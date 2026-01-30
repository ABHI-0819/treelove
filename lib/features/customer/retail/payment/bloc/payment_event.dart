abstract class PaymentEvent {}

class StartPayment extends PaymentEvent {
  final String orderId;
  final String amount;
  final String currency;
  final String paymentMode;

  StartPayment({
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.paymentMode,
  });
}

class RazorpaySuccess extends PaymentEvent {
  final String razorpayOrderId;
  final String razorpayPaymentId;
  final String razorpaySignature;

  RazorpaySuccess({
    required this.razorpayOrderId,
    required this.razorpayPaymentId,
    required this.razorpaySignature,
  });
}
