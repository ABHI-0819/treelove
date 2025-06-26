/*
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../common/models/response.mode.dart';
import '../utils/logger.dart';
import 'base_network.dart';
import 'base_network_status.dart';

class ApiConnection {


  apiConnection<T>(String url, dynamic header, dynamic method,Function f,{dynamic body}) async {
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: json.encode(body),
        headers: header,
      );
      int statusCode = response.statusCode;
      debugLog(response.body.toString(), name: "BoSS");
      debugLog(statusCode.toString(), name: "Status Code");
      if (statusCode == ApiStatusCode.success) {
        return ApiResult<T>(
            status: ApiStatus.success, response: f!(response.body));
      } else if (statusCode == ApiStatusCode.unAuthorized) {
        return ApiResult<ResponseModel>(
            status: ApiStatus.unAuthorized,
            response: responseModelFromJson(response.body.toString())!);
      } else {
        return ApiResult<ResponseModel>(
            status: ApiStatus.badRequest,
            response: responseModelFromJson(response.body.toString())!);
      }
    } on SocketException {
      return ApiResult<ResponseModel>(
          status: ApiStatus.failed,
          response: ResponseModel(message: BaseNetwork.FailedMessage));
    } catch (e, StackTrace) {
      debugLog(e.toString(), stackTrace: StackTrace);
      return ApiResult<ResponseModel>(
          status: ApiStatus.failed,
          response: ResponseModel(
              message: "Something went wrong! ${e.toString()}", status: ''));
    }
  }

  getApiConnection<T>(url, dynamic header, Function f) async {
    debugLog(url, name: 'URL');
    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: BaseNetwork.getJsonHeaders(),
      );
      int statusCode = response.statusCode;
      debugLog(response.body.toString(), name: "BoSS");
      debugLog(statusCode.toString(), name: "Status Code");
      if (statusCode == ApiStatusCode.success) {
        return ApiResult<T>(
            status: ApiStatus.success, response: f(response.body));
      } else if (statusCode == ApiStatusCode.unAuthorized) {
        return ApiResult<ResponseModel>(
            status: ApiStatus.unAuthorized,
            response: responseModelFromJson(response.body)!);
      } else {
        return ApiResult<ResponseModel>(
            status: ApiStatus.badRequest,
            response: responseModelFromJson(response.body)!);
      }
    } on SocketException {
      return ApiResult<ResponseModel>(
          status: ApiStatus.failed,
          response: ResponseModel(message: BaseNetwork.FailedMessage));
    } catch (e, stackTrace) {
      debugLog(e.toString(), stackTrace: stackTrace);
      return ApiResult<ResponseModel>(
          status: ApiStatus.failed,
          response: ResponseModel(
              message: "Something went wrong! ${e.toString()}", status: ''));
    }
  }

  //Multipart
  apiConnectionMultipart<T>(String url, dynamic header, dynamic method,Function parseResponse,{ Map<String, dynamic> fields = const {}, List<File> files = const [], }) async {
    try {
      var request = http.MultipartRequest(method, Uri.parse(url));
      Map<String, String> userHeader = header;
      request.headers.addAll(userHeader);
      fields.forEach((key, value) => request.fields[key] = value.toString());
      for (var file in files) {
        var multipartFile = await http.MultipartFile.fromPath(
          'image',
          file.path,
          filename: 'plantation${file.path.split('/').last}.jpg',
        );
        request.files.add(multipartFile);
      }
      http.Response response = await http.Response.fromStream(await request.send());
      int statusCode = response.statusCode;
      debugLog(request.fields.toString(), name: '${request.url}');
      debugLog(request.files.toString(), name: '${request.url}');
      debugLog(response.body.toString(), name: '${request.url}');
      if (statusCode == ApiStatusCode.success) {
        return ApiResult<T>(
            status: ApiStatus.success, response:parseResponse(response.body));
      } else if (statusCode == ApiStatusCode.unAuthorized) {
        return ApiResult<ResponseModel>(
            status: ApiStatus.unAuthorized,
            response: responseModelFromJson(response.body)!);
      } else {
        return ApiResult<ResponseModel>(
            status: ApiStatus.badRequest,
            response: responseModelFromJson(response.body)!);
      }
    } on SocketException {
      return ApiResult<ResponseModel>(
          status: ApiStatus.failed,
          response: ResponseModel(message: BaseNetwork.FailedMessage));
    } catch (e, stackTrace) {
      debugLog(e.toString(), stackTrace: stackTrace);
      return ApiResult<ResponseModel>(
          status: ApiStatus.failed,
          response: ResponseModel(
              message: "Something went wrong! \n${e.toString()}", status: ''));
    }
  }


  String generateUrl({String? baseUrl, String? searchQuery, int? page, int? pageSize,String? filterBy,String ?botanical,List<String>? flowering,String ? group,String ? category,String ? orderBy}) {
    final queryParameters = <String, String>{};

    if (searchQuery != null) {
      queryParameters['search'] = searchQuery;
    }
    if (page != null) {
      queryParameters['page'] = page.toString();
    }
    if (pageSize != null) {
      queryParameters['page_size'] = pageSize.toString();
    }
    if (filterBy != null) {
      queryParameters['filter_by'] = filterBy.toString();
    }
    if (botanical != null) {
      queryParameters['botanical'] = botanical.toString();
    }
    if (orderBy != null) {
      queryParameters['order_by'] = orderBy.toString();
    }
    if (group != null) {
      queryParameters['group'] = group.toString();
    }
    if(category!=null){
       queryParameters['category'] = Uri.encodeComponent(category);
    }

    final floweringParams = flowering != null && flowering.isNotEmpty
        ? flowering.map((month) => 'flowering=$month').join('&')
        : '';

    ///Created base params
    final baseParams = queryParameters.entries.map((e) => '${e.key}=${e.value}').join('&');

    ///created full params if flowering
    final fullParams = [baseParams, floweringParams].where((param) => param.isNotEmpty).join('&');

    final uri = Uri.parse(baseUrl ?? '').replace(
      query: fullParams,
    );

    return uri.toString();
  }

}

 */

