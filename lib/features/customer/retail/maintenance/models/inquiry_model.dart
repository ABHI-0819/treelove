import 'dart:convert';

InquiryListResponse inquiryListResponseFromJson(String str) =>
    InquiryListResponse.fromJson(json.decode(str));

String inquiryListResponseToJson(InquiryListResponse data) =>
    json.encode(data.toJson());

class InquiryListResponse {
  final String status;
  final String message;
  final List<InquiryListItem> data;

  InquiryListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory InquiryListResponse.fromJson(Map<String, dynamic> json) =>
      InquiryListResponse(
        status: json["status"] ?? "",
        message: json["message"] ?? "",
        data: json["data"] == null
            ? []
            : List<InquiryListItem>.from(
                json["data"].map((x) => InquiryListItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class InquiryListItem {
  final String id;
  final String inquiryNumber;
  final String? fullName;
  final String? email;
  final String inquiryType;
  final String inquiryTypeDisplay;
  final String status;
  final String statusDisplay;
  final String urgencyLevel;
  final int itemsCount;
  final String? estimatedTotal;
  final DateTime createdAt;
  final DateTime submittedAt;

  InquiryListItem({
    required this.id,
    required this.inquiryNumber,
    this.fullName,
    this.email,
    required this.inquiryType,
    required this.inquiryTypeDisplay,
    required this.status,
    required this.statusDisplay,
    required this.urgencyLevel,
    required this.itemsCount,
    this.estimatedTotal,
    required this.createdAt,
    required this.submittedAt,
  });

  factory InquiryListItem.fromJson(Map<String, dynamic> json) => InquiryListItem(
        id: json["id"] ?? "",
        inquiryNumber: json["inquiry_number"] ?? "",
        fullName: json["full_name"],
        email: json["email"],
        inquiryType: json["inquiry_type"] ?? "",
        inquiryTypeDisplay: json["inquiry_type_display"] ?? "",
        status: json["status"] ?? "",
        statusDisplay: json["status_display"] ?? "",
        urgencyLevel: json["urgency_level"] ?? "",
        itemsCount: json["items_count"] ?? 0,
        estimatedTotal: json["estimated_total"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : DateTime.now(),
        submittedAt: json["submitted_at"] != null
            ? DateTime.parse(json["submitted_at"])
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "inquiry_number": inquiryNumber,
        "full_name": fullName,
        "email": email,
        "inquiry_type": inquiryType,
        "inquiry_type_display": inquiryTypeDisplay,
        "status": status,
        "status_display": statusDisplay,
        "urgency_level": urgencyLevel,
        "items_count": itemsCount,
        "estimated_total": estimatedTotal,
        "created_at": createdAt.toIso8601String(),
        "submitted_at": submittedAt.toIso8601String(),
      };
}
