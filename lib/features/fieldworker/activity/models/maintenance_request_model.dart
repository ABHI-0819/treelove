import 'dart:convert';
import 'dart:io';
/*
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

 */

import 'dart:convert';
import 'dart:io';
/*
class MaintenanceRequestModel {
  // Required
  final List<String> plantation;
  final String maintenance_date;
  final List<String> maintenance_activity;
  final String services;
  final Map<String, dynamic> location;

  // Optional
  final String? next_scheduled_date;
  final List<String>? tree_diseases;
  final String? weather_condition;
  final String? maintenance_type;
  final String? remarks;
  final double? tree_height;
  final String? tree_height_unit;
  final double? tree_girth;
  final String? tree_girth_unit;
  final double? canopy_size;
  final String? canopy_size_unit;
  final int? tree_age;
  final String? tree_health;
  final String? tree_growth;
  final List<File> media;

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

  /// Convert model to JSON map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = {
      "plantation": plantation,
      "maintenance_date": maintenance_date,
      "maintenance_activity": maintenance_activity,
      "services": services,
      "location": location,
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
    addIfNotNull("tree_age", tree_age);
    addIfNotNull("tree_health", tree_health);
    addIfNotNull("tree_growth", tree_growth);

    // For the media files, you'd typically send these separately in a multipart request.
    // The JSON part would contain metadata, not the binary data itself.
    // So, we'll add the file paths to the JSON if they exist.
    if (media.isNotEmpty) {
      jsonMap["media"] = media.map((file) => file.path).toList();
    }

    return jsonMap;
  }

  /// Convert model to JSON string
  String toJsonString() => jsonEncode(toJson());
}

 */

import 'dart:convert';
import 'dart:io';
/*
class MaintenanceRequestModel {
  // Required
  final List<String> plantation;          // list of plantation IDs (UUIDs)
  final String maintenanceDate;           // required
  final List<String> maintenanceActivity; // required
  final String services;                  // UUID
  final Map<String, dynamic> location;    // { type: "Point", coordinates: [lat, lng] }

  // Optional
  final String? nextScheduledDate;
  final List<String>? treeDiseases;
  final String? weatherCondition;
  final String? maintenanceType;
  final String? remarks;
  final double? treeHeight;
  final String? treeHeightUnit;
  final double? treeGirth;
  final String? treeGirthUnit;
  final double? canopySize;
  final String? canopySizeUnit;
  final int? treeAge;
  final String? treeHealth;
  final String? treeGrowth;
  final List<File> media;

  MaintenanceRequestModel({
    required this.plantation,
    required this.maintenanceDate,
    required this.maintenanceActivity,
    required this.services,
    required this.location,
    this.nextScheduledDate,
    this.treeDiseases,
    this.weatherCondition,
    this.maintenanceType,
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
    required this.media,
  });

  /// ✅ Convert model → JSON Map (safe)
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = {
      "plantation": plantation,
      "maintenance_date": maintenanceDate,
      "maintenance_activity": maintenanceActivity,
      "services": services,
      "location": jsonEncode(location),
    };

    void addIfNotNull(String key, dynamic value) {
      if (value != null) {
        if (value is String && value.trim().isEmpty) return; // skip empty string
        if (value is List && value.isEmpty) return;          // skip empty list
        jsonMap[key] = value;
      }
    }

    addIfNotNull("next_scheduled_date", nextScheduledDate);
    addIfNotNull("tree_diseases", treeDiseases);
    addIfNotNull("weather_condition", weatherCondition);
    addIfNotNull("maintenance_type", maintenanceType);
    addIfNotNull("remarks", remarks);
    addIfNotNull("tree_height", treeHeight?.toString()); // ✅ convert double → string
    addIfNotNull("tree_height_unit", treeHeightUnit);
    addIfNotNull("tree_girth", treeGirth?.toString());
    addIfNotNull("tree_girth_unit", treeGirthUnit);
    addIfNotNull("canopy_size", canopySize?.toString());
    addIfNotNull("canopy_size_unit", canopySizeUnit);
    addIfNotNull("tree_age", treeAge?.toString());
    addIfNotNull("tree_health", treeHealth);
    addIfNotNull("tree_growth", treeGrowth);

    // ✅ Handle media safely (paths only)
    if (media.isNotEmpty) {
      jsonMap["media"] = media.map((file) => file.path).toList();
    }

    return jsonMap;
  }

  /// ✅ Convert model → JSON String
  String toJsonString() => jsonEncode(toJson());
}

 */
