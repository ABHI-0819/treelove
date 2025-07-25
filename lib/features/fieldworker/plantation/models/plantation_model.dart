import 'dart:convert';


/// Request Model for post data
import 'dart:convert';

class PlantationRequestModel {
  final String plantationDate;      // required
  final String plantationType;      // required: "new" | "existing"
  final String services;            // required: UUID
  final Map<String, dynamic> location; // required: { type: "Point", coordinates: [lat, lng] }
  final String treeHeight;          // required
  final String treeGirth;           // required

  // Optional
  final List<String>? treeDiseases;
  final String? remarks;
  final String? treeHeightUnit;     // ft | m | cm
  final String? treeGirthUnit;      // ft | m | cm
  final String? canopySize;
  final String? canopySizeUnit;     // m2 | ft2
  final int? treeAge;
  final String? treeHealth;         // enum: healthy, etc.
  final String? treeGrowth;         // enum: sapling, etc.
  final List<PlantationMedia>? media;

  PlantationRequestModel({
    required this.plantationDate,
    required this.plantationType,
    required this.services,
    required this.location,
    required this.treeHeight,
    required this.treeGirth,
    this.treeDiseases,
    this.remarks,
    this.treeHeightUnit,
    this.treeGirthUnit,
    this.canopySize,
    this.canopySizeUnit,
    this.treeAge,
    this.treeHealth,
    this.treeGrowth,
    this.media,
  });

  /// ✅ Convert model → JSON Map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = {
      "plantation_date": plantationDate,
      "plantation_type": plantationType,
      "services": services,
      "location": location,
      "tree_height": treeHeight,
      "tree_girth": treeGirth,
    };

    // Add only non-null / non-empty fields
    void addIfNotNull(String key, dynamic value) {
      if (value != null) {
        if (value is String && value.trim().isEmpty) return; // skip empty string
        if (value is List && value.isEmpty) return; // skip empty list
        jsonMap[key] = value;
      }
    }

    addIfNotNull("tree_diseases", treeDiseases);
    addIfNotNull("remarks", remarks);
    addIfNotNull("tree_height_unit", treeHeightUnit);
    addIfNotNull("tree_girth_unit", treeGirthUnit);
    addIfNotNull("canopy_size", canopySize);
    addIfNotNull("canopy_size_unit", canopySizeUnit);
    addIfNotNull("tree_age", treeAge?.toString());
    addIfNotNull("tree_health", treeHealth);
    addIfNotNull("tree_growth", treeGrowth);

    if (media != null && media!.isNotEmpty) {
      jsonMap["media"] = media!.map((m) => m.toJson()).toList();
    }

    return jsonMap;
  }

  /// ✅ JSON encode directly if needed
  String toJsonString() => jsonEncode(toJson());
}
class PlantationMedia {
  final String media; // file path or base64
  final String type;  // "image", "video", etc.

  PlantationMedia({
    required this.media,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
    "media": media,
    "type": type,
  };

  factory PlantationMedia.fromJson(Map<String, dynamic> json) =>
      PlantationMedia(
        media: json["media"],
        type: json["type"],
      );

}


/// ✅ JSON helpers
PlantationResponseModel plantationResponseModelFromJson(String str) =>
    PlantationResponseModel.fromJson(json.decode(str));

String plantationResponseModelToJson(PlantationResponseModel data) =>
    json.encode(data.toJson());

class PlantationResponseModel {
  final String plantationDate;
  final String plantationType;
  final List<String>? treeDiseases;
  final String services;
  final PlantationLocation location;
  final String? remarks;
  final String treeHeight;
  final String? treeHeightUnit;
  final String treeGirth;
  final String? treeGirthUnit;
  final String? canopySize;
  final String? canopySizeUnit;
  final int? treeAge;
  final String? treeHealth;
  final String? treeGrowth;
  final List<PlantationMedia>? media;

  PlantationResponseModel({
    required this.plantationDate,
    required this.plantationType,
    this.treeDiseases,
    required this.services,
    required this.location,
    this.remarks,
    required this.treeHeight,
    this.treeHeightUnit,
    required this.treeGirth,
    this.treeGirthUnit,
    this.canopySize,
    this.canopySizeUnit,
    this.treeAge,
    this.treeHealth,
    this.treeGrowth,
    this.media,
  });

  /// ✅ Convert JSON → Model
  factory PlantationResponseModel.fromJson(Map<String, dynamic> json) =>
      PlantationResponseModel(
        plantationDate: json["plantation_date"],
        plantationType: json["plantation_type"],
        treeDiseases: json["tree_diseases"] == null
            ? []
            : List<String>.from(json["tree_diseases"].map((x) => x)),
        services: json["services"],
        location: PlantationLocation.fromJson(json["location"]),
        remarks: json["remarks"],
        treeHeight: json["tree_height"],
        treeHeightUnit: json["tree_height_unit"],
        treeGirth: json["tree_girth"],
        treeGirthUnit: json["tree_girth_unit"],
        canopySize: json["canopy_size"],
        canopySizeUnit: json["canopy_size_unit"],
        treeAge: json["tree_age"],
        treeHealth: json["tree_health"],
        treeGrowth: json["tree_growth"],
        media: json["media"] == null
            ? []
            : List<PlantationMedia>.from(
            json["media"].map((x) => PlantationMedia.fromJson(x))),
      );

  /// ✅ Convert Model → JSON
  Map<String, dynamic> toJson() => {
    "plantation_date": plantationDate,
    "plantation_type": plantationType,
    if (treeDiseases != null) "tree_diseases": treeDiseases,
    "services": services,
    "location": location.toJson(),
    if (remarks != null) "remarks": remarks,
    "tree_height": treeHeight,
    if (treeHeightUnit != null) "tree_height_unit": treeHeightUnit,
    "tree_girth": treeGirth,
    if (treeGirthUnit != null) "tree_girth_unit": treeGirthUnit,
    if (canopySize != null) "canopy_size": canopySize,
    if (canopySizeUnit != null) "canopy_size_unit": canopySizeUnit,
    if (treeAge != null) "tree_age": treeAge,
    if (treeHealth != null) "tree_health": treeHealth,
    if (treeGrowth != null) "tree_growth": treeGrowth,
    if (media != null)
      "media": List<dynamic>.from(media!.map((x) => x.toJson())),
  };
}

class PlantationLocation {
  final String type;
  final List<double> coordinates;

  PlantationLocation({
    this.type = "Point",
    required this.coordinates,
  });

  factory PlantationLocation.fromJson(Map<String, dynamic> json) =>
      PlantationLocation(
        type: json["type"] ?? "Point",
        coordinates:
        List<double>.from(json["coordinates"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
  };
}

