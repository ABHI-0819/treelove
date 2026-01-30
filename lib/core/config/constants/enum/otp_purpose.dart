enum OtpPurpose {
  phoneVerification,
  emailVerification,
}

extension OtpPurposeX on OtpPurpose {
  String get value {
    switch (this) {
      case OtpPurpose.phoneVerification:
        return 'phone_verification';
      case OtpPurpose.emailVerification:
        return 'email_verification';
    }
  }
}
