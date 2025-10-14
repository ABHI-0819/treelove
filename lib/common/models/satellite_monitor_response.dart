import 'dart:convert';
/*
// --- Top-Level Utility Methods for Serialization ---

/// Converts a raw JSON string to a SatelliteMonitorResponse object.
SatelliteMonitorResponse satelliteMonitorResponseFromJson(String str) =>
    SatelliteMonitorResponse.fromJson(json.decode(str) as Map<String, dynamic>);

/// Converts a SatelliteMonitorResponse object to a JSON string.
String satelliteMonitorResponseToJson(SatelliteMonitorResponse data) =>
    json.encode(data.toJson());

// --- Dart Model Classes (Including toJson() methods) ---

// Top-level class for the entire API response
class SatelliteMonitorResponse {
  final String status;
  final String message;
  final SatelliteMonitorData data;

  SatelliteMonitorResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SatelliteMonitorResponse.fromJson(Map<String, dynamic> json) {
    return SatelliteMonitorResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data: SatelliteMonitorData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data.toJson(),
  };
}

// Class for the 'data' field
class SatelliteMonitorData {
  final String id;
  final List<MediaItem> media;
  final List<String> plantation;
  final TreeSpecies treeSpecies;
  final String monitoringStatus;
  final String monitoringStatusColor;
  final String monitoringStatusDays;
  final LocationData location;
  final String remarks;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime monitoringDate;
  final DateTime nextScheduledDate;
  final String weatherCondition;
  final String monitoringType;
  final String monitoringMode;
  final String canopySize;
  final String canopySizeUnit;
  final String treeHealth;
  final String treeGrowth;
  final String jobId;
  final String detectionMethod;
  final String confidence;
  final String ndvi;
  final String vari;
  final String gli;
  final String exg;
  final String tgi;
  final String geojsonUrl;
  final String modelType;
  final String processingTimeSeconds;
  final int detectionCount;
  final String services;
  final String vendor;
  final String createdBy;
  final String updatedBy;
  final List<String> treeDiseases;

  SatelliteMonitorData({
    required this.id,
    required this.media,
    required this.plantation,
    required this.treeSpecies,
    required this.monitoringStatus,
    required this.monitoringStatusColor,
    required this.monitoringStatusDays,
    required this.location,
    required this.remarks,
    required this.createdAt,
    required this.updatedAt,
    required this.monitoringDate,
    required this.nextScheduledDate,
    required this.weatherCondition,
    required this.monitoringType,
    required this.monitoringMode,
    required this.canopySize,
    required this.canopySizeUnit,
    required this.treeHealth,
    required this.treeGrowth,
    required this.jobId,
    required this.detectionMethod,
    required this.confidence,
    required this.ndvi,
    required this.vari,
    required this.gli,
    required this.exg,
    required this.tgi,
    required this.geojsonUrl,
    required this.modelType,
    required this.processingTimeSeconds,
    required this.detectionCount,
    required this.services,
    required this.vendor,
    required this.createdBy,
    required this.updatedBy,
    required this.treeDiseases,
  });

  factory SatelliteMonitorData.fromJson(Map<String, dynamic> json) {
    return SatelliteMonitorData(
      id: json['id'] as String,
      media: (json['media'] as List<dynamic>)
          .map((e) => MediaItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      plantation: List<String>.from(json['plantation'] as List),
      treeSpecies: TreeSpecies.fromJson(json['tree_species'] as Map<String, dynamic>),
      monitoringStatus: json['monitoring_status'] as String,
      monitoringStatusColor: json['monitoring_status_color'] as String,
      monitoringStatusDays: json['monitoring_status_days'] as String,
      location: LocationData.fromJson(json['location'] as Map<String, dynamic>),
      remarks: json['remarks'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      monitoringDate: DateTime.parse(json['monitoring_date'] as String),
      nextScheduledDate: DateTime.parse(json['next_scheduled_date'] as String),
      weatherCondition: json['weather_condition'] as String,
      monitoringType: json['monitoring_type'] as String,
      monitoringMode: json['monitoring_mode'] as String,
      canopySize: json['canopy_size'] as String,
      canopySizeUnit: json['canopy_size_unit'] as String,
      treeHealth: json['tree_health'] as String,
      treeGrowth: json['tree_growth'] as String,
      jobId: json['job_id'] as String,
      detectionMethod: json['detection_method'] as String,
      confidence: json['confidence'] as String,
      ndvi: json['ndvi'] as String,
      vari: json['vari'] as String,
      gli: json['gli'] as String,
      exg: json['exg'] as String,
      tgi: json['tgi'] as String,
      geojsonUrl: json['geojson_url'] as String,
      modelType: json['model_type'] as String,
      processingTimeSeconds: json['processing_time_seconds'] as String,
      detectionCount: json['detection_count'] as int,
      services: json['services'] as String,
      vendor: json['vendor'] as String,
      createdBy: json['created_by'] as String,
      updatedBy: json['updated_by'] as String,
      treeDiseases: List<String>.from(json['tree_diseases'] as List),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'media': media.map((x) => x.toJson()).toList(),
    'plantation': List<dynamic>.from(plantation.map((x) => x)),
    'tree_species': treeSpecies.toJson(),
    'monitoring_status': monitoringStatus,
    'monitoring_status_color': monitoringStatusColor,
    'monitoring_status_days': monitoringStatusDays,
    'location': location.toJson(),
    'remarks': remarks,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'monitoring_date': monitoringDate.toIso8601String().split('T').first,
    'next_scheduled_date': nextScheduledDate.toIso8601String().split('T').first,
    'weather_condition': weatherCondition,
    'monitoring_type': monitoringType,
    'monitoring_mode': monitoringMode,
    'canopy_size': canopySize,
    'canopy_size_unit': canopySizeUnit,
    'tree_health': treeHealth,
    'tree_growth': treeGrowth,
    'job_id': jobId,
    'detection_method': detectionMethod,
    'confidence': confidence,
    'ndvi': ndvi,
    'vari': vari,
    'gli': gli,
    'exg': exg,
    'tgi': tgi,
    'geojson_url': geojsonUrl,
    'model_type': modelType,
    'processing_time_seconds': processingTimeSeconds,
    'detection_count': detectionCount,
    'services': services,
    'vendor': vendor,
    'created_by': createdBy,
    'updated_by': updatedBy,
    'tree_diseases': List<dynamic>.from(treeDiseases.map((x) => x)),
  };
}

// Class for items in the 'media' array
class MediaItem {
  final String id;
  final String media;
  final String type;

  MediaItem({
    required this.id,
    required this.media,
    required this.type,
  });

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      id: json['id'] as String,
      media: json['media'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'media': media,
    'type': type,
  };
}

// Class for the 'tree_species' field
class TreeSpecies {
  final String id;
  final String localName;
  final String image;
  final String scientificName;

  TreeSpecies({
    required this.id,
    required this.localName,
    required this.image,
    required this.scientificName,
  });

  factory TreeSpecies.fromJson(Map<String, dynamic> json) {
    return TreeSpecies(
      id: json['id'] as String,
      localName: json['local_name'] as String,
      image: json['image'] as String,
      scientificName: json['scientific_name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'local_name': localName,
    'image': image,
    'scientific_name': scientificName,
  };
}

// Class for the 'location' field (GeoJSON Point structure)
class LocationData {
  final String type;
  final List<double> coordinates;

  LocationData({
    required this.type,
    required this.coordinates,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      type: json['type'] as String,
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => e as double)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'coordinates': List<dynamic>.from(coordinates.map((x) => x)),
  };
}

*/

