class VerifyPaymentData {
  final String? razorpayOrderId;
  final String? razorpayPaymentId;
  final String? razorpaySignature;

  VerifyPaymentData({
    this.razorpayOrderId,
    this.razorpayPaymentId,
    this.razorpaySignature,
  });

  factory VerifyPaymentData.fromJson(Map<String, dynamic> json) {
    return VerifyPaymentData(
      razorpayOrderId: json['razorpay_order_id']?.toString(),
      razorpayPaymentId: json['razorpay_payment_id']?.toString(),
      razorpaySignature: json['razorpay_signature']?.toString(),
    );
  }
}
