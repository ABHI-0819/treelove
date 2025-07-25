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


