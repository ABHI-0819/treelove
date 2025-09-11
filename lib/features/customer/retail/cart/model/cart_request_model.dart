import '../../../../../core/config/constants/enum/status_enum.dart';

class CartRequestDetail{
  bool isMaintenance;
  bool  isMonitoring;
  CartItemRequest cartItemRequest;

  CartRequestDetail({
    required this.isMaintenance,
    required this.isMonitoring,
    required this.cartItemRequest
  }
      );
}

class CartItemRequest {
  final String? order;
  final String user; // required
  final String? projectArea;
  final String serviceType; // required
  final bool isGeotagOnly;
  final String? parentService;
  final int quantity; // required
  final String? startDate; // yyyy-MM-dd
  final String? endDate; // yyyy-MM-dd
  final String treeSpecies; // required
  final int? frequencyPerMonth;
  final String? plantationType; // enum or blank
  final String? plantationTechnique; // enum or blank
  final String? monitoringMode; // enum or blank
  final String unitPrice; // required decimal
  final String status; // "pending", "assigned", "in_progress", "done"
  final String? remarks;

  CartItemRequest({
    this.order,
    required this.user,
    this.projectArea,
    required this.serviceType,
    this.isGeotagOnly = false,
    this.parentService,
    required this.quantity,
    this.startDate,
    this.endDate,
    required this.treeSpecies,
    this.frequencyPerMonth,
    this.plantationType,
    this.plantationTechnique,
    this.monitoringMode,
    required this.unitPrice,
    required this.status,
    this.remarks,
  });

  factory CartItemRequest.fromJson(Map<String, dynamic> json) {
    return CartItemRequest(
      order: json['order'],
      user: json['user'],
      projectArea: json['project_area'],
      serviceType: json['service_type'],
      isGeotagOnly: json['is_geotag_only'] ?? false,
      parentService: json['parent_service'],
      quantity: json['quantity'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      treeSpecies: json['tree_species'],
      frequencyPerMonth: json['frequency_per_month'],
      plantationType: json['plantation_type'],
      plantationTechnique: json['plantation_technique'],
      monitoringMode: json['monitoring_mode'],
      unitPrice: json['unit_price'],
      status: json['status'],
      remarks: json['remarks'],
    );
  }

  /*
  Map<String, dynamic> toJson() {
    return {
      'order': order,
      'user': user,
      'project_area': projectArea,
      'service_type': serviceType,
      'is_geotag_only': isGeotagOnly,
      'parent_service': parentService,
      'quantity': quantity,
      'start_date': startDate,
      'end_date': endDate,
      'tree_species': treeSpecies,
      'frequency_per_month': frequencyPerMonth,
      'plantation_type': plantationType,
      'plantation_technique': plantationTechnique,
      'monitoring_mode': monitoringMode,
      'unit_price': unitPrice,
      'status': status,
      'remarks': remarks,
    };
  }

   */
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'user': user,
      'service_type': serviceType,
      'is_geotag_only': isGeotagOnly,
      'quantity': quantity,
      'tree_species': treeSpecies,
      'unit_price': unitPrice,
      'status': status,
    };

    if (order != null) data['order'] = order;
    if (projectArea != null) data['project_area'] = projectArea;
    if (parentService != null) data['parent_service'] = parentService;
    if (startDate != null) data['start_date'] = startDate;
    if (endDate != null) data['end_date'] = endDate;
    if (frequencyPerMonth != null) data['frequency_per_month'] = frequencyPerMonth;
    if (plantationType != null) data['plantation_type'] = plantationType;
    if (plantationTechnique != null) data['plantation_technique'] = plantationTechnique;
    if (monitoringMode != null) data['monitoring_mode'] = monitoringMode;
    if (remarks != null) data['remarks'] = remarks;

    return data;
  }

}
