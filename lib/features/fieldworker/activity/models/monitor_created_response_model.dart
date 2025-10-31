import 'dart:convert';

MonitorResponse monitorResponseFromJson(String str) =>
    MonitorResponse.fromJson(json.decode(str));

String monitorResponseToJson(MonitorResponse data) =>
    json.encode(data.toJson());

class MonitorResponse {
  final String status;
  final String message;
  final MonitorData data;

  MonitorResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MonitorResponse.fromJson(Map<String, dynamic> json) =>
      MonitorResponse(
        status: json["status"] ?? "",
        message: json["message"] ?? "",
        // Check if data is null before parsing
        data: MonitorData.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class MonitorData {
  final String id; // 💡 NEW: Added 'id'
  final List<String> plantation;
  final TreeSpecies treeSpecies; // 💡 NEW: Added 'tree_species' object
  final String monitoringDate;
  final String nextScheduledDate;
  // 💡 REMOVED: 'tree_diseases', 'weather_condition', 'tree_height',
  // 'tree_height_unit', 'tree_girth', 'tree_girth_unit', 'canopy_size',
  // 'canopy_size_unit', 'tree_age', 'tree_health', 'tree_growth' - (Missing from API response)
  final String monitoringType;
  final String services;
  final Location location;
  final String remarks;
  final String thumbnail; // 💡 NEW: Added 'thumbnail'

  MonitorData({
    required this.id,
    required this.plantation,
    required this.treeSpecies,
    required this.monitoringDate,
    required this.nextScheduledDate,
    required this.monitoringType,
    required this.services,
    required this.location,
    required this.remarks,
    required this.thumbnail,
  });

  factory MonitorData.fromJson(Map<String, dynamic> json) => MonitorData(
    id: json["id"] ?? "", // Parsing 'id'
    plantation: List<String>.from(json["plantation"]?.map((x) => x) ?? []),
    treeSpecies: TreeSpecies.fromJson(json["tree_species"] ?? {}), // Parsing 'tree_species'
    monitoringDate: json["monitoring_date"] ?? "",
    nextScheduledDate: json["next_scheduled_date"] ?? "",
    monitoringType: json["monitoring_type"] ?? "",
    services: json["services"] ?? "",
    location: Location.fromJson(json["location"] ?? {}),
    remarks: json["remarks"] ?? "",
    thumbnail: json["thumbnail"] ?? "", // Parsing 'thumbnail'

    // Note: All fields present in your original model but missing
    // in the API response have been removed from this updated model.
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "plantation": List<dynamic>.from(plantation.map((x) => x)),
    "tree_species": treeSpecies.toJson(),
    "monitoring_date": monitoringDate,
    "next_scheduled_date": nextScheduledDate,
    "monitoring_type": monitoringType,
    "services": services,
    "location": location.toJson(),
    "remarks": remarks,
    "thumbnail": thumbnail,
  };
}

// 💡 NEW CLASS: TreeSpecies
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
    id: json["id"] ?? "",
    localName: json["local_name"] ?? "",
    image: json["image"] ?? "",
    scientificName: json["scientific_name"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "local_name": localName,
    "image": image,
    "scientific_name": scientificName,
  };
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    type: json["type"] ?? "",
    coordinates: List<double>.from(json["coordinates"]?.map((x) => x.toDouble()) ?? []),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
  };
}