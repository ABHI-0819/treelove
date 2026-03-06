import 'dart:io';

class UpdateProfileRequest {
  final String? firstName;
  final String? lastName;
  final String? bio;
  final String? website;
  final String? legalName;
  final String? panNumber;
  final String? gstNumber;
  final String? dateOfBirth;
  final bool? receiveNotifications;
  final List<File> media;

  UpdateProfileRequest({
    this.firstName,
    this.lastName,
    this.bio,
    this.website,
    this.legalName,
    this.panNumber,
    this.gstNumber,
    this.dateOfBirth,
    this.receiveNotifications,
    this.media = const [],
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (firstName != null) data['first_name'] = firstName;
    if (lastName != null) data['last_name'] = lastName;
    if (bio != null) data['bio'] = bio;
    if (website != null) data['website'] = website;
    if (legalName != null) data['legal_name'] = legalName;
    if (panNumber != null) data['pan_number'] = panNumber;
    if (gstNumber != null) data['gst_number'] = gstNumber;
    if (dateOfBirth != null) {
      data['date_of_birth'] = dateOfBirth;
    }
    if (receiveNotifications != null) {
      data['receive_notifications'] = receiveNotifications;
    }

    return data;
  }
}

class ProfileMedia {
  final String filePath;

  ProfileMedia({required this.filePath});

  Map<String, dynamic> toJson() => {
        "profile_picture": filePath,
      };
}
