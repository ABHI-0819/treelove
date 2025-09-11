/*
{
  "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "created_at": "2025-07-11T07:10:32.956Z",
  "updated_at": "2025-07-11T07:10:32.956Z",
  "quantity": 2147483647,
  "start_date": "2025-07-11",
  "end_date": "2025-07-11",
  "frequency_per_month": 2147483647,
  "plantation_type": "seed",
  "plantation_technique": "miyawaki",
  "monitoring_mode": "manual",
  "unit_price": "-5079203189",
  "total_price": "-3435997.",
  "status": "pending",
  "remarks": "string",
  "order": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "service_type": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "tree_species": "3fa85f64-5717-4562-b3fc-2c963f66afa6"
}
*/

// add_to_cart_response_model.dart
/*
import 'dart:convert';

AddToCartResponseModel addToCartResponseModelFromJson(String str) =>
    AddToCartResponseModel.fromJson(json.decode(str));

String addToCartResponseModelToJson(AddToCartResponseModel data) =>
    json.encode(data.toJson());

class AddToCartResponseModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int quantity;
  final String startDate;
  final String endDate;
  final int frequencyPerMonth;
  final String plantationType;
  final String plantationTechnique;
  final String monitoringMode;
  final String unitPrice;
  final String totalPrice;
  final String status;
  final String remarks;
  final String order;
  final String serviceType;
  final String treeSpecies;

  AddToCartResponseModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.quantity,
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
    required this.order,
    required this.serviceType,
    required this.treeSpecies,
  });

  factory AddToCartResponseModel.fromJson(Map<String, dynamic> json) {
    return AddToCartResponseModel(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      quantity: json['quantity'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      frequencyPerMonth: json['frequency_per_month'],
      plantationType: json['plantation_type'],
      plantationTechnique: json['plantation_technique'],
      monitoringMode: json['monitoring_mode'],
      unitPrice: json['unit_price'],
      totalPrice: json['total_price'],
      status: json['status'],
      remarks: json['remarks'],
      order: json['order'],
      serviceType: json['service_type'],
      treeSpecies: json['tree_species'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'quantity': quantity,
      'start_date': startDate,
      'end_date': endDate,
      'frequency_per_month': frequencyPerMonth,
      'plantation_type': plantationType,
      'plantation_technique': plantationTechnique,
      'monitoring_mode': monitoringMode,
      'unit_price': unitPrice,
      'total_price': totalPrice,
      'status': status,
      'remarks': remarks,
      'order': order,
      'service_type': serviceType,
      'tree_species': treeSpecies,
    };
  }
}

 */
import 'dart:convert';

AddToCartResponseModel addToCartResponseModelFromJson(String str) =>
    AddToCartResponseModel.fromJson(json.decode(str));

String addToCartResponseModelToJson(AddToCartResponseModel data) =>
    json.encode(data.toJson());

class AddToCartResponseModel {
  final String? status;
  final String? message;
  final CartData? data;

  AddToCartResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory AddToCartResponseModel.fromJson(Map<String, dynamic> json) =>
      AddToCartResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : CartData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class CartData {
  final String? id;
  final bool? isGeotagOnly;
  final int? quantity;
  final String? startDate;
  final String? endDate;
  final dynamic frequencyPerMonth;
  final String? plantationType;
  final String? plantationTechnique;
  final String? monitoringMode;
  final String? unitPrice;
  final String? totalPrice;
  final String? status;
  final String? remarks;
  final String? cartSessionId;
  final String? createdAt;
  final String? updatedAt;
  final dynamic order;
  final String? user;
  final String? projectArea;
  final String? serviceType;
  final dynamic parentService;
  final String? treeSpecies;
  final String? createdBy;
  final String? updatedBy;

  CartData({
    this.id,
    this.isGeotagOnly,
    this.quantity,
    this.startDate,
    this.endDate,
    this.frequencyPerMonth,
    this.plantationType,
    this.plantationTechnique,
    this.monitoringMode,
    this.unitPrice,
    this.totalPrice,
    this.status,
    this.remarks,
    this.cartSessionId,
    this.createdAt,
    this.updatedAt,
    this.order,
    this.user,
    this.projectArea,
    this.serviceType,
    this.parentService,
    this.treeSpecies,
    this.createdBy,
    this.updatedBy,
  });

  factory CartData.fromJson(Map<String, dynamic> json) => CartData(
    id: json["id"],
    isGeotagOnly: json["is_geotag_only"],
    quantity: json["quantity"],
    startDate: json["start_date"],
    endDate: json["end_date"],
    frequencyPerMonth: json["frequency_per_month"],
    plantationType: json["plantation_type"],
    plantationTechnique: json["plantation_technique"],
    monitoringMode: json["monitoring_mode"],
    unitPrice: json["unit_price"],
    totalPrice: json["total_price"],
    status: json["status"],
    remarks: json["remarks"],
    cartSessionId: json["cart_session_id"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
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
    "start_date": startDate,
    "end_date": endDate,
    "frequency_per_month": frequencyPerMonth,
    "plantation_type": plantationType,
    "plantation_technique": plantationTechnique,
    "monitoring_mode": monitoringMode,
    "unit_price": unitPrice,
    "total_price": totalPrice,
    "status": status,
    "remarks": remarks,
    "cart_session_id": cartSessionId,
    "created_at": createdAt,
    "updated_at": updatedAt,
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



