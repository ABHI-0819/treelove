import 'dart:convert';
import 'dart:io';

class MaintenanceRequestModel {
  // Required
  final List<String> plantation; // UUID array
  final String maintenance_date; // date
  final List<String> maintenance_activity; // UUID array
  final String services; // UUID
  final Map<String, dynamic> location; // { type: "Point", coordinates: [lat, lng] }

  // Optional
  final String? next_scheduled_date; // date or null
  final List<String>? tree_diseases; // UUID array
  final String? weather_condition; // enum or blank
  final String? maintenance_type; // enum or blank
  final String? remarks;
  final String? tree_height; // decimal
  final String? tree_height_unit; // enum
  final String? tree_girth; // decimal
  final String? tree_girth_unit; // enum
  final String? canopy_size; // decimal
  final String? canopy_size_unit; // m2 | ft2
  final int? tree_age;
  final String? tree_health; // enum
  final String? tree_growth; // enum
  final List<File> media; // binary files

  MaintenanceRequestModel({
    required this.plantation,
    required this.maintenance_date,
    this.next_scheduled_date,
    this.tree_diseases,
    required this.maintenance_activity,
    this.weather_condition,
    this.maintenance_type,
    required this.services,
    required this.location,
    this.remarks,
    this.tree_height,
    this.tree_height_unit,
    this.tree_girth,
    this.tree_girth_unit,
    this.canopy_size,
    this.canopy_size_unit,
    this.tree_age,
    this.tree_health,
    this.tree_growth,
    required this.media,
  });

  /// Convert model to JSON (for multipart fields)
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = {
      "plantation": plantation,
      "maintenance_date": maintenance_date,
      "maintenance_activity": maintenance_activity,
      "services": services,
      "location": jsonEncode(location),
    };

    void addIfNotNull(String key, dynamic value) {
      if (value != null) {
        if (value is String && value.trim().isEmpty) return;
        if (value is List && value.isEmpty) return;
        jsonMap[key] = value;
      }
    }

    addIfNotNull("next_scheduled_date", next_scheduled_date);
    addIfNotNull("tree_diseases", tree_diseases);
    addIfNotNull("weather_condition", weather_condition);
    addIfNotNull("maintenance_type", maintenance_type);
    addIfNotNull("remarks", remarks);
    addIfNotNull("tree_height", tree_height);
    addIfNotNull("tree_height_unit", tree_height_unit);
    addIfNotNull("tree_girth", tree_girth);
    addIfNotNull("tree_girth_unit", tree_girth_unit);
    addIfNotNull("canopy_size", canopy_size);
    addIfNotNull("canopy_size_unit", canopy_size_unit);
    addIfNotNull("tree_age", tree_age?.toString());
    addIfNotNull("tree_health", tree_health);
    addIfNotNull("tree_growth", tree_growth);

    return jsonMap;
  }

  /// Convert model to JSON string
  String toJsonString() => jsonEncode(toJson());
}
