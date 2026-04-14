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
        status: json["status"] ?? "",
        message: json["message"] ?? "",
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
  final String? orderNumber;
  final String currentStatus;
  final double? totalAmount;
  final DateTime? createdAt;
  final List<OrderItem> items;
  final List<TimelineItem> timeline;

  OrderTrackingData({
    required this.orderId,
    this.orderNumber,
    required this.currentStatus,
    this.totalAmount,
    this.createdAt,
    required this.items,
    required this.timeline,
  });

  factory OrderTrackingData.fromJson(Map<String, dynamic> json) =>
      OrderTrackingData(
        orderId: json["id"] ?? json["order_id"] ?? "",
        orderNumber: json["order_number"] as String?,
        currentStatus: json["status"] ?? json["current_status"] ?? "",
        totalAmount: json["total_amount"] != null
            ? double.tryParse(json["total_amount"].toString())
            : null,
        createdAt: json["created_at"] != null
            ? DateTime.tryParse(json["created_at"] as String)
            : null,
        items: json["items"] != null
            ? List<OrderItem>.from(
                (json["items"] as List).map((x) => OrderItem.fromJson(x)))
            : [],
        timeline: json["timeline"] != null
            ? List<TimelineItem>.from(
                (json["timeline"] as List).map((x) => TimelineItem.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
    "id": orderId,
    "order_number": orderNumber,
    "status": currentStatus,
    "total_amount": totalAmount,
    "created_at": createdAt?.toIso8601String(),
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "timeline": List<dynamic>.from(timeline.map((x) => x.toJson())),
  };
}

class OrderItem {
  final String id;
  final String serviceTypeName;
  final String treeName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  OrderItem({
    required this.id,
    required this.serviceTypeName,
    required this.treeName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    id: json["id"] ?? "",
    serviceTypeName: json["service_type_name"] ?? "",
    treeName: json["tree_name"] ?? "",
    quantity: json["quantity"] ?? 1,
    unitPrice: double.tryParse(json["unit_price"].toString()) ?? 0.0,
    totalPrice: double.tryParse(json["total_price"].toString()) ?? 0.0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "service_type_name": serviceTypeName,
    "tree_name": treeName,
    "quantity": quantity,
    "unit_price": unitPrice,
    "total_price": totalPrice,
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
    status: json["status"] ?? "",
    label: json["label"] ?? "",
    achieved: json["achieved"] ?? false,
    timestamp: json["timestamp"] as String?,
    current: json["current"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "label": label,
    "achieved": achieved,
    "timestamp": timestamp,
    "current": current,
  };

  /// ✅ Human-readable formatted timestamp like "Jan 30, 2026 • 7:44 AM"
  String get formattedTimestamp {
    if (timestamp == null || timestamp!.isEmpty) return "";
    try {
      final dateTime = DateTime.parse(timestamp!);
      return DateFormat("MMM d, yyyy • h:mm a").format(dateTime.toLocal());
    } catch (e) {
      return timestamp!;
    }
  }
}