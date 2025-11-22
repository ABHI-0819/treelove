/* Request Parameter for this api */
//inquiry_type = (plantation,maintenance,monitoring,mixed)
//tree_ids (if existing trees)
//location_pin (optional)
//address (optional)
//full_name (optional)
//email (optional)
//phone (optional)
/*
import 'dart:convert';

import '../../../../../core/config/constants/enum/inquiry_type_enum.dart';

// Define the valid inquiry types for clarity and safety


class InquiryRequestModel {
  // Required
  final InquiryType inquiryType; // (plantation,maintenance,monitoring,mixed)

  // Optional
  final List<String>? treeIds;   // array<string> of existing tree IDs
  final String? locationPin;    // postal code, zip code, or specific pin
  final String? address;        // full address string
  final String? fullName;       // full name of the inquirer
  final String? email;          // email of the inquirer
  final String? phone;          // phone number of the inquirer
  final String? description;
  InquiryRequestModel({
    required this.inquiryType,
    this.treeIds,
    this.locationPin,
    this.address,
    this.fullName,
    this.email,
    this.phone,
    this.description
  });

  /// Convert → JSON map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = {
      "inquiry_type": inquiryType.value,
    };

    void addIfNotNull(String key, dynamic value) {
      if (value != null) {
        if (value is String && value.trim().isEmpty) return;
        if (value is List && value.isEmpty) return;
        jsonMap[key] = value;
      }
    }

    addIfNotNull("tree_ids", treeIds);
    addIfNotNull("location_pin", locationPin);
    addIfNotNull("address", address);
    addIfNotNull("full_name", fullName);
    addIfNotNull("email", email);
    addIfNotNull("phone", phone);
    addIfNotNull("description", description);

    return jsonMap;
  }

  /// Convert → JSON string
  String toJsonString() => jsonEncode(toJson());

  /// Convert → multipart fields (all string values)
  Map<String, String> toFields() {
    final Map<String, String> fields = {
      "inquiry_type": inquiryType.value,
    };

    void addIfNotNull(String key, dynamic value) {
      if (value != null) {
        if (value is List && value.isNotEmpty) {
          fields[key] = value.join(','); // arrays → comma-separated string
        } else {
          fields[key] = value.toString();
        }
      }
    }

    addIfNotNull("tree_ids", treeIds);
    addIfNotNull("location_pin", locationPin);
    addIfNotNull("address", address);
    addIfNotNull("full_name", fullName);
    addIfNotNull("email", email);
    addIfNotNull("phone", phone);
    addIfNotNull("description", description);

    return fields;
  }
}

 */

import 'dart:convert';

import '../../../../../core/config/constants/enum/inquiry_type_enum.dart';

class InquiryRequestModel {
  // Required
  final InquiryType inquiryType;

  // Optional
  final List<String>? treeIds;
  final String? locationPin;    // Now: stringified GeoJSON or null
  final String? address;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? description;

  // Private constructor to enforce correct usage
  InquiryRequestModel._({
    required this.inquiryType,
    this.treeIds,
    this.locationPin,
    this.address,
    this.fullName,
    this.email,
    this.phone,
    this.description,
  });

  // ✅ Public factory: use this to create from coordinates
  factory InquiryRequestModel.withLocation({
    required InquiryType inquiryType,
    double? latitude,
    double? longitude,
    List<String>? treeIds,
    String? address,
    String? fullName,
    String? email,
    String? phone,
    String? description,
  }) {
    String? geoJsonString;
    if (latitude != null && longitude != null) {
      final geoJson = {
        "type": "Point",
        "coordinates": [longitude, latitude], // [lng, lat]
      };
      geoJsonString = jsonEncode(geoJson);
    }

    return InquiryRequestModel._(
      inquiryType: inquiryType,
      treeIds: treeIds,
      locationPin: geoJsonString, // ← stringified GeoJSON
      address: address,
      fullName: fullName,
      email: email,
      phone: phone,
      description: description,
    );
  }

  // Optional: allow legacy string (e.g., for tree-based inquiries without coords)
  factory InquiryRequestModel.withoutLocation({
    required InquiryType inquiryType,
    List<String>? treeIds,
    String? locationPin, // e.g., pincode (if backend allows fallback)
    String? address,
    String? fullName,
    String? email,
    String? phone,
    String? description,
  }) {
    return InquiryRequestModel._(
      inquiryType: inquiryType,
      treeIds: treeIds,
      locationPin: locationPin,
      address: address,
      fullName: fullName,
      email: email,
      phone: phone,
      description: description,
    );
  }

  // --- Rest remains almost same ---

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = {
      "inquiry_type": inquiryType.value,
    };

    void addIfNotNull(String key, dynamic value) {
      if (value != null) {
        if (value is String && value.trim().isEmpty) return;
        if (value is List && value.isEmpty) return;
        jsonMap[key] = value;
      }
    }

    addIfNotNull("tree_ids", treeIds);
    addIfNotNull("location_pin", locationPin); // now a JSON string
    addIfNotNull("address", address);
    addIfNotNull("full_name", fullName);
    addIfNotNull("email", email);
    addIfNotNull("phone", phone);
    addIfNotNull("description", description);

    return jsonMap;
  }

  String toJsonString() => jsonEncode(toJson());

  Map<String, String> toFields() {
    final Map<String, String> fields = {
      "inquiry_type": inquiryType.value,
    };

    void addIfNotNull(String key, dynamic value) {
      if (value != null) {
        if (value is List && value.isNotEmpty) {
          fields[key] = value.join(',');
        } else {
          fields[key] = value.toString();
        }
      }
    }

    addIfNotNull("tree_ids", treeIds);
    addIfNotNull("location_pin", locationPin); // ✅ now safe: it's a string
    addIfNotNull("address", address);
    addIfNotNull("full_name", fullName);
    addIfNotNull("email", email);
    addIfNotNull("phone", phone);
    addIfNotNull("description", description);

    return fields;
  }
}



