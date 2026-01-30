import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:treelove/common/repositories/payment_repository.dart';
import 'package:treelove/core/network/api_connection.dart';

import '../../../../../core/config/themes/app_color.dart';
import '../bloc/payment_bloc.dart';
import '../bloc/payment_event.dart';
import '../bloc/payment_state.dart';
import '../model/razorpay_order_data.dart';
import 'payment_failed_screen.dart';
import 'payment_success_screen.dart';

class PaymentInitiatedScreen extends StatefulWidget {
  static const route = '/payment-initiated';

  final String amount;
  final String orderId;
  final String msgType;
  final String customMsg;

  const PaymentInitiatedScreen({
    super.key,
    required this.amount,
    required this.orderId,
    this.msgType = '',
    this.customMsg = '',
  });

  @override
  State<PaymentInitiatedScreen> createState() => _PaymentInitiatedScreenState();
}

class _PaymentInitiatedScreenState extends State<PaymentInitiatedScreen> {
  late Razorpay _razorpay;

  late PaymentBloc paymentBloc;

  @override
  void initState() {
    super.initState();

    paymentBloc = PaymentBloc(
      PaymentRepository(api: ApiConnection()),
    );

    _razorpay = Razorpay();

    _razorpay.on(
      Razorpay.EVENT_PAYMENT_SUCCESS,
      _onPaymentSuccess,
    );
    _razorpay.on(
      Razorpay.EVENT_PAYMENT_ERROR,
      _onPaymentError,
    );
    _razorpay.on(
      Razorpay.EVENT_EXTERNAL_WALLET,
      _onExternalWallet,
    );

    /// 🔥 Start payment immediately
    paymentBloc.add(
      StartPayment(
        orderId: widget.orderId,
        amount: widget.amount,
        currency: 'ae01a08c-ed97-4b28-af3d-a7338bfdd8ed',
        paymentMode: 'upi',
      ),
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  // ---------------- RAZORPAY CALLBACKS ----------------

  void _onPaymentSuccess(PaymentSuccessResponse response) {
    paymentBloc.add(
      RazorpaySuccess(
        razorpayOrderId: response.orderId!,
        razorpayPaymentId: response.paymentId!,
        razorpaySignature: response.signature!,
      ),
    );
  }

  void _onPaymentError(PaymentFailureResponse response) {
    Navigator.pushReplacementNamed(
      context,
      '/payment-failed',
      arguments: {'amount': widget.amount, 'errorMessage': response.message},
    );
  }

  void _onExternalWallet(ExternalWalletResponse response) {}

  void _openRazorpay(RazorpayOrderData data) {
    final options = {
      'key': data.key,
      'amount': data.amount,
      'currency': data.currency,
      'order_id': data.razorpayOrderId,
      'name': 'TreeLov',
      'description': 'Plant trees, make impact 🌱',
      'retry': {'enabled': true, 'max_count': 1},
    };

    _razorpay.open(options);
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => paymentBloc,
          ),
        ],
        child: BlocListener<PaymentBloc, PaymentState>(
          listener: (context, state) {
            if (state is PaymentRazorpayReady) {
              _openRazorpay(state.razorpayOrderData);
            }

            if (state is PaymentSuccess) {
              Navigator.pushReplacementNamed(
                context,
                PaymentSuccessScreen.route,
                arguments: {
                  'msgType': widget.msgType,
                  'customMsg': widget.customMsg,
                },
              );
            }

            if (state is PaymentFailure) {
              Navigator.pushReplacementNamed(
                context,
                PaymentFailedScreen.route,
                arguments: {
                  'amount': widget.amount,
                  'errorMessage': state.error,
                },
              );
            }
          },
          child: Scaffold(
            backgroundColor: AppColor.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColor.accent.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 4,
                          color: AppColor.accent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Processing Payment',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Please wait while we securely confirm your payment.\nDo not press back or close the app.',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColor.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColor.grey,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColor.border,
                          width: 1,
                        ),
                      ),
                      child: _buildDetailRow(
                        'Amount',
                        '₹ ${widget.amount}',
                      ),
                    ),
                    const Spacer(flex: 3),
                    const Text(
                      'This may take a few seconds',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColor.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: AppColor.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: AppColor.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
