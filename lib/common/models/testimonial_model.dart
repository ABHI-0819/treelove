import 'dart:convert';

TestimonialResponse testimonialResponseFromJson(String str) =>
    TestimonialResponse.fromJson(json.decode(str));

String testimonialResponseToJson(TestimonialResponse data) =>
    json.encode(data.toJson());

class TestimonialResponse {
  final String status;
  final String message;
  final List<TestimonialModel> data;

  TestimonialResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TestimonialResponse.fromJson(Map<String, dynamic> json) =>
      TestimonialResponse(
        status: json["status"] ?? "",
        message: json["message"] ?? "",
        data: json["data"] != null
            ? List<TestimonialModel>.from(
                json["data"].map((x) => TestimonialModel.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class TestimonialModel {
  final String id;
  final String userName;
  final String userDesignation;
  final String message;
  final String userImage;
  final int rating;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String modifiedBy;

  TestimonialModel({
    required this.id,
    required this.userName,
    required this.userDesignation,
    required this.message,
    required this.userImage,
    required this.rating,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.modifiedBy,
  });

  factory TestimonialModel.fromJson(Map<String, dynamic> json) =>
      TestimonialModel(
        id: json["id"] ?? "",
        userName: json["user_name"] ?? "",
        userDesignation: json["user_designation"] ?? "",
        message: json["message"] ?? "",
        userImage: json["user_image"] ?? "",
        rating: json["rating"] ?? 0,
        isActive: json["is_active"] ?? false,
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : DateTime.now(),
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : DateTime.now(),
        createdBy: json["created_by"] ?? "",
        modifiedBy: json["modified_by"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_name": userName,
        "user_designation": userDesignation,
        "message": message,
        "user_image": userImage,
        "rating": rating,
        "is_active": isActive,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "created_by": createdBy,
        "modified_by": modifiedBy,
      };
}
