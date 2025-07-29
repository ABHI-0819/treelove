import 'package:geojson_vi/geojson_vi.dart'; // Make sure to add geojson_vi to pubspec.yaml
import 'dart:convert';

/*
/// Converts a JSON string to a [ProjectListResponse] object.
ProjectListResponse projectListResponseFromJson(String str) =>
    ProjectListResponse.fromJson(json.decode(str) as Map<String, dynamic>);

/// Converts a [ProjectListResponse] object to a JSON string.
String projectListResponseToJson(ProjectListResponse data) =>
    json.encode(data.toJson());

///  Root response for project list
class ProjectListResponse {
  final String status;
  final String message;
  final List<ProjectItem> data;

  ProjectListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProjectListResponse.fromJson(Map<String, dynamic> json) =>
      ProjectListResponse(
        status: json["status"] ?? '',
        message: json["message"] ?? '',
        data: (json["data"] as List? ?? [])
            .map((x) => ProjectItem.fromJson(x))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.map((e) => e.toJson()).toList(),
  };

  ///  Helper: Get only project names
  List<String> get projectNames => data.map((p) => p.name).toList();

  ///  Helper: Total number of areas across all projects
  int get totalAreas =>
      data.fold(0, (sum, project) => sum + project.areas.length);
}

///  Individual Project Item
class ProjectItem {
  final String id;
  final String name;
  final String type;
  final String category;
  final String description;
  final String? image;
  final String? scopeOfWork;
  final String contractValue;
  final bool gstApplicable;
  final String gstPercentage;
  final String totalAmountPaid;
  final String? paymentTerms;
  final String? timeline;
  final String startDate;
  final String endDate;
  final String createdAt;
  final String updatedAt;
  final String status;
  final String currency;
  final String createdBy;
  final String updatedBy;
  final List<dynamic> users;
  final List<ProjectArea> areas;

  ProjectItem({
    required this.id,
    required this.name,
    required this.type,
    required this.category,
    required this.description,
    required this.image,
    required this.scopeOfWork,
    required this.contractValue,
    required this.gstApplicable,
    required this.gstPercentage,
    required this.totalAmountPaid,
    required this.paymentTerms,
    required this.timeline,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.currency,
    required this.createdBy,
    required this.updatedBy,
    required this.users,
    required this.areas,
  });

  factory ProjectItem.fromJson(Map<String, dynamic> json) => ProjectItem(
    id: json["id"] ?? '',
    name: json["name"] ?? '',
    type: json["type"] ?? '',
    category: json["category"] ?? '',
    description: json["description"] ?? '',
    image: json["image"],
    scopeOfWork: json["scope_of_work"],
    contractValue: json["contract_value"] ?? '',
    gstApplicable: json["gst_applicable"] ?? false,
    gstPercentage: json["gst_percentage"] ?? '',
    totalAmountPaid: json["total_amount_paid"] ?? '',
    paymentTerms: json["payment_terms"],
    timeline: json["timeline"],
    startDate: json["start_date"] ?? '',
    endDate: json["end_date"] ?? '',
    createdAt: json["created_at"] ?? '',
    updatedAt: json["updated_at"] ?? '',
    status: json["status"] ?? '',
    currency: json["currency"] ?? '',
    createdBy: json["created_by"] ?? '',
    updatedBy: json["updated_by"] ?? '',
    users: json["users"] ?? [],
    areas: (json["areas"] as List? ?? [])
        .map((x) => ProjectArea.fromJson(x))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
    "category": category,
    "description": description,
    "image": image,
    "scope_of_work": scopeOfWork,
    "contract_value": contractValue,
    "gst_applicable": gstApplicable,
    "gst_percentage": gstPercentage,
    "total_amount_paid": totalAmountPaid,
    "payment_terms": paymentTerms,
    "timeline": timeline,
    "start_date": startDate,
    "end_date": endDate,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "status": status,
    "currency": currency,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "users": users,
    "areas": areas.map((e) => e.toJson()).toList(),
  };

  ///  Helper: total area count in this project
  int get areaCount => areas.length;

  ///  Helper: Total capacity across all areas
  int get totalCapacity =>
      areas.fold(0, (sum, area) => sum + area.capacity);
}

///  Project Area Model with GeoJSON support
class ProjectArea {
  final String id;
  final String name;
  final String type;
  final int capacity;
  final GeoJSONPolygon? polygon; // parsed GeoJSON Polygon
  final String createdAt;
  final String projectId;
  final String? parentArea;

  ProjectArea({
    required this.id,
    required this.name,
    required this.type,
    required this.capacity,
    required this.polygon,
    required this.createdAt,
    required this.projectId,
    this.parentArea,
  });

  factory ProjectArea.fromJson(Map<String, dynamic> json) {
    GeoJSONPolygon? parsedPolygon;
    try {
      final locationJson = json["location"];
      if (locationJson != null) {
        final geoFeature = GeoJSONFeature.fromJSON(jsonEncode(locationJson));
        if (geoFeature.geometry is GeoJSONPolygon) {
          parsedPolygon = geoFeature.geometry as GeoJSONPolygon;
        }
      }
    } catch (e) {
      print("GeoJSON parse error: $e");
    }

    return ProjectArea(
      id: json["id"] ?? '',
      name: json["name"] ?? '',
      type: json["type"] ?? '',
      capacity: json["capacity"] ?? 0,
      polygon: parsedPolygon,
      createdAt: json["created_at"] ?? '',
      projectId: json["project"] ?? '',
      parentArea: json["parent_area"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
    "capacity": capacity,
    "location": polygon?.toJSON(),
    "created_at": createdAt,
    "project": projectId,
    "parent_area": parentArea,
  };

  ///  Helper: get coordinates
  List<List<List<double>>>? get coordinates => polygon?.coordinates;

  ///  Helper: get approx center of polygon
  List<double>? get polygonCenter {
    if (polygon != null) {
      final coords = polygon!.coordinates.first; // outer ring
      final latSum = coords.fold(0.0, (sum, p) => sum + p[1]);
      final lngSum = coords.fold(0.0, (sum, p) => sum + p[0]);
      return [lngSum / coords.length, latSum / coords.length];
    }
    return null;
  }
}

 */

