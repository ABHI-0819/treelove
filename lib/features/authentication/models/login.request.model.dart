class LoginRequestModel {
  final String? email;
  final String? phone;
  final String password;
  final String deviceId;

  LoginRequestModel({
    this.email,
    this.phone,
    required this.password,
    required this.deviceId,
  }) : assert(
          // This assertion ensures that at least one of these conditions is true:
          // 1. email is not null AND not empty
          // OR
          // 2. phone is not null AND not empty
          (email != null && email.isNotEmpty) ||
              (phone != null && phone.isNotEmpty),
          'Either email or phone must be provided and not be null or empty.',
        );
}
