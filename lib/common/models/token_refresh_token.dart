// token_refresh_response.dart
class TokenRefreshResponse {
  final String status;
  final String message;
  final TokenData data;

  TokenRefreshResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TokenRefreshResponse.fromJson(Map<String, dynamic> json) {
    return TokenRefreshResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: TokenData.fromJson(json['data'] ?? {}),
    );
  }
}

class TokenData {
  final String access;
  final String refresh;
  final String accessTokenExpires;
  final String refreshTokenExpires;

  TokenData({
    required this.access,
    required this.refresh,
    required this.accessTokenExpires,
    required this.refreshTokenExpires,
  });

  factory TokenData.fromJson(Map<String, dynamic> json) {
    return TokenData(
      access: json['access'] ?? '',
      refresh: json['refresh'] ?? '',
      accessTokenExpires: json['access_token_expires'] ?? '',
      refreshTokenExpires: json['refresh_token_expires'] ?? '',
    );
  }
}