import 'dart:convert';
import 'package:geojson_vi/geojson_vi.dart';

/// Parse response
ProjectListResponse projectListResponseFromJson(String str) =>
    ProjectListResponse.fromJson(json.decode(str));

String projectListResponseToJson(ProjectListResponse data) =>
    json.encode(data.toJson());

/// ✅ Root response for project list
class ProjectListResponse {
  final String status;
  final String message;
  final List<ProjectItem> data;

  ProjectListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProjectListResponse.fromJson(Map<String, dynamic> json) =>
      ProjectListResponse(
        status: json["status"] ?? '',
        message: json["message"] ?? '',
        data: (json["data"] as List? ?? [])
            .map((x) => ProjectItem.fromJson(x))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.map((e) => e.toJson()).toList(),
  };

  /// Helper: Get only project names
  List<String> get projectNames => data.map((p) => p.name).toList();

  /// Helper: Total areas count across all projects
  int get totalAreas =>
      data.fold(0, (sum, project) => sum + project.areas.length);
}

/// ✅ Individual Project Item
class ProjectItem {
  final String id;
  final String name;
  final String type;
  final String category;
  final String description;
  final String? image;
  final String? scopeOfWork;
  final String contractValue;
  final bool gstApplicable;
  final String gstPercentage;
  final String totalAmountPaid;
  final String? paymentTerms;
  final String? timeline;
  final String startDate;
  final String endDate;
  final String createdAt;
  final String updatedAt;
  final String status;
  final String currency;
  final String createdBy;
  final String updatedBy;
  final List<dynamic> users;

  /// ✅ NEW: list of service types ("Maintenance", "Monitoring", "Plantation")
  final List<String> serviceTypes;

  /// ✅ Areas within this project
  final List<ProjectArea> areas;

  ProjectItem({
    required this.id,
    required this.name,
    required this.type,
    required this.category,
    required this.description,
    required this.image,
    required this.scopeOfWork,
    required this.contractValue,
    required this.gstApplicable,
    required this.gstPercentage,
    required this.totalAmountPaid,
    required this.paymentTerms,
    required this.timeline,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.currency,
    required this.createdBy,
    required this.updatedBy,
    required this.users,
    required this.areas,
    required this.serviceTypes,
  });

