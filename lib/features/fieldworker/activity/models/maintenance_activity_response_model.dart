import 'dart:convert';

// Helper methods for easy JSON string serialization/deserialization
MaintenanceActivityResponseModel maintenanceActivityResponseModelFromJson(String str) =>
    MaintenanceActivityResponseModel.fromJson(json.decode(str));

String maintenanceActivityResponseModelToJson(MaintenanceActivityResponseModel data) =>
    json.encode(data.toJson());

class MaintenanceActivityResponseModel {
  final String status;
  final String message;
  final List<Activity> data;

  MaintenanceActivityResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MaintenanceActivityResponseModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> dataList = json['data'] as List<dynamic>;
    final List<Activity> activities = dataList
        .map((item) => Activity.fromJson(item as Map<String, dynamic>))
        .toList();

    return MaintenanceActivityResponseModel(
      status: json['status'] as String,
      message: json['message'] as String,
      data: activities,
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Activity {
  final String id;
  final String name;
  final String description;
  final DateTime timestamp;

  Activity({
    required this.id,
    required this.name,
    required this.description,
    required this.timestamp,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    // Convert DateTime back to an ISO 8601 string
    "timestamp": timestamp.toIso8601String(),
  };
}

