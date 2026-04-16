class TaskAllocationRequestModel {
  final String fieldworker; // UUID
  final String services;    // UUID
  final int quantity;
  final String startDate;   // YYYY-MM-DD
  final String endDate;     // YYYY-MM-DD

  TaskAllocationRequestModel({
    required this.fieldworker,
    required this.services,
    required this.quantity,
    required this.startDate,
    required this.endDate,
  });

  /// ✅ Convert to JSON for API body
  Map<String, dynamic> toJson() {
    return {
      "fieldworker": fieldworker,
      "services": services,
      "quantity": quantity,
      "start_date": startDate,
      "end_date": endDate,
    };
  }

  /// ✅ Create from JSON (if needed)
  factory TaskAllocationRequestModel.fromJson(Map<String, dynamic> json) {
    return TaskAllocationRequestModel(
      fieldworker: json["fieldworker"],
      services: json["services"],
      quantity: json["quantity"],
      startDate: json["start_date"],
      endDate: json["end_date"],
    );
  }
}
