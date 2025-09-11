import 'dart:convert';

// Helper functions for JSON serialization/deserialization
TreeSpeciesListResponse treeSpeciesListResponseFromJson(String str) =>
    TreeSpeciesListResponse.fromJson(json.decode(str));

String treeSpeciesListResponseToJson(TreeSpeciesListResponse data) =>
    json.encode(data.toJson());

// --- Top-level Model (TreeSpeciesListResponse) ---
class TreeSpeciesListResponse {
  final String status;
  final String message;
  final List<TreeSpecies> data;
  final Pagination? pagination; // Make pagination nullable

  TreeSpeciesListResponse({
    required this.status,
    required this.message,
    required this.data,
    this.pagination, // Make constructor parameter nullable
  });

  factory TreeSpeciesListResponse.fromJson(Map<String, dynamic> json) {
    return TreeSpeciesListResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => TreeSpecies.fromJson(e as Map<String, dynamic>))
          .toList(),
      // Handle nullable pagination: if json['pagination'] is null, assign null.
      // Otherwise, parse it as a Pagination object.
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(), // Use null-aware operator for toJson
    };
  }
}

// --- Pagination Model (No changes needed) ---
class Pagination {
  final int count;
  final String? next;
  final String? previous;
  final int currentPage;
  final int totalPages;

  Pagination({
    required this.count,
    this.next,
    this.previous,
    required this.currentPage,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      count: json['count'] as int,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      currentPage: json['current_page'] as int,
      totalPages: json['total_pages'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'next': next,
      'previous': previous,
      'current_page': currentPage,
      'total_pages': totalPages,
    };
  }
}

class TreeSpecies {
  final String id;
  final List<Disease> diseases;
  final ServicePricing? servicePricing;
  final String? waterAndCareInfo;
  final String addedById;
  final String updatedById;
  final String treeName;
  final String scientificName;
  final String speciesName;
  final String localName;
  final String? image;
  final String type;
  final String category;
  final String nativeRegion;
  final String droughtTolerance;
  final String soilType;
  final String suitableWeather;
  final String humidity;
  final String shortDescription;
  final int lifespanYears;
  final String treeDetails;
  final String identificationMethod;
  final String avgTreeHeight;
  final String avgTreeGirth;
  final String sizeToBePlanted;
  final String pitSize;
  final String spacing;
  final String annualCarbonOffset;
  final String createdAt;
  final String updatedAt;
  final String addedBy;
  final String updatedBy;

  TreeSpecies({
    required this.id,
    required this.diseases,
    required this.servicePricing,
    required this.waterAndCareInfo,
    required this.addedById,
    required this.updatedById,
    required this.treeName,
    required this.scientificName,
    required this.speciesName,
    required this.localName,
    required this.image,
    required this.type,
    required this.category,
    required this.nativeRegion,
    required this.droughtTolerance,
    required this.soilType,
    required this.suitableWeather,
    required this.humidity,
    required this.shortDescription,
    required this.lifespanYears,
    required this.treeDetails,
    required this.identificationMethod,
    required this.avgTreeHeight,
    required this.avgTreeGirth,
    required this.sizeToBePlanted,
    required this.pitSize,
    required this.spacing,
    required this.annualCarbonOffset,
    required this.createdAt,
    required this.updatedAt,
    required this.addedBy,
    required this.updatedBy,
  });