  factory ProjectItem.fromJson(Map<String, dynamic> json) => ProjectItem(
    id: json["id"] ?? '',
    name: json["name"] ?? '',
    type: json["type"] ?? '',
    category: json["category"] ?? '',
    description: json["description"] ?? '',
    image: json["image"],
    scopeOfWork: json["scope_of_work"],
    contractValue: json["contract_value"] ?? '',
    gstApplicable: json["gst_applicable"] ?? false,
    gstPercentage: json["gst_percentage"] ?? '',
    totalAmountPaid: json["total_amount_paid"] ?? '',
    paymentTerms: json["payment_terms"],
    timeline: json["timeline"],
    startDate: json["start_date"] ?? '',
    endDate: json["end_date"] ?? '',
    createdAt: json["created_at"] ?? '',
    updatedAt: json["updated_at"] ?? '',
    status: json["status"] ?? '',
    currency: json["currency"] ?? '',
    createdBy: json["created_by"] ?? '',
    updatedBy: json["updated_by"] ?? '',
    users: json["users"] ?? [],
    areas: (json["areas"] as List? ?? [])
        .map((x) => ProjectArea.fromJson(x))
        .toList(),

    /// ✅ Parse service_types if present
    serviceTypes: (json["service_types"] as List? ?? [])
        .map((e) => e.toString())
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
    "category": category,
    "description": description,
    "image": image,
    "scope_of_work": scopeOfWork,
    "contract_value": contractValue,
    "gst_applicable": gstApplicable,
    "gst_percentage": gstPercentage,
    "total_amount_paid": totalAmountPaid,
    "payment_terms": paymentTerms,
    "timeline": timeline,
    "start_date": startDate,
    "end_date": endDate,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "status": status,
    "currency": currency,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "users": users,
    "areas": areas.map((e) => e.toJson()).toList(),
    "service_types": serviceTypes,
  };

  /// Helper: total area count
  int get areaCount => areas.length;

  /// Helper: Total capacity across all areas
  int get totalCapacity =>
      areas.fold(0, (sum, area) => sum + area.capacity);
}

/// ✅ Project Area Model (supports GeoJSON)
class ProjectArea {
  final String id;
  final String name;
  final String type;
  final int capacity;

  /// ✅ Parsed GeoJSON Polygon
  final GeoJSONPolygon? polygon;

  final String createdAt;
  final String updatedAt;
  final String projectId;
  final String? parentArea;

  ProjectArea({
    required this.id,
    required this.name,
    required this.type,
    required this.capacity,
    required this.polygon,
    required this.createdAt,
    required this.updatedAt,
    required this.projectId,
    this.parentArea,
  });

  factory ProjectArea.fromJson(Map<String, dynamic> json) {
    GeoJSONPolygon? parsedPolygon;

    try {
      final locationJson = json["location"];
      if (locationJson != null) {
        /// ✅ location is already a GeoJSON {"type": "Polygon", "coordinates": [...]}
        final geoFeature = GeoJSONFeature.fromJSON(jsonEncode(locationJson));
        if (geoFeature.geometry is GeoJSONPolygon) {
          parsedPolygon = geoFeature.geometry as GeoJSONPolygon;
        }
      }
    } catch (e) {
      print("GeoJSON parse error for ${json["name"]}: $e");
    }

    return ProjectArea(
      id: json["id"] ?? '',
      name: json["name"] ?? '',
      type: json["type"] ?? '',
      capacity: json["capacity"] ?? 0,
      polygon: parsedPolygon,
      createdAt: json["created_at"] ?? '',
      updatedAt: json["updated_at"] ?? '',
      projectId: json["project"] ?? '',
      parentArea: json["parent_area"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
    "capacity": capacity,
    "location": polygon?.toJSON(),
    "created_at": createdAt,
    "updated_at": updatedAt,
    "project": projectId,
    "parent_area": parentArea,
  };

  /// ✅ Helper: polygon coordinates
  List<List<List<double>>>? get coordinates => polygon?.coordinates;

  /// ✅ Helper: approximate polygon center
  List<double>? get polygonCenter {
    if (polygon != null) {
      final coords = polygon!.coordinates.first; // outer ring
      final latSum = coords.fold(0.0, (sum, p) => sum + p[1]);
      final lngSum = coords.fold(0.0, (sum, p) => sum + p[0]);
      return [lngSum / coords.length, latSum / coords.length];
    }
    return null;
  }
}

