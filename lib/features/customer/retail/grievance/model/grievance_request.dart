import 'dart:io';

import 'package:image_picker/image_picker.dart'; // or your file type
import 'dart:convert';

class GrievanceRequestModel {
  final String? relatedObject; // e.g., project ID, plantation ID
  final int category;          // e.g., 1, 2, 3 — must be integer!
  final String description;
  final File? image;          // single image (API says "image", not array)
  final String? location;      // e.g., "Thane, Maharashtra" or lat,lng

  GrievanceRequestModel({
    this.relatedObject,
    required this.category,
    required this.description,
    this.image,
    this.location,
  });

  /// Convert to form fields (for multipart)
  Map<String, String> toFields() {
    return {
      if (relatedObject != null) 'related_object': relatedObject!,
      'category': category.toString(),        // ⚠️ Must be string for form field
      'description': description,
      if (location != null) 'location': location!,
    };
  }

  // Optional: for logging
  Map<String, dynamic> toJson() => {
    'related_object': relatedObject,
    'category': category,
    'description': description,
    'location': location,
  };

  String toJsonString() => jsonEncode(toJson());
}