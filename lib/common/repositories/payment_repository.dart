import 'dart:convert';

import '../../core/network/api_connection.dart';
import '../../core/network/base_network.dart';
import '../../core/network/base_network_status.dart';
import '../../features/customer/retail/payment/model/api_success_response.dart';
import '../../features/customer/retail/payment/model/capture_payment_data.dart';
import '../../features/customer/retail/payment/model/create_payment_data.dart';
import '../../features/customer/retail/payment/model/razorpay_order_data.dart';
import '../../features/customer/retail/payment/model/verify_payment_data.dart';
import '../../features/customer/retail/payment/model/verify_payment_response.dart';

class PaymentRepository {
  final ApiConnection? api;
  PaymentRepository({this.api});

  /// 1️⃣ Create Payment
  Future<ApiResult> createPayment({
    required String orderId,
    required String amountPaid,
    required String currency,
    required String paymentMode,
  }) async {
    final Map<String, dynamic> fields = {
      // "order": null,
      "amount_paid": amountPaid,
      "currency": currency,
      "payment_mode": paymentMode,
    };

    return await api!
        .apiConnectionMultipart<ApiSuccessResponse<CreatePaymentData>>(
      BaseNetwork.paymentURL,
      BaseNetwork.getMultipartHeaders(),
      'post',
      (json) => ApiSuccessResponse.fromJson(
        jsonDecode(json),
        (data) => CreatePaymentData.fromJson(data),
      ),
      fields: fields,
    );
  }

  /// 2️⃣ Get Razorpay Order
  Future<ApiResult> getRazorpayOrder({required String paymentId}) async {
    final url = "${BaseNetwork.paymentURL}$paymentId/razorpay-order/";
    return await api!.getApiConnection<RazorpayOrderData>(
      url,
      BaseNetwork.getHeaderForLogin(),
      razorpayOrderDataFromJson
    );
  }

  /// 3️⃣ Verify Payment
  Future<ApiResult> verifyPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    final Map<String, dynamic> fields = {
      "razorpay_order_id": razorpayOrderId,
      "razorpay_payment_id": razorpayPaymentId,
      "razorpay_signature": razorpaySignature,
    };

    return await api!
        .apiConnectionMultipart<PaymentVerificationResponse>(
      BaseNetwork.verifyPaymentUrl,
      BaseNetwork.getMultipartHeaders(),
      'post',
      paymentVerificationResponseFromJson,
      fields: fields,
    );
  }

  /// 4️⃣ Capture Payment
  Future<ApiResult> capturePayment({
    required String paymentId,
    required String razorpayPaymentId,
  }) async {
    final Map<String, dynamic> fields = {
      "payment_id": paymentId,
      "razorpay_payment_id": razorpayPaymentId,
    };

    return await api!
        .apiConnectionMultipart<CapturePaymentData>(
      BaseNetwork.capturePaymentUrl,
      BaseNetwork.getMultipartHeaders(),
      'post',
      capturePaymentDataFromJson,
      fields: fields,
    );
  }
}
