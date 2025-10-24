import 'dart:convert';
import 'package:flutter/foundation.dart';

/// Helper functions for the root model
MonitoringHistoryListResponse monitoringHistoryListResponseFromJson(String str) =>
    MonitoringHistoryListResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String monitoringHistoryListResponseToJson(MonitoringHistoryListResponse data) =>
    json.encode(data.toJson());

// -----------------------------------------------------------------------------
// 5. MonitoringHistoryListResponse Model (Root object)
// -----------------------------------------------------------------------------

class MonitoringHistoryListResponse {
  final String status;
  final String message;
  final List<MonitoringRecord> data;

  MonitoringHistoryListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MonitoringHistoryListResponse.fromJson(Map<String, dynamic> json) =>
      MonitoringHistoryListResponse(
        status: json["status"] as String,
        message: json["message"] as String,
        data: List<MonitoringRecord>.from(
          (json["data"] as List).map((x) => MonitoringRecord.fromJson(x as Map<String, dynamic>)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

// -----------------------------------------------------------------------------
// 4. MonitoringRecord Model
// -----------------------------------------------------------------------------

class MonitoringRecord {
  final String id;
  final List<String> plantation;
  final TreeSpecies treeSpecies;
  final DateTime monitoringDate;
  final DateTime nextScheduledDate;
  final String monitoringType;
  final String services;
  final Location location;
  final String remarks;
  final String? thumbnail;

  MonitoringRecord({
    required this.id,
    required this.plantation,
    required this.treeSpecies,
    required this.monitoringDate,
    required this.nextScheduledDate,
    required this.monitoringType,
    required this.services,
    required this.location,
    required this.remarks,
    this.thumbnail,
  });

  factory MonitoringRecord.fromJson(Map<String, dynamic> json) => MonitoringRecord(
    id: json["id"] as String,
    plantation: List<String>.from(json["plantation"] as List),
    treeSpecies: TreeSpecies.fromJson(json["tree_species"] as Map<String, dynamic>),
    monitoringDate: DateTime.parse(json["monitoring_date"] as String),
    nextScheduledDate: DateTime.parse(json["next_scheduled_date"] as String),
    monitoringType: json["monitoring_type"] as String,
    services: json["services"] as String,
    location: Location.fromJson(json["location"] as Map<String, dynamic>),
    remarks: json["remarks"] as String,
    thumbnail: json["thumbnail"] as String?,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "plantation": List<dynamic>.from(plantation.map((x) => x)),
    "tree_species": treeSpecies.toJson(),
    // Format date back to 'YYYY-MM-DD'
    "monitoring_date":
    "${monitoringDate.year.toString().padLeft(4, '0')}-${monitoringDate.month.toString().padLeft(2, '0')}-${monitoringDate.day.toString().padLeft(2, '0')}",
    "next_scheduled_date":
    "${nextScheduledDate.year.toString().padLeft(4, '0')}-${nextScheduledDate.month.toString().padLeft(2, '0')}-${nextScheduledDate.day.toString().padLeft(2, '0')}",
    "monitoring_type": monitoringType,
    "services": services,
    "location": location.toJson(),
    "remarks": remarks,
    "thumbnail": thumbnail,
  };
}

// -----------------------------------------------------------------------------
// 3. TreeSpecies Model (Reused)
// -----------------------------------------------------------------------------

class TreeSpecies {
  final String id;
  final String localName;
  final String image;
  final String scientificName;

  TreeSpecies({
    required this.id,
    required this.localName,
    required this.image,
    required this.scientificName,
  });

  factory TreeSpecies.fromJson(Map<String, dynamic> json) => TreeSpecies(
    id: json["id"] as String,
    localName: json["local_name"] as String,
    image: json["image"] as String,
    scientificName: json["scientific_name"] as String,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "local_name": localName,
    "image": image,
    "scientific_name": scientificName,
  };
}

// -----------------------------------------------------------------------------
// 2. Location Model
// -----------------------------------------------------------------------------

class Location {
  final String type;
  // GeoJSON standard: [longitude, latitude]
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    type: json["type"] as String,
    coordinates: List<double>.from(json["coordinates"].map((x) => x as double)),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
  };
}