// To parse this JSON data, do
//
//     final plantedListResponseModel = plantedListResponseModelFromJson(jsonString);


import 'dart:convert';

PlantedListResponseModel plantedListResponseModelFromJson(String str) => PlantedListResponseModel.fromJson(json.decode(str));

String plantedListResponseModelToJson(PlantedListResponseModel data) => json.encode(data.toJson());

class PlantedListResponseModel {
  String status;
  String message;
  List<PlantedTreeModel> data;

  PlantedListResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PlantedListResponseModel.fromJson(Map<String, dynamic> json) => PlantedListResponseModel(
    status: json["status"],
    message: json["message"],
    data: List<PlantedTreeModel>.from(json["data"].map((x) => PlantedTreeModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}
/*
class PlantedTreeModel {
  String id;
  String? thumbnail;
  TreeSpeciesModel treeSpecies;
  dynamic nextMaintenanceDate;
  dynamic maintenanceServiceId;
  dynamic monitoringServiceId;
  LocationModel location;
  String? remarks;
  String createdAt;
  String updatedAt;
  String treeHeight;
  String treeHeightUnit;
  String treeGirth;
  String treeGirthUnit;
  dynamic canopySize;
  String canopySizeUnit;
  dynamic treeAge;
  String treeHealth;
  String treeGrowth;
  String plantationDate;
  String plantationType;
  bool isVerified;
  dynamic verifiedAt;
  String services;
  String vendor;
  String createdBy;
  String updatedBy;
  dynamic verifiedBy;
  List<dynamic> treeDiseases;

  PlantedTreeModel({
    required this.id,
    this.thumbnail,
    required this.treeSpecies,
    this.nextMaintenanceDate,
    this.maintenanceServiceId,
    this.monitoringServiceId,
    required this.location,
    this.remarks,
    required this.createdAt,
    required this.updatedAt,
    required this.treeHeight,
    required this.treeHeightUnit,
    required this.treeGirth,
    required this.treeGirthUnit,
    this.canopySize,
    required this.canopySizeUnit,
    this.treeAge,
    required this.treeHealth,
    required this.treeGrowth,
    required this.plantationDate,
    required this.plantationType,
    required this.isVerified,
    this.verifiedAt,
    required this.services,
    required this.vendor,
    required this.createdBy,
    required this.updatedBy,
    this.verifiedBy,
    required this.treeDiseases,
  });

  factory PlantedTreeModel.fromJson(Map<String, dynamic> json) => PlantedTreeModel(
    id: json["id"],
    thumbnail: json["thumbnail"],
    treeSpecies: TreeSpeciesModel.fromJson(json["tree_species"]),
    nextMaintenanceDate: json["next_maintenance_date"],
    maintenanceServiceId: json["maintenance_service_id"],
    monitoringServiceId: json["monitoring_service_id"],
    location: LocationModel.fromJson(json["location"]),
    remarks: json["remarks"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    treeHeight: json["tree_height"],
    treeHeightUnit: json["tree_height_unit"],
    treeGirth: json["tree_girth"],
    treeGirthUnit: json["tree_girth_unit"],
    canopySize: json["canopy_size"],
    canopySizeUnit: json["canopy_size_unit"],
    treeAge: json["tree_age"],
    treeHealth: json["tree_health"],
    treeGrowth: json["tree_growth"],
    plantationDate: json["plantation_date"],
    plantationType: json["plantation_type"],
    isVerified: json["is_verified"],
    verifiedAt: json["verified_at"],
    services: json["services"],
    vendor: json["vendor"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    verifiedBy: json["verified_by"],
    treeDiseases: List<dynamic>.from(json["tree_diseases"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "thumbnail": thumbnail,
    "tree_species": treeSpecies.toJson(),
    "next_maintenance_date": nextMaintenanceDate,
    "maintenance_service_id": maintenanceServiceId,
    "monitoring_service_id": monitoringServiceId,
    "location": location.toJson(),
    "remarks": remarks,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "tree_height": treeHeight,
    "tree_height_unit": treeHeightUnit,
    "tree_girth": treeGirth,
    "tree_girth_unit": treeGirthUnit,
    "canopy_size": canopySize,
    "canopy_size_unit": canopySizeUnit,
    "tree_age": treeAge,
    "tree_health": treeHealth,
    "tree_growth": treeGrowth,
    "plantation_date": plantationDate,
    "plantation_type": plantationType,
    "is_verified": isVerified,
    "verified_at": verifiedAt,
    "services": services,
    "vendor": vendor,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "verified_by": verifiedBy,
    "tree_diseases": List<dynamic>.from(treeDiseases.map((x) => x)),
  };
}

 */
class PlantedTreeModel {
  String id;
  String? thumbnail;
  TreeSpeciesModel treeSpecies;
  dynamic nextMaintenanceDate;
  dynamic maintenanceServiceId;
  dynamic monitoringServiceId;

  // 🆕 New fields
  String? fieldworkerName;
  String? maintenanceStatus;
  String? maintenanceStatusColor;
  dynamic maintenanceStatusDays;
  dynamic lastMaintainedDate;
  dynamic nextMonitoringDate;
  String? monitoringStatus;
  String? monitoringStatusColor;
  dynamic monitoringStatusDays;
  dynamic lastMonitoredDate;

  LocationModel location;
  String? remarks;
  String createdAt;
  String updatedAt;
  String treeHeight;
  String treeHeightUnit;
  String treeGirth;
  String treeGirthUnit;
  dynamic canopySize;
  String canopySizeUnit;
  dynamic treeAge;
  String treeHealth;
  String treeGrowth;
  String plantationDate;
  String plantationType;
  bool isVerified;
  dynamic verifiedAt;
  String services;
  String vendor;
  String createdBy;
  String updatedBy;
  dynamic verifiedBy;
  List<dynamic> treeDiseases;

  PlantedTreeModel({
    required this.id,
    this.thumbnail,
    required this.treeSpecies,
    this.nextMaintenanceDate,
    this.maintenanceServiceId,
    this.monitoringServiceId,
    this.fieldworkerName,
    this.maintenanceStatus,
    this.maintenanceStatusColor,
    this.maintenanceStatusDays,
    this.lastMaintainedDate,
    this.nextMonitoringDate,
    this.monitoringStatus,
    this.monitoringStatusColor,
    this.monitoringStatusDays,
    this.lastMonitoredDate,
    required this.location,
    this.remarks,
    required this.createdAt,
    required this.updatedAt,
    required this.treeHeight,
    required this.treeHeightUnit,
    required this.treeGirth,
    required this.treeGirthUnit,
    this.canopySize,
    required this.canopySizeUnit,
    this.treeAge,
    required this.treeHealth,
    required this.treeGrowth,
    required this.plantationDate,
    required this.plantationType,
    required this.isVerified,
    this.verifiedAt,
    required this.services,
    required this.vendor,
    required this.createdBy,
    required this.updatedBy,
    this.verifiedBy,
    required this.treeDiseases,
  });

  factory PlantedTreeModel.fromJson(Map<String, dynamic> json) => PlantedTreeModel(
    id: json["id"],
    thumbnail: json["thumbnail"],
    treeSpecies: TreeSpeciesModel.fromJson(json["tree_species"]),
    nextMaintenanceDate: json["next_maintenance_date"],
    maintenanceServiceId: json["maintenance_service_id"],
    monitoringServiceId: json["monitoring_service_id"],
    fieldworkerName: json["fieldworker_name"],
    maintenanceStatus: json["maintenance_status"],
    maintenanceStatusColor: json["maintenance_status_color"],
    maintenanceStatusDays: json["maintenance_status_days"],
    lastMaintainedDate: json["last_maintained_date"],
    nextMonitoringDate: json["next_monitoring_date"],
    monitoringStatus: json["monitoring_status"],
    monitoringStatusColor: json["monitoring_status_color"],
    monitoringStatusDays: json["monitoring_status_days"],
    lastMonitoredDate: json["last_monitored_date"],
    location: LocationModel.fromJson(json["location"]),
    remarks: json["remarks"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    treeHeight: json["tree_height"],
    treeHeightUnit: json["tree_height_unit"],
    treeGirth: json["tree_girth"],
    treeGirthUnit: json["tree_girth_unit"],
    canopySize: json["canopy_size"],
    canopySizeUnit: json["canopy_size_unit"],
    treeAge: json["tree_age"],
    treeHealth: json["tree_health"],
    treeGrowth: json["tree_growth"],
    plantationDate: json["plantation_date"],
    plantationType: json["plantation_type"],
    isVerified: json["is_verified"],
    verifiedAt: json["verified_at"],
    services: json["services"],
    vendor: json["vendor"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    verifiedBy: json["verified_by"],
    treeDiseases: List<dynamic>.from(json["tree_diseases"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "thumbnail": thumbnail,
    "tree_species": treeSpecies.toJson(),
    "next_maintenance_date": nextMaintenanceDate,
    "maintenance_service_id": maintenanceServiceId,
    "monitoring_service_id": monitoringServiceId,
    "fieldworker_name": fieldworkerName,
    "maintenance_status": maintenanceStatus,
    "maintenance_status_color": maintenanceStatusColor,
    "maintenance_status_days": maintenanceStatusDays,
    "last_maintained_date": lastMaintainedDate,
    "next_monitoring_date": nextMonitoringDate,
    "monitoring_status": monitoringStatus,
    "monitoring_status_color": monitoringStatusColor,
    "monitoring_status_days": monitoringStatusDays,
    "last_monitored_date": lastMonitoredDate,
    "location": location.toJson(),
    "remarks": remarks,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "tree_height": treeHeight,
    "tree_height_unit": treeHeightUnit,
    "tree_girth": treeGirth,
    "tree_girth_unit": treeGirthUnit,
    "canopy_size": canopySize,
    "canopy_size_unit": canopySizeUnit,
    "tree_age": treeAge,
    "tree_health": treeHealth,
    "tree_growth": treeGrowth,
    "plantation_date": plantationDate,
    "plantation_type": plantationType,
    "is_verified": isVerified,
    "verified_at": verifiedAt,
    "services": services,
    "vendor": vendor,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "verified_by": verifiedBy,
    "tree_diseases": List<dynamic>.from(treeDiseases.map((x) => x)),
  };

  // ✅ Helpers to format dates like "2 days ago"
  String get lastMaintainedAgo => _timeAgo(lastMaintainedDate);
  String get nextMonitoringAgo => _timeAgo(nextMonitoringDate);

  static String _timeAgo(String? dateStr) {
    if (dateStr == null) return "N/A";
    try {
      final date = DateTime.parse(dateStr);
      final diff = DateTime.now().difference(date);

      if (diff.inSeconds < 60) return "just now";
      if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
      if (diff.inHours < 24) return "${diff.inHours} hour${diff.inHours > 1 ? "s" : ""} ago";
      if (diff.inDays < 30) return "${diff.inDays} day${diff.inDays > 1 ? "s" : ""} ago";
      if (diff.inDays < 365) return "${(diff.inDays / 30).floor()} month${(diff.inDays / 30).floor() > 1 ? "s" : ""} ago";
      return "${(diff.inDays / 365).floor()} year${(diff.inDays / 365).floor() > 1 ? "s" : ""} ago";
    } catch (e) {
      return "Invalid date";
    }
  }
}


class LocationModel {
  String type;
  List<double> coordinates;

  LocationModel({
    required this.type,
    required this.coordinates,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    type: json["type"],
    coordinates: List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
  };
}

class TreeSpeciesModel {
  String id;
  String localName;
  dynamic image;
  String scientificName;

  TreeSpeciesModel({
    required this.id,
    required this.localName,
    this.image,
    required this.scientificName,
  });

  factory TreeSpeciesModel.fromJson(Map<String, dynamic> json) => TreeSpeciesModel(
    id: json["id"],
    localName: json["local_name"],
    image: json["image"],
    scientificName: json["scientific_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "local_name": localName,
    "image": image,
    "scientific_name": scientificName,
  };
}
