import 'dart:convert';

// --- Global Serialization Helpers ---

GoogleLoginResponseModel googleLoginResponseModelFromJson(String str) =>
    GoogleLoginResponseModel.fromJson(json.decode(str));

String googleLoginResponseModelToJson(GoogleLoginResponseModel data) =>
    json.encode(data.toJson());

// --- Main Response Model ---

class GoogleLoginResponseModel {
  final String? status;
  final String? message;
  final AuthData? data;

  GoogleLoginResponseModel({this.status, this.message, this.data});

  factory GoogleLoginResponseModel.fromJson(Map<String, dynamic> json) =>
      GoogleLoginResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : AuthData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class AuthData {
  // Common status flags
  final bool? isNewUser;
  final bool? requiresGroupSelection;
  final bool? requiresOnboarding;

  // Fields present when group selection is required
  final UserInfo? userInfo;

  // Fields present when login/registration is fully complete
  final FullUser? user;
  final TokenData? tokens;

  AuthData({
    this.isNewUser,
    this.requiresGroupSelection,
    this.requiresOnboarding,
    this.userInfo,
    this.user,
    this.tokens,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) => AuthData(
        isNewUser: json["is_new_user"],
        requiresGroupSelection: json["requires_group_selection"],
        requiresOnboarding: json["requires_onboarding"],
        userInfo: json["user_info"] == null ? null : UserInfo.fromJson(json["user_info"]),
        user: json["user"] == null ? null : FullUser.fromJson(json["user"]),
        tokens: json["tokens"] == null ? null : TokenData.fromJson(json["tokens"]),
      );

  Map<String, dynamic> toJson() => {
        "is_new_user": isNewUser,
        "requires_group_selection": requiresGroupSelection,
        "requires_onboarding": requiresOnboarding,
        "user_info": userInfo?.toJson(),
        "user": user?.toJson(),
        "tokens": tokens?.toJson(),
      };
}

// --- Specific Data Models ---

/// Used during the initial 'Group Selection' phase
class UserInfo {
  final String? email;
  final String? name;
  final String? oauthUid;
  final String? oauthProvider;

  UserInfo({this.email, this.name, this.oauthUid, this.oauthProvider});

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        email: json["email"],
        name: json["name"],
        oauthUid: json["oauth_uid"],
        oauthProvider: json["oauth_provider"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "name": name,
        "oauth_uid": oauthUid,
        "oauth_provider": oauthProvider,
      };
}

/// The full user object returned after account creation/login
class FullUser {
  final String? id;
  final String? email;
  final String? phone;
  final String? countryCode;
  final String? oauthProvider;
  final bool? isEmailVerified;
  final bool? isPhoneVerified;
  final bool? isUserVerified;
  final bool? isActive;
  final String? group;
  final String? groupName;
  final UserProfile? profile;
  final DateTime? lastLogin;

  FullUser({
    this.id, this.email, this.phone, this.countryCode, this.oauthProvider,
    this.isEmailVerified, this.isPhoneVerified, this.isUserVerified,
    this.isActive, this.group, this.groupName, this.profile, this.lastLogin,
  });

  factory FullUser.fromJson(Map<String, dynamic> json) => FullUser(
        id: json["id"],
        email: json["email"],
        phone: json["phone"],
        countryCode: json["country_code"],
        oauthProvider: json["oauth_provider"],
        isEmailVerified: json["is_email_verified"],
        isPhoneVerified: json["is_phone_verified"],
        isUserVerified: json["is_user_verified"],
        isActive: json["is_active"],
        group: json["group"],
        groupName: json["group_name"],
        profile: json["profile"] == null ? null : UserProfile.fromJson(json["profile"]),
        lastLogin: json["last_login"] == null ? null : DateTime.parse(json["last_login"]),
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
        "profile": profile?.toJson(),
        "last_login": lastLogin?.toIso8601String(),
      };
}

class UserProfile {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? profilePicture;
  final String? bio;
  final DateTime? dateOfBirth;
  final String? legalName;
  final String? website;
  final String? panNumber;
  final String? gstNumber;
  final bool? receiveNotifications;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? userId;

  UserProfile({
    this.id, this.firstName, this.lastName, this.profilePicture, this.bio,
    this.dateOfBirth, this.legalName, this.website, this.panNumber,
    this.gstNumber, this.receiveNotifications, this.createdAt, this.updatedAt, this.userId,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        profilePicture: json["profile_picture"],
        bio: json["bio"],
        dateOfBirth: json["date_of_birth"] == null ? null : DateTime.parse(json["date_of_birth"]),
        legalName: json["legal_name"],
        website: json["website"],
        panNumber: json["_pan_number"],
        gstNumber: json["_gst_number"],
        receiveNotifications: json["receive_notifications"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        userId: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "profile_picture": profilePicture,
        "bio": bio,
        "date_of_birth": dateOfBirth?.toIso8601String(),
        "legal_name": legalName,
        "website": website,
        "_pan_number": panNumber,
        "_gst_number": gstNumber,
        "receive_notifications": receiveNotifications,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": userId,
      };
}

class TokenData {
  final String? access;
  final String? refresh;
  final DateTime? accessExpires;
  final DateTime? refreshExpires;

  TokenData({this.access, this.refresh, this.accessExpires, this.refreshExpires});

  factory TokenData.fromJson(Map<String, dynamic> json) => TokenData(
        access: json["access"],
        refresh: json["refresh"],
        accessExpires: json["access_token_expires"] == null ? null : DateTime.parse(json["access_token_expires"]),
        refreshExpires: json["refresh_token_expires"] == null ? null : DateTime.parse(json["refresh_token_expires"]),
      );

  Map<String, dynamic> toJson() => {
        "access": access,
        "refresh": refresh,
        "access_token_expires": accessExpires?.toIso8601String(),
        "refresh_token_expires": refreshExpires?.toIso8601String(),
      };
}