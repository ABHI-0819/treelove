import 'dart:convert';


/// Converts a JSON string into a SatelliteMonitoringHistoryResponse object.
SatelliteMonitoringHistoryResponse satelliteMonitoringHistoryResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return SatelliteMonitoringHistoryResponse.fromJson(jsonData as Map<String, dynamic>);
}

/// Converts a SatelliteMonitoringHistoryResponse object into a JSON string.
String satelliteMonitoringHistoryResponseToJson(SatelliteMonitoringHistoryResponse data) {
  return json.encode(data.toJson());
}

// --- 1. Top-Level Response Model ---
class SatelliteMonitoringHistoryResponse {
  final String status;
  final String message;
  final List<SatelliteMonitorData> data;

  SatelliteMonitoringHistoryResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SatelliteMonitoringHistoryResponse.fromJson(Map<String, dynamic> json) {
    return SatelliteMonitoringHistoryResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((item) =>
          SatelliteMonitorData.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

// ----------------------------------------------------------------------
// --- 2. Data Item Model (Individual Monitoring Record) ---
class SatelliteMonitorData {
  final String id;
  // A list of UUIDs, or empty list
  final List<String> plantation;
  final String monitoringDate;
  final TreeSpecies treeSpecies;
  final Location location;
  // Represented as String for high precision decimal values
  final String canopySize;
  final String canopySizeUnit;
  final String confidence;
  final String treeHealth;
  // ndvi is null in the sample, so dynamic or double?
  final dynamic ndvi;
  final String modelType;
  final String createdAt;
  // Can be null
  final String? thumbnail;

  SatelliteMonitorData({
    required this.id,
    required this.plantation,
    required this.monitoringDate,
    required this.treeSpecies,
    required this.location,
    required this.canopySize,
    required this.canopySizeUnit,
    required this.confidence,
    required this.treeHealth,
    required this.ndvi,
    required this.modelType,
    required this.createdAt,
    this.thumbnail,
  });

  factory SatelliteMonitorData.fromJson(Map<String, dynamic> json) {
    return SatelliteMonitorData(
      id: json['id'] as String,
      plantation: (json['plantation'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      monitoringDate: json['monitoring_date'] as String,
      treeSpecies:
      TreeSpecies.fromJson(json['tree_species'] as Map<String, dynamic>),
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      canopySize: json['canopy_size'] as String,
      canopySizeUnit: json['canopy_size_unit'] as String,
      confidence: json['confidence'] as String,
      treeHealth: json['tree_health'] as String,
      ndvi: json['ndvi'],
      modelType: json['model_type'] as String,
      createdAt: json['created_at'] as String,
      thumbnail: json['thumbnail'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plantation': plantation,
      'monitoring_date': monitoringDate,
      'tree_species': treeSpecies.toJson(),
      'location': location.toJson(),
      'canopy_size': canopySize,
      'canopy_size_unit': canopySizeUnit,
      'confidence': confidence,
      'tree_health': treeHealth,
      'ndvi': ndvi,
      'model_type': modelType,
      'created_at': createdAt,
      'thumbnail': thumbnail,
    };
  }
}

// ----------------------------------------------------------------------
// --- 3. Tree Species Sub-Model ---
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

  factory TreeSpecies.fromJson(Map<String, dynamic> json) {
    return TreeSpecies(
      id: json['id'] as String,
      localName: json['local_name'] as String,
      image: json['image'] as String,
      scientificName: json['scientific_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'local_name': localName,
      'image': image,
      'scientific_name': scientificName,
    };
  }
}

// ----------------------------------------------------------------------
// --- 4. Location Sub-Model (GeoJSON Point) ---
class Location {
  final String type;
  // The JSON structure is [latitude, longitude]
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] as String,
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble()) // Cast to num then to double for safety
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}