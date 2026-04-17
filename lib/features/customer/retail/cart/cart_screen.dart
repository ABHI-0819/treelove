import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:treelove/common/bloc/api_event.dart';
import 'package:treelove/common/repositories/cart_repository.dart';
import 'package:treelove/common/repositories/order_repository.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/core/widgets/common_notification.dart';
import 'package:treelove/features/customer/retail/order/bloc/order_bloc.dart';
import 'package:treelove/features/customer/retail/order/congratulations_screen.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../core/config/constants/enum/notification_enum.dart';
import '../../../../core/config/themes/app_color.dart';
import '../../../../core/network/api_connection.dart';
import '../../../../core/storage/preference_keys.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../authentication/screens/sign_in_screen.dart';
import '../home/screens/main_screen.dart';
import '../order/models/order_place_request.dart';
import '../order/models/order_place_response.dart';
import '../payment/screen/payment_initiated_screen.dart';
import 'bloc/cart_item_bloc.dart';
import 'model/cart_item_list_model.dart';
import 'model/cart_item_update_request_model.dart';

import 'package:shimmer/shimmer.dart';

// ---- YOUR IMPORTS ----
// import '...';

// Removed local CartItem class to use the one from model/cart_item_list_model.dart

class CartScreen extends StatefulWidget {
  static const route = "/CartScreen";
  final String msgType;
  final String customMsg;