// lib/network/api_connection.dart
/*
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../common/models/response.mode.dart';
import '../storage/preference_keys.dart';
import '../storage/secure_storage.dart';
import '../utils/logger.dart';
import 'base_network.dart';
import 'base_network_status.dart';


class ApiConnection {
  final securePref = SecurePreference();

  Future<String?> _getAccessToken() async {
    return await securePref.getString(Keys.accessToken);
  }

  Future<String?> _getRefreshToken() async {
    return await securePref.getString(Keys.refreshToken);
  }

  Future<bool> _refreshToken() async {
    final refreshToken = await _getRefreshToken();
    if (refreshToken == null) return false;

    final response = await http.post(
      Uri.parse(BaseNetwork.refreshTokenURL),
      headers: BaseNetwork.getJsonHeaders(),
      body: json.encode({"refresh": refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await securePref.setString(Keys.accessToken, data['access']);
      await securePref.setString(Keys.refreshToken, data['refresh']);
      return true;
    }
    return false;
  }

  Future<ApiResult<T>> apiConnection<T>(
      String url,
      dynamic header,
      dynamic method,
      Function f, {
        dynamic body,
      }) async {
    try {
      String? token = await _getAccessToken();
      if (token != null) {
        header['Authorization'] = 'Bearer $token';
      }

      http.Response response = await http.post(
        Uri.parse(url),
        body: json.encode(body),
        headers: header,
      );

      if (response.statusCode == ApiStatusCode.success) {
        return ApiResult<T>(status: ApiStatus.success, response: f(response.body));
      } else if (response.statusCode == ApiStatusCode.unAuthorized) {
        bool refreshed = await _refreshToken();
        if (refreshed) {
          return await apiConnection<T>(url, header, method, f, body: body);
        } else {
          return ApiResult<T>(
              status: ApiStatus.unAuthorized,
              response: responseModelFromJson(response.body));
        }
      } else {
        return ApiResult<ResponseModel>(
            status: ApiStatus.badRequest,
            response: responseModelFromJson(response.body));
      }
    } on SocketException {
      return ApiResult<ResponseModel>(
          status: ApiStatus.failed,
          response: ResponseModel(message: BaseNetwork.FailedMessage));
    } catch (e, stackTrace) {
      debugLog(e.toString(), stackTrace: stackTrace);
      return ApiResult<ResponseModel>(
          status: ApiStatus.failed,
          response: ResponseModel(
              message: "Something went wrong! ${e.toString()}", status: ''));
    }
  }

  Future<ApiResult<T>> getApiConnection<T>(String url, dynamic header, Function f) async {
    try {
      String? token = await _getAccessToken();
      if (token != null) {
        header['Authorization'] = 'Bearer $token';
      }

      http.Response response = await http.get(
        Uri.parse(url),
        headers: header,
      );

      if (response.statusCode == ApiStatusCode.success) {
        return ApiResult<T>(status: ApiStatus.success, response: f(response.body));
      } else if (response.statusCode == ApiStatusCode.unAuthorized) {
        bool refreshed = await _refreshToken();
        if (refreshed) {
          return await getApiConnection<T>(url, header, f);
        } else {
          return ApiResult<ResponseModel>(
              status: ApiStatus.unAuthorized,
              response: responseModelFromJson(response.body));
        }
      } else {
        return ApiResult<ResponseModel>(
            status: ApiStatus.badRequest,
            response: responseModelFromJson(response.body));
      }
    } on SocketException {
      return ApiResult<ResponseModel>(
          status: ApiStatus.failed,
          response: ResponseModel(message: BaseNetwork.FailedMessage));
    } catch (e, stackTrace) {
      debugLog(e.toString(), stackTrace: stackTrace);
      return ApiResult<ResponseModel>(
          status: ApiStatus.failed,
          response: ResponseModel(
              message: "Something went wrong! ${e.toString()}", status: ''));
    }
  }

  Future<ApiResult<T>> apiConnectionMultipart<T>(
      String url,
      dynamic header,
      dynamic method,
      Function parseResponse, {
        Map<String, dynamic> fields = const {},
        List<File> files = const [],
      }) async {
    try {
      String? token = await _getAccessToken();
      if (token != null) {
        header['Authorization'] = 'Bearer $token';
      }

      var request = http.MultipartRequest(method, Uri.parse(url));
      request.headers.addAll(header);
      fields.forEach((key, value) => request.fields[key] = value.toString());
      for (var file in files) {
        var multipartFile = await http.MultipartFile.fromPath(
          'image',
          file.path,
          filename: 'plantation${file.path.split('/').last}.jpg',
        );
        request.files.add(multipartFile);
      }

      http.Response response = await http.Response.fromStream(await request.send());

      if (response.statusCode == ApiStatusCode.success) {
        return ApiResult<T>(
            status: ApiStatus.success, response: parseResponse(response.body));
      } else if (response.statusCode == ApiStatusCode.unAuthorized) {
        bool refreshed = await _refreshToken();
        if (refreshed) {
          return await apiConnectionMultipart<T>(url, header, method, parseResponse,
              fields: fields, files: files);
        } else {
          return ApiResult<ResponseModel>(
              status: ApiStatus.unAuthorized,
              response: responseModelFromJson(response.body));
        }
      } else {
        return ApiResult<ResponseModel>(
            status: ApiStatus.badRequest,
            response: responseModelFromJson(response.body));
      }
    } on SocketException {
      return ApiResult<ResponseModel>(
          status: ApiStatus.failed,
          response: ResponseModel(message: BaseNetwork.FailedMessage));
    } catch (e, stackTrace) {
      debugLog(e.toString(), stackTrace: stackTrace);
      return ApiResult<ResponseModel>(
          status: ApiStatus.failed,
          response: ResponseModel(
              message: "Something went wrong! \n${e.toString()}", status: ''));
    }
  }

  String generateUrl({
    String? baseUrl,
    String? searchQuery,
    int? page,
    int? pageSize,
    String? filterBy,
    String? botanical,
    List<String>? flowering,
    String? group,
    String? category,
    String? orderBy,
  }) {
    final queryParameters = <String, String>{};

    if (searchQuery != null) queryParameters['search'] = searchQuery;
    if (page != null) queryParameters['page'] = page.toString();
    if (pageSize != null) queryParameters['page_size'] = pageSize.toString();
    if (filterBy != null) queryParameters['filter_by'] = filterBy;
    if (botanical != null) queryParameters['botanical'] = botanical;
    if (orderBy != null) queryParameters['order_by'] = orderBy;
    if (group != null) queryParameters['group'] = group;
    if (category != null) queryParameters['category'] = Uri.encodeComponent(category);

    final floweringParams = flowering != null && flowering.isNotEmpty
        ? flowering.map((month) => 'flowering=$month').join('&')
        : '';

    final baseParams = queryParameters.entries.map((e) => '${e.key}=${e.value}').join('&');
    final fullParams = [baseParams, floweringParams].where((param) => param.isNotEmpty).join('&');

    final uri = Uri.parse(baseUrl ?? '').replace(query: fullParams);
    return uri.toString();
  }
}

 */
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../common/models/response.mode.dart';
import '../storage/preference_keys.dart';
import '../storage/secure_storage.dart';
import '../utils/logger.dart';
import 'base_network.dart';
import 'base_network_status.dart';