class MaintenanceRequestModel {
  // Required
  final List<String> plantation;          // list of plantation IDs (UUIDs)
  final String maintenanceDate;           // required
  final List<String> maintenanceActivity; // required
  final String services;                  // UUID
  final Map<String, dynamic> location;    // { type: "Point", coordinates: [lat, lng] }

  // Optional
  final String? nextScheduledDate;
  final List<String>? treeDiseases;
  final String? weatherCondition;
  final String? maintenanceType;
  final String? remarks;
  final double? treeHeight;
  final String? treeHeightUnit;
  final double? treeGirth;
  final String? treeGirthUnit;
  final double? canopySize;
  final String? canopySizeUnit;
  final int? treeAge;
  final String? treeHealth;
  final String? treeGrowth;
  final List<File> media;

  MaintenanceRequestModel({
    required this.plantation,
    required this.maintenanceDate,
    required this.maintenanceActivity,
    required this.services,
    required this.location,
    this.nextScheduledDate,
    this.treeDiseases,
    this.weatherCondition,
    this.maintenanceType,
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
    required this.media,
  });

  /// Convert model → JSON map (arrays kept as arrays)
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = {
      "plantation": plantation,
      "maintenance_date": maintenanceDate,
      "maintenance_activity": maintenanceActivity,
      "services": services,
      "location": jsonEncode(location), // keep stringified if backend requires
    };

    void addIfNotNull(String key, dynamic value) {
      if (value != null) {
        if (value is String && value.trim().isEmpty) return;
        if (value is List && value.isEmpty) return;
        jsonMap[key] = value;
      }
    }

    addIfNotNull("next_scheduled_date", nextScheduledDate);
    addIfNotNull("tree_diseases", treeDiseases);
    addIfNotNull("weather_condition", weatherCondition);
    addIfNotNull("maintenance_type", maintenanceType);
    addIfNotNull("remarks", remarks);
    addIfNotNull("tree_height", treeHeight?.toString());
    addIfNotNull("tree_height_unit", treeHeightUnit);
    addIfNotNull("tree_girth", treeGirth?.toString());
    addIfNotNull("tree_girth_unit", treeGirthUnit);
    addIfNotNull("canopy_size", canopySize?.toString());
    addIfNotNull("canopy_size_unit", canopySizeUnit);
    addIfNotNull("tree_age", treeAge?.toString());
    addIfNotNull("tree_health", treeHealth);
    addIfNotNull("tree_growth", treeGrowth);

    if (media.isNotEmpty) {
      jsonMap["media"] = media.map((file) => file.path).toList();
    }

    return jsonMap;
  }

  /// Convert model → JSON string
  String toJsonString() => jsonEncode(toJson());

  /// Convert model → fields for MultipartRequest (all values must be strings)
  Map<String, String> toFields() {
    final Map<String, String> fields = {
      "plantation": plantation.join(','),                 // comma-separated
      "maintenance_date": maintenanceDate,
      "maintenance_activity": maintenanceActivity.join(','), // comma-separated
      "services": services,
      "location": jsonEncode(location),
    };

    void addIfNotNull(String key, dynamic value) {
      if (value != null) {
        if (value is List && value.isNotEmpty) {
          fields[key] = value.join(','); // convert any list to comma-separated
        } else {
          fields[key] = value.toString();
        }
      }
    }

    addIfNotNull("next_scheduled_date", nextScheduledDate);
    addIfNotNull("tree_diseases", treeDiseases);
    addIfNotNull("weather_condition", weatherCondition);
    addIfNotNull("maintenance_type", maintenanceType);
    addIfNotNull("remarks", remarks);
    addIfNotNull("tree_height", treeHeight);
    addIfNotNull("tree_height_unit", treeHeightUnit);
    addIfNotNull("tree_girth", treeGirth);
    addIfNotNull("tree_girth_unit", treeGirthUnit);
    addIfNotNull("canopy_size", canopySize);
    addIfNotNull("canopy_size_unit", canopySizeUnit);
    addIfNotNull("tree_age", treeAge);
    addIfNotNull("tree_health", treeHealth);
    addIfNotNull("tree_growth", treeGrowth);

    return fields;
  }


}

