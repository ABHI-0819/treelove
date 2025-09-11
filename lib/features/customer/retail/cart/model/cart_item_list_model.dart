// To parse this JSON data, do
//
//     final cartItemListResponse = cartItemListResponseFromJson(jsonString);

import 'dart:convert';
/*
CartItemListResponse cartItemListResponseFromJson(String str) => CartItemListResponse.fromJson(json.decode(str));

String cartItemListResponseToJson(CartItemListResponse data) => json.encode(data.toJson());

class CartItemListResponse {
  final String status;
  final String message;
  final List<CartItemData> data;

  CartItemListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CartItemListResponse.fromJson(Map<String, dynamic> json) => CartItemListResponse(
    status: json["status"],
    message: json["message"],
    data: List<CartItemData>.from(json["data"].map((x) => CartItemData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class CartItemData {
  final String id;
  final bool isGeotagOnly;
  final int quantity;
  final String treeName;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? frequencyPerMonth;
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
  final String? order;
  final String user;
  final String? projectArea;
  final String serviceType;
  final String? parentService;
  final String treeSpecies;
  final String createdBy;
  final String updatedBy;

  CartItemData({
    required this.id,
    required this.isGeotagOnly,
    required this.quantity,
    required this.treeName,
    required this.startDate,
    required this.endDate,
    required this.frequencyPerMonth,
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
    required this.parentService,
    required this.treeSpecies,
    required this.createdBy,
    required this.updatedBy,
  });

  factory CartItemData.fromJson(Map<String, dynamic> json) => CartItemData(
    id: json["id"],
    isGeotagOnly: json["is_geotag_only"],
    quantity: json["quantity"],
    treeName: json["tree_name"],
    startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
    endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
    frequencyPerMonth: json["frequency_per_month"],
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
    "is_geotag_only": isGeotagOnly,
    "quantity": quantity,
    "tree_name":treeName,
    "start_date": startDate?.toIso8601String(),
    "end_date": endDate?.toIso8601String(),
    "frequency_per_month": frequencyPerMonth,
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
}

 */

// To parse this JSON data, do
//
//     final cartItemListResponse = cartItemListResponseFromJson(jsonString);

import 'dart:convert';

CartItemListResponse cartItemListResponseFromJson(String str) => CartItemListResponse.fromJson(json.decode(str));

String cartItemListResponseToJson(CartItemListResponse data) => json.encode(data.toJson());

class CartItemListResponse {
  final String status;
  final String message;
  final List<CartItem> data;

  CartItemListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CartItemListResponse.fromJson(Map<String, dynamic> json) => CartItemListResponse(
    status: json["status"],
    message: json["message"],
    data: List<CartItem>.from(json["data"].map((x) => CartItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };

  double getTotalCartPrice() {
    double total = 0;

    for (var item in data) {
      total += item.totalPrice;
      for (var child in item.children) {
        total += child.totalPrice;
      }
    }

    return total.truncateToDouble();
  }


}

class CartItem {
  final String id;
  final String serviceType;
  final String serviceTypeName;
  final String treeName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final List<ChildItem> children;

  CartItem({
    required this.id,
    required this.serviceType,
    required this.serviceTypeName,
    required this.treeName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.children,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json["id"],
    serviceType: json["service_type"],
    serviceTypeName: json["service_type_name"],
    treeName: json["tree_name"],
    quantity: json["quantity"],
    unitPrice: json["unit_price"]?.toDouble(),
    totalPrice: json["total_price"]?.toDouble(),
    children: List<ChildItem>.from(json["children"].map((x) => ChildItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "service_type": serviceType,
    "service_type_name": serviceTypeName,
    "tree_name": treeName,
    "quantity": quantity,
    "unit_price": unitPrice,
    "total_price": totalPrice,
    "children": List<dynamic>.from(children.map((x) => x.toJson())),
  };
}

class ChildItem {
  final String id;
  final String serviceType;
  final String serviceTypeName;
  final String treeName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  ChildItem({
    required this.id,
    required this.serviceType,
    required this.serviceTypeName,
    required this.treeName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory ChildItem.fromJson(Map<String, dynamic> json) => ChildItem(
    id: json["id"],
    serviceType: json["service_type"],
    serviceTypeName: json["service_type_name"],
    treeName: json["tree_name"],
    quantity: json["quantity"],
    unitPrice: json["unit_price"],
    totalPrice: json["total_price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "service_type": serviceType,
    "service_type_name": serviceTypeName,
    "tree_name": treeName,
    "quantity": quantity,
    "unit_price": unitPrice,
    "total_price": totalPrice,
  };
}