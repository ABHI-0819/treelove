import 'dart:convert';
import 'package:intl/intl.dart';

ProfileResponseModel profileResponseModelFromJson(String str) =>
    ProfileResponseModel.fromJson(json.decode(str));

String profileResponseModelToJson(ProfileResponseModel data) =>
    json.encode(data.toJson());

class ProfileResponseModel {
  final String status;
  final String message;
  final ProfileData? data;

  ProfileResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ProfileResponseModel(
        status: '',
        message: '',
        data: null,
      );
    }

    return ProfileResponseModel(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: json['data'] is Map<String, dynamic>
          ? ProfileData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class ProfileData {
  final String id;
  final String user;
  final String firstName;
  final String lastName;
  final String? profilePicture;
  final String bio;
  final DateTime? dateOfBirth;
  final String legalName;
  final String website;
  final String? panNumber;
  final String? gstNumber;
  final bool receiveNotifications;
  final String? createdBy;
  final String? modifiedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProfileData({
    required this.id,
    required this.user,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
    required this.bio,
    required this.dateOfBirth,
    required this.legalName,
    required this.website,
    required this.panNumber,
    required this.gstNumber,
    required this.receiveNotifications,
    required this.createdBy,
    required this.modifiedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileData.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ProfileData.empty();
    }

    return ProfileData(
      id: json['id']?.toString() ?? '',
      user: json['user']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      profilePicture: json['profile_picture']?.toString(),
      bio: json['bio']?.toString() ?? '',
      dateOfBirth: _safeDate(json['date_of_birth']),
      legalName: json['legal_name']?.toString() ?? '',
      website: json['website']?.toString() ?? '',
      panNumber: json['pan_number']?.toString(),
      gstNumber: json['gst_number']?.toString(),
      receiveNotifications: _safeBool(json['receive_notifications']),
      createdBy: json['created_by']?.toString(),
      modifiedBy: json['modified_by']?.toString(),
      createdAt: _safeDate(json['created_at']),
      updatedAt: _safeDate(json['updated_at']),
    );
  }

  /// Prevents DateTime parse crash
  static DateTime? _safeDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  /// Prevents bool type crash
  static bool _safeBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
  }

  /// Empty fallback object
  factory ProfileData.empty() {
    return ProfileData(
      id: '',
      user: '',
      firstName: '',
      lastName: '',
      profilePicture: null,
      bio: '',
      dateOfBirth: null,
      legalName: '',
      website: '',
      panNumber: null,
      gstNumber: null,
      receiveNotifications: false,
      createdBy: null,
      modifiedBy: null,
      createdAt: null,
      updatedAt: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'first_name': firstName,
      'last_name': lastName,
      'profile_picture': profilePicture,
      'bio': bio,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'legal_name': legalName,
      'website': website,
      'pan_number': panNumber,
      'gst_number': gstNumber,
      'receive_notifications': receiveNotifications,
      'created_by': createdBy,
      'modified_by': modifiedBy,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Useful for UI
  String get fullName {
    return "$firstName $lastName".trim();
  }

  String get formattedDateOfBirth {
    if (dateOfBirth == null) return '';
    return DateFormat('dd MMM yyyy').format(dateOfBirth!);
  }
}
