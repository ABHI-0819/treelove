/*
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
*/
import 'dart:convert';

// Helper methods
MaintenanceActivityResponseModel maintenanceActivityResponseModelFromJson(
        String str) =>
    MaintenanceActivityResponseModel.fromJson(json.decode(str));

String maintenanceActivityResponseModelToJson(
        MaintenanceActivityResponseModel data) =>
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

  factory MaintenanceActivityResponseModel.fromJson(
      Map<String, dynamic>? json) {
    if (json == null) {
      return MaintenanceActivityResponseModel(
        status: '',
        message: '',
        data: [],
      );
    }

    return MaintenanceActivityResponseModel(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data:
          (json['data'] as List?)?.map((e) => Activity.fromJson(e)).toList() ??
              [],
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.map((x) => x.toJson()).toList(),
      };
}

class Activity {
  final String id;
  final String name;
  final String description;
  final String? icon;
  final DateTime? timestamp;

  Activity({
    required this.id,
    required this.name,
    required this.description,
    this.icon,
    this.timestamp,
  });

  factory Activity.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Activity(
        id: '',
        name: '',
        description: '',
        icon: null,
        timestamp: null,
      );
    }

    return Activity(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      icon: json['icon']?.toString(),
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "icon": icon,
        "timestamp": timestamp?.toIso8601String(),
      };
}
