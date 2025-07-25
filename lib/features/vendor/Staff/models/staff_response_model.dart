import 'dart:convert';

/// Parse from JSON
StaffResponseModel staffResponseModelFromJson(String str) =>
    StaffResponseModel.fromJson(json.decode(str));

/// Convert to JSON
String staffResponseModelToJson(StaffResponseModel data) =>
    json.encode(data.toJson());

class StaffResponseModel {
  final String status;
  final String message;
  final StaffData? data;

  StaffResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory StaffResponseModel.fromJson(Map<String, dynamic> json) =>
      StaffResponseModel(
        status: json["status"] ?? "",
        message: json["message"] ?? "",
        data: json["data"] != null ? StaffData.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class StaffData {
  final String id;
  final String? email;
  final String? phone;
  final String? countryCode;
  final String oauthProvider;
  final bool isActive;
  final StaffGroup? group;
  final StaffProfile? profile;
  final String createdAt;
  final String? lastLogin;
  final String updatedAt;

  StaffData({
    required this.id,
    this.email,
    this.phone,
    this.countryCode,
    required this.oauthProvider,
    required this.isActive,
    this.group,
    this.profile,
    required this.createdAt,
    this.lastLogin,
    required this.updatedAt,
  });

  factory StaffData.fromJson(Map<String, dynamic> json) => StaffData(
    id: json["id"] ?? "",
    email: json["email"],
    phone: json["phone"],
    countryCode: json["country_code"],
    oauthProvider: json["oauth_provider"] ?? "",
    isActive: json["is_active"] ?? false,
    group: json["group"] != null ? StaffGroup.fromJson(json["group"]) : null,
    profile:
    json["profile"] != null ? StaffProfile.fromJson(json["profile"]) : null,
    createdAt: json["created_at"] ?? "",
    lastLogin: json["last_login"],
    updatedAt: json["updated_at"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "phone": phone,
    "country_code": countryCode,
    "oauth_provider": oauthProvider,
    "is_active": isActive,
    "group": group?.toJson(),
    "profile": profile?.toJson(),
    "created_at": createdAt,
    "last_login": lastLogin,
    "updated_at": updatedAt,
  };
}

class StaffGroup {
  final String id;
  final String name;
  final String description;
  final String createdAt;
  final String updatedAt;

  StaffGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StaffGroup.fromJson(Map<String, dynamic> json) => StaffGroup(
    id: json["id"] ?? "",
    name: json["name"] ?? "",
    description: json["description"] ?? "",
    createdAt: json["created_at"] ?? "",
    updatedAt: json["updated_at"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

class StaffProfile {
  final String id;
  final String firstName;
  final String lastName;
  final String profilePicture;
  final String bio;
  final String? dateOfBirth;
  final String legalName;
  final String website;
  final String panNumber;
  final String gstNumber;
  final bool receiveNotifications;
  final String createdAt;
  final String updatedAt;
  final String user;
  final String createdBy;
  final String modifiedBy;

  StaffProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
    required this.bio,
    this.dateOfBirth,
    required this.legalName,
    required this.website,
    required this.panNumber,
    required this.gstNumber,
    required this.receiveNotifications,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.createdBy,
    required this.modifiedBy,
  });

  factory StaffProfile.fromJson(Map<String, dynamic> json) => StaffProfile(
    id: json["id"] ?? "",
    firstName: json["first_name"] ?? "",
    lastName: json["last_name"] ?? "",
    profilePicture: json["profile_picture"] ?? "",
    bio: json["bio"] ?? "",
    dateOfBirth: json["date_of_birth"],
    legalName: json["legal_name"] ?? "",
    website: json["website"] ?? "",
    panNumber: json["_pan_number"] ?? "",
    gstNumber: json["_gst_number"] ?? "",
    receiveNotifications: json["receive_notifications"] ?? false,
    createdAt: json["created_at"] ?? "",
    updatedAt: json["updated_at"] ?? "",
    user: json["user"] ?? "",
    createdBy: json["created_by"] ?? "",
    modifiedBy: json["modified_by"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "profile_picture": profilePicture,
    "bio": bio,
    "date_of_birth": dateOfBirth,
    "legal_name": legalName,
    "website": website,
    "_pan_number": panNumber,
    "_gst_number": gstNumber,
    "receive_notifications": receiveNotifications,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "user": user,
    "created_by": createdBy,
    "modified_by": modifiedBy,
  };

  String get fullName {
    // Trim in case either is empty
    final full = "$firstName $lastName".trim();
    return full.isEmpty ? "Unknown" : full;
  }
}

// List Users
/// ✅ Top-level parser
StaffListResponseModel staffListResponseModelFromJson(String str) =>
    StaffListResponseModel.fromJson(json.decode(str));

String staffListResponseModelToJson(StaffListResponseModel data) =>
    json.encode(data.toJson());

class StaffListResponseModel {
  final String? status;
  final String? message;
  final List<StaffData>? data;

  StaffListResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory StaffListResponseModel.fromJson(Map<String, dynamic> json) =>
      StaffListResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<StaffData>.from(
          json["data"].map((x) => StaffData.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

