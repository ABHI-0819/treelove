import 'dart:convert';
import 'package:geojson_vi/geojson_vi.dart';
/*
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

 */
import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geojson_vi/geojson_vi.dart';

/// Helper to parse JSON -> Model
ProjectAreasResponse projectAreasResponseFromJson(String str) =>
    ProjectAreasResponse.fromJson(json.decode(str));

/// Helper to convert Model -> JSON string
String projectAreasResponseToJson(ProjectAreasResponse data) =>
    json.encode(data.toJson());

/// Root Response
class ProjectAreasResponse {
  final String status;
  final String message;
  final List<ProjectAreaItem> data;

  ProjectAreasResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProjectAreasResponse.fromJson(Map<String, dynamic> json) {
    return ProjectAreasResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => ProjectAreaItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.map((e) => e.toJson()).toList(),
  };
}

/// Individual Area Item
class ProjectAreaItem {
  final String id;
  final List<String> serviceTypes;
  final LatLng centroid; // ✅ LatLng instead of List<double>
  final GeoJSONPolygon? polygon; // ✅ Raw GeoJSONPolygon
  final String name;
  final String type;
  final int capacity;
  final String locationDescription;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String projectId;
  final String? parentArea;
  final String createdBy;
  final String updatedBy;
  final List<TodayTask> todayTasks;

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
    required this.todayTasks,
  });

  factory ProjectAreaItem.fromJson(Map<String, dynamic> json) {
    // Parse centroid [lng, lat] → LatLng(lat, lng)
    final List<dynamic> centroidJson = json['centroid'] ?? [];
    final LatLng centroidParsed = centroidJson.length == 2
        ? LatLng(centroidJson[1], centroidJson[0])
        : LatLng(0, 0);

    // Parse location GeoJSON (stored as String)
    GeoJSONPolygon? parsedPolygon;
    if (json['location'] != null && json['location'].isNotEmpty) {
      try {
        final locationDecoded = jsonDecode(json['location']); // String → Map

        // ✅ Wrap Polygon into Feature for geojson_vi
        final featureWrapped = {
          "type": "Feature",
          "geometry": locationDecoded,
          "properties": {}
        };

        final geoFeature = GeoJSONFeature.fromJSON(jsonEncode(featureWrapped));
        if (geoFeature.geometry is GeoJSONPolygon) {
          parsedPolygon = geoFeature.geometry as GeoJSONPolygon;
        }
      } catch (e) {
        print("GeoJSON parse error: $e");
      }
    }

    return ProjectAreaItem(
      id: json['id'] ?? '',
      serviceTypes: (json['service_types'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      centroid: centroidParsed,
      polygon: parsedPolygon,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      capacity: json['capacity'] ?? 0,
      locationDescription: json['location_description'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      projectId: json['project'] ?? '',
      parentArea: json['parent_area'],
      createdBy: json['created_by'] ?? '',
      updatedBy: json['updated_by'] ?? '',
      todayTasks: (json['today_tasks'] as List? ?? [])
          .map((e) => TodayTask.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "service_types": serviceTypes,
    "centroid": [centroid.longitude, centroid.latitude],
    "location": polygon?.toJSON(), // store parsed GeoJSON back
    "name": name,
    "type": type,
    "capacity": capacity,
    "location_description": locationDescription,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "project": projectId,
    "parent_area": parentArea,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "today_tasks": todayTasks.map((e) => e.toJson()).toList(),
  };

  /// ✅ Helper: convert GeoJSON polygon → LatLng list for flutter_map
  List<LatLng> get polygonLatLngs {
    if (polygon == null) return [];
    final coords = polygon!.coordinates.first; // outer ring
    return coords.map((p) => LatLng(p[1], p[0])).toList();
  }

  /// ✅ Helper: polygon center (fallback if API centroid is missing)
  LatLng get effectiveCenter =>
      centroid == const LatLng(0, 0) ? (polygonCenter ?? LatLng(0, 0)) : centroid;

  LatLng? get polygonCenter {
    if (polygon != null) {
      final coords = polygon!.coordinates.first;
      final latSum = coords.fold(0.0, (sum, p) => sum + p[1]);
      final lngSum = coords.fold(0.0, (sum, p) => sum + p[0]);
      return LatLng(latSum / coords.length, lngSum / coords.length);
    }
    return null;
  }

  /// Helper: readable service types
  String get serviceTypeText => serviceTypes.join(", ");
}

/// Today Task
class TodayTask {
  final String serviceType;
  final String startDate;
  final String endDate;
  final int totalTrees;
  final int expectedToday;
  final int completedToday;

  TodayTask({
    required this.serviceType,
    required this.startDate,
    required this.endDate,
    required this.totalTrees,
    required this.expectedToday,
    required this.completedToday,
  });

  factory TodayTask.fromJson(Map<String, dynamic> json) {
    return TodayTask(
      serviceType: json['service_type'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      totalTrees: json['total_trees'] ?? 0,
      expectedToday: json['expected_today'] ?? 0,
      completedToday: json['completed_today'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "service_type": serviceType,
    "start_date": startDate,
    "end_date": endDate,
    "total_trees": totalTrees,
    "expected_today": expectedToday,
    "completed_today": completedToday,
  };
}



