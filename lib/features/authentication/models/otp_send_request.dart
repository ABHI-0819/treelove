import '../../../core/config/constants/enum/otp_purpose.dart';

class OtpSendRequest {
  final String phone;
  final String email;
  final OtpPurpose purpose;

  OtpSendRequest({
    required this.phone,
    required this.email,
    required this.purpose,
  }) : assert(
          phone.isNotEmpty || email.isNotEmpty,
          'Either phone or email must be provided',
        );

  /// Factory: phone has top priority
  factory OtpSendRequest.fromContact({
    required String phone,
    required String email,
  }) {
    final usePhone = phone.isNotEmpty;

    return OtpSendRequest(
      phone: usePhone ? phone.trim() : '',
      email: usePhone ? '' : email.trim(),
      purpose: usePhone
          ? OtpPurpose.phoneVerification
          : OtpPurpose.emailVerification,
    );
  }

  /// Multipart body (same style as RegistrationRequest)
  Map<String, String> toMultipart() {
    final Map<String, String> fields = {};

    if (phone.isNotEmpty) {
      fields['phone'] = phone;
    }

    if (email.isNotEmpty) {
      fields['email'] = email;
    }

    fields['purpose'] = purpose.value;

    return fields;
  }
}
