import 'dart:convert';
import 'package:flutter/foundation.dart'; // Optional: for @immutable
/*
/// Helper functions for the root model
GrievanceListResponse grievanceListResponseFromJson(String str) =>
    GrievanceListResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String grievanceListResponseToJson(GrievanceListResponse data) =>
    json.encode(data.toJson());

// -----------------------------------------------------------------------------
// 3. GrievanceListResponse Model (Root object)
// -----------------------------------------------------------------------------

class GrievanceListResponse {
  final String status;
  final String message;
  final List<GrievanceRecord> data;

  GrievanceListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GrievanceListResponse.fromJson(Map<String, dynamic> json) =>
      GrievanceListResponse(
        status: json["status"] as String,
        message: json["message"] as String,
        data: List<GrievanceRecord>.from(
          (json["data"] as List).map((x) => GrievanceRecord.fromJson(x as Map<String, dynamic>)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

// -----------------------------------------------------------------------------
// 2. GrievanceRecord Model (Item in the 'data' list)
// -----------------------------------------------------------------------------

class GrievanceRecord {
  final String id;
  final String user;
  final String relatedObject;
  final GrievanceCategory category;
  final String description;
  final String image;
  final String location;
  final String status;
  final String statusDisplay;
  final String? assignedTo; // String or null
  final String? resolutionComment; // String or null
  final DateTime createdAt;
  final DateTime updatedAt;

  GrievanceRecord({
    required this.id,
    required this.user,
    required this.relatedObject,
    required this.category,
    required this.description,
    required this.image,
    required this.location,
    required this.status,
    required this.statusDisplay,
    this.assignedTo,
    this.resolutionComment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GrievanceRecord.fromJson(Map<String, dynamic> json) => GrievanceRecord(
    id: json["id"] as String,
    user: json["user"] as String,
    relatedObject: json["related_object"] as String,
    category: GrievanceCategory.fromJson(json["category"] as Map<String, dynamic>),
    description: json["description"] as String,
    image: json["image"] as String,
    location: json["location"] as String,
    status: json["status"] as String,
    statusDisplay: json["status_display"] as String,
    assignedTo: json["assigned_to"] as String?,
    resolutionComment: json["resolution_comment"] as String?,
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

// -----------------------------------------------------------------------------
// 1. GrievanceCategory Model (Nested object)
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

 */
import 'dart:convert';

/// Helper functions for the root model
GrievanceListResponse grievanceListResponseFromJson(String str) =>
    GrievanceListResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String grievanceListResponseToJson(GrievanceListResponse data) =>
    json.encode(data.toJson());

// -----------------------------------------------------------------------------
// 3. GrievanceListResponse Model (Root object)
// -----------------------------------------------------------------------------

class GrievanceListResponse {
  final String status;
  final String message;
  final List<GrievanceRecord> data;

  GrievanceListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GrievanceListResponse.fromJson(Map<String, dynamic> json) =>
      GrievanceListResponse(
        status: json["status"] as String,
        message: json["message"] as String,
        data: List<GrievanceRecord>.from(
          (json["data"] as List).map(
                (x) => GrievanceRecord.fromJson(x as Map<String, dynamic>),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

// -----------------------------------------------------------------------------
// 2. GrievanceRecord Model (Item in the 'data' list)
// -----------------------------------------------------------------------------

class GrievanceRecord {
  final String id;
  final String user;
  final String? relatedObject;
  final GrievanceCategory category;
  final String description;
  final String? image;
  final String? location;
  final String status;
  final String statusDisplay;
  final String? assignedTo;
  final String? resolutionComment;
  final DateTime createdAt;
  final DateTime updatedAt;

  GrievanceRecord({
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
    this.resolutionComment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GrievanceRecord.fromJson(Map<String, dynamic> json) => GrievanceRecord(
    id: json["id"] as String,
    user: json["user"] as String,
    relatedObject: json["related_object"] as String?,
    category:
    GrievanceCategory.fromJson(json["category"] as Map<String, dynamic>),
    description: json["description"] as String,
    image: json["image"] as String?,
    location: json["location"] as String?,
    status: json["status"] as String,
    statusDisplay: json["status_display"] as String,
    assignedTo: json["assigned_to"] as String?,
    resolutionComment: json["resolution_comment"] as String?,
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

// -----------------------------------------------------------------------------
// 1. GrievanceCategory Model (Nested object)
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

  factory GrievanceCategory.fromJson(Map<String, dynamic> json) =>
      GrievanceCategory(
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
