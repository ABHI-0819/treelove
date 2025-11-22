class OrderPlaceRequest {
  String userId;
  String currencyId;
  String treeMessageType;
  String treeCustomMessage;
  OrderPlaceRequest({
    required this.userId,
    this.currencyId = "ae01a08c-ed97-4b28-af3d-a7338bfdd8ed",
    this.treeMessageType = "default",
    this.treeCustomMessage = "",
  });

  /// Convert Dart object → JSON
  Map<String, dynamic> toJson() {
    return {
      "user": userId,
      "currency": currencyId,
      "tree_message_type": treeMessageType,
      "tree_custom_message": treeCustomMessage,
    };
  }

  /// Convert JSON → Dart object
  factory OrderPlaceRequest.fromJson(Map<String, dynamic> json) {
    return OrderPlaceRequest(
      userId: json["user"] ?? "",
      currencyId: json["currency"] ?? "",
      treeMessageType: json["tree_message_type"] ?? "",
      treeCustomMessage: json["tree_custom_message"] ?? "",
    );
  }
}
