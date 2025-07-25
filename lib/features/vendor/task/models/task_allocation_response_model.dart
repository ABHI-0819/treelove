import 'dart:convert';
/*
/// Helper for JSON serialization/deserialization
TaskAllocationResponseModel taskAllocationResponseModelFromJson(String str) =>
    TaskAllocationResponseModel.fromJson(json.decode(str));

String taskAllocationResponseModelToJson(TaskAllocationResponseModel data) =>
    json.encode(data.toJson());

class TaskAllocationResponseModel {
  final String fieldworker;
  final String services;
  final int quantity;

  TaskAllocationResponseModel({
    required this.fieldworker,
    required this.services,
    required this.quantity,
  });

  /// From JSON
  factory TaskAllocationResponseModel.fromJson(Map<String, dynamic> json) =>
      TaskAllocationResponseModel(
        fieldworker: json["fieldworker"] ?? '',
        services: json["services"] ?? '',
        quantity: json["quantity"] ?? 0,
      );

  /// To JSON
  Map<String, dynamic> toJson() => {
    "fieldworker": fieldworker,
    "services": services,
    "quantity": quantity,
  };
}

 */
import 'dart:convert';

///  Helper functions
TaskAllocationResponseModel taskAllocationResponseModelFromJson(String str) =>
    TaskAllocationResponseModel.fromJson(json.decode(str));

String taskAllocationResponseModelToJson(TaskAllocationResponseModel data) =>
    json.encode(data.toJson());

class TaskAllocationResponseModel {
  final String status;
  final String message;
  final TaskAllocationData? data;

  TaskAllocationResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory TaskAllocationResponseModel.fromJson(Map<String, dynamic> json) =>
      TaskAllocationResponseModel(
        status: json["status"] ?? "",
        message: json["message"] ?? "",
        data: json["data"] != null
            ? TaskAllocationData.fromJson(json["data"])
            : null,
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class TaskAllocationData {
  final String fieldworker;
  final String services;
  final int quantity;

  TaskAllocationData({
    required this.fieldworker,
    required this.services,
    required this.quantity,
  });

  factory TaskAllocationData.fromJson(Map<String, dynamic> json) =>
      TaskAllocationData(
        fieldworker: json["fieldworker"] ?? "",
        services: json["services"] ?? "",
        quantity: json["quantity"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
    "fieldworker": fieldworker,
    "services": services,
    "quantity": quantity,
  };
}