class ApiConnection {
  final securePref = SecurePreference();

  Future<String?> _getAccessToken() async {
    return await securePref.getString(Keys.accessToken);
  }

  Future<String?> _getRefreshToken() async {
    return await securePref.getString(Keys.refreshToken);
  }

  Future<bool> _refreshToken() async {
    final refreshToken = await _getRefreshToken();
    if (refreshToken == null) return false;

    final response = await http.post(
      Uri.parse(BaseNetwork.refreshTokenURL),
      headers: BaseNetwork.getJsonHeaders(),
      body: json.encode({"refresh": refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await securePref.setString(Keys.accessToken, data['access']);
      await securePref.setString(Keys.refreshToken, data['refresh']);
      return true;
    }
    return false;
  }

  Future<ApiResult> apiConnection<T>(
      String url,
      Map<String, String> header,
      String method,
      T Function(String) parser, {
        dynamic body,
      }) async {
    try {
      final token = await _getAccessToken();
      if (token != null) {
        header['Authorization'] = 'Bearer $token';
      }

      final response = await http.post(
        Uri.parse(url),
        headers: header,
        body: json.encode(body),
      );

      if (response.statusCode == ApiStatusCode.success) {
        return ApiResult<T>(status: ApiStatus.success, response: parser(response.body));
      } else if (response.statusCode == ApiStatusCode.unAuthorized) {
        final refreshed = await _refreshToken();
        if (refreshed) {
          return await apiConnection<T>(url, header, method, parser, body: body);
        } else {
          return ApiResult<ResponseModel>(
            status: ApiStatus.unAuthorized,
            response: responseModelFromJson(response.body)!,
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
        response: ResponseModel(message: "Something went wrong! ${e.toString()}", status: ''),
      );
    }
  }

  Future<ApiResult> getApiConnection<T>(
      String url,
      Map<String, String> header,
      T Function(String) parser,
      ) async {
    try {
      final token = await _getAccessToken();
      if (token != null) {
        header['Authorization'] = 'Bearer $token';
      }

      final response = await http.get(Uri.parse(url), headers: header);

      if (response.statusCode == ApiStatusCode.success) {
        return ApiResult<T>(status: ApiStatus.success, response: parser(response.body));
      } else if (response.statusCode == ApiStatusCode.unAuthorized) {
        final refreshed = await _refreshToken();
        if (refreshed) {
          return await getApiConnection<T>(url, header, parser);
        } else {
          return ApiResult<ResponseModel>(
            status: ApiStatus.unAuthorized,
            response: responseModelFromJson(response.body)!,
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
        response: ResponseModel(message: "Something went wrong! ${e.toString()}", status: ''),
      );
    }
  }

  Future<ApiResult> apiConnectionMultipart<T>(
      String url,
      Map<String, String> header,
      String method,
      T Function(String) parser, {
        Map<String, dynamic> fields = const {},
        List<File> files = const [],
      }) async {
    try {
      // final token = await _getAccessToken();
      // if (token != null) {
      //   header['Authorization'] = 'Bearer $token';
      // }

      final request = http.MultipartRequest(method, Uri.parse(url));
      request.headers.addAll(header);
      fields.forEach((key, value) => request.fields[key] = value.toString());
      for (var file in files) {
        final multipartFile = await http.MultipartFile.fromPath(
          'image',
          file.path,
          filename: 'plantation${file.path.split('/').last}.jpg',
        );
        request.files.add(multipartFile);
      }

      final streamedResponse = await request.send();
      debugLog(request.headers.toString(),name: "Request header");
      debugLog(request.fields.toString(),name: "Request fields");
      final response = await http.Response.fromStream(streamedResponse);
      debugLog(response.body.toString(),name: "Result");
      if (response.statusCode == ApiStatusCode.success) {
        return ApiResult<T>(status: ApiStatus.success, response: parser(response.body));
      } else if (response.statusCode == ApiStatusCode.unAuthorized) {
        return ApiResult<ResponseModel>(
          status: ApiStatus.unAuthorized,
          response: responseModelFromJson(response.body)!,
        );
        // final refreshed = await _refreshToken();
        /*
        if (refreshed) {
          return await apiConnectionMultipart<T>(
            url,
            header,
            method,
            parser,
            fields: fields,
            files: files,
          );
        } else {
          return ApiResult<ResponseModel>(
            status: ApiStatus.unAuthorized,
            response: responseModelFromJson(response.body)!,
          );
        }

         */
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
        response: ResponseModel(message: "Something went wrong! \n${e.toString()}", status: ''),
      );
    }
  }

  String generateUrl({
    String? baseUrl,
    String? searchQuery,
    int? page,
    int? pageSize,
    String? filterBy,
    String? botanical,
    List<String>? flowering,
    String? group,
    String? category,
    String? orderBy,
  }) {
    final queryParameters = <String, String>{};

    if (searchQuery != null) queryParameters['search'] = searchQuery;
    if (page != null) queryParameters['page'] = page.toString();
    if (pageSize != null) queryParameters['page_size'] = pageSize.toString();
    if (filterBy != null) queryParameters['filter_by'] = filterBy;
    final floweringParams = flowering != null && flowering.isNotEmpty
        ? flowering.map((month) => 'flowering=$month').join('&')
        : '';

    final baseParams = queryParameters.entries.map((e) => '${e.key}=${e.value}').join('&');
    final fullParams = [baseParams, floweringParams].where((param) => param.isNotEmpty).join('&');

    final uri = Uri.parse(baseUrl ?? '').replace(query: fullParams);
    return uri.toString();
  }
}






