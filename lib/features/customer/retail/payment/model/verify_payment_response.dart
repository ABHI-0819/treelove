import 'dart:convert';

PaymentVerificationResponse paymentVerificationResponseFromJson(String str) =>
    PaymentVerificationResponse.fromJson(json.decode(str));

String paymentVerificationResponseToJson(PaymentVerificationResponse data) =>
    json.encode(data.toJson());

class PaymentVerificationResponse {
  final String message;
  final String paymentId;
  final String status;

  PaymentVerificationResponse({
    required this.message,
    required this.paymentId,
    required this.status,
  });

  factory PaymentVerificationResponse.fromJson(Map<String, dynamic> json) {
    return PaymentVerificationResponse(
      message: json['message'] as String,
      paymentId: json['payment_id'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'payment_id': paymentId,
      'status': status,
    };
  }
}
