import 'dart:convert';


/// Helper functions for the root model
GrievanceCategoryListResponse grievanceCategoryListResponseFromJson(String str) =>
    GrievanceCategoryListResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String grievanceCategoryListResponseToJson(GrievanceCategoryListResponse data) =>
    json.encode(data.toJson());

// -----------------------------------------------------------------------------
// 2. GrievanceCategoryListResponse Model (Root object)
// -----------------------------------------------------------------------------

class GrievanceCategoryListResponse {
  final String status;
  final String message;
  final List<GrievanceCategory> data;

  GrievanceCategoryListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GrievanceCategoryListResponse.fromJson(Map<String, dynamic> json) =>
      GrievanceCategoryListResponse(
        status: json["status"] as String,
        message: json["message"] as String,
        data: List<GrievanceCategory>.from(
          (json["data"] as List).map((x) => GrievanceCategory.fromJson(x as Map<String, dynamic>)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

// -----------------------------------------------------------------------------
// 1. GrievanceCategory Model (List item in 'data')
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