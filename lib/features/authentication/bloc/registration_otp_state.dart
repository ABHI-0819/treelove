enum RegistrationOtpStatus {
  initial,
  sendingOtp,
  otpSent,
  verifyingOtp,
  verified,
  failure,
}

class RegistrationOtpState {
  final RegistrationOtpStatus status;
  final String? errorMessage;

  const RegistrationOtpState({
    required this.status,
    this.errorMessage,
  });

  factory RegistrationOtpState.initial() {
    return const RegistrationOtpState(
      status: RegistrationOtpStatus.initial,
    );
  }

  RegistrationOtpState copyWith({
    RegistrationOtpStatus? status,
    String? errorMessage,
  }) {
    return RegistrationOtpState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
