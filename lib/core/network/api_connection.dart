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
      if (statusCode == ApiStatusCode.SUCCESS) {
        return ApiResult<T>(
            status: ApiStatus.success, response: f!(response.body));
      } else if (statusCode == ApiStatusCode.UnAUTHORIZED) {
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
      if (statusCode == ApiStatusCode.SUCCESS) {
        return ApiResult<T>(
            status: ApiStatus.success, response: f(response.body));
      } else if (statusCode == ApiStatusCode.UnAUTHORIZED) {
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
      if (statusCode == ApiStatusCode.SUCCESS) {
        return ApiResult<T>(
            status: ApiStatus.success, response:parseResponse(response.body));
      } else if (statusCode == ApiStatusCode.UnAUTHORIZED) {
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