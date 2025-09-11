// To parse this JSON data, do
//
//     final orderListResponse = orderListResponseFromJson(jsonString);
/*
import 'dart:convert';

OrderListResponse orderListResponseFromJson(String str) =>
    OrderListResponse.fromJson(json.decode(str));

String orderListResponseToJson(OrderListResponse data) =>
    json.encode(data.toJson());

class OrderListResponse {
  final String status;
  final String message;
  final List<OrderData> data;

  OrderListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory OrderListResponse.fromJson(Map<String, dynamic> json) =>
      OrderListResponse(
        status: json["status"],
        message: json["message"],
        data: List<OrderData>.from(
            json["data"].map((x) => OrderData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class OrderData {
  final String id;
  final String name;
  final int totalItemCount;
  final String? project;
  final String? totalAmount;
  final String? totalAmountPaid;
  final String status;
  final String paymentStatus;
  final String currency;

  OrderData({
    required this.id,
    required this.name,
    required this.totalItemCount,
    this.project,
    this.totalAmount,
    this.totalAmountPaid,
    required this.status,
    required this.paymentStatus,
    required this.currency,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
    id: json["id"],
    name: json["name"],
    totalItemCount: json["total_item_count"],
    project: json["project"] as String?,
    totalAmount: json["total_amount"] as String?,
    totalAmountPaid: json["total_amount_paid"] as String?,
    status: json["status"],
    paymentStatus: json["payment_status"],
    currency: json["currency"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "total_item_count": totalItemCount,
    "project": project,
    "total_amount": totalAmount,
    "total_amount_paid": totalAmountPaid,
    "status": status,
    "payment_status": paymentStatus,
    "currency": currency,
  };
}

 */

import 'dart:convert';
import 'package:intl/intl.dart';

OrderListResponse orderListResponseFromJson(String str) =>
    OrderListResponse.fromJson(json.decode(str));

String orderListResponseToJson(OrderListResponse data) =>
    json.encode(data.toJson());

class OrderListResponse {
  final String status;
  final String message;
  final List<OrderData> data;

  OrderListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory OrderListResponse.fromJson(Map<String, dynamic> json) =>
      OrderListResponse(
        status: json["status"],
        message: json["message"],
        data: List<OrderData>.from(
            json["data"].map((x) => OrderData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class OrderData {
  final String id;
  final String name;
  final int totalItemCount;
  final String? project;
  final String? totalAmount;
  final String? totalAmountPaid;
  final String status;
  final String paymentStatus;
  final String currency;
  final String? treeMessageType;
  final String? treeCustomMessage;
  final bool isQuery;
  final DateTime createdAt;

  OrderData({
    required this.id,
    required this.name,
    required this.totalItemCount,
    this.project,
    this.totalAmount,
    this.totalAmountPaid,
    required this.status,
    required this.paymentStatus,
    required this.currency,
    this.treeMessageType,
    this.treeCustomMessage,
    required this.isQuery,
    required this.createdAt,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
    id: json["id"],
    name: json["name"],
    totalItemCount: json["total_item_count"],
    project: json["project"] as String?,
    totalAmount: json["total_amount"]?.toString(),
    totalAmountPaid: json["total_amount_paid"]?.toString(),
    status: json["status"],
    paymentStatus: json["payment_status"],
    currency: json["currency"],
    treeMessageType: json["tree_message_type"] as String?,
    treeCustomMessage: json["tree_custom_message"] as String?,
    isQuery: json["is_query"] ?? false,
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "total_item_count": totalItemCount,
    "project": project,
    "total_amount": totalAmount,
    "total_amount_paid": totalAmountPaid,
    "status": status,
    "payment_status": paymentStatus,
    "currency": currency,
    "tree_message_type": treeMessageType,
    "tree_custom_message": treeCustomMessage,
    "is_query": isQuery,
    "created_at": createdAt.toIso8601String(),
  };

  /// 👉 Getter for nicely formatted date like "Aug 29, 2025"
  String get formattedCreatedAt {
    try {// assumes ISO 8601 string
      return DateFormat("MMM d, yyyy • h:mm a").format(createdAt);
    } catch (e) {
      return DateFormat("MMM d, y").format(createdAt); // fallback in case parsing fails
    }
    return DateFormat("MMM d, y").format(createdAt);
  }
}
