import 'dart:convert';
import 'package:latlong2/latlong.dart';

/// ✅ Helper to parse JSON string → Model
AssignedServiceTypeResponse assignedServiceTypeResponseFromJson(String str) =>
    AssignedServiceTypeResponse.fromJson(json.decode(str));

/// ✅ Helper to convert Model → JSON string
String assignedServiceTypeResponseToJson(AssignedServiceTypeResponse data) =>
    json.encode(data.toJson());

class AssignedServiceTypeResponse {
  final String status;
  final String message;
  final AssignedAreaData? data;

  AssignedServiceTypeResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory AssignedServiceTypeResponse.fromJson(Map<String, dynamic> json) {
    return AssignedServiceTypeResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null ? AssignedAreaData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class AssignedAreaData {
  final String id;
  final String name;
  final int capacity;
  final PolygonData? location;
  final List<ServiceSummary> serviceSummary;

  AssignedAreaData({
    required this.id,
    required this.name,
    required this.capacity,
    required this.location,
    required this.serviceSummary,
  });

  factory AssignedAreaData.fromJson(Map<String, dynamic> json) {
    return AssignedAreaData(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      capacity: json['capacity'] ?? 0,
      location: json['location'] != null
          ? PolygonData.fromJson(jsonDecode(json['location']))
          : null,
      serviceSummary: (json['service_summary'] as List<dynamic>?)
          ?.map((e) => ServiceSummary.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "capacity": capacity,
    "location": location?.toJson(),
    "service_summary": serviceSummary.map((e) => e.toJson()).toList(),
  };
}

/// ✅ Polygon optimized for `flutter_map`
class PolygonData {
  final String type;
  final List<List<LatLng>> coordinates;

  PolygonData({
    required this.type,
    required this.coordinates,
  });

  factory PolygonData.fromJson(Map<String, dynamic> json) {
    final rawCoords = json['coordinates'] as List<dynamic>;

    // ✅ Parse into flutter_map friendly LatLng
    List<List<LatLng>> parsed = rawCoords.map((poly) {
      return (poly as List<dynamic>)
          .map((point) => LatLng(point[1], point[0])) // lat = [1], lng = [0]
          .toList();
    }).toList();

    return PolygonData(
      type: json['type'] ?? 'Polygon',
      coordinates: parsed,
    );
  }

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": coordinates
        .map((poly) => poly
        .map((latLng) => [latLng.longitude, latLng.latitude])
        .toList())
        .toList(),
  };

  /// ✅ Helper: Flatten to a single LatLng list (first polygon ring)
  List<LatLng> get firstRing => coordinates.isNotEmpty ? coordinates.first : [];
}

class ServiceSummary {
  final String serviceType;
  final int totalRequired;
  final int totalDone;

  ServiceSummary({
    required this.serviceType,
    required this.totalRequired,
    required this.totalDone,
  });

  factory ServiceSummary.fromJson(Map<String, dynamic> json) => ServiceSummary(
    serviceType: json['service_type'] ?? '',
    totalRequired: json['total_required'] ?? 0,
    totalDone: json['total_done'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "service_type": serviceType,
    "total_required": totalRequired,
    "total_done": totalDone,
  };
}
