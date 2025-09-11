// To parse this JSON data, do
//
//     final orderPlacedResponse = orderPlacedResponseFromJson(jsonString);
/*
import 'dart:convert';

OrderPlacedResponse orderPlacedResponseFromJson(String str) =>
    OrderPlacedResponse.fromJson(json.decode(str));

String orderPlacedResponseToJson(OrderPlacedResponse data) =>
    json.encode(data.toJson());

class OrderPlacedResponse {
  final String? status;
  final String? message;

  OrderPlacedResponse({
    this.status,
    this.message,
  });

  factory OrderPlacedResponse.fromJson(Map<String, dynamic> json) =>
      OrderPlacedResponse(
        status: json["status"] as String?,
        message: json["message"] as String?,
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}

 */

import 'dart:convert';
import 'package:intl/intl.dart';

OrderPlacedResponse orderPlacedResponseFromJson(String str) =>
    OrderPlacedResponse.fromJson(json.decode(str));

String orderPlacedResponseToJson(OrderPlacedResponse data) =>
    json.encode(data.toJson());

class OrderPlacedResponse {
  final String status;
  final String message;
  final OrderPlacedData data;

  OrderPlacedResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory OrderPlacedResponse.fromJson(Map<String, dynamic> json) =>
      OrderPlacedResponse(
        status: json["status"],
        message: json["message"],
        data: OrderPlacedData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class OrderPlacedData {
  final String id;
  final List<OrderItem> items;
  final String publicTreeContributionUrl;
  final String? totalAmount;
  final String totalAmountPaid;
  final bool gstApplicable;
  final String gstPercentage;
  final String status;
  final String paymentStatus;
  final String? treeMessageType;
  final String? treeCustomMessage;
  final bool isQuery;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String user;
  final String project;
  final String currency;
  final String createdBy;
  final String updatedBy;

  OrderPlacedData({
    required this.id,
    required this.items,
    required this.publicTreeContributionUrl,
    this.totalAmount,
    required this.totalAmountPaid,
    required this.gstApplicable,
    required this.gstPercentage,
    required this.status,
    required this.paymentStatus,
    this.treeMessageType,
    this.treeCustomMessage,
    required this.isQuery,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.project,
    required this.currency,
    required this.createdBy,
    required this.updatedBy,
  });

  factory OrderPlacedData.fromJson(Map<String, dynamic> json) => OrderPlacedData(
    id: json["id"],
    items: List<OrderItem>.from(
        json["items"].map((x) => OrderItem.fromJson(x))),
    publicTreeContributionUrl: json["public_tree_contribution_url"],
    totalAmount: json["total_amount"]?.toString(),
    totalAmountPaid: json["total_amount_paid"],
    gstApplicable: json["gst_applicable"],
    gstPercentage: json["gst_percentage"],
    status: json["status"],
    paymentStatus: json["payment_status"],
    treeMessageType: json["tree_message_type"],
    treeCustomMessage: json["tree_custom_message"],
    isQuery: json["is_query"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    user: json["user"],
    project: json["project"],
    currency: json["currency"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "public_tree_contribution_url": publicTreeContributionUrl,
    "total_amount": totalAmount,
    "total_amount_paid": totalAmountPaid,
    "gst_applicable": gstApplicable,
    "gst_percentage": gstPercentage,
    "status": status,
    "payment_status": paymentStatus,
    "tree_message_type": treeMessageType,
    "tree_custom_message": treeCustomMessage,
    "is_query": isQuery,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "user": user,
    "project": project,
    "currency": currency,
    "created_by": createdBy,
    "updated_by": updatedBy,
  };

  /// ✅ Human-readable formatted date
  String get formattedCreatedAt =>
      DateFormat("MMM d, yyyy • h:mm a").format(createdAt);

  String get formattedUpdatedAt =>
      DateFormat("MMM d, yyyy • h:mm a").format(updatedAt);
}

class OrderItem {
  final String id;
  final String serviceTypeName;
  final String treeName;
  final bool isGeotagOnly;
  final int quantity;
  final String plantationType;
  final String plantationTechnique;
  final String monitoringMode;
  final String unitPrice;
  final String totalPrice;
  final String status;
  final String remarks;
  final String cartSessionId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String order;
  final String user;
  final String projectArea;
  final String serviceType;
  final String? parentService;
  final String treeSpecies;
  final String createdBy;
  final String updatedBy;

  OrderItem({
    required this.id,
    required this.serviceTypeName,
    required this.treeName,
    required this.isGeotagOnly,
    required this.quantity,
    required this.plantationType,
    required this.plantationTechnique,
    required this.monitoringMode,
    required this.unitPrice,
    required this.totalPrice,
    required this.status,
    required this.remarks,
    required this.cartSessionId,
    required this.createdAt,
    required this.updatedAt,
    required this.order,
    required this.user,
    required this.projectArea,
    required this.serviceType,
    this.parentService,
    required this.treeSpecies,
    required this.createdBy,
    required this.updatedBy,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    id: json["id"],
    serviceTypeName: json["service_type_name"],
    treeName: json["tree_name"],
    isGeotagOnly: json["is_geotag_only"],
    quantity: json["quantity"],
    plantationType: json["plantation_type"],
    plantationTechnique: json["plantation_technique"],
    monitoringMode: json["monitoring_mode"],
    unitPrice: json["unit_price"],
    totalPrice: json["total_price"],
    status: json["status"],
    remarks: json["remarks"],
    cartSessionId: json["cart_session_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    order: json["order"],
    user: json["user"],
    projectArea: json["project_area"],
    serviceType: json["service_type"],
    parentService: json["parent_service"],
    treeSpecies: json["tree_species"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "service_type_name": serviceTypeName,
    "tree_name": treeName,
    "is_geotag_only": isGeotagOnly,
    "quantity": quantity,
    "plantation_type": plantationType,
    "plantation_technique": plantationTechnique,
    "monitoring_mode": monitoringMode,
    "unit_price": unitPrice,
    "total_price": totalPrice,
    "status": status,
    "remarks": remarks,
    "cart_session_id": cartSessionId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "order": order,
    "user": user,
    "project_area": projectArea,
    "service_type": serviceType,
    "parent_service": parentService,
    "tree_species": treeSpecies,
    "created_by": createdBy,
    "updated_by": updatedBy,
  };

  /// ✅ User-friendly timestamps
  String get formattedCreatedAt =>
      DateFormat("MMM d, yyyy • h:mm a").format(createdAt);

  String get formattedUpdatedAt =>
      DateFormat("MMM d, yyyy • h:mm a").format(updatedAt);
}
