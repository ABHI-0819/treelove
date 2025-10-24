import 'dart:convert';
import 'package:flutter/foundation.dart';
/*
/// Helper functions for the root model
GrievanceResponse grievanceResponseFromJson(String str) =>
    GrievanceResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String grievanceResponseToJson(GrievanceResponse data) =>
    json.encode(data.toJson());

// -----------------------------------------------------------------------------
// 2. GrievanceResponse Model (Root object)
// -----------------------------------------------------------------------------

class GrievanceResponse {
  final String status;
  final String message;
  final GrievanceData data;

  GrievanceResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GrievanceResponse.fromJson(Map<String, dynamic> json) =>
      GrievanceResponse(
        status: json["status"] as String,
        message: json["message"] as String,
        data: GrievanceData.fromJson(json["data"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

// -----------------------------------------------------------------------------
// 1. GrievanceData Model (Nested 'data' object)
// -----------------------------------------------------------------------------

class GrievanceData {
  final String relatedObject;
  final int category;
  final String description;
  final String image;
  final String location;

  GrievanceData({
    required this.relatedObject,
    required this.category,
    required this.description,
    required this.image,
    required this.location,
  });

  factory GrievanceData.fromJson(Map<String, dynamic> json) => GrievanceData(
    relatedObject: json["related_object"] as String,
    category: json["category"] as int,
    description: json["description"] as String,
    image: json["image"] as String,
    location: json["location"] as String,
  );

  Map<String, dynamic> toJson() => {
    "related_object": relatedObject,
    "category": category,
    "description": description,
    "image": image,
    "location": location,
  };
}

 */
import 'dart:convert';
import 'package:flutter/foundation.dart';

/// Helper functions for the root model
GrievanceResponse grievanceResponseFromJson(String str) =>
    GrievanceResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String grievanceResponseToJson(GrievanceResponse data) =>
    json.encode(data.toJson());

// -----------------------------------------------------------------------------
// 3. GrievanceCategory Model (Reused/Defined)
// -----------------------------------------------------------------------------

class GrievanceCategory {
  final int id;
  final String name;
  final String description;
  final bool isActive;

  GrievanceCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
  });

  factory GrievanceCategory.fromJson(Map<String, dynamic> json) => GrievanceCategory(
    id: json["id"] as int,
    name: json["name"] as String,
    description: json["description"] as String,
    isActive: json["is_active"] as bool,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "is_active": isActive,
  };
}

// -----------------------------------------------------------------------------
// 2. GrievanceResponse Model (Root object - Unchanged structure)
// -----------------------------------------------------------------------------

class GrievanceResponse {
  final String status;
  final String message;
  final GrievanceData data;

  GrievanceResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GrievanceResponse.fromJson(Map<String, dynamic> json) =>
      GrievanceResponse(
        status: json["status"] as String,
        message: json["message"] as String,
        data: GrievanceData.fromJson(json["data"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

// -----------------------------------------------------------------------------
// 1. GrievanceData Model (Nested 'data' object - **Updated**)
// -----------------------------------------------------------------------------

class GrievanceData {
  final String id;
  final String user;
  final String? relatedObject; // Now nullable (null)
  final GrievanceCategory category; // Now a nested object
  final String description;
  final String? image; // Now nullable (null)
  final String? location; // Now nullable (null)
  final String status;
  final String statusDisplay;
  final String? assignedTo; // Now nullable (null)
  final String resolutionComment;
  final DateTime createdAt;
  final DateTime updatedAt;

  GrievanceData({
    required this.id,
    required this.user,
    this.relatedObject,
    required this.category,
    required this.description,
    this.image,
    this.location,
    required this.status,
    required this.statusDisplay,
    this.assignedTo,
    required this.resolutionComment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GrievanceData.fromJson(Map<String, dynamic> json) => GrievanceData(
    id: json["id"] as String,
    user: json["user"] as String,
    // Use 'as String?' for nullable fields
    relatedObject: json["related_object"] as String?,
    // Parse the nested category object
    category: GrievanceCategory.fromJson(json["category"] as Map<String, dynamic>),
    description: json["description"] as String,
    image: json["image"] as String?,
    location: json["location"] as String?,
    status: json["status"] as String,
    statusDisplay: json["status_display"] as String,
    assignedTo: json["assigned_to"] as String?,
    resolutionComment: json["resolution_comment"] as String,
    // Parse ISO 8601 strings into DateTime objects
    createdAt: DateTime.parse(json["created_at"] as String).toLocal(),
    updatedAt: DateTime.parse(json["updated_at"] as String).toLocal(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user,
    "related_object": relatedObject,
    "category": category.toJson(),
    "description": description,
    "image": image,
    "location": location,
    "status": status,
    "status_display": statusDisplay,
    "assigned_to": assignedTo,
    "resolution_comment": resolutionComment,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}