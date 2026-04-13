
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../../common/models/response.mode.dart';
import '../../common/models/token_refresh_token.dart';
import '../config/constants/enum/session_status.dart';
import '../storage/preference_keys.dart';
import '../storage/secure_storage.dart';
import '../utils/logger.dart';
import 'base_network.dart';
import 'base_network_status.dart';
/*
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

 */


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
*/

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
/*
/// Session status enumeration
enum SessionStatus {
  active,
  refreshed,
  expired,
  loggedOut,
}

/// API status enumeration
enum ApiStatus {
  success,
  created,
  resetContent,
  badRequest,
  unAuthorized,
  refreshTokenExpired,
  failed,
}

 */
/*
class ApiConnection {
  // Singleton pattern (optional, but recommended)
  static final ApiConnection _instance = ApiConnection._internal();
  factory ApiConnection() => _instance;
  ApiConnection._internal();

  // Session stream controller
  final _sessionController = StreamController<SessionStatus>.broadcast();
  Stream<SessionStatus> get sessionStream => _sessionController.stream;

  final securePref = SecurePreference();

  // Token refresh lock to prevent multiple simultaneous refresh attempts
  bool _isRefreshing = false;
  final List<Completer<bool>> _refreshCompleters = [];

  /// Get access token from secure storage
  Future<String?> _getAccessToken() async {
    return await securePref.getString(Keys.accessToken);
  }

  /// Get refresh token from secure storage
  Future<String?> _getRefreshToken() async {
    return await securePref.getString(Keys.refreshToken);
  }

  /*
  /// 🔄 Refresh the token
  Future<bool> _refreshToken() async {
    // If already refreshing, wait for the current refresh to complete
    if (_isRefreshing) {
      final completer = Completer<bool>();
      _refreshCompleters.add(completer);
      return completer.future;
    }

    _isRefreshing = true;
    debugLog("🔄 Starting token refresh...", name: "Token Refresh");

    final refreshToken = await _getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      debugLog("❌ No refresh token available", name: "Token Refresh");
      _isRefreshing = false;
      _completeAllRefreshRequests(false);
      return false;
    }

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

      debugLog("📤 Sending refresh token request...", name: "Token Refresh");

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugLog("📥 Response: ${response.statusCode}", name: "Token Refresh");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);

        // Save new access token
        if (data['access'] != null && data['access'].toString().isNotEmpty) {
          await securePref.setString(Keys.accessToken, data['access']);
          debugLog("✅ New Access Token saved", name: "Token Refresh");
        } else {
          debugLog("⚠️ No access token in response", name: "Token Refresh");
          _isRefreshing = false;
          _completeAllRefreshRequests(false);
          return false;
        }

        // Save new refresh token if provided
        if (data['refresh'] != null && data['refresh'].toString().isNotEmpty) {
          await securePref.setString(Keys.refreshToken, data['refresh']);
          debugLog("✅ New Refresh Token saved", name: "Token Refresh");
        }

        _sessionController.add(SessionStatus.refreshed);
        _isRefreshing = false;
        _completeAllRefreshRequests(true);
        return true;
      } else {
        debugLog("❌ Refresh failed with status: ${response.statusCode}", name: "Token Refresh");
        debugLog("Response body: ${response.body}", name: "Token Refresh");
      }
    } catch (e, st) {
      debugLog("❌ Exception during token refresh: $e", name: "Token Refresh");
      debugLog(st.toString(), name: "Token Refresh Stacktrace");
    }

    _isRefreshing = false;
    _completeAllRefreshRequests(false);
    return false;
  }

   */
  /// 🔄 Refresh the access token using refresh token
  Future<bool> _refreshToken() async {
    // Prevent multiple simultaneous refresh attempts
    if (_isRefreshing) {
      debugLog("⏳ Token refresh already in progress, queuing request...", name: "Token Refresh");
      final completer = Completer<bool>();
      _refreshCompleters.add(completer);
      return completer.future;
    }

    _isRefreshing = true;
    debugLog("🔄 Starting token refresh...", name: "Token Refresh");

    // Get stored refresh token
    final refreshToken = await _getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      debugLog("❌ No refresh token available in storage", name: "Token Refresh");
      _isRefreshing = false;
      _completeAllRefreshRequests(false);
      return false;
    }

    try {
      // Prepare multipart request (as per your API requirements)
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(BaseNetwork.refreshTokenURL),
      );

      // Add headers for form-urlencoded
      request.headers.addAll(BaseNetwork.getHeaderForLogin());

      // Add refresh token as form field
      request.fields['refresh'] = refreshToken;

      debugLog("📤 Sending refresh token request to: ${BaseNetwork.refreshTokenURL}", name: "Token Refresh");
      debugLog("📤 Using refresh token: ${refreshToken.substring(0, 20)}...", name: "Token Refresh");

      // Send request with timeout
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Token refresh request timed out');
        },
      );

      final response = await http.Response.fromStream(streamedResponse);

      debugLog("📥 Response status: ${response.statusCode}", name: "Token Refresh");
      debugLog("📥 Response body: ${response.body}", name: "Token Refresh");

      // ✅ Handle successful response
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          // Parse response using model
          final refreshResponse = TokenRefreshResponse.fromJson(
            json.decode(response.body),
          );

          debugLog("📦 Parsed response - Status: ${refreshResponse.status}", name: "Token Refresh");
          debugLog("📦 Message: ${refreshResponse.message}", name: "Token Refresh");

          // Validate access token
          if (refreshResponse.data.access.isEmpty) {
            debugLog("❌ Empty access token in response", name: "Token Refresh");
            _isRefreshing = false;
            _completeAllRefreshRequests(false);
            return false;
          }

          // ✅ Save new access token
          await securePref.setString(Keys.accessToken, refreshResponse.data.access);
          debugLog("✅ New Access Token saved (length: ${refreshResponse.data.access.length})", name: "Token Refresh");

          // Save access token expiry
          if (refreshResponse.data.accessTokenExpires.isNotEmpty) {
            await securePref.setString(Keys.accessTokenExpires, refreshResponse.data.accessTokenExpires);
            debugLog("✅ Access token expiry: ${refreshResponse.data.accessTokenExpires}", name: "Token Refresh");
          }

          // ✅ Save new refresh token (if provided)
          if (refreshResponse.data.refresh.isNotEmpty) {
            await securePref.setString(Keys.refreshToken, refreshResponse.data.refresh);
            debugLog("✅ New Refresh Token saved (length: ${refreshResponse.data.refresh.length})", name: "Token Refresh");

            // Save refresh token expiry
            if (refreshResponse.data.refreshTokenExpires.isNotEmpty) {
              await securePref.setString(Keys.refreshTokenExpires, refreshResponse.data.refreshTokenExpires);
              debugLog("✅ Refresh token expiry: ${refreshResponse.data.refreshTokenExpires}", name: "Token Refresh");
            }
          } else {
            debugLog("⚠️ No new refresh token provided, keeping existing one", name: "Token Refresh");
          }

          // Notify listeners about successful refresh
          _sessionController.add(SessionStatus.refreshed);

          debugLog("🎉 Token refresh completed successfully!", name: "Token Refresh");

          // Complete all waiting requests with success
          _isRefreshing = false;
          _completeAllRefreshRequests(true);
          return true;

        } catch (parseError, stackTrace) {
          debugLog("❌ Error parsing refresh token response: $parseError", name: "Token Refresh");
          debugLog("Stack trace: $stackTrace", name: "Token Refresh");
          debugLog("Raw response body: ${response.body}", name: "Token Refresh");

          _isRefreshing = false;
          _completeAllRefreshRequests(false);
          return false;
        }
      }

      // 🔴 Handle 401 - Refresh token expired
      else if (response.statusCode == 401) {
        debugLog("❌ Refresh token expired or invalid (401)", name: "Token Refresh");

        try {
          final errorResponse = json.decode(response.body);
          debugLog("Error details: ${errorResponse['message'] ?? errorResponse}", name: "Token Refresh");
        } catch (_) {
          debugLog("Error body: ${response.body}", name: "Token Refresh");
        }

        _isRefreshing = false;
        _completeAllRefreshRequests(false);
        return false;
      }

      // 🔴 Handle other error status codes
      else {
        debugLog("❌ Token refresh failed with status: ${response.statusCode}", name: "Token Refresh");
        debugLog("Response body: ${response.body}", name: "Token Refresh");

        _isRefreshing = false;
        _completeAllRefreshRequests(false);
        return false;
      }

    } on TimeoutException catch (e) {
      debugLog("❌ Token refresh timeout: $e", name: "Token Refresh");
      _isRefreshing = false;
      _completeAllRefreshRequests(false);
      return false;

    } on SocketException catch (e) {
      debugLog("❌ Network error during token refresh: $e", name: "Token Refresh");
      _isRefreshing = false;
      _completeAllRefreshRequests(false);
      return false;

    } catch (e, stackTrace) {
      debugLog("❌ Unexpected exception during token refresh: $e", name: "Token Refresh");
      debugLog("Stack trace: $stackTrace", name: "Token Refresh");
      _isRefreshing = false;
      _completeAllRefreshRequests(false);
      return false;
    }
  }

  /// Complete all waiting refresh requests
  void _completeAllRefreshRequests(bool success) {
    for (var completer in _refreshCompleters) {
      if (!completer.isCompleted) {
        completer.complete(success);
      }
    }
    _refreshCompleters.clear();
  }

  /// 🔧 Centralized request handler
  Future<ApiResult> _handleRequest<T>(
      Future<http.Response> Function(String? token) requestFn,
      T Function(String) parser,
      ) async {
    try {
      // Get current access token
      String? token = await _getAccessToken();

      debugLog("📤 Making API request with token: ${token != null ? 'Present' : 'Missing'}", name: "API Request");

      // Make initial request
      http.Response response = await requestFn(token);

      debugLog("📥 Response status: ${response.statusCode}", name: "API Response");
      debugLog("📥 Response body: ${response.body}", name: "API Response");

      // ✅ Success responses
      if (response.statusCode == ApiStatusCode.success ||
          response.statusCode == ApiStatusCode.created) {
        _sessionController.add(SessionStatus.active);
        return ApiResult<T>(
          status: ApiStatus.success,
          response: parser(response.body),
        );
      }

      // ✅ No content responses
      if (response.statusCode == ApiStatusCode.noContent ||
          response.statusCode == ApiStatusCode.resetContent) {
        _sessionController.add(SessionStatus.active);
        return ApiResult<ResponseModel>(
          status: ApiStatus.resetContent,
          response: ResponseModel(
            status: "success",
            message: "No content / reset content response",
            data: null,
          ),
        );
      }

      // 🔴 Handle unauthorized (401) - attempt token refresh
      if (response.statusCode == ApiStatusCode.unAuthorized) {
        debugLog("⚠️ Unauthorized (401) - Attempting token refresh...", name: "API Response");

        final refreshed = await _refreshToken();

        if (refreshed) {
          debugLog("✅ Token refreshed successfully, retrying request...", name: "API Response");

          // Retry request with new token
          final newToken = await _getAccessToken();
          final retryResponse = await requestFn(newToken);

          debugLog("📥 Retry response status: ${retryResponse.statusCode}", name: "API Response");

          if (retryResponse.statusCode == ApiStatusCode.success ||
              retryResponse.statusCode == ApiStatusCode.created) {
            _sessionController.add(SessionStatus.active);
            return ApiResult<T>(
              status: ApiStatus.success,
              response: parser(retryResponse.body),
            );
          } else {
            // Retry failed with error
            return ApiResult<ResponseModel>(
              status: ApiStatus.badRequest,
              response: responseModelFromJson(retryResponse.body) ??
                  ResponseModel(
                    message: "Request failed after token refresh",
                    status: "error",
                  ),
            );
          }
        } else {
          // 🔴 Refresh token failed or expired
          debugLog("❌ Token refresh failed - Session expired", name: "API Response");
          _sessionController.add(SessionStatus.expired);

          return ApiResult<ResponseModel>(
            status: ApiStatus.refreshTokenExpired,
            response: ResponseModel(
              message: "Session expired. Please login again.",
              status: "unauthorized",
            ),
          );
        }
      }

      // 🟡 Other error responses
      _sessionController.add(SessionStatus.active);
      return ApiResult<ResponseModel>(
        status: ApiStatus.badRequest,
        response: responseModelFromJson(response.body) ??
            ResponseModel(
              message: "Request failed with status ${response.statusCode}",
              status: "error",
            ),
      );
    } on SocketException catch (e) {
      debugLog("❌ Network error: $e", name: "API Request");
      _sessionController.add(SessionStatus.active);
      return ApiResult<ResponseModel>(
        status: ApiStatus.failed,
        response: ResponseModel(
          message: BaseNetwork.FailedMessage ?? "No internet connection",
          status: "network_error",
        ),
      );
    } on TimeoutException catch (e) {
      debugLog("❌ Request timeout: $e", name: "API Request");
      _sessionController.add(SessionStatus.active);
      return ApiResult<ResponseModel>(
        status: ApiStatus.failed,
        response: ResponseModel(
          message: "Request timeout. Please try again.",
          status: "timeout",
        ),
      );
    } catch (e, stackTrace) {
      debugLog("❌ Unexpected error: $e", name: "API Request");
      debugLog(stackTrace.toString(), name: "API Request Stacktrace");
      _sessionController.add(SessionStatus.active);
      return ApiResult<ResponseModel>(
        status: ApiStatus.failed,
        response: ResponseModel(
          message: "Something went wrong! ${e.toString()}",
          status: 'error',
        ),
      );
    }
  }

  /// 📌 POST request
  Future<ApiResult> apiConnection<T>(
      String url,
      Map<String, String> header,
      String method,
      T Function(String) parser, {
        dynamic body,
      }) async {
    debugLog("POST: $url", name: "API Request");
    debugLog("Body: ${json.encode(body)}", name: "API Request");

    return _handleRequest<T>(
          (token) async {
        final headers = Map<String, String>.from(header);
        if (token != null && token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
        }

        return await http
            .post(
          Uri.parse(url),
          headers: headers,
          body: json.encode(body),
        )
            .timeout(const Duration(seconds: 30));
      },
      parser,
    );
  }

  /// 📌 GET request
  Future<ApiResult> getApiConnection<T>(
      String url,
      Map<String, String> header,
      T Function(String) parser,{
        bool isLogIn = false,
      }

      ) async {
    debugLog("GET: $url", name: "API Request");

    return _handleRequest<T>(
          (token) async {
        final headers = Map<String, String>.from(header);
        if (!isLogIn &&token != null && token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
        }

        return await http
            .get(
          Uri.parse(url),
          headers: headers,
        )
            .timeout(const Duration(seconds: 30));
      },
      parser,
    );
  }

  /// 📌 PUT request
  Future<ApiResult> putApiConnection<T>(
      String url,
      Map<String, String> header,
      T Function(String) parser, {
        dynamic body,
      }) async {
    debugLog("PUT: $url", name: "API Request");
    debugLog("Body: ${json.encode(body)}", name: "API Request");

    return _handleRequest<T>(
          (token) async {
        final headers = Map<String, String>.from(header);
        if (token != null && token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
        }

        return await http
            .put(
          Uri.parse(url),
          headers: headers,
          body: json.encode(body),
        )
            .timeout(const Duration(seconds: 30));
      },
      parser,
    );
  }

  /// 📌 DELETE request
  Future<ApiResult> deleteApiConnection<T>(
      String url,
      Map<String, String> header,
      T Function(String) parser,
      ) async {
    debugLog("DELETE: $url", name: "API Request");

    return _handleRequest<T>(
          (token) async {
        final headers = Map<String, String>.from(header);
        if (token != null && token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
        }

        return await http
            .delete(
          Uri.parse(url),
          headers: headers,
        )
            .timeout(const Duration(seconds: 30));
      },
      parser,
    );
  }

  /// 📌 Multipart request (POST/PUT with file uploads)
  Future<ApiResult> apiConnectionMultipart<T>(
      String url,
      Map<String, String> header,
      String method,
      T Function(String) parser, {
        Map<String, dynamic> fields = const {},
        String fileKey = 'images',
        List<File> files = const [],
        bool isLogIn = false,
      }) async {
    debugLog("$method (Multipart): $url", name: "API Request");
    debugLog("Fields: $fields", name: "API Request");
    debugLog("Files count: ${files.length}", name: "API Request");

    return _handleRequest<T>(
          (token) async {
        final headers = Map<String, String>.from(header);

        // Only add token if not a login request
        if (!isLogIn && token != null && token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
        }

        final request = http.MultipartRequest(method, Uri.parse(url));
        request.headers.addAll(headers);

        // Add text fields
        fields.forEach((key, value) {
          request.fields[key] = value.toString();
        });

        // Add files
        for (var file in files) {
          final multipartFile = await http.MultipartFile.fromPath(
            fileKey,
            file.path,
            filename: 'upload_${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}',
          );
          request.files.add(multipartFile);
        }

        final streamedResponse = await request.send().timeout(const Duration(seconds: 60));
        return await http.Response.fromStream(streamedResponse);
      },
      parser,
    );
  }

  /// 🔗 Generate URL with query parameters
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
    String? createdBy,
    String? maintenanceStatus,
    String? requireMaintenance,
    String? requireMonitoring,
    String? group,
    String? category,
    String? orderBy,
  }) {
    final queryParameters = <String, String>{};

    if (searchQuery != null && searchQuery.isNotEmpty) {
      queryParameters['search'] = searchQuery;
    }
    if (page != null) queryParameters['page'] = page.toString();
    if (pageSize != null) queryParameters['page_size'] = pageSize.toString();
    if (filterBy != null && filterBy.isNotEmpty) {
      queryParameters['category'] = filterBy;
    }
    if (status != null && status.isNotEmpty) {
      queryParameters['status'] = status;
    }
    if (projectId != null && projectId.isNotEmpty) {
      queryParameters['project_id'] = projectId;
    }
    if (project != null && project.isNotEmpty) {
      queryParameters['project'] = project;
    }
    if (serviceName != null && serviceName.isNotEmpty) {
      queryParameters['service_type'] = serviceName;
    }
    if (projectAreaId != null && projectAreaId.isNotEmpty) {
      queryParameters['project_area_id'] = projectAreaId;
    }
    if (plantationId != null && plantationId.isNotEmpty) {
      queryParameters['plantationId'] = plantationId;
    }
    if (plantation != null && plantation.isNotEmpty) {
      queryParameters['plantation'] = plantation;
    }
    if (areaId != null && areaId.isNotEmpty) {
      queryParameters['area'] = areaId;
    }
    if (orderId != null && orderId.isNotEmpty) {
      queryParameters['order_id'] = orderId;
    }
    if (vendorId != null && vendorId.isNotEmpty) {
      queryParameters['vendor'] = vendorId;
    }
    if (type != null && type.isNotEmpty) {
      queryParameters['type'] = type;
    }
    if (createdBy != null && createdBy.isNotEmpty) {
      queryParameters['created_by'] = createdBy;
    }
    if (maintenanceStatus != null && maintenanceStatus.isNotEmpty) {
      queryParameters['maintenance_status'] = maintenanceStatus;
    }
    if (group != null && group.isNotEmpty) {
      queryParameters['group'] = group;
    }
    if (requireMaintenance != null && requireMaintenance.isNotEmpty) {
      queryParameters['require_maintenance'] = requireMaintenance;
    }
    if (requireMonitoring != null && requireMonitoring.isNotEmpty) {
      queryParameters['require_monitoring'] = requireMonitoring;
    }
    if (category != null && category.isNotEmpty) {
      queryParameters['category'] = Uri.encodeComponent(category);
    }
    if (orderBy != null && orderBy.isNotEmpty) {
      queryParameters['order_by'] = orderBy;
    }

    if (baseUrl == null || baseUrl.isEmpty) {
      return '';
    }

    if (queryParameters.isEmpty) {
      return baseUrl;
    }

    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);
    return uri.toString();
  }

  /// 🚪 Logout - clear tokens and notify
  Future<void> logout() async {
    debugLog("🚪 Logging out...", name: "ApiConnection");
    await securePref.remove(Keys.accessToken);
    await securePref.remove(Keys.refreshToken);
    _sessionController.add(SessionStatus.loggedOut);
  }

  /// 🧹 Dispose resources
  void dispose() {
    _sessionController.close();
  }
}

 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';



