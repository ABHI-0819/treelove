import 'dart:convert';
import 'package:intl/intl.dart'; // For formatting
import 'package:latlong2/latlong.dart'; // For location parsing

/// Top-level helper functions
B2BProjectDetailResponseModel b2bProjectDetailResponseModelFromJson(String str) =>
    B2BProjectDetailResponseModel.fromJson(json.decode(str));

String b2bProjectDetailResponseModelToJson(B2BProjectDetailResponseModel data) =>
    json.encode(data.toJson());


class B2BProjectDetailResponseModel {
  final String status;
  final String message;
  final B2BProjectDetailData data;

  B2BProjectDetailResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory B2BProjectDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return B2BProjectDetailResponseModel(
      status: json['status'],
      message: json['message'],
      data: B2BProjectDetailData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data.toJson(),
      };
}


class B2BProjectDetailData {
  final ProjectInfo projectInfo;
  final int totalProjectAreas;
  final int totalServiceTypes;
  final List<ServiceSummary> serviceSummary;
  final List<ProjectArea> projectAreas;

  B2BProjectDetailData({
    required this.projectInfo,
    required this.totalProjectAreas,
    required this.totalServiceTypes,
    required this.serviceSummary,
    required this.projectAreas,
  });

  factory B2BProjectDetailData.fromJson(Map<String, dynamic> json) {
    return B2BProjectDetailData(
      projectInfo: ProjectInfo.fromJson(json['project_info']),
      totalProjectAreas: json['total_project_areas'],
      totalServiceTypes: json['total_service_types'],
      serviceSummary: (json['service_summary'] as List)
          .map((e) => ServiceSummary.fromJson(e))
          .toList(),
      projectAreas: (json['project_areas'] as List)
          .map((e) => ProjectArea.fromJson(e))
          .toList(),
    );
  }

   Map<String, dynamic> toJson() => {
        'project_info': projectInfo.toJson(),
        'total_project_areas': totalProjectAreas,
        'total_service_types': totalServiceTypes,
        'service_summary': serviceSummary.map((e) => e.toJson()).toList(),
        'project_areas': projectAreas.map((e) => e.toJson()).toList(),
      };

  /// 🔹 Returns average completion percentage across all service types
  double getTotalCompletionPercentage() {
    if (serviceSummary.isEmpty) return 0.0;
    final total = serviceSummary
        .map((e) => e.totalRequired == 0
            ? 0.0
            : (e.totalDone / e.totalRequired) * 100)
        .reduce((a, b) => a + b);
    return total / serviceSummary.length;
  }
}

class ProjectInfo {
  final String id;
  final String name;
  final String type;
  final String category;
  final String description;
  final String image;
  final String? scopeOfWork;
  final String contractValue;
  final bool gstApplicable;
  final String gstPercentage;
  final String totalAmountPaid;
  final String? paymentTerms;
  final String? timeline;
  final String locationDescription;
  final String startDate;
  final String endDate;
  final String status;
  final String currency;

  ProjectInfo({
    required this.id,
    required this.name,
    required this.type,
    required this.category,
    required this.description,
    required this.image,
    this.scopeOfWork,
    required this.contractValue,
    required this.gstApplicable,
    required this.gstPercentage,
    required this.totalAmountPaid,
    this.paymentTerms,
    this.timeline,
    required this.locationDescription,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.currency,
  });

  factory ProjectInfo.fromJson(Map<String, dynamic> json) {
    return ProjectInfo(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      category: json['category'],
      description: json['description'],
      image: json['image'],
      scopeOfWork: json['scope_of_work'],
      contractValue: json['contract_value'],
      gstApplicable: json['gst_applicable'],
      gstPercentage: json['gst_percentage'],
      totalAmountPaid: json['total_amount_paid'],
      paymentTerms: json['payment_terms'],
      timeline: json['timeline'],
      locationDescription: json['location_description'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      status: json['status'],
      currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'category': category,
        'description': description,
        'image': image,
        'scope_of_work': scopeOfWork,
        'contract_value': contractValue,
        'gst_applicable': gstApplicable,
        'gst_percentage': gstPercentage,
        'total_amount_paid': totalAmountPaid,
        'payment_terms': paymentTerms,
        'timeline': timeline,
        'location_description': locationDescription,
        'start_date': startDate,
        'end_date': endDate,
        'status': status,
        'currency': currency,
      };

  /// 🔹 Format contract value as ₹12,30,000.00
  String getFormattedContractValue() {
    final amount = double.tryParse(contractValue) ?? 0.0;
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return formatter.format(amount);
  }

  /// 🔹 Format contract value as ₹12,30,000.00
  String getFormattedAmountPaid() {
    final amount = double.tryParse(totalAmountPaid) ?? 0.0;
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return formatter.format(amount);
  }

  /// 🔹 Format date as 5 Aug 2025
  String getFormattedStartDate() {
    return _formatDate(startDate);
  }

  String getFormattedEndDate() {
    return _formatDate(endDate);
  }

  String _formatDate(String rawDate) {
    try {
      final date = DateTime.parse(rawDate);
      return DateFormat('d MMM yyyy').format(date);
    } catch (_) {
      return rawDate;
    }
  }
}

class ServiceSummary {
  final String serviceType;
  final int totalRequired;
  final int totalDone;

  ServiceSummary({
    required this.serviceType,
    required this.totalRequired,
    required this.totalDone,
  });

  factory ServiceSummary.fromJson(Map<String, dynamic> json) {
    return ServiceSummary(
      serviceType: json['service_type'],
      totalRequired: json['total_required'],
      totalDone: json['total_done'],
    );
  }

  Map<String, dynamic> toJson() => {
        'service_type': serviceType,
        'total_required': totalRequired,
        'total_done': totalDone,
      };

  /// 🔹 Get percentage done as 65.0
  double getCompletionPercentage() {
    if (totalRequired == 0) return 0.0;
    return (totalDone / totalRequired) * 100;
  }

  String getCompletionText() {
    return "${totalDone.toString()} / ${totalRequired.toString()}";
  }
}

class ProjectArea {
  final String id;
  final String name;
  final int capacity;
  final String location;
  final List<ServiceSummary> serviceSummary;
  final dynamic fieldworkers;

  ProjectArea({
    required this.id,
    required this.name,
    required this.capacity,
    required this.location,
    required this.serviceSummary,
    this.fieldworkers,
  });

  factory ProjectArea.fromJson(Map<String, dynamic> json) {
    return ProjectArea(
      id: json['id'],
      name: json['name'],
      capacity: json['capacity'],
      location: json['location'],
      serviceSummary: (json['service_summary'] as List)
          .map((e) => ServiceSummary.fromJson(e))
          .toList(),
      fieldworkers: json['fieldworkers'],
    );
  }

   Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'capacity': capacity,
        'location': location,
        'service_summary': serviceSummary.map((e) => e.toJson()).toList(),
        'fieldworkers': fieldworkers,
      };

  /// 🔹 Parses coordinates from GeoJSON `location`
  List<LatLng> getAreaCoordinates() {
    try {
      final Map<String, dynamic> locationJson = jsonDecode(location);
      final List coordinates = locationJson['coordinates'][0];
      return coordinates
          .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
