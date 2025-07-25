/// Api Response
/*
{
  "status": "success",
  "message": "Success",
  "data": {
    "total_project_areas": 2,
    "total_service_types": 2,
    "total_fieldworkers": 2,
    "service_summary": [
      {
        "service_type__name": "Maintenance",
        "total_trees": 200
      },
      {
        "service_type__name": "Plantation",
        "total_trees": 200
      }
    ],
    "fieldworkers": [
      {
        "id": "1079e887-1b39-4b6c-9b5b-1e8591df8c0e",
        "username": "fw@example.com",
        "full_name": "Suraj Koyate",
        "profile_picture": "/media/user/profile_pics/Screenshot_2025-06-17_193745.png"
      },
      {
        "id": "d4d5007b-b113-439c-8f60-a82ad70aa704",
        "username": "fw1@example.com",
        "full_name": "Manesh Zore",
        "profile_picture": "/media/user/profile_pics/Screenshot_2025-06-17_193745_KJt1vWE.png"
      }
    ],
    "project_areas": [
      {
        "id": "9a1c2dcf-1e34-43c0-9a4f-530b53ec5125",
        "name": "Thane East",
        "capacity": 2345,
        "location": "{ \"type\": \"Polygon\", \"coordinates\": [ [ [ 0.0, 0.0 ], [ 0.0, 50.0 ], [ 50.0, 50.0 ], [ 50.0, 0.0 ], [ 0.0, 0.0 ] ] ] }",
        "service_summary": [
          {
            "service_type__name": "Maintenance",
            "total_trees": 200
          },
          {
            "service_type__name": "Plantation",
            "total_trees": 200
          }
        ],
        "fieldworkers": [
          {
            "id": "1079e887-1b39-4b6c-9b5b-1e8591df8c0e",
            "username": "fw@example.com",
            "full_name": "Suraj Koyate",
            "profile_picture": "/media/user/profile_pics/Screenshot_2025-06-17_193745.png"
          },
          {
            "id": "d4d5007b-b113-439c-8f60-a82ad70aa704",
            "username": "fw1@example.com",
            "full_name": "Manesh Zore",
            "profile_picture": "/media/user/profile_pics/Screenshot_2025-06-17_193745_KJt1vWE.png"
          }
        ]
      },
      {
        "id": "fdbe61a3-d389-4b38-a72a-b9381be772de",
        "name": "Thane West",
        "capacity": 1234,
        "location": "{ \"type\": \"Polygon\", \"coordinates\": [ [ [ 0.0, 0.0 ], [ 0.0, 50.0 ], [ 50.0, 50.0 ], [ 50.0, 0.0 ], [ 0.0, 0.0 ] ] ] }",
        "service_summary": [],
        "fieldworkers": []
      }
    ]
  }
}

*/



import 'dart:convert';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:treelove/core/utils/logger.dart';

/// Helper functions
ProjectDetailResponse projectDetailResponseFromJson(String str) =>
    ProjectDetailResponse.fromJson(json.decode(str));

String projectDetailResponseToJson(ProjectDetailResponse data) =>
    json.encode(data.toJson());


///  Root Model
class ProjectDetailResponse {
  final String status;
  final String message;
  final ProjectDetailData data;

  ProjectDetailResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProjectDetailResponse.fromJson(Map<String, dynamic> json) =>
      ProjectDetailResponse(
        status: json["status"] ?? '',
        message: json["message"] ?? '',
        data: ProjectDetailData.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

/// Project Info (newly added section)
class ProjectInfo {
  final String id;
  final String name;
  final String category;
  final String type;
  final String description;
  final String image;
  final String endDate;

  ProjectInfo({
    required this.id,
    required this.name,
    required this.category,
    required this.type,
    required this.description,
    required this.image,
    required this.endDate,
  });

  factory ProjectInfo.fromJson(Map<String, dynamic> json) => ProjectInfo(
    id: json["id"] ?? '',
    name: json["name"] ?? '',
    category: json["category"] ?? '',
    type: json["type"] ?? '',
    description: json["description"] ?? '',
    image: json["image"] ?? '',
    endDate: json["end_date"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "category": category,
    "type": type,
    "description": description,
    "image": image,
    "end_date": endDate,
  };
}


///  Main Data Model
class ProjectDetailData {
  final ProjectInfo projectInfo;
  final int totalProjectAreas;
  final int totalServiceTypes;
  final int totalFieldworkers;
  final List<ServiceSummary> serviceSummary;
  final List<Fieldworker> fieldworkers; // ✅ root-level fieldworkers
  final List<ProjectArea> projectAreas;

  ProjectDetailData({
    required this.projectInfo,
    required this.totalProjectAreas,
    required this.totalServiceTypes,
    required this.totalFieldworkers,
    required this.serviceSummary,
    required this.fieldworkers,
    required this.projectAreas,
  });

  factory ProjectDetailData.fromJson(Map<String, dynamic> json) =>
      ProjectDetailData(
        projectInfo: ProjectInfo.fromJson(json["project_info"] ?? {}),
        totalProjectAreas: json["total_project_areas"] ?? 0,
        totalServiceTypes: json["total_service_types"] ?? 0,
        totalFieldworkers: json["total_fieldworkers"] ?? 0,
        serviceSummary: (json["service_summary"] as List? ?? [])
            .map((x) => ServiceSummary.fromJson(x))
            .toList(),
        fieldworkers: (json["fieldworkers"] as List? ?? [])
            .map((x) => Fieldworker.fromJson(x))
            .toList(),
        projectAreas: (json["project_areas"] as List? ?? [])
            .map((x) => ProjectArea.fromJson(x))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
    "project_info": projectInfo.toJson(),
    "total_project_areas": totalProjectAreas,
    "total_service_types": totalServiceTypes,
    "total_fieldworkers": totalFieldworkers,
    "service_summary": serviceSummary.map((e) => e.toJson()).toList(),
    "fieldworkers": fieldworkers.map((e) => e.toJson()).toList(),
    "project_areas": projectAreas.map((e) => e.toJson()).toList(),
  };



  ///  Helper: total trees in entire project
  int get totalTrees =>
      serviceSummary.fold(0, (sum, item) => sum + item.totalTrees);


  ///  All area names
  List<String> get allProjectAreaNames =>
      projectAreas.map((area) => area.name).toList();

  /// ✅ Helper: all fieldworker names
  List<String> get allFieldworkerNames =>
      fieldworkers.map((fw) => fw.fullName).toList();
}

///  Each Service Summary
class ServiceSummary {
  final String serviceTypeName;
  final int totalTrees;

  ServiceSummary({
    required this.serviceTypeName,
    required this.totalTrees,
  });

  factory ServiceSummary.fromJson(Map<String, dynamic> json) => ServiceSummary(
    serviceTypeName: json["service_type__name"] ?? '',
    totalTrees: json["total_trees"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "service_type__name": serviceTypeName,
    "total_trees": totalTrees,
  };
}

///  Fieldworker (Used both at root and inside areas)
class Fieldworker {
  final String id;
  final String username;
  final String fullName;
  final String profilePicture;

  Fieldworker({
    required this.id,
    required this.username,
    required this.fullName,
    required this.profilePicture,
  });

  factory Fieldworker.fromJson(Map<String, dynamic> json) => Fieldworker(
    id: json["id"] ?? '',
    username: json["username"] ?? '',
    fullName: json["full_name"] ?? '',
    profilePicture: json["profile_picture"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "full_name": fullName,
    "profile_picture": profilePicture,
  };
}

///  Project Areas (with GeoJSON location)
class ProjectArea {
  final String id;
  final String name;
  final int capacity;
  final String location; // raw GeoJSON string
  final List<ServiceSummary> serviceSummary;
  final List<Fieldworker> fieldworkers;

  ProjectArea({
    required this.id,
    required this.name,
    required this.capacity,
    required this.location,
    required this.serviceSummary,
    required this.fieldworkers,
  });

  factory ProjectArea.fromJson(Map<String, dynamic> json) => ProjectArea(
    id: json["id"] ?? '',
    name: json["name"] ?? '',
    capacity: json["capacity"] ?? 0,
    location: json["location"] ?? '',
    serviceSummary: (json["service_summary"] as List? ?? [])
        .map((x) => ServiceSummary.fromJson(x))
        .toList(),
    fieldworkers: (json["fieldworkers"] as List? ?? [])
        .map((x) => Fieldworker.fromJson(x))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "capacity": capacity,
    "location": location,
    "service_summary": serviceSummary.map((e) => e.toJson()).toList(),
    "fieldworkers": fieldworkers.map((e) => e.toJson()).toList(),
  };

  ///  Total trees for this specific area
  int get totalTreesInThisArea =>
      serviceSummary.fold(0, (sum, s) => sum + s.totalTrees);


  ///  Get only fieldworker names for this area
  List<String> get areaFieldworkerNames =>
      fieldworkers.map((fw) => fw.fullName).toList();

  ///  Parse Polygon with geojson_vi
  GeoJSONPolygon? get geoPolygon {
    try {
      final geo = GeoJSONFeature.fromJSON(location);
      if (geo.geometry is GeoJSONPolygon) {
        return geo.geometry as GeoJSONPolygon;
      }
    } catch (e) {
      debugLog("GeoJSON parsing error: $e");
    }
    return null;
  }

  ///  Get coordinates as List<List<List<double>>> (GeoJSON standard)
  List<List<List<double>>>? get polygonCoordinates {
    final polygon = geoPolygon;
    return polygon?.coordinates;
  }

  ///  Get center (approx) for placing marker
  List<double>? get polygonCenter {
    final polygon = geoPolygon;
    if (polygon != null) {
      final coords = polygon.coordinates.first; // outer ring
      final latSum = coords.fold(0.0, (sum, p) => sum + p[1]);
      final lngSum = coords.fold(0.0, (sum, p) => sum + p[0]);
      return [lngSum / coords.length, latSum / coords.length];
    }
    return null;
  }
}

extension ProjectDetailHelpers on ProjectDetailData {
  /// ✅ Get fieldworkers for a specific Area ID
  List<Fieldworker> getFieldworkersForArea(String areaId) {
    final area = projectAreas.firstWhere(
          (a) => a.id == areaId,
      orElse: () => ProjectArea(
        id: '',
        name: '',
        capacity: 0,
        location: '',
        serviceSummary: [],
        fieldworkers: [],
      ),
    );

    return area.fieldworkers;
  }
}
