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
  String profile;
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
    required this.profile,
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
    profile: json["profile"],
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
    "profile": profile,
    "last_login": lastLogin.toIso8601String(),
  };
}