/*
import 'dart:convert';

/// Converts a raw JSON string to a SatelliteMonitorResponse object.
SatelliteMonitorResponse satelliteMonitorResponseFromJson(String str) =>
    SatelliteMonitorResponse.fromJson(json.decode(str) as Map<String, dynamic>);

/// Converts a SatelliteMonitorResponse object to a JSON string.
String satelliteMonitorResponseToJson(SatelliteMonitorResponse data) =>
    json.encode(data.toJson());

class SatelliteMonitorResponse {
  final String status;
  final String message;
  final List<SatelliteMonitorData> data;

  SatelliteMonitorResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SatelliteMonitorResponse.fromJson(Map<String, dynamic> json) {
    return SatelliteMonitorResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => SatelliteMonitorData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data.map((x) => x.toJson()).toList(),
  };
}

class SatelliteMonitorData {
  final String id;
  final String jobId;
  final List<String> plantation;
  final DateTime monitoringDate;
  final DateTime nextScheduledDate;
  final TreeSpecies treeSpecies;
  final LocationData location;
  final double canopySize;
  final String canopySizeUnit;
  final String detectionMethod;
  final double confidence;
  final String treeHealth;
  final String treeGrowth;
  final double ndvi;
  final double vari;
  final double gli;
  final double exg;
  final double tgi;
  final String modelType;
  final int detectionCount;
  final DateTime createdAt;
  final dynamic thumbnail; // Can be null
  final String monitoringStatus;
  final String monitoringStatusColor;
  final int monitoringStatusDays;

  SatelliteMonitorData({
    required this.id,
    required this.jobId,
    required this.plantation,
    required this.monitoringDate,
    required this.nextScheduledDate,
    required this.treeSpecies,
    required this.location,
    required this.canopySize,
    required this.canopySizeUnit,
    required this.detectionMethod,
    required this.confidence,
    required this.treeHealth,
    required this.treeGrowth,
    required this.ndvi,
    required this.vari,
    required this.gli,
    required this.exg,
    required this.tgi,
    required this.modelType,
    required this.detectionCount,
    required this.createdAt,
    this.thumbnail,
    required this.monitoringStatus,
    required this.monitoringStatusColor,
    required this.monitoringStatusDays,
  });

  factory SatelliteMonitorData.fromJson(Map<String, dynamic> json) {
    return SatelliteMonitorData(
      id: json['id'] as String,
      jobId: json['job_id'] as String,
      plantation: List<String>.from(json['plantation'] as List),
      monitoringDate: DateTime.parse(json['monitoring_date'] as String),
      nextScheduledDate: DateTime.parse(json['next_scheduled_date'] as String),
      treeSpecies: TreeSpecies.fromJson(json['tree_species'] as Map<String, dynamic>),
      location: LocationData.fromJson(json['location'] as Map<String, dynamic>),
      canopySize: double.parse(json['canopy_size'] as String),
      canopySizeUnit: json['canopy_size_unit'] as String,
      detectionMethod: json['detection_method'] as String,
      confidence: double.parse(json['confidence'] as String),
      treeHealth: json['tree_health'] as String,
      treeGrowth: json['tree_growth'] as String,
      ndvi: double.parse(json['ndvi'] as String),
      vari: double.parse(json['vari'] as String),
      gli: double.parse(json['gli'] as String),
      exg: double.parse(json['exg'] as String),
      tgi: double.parse(json['tgi'] as String),
      modelType: json['model_type'] as String,
      detectionCount: json['detection_count'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      thumbnail: json['thumbnail'],
      monitoringStatus: json['monitoring_status'] as String,
      monitoringStatusColor: json['monitoring_status_color'] as String,
      monitoringStatusDays: json['monitoring_status_days'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'job_id': jobId,
    'plantation': List<dynamic>.from(plantation.map((x) => x)),
    'monitoring_date': monitoringDate.toIso8601String().split('T').first,
    'next_scheduled_date': nextScheduledDate.toIso8601String().split('T').first,
    'tree_species': treeSpecies.toJson(),
    'location': location.toJson(),
    'canopy_size': canopySize.toString(),
    'canopy_size_unit': canopySizeUnit,
    'detection_method': detectionMethod,
    'confidence': confidence.toString(),
    'tree_health': treeHealth,
    'tree_growth': treeGrowth,
    'ndvi': ndvi.toString(),
    'vari': vari.toString(),
    'gli': gli.toString(),
    'exg': exg.toString(),
    'tgi': tgi.toString(),
    'model_type': modelType,
    'detection_count': detectionCount,
    'created_at': createdAt.toIso8601String(),
    'thumbnail': thumbnail,
    'monitoring_status': monitoringStatus,
    'monitoring_status_color': monitoringStatusColor,
    'monitoring_status_days': monitoringStatusDays,
  };
}

class TreeSpecies {
  final String id;
  final String localName;
  final String image;
  final String scientificName;

  TreeSpecies({
    required this.id,
    required this.localName,
    required this.image,
    required this.scientificName,
  });

  factory TreeSpecies.fromJson(Map<String, dynamic> json) {
    return TreeSpecies(
      id: json['id'] as String,
      localName: json['local_name'] as String,
      image: json['image'] as String,
      scientificName: json['scientific_name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'local_name': localName,
    'image': image,
    'scientific_name': scientificName,
  };
}

class LocationData {
  final String type;
  final List<double> coordinates;

  LocationData({
    required this.type,
    required this.coordinates,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      type: json['type'] as String,
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => e as double)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'coordinates': List<dynamic>.from(coordinates.map((x) => x)),
  };
}

 */