class ApiConnection {
  // Singleton pattern
  static final ApiConnection _instance = ApiConnection._internal();
  factory ApiConnection() => _instance;
  ApiConnection._internal();

  // Session stream controller
  final _sessionController = StreamController<SessionStatus>.broadcast();
  Stream<SessionStatus> get sessionStream => _sessionController.stream;

  final securePref = SecurePreference();

  // Token refresh lock to prevent multiple simultaneous refresh attempts
  bool _isRefreshing = false;
  final List<Completer<bool>> _refreshCompleters = [];

  /// Get access token from secure storage
  Future<String?> _getAccessToken() async {
    return await securePref.getString(Keys.accessToken);
  }

  /// Get refresh token from secure storage
  Future<String?> _getRefreshToken() async {
    return await securePref.getString(Keys.refreshToken);
  }

  /// 🔄 Refresh the access token using refresh token
  Future<bool> _refreshToken() async {
    // Prevent multiple simultaneous refresh attempts
    if (_isRefreshing) {
      debugLog("⏳ Token refresh already in progress, queuing request...", name: "Token Refresh");
      final completer = Completer<bool>();
      _refreshCompleters.add(completer);
      return completer.future;
    }

    _isRefreshing = true;
    debugLog("🔄 Starting token refresh...", name: "Token Refresh");

    // Get stored refresh token
    final refreshToken = await _getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      debugLog("❌ No refresh token available in storage", name: "Token Refresh");
      _isRefreshing = false;
      _completeAllRefreshRequests(false);
      return false;
    }

