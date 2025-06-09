class ApiResult<T> {
  ApiStatus? status;
  T response;

  ApiResult({required this.status, required this.response});
  T get getResponse => response;

  ApiStatus? get getStatus => status;
}

enum ApiStatus { success,noContent, failed ,forbidden, unAuthorized,badRequest,resourceNotFound,mediaNotSupport}

class ApiStatusCode {
  static int SUCCESS = 200;
  static int NOCONTENT =204;
  static int FAILED = 400;
  static int FORBID = 403;
  static int UnAUTHORIZED = 401;
  static int BADREQUEST = 400;
  static int RESOURCENOTFOUND = 404;
  static int MEDIANOTSUPPORT = 415;
}