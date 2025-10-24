import 'dart:convert';

// --- Top Level Convenience Functions ---
/// Decodes a raw JSON string into the NotificationResponse model.
NotificationResponse notificationResponseFromJson(String str) =>
    NotificationResponse.fromJson(json.decode(str) as Map<String, dynamic>);

/// Encodes a NotificationResponse model into a raw JSON string.
String notificationResponseToJson(NotificationResponse data) =>
    json.encode(data.toJson());

// --- Top Level Response Model ---
/// Represents the full JSON response from the API.
class NotificationResponse {
  final String status;
  final String message;
  final List<NotificationItem> data;

  NotificationResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  /// Factory method to create an instance from a JSON map.
  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      // Map the list of dynamic objects to a List of NotificationItem
      data: (json['data'] as List<dynamic>)
          .map((item) => NotificationItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Helper to decode a raw JSON string into the model.
  factory NotificationResponse.fromRawJson(String str) {
    return NotificationResponse.fromJson(json.decode(str) as Map<String, dynamic>);
  }

  /// Converts this object into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      // Map the list of NotificationItem objects to a list of JSON maps
      'data': data.map((item) => item.toJson()).toList(),
    };
  }

  /// Converts this object into a raw JSON string.
  String toRawJson() => json.encode(toJson());
}


// --- Individual Notification Item Model ---
/// Represents a single notification item in the 'data' array.
class NotificationItem {
  final String id;
  final String user;
  final String userName; // Mapped from 'user_name'
  final String title;
  final String message;
  final String type;
  final String typeDisplay; // Mapped from 'type_display'
  final String? relatedObjectType; // Mapped from 'related_object_type', can be null
  final String? relatedObjectId; // Mapped from 'related_object_id', can be null
  final bool isRead; // Mapped from 'is_read'
  final bool isActionable; // Mapped from 'is_actionable'
  final DateTime createdAt; // Mapped from 'created_at' and parsed into DateTime

  NotificationItem({
    required this.id,
    required this.user,
    required this.userName,
    required this.title,
    required this.message,
    required this.type,
    required this.typeDisplay,
    this.relatedObjectType,
    this.relatedObjectId,
    required this.isRead,
    required this.isActionable,
    required this.createdAt,
  });

  /// Factory method to create an instance from a JSON map.
  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    // Helper function to safely cast to a boolean, handling potential null or non-boolean types if the API is inconsistent
    bool _parseBool(dynamic value) {
      if (value is bool) return value;
      if (value is String) return value.toLowerCase() == 'true' || value == '1';
      if (value is int) return value != 0;
      return false;
    }

    return NotificationItem(
      id: json['id'] as String,
      user: json['user'] as String,
      // Mapping snake_case JSON keys to Dart's camelCase fields
      userName: json['user_name'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      typeDisplay: json['type_display'] as String,

      // Handle potentially null fields
      relatedObjectType: json['related_object_type'] as String?,
      relatedObjectId: json['related_object_id'] as String?,

      // Use the helper to ensure safe casting for booleans
      isRead: _parseBool(json['is_read']),
      isActionable: _parseBool(json['is_actionable']),

      // Parse the ISO 8601 string into a DateTime object
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Converts this object back into a JSON map (using snake_case keys).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'user_name': userName, // Convert camelCase back to snake_case
      'title': title,
      'message': message,
      'type': type,
      'type_display': typeDisplay, // Convert camelCase back to snake_case
      'related_object_type': relatedObjectType, // Convert camelCase back to snake_case
      'related_object_id': relatedObjectId, // Convert camelCase back to snake_case
      'is_read': isRead,
      'is_actionable': isActionable,
      // Convert DateTime back to an ISO 8601 string (UTC recommended)
      'created_at': createdAt.toUtc().toIso8601String(),
    };
  }
}
