import 'dart:convert';
import 'package:geojson_vi/geojson_vi.dart';

///  Helper to parse JSON -> Model
ProjectAreasResponse projectAreasResponseFromJson(String str) =>
    ProjectAreasResponse.fromJson(json.decode(str));

///  Helper to convert Model -> JSON string
String projectAreasResponseToJson(ProjectAreasResponse data) =>
    json.encode(data.toJson());

///  Root Response
class ProjectAreasResponse {
  final String status;
  final String message;
  final List<ProjectAreaItem> data;

  ProjectAreasResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProjectAreasResponse.fromJson(Map<String, dynamic> json) =>
      ProjectAreasResponse(
        status: json['status'] ?? '',
        message: json['message'] ?? '',
        data: (json['data'] as List? ?? [])
            .map((e) => ProjectAreaItem.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.map((e) => e.toJson()).toList(),
  };
}

///  Individual Area Item
class ProjectAreaItem {
  final String id;
  final List<String> serviceTypes;
  final List<double> centroid; // [lng, lat]
  final GeoJSONPolygon? polygon; // parsed GeoJSON Polygon
  final String name;
  final String type;
  final int capacity;
  final String locationDescription;
  final String createdAt;
  final String updatedAt;
  final String projectId;
  final String? parentArea;
  final String createdBy;
  final String updatedBy;

  ProjectAreaItem({
    required this.id,
    required this.serviceTypes,
    required this.centroid,
    required this.polygon,
    required this.name,
    required this.type,
    required this.capacity,
    required this.locationDescription,
    required this.createdAt,
    required this.updatedAt,
    required this.projectId,
    this.parentArea,
    required this.createdBy,
    required this.updatedBy,
  });

  factory ProjectAreaItem.fromJson(Map<String, dynamic> json) {
    ///  Parse centroid
    final List<dynamic> centroidJson = json['centroid'] ?? [];
    final List<double> centroidParsed =
    centroidJson.map((e) => (e as num).toDouble()).toList();

    ///  Parse location GeoJSON (stored as String)
    GeoJSONPolygon? parsedPolygon;
    if (json['location'] != null && json['location'].isNotEmpty) {
      try {
        final locationStr = json['location'];
        final locationDecoded = jsonDecode(locationStr); // String → Map
        final geoFeature = GeoJSONFeature.fromJSON(jsonEncode(locationDecoded));
        if (geoFeature.geometry is GeoJSONPolygon) {
          parsedPolygon = geoFeature.geometry as GeoJSONPolygon;
        }
      } catch (e) {
        print("GeoJSON parse error: $e");
      }
    }

    return ProjectAreaItem(
      id: json['id'] ?? '',
      serviceTypes:
      (json['service_types'] as List? ?? []).map((e) => e.toString()).toList(),
      centroid: centroidParsed,
      polygon: parsedPolygon,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      capacity: json['capacity'] ?? 0,
      locationDescription: json['location_description'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      projectId: json['project'] ?? '',
      parentArea: json['parent_area'],
      createdBy: json['created_by'] ?? '',
      updatedBy: json['updated_by'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "service_types": serviceTypes,
    "centroid": centroid,
    "location": polygon?.toJSON(), // store parsed GeoJSON back
    "name": name,
    "type": type,
    "capacity": capacity,
    "location_description": locationDescription,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "project": projectId,
    "parent_area": parentArea,
    "created_by": createdBy,
    "updated_by": updatedBy,
  };

  ///  Helper: get polygon center
  List<double>? get polygonCenter {
    if (polygon != null) {
      final coords = polygon!.coordinates.first; // outer ring
      final latSum = coords.fold(0.0, (sum, p) => sum + p[1]);
      final lngSum = coords.fold(0.0, (sum, p) => sum + p[0]);
      return [lngSum / coords.length, latSum / coords.length];
    }
    return null;
  }

  ///  Helper: get service type as comma separated
  String get serviceTypeText => serviceTypes.join(", ");
}
