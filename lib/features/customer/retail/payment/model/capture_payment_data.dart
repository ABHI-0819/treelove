
import 'dart:convert';

CapturePaymentData capturePaymentDataFromJson(String str) =>
    CapturePaymentData.fromJson(json.decode(str));

String capturePaymentDataToJson(CapturePaymentData data) =>
    json.encode(data.toJson());

class CapturePaymentData {
  final String? paymentId;
  final String? razorpayPaymentId;
  final double? amount;

  CapturePaymentData({
    this.paymentId,
    this.razorpayPaymentId,
    this.amount,
  });

  factory CapturePaymentData.fromJson(Map<String, dynamic> json) {
    return CapturePaymentData(
      paymentId: json['payment_id']?.toString(),
      razorpayPaymentId: json['razorpay_payment_id']?.toString(),
      amount: json['amount'] != null
          ? double.tryParse(json['amount'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_id': paymentId,
      'razorpay_payment_id': razorpayPaymentId,
      'amount': amount,
    };
  }
}
