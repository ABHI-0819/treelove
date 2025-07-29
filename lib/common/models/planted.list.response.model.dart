

import 'dart:convert';

PlantedListResponseModel plantedListResponseModelFromJson(String str) => PlantedListResponseModel.fromJson(json.decode(str));

String plantedListResponseModelToJson(PlantedListResponseModel data) => json.encode(data.toJson());

class PlantedListResponseModel {
  String status;
  String message;
  List<Datum> data;

  PlantedListResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PlantedListResponseModel.fromJson(Map<String, dynamic> json) => PlantedListResponseModel(
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String id;
  String? thumbnail;
  Location location;
  Remarks remarks;
  DateTime createdAt;
  DateTime updatedAt;
  String treeHeight;
  TreeUnit treeHeightUnit;
  String treeGirth;
  TreeUnit treeGirthUnit;
  String? canopySize;
  CanopySizeUnit canopySizeUnit;
  int? treeAge;
  TreeHealth treeHealth;
  TreeGrowth treeGrowth;
  DateTime plantationDate;
  PlantationType plantationType;
  bool isVerified;
  dynamic verifiedAt;
  String services;
  String treeSpecies;
  String vendor;
  String createdBy;
  String updatedBy;
  dynamic verifiedBy;
  List<dynamic> treeDiseases;

  Datum({
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

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    thumbnail: json["thumbnail"],
    location: Location.fromJson(json["location"]),
    remarks: remarksValues.map[json["remarks"]]!,
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    treeHeight: json["tree_height"],
    treeHeightUnit: treeUnitValues.map[json["tree_height_unit"]]!,
    treeGirth: json["tree_girth"],
    treeGirthUnit: treeUnitValues.map[json["tree_girth_unit"]]!,
    canopySize: json["canopy_size"],
    canopySizeUnit: canopySizeUnitValues.map[json["canopy_size_unit"]]!,
    treeAge: json["tree_age"],
    treeHealth: treeHealthValues.map[json["tree_health"]]!,
    treeGrowth: treeGrowthValues.map[json["tree_growth"]]!,
    plantationDate: DateTime.parse(json["plantation_date"]),
    plantationType: plantationTypeValues.map[json["plantation_type"]]!,
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
    "remarks": remarksValues.reverse[remarks],
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "tree_height": treeHeight,
    "tree_height_unit": treeUnitValues.reverse[treeHeightUnit],
    "tree_girth": treeGirth,
    "tree_girth_unit": treeUnitValues.reverse[treeGirthUnit],
    "canopy_size": canopySize,
    "canopy_size_unit": canopySizeUnitValues.reverse[canopySizeUnit],
    "tree_age": treeAge,
    "tree_health": treeHealthValues.reverse[treeHealth],
    "tree_growth": treeGrowthValues.reverse[treeGrowth],
    "plantation_date": "${plantationDate.year.toString().padLeft(4, '0')}-${plantationDate.month.toString().padLeft(2, '0')}-${plantationDate.day.toString().padLeft(2, '0')}",
    "plantation_type": plantationTypeValues.reverse[plantationType],
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

enum CanopySizeUnit {
  M2
}

final canopySizeUnitValues = EnumValues({
  "m2": CanopySizeUnit.M2
});

class Location {
  Type type;
  List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    type: typeValues.map[json["type"]]!,
    coordinates: List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "type": typeValues.reverse[type],
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
  };
}

enum Type {
  POINT
}

final typeValues = EnumValues({
  "Point": Type.POINT
});

enum PlantationType {
  NEW
}

final plantationTypeValues = EnumValues({
  "new": PlantationType.NEW
});

enum Remarks {
  EMPTY,
  STRING,
  TESTING
}

final remarksValues = EnumValues({
  "": Remarks.EMPTY,
  "string": Remarks.STRING,
  "Testing": Remarks.TESTING
});

enum TreeUnit {
  FT
}

final treeUnitValues = EnumValues({
  "ft": TreeUnit.FT
});

enum TreeGrowth {
  SAPLING
}

final treeGrowthValues = EnumValues({
  "sapling": TreeGrowth.SAPLING
});

enum TreeHealth {
  HEALTHY
}

final treeHealthValues = EnumValues({
  "healthy": TreeHealth.HEALTHY
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
