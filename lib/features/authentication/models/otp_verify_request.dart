class OtpVerifyRequest {
  final String otp;
  final String phone;
  final String email;

  OtpVerifyRequest({
    required this.otp,
    required this.phone,
    required this.email,
  }) : assert(
          phone.isNotEmpty || email.isNotEmpty,
          'Either phone or email must be provided',
        );

  Map<String, String> toMultipart() {
    final Map<String, String> fields = {
      'otp': otp.trim(),
    };

    if (phone.isNotEmpty) {
      fields['phone'] = phone.trim();
    }

    if (email.isNotEmpty) {
      fields['email'] = email.trim();
    }

    return fields;
  }
}