    try {
      // Prepare multipart request (as per your API requirements)
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(BaseNetwork.refreshTokenURL),
      );

      // Add headers for form-urlencoded
      request.headers.addAll(BaseNetwork.getHeaderForLogin());

      // Add refresh token as form field
      request.fields['refresh'] = refreshToken;

      debugLog("📤 Sending refresh token request to: ${BaseNetwork.refreshTokenURL}", name: "Token Refresh");
      debugLog("📤 Using refresh token: ${refreshToken.substring(0, 20)}...", name: "Token Refresh");

      // Send request with timeout
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Token refresh request timed out');
        },
      );

      final response = await http.Response.fromStream(streamedResponse);

      debugLog("📥 Response status: ${response.statusCode}", name: "Token Refresh");
      debugLog("📥 Response body: ${response.body}", name: "Token Refresh");

      // ✅ Handle successful response
      if (ApiStatusCode.isSuccess(response.statusCode)) {
        try {
          // Parse response using model
          final refreshResponse = TokenRefreshResponse.fromJson(
            json.decode(response.body),
          );

          debugLog("📦 Parsed response - Status: ${refreshResponse.status}", name: "Token Refresh");
          debugLog("📦 Message: ${refreshResponse.message}", name: "Token Refresh");

          // Validate access token
          if (refreshResponse.data.access.isEmpty) {
            debugLog("❌ Empty access token in response", name: "Token Refresh");
            _isRefreshing = false;
            _completeAllRefreshRequests(false);
            return false;
          }

          // ✅ Save new access token
          await securePref.setString(Keys.accessToken, refreshResponse.data.access);
          debugLog("✅ New Access Token saved (length: ${refreshResponse.data.access.length})", name: "Token Refresh");

          // Save access token expiry
          if (refreshResponse.data.accessTokenExpires.isNotEmpty) {
            await securePref.setString(Keys.accessTokenExpires, refreshResponse.data.accessTokenExpires);
            debugLog("✅ Access token expiry: ${refreshResponse.data.accessTokenExpires}", name: "Token Refresh");
          }

          // ✅ Save new refresh token (if provided)
          if (refreshResponse.data.refresh.isNotEmpty) {
            await securePref.setString(Keys.refreshToken, refreshResponse.data.refresh);
            debugLog("✅ New Refresh Token saved (length: ${refreshResponse.data.refresh.length})", name: "Token Refresh");

            // Save refresh token expiry
            if (refreshResponse.data.refreshTokenExpires.isNotEmpty) {
              await securePref.setString(Keys.refreshTokenExpires, refreshResponse.data.refreshTokenExpires);
              debugLog("✅ Refresh token expiry: ${refreshResponse.data.refreshTokenExpires}", name: "Token Refresh");
            }
          } else {
            debugLog("⚠️ No new refresh token provided, keeping existing one", name: "Token Refresh");
          }

          // Notify listeners about successful refresh
          _sessionController.add(SessionStatus.refreshed);

          debugLog("🎉 Token refresh completed successfully!", name: "Token Refresh");

          // Complete all waiting requests with success
          _isRefreshing = false;
          _completeAllRefreshRequests(true);
          return true;

        } catch (parseError, stackTrace) {
          debugLog("❌ Error parsing refresh token response: $parseError", name: "Token Refresh");
          debugLog("Stack trace: $stackTrace", name: "Token Refresh");
          debugLog("Raw response body: ${response.body}", name: "Token Refresh");

          _isRefreshing = false;
          _completeAllRefreshRequests(false);
          return false;
        }
      }

      // 🔴 Handle 401 - Refresh token expired
      else if (response.statusCode == ApiStatusCode.unAuthorized) {
        debugLog("❌ Refresh token expired or invalid (401)", name: "Token Refresh");

        try {
          final errorResponse = json.decode(response.body);
          debugLog("Error details: ${errorResponse['message'] ?? errorResponse}", name: "Token Refresh");
        } catch (_) {
          debugLog("Error body: ${response.body}", name: "Token Refresh");
        }

        _isRefreshing = false;
        _completeAllRefreshRequests(false);
        return false;
      }

      // 🔴 Handle other error status codes
      else {
        debugLog("❌ Token refresh failed with status: ${response.statusCode}", name: "Token Refresh");
        debugLog("Response body: ${response.body}", name: "Token Refresh");

        _isRefreshing = false;
        _completeAllRefreshRequests(false);
        return false;
      }

    } on TimeoutException catch (e) {
      debugLog("❌ Token refresh timeout: $e", name: "Token Refresh");
      _isRefreshing = false;
      _completeAllRefreshRequests(false);
      return false;

    } on SocketException catch (e) {
      debugLog("❌ Network error during token refresh: $e", name: "Token Refresh");
      _isRefreshing = false;
      _completeAllRefreshRequests(false);
      return false;

    } catch (e, stackTrace) {
      debugLog("❌ Unexpected exception during token refresh: $e", name: "Token Refresh");
      debugLog("Stack trace: $stackTrace", name: "Token Refresh");
      _isRefreshing = false;
      _completeAllRefreshRequests(false);
      return false;
    }
  }

  /// Complete all waiting refresh requests
  void _completeAllRefreshRequests(bool success) {
    for (var completer in _refreshCompleters) {
      if (!completer.isCompleted) {
        completer.complete(success);
      }
    }
    _refreshCompleters.clear();
  }

  /// 🔧 Centralized request handler
  Future<ApiResult> _handleRequest<T>(
      Future<http.Response> Function(String? token) requestFn,
      T Function(String) parser,
      ) async {
    try {
      // Get current access token
      String? token = await _getAccessToken();

      debugLog("📤 Making API request with token: ${token != null ? 'Present' : 'Missing'}", name: "API Request");

      // Make initial request
      http.Response response = await requestFn(token);

      debugLog("📥 Response status: ${response.statusCode}", name: "API Response");
      debugLog("📥 Response body: ${response.body}", name: "API Response");

      // ✅ Handle successful responses (2xx)
      if (ApiStatusCode.isSuccess(response.statusCode)) {
        _sessionController.add(SessionStatus.active);

        // Handle no-content responses
        if (response.statusCode == ApiStatusCode.noContent ||
            response.statusCode == ApiStatusCode.resetContent) {
          return ApiResult<ResponseModel>(
            status: ApiStatusCode.fromStatusCode(response.statusCode),
            response: ResponseModel(
              status: "success",
              message: "Operation completed successfully",
              // data: null,
            ),
          );
        }

        // Handle normal success responses with data
        return ApiResult<T>(
          status: ApiStatusCode.fromStatusCode(response.statusCode),
          response: parser(response.body),
        );
      }

      // 🔴 Handle unauthorized (401) - attempt token refresh
      if (response.statusCode == ApiStatusCode.unAuthorized) {
        debugLog("⚠️ Unauthorized (401) - Attempting token refresh...", name: "API Response");

        final refreshed = await _refreshToken();

        if (refreshed) {
          debugLog("✅ Token refreshed successfully, retrying original request...", name: "API Response");

          // Retry request with new token
          final newToken = await _getAccessToken();
          final retryResponse = await requestFn(newToken);

          debugLog("📥 Retry response status: ${retryResponse.statusCode}", name: "API Response");

          // Handle retry response
          if (ApiStatusCode.isSuccess(retryResponse.statusCode)) {
            _sessionController.add(SessionStatus.active);

            // Handle no-content retry responses
            if (retryResponse.statusCode == ApiStatusCode.noContent ||
                retryResponse.statusCode == ApiStatusCode.resetContent) {
              return ApiResult<ResponseModel>(
                status: ApiStatusCode.fromStatusCode(retryResponse.statusCode),
                response: ResponseModel(
                  status: "success",
                  message: "Operation completed successfully",
                  // data: null,
                ),
              );
            }

            // Handle normal success retry
            return ApiResult<T>(
              status: ApiStatusCode.fromStatusCode(retryResponse.statusCode),
              response: parser(retryResponse.body),
            );
          } else {
            // Retry failed with error
            final errorStatus = ApiStatusCode.fromStatusCode(retryResponse.statusCode);
            return ApiResult<ResponseModel>(
              status: errorStatus,
              response: responseModelFromJson(retryResponse.body) ??
                  ResponseModel(
                    message: "Request failed after token refresh (${retryResponse.statusCode})",
                    status: "error",
                  ),
            );
          }
        } else {
          // 🔴 Refresh token failed or expired
          debugLog("❌ Token refresh failed - Session expired", name: "API Response");
          _sessionController.add(SessionStatus.expired);

          return ApiResult<ResponseModel>(
            status: ApiStatus.refreshTokenExpired,
            response: ResponseModel(
              message: "Session expired. Please login again.",
              status: "unauthorized",
            ),
          );
        }
      }

      // 🔴 Handle forbidden (403)
      if (response.statusCode == ApiStatusCode.forbidden) {
        debugLog("⚠️ Forbidden (403) - Access denied", name: "API Response");
        _sessionController.add(SessionStatus.active);
        return ApiResult<ResponseModel>(
          status: ApiStatus.forbidden,
          response: responseModelFromJson(response.body) ??
              ResponseModel(
                message: "Access denied. You don't have permission.",
                status: "forbidden",
              ),
        );
      }

      // 🔴 Handle not found (404)
      if (response.statusCode == ApiStatusCode.notFound) {
        debugLog("⚠️ Not Found (404)", name: "API Response");
        _sessionController.add(SessionStatus.active);
        return ApiResult<ResponseModel>(
          status: ApiStatus.notFound,
          response: responseModelFromJson(response.body) ??
              ResponseModel(
                message: "Resource not found.",
                status: "not_found",
              ),
        );
      }

      // 🔴 Handle too many requests (429)
      if (response.statusCode == ApiStatusCode.tooManyRequests) {
        debugLog("⚠️ Too Many Requests (429)", name: "API Response");
        _sessionController.add(SessionStatus.active);
        return ApiResult<ResponseModel>(
          status: ApiStatus.tooManyRequests,
          response: responseModelFromJson(response.body) ??
              ResponseModel(
                message: "Too many requests. Please try again later.",
                status: "rate_limit",
              ),
        );
      }

      // 🔴 Handle server errors (5xx)
      if (ApiStatusCode.isServerError(response.statusCode)) {
        debugLog("⚠️ Server Error (${response.statusCode})", name: "API Response");
        _sessionController.add(SessionStatus.active);
        final errorStatus = ApiStatusCode.fromStatusCode(response.statusCode);
        return ApiResult<ResponseModel>(
          status: errorStatus,
          response: responseModelFromJson(response.body) ??
              ResponseModel(
                message: _getServerErrorMessage(response.statusCode),
                status: "server_error",
              ),
        );
      }

      // 🟡 Handle other client errors (4xx)
      if (ApiStatusCode.isClientError(response.statusCode)) {
        debugLog("⚠️ Client Error (${response.statusCode})", name: "API Response");
        _sessionController.add(SessionStatus.active);
        final errorStatus = ApiStatusCode.fromStatusCode(response.statusCode);
        return ApiResult<ResponseModel>(
          status: errorStatus,
          response: responseModelFromJson(response.body) ??
              ResponseModel(
                message: "Request failed with status ${response.statusCode}",
                status: "client_error",
              ),
        );
      }

      // 🟡 Handle any other unexpected status codes
      debugLog("⚠️ Unexpected status code: ${response.statusCode}", name: "API Response");
      _sessionController.add(SessionStatus.active);
      return ApiResult<ResponseModel>(
        status: ApiStatus.failed,
        response: responseModelFromJson(response.body) ??
            ResponseModel(
              message: "Request failed with status ${response.statusCode}",
              status: "error",
            ),
      );

    } on SocketException catch (e) {
      debugLog("❌ Network error: $e", name: "API Request");
      _sessionController.add(SessionStatus.active);
      return ApiResult<ResponseModel>(
        status: ApiStatus.networkError, // ✅ Updated to use specific status
        response: ResponseModel(
          message: BaseNetwork.FailedMessage ?? "No internet connection",
          status: "network_error",
        ),
      );
    } on TimeoutException catch (e) {
      debugLog("❌ Request timeout: $e", name: "API Request");
      _sessionController.add(SessionStatus.active);
      return ApiResult<ResponseModel>(
        status: ApiStatus.timeoutError, // ✅ Updated to use specific status
        response: ResponseModel(
          message: "Request timeout. Please try again.",
          status: "timeout",
        ),
      );
    } on FormatException catch (e) {
      debugLog("❌ JSON parsing error: $e", name: "API Request");
      _sessionController.add(SessionStatus.active);
      return ApiResult<ResponseModel>(
        status: ApiStatus.failed,
        response: ResponseModel(
          message: "Invalid response format from server.",
          status: 'parse_error',
        ),
      );
    } catch (e, stackTrace) {
      debugLog("❌ Unexpected error: $e", name: "API Request");
      debugLog(stackTrace.toString(), name: "API Request Stacktrace");
      _sessionController.add(SessionStatus.active);
      return ApiResult<ResponseModel>(
        status: ApiStatus.failed,
        response: ResponseModel(
          message: "Something went wrong! ${e.toString()}",
          status: 'error',
        ),
      );
    }
  }

  /// Get user-friendly server error message
  String _getServerErrorMessage(int statusCode) {
    switch (statusCode) {
      case ApiStatusCode.internalServerError:
        return "Internal server error. Please try again later.";
      case ApiStatusCode.badGateway:
        return "Bad gateway. Please try again later.";
      case ApiStatusCode.serviceUnavailable:
        return "Service temporarily unavailable. Please try again later.";
      case ApiStatusCode.gatewayTimeout:
        return "Gateway timeout. Please try again.";
      default:
        return "Server error ($statusCode). Please try again later.";
    }
  }

  /// 📌 POST request
  Future<ApiResult> apiConnection<T>(
      String url,
      Map<String, String> header,
      String method,
      T Function(String) parser, {
        dynamic body,
      }) async {
    debugLog("POST: $url", name: "API Request");
    debugLog("Body: ${json.encode(body)}", name: "API Request");

    return _handleRequest<T>(
          (token) async {
        final headers = Map<String, String>.from(header);
        if (token != null && token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
        }

        return await http
            .post(
          Uri.parse(url),
          headers: headers,
          body: json.encode(body),
        )
            .timeout(const Duration(seconds: 30));
      },
      parser,
    );
  }

  /// 📌 GET request
  Future<ApiResult> getApiConnection<T>(
      String url,
      Map<String, String> header,
      T Function(String) parser, {
        bool isLogIn = false,
      }) async {
    debugLog("GET: $url", name: "API Request");

    return _handleRequest<T>(
          (token) async {
        final headers = Map<String, String>.from(header);
        if (!isLogIn && token != null && token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
        }

        return await http
            .get(
          Uri.parse(url),
          headers: headers,
        )
            .timeout(const Duration(seconds: 30));
      },
      parser,
    );
  }

  /// 📌 PUT request
  Future<ApiResult> putApiConnection<T>(
      String url,
      Map<String, String> header,
      T Function(String) parser, {
        dynamic body,
      }) async {
    debugLog("PUT: $url", name: "API Request");
    debugLog("Body: ${json.encode(body)}", name: "API Request");

    return _handleRequest<T>(
          (token) async {
        final headers = Map<String, String>.from(header);
        if (token != null && token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
        }

        return await http
            .put(
          Uri.parse(url),
          headers: headers,
          body: json.encode(body),
        )
            .timeout(const Duration(seconds: 30));
      },
      parser,
    );
  }

  /// 📌 PATCH request
  Future<ApiResult> patchApiConnection<T>(
      String url,
      Map<String, String> header,
      T Function(String) parser, {
        dynamic body,
      }) async {
    debugLog("PATCH: $url", name: "API Request");
    debugLog("Body: ${json.encode(body)}", name: "API Request");

    return _handleRequest<T>(
          (token) async {
        final headers = Map<String, String>.from(header);
        if (token != null && token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
        }

        return await http
            .patch(
          Uri.parse(url),
          headers: headers,
          body: json.encode(body),
        )
            .timeout(const Duration(seconds: 30));
      },
      parser,
    );
  }

  /// 📌 DELETE request
  Future<ApiResult> deleteApiConnection<T>(
      String url,
      Map<String, String> header,
      T Function(String) parser,
      ) async {
    debugLog("DELETE: $url", name: "API Request");

    return _handleRequest<T>(
          (token) async {
        final headers = Map<String, String>.from(header);
        if (token != null && token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
        }

        return await http
            .delete(
          Uri.parse(url),
          headers: headers,
        )
            .timeout(const Duration(seconds: 30));
      },
      parser,
    );
  }

  /// 📌 Multipart PATCH request (with optional file upload)
