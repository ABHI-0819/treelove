import 'dart:io';

class AddStaffRequestModel {
  final String firstName;        // required
  final String lastName;         // required
  final String? email;           // optional
  final String? phone;           // optional
  final String? countryCode;     // optional
  final String oauthProvider;    // required (email/phone/google/facebook)
  final String password;         // required
  final File? profilePicture;    // optional

  AddStaffRequestModel({
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    this.countryCode,
    required this.oauthProvider,
    required this.password,
    this.profilePicture,
  });

  /// ✅ Convert only text fields into a map (useful if no image)
  Map<String, String> toFields() {
    final Map<String, String> fields = {
      'first_name': firstName,
      'last_name': lastName,
      'oauth_provider': oauthProvider,
      'password': password,
    };

    if (email != null && email!.isNotEmpty) {
      fields['email'] = email!;
    }
    if (phone != null && phone!.isNotEmpty) {
      fields['phone'] = phone!;
    }
    if (countryCode != null && countryCode!.isNotEmpty) {
      fields['country_code'] = countryCode!;
    }

    return fields;
  }

  List<File> getFiles() {
    return profilePicture != null ? [profilePicture!] : [];
  }
}
