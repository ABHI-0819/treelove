import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/bloc/api_state.dart';
import '../../../../../common/repositories/payment_repository.dart';
import '../model/capture_payment_data.dart';
import '../model/razorpay_order_data.dart';
import '../model/verify_payment_data.dart';
import '../model/verify_payment_response.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentRepository repo;
  String? _paymentId;

  PaymentBloc(this.repo) : super(PaymentIdle()) {
    on<StartPayment>(_startPayment);
    on<RazorpaySuccess>(_confirmPayment);
  }

  /// Step 1 → Create Payment + Get Razorpay Order
  Future<void> _startPayment(
    StartPayment event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading("Initiating payment"));

    final createRes = await repo.createPayment(
      orderId: event.orderId,
      amountPaid: event.amount,
      currency: event.currency,
      paymentMode: event.paymentMode,
    );

    if (createRes is ApiFailure) {
      emit(PaymentFailure(createRes.response));
      return;
    }

    // ✅ Save payment ID
    _paymentId = createRes.response?.data.id;

    if (_paymentId == null) {
      emit(PaymentFailure("Payment ID not returned from server"));
      return;
    }

    // Step 2 → Get Razorpay Order Details
    final orderRes = await repo.getRazorpayOrder(paymentId: _paymentId!);
    if (orderRes is ApiFailure) {
      emit(PaymentFailure(orderRes.response));
      return;
    }

    final RazorpayOrderData? orderData = orderRes.response;
    if (orderData == null) {
      emit(PaymentFailure("Razorpay order data not available"));
      return;
    }

    emit(PaymentRazorpayReady(orderData, _paymentId!));
  }

  /// Step 3 → Verify & Capture Payment
  Future<void> _confirmPayment(
    RazorpaySuccess event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading("Confirming payment"));

    // Step 4 → Verify Payment
    final verifyRes = await repo.verifyPayment(
      razorpayOrderId: event.razorpayOrderId,
      razorpayPaymentId: event.razorpayPaymentId,
      razorpaySignature: event.razorpaySignature,
    );

    if (verifyRes is ApiFailure) {
      emit(PaymentFailure(verifyRes.response));
      return;
    }

    final PaymentVerificationResponse? verifyData = verifyRes.response;
    if (verifyData == null) {
      emit(PaymentFailure("Verification failed"));
      return;
    }

    // Step 5 → Capture Payment
    final captureRes = await repo.capturePayment(
      paymentId: _paymentId!,
      razorpayPaymentId: event.razorpayPaymentId,
    );

    if (captureRes is ApiFailure) {
      emit(PaymentFailure(captureRes.response));
      return;
    }

    final CapturePaymentData? captureData = captureRes.response;
    if (captureData == null) {
      emit(PaymentFailure("Capture failed"));
      return;
    }

    emit(PaymentSuccess(captureData: captureData));
  }
}