Future<ApiResult> patchApiConnectionMultipart<T>(
  String url,
  Map<String, String> header,
  T Function(String) parser, {
  Map<String, dynamic> fields = const {},
  String fileKey = 'file',
  List<File> files = const [],
}) async {
  debugLog("PATCH (Multipart): $url", name: "API Request");
  debugLog("Fields: $fields", name: "API Request");
  debugLog("Files count: ${files.length}", name: "API Request");

  return _handleRequest<T>(
    (token) async {
      final headers = Map<String, String>.from(header);

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final request =
          http.MultipartRequest('PATCH', Uri.parse(url));

      request.headers.addAll(headers);

      // Add fields
      fields.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      // Add files
      for (var file in files) {
        final multipartFile = await http.MultipartFile.fromPath(
          fileKey,
          file.path,
          filename:
              'upload_${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}',
        );
        request.files.add(multipartFile);
      }

      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 60));

      return await http.Response.fromStream(streamedResponse);
    },
    parser,
  );
}

  /// 📌 Multipart request (POST/PUT with file uploads)
  Future<ApiResult> apiConnectionMultipart<T>(
      String url,
      Map<String, String> header,
      String method,
      T Function(String) parser, {
        Map<String, dynamic> fields = const {},
        String fileKey = 'images',
        List<File> files = const [],
        bool isLogIn = false,
      }) async {
    debugLog("$method (Multipart): $url", name: "API Request");
    debugLog("Fields: $fields", name: "API Request");
    debugLog("Files count: ${files.length}", name: "API Request");
    return _handleRequest<T>(
          (token) async {
        final headers = Map<String, String>.from(header);

        // Only add token if not a login request
        if (!isLogIn && token != null && token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
        }

        final request = http.MultipartRequest(method, Uri.parse(url));
        request.headers.addAll(headers);

        // Add text fields
        fields.forEach((key, value) {
          request.fields[key] = value.toString();
        });

        // Add files
        for (var file in files) {
          final multipartFile = await http.MultipartFile.fromPath(
            fileKey,
            file.path,
            filename: 'upload_${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}',
          );
          request.files.add(multipartFile);
        }

        final streamedResponse = await request.send().timeout(const Duration(seconds: 60));
        return await http.Response.fromStream(streamedResponse);
      },
      parser,
    );
  }

  /// 🔗 Generate URL with query parameters
  /// 📌 GET Binary data (for file downloads)
  Future<Uint8List?> getBinaryData(String url) async {
    try {
      String? token = await _getAccessToken();
      Map<String, String> header = BaseNetwork.getJsonHeaders();
      if (token != null) header['Authorization'] = 'Bearer $token';

      debugLog("📤 Binary Request: $url", name: "ApiConnection");

      final response = await http.get(Uri.parse(url), headers: header);

      debugLog("📥 Status: ${response.statusCode}", name: "ApiConnection");

      if (response.statusCode == ApiStatusCode.success) {
        return response.bodyBytes;
      } else if (response.statusCode == ApiStatusCode.unAuthorized) {
        debugLog(
            "⚠️ Binary request unauthorized, refreshing token...",
            name: "ApiConnection");
        final refreshed = await _refreshToken();
        if (refreshed) {
          final newToken = await _getAccessToken();
          header['Authorization'] = 'Bearer $newToken';
          final retryResponse = await http.get(Uri.parse(url), headers: header);
          if (retryResponse.statusCode == ApiStatusCode.success) {
            return retryResponse.bodyBytes;
          }
        }
      }
      return null;
    } catch (e, st) {
      debugLog("❌ Error downloading binary data: $e",
          name: "ApiConnection", stackTrace: st);
      return null;
    }
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
    String? createdBy,
    String? maintenanceStatus,
    String? requireMaintenance,
    String? requireMonitoring,
    String? group,
    String? category,
    String? orderBy,
  }) {
    final queryParameters = <String, String>{};

    if (searchQuery != null && searchQuery.isNotEmpty) {
      queryParameters['search'] = searchQuery;
    }
    if (page != null) queryParameters['page'] = page.toString();
    if (pageSize != null) queryParameters['page_size'] = pageSize.toString();
    if (filterBy != null && filterBy.isNotEmpty) {
      queryParameters['category'] = filterBy;
    }
    if (status != null && status.isNotEmpty) {
      queryParameters['status'] = status;
    }
    if (projectId != null && projectId.isNotEmpty) {
      queryParameters['project_id'] = projectId;
    }
    if (project != null && project.isNotEmpty) {
      queryParameters['project'] = project;
    }
    if (serviceName != null && serviceName.isNotEmpty) {
      queryParameters['service_type'] = serviceName;
    }
    if (projectAreaId != null && projectAreaId.isNotEmpty) {
      queryParameters['project_area_id'] = projectAreaId;
    }
    if (plantationId != null && plantationId.isNotEmpty) {
      queryParameters['plantationId'] = plantationId;
    }
    if (plantation != null && plantation.isNotEmpty) {
      queryParameters['plantation'] = plantation;
    }
    if (areaId != null && areaId.isNotEmpty) {
      queryParameters['area'] = areaId;
    }
    if (orderId != null && orderId.isNotEmpty) {
      queryParameters['order_id'] = orderId;
    }
    if (vendorId != null && vendorId.isNotEmpty) {
      queryParameters['vendor'] = vendorId;
    }
    if (type != null && type.isNotEmpty) {
      queryParameters['type'] = type;
    }
    if (createdBy != null && createdBy.isNotEmpty) {
      queryParameters['created_by'] = createdBy;
    }
    if (maintenanceStatus != null && maintenanceStatus.isNotEmpty) {
      queryParameters['maintenance_status'] = maintenanceStatus;
    }
    if (group != null && group.isNotEmpty) {
      queryParameters['group'] = group;
    }
    if (requireMaintenance != null && requireMaintenance.isNotEmpty) {
      queryParameters['require_maintenance'] = requireMaintenance;
    }
    if (requireMonitoring != null && requireMonitoring.isNotEmpty) {
      queryParameters['require_monitoring'] = requireMonitoring;
    }
    if (category != null && category.isNotEmpty) {
      queryParameters['category'] = Uri.encodeComponent(category);
    }
    if (orderBy != null && orderBy.isNotEmpty) {
      queryParameters['order_by'] = orderBy;
    }

    if (baseUrl == null || baseUrl.isEmpty) {
      return '';
    }

    if (queryParameters.isEmpty) {
      return baseUrl;
    }

    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);
    return uri.toString();
  }

  /// 🚪 Logout - clear tokens and notify
  Future<void> logout() async {
    debugLog("🚪 Logging out...", name: "ApiConnection");
    await securePref.remove(Keys.accessToken);
    await securePref.remove(Keys.refreshToken);
    await securePref.remove(Keys.accessTokenExpires);
    await securePref.remove(Keys.refreshTokenExpires);
    _sessionController.add(SessionStatus.loggedOut);
  }

  /// 🧹 Dispose resources
  void dispose() {
    _sessionController.close();
  }
}


