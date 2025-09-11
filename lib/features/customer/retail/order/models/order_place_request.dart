class OrderPlaceRequest {
  String userId;
  String currencyId;

  OrderPlaceRequest({
    required this.userId,
     this.currencyId = "ae01a08c-ed97-4b28-af3d-a7338bfdd8ed",
  });

  /// Convert Dart object → JSON
  Map<String, dynamic> toJson() {
    return {
      "user": userId,
      "currency": currencyId,
    };
  }

  /// Convert JSON → Dart object
  factory OrderPlaceRequest.fromJson(Map<String, dynamic> json) {
    return OrderPlaceRequest(
      userId: json["user"] ?? "",
      currencyId: json["currency"] ?? "",
    );
  }
}
