import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) => LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());

class LoginResponseModel {
  String status;
  String message;
  Data data;

  LoginResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  User user;
  Tokens tokens;

  Data({
    required this.user,
    required this.tokens,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    user: User.fromJson(json["user"]),
    tokens: Tokens.fromJson(json["tokens"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "tokens": tokens.toJson(),
  };
}

class Tokens {
  String access;
  String refresh;
  DateTime accessTokenExpires;
  DateTime refreshTokenExpires;

  Tokens({
    required this.access,
    required this.refresh,
    required this.accessTokenExpires,
    required this.refreshTokenExpires,
  });

  factory Tokens.fromJson(Map<String, dynamic> json) => Tokens(
    access: json["access"],
    refresh: json["refresh"],
    accessTokenExpires: DateTime.parse(json["access_token_expires"]),
    refreshTokenExpires: DateTime.parse(json["refresh_token_expires"]),
  );

  Map<String, dynamic> toJson() => {
    "access": access,
    "refresh": refresh,
    "access_token_expires": accessTokenExpires.toIso8601String(),
    "refresh_token_expires": refreshTokenExpires.toIso8601String(),
  };
}

class User {
  String id;
  String email;
  String ? phone;
  String countryCode;
  String oauthProvider;
  bool isEmailVerified;
  bool isPhoneVerified;
  bool isUserVerified;
  bool isActive;
  String group;
  String groupName;
  Profile ? profile;
  DateTime lastLogin;

  User({
    required this.id,
    required this.email,
     this.phone,
    required this.countryCode,
    required this.oauthProvider,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.isUserVerified,
    required this.isActive,
    required this.group,
    required this.groupName,
     this.profile,
    required this.lastLogin,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    email: json["email"],
    phone: json["phone"]??'',
    countryCode: json["country_code"],
    oauthProvider: json["oauth_provider"],
    isEmailVerified: json["is_email_verified"],
    isPhoneVerified: json["is_phone_verified"],
    isUserVerified: json["is_user_verified"],
    isActive: json["is_active"],
    group: json["group"],
    groupName: json["group_name"],
    profile:   json["profile"] != null ? Profile.fromJson(json["profile"]) : null,
    lastLogin: DateTime.parse(json["last_login"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "phone": phone,
    "country_code": countryCode,
    "oauth_provider": oauthProvider,
    "is_email_verified": isEmailVerified,
    "is_phone_verified": isPhoneVerified,
    "is_user_verified": isUserVerified,
    "is_active": isActive,
    "group": group,
    "group_name": groupName,
    "profile": profile!.toJson(),
    "last_login": lastLogin.toIso8601String(),
  };
}

class Profile {
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

  Profile({
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

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
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
