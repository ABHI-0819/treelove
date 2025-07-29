import 'dart:convert';

///  Parse JSON → ServiceDetailResponse
ServiceDetailResponse serviceDetailResponseFromJson(String str) =>
    ServiceDetailResponse.fromJson(json.decode(str));

///  Convert ServiceDetailResponse → JSON string
String serviceDetailResponseToJson(ServiceDetailResponse data) =>
    json.encode(data.toJson());

///  Root Model
class ServiceDetailResponse {
  final String status;
  final String message;
  final List<ServiceSpeciesItem> data;

  ServiceDetailResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ServiceDetailResponse.fromJson(Map<String, dynamic> json) =>
      ServiceDetailResponse(
        status: json["status"] ?? '',
        message: json["message"] ?? '',
        data: (json["data"] as List? ?? [])
            .map((x) => ServiceSpeciesItem.fromJson(x))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.map((x) => x.toJson()).toList(),
  };

  ///  Helper: total required across all species
  int get totalRequired =>
      data.fold(0, (sum, item) => sum + item.totalRequired);

  ///  Helper: total already done
  int get totalDone =>
      data.fold(0, (sum, item) => sum + item.totalDone);
}

///  Individual Species Item
class ServiceSpeciesItem {
  final String serviceId;
  final String speciesId;
  final String name;
  final String scientificName;
  final String? media;
  final int totalDone;
  final int totalRequired;

  ServiceSpeciesItem({
    required this.serviceId,
    required this.speciesId,
    required this.name,
    required this.scientificName,
    required this.media,
    required this.totalDone,
    required this.totalRequired,
  });

  factory ServiceSpeciesItem.fromJson(Map<String, dynamic> json) =>
      ServiceSpeciesItem(
        serviceId: json["service_id"] ?? '',
        speciesId: json["species_id"] ?? '',
        name: json["name"] ?? '',
        scientificName: json["scientific_name"] ?? '',
        media: json["media"],
        totalDone: json["total_done"] ?? 0,
        totalRequired: json["total_required"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
    "service_id": serviceId,
    "species_id": speciesId,
    "name": name,
    "scientific_name": scientificName,
    "media": media,
    "total_done": totalDone,
    "total_required": totalRequired,
  };

  /// ✅ Helper: progress %
  double get progressPercent =>
      totalRequired == 0 ? 0 : (totalDone / totalRequired * 100);
}
