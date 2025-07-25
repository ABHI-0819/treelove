class TaskAllocationRequestModel {
  final String fieldworker; // UUID
  final String services;    // UUID
  final int quantity;

  TaskAllocationRequestModel({
    required this.fieldworker,
    required this.services,
    required this.quantity,
  });

  /// ✅ Convert to JSON for API body
  Map<String, dynamic> toJson() {
    return {
      "fieldworker": fieldworker,
      "services": services,
      "quantity": quantity,
    };
  }

  /// ✅ Create from JSON (if needed)
  factory TaskAllocationRequestModel.fromJson(Map<String, dynamic> json) {
    return TaskAllocationRequestModel(
      fieldworker: json["fieldworker"],
      services: json["services"],
      quantity: json["quantity"],
    );
  }
}
