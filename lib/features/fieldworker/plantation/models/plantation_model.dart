import 'dart:convert';


/// Request Model for post data
import 'dart:convert';
import 'dart:io';

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
  final List<File> media;

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
    required this.media,
  });

  /// ✅ Convert model → JSON Map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = {
      "plantation_date": plantationDate,
      "plantation_type": plantationType,
      "services": services,
      "location": jsonEncode(location),
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
    // addIfNotNull("media", media);

    // if (media != null && media!.isNotEmpty) {
    //   jsonMap["media"] = jsonEncode(media!.map((m) => m.toJson()).toList());
    // }

    // if (media != null && media!.isNotEmpty) {
    //   jsonMap["media"] = jsonEncode(media!.map((m) => m.toJson()).toList());
    // }

    return jsonMap;
  }


  /// ✅ JSON encode directly if needed
  String toJsonString() => jsonEncode(toJson());
}
class PlantationMedia {
  final String filePath;

  PlantationMedia({required this.filePath});

  Map<String, dynamic> toJson() => {
    "file_path": filePath,
  };
}
/*
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

 */


/// ✅ JSON helpers
/*
PlantationResponseModel plantationResponseModelFromJson(String str) => PlantationResponseModel.fromJson(json.decode(str));

String plantationResponseModelToJson(PlantationResponseModel data) => json.encode(data.toJson());

class PlantationResponseModel {
  String status;
  String message;
  Data data;

  PlantationResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

}

class Data {
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

  Data({
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
  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(
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

 */

PlantationResponseModel plantationResponseModelFromJson(String str) => PlantationResponseModel.fromJson(json.decode(str));

String plantationResponseModelToJson(PlantationResponseModel data) => json.encode(data.toJson());

class PlantationResponseModel {
  String status;
  String message;
  Data data;

  PlantationResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PlantationResponseModel.fromJson(Map<String, dynamic> json) => PlantationResponseModel(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  String id;
  dynamic thumbnail;
  Location location;
  String remarks;
  DateTime createdAt;
  DateTime updatedAt;
  String treeHeight;
  String treeHeightUnit;
  String treeGirth;
  String treeGirthUnit;
  dynamic canopySize;
  String canopySizeUnit;
  dynamic treeAge;
  String treeHealth;
  String treeGrowth;
  DateTime plantationDate;
  String plantationType;
  bool isVerified;
  dynamic verifiedAt;
  String services;
  String treeSpecies;
  String vendor;
  String createdBy;
  String updatedBy;
  dynamic verifiedBy;
  List<dynamic> treeDiseases;

  Data({
    required this.id,
    required this.thumbnail,
    required this.location,
    required this.remarks,
    required this.createdAt,
    required this.updatedAt,
    required this.treeHeight,
    required this.treeHeightUnit,
    required this.treeGirth,
    required this.treeGirthUnit,
    required this.canopySize,
    required this.canopySizeUnit,
    required this.treeAge,
    required this.treeHealth,
    required this.treeGrowth,
    required this.plantationDate,
    required this.plantationType,
    required this.isVerified,
    required this.verifiedAt,
    required this.services,
    required this.treeSpecies,
    required this.vendor,
    required this.createdBy,
    required this.updatedBy,
    required this.verifiedBy,
    required this.treeDiseases,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    thumbnail: json["thumbnail"],
    location: Location.fromJson(json["location"]),
    remarks: json["remarks"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    treeHeight: json["tree_height"],
    treeHeightUnit: json["tree_height_unit"],
    treeGirth: json["tree_girth"],
    treeGirthUnit: json["tree_girth_unit"],
    canopySize: json["canopy_size"],
    canopySizeUnit: json["canopy_size_unit"],
    treeAge: json["tree_age"],
    treeHealth: json["tree_health"],
    treeGrowth: json["tree_growth"],
    plantationDate: DateTime.parse(json["plantation_date"]),
    plantationType: json["plantation_type"],
    isVerified: json["is_verified"],
    verifiedAt: json["verified_at"],
    services: json["services"],
    treeSpecies: json["tree_species"],
    vendor: json["vendor"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    verifiedBy: json["verified_by"],
    treeDiseases: List<dynamic>.from(json["tree_diseases"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "thumbnail": thumbnail,
    "location": location.toJson(),
    "remarks": remarks,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "tree_height": treeHeight,
    "tree_height_unit": treeHeightUnit,
    "tree_girth": treeGirth,
    "tree_girth_unit": treeGirthUnit,
    "canopy_size": canopySize,
    "canopy_size_unit": canopySizeUnit,
    "tree_age": treeAge,
    "tree_health": treeHealth,
    "tree_growth": treeGrowth,
    "plantation_date": "${plantationDate.year.toString().padLeft(4, '0')}-${plantationDate.month.toString().padLeft(2, '0')}-${plantationDate.day.toString().padLeft(2, '0')}",
    "plantation_type": plantationType,
    "is_verified": isVerified,
    "verified_at": verifiedAt,
    "services": services,
    "tree_species": treeSpecies,
    "vendor": vendor,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "verified_by": verifiedBy,
    "tree_diseases": List<dynamic>.from(treeDiseases.map((x) => x)),
  };
}

class Location {
  String type;
  List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    type: json["type"],
    coordinates: List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
  };
}


