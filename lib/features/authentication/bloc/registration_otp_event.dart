abstract class RegistrationOtpEvent {}

class SendOtp extends RegistrationOtpEvent {}

class ResendOtp extends RegistrationOtpEvent {}

class VerifyOtp extends RegistrationOtpEvent {
  final String otp;
  VerifyOtp(this.otp);
}
