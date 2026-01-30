import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/bloc/api_event.dart';
import '../../../../../common/bloc/api_state.dart';
import '../../../../../common/models/response.mode.dart';
import '../../../../../common/repositories/order_repository.dart';
import '../../../../../core/config/themes/app_color.dart';
import '../../../../../core/network/api_connection.dart';
import '../../../../../core/storage/preference_keys.dart';
import '../../../../../core/storage/secure_storage.dart';
import '../../order/bloc/order_bloc.dart';
import '../../order/congratulations_screen.dart';
import '../../order/models/order_place_request.dart';
import '../../order/models/order_place_response.dart';

class PaymentSuccessScreen extends StatefulWidget {
  static const route = '/payment-success';

  final String msgType;
  final String customMsg;

  const PaymentSuccessScreen({
    super.key,
    this.msgType = '',
    this.customMsg = '',
  });

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  late OrderPlaceBloc orderPlaceBloc;

    final pref = SecurePreference();

  @override
  void initState() {
    super.initState();

    orderPlaceBloc = OrderPlaceBloc(
      OrderRepository(api: ApiConnection()),
    );

    /// 🔥 Place order AFTER payment success
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _placeOrder();
    });
  }

  Future<void> _placeOrder() async {
  final userId = await pref.getString(Keys.id);

  orderPlaceBloc.add(
    ApiAdd(
      OrderPlaceRequest(
        userId: userId,
        treeMessageType: widget.msgType,
        treeCustomMessage: widget.customMsg,
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocProvider(
        create: (_) => orderPlaceBloc,
        child: BlocListener<OrderPlaceBloc,
            ApiState<OrderPlacedResponse, ResponseModel>>(
          listener: (context, state) {
            if (state is ApiSuccess<OrderPlacedResponse, ResponseModel>) {
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  CongratulationsScreen.route,
                  (_) => false,
                  arguments: {
                    'shareLink':
                        state.data.data.publicTreeContributionUrl,
                  },
                );
              });
            }

            if (state is ApiFailure<OrderPlacedResponse, ResponseModel>) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.error.message ?? 'Order placement failed',
                  ),
                ),
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

                    /// ✅ Success Icon
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColor.accent.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check_circle_rounded,
                          size: 70,
                          color: AppColor.accent,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    const Text(
                      'Payment Successful',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Thank you for your contribution 🌱\nWe’re placing your order now.',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColor.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32),

                    /// 🔄 Order processing indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColor.accent,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Confirming your order…',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColor.textSecondary,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(flex: 3),

                    /// 🌿 Reassurance footer
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColor.grey,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColor.border),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.eco_rounded,
                            color: AppColor.accent,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Your trees will be planted and monitored with care.',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColor.textSecondary,
                              ),
                            ),
                          ),
                        ],
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
}
