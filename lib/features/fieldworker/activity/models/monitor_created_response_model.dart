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
        data: MonitorData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class MonitorData {
  final List<String> plantation;
  final String monitoringDate;
  final String nextScheduledDate;
  final List<String> treeDiseases;
  final String weatherCondition;
  final String monitoringType;
  final String services;
  final Location location;
  final String remarks;
  final String treeHeight;
  final String treeHeightUnit;
  final String treeGirth;
  final String treeGirthUnit;
  final String canopySize;
  final String canopySizeUnit;
  final int treeAge;
  final String treeHealth;
  final String treeGrowth;

  MonitorData({
    required this.plantation,
    required this.monitoringDate,
    required this.nextScheduledDate,
    required this.treeDiseases,
    required this.weatherCondition,
    required this.monitoringType,
    required this.services,
    required this.location,
    required this.remarks,
    required this.treeHeight,
    required this.treeHeightUnit,
    required this.treeGirth,
    required this.treeGirthUnit,
    required this.canopySize,
    required this.canopySizeUnit,
    required this.treeAge,
    required this.treeHealth,
    required this.treeGrowth,
  });

  factory MonitorData.fromJson(Map<String, dynamic> json) => MonitorData(
    plantation: List<String>.from(json["plantation"].map((x) => x)),
    monitoringDate: json["monitoring_date"] ?? "",
    nextScheduledDate: json["next_scheduled_date"] ?? "",
    treeDiseases: List<String>.from(json["tree_diseases"].map((x) => x)),
    weatherCondition: json["weather_condition"] ?? "",
    monitoringType: json["monitoring_type"] ?? "",
    services: json["services"] ?? "",
    location: Location.fromJson(json["location"]),
    remarks: json["remarks"] ?? "",
    treeHeight: json["tree_height"] ?? "",
    treeHeightUnit: json["tree_height_unit"] ?? "",
    treeGirth: json["tree_girth"] ?? "",
    treeGirthUnit: json["tree_girth_unit"] ?? "",
    canopySize: json["canopy_size"] ?? "",
    canopySizeUnit: json["canopy_size_unit"] ?? "",
    treeAge: json["tree_age"] ?? 0,
    treeHealth: json["tree_health"] ?? "",
    treeGrowth: json["tree_growth"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "plantation": plantation,
    "monitoring_date": monitoringDate,
    "next_scheduled_date": nextScheduledDate,
    "tree_diseases": treeDiseases,
    "weather_condition": weatherCondition,
    "monitoring_type": monitoringType,
    "services": services,
    "location": location.toJson(),
    "remarks": remarks,
    "tree_height": treeHeight,
    "tree_height_unit": treeHeightUnit,
    "tree_girth": treeGirth,
    "tree_girth_unit": treeGirthUnit,
    "canopy_size": canopySize,
    "canopy_size_unit": canopySizeUnit,
    "tree_age": treeAge,
    "tree_health": treeHealth,
    "tree_growth": treeGrowth,
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
    coordinates:
    List<double>.from(json["coordinates"].map((x) => x.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": coordinates,
  };
}