import 'dart:convert';

SatelliteMonitorResponse satelliteMonitorResponseFromJson(String str) =>
    SatelliteMonitorResponse.fromJson(json.decode(str));

String satelliteMonitorResponseToJson(SatelliteMonitorResponse data) =>
    json.encode(data.toJson());

class SatelliteMonitorResponse {
  final String status;
  final String message;
  final SatelliteMonitorData data;

  SatelliteMonitorResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SatelliteMonitorResponse.fromJson(Map<String, dynamic> json) =>
      SatelliteMonitorResponse(
        status: json['status'] ?? '',
        message: json['message'] ?? '',
        data: SatelliteMonitorData.fromJson(json['data'] ?? {}),
      );

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data.toJson(),
  };
}

class SatelliteMonitorData {
  final String id;
  final String jobId;
  final List<String> plantation;
  final TreeSpecies? treeSpecies;
  final LocationData? location;
  final List<MediaItem> media;
  final String monitoringStatus;
  final String monitoringStatusColor;
  final int monitoringStatusDays;
  final String remarks;
  final String monitoringType;
  final String monitoringMode;
  final String weatherCondition;
  final double canopySize;
  final String canopySizeUnit;
  final String detectionMethod;
  final double confidence;
  final String treeHealth;
  final String treeGrowth;
  final double? ndvi;
  final double? vari;
  final double? gli;
  final double? exg;
  final double? tgi;
  final String modelType;
  final int detectionCount;
  final String geojsonUrl;
  final String processingTimeSeconds;
  final String services;
  final String vendor;
  final String createdBy;
  final String updatedBy;
  final List<dynamic> treeDiseases;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? monitoringDate;
  final DateTime? nextScheduledDate;

