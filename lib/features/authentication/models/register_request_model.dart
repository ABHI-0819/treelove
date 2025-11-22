/*
import 'dart:io';
import 'dart:convert';

class RegistrationRequest {
  final String? email;
  final String? phone;
  final String? countryCode;
  final String oauthProvider; // required
  final String password; // required
  final String confirmPassword; // required
  final String? group;
  final ProfileRegistrationRequest profile;

  RegistrationRequest({
    this.email,
    this.phone,
    this.countryCode,
    required this.oauthProvider,
    required this.password,
    required this.confirmPassword,
    this.group,
    required this.profile,
  });

  /// Convert model into Multipart request fields
  Map<String, dynamic> toMultipart() {
    return {
      if (email != null) "email": email,
      if (phone != null) "phone": phone,
      if (countryCode != null) "country_code": countryCode,
      "oauth_provider": oauthProvider,
      "password": password,
      "confirm_password": confirmPassword,
      if (group != null) "group": group,
      ...profile.toMultipart(),
    };
  }
}
class ProfileRegistrationRequest {
  final String firstName;
  final String lastName;
  final String? bio;
  final String? dateOfBirth; // yyyy-MM-dd
  final String legalName;
  final String? website;
  final bool receiveNotifications;
  final List<AddressRegistrationRequest> addresses;
  final String? profilePicturePath; // File path (optional)

  ProfileRegistrationRequest({
    required this.firstName,
    required this.lastName,
    this.bio,
    this.dateOfBirth,
    required this.legalName,
    this.website,
    required this.receiveNotifications,
    required this.addresses,
    this.profilePicturePath,
  });

  Map<String, dynamic> toMultipart() {
    return {
      "profile[first_name]": firstName,
      "profile[last_name]": lastName,
      if (bio != null) "profile[bio]": bio,
      if (dateOfBirth != null) "profile[date_of_birth]": dateOfBirth,
      "profile[legal_name]": legalName,
      if (website != null) "profile[website]": website,
      "profile[receive_notifications]": receiveNotifications.toString(),
      // Addresses
      for (int i = 0; i < addresses.length; i++)
        ...addresses[i].toMultipart(i),
    };
  }
}
class AddressRegistrationRequest {
  final String line1;
  final String? line2;
  final String city;
  final String state;
  final String country;
  final String postalCode;

  AddressRegistrationRequest({
    required this.line1,
    this.line2,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
  });

  /// Convert to multipart indexed format: profile[addresses][0][city]
  Map<String, dynamic> toMultipart(int index) {
    return {
      "profile[addresses][$index][line1]": line1,
      if (line2 != null) "profile[addresses][$index][line2]": line2,
      "profile[addresses][$index][city]": city,
      "profile[addresses][$index][state]": state,
      "profile[addresses][$index][country]": country,
      "profile[addresses][$index][postal_code]": postalCode,
    };
  }
}

enum OauthProviderEnum { email, phone, google, facebook }

String oauthProviderToString(OauthProviderEnum value) {
  return value.name;
}

 */
import 'dart:convert';
import 'dart:io';

/// Main registration request model for multipart/form-data submission
class RegistrationRequest {
  final String? email;
  final String? phone;
  final String? countryCode;
  final String oauthProvider;
  final String password;
  final String confirmPassword;
  final String? group;
  final Profile profile;
  final File? profilePicture;

  RegistrationRequest({
    this.email,
    this.phone,
    this.countryCode,
    required this.oauthProvider,
    required this.password,
    required this.confirmPassword,
    this.group,
    required this.profile,
    this.profilePicture,
  }) : assert(
  (email != null && email.isNotEmpty) ||
      (phone != null && phone.isNotEmpty),
  'Either email or phone must be provided',
  );

  /// Converts the request to a Map<String, String> for multipart fields
  /// The profile_picture file is handled separately by the repository
  Map<String, String> toMultipart() {
    final Map<String, String> fields = {};

    // Add optional fields only if they have values
    if (email != null && email!.isNotEmpty) {
      fields['email'] = email!.trim();
    }
    if (phone != null && phone!.isNotEmpty) {
      fields['phone'] = phone!.trim();
    }
    if (countryCode != null && countryCode!.isNotEmpty) {
      fields['country_code'] = countryCode!.trim();
    }
    if (group != null && group!.isNotEmpty) {
      fields['group'] = group!;
    }

    // Add required fields
    fields['oauth_provider'] = oauthProvider;
    fields['password'] = password;
    fields['confirm_password'] = confirmPassword;

    // Serialize the profile object to JSON string
    fields['profile'] = json.encode(profile.toJson());

    return fields;
  }
}

/// Profile model for user registration
class Profile {
  final String? firstName;
  final String? lastName;
  final String? bio;
  final DateTime? dateOfBirth;
  final String? legalName;
  final String? website;
  final bool? receiveNotifications;

  Profile({
    this.firstName,
    this.lastName,
    this.bio,
    this.dateOfBirth,
    this.legalName,
    this.website,
    this.receiveNotifications,
  });

  /// Converts profile to JSON map for serialization
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    if (firstName != null && firstName!.isNotEmpty) {
      json['first_name'] = firstName;
    }
    if (lastName != null && lastName!.isNotEmpty) {
      json['last_name'] = lastName;
    }
    if (bio != null && bio!.isNotEmpty) {
      json['bio'] = bio;
    }
    if (dateOfBirth != null) {
      // Format as YYYY-MM-DD
      json['date_of_birth'] = dateOfBirth!.toIso8601String().split('T')[0];
    }
    if (legalName != null && legalName!.isNotEmpty) {
      json['legal_name'] = legalName;
    }
    if (website != null && website!.isNotEmpty) {
      json['website'] = website;
    }
    if (receiveNotifications != null) {
      json['receive_notifications'] = receiveNotifications;
    }

    return json;
  }
}



/// Location model (GeoJSON format)
class Location {
  final String type; // Typically "Point"
  final List<double> coordinates; // [longitude, latitude]

  Location({
    required this.type,
    required this.coordinates,
  });

  /// Converts location to JSON map
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }

  /// Helper factory for creating a Point location
  factory Location.point(double longitude, double latitude) {
    return Location(
      type: 'Point',
      coordinates: [longitude, latitude],
    );
  }
}