  factory TreeSpecies.fromJson(Map<String, dynamic> json) {
    return TreeSpecies(
      id: json["id"],
      diseases: (json["diseases"] as List)
          .map((e) => Disease.fromJson(e))
          .toList(),
      servicePricing: json["service_pricing"] != null
          ? ServicePricing.fromJson(json["service_pricing"])
          : null,
      waterAndCareInfo: json["water_and_care_info"],
      addedById: json["added_by_id"],
      updatedById: json["updated_by_id"],
      treeName: json["tree_name"],
      scientificName: json["scientific_name"],
      speciesName: json["species_name"],
      localName: json["local_name"],
      image: json["image"],
      type: json["type"],
      category: json["category"],
      nativeRegion: json["native_region"],
      droughtTolerance: json["drought_tolerance"],
      soilType: json["soil_type"],
      suitableWeather: json["suitable_weather"],
      humidity: json["humidity"],
      shortDescription: json["short_description"],
      lifespanYears: json["lifespan_years"],
      treeDetails: json["tree_details"],
      identificationMethod: json["identification_method"],
      avgTreeHeight: json["avg_tree_height"],
      avgTreeGirth: json["avg_tree_girth"],
      sizeToBePlanted: json["size_to_be_planted"],
      pitSize: json["pit_size"],
      spacing: json["spacing"],
      annualCarbonOffset: json["annual_carbon_offset"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      addedBy: json["added_by"],
      updatedBy: json["updated_by"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "diseases": diseases.map((e) => e.toJson()).toList(),
      "service_pricing": servicePricing?.toJson(),
      "water_and_care_info": waterAndCareInfo,
      "added_by_id": addedById,
      "updated_by_id": updatedById,
      "tree_name": treeName,
      "scientific_name": scientificName,
      "species_name": speciesName,
      "local_name": localName,
      "image": image,
      "type": type,
      "category": category,
      "native_region": nativeRegion,
      "drought_tolerance": droughtTolerance,
      "soil_type": soilType,
      "suitable_weather": suitableWeather,
      "humidity": humidity,
      "short_description": shortDescription,
      "lifespan_years": lifespanYears,
      "tree_details": treeDetails,
      "identification_method": identificationMethod,
      "avg_tree_height": avgTreeHeight,
      "avg_tree_girth": avgTreeGirth,
      "size_to_be_planted": sizeToBePlanted,
      "pit_size": pitSize,
      "spacing": spacing,
      "annual_carbon_offset": annualCarbonOffset,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "added_by": addedBy,
      "updated_by": updatedBy,
    };
  }
}

class Disease {
  final String id;
  final String diseaseName;
  final String scientificName;
  final String symptoms;
  final String cause;
  final String treatment;
  final String prevention;
  final String? image;
  final String createdAt;
  final String updatedAt;

  Disease({
    required this.id,
    required this.diseaseName,
    required this.scientificName,
    required this.symptoms,
    required this.cause,
    required this.treatment,
    required this.prevention,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      id: json["id"],
      diseaseName: json["disease_name"],
      scientificName: json["scientific_name"],
      symptoms: json["symptoms"],
      cause: json["cause"],
      treatment: json["treatment"],
      prevention: json["prevention"],
      image: json["image"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "disease_name": diseaseName,
      "scientific_name": scientificName,
      "symptoms": symptoms,
      "cause": cause,
      "treatment": treatment,
      "prevention": prevention,
      "image": image,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}

class ServicePricing {
  final String id;
  final String plantingPrice;
  final String transplantationPrice;
  final String monitoringPrice;
  final String maintenancePrice;
  final String cuttingPrice;
  final String treeSpecies;

  ServicePricing({
    required this.id,
    required this.plantingPrice,
    required this.transplantationPrice,
    required this.monitoringPrice,
    required this.maintenancePrice,
    required this.cuttingPrice,
    required this.treeSpecies,
  });

  factory ServicePricing.fromJson(Map<String, dynamic> json) {
    return ServicePricing(
      id: json["id"],
      plantingPrice: json["planting_price"],
      transplantationPrice: json["transplantation_price"],
      monitoringPrice: json["monitoring_price"],
      maintenancePrice: json["maintenance_price"],
      cuttingPrice: json["cutting_price"],
      treeSpecies: json["tree_species"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "planting_price": plantingPrice,
      "transplantation_price": transplantationPrice,
      "monitoring_price": monitoringPrice,
      "maintenance_price": maintenancePrice,
      "cutting_price": cuttingPrice,
      "tree_species": treeSpecies,
    };
  }
}

/*
// --- TreeSpecies Model (No changes needed) ---
class TreeSpecies {
  final String id;
  final List<Disease> diseases;
  final String addedById;
  final String updatedById;
  final String treeName;
  final String scientificName;
  final String speciesName;
  final String localName;
  final String? image;
  final String type;
  final String category;
  final String nativeRegion;
  final String droughtTolerance;
  final String soilType;
  final String suitableWeather;
  final String humidity;
  final String shortDescription;
  final int lifespanYears;
  final String treeDetails;
  final String identificationMethod;
  final String avgTreeHeight;
  final String avgTreeGirth;
  final String sizeToBePlanted;
  final String pitSize;
  final String spacing;
  final String annualCarbonOffset;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String addedBy;
  final String updatedBy;

  TreeSpecies({
    required this.id,
    required this.diseases,
    required this.addedById,
    required this.updatedById,
    required this.treeName,
    required this.scientificName,
    required this.speciesName,
    required this.localName,
    this.image,
    required this.type,
    required this.category,
    required this.nativeRegion,
    required this.droughtTolerance,
    required this.soilType,
    required this.suitableWeather,
    required this.humidity,
    required this.shortDescription,
    required this.lifespanYears,
    required this.treeDetails,
    required this.identificationMethod,
    required this.avgTreeHeight,
    required this.avgTreeGirth,
    required this.sizeToBePlanted,
    required this.pitSize,
    required this.spacing,
    required this.annualCarbonOffset,
    required this.createdAt,
    required this.updatedAt,
    required this.addedBy,
    required this.updatedBy,
  });

  factory TreeSpecies.fromJson(Map<String, dynamic> json) {
    return TreeSpecies(
      id: json['id'] as String,
      diseases: (json['diseases'] as List<dynamic>)
          .map((e) => Disease.fromJson(e as Map<String, dynamic>))
          .toList(),
      addedById: json['added_by_id'] as String,
      updatedById: json['updated_by_id'] as String,
      treeName: json['tree_name'] as String,
      scientificName: json['scientific_name'] as String,
      speciesName: json['species_name'] as String,
      localName: json['local_name'] as String,
      image: json['image'] as String?,
      type: json['type'] as String,
      category: json['category'] as String,
      nativeRegion: json['native_region'] as String,
      droughtTolerance: json['drought_tolerance'] as String,
      soilType: json['soil_type'] as String,
      suitableWeather: json['suitable_weather'] as String,
      humidity: json['humidity'] as String,
      shortDescription: json['short_description'] as String,
      lifespanYears: json['lifespan_years'] as int,
      treeDetails: json['tree_details'] as String,
      identificationMethod: json['identification_method'] as String,
      avgTreeHeight: json['avg_tree_height'] as String,
      avgTreeGirth: json['avg_tree_girth'] as String,
      sizeToBePlanted: json['size_to_be_planted'] as String,
      pitSize: json['pit_size'] as String,
      spacing: json['spacing'] as String,
      annualCarbonOffset: json['annual_carbon_offset'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      addedBy: json['added_by'] as String,
      updatedBy: json['updated_by'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'diseases': diseases.map((e) => e.toJson()).toList(),
      'added_by_id': addedById,
      'updated_by_id': updatedById,
      'tree_name': treeName,
      'scientific_name': scientificName,
      'species_name': speciesName,
      'local_name': localName,
      'image': image,
      'type': type,
      'category': category,
      'native_region': nativeRegion,
      'drought_tolerance': droughtTolerance,
      'soil_type': soilType,
      'suitable_weather': suitableWeather,
      'humidity': humidity,
      'short_description': shortDescription,
      'lifespan_years': lifespanYears,
      'tree_details': treeDetails,
      'identification_method': identificationMethod,
      'avg_tree_height': avgTreeHeight,
      'avg_tree_girth': avgTreeGirth,
      'size_to_be_planted': sizeToBePlanted,
      'pit_size': pitSize,
      'spacing': spacing,
      'annual_carbon_offset': annualCarbonOffset,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// --- Disease Model (No changes needed) ---
class Disease {
  final String id;
  final String diseaseName;
  final String scientificName;
  final String symptoms;
  final String cause;
  final String treatment;
  final String prevention;
  final String? image;
  final DateTime createdAt;
  final DateTime updatedAt;

  Disease({
    required this.id,
    required this.diseaseName,
    required this.scientificName,
    required this.symptoms,
    required this.cause,
    required this.treatment,
    required this.prevention,
    this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      id: json['id'] as String,
      diseaseName: json['disease_name'] as String,
      scientificName: json['scientific_name'] as String,
      symptoms: json['symptoms'] as String,
      cause: json['cause'] as String,
      treatment: json['treatment'] as String,
      prevention: json['prevention'] as String,
      image: json['image'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'disease_name': diseaseName,
      'scientific_name': scientificName,
      'symptoms': symptoms,
      'cause': cause,
      'treatment': treatment,
      'prevention': prevention,
      'image': image,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

 */


// TODO Single Tree Details Response

// New helper functions for single tree response
SingleTreeSpeciesResponse singleTreeSpeciesResponseFromJson(String str) =>
    SingleTreeSpeciesResponse.fromJson(json.decode(str));

String singleTreeSpeciesResponseToJson(SingleTreeSpeciesResponse data) =>
    json.encode(data.toJson());

// --- New Top-level Model for Single Tree Details ---
class SingleTreeSpeciesResponse {
  final String status;
  final String message;
  final TreeSpecies data; // 'data' is now a single TreeSpecies object

  SingleTreeSpeciesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SingleTreeSpeciesResponse.fromJson(Map<String, dynamic> json) {
    return SingleTreeSpeciesResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data: TreeSpecies.fromJson(json['data'] as Map<String, dynamic>), // Directly parse the TreeSpecies object
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}
