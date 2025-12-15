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
import 'bloc/cart_item_bloc.dart';
import 'model/cart_item_list_model.dart';
import 'model/cart_item_update_request_model.dart';

import 'package:shimmer/shimmer.dart';
/*
class CartItem {
  String cartId;
  String title;
  double price;
  int quantity;
  double maintenancePrice;

  CartItem({
    required this.cartId,
    required this.title,
    required this.price,
    required this.quantity,
    required this.maintenancePrice,
  });
}

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

  @override
  void initState() {
    super.initState();

    final cartRepo = CartRepository(api: ApiConnection());

    cartItemListBloc = CartItemListBloc(cartRepo);
    cartRemoveBloc = CartRemoveBloc(cartRepo);
    cartUpdateBloc = CartUpdateBloc(cartRepo);
    orderPlaceBloc =OrderPlaceBloc(OrderRepository(api: ApiConnection()));

    cartItemListBloc.add(ApiListFetch());

    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(
        Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
        handleExternalWalletSelected);
  }

  @override
  void dispose() {
    razorpay.clear();
    super.dispose();
  }

  // ----------------- PAYMENT HANDLERS -----------------

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    showNotification(context,
        message: response.message ?? "Payment failed",
        type: Not.failed);
  }

  void handlePaymentSuccessResponse(
      PaymentSuccessResponse response) async {
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

  void handleExternalWalletSelected(
      ExternalWalletResponse response) {
    showNotification(context,
        message: 'Processing with ${response.walletName}',
        type: Not.success);
  }

  // ----------------- UI HELPERS -----------------

  Widget _buildCartItem(CartItem item) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(item.title,
                  style: const TextStyle(fontSize: 16)),
            ),

            /// ➖ Quantity
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: item.quantity > 1
                  ? () {
                      cartUpdateBloc.add(
                            ApiUpdate(
                              CartItemUpdateRequestModel(
                                cartId: item.cartId,
                                quanity: item.quantity - 1,
                              ),
                            ),
                          );
                    }
                  : null,
            ),

            Text('${item.quantity}',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),

            /// ➕ Quantity
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                cartUpdateBloc.add(
                      ApiUpdate(
                        CartItemUpdateRequestModel(
                          cartId: item.cartId,
                          quanity: item.quantity + 1,
                        ),
                      ),
                    );
              },
            ),

            /// 🗑 Remove
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  color: Colors.red),
              onPressed: () {
                cartRemoveBloc.add(ApiDelete(item.cartId));
              },
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '₹ ${(item.price * item.quantity).toStringAsFixed(2)}',
            style: const TextStyle(
                fontSize: 16, color: Color(0xFFB6A865)),
          ),
        ),
        const Divider(height: 32),
      ],
    );
  }

  double _grandTotal(double total) {
    final gst = total * 0.18;
    return total + gst + 200 + 100;
  }

  // ----------------- BUILD -----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFDF7),
      body: MultiBlocProvider(
        providers: [
        BlocProvider(
              create: (context) => cartItemListBloc,
            ),
            BlocProvider(
              create: (context) => orderPlaceBloc,
            ),
            BlocProvider(create: (_) => cartRemoveBloc),
            BlocProvider(create: (_) => cartUpdateBloc),
        ],
        child: MultiBlocListener(
          listeners: [
            /// Refresh cart after update
            BlocListener<CartUpdateBloc,
                ApiState<ResponseModel, ResponseModel>>(
              listener: (_, state) {
                if (state is ApiSuccess) {
                  cartItemListBloc.add(ApiListFetch());
                }
              },
            ),

            /// Refresh cart after delete
            BlocListener<CartRemoveBloc,
                ApiState<ResponseModel, ResponseModel>>(
              listener: (_, state) {
                if (state is ApiDeleteSuccess) {
                  cartItemListBloc.add(ApiListFetch());
                  showNotification(context,
                      message: "Item removed",
                      type: Not.success);
                }
              },
            ),

            /// Order place listener
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
                      'shareLink':
                          state.data.data.publicTreeContributionUrl
                    },
                  );
                } else if (state is ApiFailure<OrderPlacedResponse, ResponseModel>) {
                  EasyLoading.dismiss();
                  _isProcessingOrder = false;
                  showNotification(context,
                      message: state.error.message ?? '',
                      type: Not.failed);
                }
              },
            ),
          ],
          child: SafeArea(
            child: BlocBuilder<CartItemListBloc,
                ApiState<CartItemListResponse, ResponseModel>>(
              builder: (_, state) {
                if (state is ApiLoading) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                if (state is ApiSuccess<CartItemListResponse,ResponseModel> && state.data.data.isNotEmpty) {
                  final cart = state.data;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Thank you for making\nthe world greener',
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 32),

                        ...cart.data.map(
                          (e) => _buildCartItem(
                            CartItem(
                              cartId: e.id,
                              title: e.treeName,
                              price: e.unitPrice,
                              quantity: e.quantity,
                              maintenancePrice: e.unitPrice,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                        Text('Grand Total: ₹ ${_grandTotal(cart.getTotalCartPrice()).toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),

                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            razorpay.open({
                              'key': 'rzp_live_xxx',
                              'amount':
                                  (_grandTotal(cart.getTotalCartPrice()) *
                                          100)
                                      .toInt(),
                              'name': 'TreeLov',
                            });
                          },
                          child: const Text('Pay Now'),
                        ),
                      ],
                    ),
                  );
                }

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


*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

// ---- YOUR IMPORTS ----
// import '...';

class CartItem {
  String cartId;
  String title;
  double price;
  int quantity;
  double maintenancePrice;

  CartItem({
    required this.cartId,
    required this.title,
    required this.price,
    required this.quantity,
    required this.maintenancePrice,
  });
}

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

  @override
  void initState() {
    super.initState();

    final cartRepo = CartRepository(api: ApiConnection());

    cartItemListBloc = CartItemListBloc(cartRepo);
    cartRemoveBloc = CartRemoveBloc(cartRepo);
    cartUpdateBloc = CartUpdateBloc(cartRepo);
    orderPlaceBloc =
        OrderPlaceBloc(OrderRepository(api: ApiConnection()));

    cartItemListBloc.add(ApiListFetch());

    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
        handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
        handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
        handleExternalWalletSelected);
  }

  @override
  void dispose() {
    razorpay.clear();
    super.dispose();
  }

  // ---------------- PAYMENT ----------------

  void handlePaymentErrorResponse(
      PaymentFailureResponse response) {
    showNotification(context,
        message: response.message ?? "Payment failed",
        type: Not.failed);
  }

  void handlePaymentSuccessResponse(
      PaymentSuccessResponse response) async {
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
             AppRoute.pushReplacement(
                      context, RetailMainScreen.route, arguments: {});
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
                    AppRoute.pushReplacement(
                      context, RetailMainScreen.route, arguments: {});
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


  void handleExternalWalletSelected(
      ExternalWalletResponse response) {
    showNotification(context,
        message: 'Processing with ${response.walletName}',
        type: Not.success);
  }

  // ---------------- CART ITEM ----------------

  Widget _buildCartItem(CartItem item) {
    final isLoading = _loadingCartId == item.cartId;

    return Stack(
      children: [
        Opacity(
          opacity: isLoading ? 0.5 : 1,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: isLoading || item.quantity <= 1
                        ? null
                        : () {
                            setState(() =>
                                _loadingCartId = item.cartId);
                            cartUpdateBloc.add(
                              ApiUpdate(
                                CartItemUpdateRequestModel(
                                  cartId: item.cartId,
                                  quanity: item.quantity - 1,
                                ),
                              ),
                            );
                          },
                  ),

                  Text(
                    '${item.quantity}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),

                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: isLoading
                        ? null
                        : () {
                            setState(() =>
                                _loadingCartId = item.cartId);
                            cartUpdateBloc.add(
                              ApiUpdate(
                                CartItemUpdateRequestModel(
                                  cartId: item.cartId,
                                  quanity: item.quantity + 1,
                                ),
                              ),
                            );
                          },
                  ),

                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.red),
                    onPressed: isLoading
                        ? null
                        : () {
                            setState(() =>
                                _loadingCartId = item.cartId);
                            cartRemoveBloc
                                .add(ApiDelete(item.cartId));
                          },
                  ),
                ],
              ),

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '₹ ${(item.price * item.quantity).toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF00473E),
                      fontWeight: FontWeight.w600),
                ),
              ),

              const Divider(height: 28),
            ],
          ),
        ),

        if (isLoading)
          const Positioned.fill(
            child: Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
      ],
    );
  }

  // ---------------- BILL SUMMARY ----------------

  Widget _buildBillSummary(CartItemListResponse cart) {
    final itemTotal = cart.getTotalCartPrice();
    final gst = itemTotal * 0.18;
    const locationCharge = 200.0;
    const platformFee = 100.0;
    final grandTotal =
        itemTotal + gst + locationCharge + platformFee;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bill Summary',
            style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          _billRow('Item Total', itemTotal),
          _billRow('GST (18%)', gst),
          _billRow('Location Charges', locationCharge),
          _billRow('Platform Fee', platformFee),

          const Divider(height: 32),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Grand Total',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '₹ ${grandTotal.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00473E)),
              ),
            ],
          ),

          const SizedBox(height: 6),
          const Text(
            'Inclusive of all taxes & charges',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _billRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text('₹ ${amount.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  // ---------------- PAY BUTTON ----------------

  Widget _buildPayNowButton(double amount) {
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
          razorpay.open({
            'key': 'rzp_live_RkQVukSjsAqPVe',
            'amount': (amount * 100).toInt(),
            'name': 'TreeLov',
            'description': 'Plant trees, make impact 🌱',
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.lock_outline,
                color: Colors.white, size: 18),
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
                      'shareLink':
                          state.data.data.publicTreeContributionUrl
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
                if (state is ApiLoading) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                if (state is ApiSuccess<CartItemListResponse, ResponseModel> &&
                    state.data.data.isNotEmpty) {
                  final cart = state.data;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...cart.data.map(
                          (e) => _buildCartItem(
                            CartItem(
                              cartId: e.id,
                              title: e.treeName,
                              price: e.unitPrice,
                              quantity: e.quantity,
                              maintenancePrice: e.unitPrice,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                        _buildBillSummary(cart),
                        const SizedBox(height: 24),
                        _buildPayNowButton(
                          cart.getTotalCartPrice() * 1.18 + 300,
                        ),
                      ],
                    ),
                  );
                }

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
