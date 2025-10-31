
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../common/models/response.mode.dart';
import '../config/constants/enum/session_status.dart';
import '../storage/preference_keys.dart';
import '../storage/secure_storage.dart';
import '../utils/logger.dart';
import 'base_network.dart';
import 'base_network_status.dart';

class ApiConnection {

  // Step 1: Add this stream to broadcast session changes
  final _sessionController = StreamController<SessionStatus>.broadcast();
  Stream<SessionStatus> get sessionStream => _sessionController.stream;

  final securePref = SecurePreference();

  Future<String?> _getAccessToken() async {
    return await securePref.getString(Keys.accessToken);
  }

  Future<String?> _getRefreshToken() async {
    return await securePref.getString(Keys.refreshToken);
  }


  /// 🔄 Refresh the token
  /*
  Future<bool> _refreshToken() async {
    final refreshToken = await _getRefreshToken();
    if (refreshToken == null) return false;

    final response = await http.post(
      Uri.parse(BaseNetwork.refreshTokenURL),
      headers: BaseNetwork.getHeaderForLogin(),
      body: json.encode({"refresh": refreshToken}),
    );

    debugLog(response.body,name: "Token checking");
    if (response.statusCode == 200) {
      debugLog("New Access Key generated",name: "Token checking");
      final data = json.decode(response.body);
      await securePref.setString(Keys.accessToken, data['access']);
      if (data['refresh'] != null) {
        await securePref.setString(Keys.refreshToken, data['refresh']);
      }
      return true;
    }
    return false;
  }

   */
  Future<bool> _refreshToken() async {
    final refreshToken = await _getRefreshToken();
    if (refreshToken == null) return false;

    try {
      // Prepare multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(BaseNetwork.refreshTokenURL),
      );

      // Add headers
      request.headers.addAll(BaseNetwork.getHeaderForLogin());

      // Add form-data field
      request.fields['refresh'] = refreshToken;

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugLog(response.body, name: "Token Refresh");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Save new tokens
        if (data['access'] != null) {
          await securePref.setString(Keys.accessToken, data['access']);
          debugLog("✅ New Access Token generated", name: "Token Refresh");
        }

        if (data['refresh'] != null) {
          await securePref.setString(Keys.refreshToken, data['refresh']);
        }
        return true;
      } else {
        debugLog("❌ Refresh token failed with ${response.statusCode}", name: "Token Refresh");
      }
    } catch (e, st) {
      debugLog("❌ Exception while refreshing token: $e", name: "Token Refresh");
      debugLog(st.toString(), name: "Stacktrace");
    }

    return false;
  }


  ///  Centralized request handler
  /*
  Future<ApiResult> _handleRequest<T>(
      Future<http.Response> Function(String? token) requestFn,
      T Function(String) parser,
      ) async {
    try {
      String? token = await _getAccessToken();
      http.Response response = await requestFn(token);
      debugLog(response.body,name: "Api Response");
      if (response.statusCode == ApiStatusCode.success ||
          response.statusCode == ApiStatusCode.created) {
        return ApiResult<T>(
          status: ApiStatus.success,
          response: parser(response.body),
        );
      } else if (response.statusCode == ApiStatusCode.noContent ||
          response.statusCode == ApiStatusCode.resetContent) {
        return ApiResult<ResponseModel>(
          status: ApiStatus.resetContent,
          response: ResponseModel(
            status: "success",
            message: "No content / reset content response",
            data: null,
          ),
        );
      } else if (response.statusCode == ApiStatusCode.unAuthorized) {
        // 🔄 Try to refresh
        final refreshed = await _refreshToken();
        if (refreshed) {
          final newToken = await _getAccessToken();
          final retryResponse = await requestFn(newToken);

          if (retryResponse.statusCode == ApiStatusCode.success ||
              retryResponse.statusCode == ApiStatusCode.created) {
            return ApiResult<T>(
              status: ApiStatus.success,
              response: parser(retryResponse.body),
            );
          } else {
            return ApiResult<ResponseModel>(
              status: ApiStatus.badRequest,
              response: responseModelFromJson(retryResponse.body)!,
            );
          }
        } else {
          return ApiResult<ResponseModel>(
            status: ApiStatus.refreshTokenExpired, // 👈 new status
            response: ResponseModel(
              message: "Session expired. Please login again.",
              status: "unauthorized",
            ),
          );
        }
      } else {
        return ApiResult<ResponseModel>(
          status: ApiStatus.badRequest,
          response: responseModelFromJson(response.body)!,
        );
      }
    } on SocketException {
      return ApiResult<ResponseModel>(
        status: ApiStatus.failed,
        response: ResponseModel(message: BaseNetwork.FailedMessage),
      );
    } catch (e, stackTrace) {
      debugLog(e.toString(), stackTrace: stackTrace);
      return ApiResult<ResponseModel>(
        status: ApiStatus.failed,
        response: ResponseModel(
          message: "Something went wrong! ${e.toString()}",
          status: '',
        ),
      );
    }
  }

   */
  Future<ApiResult> _handleRequest<T>(
      Future<http.Response> Function(String? token) requestFn,
      T Function(String) parser,
      ) async {
    try {
      String? token = await _getAccessToken();
      http.Response response = await requestFn(token);

      debugLog(response.body, name: "Api Response");

      if (response.statusCode == ApiStatusCode.success ||
          response.statusCode == ApiStatusCode.created) {
        _sessionController.add(SessionStatus.active); // ✅ NEW
        return ApiResult<T>(
          status: ApiStatus.success,
          response: parser(response.body),
        );
      } else if (response.statusCode == ApiStatusCode.noContent ||
          response.statusCode == ApiStatusCode.resetContent) {
        _sessionController.add(SessionStatus.active); // ✅ NEW
        return ApiResult<ResponseModel>(
          status: ApiStatus.resetContent,
          response: ResponseModel(
            status: "success",
            message: "No content / reset content response",
            data: null,
          ),
        );
      }

      // 🟡 Handle unauthorized response
      if (response.statusCode == ApiStatusCode.unAuthorized) {
        final refreshed = await _refreshToken();

        if (refreshed) {
          _sessionController.add(SessionStatus.refreshed); // ✅ NEW
          final newToken = await _getAccessToken();
          final retryResponse = await requestFn(newToken);

          if (retryResponse.statusCode == ApiStatusCode.success ||
              retryResponse.statusCode == ApiStatusCode.created) {
            return ApiResult<T>(
              status: ApiStatus.success,
              response: parser(retryResponse.body),
            );
          } else {
            return ApiResult<ResponseModel>(
              status: ApiStatus.badRequest,
              response: responseModelFromJson(retryResponse.body)!,
            );
          }
        } else {
          // 🔴 Refresh token failed -> expired
          _sessionController.add(SessionStatus.expired); // ✅ NEW
          return ApiResult<ResponseModel>(
            status: ApiStatus.refreshTokenExpired,
            response: ResponseModel(
              message: "Session expired. Please login again.",
              status: "unauthorized",
            ),
          );
        }
      }

      // Other error cases
      _sessionController.add(SessionStatus.active);
      return ApiResult<ResponseModel>(
        status: ApiStatus.badRequest,
        response: responseModelFromJson(response.body)!,
      );
    } on SocketException {
      _sessionController.add(SessionStatus.active);
      return ApiResult<ResponseModel>(
        status: ApiStatus.failed,
        response: ResponseModel(message: BaseNetwork.FailedMessage),
      );
    } catch (e, stackTrace) {
      debugLog(e.toString(), stackTrace: stackTrace);
      _sessionController.add(SessionStatus.active);
      return ApiResult<ResponseModel>(
        status: ApiStatus.failed,
        response: ResponseModel(
          message: "Something went wrong! ${e.toString()}",
          status: '',
        ),
      );
    }
  }


  /// 📌 POST / PUT requests
  Future<ApiResult> apiConnection<T>(
      String url,
      Map<String, String> header,
      String method,
      T Function(String) parser, {
        dynamic body,
      }) async {
    debugLog(url.toString(),name: "Request header");
    return _handleRequest<T>(
          (token) async {
        if (token != null) header['Authorization'] = 'Bearer $token';
        return await http.post(
          Uri.parse(url),
          headers: header,
          body: json.encode(body),
        );

      },
      parser,
    );
  }

  /// 📌 GET requests
  Future<ApiResult> getApiConnection<T>(
      String url,
      Map<String, String> header,
      T Function(String) parser,
      ) async {
    debugLog(url.toString(),name: "Request header");
    return _handleRequest<T>(
          (token) async {
        if (token != null) header['Authorization'] = 'Bearer $token';
        return await http.get(Uri.parse(url), headers: header);
      },
      parser,
    );
  }

  /// 📌 Multipart requests
  Future<ApiResult> apiConnectionMultipart<T>(
      String url,
      Map<String, String> header,
      String method,
      T Function(String) parser, {
        Map<String, dynamic> fields = const {},
        String fileKey = 'images',
        List<File> files = const [],
        bool isLogIn = true,
      }) async {
    return _handleRequest<T>(
          (token) async {
        if (isLogIn && token != null) {
          header['Authorization'] = 'Bearer $token';
        }

        final request = http.MultipartRequest(method, Uri.parse(url));

        debugLog(request.url.toString(),name: "Request header");
        request.headers.addAll(header);
        fields.forEach((key, value) => request.fields[key] = value.toString());

        for (var file in files) {
          final multipartFile = await http.MultipartFile.fromPath(
            fileKey,
            file.path,
            filename: 'plantation${file.path.split('/').last}',
          );
          request.files.add(multipartFile);
        }

        final streamedResponse = await request.send();
        debugLog(request.fields.toString(),name: "All fields");
        return await http.Response.fromStream(streamedResponse);
      },
      parser,
    );

  }

  String generateUrl({
    String? baseUrl,
    String? searchQuery,
    int? page,
    int? pageSize,
    String? filterBy,
    String? status,
    String? projectId,
    String? project,
    String? serviceName,
    String? projectAreaId,
    String? plantationId,
    String? plantation,
    String? areaId,
    String? orderId,
    String? vendorId,
    String? type,
    String ? createdBy,
    String ? maintenanceStatus,
    String ? requireMaintenance,
    String ? requireMonitoring,
    String? group,
    String? category,
    String? orderBy,
  }) {
    final queryParameters = <String, String>{};

    if (searchQuery != null) queryParameters['search'] = searchQuery;
    if (page != null) queryParameters['page'] = page.toString();
    if (pageSize != null) queryParameters['page_size'] = pageSize.toString();
    if (filterBy != null) queryParameters['category'] = filterBy;
    if (status != null) queryParameters['status'] = status;
    if (projectId!=null) queryParameters['project_id'] = projectId;
    if (project!=null) queryParameters['project'] = project;
    if (serviceName != null) queryParameters['service_type'] = serviceName;
    if (projectAreaId != null) queryParameters['project_area_id'] = projectAreaId;
    if (plantationId != null) queryParameters['plantationId'] = plantationId;
    if (plantation != null) queryParameters['plantation'] = plantation;
    if (areaId != null) queryParameters['area'] = areaId;
    if (orderId != null) queryParameters['order_id'] = orderId;
    if (vendorId != null) queryParameters['vendor'] = vendorId;
    if (type != null) queryParameters['type'] = type;
    if (createdBy != null) queryParameters['created_by'] = createdBy;
    if (maintenanceStatus != null) queryParameters['maintenance_status'] = maintenanceStatus;
    if (group != null) queryParameters['group'] = group;
    if (requireMaintenance != null) queryParameters['require_maintenance'] = requireMaintenance;
    if (requireMonitoring != null) queryParameters['require_monitoring'] = requireMonitoring;
    if (category != null) queryParameters['category'] = Uri.encodeComponent(category);
    if (orderBy != null) queryParameters['order_by'] = orderBy;

    final baseParams = queryParameters.entries.map((e) => '${e.key}=${e.value}').join('&');
    final fullParams = [baseParams].where((param) => param.isNotEmpty).join('&');

    final uri = Uri.parse(baseUrl ?? '').replace(query: fullParams);
    return uri.toString();
  }

  void dispose() {
    _sessionController.close();
  }

}


