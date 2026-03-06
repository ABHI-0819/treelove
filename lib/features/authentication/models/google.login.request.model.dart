class GoogleLoginRequestModel {
  final String ? email;
  final String ? name;
  final String ? oauthUid;
  final String idToken;
  final Map<String, dynamic> additionalData;
  final String provider;
  final String ?userTypeId;
  final String ?deviceId;

  GoogleLoginRequestModel({
    this.email,
    this.name,
    this.oauthUid,
    required this.idToken,
    required this.additionalData,
    required this.provider,
    this.userTypeId,
    this.deviceId,
  }): assert(
          oauthUid != null && oauthUid.isNotEmpty,
          'OAuth UID must be provided and not be null or empty.',
        );
}
