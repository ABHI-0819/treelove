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
        status: json["status"]?.toString() ?? '',
        message: json["message"]?.toString() ?? '',
        data: (json["data"] as List? ?? [])
            .where((x) => x != null)
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

  ///  Helper: total remaining for allocation
  int get totalRemaining =>
      data.fold(0, (sum, item) => sum + item.remainingTrees);
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
  final int remainingTrees;

  ServiceSpeciesItem({
    required this.serviceId,
    required this.speciesId,
    required this.name,
    required this.scientificName,
    required this.media,
    required this.totalDone,
    required this.totalRequired,
    required this.remainingTrees,
  });

  factory ServiceSpeciesItem.fromJson(Map<String, dynamic> json) =>
      ServiceSpeciesItem(
        serviceId: json["service_id"]?.toString() ?? '',
        speciesId: json["species_id"]?.toString() ?? '',
        name: json["name"]?.toString() ?? '',
        scientificName: json["scientific_name"]?.toString() ?? '',
        media: json["media"]?.toString(),
        totalDone: (json["total_done"] ?? 0) as int,
        totalRequired: (json["total_required"] ?? 0) as int,
        remainingTrees: (json["remaining_trees"] ?? 0) as int,
      );

  Map<String, dynamic> toJson() => {
    "service_id": serviceId,
    "species_id": speciesId,
    "name": name,
    "scientific_name": scientificName,
    "media": media,
    "total_done": totalDone,
    "total_required": totalRequired,
    "remaining_trees": remainingTrees,
  };

  /// ✅ Helper: progress %
  double get progressPercent =>
      totalRequired == 0 ? 0 : (totalDone / totalRequired * 100);
}
