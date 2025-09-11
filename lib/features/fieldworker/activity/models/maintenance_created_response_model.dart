/*
{
  "plantation": [
    "3fa85f64-5717-4562-b3fc-2c963f66afa6"
  ],
  "maintenance_date": "2025-08-10",
  "next_scheduled_date": "2025-08-10",
  "tree_diseases": [
    "3fa85f64-5717-4562-b3fc-2c963f66afa6"
  ],
  "maintenance_activity": [
    "3fa85f64-5717-4562-b3fc-2c963f66afa6"
  ],
  "weather_condition": "sunny",
  "maintenance_type": "single",
  "services": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "location": {
    "type": "Point",
    "coordinates": [
      12.9721,
      77.5933
    ]
  },
  "remarks": "string",
  "tree_height": "-1825.50",
  "tree_height_unit": "ft",
  "tree_girth": "9",
  "tree_girth_unit": "ft",
  "canopy_size": "5742.5",
  "canopy_size_unit": "m2",
  "tree_age": 2147483647,
  "tree_health": "healthy",
  "tree_growth": "sapling"
}
*/

import 'dart:convert';

MaintenanceResponse maintenanceResponseFromJson(String str) =>
    MaintenanceResponse.fromJson(json.decode(str));

String maintenanceResponseToJson(MaintenanceResponse data) =>
    json.encode(data.toJson());

class MaintenanceResponse {
  final List<String> plantation;
  final String maintenanceDate;
  final String? nextScheduledDate;
  final List<String> treeDiseases;
  final List<String> maintenanceActivity;
  final String? weatherCondition;
  final String? maintenanceType;
  final String services;
  final Location location;
  final String? remarks;
  final String? treeHeight;
  final String? treeHeightUnit;
  final String? treeGirth;
  final String? treeGirthUnit;
  final String? canopySize;
  final String? canopySizeUnit;
  final int? treeAge;
  final String? treeHealth;
  final String? treeGrowth;

  MaintenanceResponse({
    required this.plantation,
    required this.maintenanceDate,
    this.nextScheduledDate,
    required this.treeDiseases,
    required this.maintenanceActivity,
    this.weatherCondition,
    this.maintenanceType,
    required this.services,
    required this.location,
    this.remarks,
    this.treeHeight,
    this.treeHeightUnit,
    this.treeGirth,
    this.treeGirthUnit,
    this.canopySize,
    this.canopySizeUnit,
    this.treeAge,
    this.treeHealth,
    this.treeGrowth,
  });

  factory MaintenanceResponse.fromJson(Map<String, dynamic> json) {
    return MaintenanceResponse(
      plantation: _safeStringList(json['plantation']),
      maintenanceDate: json['maintenance_date']?.toString() ?? '',
      nextScheduledDate: json['next_scheduled_date']?.toString(),
      treeDiseases: _safeStringList(json['tree_diseases']),
      maintenanceActivity: _safeStringList(json['maintenance_activity']),
      weatherCondition: json['weather_condition']?.toString(),
      maintenanceType: json['maintenance_type']?.toString(),
      services: json['services']?.toString() ?? '',
      location: Location.fromJson(json['location'] ?? {}),
      remarks: json['remarks']?.toString(),
      treeHeight: json['tree_height']?.toString(),
      treeHeightUnit: json['tree_height_unit']?.toString(),
      treeGirth: json['tree_girth']?.toString(),
      treeGirthUnit: json['tree_girth_unit']?.toString(),
      canopySize: json['canopy_size']?.toString(),
      canopySizeUnit: json['canopy_size_unit']?.toString(),
      treeAge: _safeInt(json['tree_age']),
      treeHealth: json['tree_health']?.toString(),
      treeGrowth: json['tree_growth']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plantation': plantation,
      'maintenance_date': maintenanceDate,
      'next_scheduled_date': nextScheduledDate,
      'tree_diseases': treeDiseases,
      'maintenance_activity': maintenanceActivity,
      'weather_condition': weatherCondition,
      'maintenance_type': maintenanceType,
      'services': services,
      'location': location.toJson(),
      'remarks': remarks,
      'tree_height': treeHeight,
      'tree_height_unit': treeHeightUnit,
      'tree_girth': treeGirth,
      'tree_girth_unit': treeGirthUnit,
      'canopy_size': canopySize,
      'canopy_size_unit': canopySizeUnit,
      'tree_age': treeAge,
      'tree_health': treeHealth,
      'tree_growth': treeGrowth,
    };
  }

  static List<String> _safeStringList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  static int? _safeInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}

class Location {
  final String? type;
  final List<double> coordinates;

  Location({
    this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type']?.toString(),
      coordinates: _safeDoubleList(json['coordinates']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }

  static List<double> _safeDoubleList(dynamic value) {
    if (value is List) {
      return value.map((e) => double.tryParse(e.toString()) ?? 0.0).toList();
    }
    return [];
  }
}
