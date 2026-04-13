import 'dart:convert';

BlogResponse blogResponseFromJson(String str) =>
    BlogResponse.fromJson(json.decode(str));

String blogResponseToJson(BlogResponse data) => json.encode(data.toJson());

class BlogResponse {
  final String status;
  final String message;
  final List<BlogModel> data;

  BlogResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BlogResponse.fromJson(Map<String, dynamic> json) => BlogResponse(
        status: json["status"] ?? "",
        message: json["message"] ?? "",
        data: json["data"] != null
            ? List<BlogModel>.from(json["data"].map((x) => BlogModel.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class BlogModel {
  final String id;
  final String title;
  final String description;
  final String url;
  final String thumbnailImage;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  BlogModel({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.thumbnailImage,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) => BlogModel(
        id: json["id"] ?? "",
        title: json["title"] ?? "",
        description: json["description"] ?? "",
        url: json["url"] ?? "",
        thumbnailImage: json["thumbnail_image"] ?? "",
        isActive: json["is_active"] ?? false,
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : DateTime.now(),
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "url": url,
        "thumbnail_image": thumbnailImage,
        "is_active": isActive,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
