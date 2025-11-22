/*
class ApiResult<T> {
  ApiStatus? status;
  T response;

  ApiResult({required this.status, required this.response});
  T get getResponse => response;

  ApiStatus? get getStatus => status;
}

enum ApiStatus {success,created,noContent,resetContent, failed ,forbidden, unAuthorized,badRequest,resourceNotFound,mediaNotSupport,refreshTokenExpired}

class ApiStatusCode {
  static int success = 200;
  static int created = 201;
  static int noContent =204;
  static int resetContent=205;
  static int failed = 400;
  static int forbidden = 403;
  static int unAuthorized = 401;
  static int badRequest = 400;
  static int resourceNotFound = 404;
  static int mediaNotSupport = 415;
}

 */
/// API Result wrapper class
class ApiResult<T> {
  final ApiStatus status;  //  Made non-nullable and final
  final T response;        //  Made final

  ApiResult({
    required this.status,
    required this.response,
  });

  //  Simplified getters (can access directly via .status and .response)
  T get getResponse => response;
  ApiStatus get getStatus => status;

  //  Added utility methods
  bool get isSuccess => status == ApiStatus.success || status == ApiStatus.created;
  bool get isError => !isSuccess;
  bool get needsAuth => status == ApiStatus.unAuthorized || status == ApiStatus.refreshTokenExpired;
}

/// API Status enumeration
enum ApiStatus {
  //  Success statuses
  success,              // 200
  created,              // 201
  accepted,             // 202 (new)
  noContent,            // 204
  resetContent,         // 205

  //  Client error statuses
  badRequest,           // 400
  unAuthorized,         // 401
  forbidden,            // 403
  notFound,             // 404 (renamed from resourceNotFound)
  methodNotAllowed,     // 405 (new)
  conflict,             // 409 (new)
  unsupportedMedia,     // 415 (renamed from mediaNotSupport)
  unprocessableEntity,  // 422 (new)
  tooManyRequests,      // 429 (new)

  //  Server error statuses
  internalServerError,  // 500 (new)
  badGateway,           // 502 (new)
  serviceUnavailable,   // 503 (new)
  gatewayTimeout,       // 504 (new)

  //  Custom statuses
  refreshTokenExpired,  // Custom status for token expiry
  networkError,         // Custom status for network issues (new)
  timeoutError,         // Custom status for timeout (new)
  failed,              // Generic failure
}

/// HTTP Status codes
class ApiStatusCode {
  // ✅ Success codes (2xx)
  static const int success = 200;
  static const int created = 201;
  static const int accepted = 202;
  static const int noContent = 204;
  static const int resetContent = 205;

  // ✅ Client error codes (4xx)
  static const int badRequest = 400;
  static const int unAuthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int methodNotAllowed = 405;
  static const int conflict = 409;
  static const int unsupportedMedia = 415;
  static const int unprocessableEntity = 422;
  static const int tooManyRequests = 429;

  // ✅ Server error codes (5xx)
  static const int internalServerError = 500;
  static const int badGateway = 502;
  static const int serviceUnavailable = 503;
  static const int gatewayTimeout = 504;

  // ✅ Helper method to convert status code to ApiStatus
  static ApiStatus fromStatusCode(int statusCode) {
    switch (statusCode) {
    // Success
      case 200:
        return ApiStatus.success;
      case 201:
        return ApiStatus.created;
      case 202:
        return ApiStatus.accepted;
      case 204:
        return ApiStatus.noContent;
      case 205:
        return ApiStatus.resetContent;

    // Client errors
      case 400:
        return ApiStatus.badRequest;
      case 401:
        return ApiStatus.unAuthorized;
      case 403:
        return ApiStatus.forbidden;
      case 404:
        return ApiStatus.notFound;
      case 405:
        return ApiStatus.methodNotAllowed;
      case 409:
        return ApiStatus.conflict;
      case 415:
        return ApiStatus.unsupportedMedia;
      case 422:
        return ApiStatus.unprocessableEntity;
      case 429:
        return ApiStatus.tooManyRequests;

    // Server errors
      case 500:
        return ApiStatus.internalServerError;
      case 502:
        return ApiStatus.badGateway;
      case 503:
        return ApiStatus.serviceUnavailable;
      case 504:
        return ApiStatus.gatewayTimeout;

    // Default
      default:
        return ApiStatus.failed;
    }
  }

  //  Helper to check if status code is success
  static bool isSuccess(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  //  Helper to check if status code is client error
  static bool isClientError(int statusCode) {
    return statusCode >= 400 && statusCode < 500;
  }

  //  Helper to check if status code is server error
  static bool isServerError(int statusCode) {
    return statusCode >= 500 && statusCode < 600;
  }
}