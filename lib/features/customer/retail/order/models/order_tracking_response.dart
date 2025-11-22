// To parse this JSON data, do
//
//     final orderTrackingResponse = orderTrackingResponseFromJson(jsonString);

import 'dart:convert';
import 'package:intl/intl.dart';

OrderTrackingResponse orderTrackingResponseFromJson(String str) =>
    OrderTrackingResponse.fromJson(json.decode(str));

String orderTrackingResponseToJson(OrderTrackingResponse data) =>
    json.encode(data.toJson());

class OrderTrackingResponse {
  final String status;
  final String message;
  final OrderTrackingData data;

  OrderTrackingResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory OrderTrackingResponse.fromJson(Map<String, dynamic> json) =>
      OrderTrackingResponse(
        status: json["status"],
        message: json["message"],
        data: OrderTrackingData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class OrderTrackingData {
  final String orderId;
  final String currentStatus;
  final String ? orderNumber;
  final List<TimelineItem> timeline;

  OrderTrackingData({
    required this.orderId,
    required this.currentStatus,
    this.orderNumber,
    required this.timeline,
  });

  factory OrderTrackingData.fromJson(Map<String, dynamic> json) =>
      OrderTrackingData(
        orderId: json["order_id"],
        currentStatus: json["current_status"],
        orderNumber: json["order_number"],
        timeline: List<TimelineItem>.from(
            json["timeline"].map((x) => TimelineItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "current_status": currentStatus,
    "order_number":orderNumber,
    "timeline": List<dynamic>.from(timeline.map((x) => x.toJson())),
  };
}

class TimelineItem {
  final String status;
  final String label;
  final bool achieved;
  final String? timestamp;
  final bool current;

  TimelineItem({
    required this.status,
    required this.label,
    required this.achieved,
    this.timestamp,
    required this.current,
  });

  factory TimelineItem.fromJson(Map<String, dynamic> json) => TimelineItem(
    status: json["status"],
    label: json["label"],
    achieved: json["achieved"],
    timestamp: json["timestamp"] as String?,
    current: json["current"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "label": label,
    "achieved": achieved,
    "timestamp": timestamp,
    "current": current,
  };

  /// ✅ Human-readable formatted timestamp like "Aug 29, 2025 • 2:30 PM"
  String get formattedTimestamp {
    if (timestamp == null || timestamp!.isEmpty) return "";
    try {
      final dateTime = DateTime.parse(timestamp!); // assumes ISO 8601 string
      return DateFormat("MMM d, yyyy • h:mm a").format(dateTime);
    } catch (e) {
      return timestamp!; // fallback in case parsing fails
    }
  }
}