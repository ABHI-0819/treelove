import 'dart:convert';
import 'dart:io';

class MonitorRequestModel {
  // Required
  final List<String> plantation;      // array<string> of plantation IDs
  final String monitoringDate;        // required
  final String services;              // uuid
  final Map<String, dynamic> location; // GeoJSON point

  // Optional
  final String? nextScheduledDate;
  final List<String>? treeDiseases;
  final String? weatherCondition;
  final String? monitoringType;
  final String? remarks;
  final double? treeHeight;
  final String? treeHeightUnit;       // ft, m, cm
  final double? treeGirth;
  final String? treeGirthUnit;        // ft, m, cm
  final double? canopySize;
  final String? canopySizeUnit;       // m2, ft2
  final int? treeAge;
  final String? treeHealth;           // healthy, good, better, require_attention, bad, worse, dead
  final String? treeGrowth;           // sapling, young, mature, half_grown, fully_grown
  final List<File> media;             // array<string> (file paths)

  MonitorRequestModel({
    required this.plantation,
    required this.monitoringDate,
    required this.services,
    required this.location,
    this.nextScheduledDate,
    this.treeDiseases,
    this.weatherCondition,
    this.monitoringType,
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

  /// Convert → JSON map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = {
      "plantation": plantation,
      "monitoring_date": monitoringDate,
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

    addIfNotNull("next_scheduled_date", nextScheduledDate);
    addIfNotNull("tree_diseases", treeDiseases);
    addIfNotNull("weather_condition", weatherCondition);
    addIfNotNull("monitoring_type", monitoringType);
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

  /// Convert → JSON string
  String toJsonString() => jsonEncode(toJson());

  /// Convert → multipart fields (all string values)
  Map<String, String> toFields() {
    final Map<String, String> fields = {
      "plantation": plantation.join(','),  // comma-separated
      "monitoring_date": monitoringDate,
      "services": services,
      "location": jsonEncode(location),
    };

    void addIfNotNull(String key, dynamic value) {
      if (value != null) {
        if (value is List && value.isNotEmpty) {
          fields[key] = value.join(','); // arrays → comma-separated
        } else {
          fields[key] = value.toString();
        }
      }
    }

    addIfNotNull("next_scheduled_date", nextScheduledDate);
    addIfNotNull("tree_diseases", treeDiseases);
    addIfNotNull("weather_condition", weatherCondition);
    addIfNotNull("monitoring_type", monitoringType);
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
