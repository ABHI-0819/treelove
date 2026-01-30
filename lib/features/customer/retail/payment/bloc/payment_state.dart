

import '../model/capture_payment_data.dart';
import '../model/razorpay_order_data.dart';

abstract class PaymentState {}

/// Initial state
class PaymentIdle extends PaymentState {}

/// Loading state with optional message
class PaymentLoading extends PaymentState {
  final String message;
  PaymentLoading(this.message);
}

/// Ready to open Razorpay checkout
class PaymentRazorpayReady extends PaymentState {
  final RazorpayOrderData razorpayOrderData;
  final String paymentId;
  PaymentRazorpayReady(this.razorpayOrderData, this.paymentId);
}

/// Payment completed successfully
class PaymentSuccess extends PaymentState {
  final CapturePaymentData captureData;

  PaymentSuccess({required this.captureData});
}

/// Payment failed
class PaymentFailure extends PaymentState {
  final String error;
  PaymentFailure(this.error);
}