  const CartScreen({
    super.key,
    this.msgType = '',
    this.customMsg = '',
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Razorpay razorpay;

  final pref = SecurePreference();

  late CartItemListBloc cartItemListBloc;
  late CartRemoveBloc cartRemoveBloc;
  late CartUpdateBloc cartUpdateBloc;
  late OrderPlaceBloc orderPlaceBloc;

  bool _isProcessingOrder = false;
  String? _loadingCartId; // 👈 per-item loader
  CartItemListResponse?
      _cachedCartResponse; // 👈 cached data to prevent full-screen reloads

  @override
  void initState() {
    super.initState();

    final cartRepo = CartRepository(api: ApiConnection());

    cartItemListBloc = CartItemListBloc(cartRepo);
    cartRemoveBloc = CartRemoveBloc(cartRepo);
    cartUpdateBloc = CartUpdateBloc(cartRepo);
    orderPlaceBloc = OrderPlaceBloc(OrderRepository(api: ApiConnection()));

    cartItemListBloc.add(ApiListFetch());

    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
  }

  @override
  void dispose() {
    razorpay.clear();
    super.dispose();
  }

  // ---------------- PAYMENT ----------------

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    showNotification(context,
        message: response.message ?? "Payment failed", type: Not.failed);
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    if (_isProcessingOrder) return;
    _isProcessingOrder = true;

    EasyLoading.show(status: 'Processing your order...');

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

  PreferredSizeWidget buildCartAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(72),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFEFDF7),
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(28),
          ),
        ),
        child: SafeArea(
          bottom: false,
          left: true,
          right: true,
          child: Row(
            children: [
              /// ← Back (optional)
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: Colors.black87,
                onPressed: () {
                  AppRoute.pushReplacement(context, RetailMainScreen.route,
                      arguments: {});
                },
              ),

              /// Title
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Your Cart',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Planting a greener future 🌱',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              /// ✕ Close
              Container(
                height: 38,
                width: 38,
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.04),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.close_rounded),
                  color: Colors.black87,
                  onPressed: () {
                    AppRoute.pushReplacement(context, RetailMainScreen.route,
                        arguments: {});
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showNotification(context,
        message: 'Processing with ${response.walletName}', type: Not.success);
  }

  // ---------------- CART ITEM ----------------

  Widget _buildCartItem(CartItem item) {
    final isLoading = _loadingCartId == item.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8F2EF), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00473E).withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Opacity(
            opacity: isLoading ? 0.4 : 1.0,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Item Icon/Image placeholder
                      Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F2EF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.park_rounded,
                            color: Color(0xFF00473E), size: 26),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.treeName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Unit Price: ₹ ${item.unitPrice.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Delete Button
                      IconButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                setState(() => _loadingCartId = item.id);
                                cartRemoveBloc.add(ApiDelete(item.id));
                              },
                        icon: const Icon(Icons.delete_outline_rounded,
                            color: Colors.redAccent, size: 22),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Quantity Controls and Prices
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F9F8),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: const Color(0xFFE8F2EF)),
                        ),
                        child: Row(
                          children: [
                            _qtyBtn(
                                Icons.remove_rounded,
                                isLoading || item.quantity <= 1
                                    ? null
                                    : () {
                                        setState(
                                            () => _loadingCartId = item.id);
                                        cartUpdateBloc.add(ApiUpdate(
                                            CartItemUpdateRequestModel(
                                                cartId: item.id,
                                                quanity: item.quantity - 1)));
                                      }),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                            _qtyBtn(
                                Icons.add_rounded,
                                isLoading
                                    ? null
                                    : () {
                                        setState(
                                            () => _loadingCartId = item.id);
                                        cartUpdateBloc.add(ApiUpdate(
                                            CartItemUpdateRequestModel(
                                                cartId: item.id,
                                                quanity: item.quantity + 1)));
                                      }),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text("Sub-total",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey)),
                          Text(
                            '₹ ${item.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF00473E),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Child items (Maintenance, Monitoring, etc.)
                  if (item.children.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(height: 1, color: Color(0xFFE8F2EF)),
                    ),
                    const Text(
                      "Includes Services:",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Column(
                      children: item.children
                          .map((child) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                            Icons.check_circle_outline_rounded,
                                            size: 13,
                                            color: Color(0xFF00473E)),
                                        const SizedBox(width: 6),
                                        Text(
                                          child.serviceTypeName,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "₹ ${child.totalPrice.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5, color: Color(0xFF00473E)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback? onPressed) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon,
              size: 18,
              color: onPressed == null ? Colors.grey : const Color(0xFF00473E)),
        ),
      ),
    );
  }

  // ---------------- BILL SUMMARY ----------------

  Widget _buildBillSummary(CartItemListResponse cart) {
    final itemTotal = cart.getTotalCartPrice();
    final gst = itemTotal * 0;
    const locationCharge = 0.0;
    const platformFee = 0.0;
    final grandTotal = itemTotal + gst + locationCharge + platformFee;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8F2EF), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long_rounded,
                  color: Color(0xFF00473E), size: 18),
              const SizedBox(width: 8),
              const Text(
                'Bill Summary',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _billRow('Item Total', itemTotal),
          _billRow('GST (18%)', gst,
              isDiscount: true), // For showing 0 as neutral/discount
          _billRow('Location Charges', locationCharge),
          _billRow('Platform Fee', platformFee),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, color: Color(0xFFE8F2EF)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'To Pay',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A1A1A)),
              ),
              Text(
                '₹ ${grandTotal.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF00473E)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F9F8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: const [
                Icon(Icons.lock_outline, size: 14, color: Color(0xFF00473E)),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Secure payment & inclusive of all taxes',
                    style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF00473E),
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _billRow(String label, double amount, {bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.w500),
          ),
          Text(
            '₹ ${amount.toStringAsFixed(2)}',
            style: TextStyle(
                fontSize: 14,
                color:
                    isDiscount && amount == 0 ? Colors.green : Colors.black87,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // ---------------- PAY BUTTON ----------------

  Widget _buildPayNowButton(String cartOrderId, double amount) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF00473E), Color(0xFF0B7D6C)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(
            context,
            PaymentInitiatedScreen.route,
            arguments: {
              'amount': amount.toStringAsFixed(2),
              'orderId': cartOrderId,
              'msgType': widget.msgType,
              'customMsg': widget.customMsg,
              // backend-generated order id
            },
          );
          // razorpay.open({
          //   'key': 'rzp_live_RkQVufjsAqPVe',
          //   'amount': (amount * 100).toInt(),
          //   'name': 'TreeLov',
          //   'description': 'Plant trees, make impact 🌱',
          // });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.lock_outline, color: Colors.white, size: 18),
            SizedBox(width: 10),
            Text(
              'Pay Securely',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- BUILD ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFDF7),
      appBar: buildCartAppBar(context),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => cartItemListBloc),
          BlocProvider(create: (_) => cartRemoveBloc),
          BlocProvider(create: (_) => cartUpdateBloc),
          BlocProvider(create: (_) => orderPlaceBloc),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<CartUpdateBloc,
                ApiState<ResponseModel, ResponseModel>>(
              listener: (_, state) {
                if (state is ApiSuccess) {
                  setState(() => _loadingCartId = null);
                  cartItemListBloc.add(ApiListFetch());
                }
              },
            ),
            BlocListener<CartRemoveBloc,
                ApiState<ResponseModel, ResponseModel>>(
              listener: (_, state) {
                if (state is ApiDeleteSuccess) {
                  setState(() => _loadingCartId = null);
                  cartItemListBloc.add(ApiListFetch());
                }
              },
            ),
            BlocListener<OrderPlaceBloc,
                ApiState<OrderPlacedResponse, ResponseModel>>(
              listener: (_, state) {
                if (state is ApiSuccess<OrderPlacedResponse, ResponseModel>) {
                  EasyLoading.dismiss();
                  _isProcessingOrder = false;
                  AppRoute.goToNextPage(
                    context: context,
                    screen: CongratulationsScreen.route,
                    arguments: {
                      'shareLink': state.data.data.publicTreeContributionUrl
                    },
                  );
                }
              },
            ),
          ],
          child: SafeArea(
            child: BlocBuilder<CartItemListBloc,
                ApiState<CartItemListResponse, ResponseModel>>(
              builder: (_, state) {
                // Update cache whenever we get a successful response
                if (state is ApiSuccess<CartItemListResponse, ResponseModel>) {
                  _cachedCartResponse = state.data;
                }

                // If we are loading and have no cached data, show the full-screen loader
                if (state is ApiLoading && _cachedCartResponse == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                // If we have cached data (or just got new data), show the list
                if (_cachedCartResponse != null &&
                    _cachedCartResponse!.data.isNotEmpty) {
                  final cart = _cachedCartResponse!;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...cart.data.map((e) => _buildCartItem(e)),
                        const SizedBox(height: 24),
                        _buildBillSummary(cart),
                        const SizedBox(height: 24),
                        _buildPayNowButton(
                          cart.data.first.id,
                          cart.getTotalCartPrice(),
                        ),
                      ],
                    ),
                  );
                }

                // If everything is done and list is empty
                if (state is ApiSuccess &&
                    _cachedCartResponse?.data.isEmpty == true) {
                  return const EmptyCartWithCard();
                }

                // Default fallback (e.g. initial state or empty)
                if (_cachedCartResponse == null && state is! ApiLoading) {
                  return const EmptyCartWithCard();
                }

                // If it's loading but we already matched the initial loader,
                // this case is handled by the "cached data" check above.
                return const EmptyCartWithCard();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyCartWithCard extends StatelessWidget {
  final VoidCallback? onStartShopping;

  const EmptyCartWithCard({
    Key? key,
    this.onStartShopping,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              // Animated Icon Stack
              Stack(
                alignment: Alignment.center,
                children: [
                  // Background Circle
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: AppColor.accent.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),

                  // Middle Circle
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: AppColor.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),

                  // Cart Icon
                  const Icon(
                    Icons.shopping_bag_outlined,
                    size: 70,
                    color: AppColor.primary,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Title
              const Text(
                'No Items in Cart',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColor.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              Text(
                'Your cart is waiting to be filled\nwith amazing trees',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.textSecondary,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
