class ApiResult<T> {
  ApiStatus? status;
  T response;

  ApiResult({required this.status, required this.response});
  T get getResponse => response;

  ApiStatus? get getStatus => status;
}

enum ApiStatus { success,noContent, failed ,forbidden, unAuthorized,badRequest,resourceNotFound,mediaNotSupport}

class ApiStatusCode {
  static int success = 200;
  static int noContent =204;
  static int failed = 400;
  static int forbidden = 403;
  static int unAuthorized = 401;
  static int badRequest = 400;
  static int resourceNotFound = 404;
  static int mediaNotSupport = 415;
}