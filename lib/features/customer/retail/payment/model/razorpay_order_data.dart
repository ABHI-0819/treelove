import 'dart:convert';

RazorpayOrderData razorpayOrderDataFromJson(String str) =>
    RazorpayOrderData.fromJson(json.decode(str));

String razorpayOrderDataToJson(RazorpayOrderData data) =>
    json.encode(data);

class RazorpayOrderData {
  final String? razorpayOrderId;
  final int? amount;
  final String? currency;
  final String? key;

  RazorpayOrderData({
    this.razorpayOrderId,
    this.amount,
    this.currency,
    this.key,
  });

  factory RazorpayOrderData.fromJson(Map<String, dynamic> json) {
    return RazorpayOrderData(
      razorpayOrderId: json['razorpay_order_id']?.toString(),
      amount: json['amount'] != null
          ? int.tryParse(json['amount'].toString())
          : null,
      currency: json['currency']?.toString(),
      key: json['key']?.toString(),
    );
  }
}
