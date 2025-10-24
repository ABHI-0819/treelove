import 'dart:convert';

/// Helper functions for the root model
MaintenanceHistoryListResponse maintenanceHistoryListResponseFromJson(String str) =>
    MaintenanceHistoryListResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String maintenanceHistoryListResponseToJson(MaintenanceHistoryListResponse data) =>
    json.encode(data.toJson());

// -----------------------------------------------------------------------------
// 4. MaintenanceHistoryListResponse Model (Root object)
// -----------------------------------------------------------------------------

class MaintenanceHistoryListResponse {
  final String status;
  final String message;
  final List<MaintenanceRecord> data;

  MaintenanceHistoryListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MaintenanceHistoryListResponse.fromJson(Map<String, dynamic> json) =>
      MaintenanceHistoryListResponse(
        status: json["status"] as String,
        message: json["message"] as String,
        data: List<MaintenanceRecord>.from(
          (json["data"] as List).map((x) => MaintenanceRecord.fromJson(x as Map<String, dynamic>)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

// -----------------------------------------------------------------------------
// 3. MaintenanceRecord Model
// -----------------------------------------------------------------------------

class MaintenanceRecord {
  final String id;
  final List<String> plantation;
  final TreeSpecies treeSpecies;
  final DateTime maintenanceDate;
  final DateTime nextScheduledDate;
  final String remarks;
  final String treeHealth;
  final String? thumbnail;
  final List<MaintenanceActivity> maintenanceActivity;

  MaintenanceRecord({
    required this.id,
    required this.plantation,
    required this.treeSpecies,
    required this.maintenanceDate,
    required this.nextScheduledDate,
    required this.remarks,
    required this.treeHealth,
    this.thumbnail,
    required this.maintenanceActivity,
  });

  factory MaintenanceRecord.fromJson(Map<String, dynamic> json) => MaintenanceRecord(
    id: json["id"] as String,
    plantation: List<String>.from(json["plantation"] as List),
    treeSpecies: TreeSpecies.fromJson(json["tree_species"] as Map<String, dynamic>),
    // Parse date strings into DateTime objects
    maintenanceDate: DateTime.parse(json["maintenance_date"] as String),
    nextScheduledDate: DateTime.parse(json["next_scheduled_date"] as String),
    remarks: json["remarks"] as String,
    treeHealth: json["tree_health"] as String,
    thumbnail: json["thumbnail"] as String?,
    maintenanceActivity: List<MaintenanceActivity>.from(
      (json["maintenance_activity"] as List).map((x) => MaintenanceActivity.fromJson(x as Map<String, dynamic>)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "plantation": List<dynamic>.from(plantation.map((x) => x)),
    "tree_species": treeSpecies.toJson(),
    "maintenance_date":
    "${maintenanceDate.year.toString().padLeft(4, '0')}-${maintenanceDate.month.toString().padLeft(2, '0')}-${maintenanceDate.day.toString().padLeft(2, '0')}",
    "next_scheduled_date":
    "${nextScheduledDate.year.toString().padLeft(4, '0')}-${nextScheduledDate.month.toString().padLeft(2, '0')}-${nextScheduledDate.day.toString().padLeft(2, '0')}",
    "remarks": remarks,
    "tree_health": treeHealth,
    "thumbnail": thumbnail,
    "maintenance_activity":
    List<dynamic>.from(maintenanceActivity.map((x) => x.toJson())),
  };
}

// -----------------------------------------------------------------------------
// 2. TreeSpecies Model
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
// 1. MaintenanceActivity Model
// -----------------------------------------------------------------------------

class MaintenanceActivity {
  final String id;
  final String name;
  final String? icon;
  final String description;
  final DateTime timestamp;

  MaintenanceActivity({
    required this.id,
    required this.name,
    this.icon,
    required this.description,
    required this.timestamp,
  });

  factory MaintenanceActivity.fromJson(Map<String, dynamic> json) =>
      MaintenanceActivity(
        id: json["id"] as String,
        name: json["name"] as String,
        icon: json["icon"] as String?,
        description: json["description"] as String,
        // Parse the full ISO 8601 timestamp string
        timestamp: DateTime.parse(json["timestamp"] as String),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon": icon,
    "description": description,
    // Use toIso8601String() for consistent JSON output
    "timestamp": timestamp.toIso8601String(),
  };
}