  SatelliteMonitorData({
    required this.id,
    required this.jobId,
    required this.plantation,
    required this.treeSpecies,
    required this.location,
    required this.media,
    required this.monitoringStatus,
    required this.monitoringStatusColor,
    required this.monitoringStatusDays,
    required this.remarks,
    required this.monitoringType,
    required this.monitoringMode,
    required this.weatherCondition,
    required this.canopySize,
    required this.canopySizeUnit,
    required this.detectionMethod,
    required this.confidence,
    required this.treeHealth,
    required this.treeGrowth,
    required this.ndvi,
    required this.vari,
    required this.gli,
    required this.exg,
    required this.tgi,
    required this.modelType,
    required this.detectionCount,
    required this.geojsonUrl,
    required this.processingTimeSeconds,
    required this.services,
    required this.vendor,
    required this.createdBy,
    required this.updatedBy,
    required this.treeDiseases,
    required this.createdAt,
    required this.updatedAt,
    required this.monitoringDate,
    required this.nextScheduledDate,
  });

  factory SatelliteMonitorData.fromJson(Map<String, dynamic> json) {
    double? _toDouble(dynamic value) {
      if (value == null) return null;
      return double.tryParse(value.toString());
    }

    DateTime? _toDate(dynamic value) {
      if (value == null || value.toString().isEmpty) return null;
      return DateTime.tryParse(value.toString());
    }

    return SatelliteMonitorData(
      id: json['id'] ?? '',
      jobId: json['job_id'] ?? '',
      plantation:
      (json['plantation'] as List?)?.map((e) => e.toString()).toList() ?? [],
      treeSpecies: json['tree_species'] != null
          ? TreeSpecies.fromJson(json['tree_species'])
          : null,
      location: json['location'] != null
          ? LocationData.fromJson(json['location'])
          : null,
      media: (json['media'] as List?)
          ?.map((e) => MediaItem.fromJson(e))
          .toList() ??
          [],
      monitoringStatus: json['monitoring_status'] ?? '',
      monitoringStatusColor: json['monitoring_status_color'] ?? '',
      monitoringStatusDays: json['monitoring_status_days'] ?? 0,
      remarks: json['remarks'] ?? '',
      monitoringType: json['monitoring_type'] ?? '',
      monitoringMode: json['monitoring_mode'] ?? '',
      weatherCondition: json['weather_condition'] ?? '',
      canopySize: _toDouble(json['canopy_size']) ?? 0.0,
      canopySizeUnit: json['canopy_size_unit'] ?? '',
      detectionMethod: json['detection_method'] ?? '',
      confidence: _toDouble(json['confidence']) ?? 0.0,
      treeHealth: json['tree_health'] ?? '',
      treeGrowth: json['tree_growth'] ?? '',
      ndvi: _toDouble(json['ndvi']),
      vari: _toDouble(json['vari']),
      gli: _toDouble(json['gli']),
      exg: _toDouble(json['exg']),
      tgi: _toDouble(json['tgi']),
      modelType: json['model_type'] ?? '',
      detectionCount: json['detection_count'] ?? 0,
      geojsonUrl: json['geojson_url'] ?? '',
      processingTimeSeconds: json['processing_time_seconds'] ?? '',
      services: json['services'] ?? '',
      vendor: json['vendor'] ?? '',
      createdBy: json['created_by'] ?? '',
      updatedBy: json['updated_by'] ?? '',
      treeDiseases: json['tree_diseases'] ?? [],
      createdAt: _toDate(json['created_at']),
      updatedAt: _toDate(json['updated_at']),
      monitoringDate: _toDate(json['monitoring_date']),
      nextScheduledDate: _toDate(json['next_scheduled_date']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'job_id': jobId,
    'plantation': plantation,
    'tree_species': treeSpecies?.toJson(),
    'location': location?.toJson(),
    'media': media.map((x) => x.toJson()).toList(),
    'monitoring_status': monitoringStatus,
    'monitoring_status_color': monitoringStatusColor,
    'monitoring_status_days': monitoringStatusDays,
    'remarks': remarks,
    'monitoring_type': monitoringType,
    'monitoring_mode': monitoringMode,
    'weather_condition': weatherCondition,
    'canopy_size': canopySize.toString(),
    'canopy_size_unit': canopySizeUnit,
    'detection_method': detectionMethod,
    'confidence': confidence.toString(),
    'tree_health': treeHealth,
    'tree_growth': treeGrowth,
    'ndvi': ndvi?.toString(),
    'vari': vari?.toString(),
    'gli': gli?.toString(),
    'exg': exg?.toString(),
    'tgi': tgi?.toString(),
    'model_type': modelType,
    'detection_count': detectionCount,
    'geojson_url': geojsonUrl,
    'processing_time_seconds': processingTimeSeconds,
    'services': services,
    'vendor': vendor,
    'created_by': createdBy,
    'updated_by': updatedBy,
    'tree_diseases': treeDiseases,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'monitoring_date': monitoringDate?.toIso8601String(),
    'next_scheduled_date': nextScheduledDate?.toIso8601String(),
  };
}

class TreeSpecies {
  final String id;
  final String localName;
  final String image;
  final String scientificName;

  TreeSpecies({
    required this.id,
    required this.localName,
    required this.image,
    required this.scientificName,
  });

  factory TreeSpecies.fromJson(Map<String, dynamic> json) => TreeSpecies(
    id: json['id'] ?? '',
    localName: json['local_name'] ?? '',
    image: json['image'] ?? '',
    scientificName: json['scientific_name'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'local_name': localName,
    'image': image,
    'scientific_name': scientificName,
  };
}

class LocationData {
  final String type;
  final List<double> coordinates;

  LocationData({
    required this.type,
    required this.coordinates,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) => LocationData(
    type: json['type'] ?? '',
    coordinates: (json['coordinates'] as List?)
        ?.map((e) => (e as num).toDouble())
        .toList() ??
        [],
  );

  Map<String, dynamic> toJson() => {
    'type': type,
    'coordinates': coordinates,
  };
}

class MediaItem {
  final String id;
  final String media;
  final String type;

  MediaItem({
    required this.id,
    required this.media,
    required this.type,
  });

  factory MediaItem.fromJson(Map<String, dynamic> json) => MediaItem(
    id: json['id'] ?? '',
    media: json['media'] ?? '',
    type: json['type'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'media': media,
    'type': type,
  };
}
