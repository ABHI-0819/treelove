import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:treelove/common/bloc/api_event.dart';
import 'package:treelove/common/repositories/cart_repository.dart';
import 'package:treelove/common/repositories/order_repository.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/core/widgets/common_notification.dart';
import 'package:treelove/features/customer/retail/order/bloc/order_bloc.dart';
import 'package:treelove/features/customer/retail/order/congratulations_screen.dart';
import 'package:treelove/features/customer/retail/order/order_list_screen.dart';

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

class CartScreen extends StatefulWidget {
  static const route = "/CartScreen";
  final String  msgType;
  final String customMsg;
  const CartScreen({super.key,this.msgType='',this.customMsg=''});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class CartItem {
  String title;
  double price;
  int quantity;
  double maintenancePrice;

  CartItem({
    required this.title,
    required this.price,
    this.quantity = 10, // default quantity
    this.maintenancePrice = 0.0,
  });
}

class _CartScreenState extends State<CartScreen> {
  late Razorpay razorpay;

  // List<CartItem> cartItems = [
  //   CartItem(title: 'Alphanso mango', price: 400,),
  //   CartItem(title: 'Peepal', price: 300),
  //   CartItem(title: 'Apple nutrition', price: 200),
  //   CartItem(title: 'Mirinda orange', price: 800),
  // ];

  double maintenanceCost = 3000;

  final pref = SecurePreference();

  late CartItemListBloc cartItemListBloc;
  late OrderPlaceBloc orderPlaceBloc;

  @override
  void initState() {
    super.initState();
    cartItemListBloc = CartItemListBloc(
      CartRepository(api: ApiConnection()),
    );
    orderPlaceBloc = OrderPlaceBloc(
      OrderRepository(api: ApiConnection()),
    );
    cartItemListBloc.add(ApiListFetch());
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
  }

  @override
  void dispose() {
    razorpay.clear(); // Removes all listeners
    super.dispose();
  }

  List<CartItem> cartItems = [];

  // double getItemTotal( ) {
  //   return cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  // }

  /*
  double getGrandTotal(double itemTotalCost,int gstPercentage,double locationCharge,double platformFree) {
    return getItemTotal() + maintenanceCost + 3000 + 3000 + 3000; // Gst + Location Charges + Platform Fee
  }

   */

  double getGrandTotal(double itemTotalCost, int gstPercentage,
      double locationCharge, double platformFee) {
    // GST amount
    double gstAmount = (itemTotalCost * gstPercentage) / 100;

    // Grand total = Item cost + GST + extra charges
    double grandTotal =
        itemTotalCost + gstAmount + locationCharge + platformFee;

    return double.parse(grandTotal.toStringAsFixed(2));
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    _showAlertDialog(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    _showAlertDialog(
        context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    _showAlertDialog(context, "External Wallet", "${response.walletName}");
  }

  void _showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, size: 20),
                  onPressed: () {
                    if (item.quantity > 1) {
                      setState(() {
                        item.quantity--;
                      });
                    }
                  },
                ),
                Text(
                  '${item.quantity}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 20),
                  onPressed: () {
                    setState(() {
                      item.quantity++;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              // '₹ ${item.price * item.quantity}'.,
              '₹ ${(item.price * item.quantity).toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFFB6A865),
              ),
            ),
          ],
        ),
        const Divider(height: 32),
      ],
    );
  }

  Widget _buildCostRow(String label, String symbol, double amount,
      {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '$symbol $amount',
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

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
          ],
          child: SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    color: Color(0xFFF7F2E6),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'Cart',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          AppRoute.pushAndRemoveUntil(context,RetailMainScreen.route,arguments: {});
                        },
                      ),
                      // const Icon(Icons.close),
                    ],
                  ),
                ),
                BlocBuilder<CartItemListBloc,
                        ApiState<CartItemListResponse, ResponseModel>>(
                    builder: (context, state) {
                  if (state
                      is ApiLoading<CartItemListResponse, ResponseModel>) {
                    return CircularProgressIndicator();
                  } else if (state
                      is ApiSuccess<CartItemListResponse, ResponseModel>) {
                    CartItemListResponse cartList = state.data;
                    if(cartList.data.isNotEmpty){
                      for (int i = 0; i < cartList.data.length; i++) {
                        cartItems.add(CartItem(
                          title: cartList.data[i].treeName,
                          price: cartList.data[i].totalPrice,
                          quantity: cartList.data[i].quantity,
                          maintenancePrice: cartList.data[i].unitPrice,
                        ));
                      }
                      return Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Thankyou for making\nthe world greener',
                                style: TextStyle(
                                  fontSize: 26,
                                  height: 1.4,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Serif',
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Cart Items
                              ...List.generate(
                                cartList.data.length,
                                    (index) => _buildCartItem(CartItem(
                                  title: cartList.data[index].treeName,
                                  price: cartList.data[index].unitPrice,
                                  quantity: cartList.data[index].quantity,
                                  maintenancePrice:
                                  cartList.data[index].unitPrice,
                                )),
                              ),

                              const SizedBox(height: 24),

                              // Bill Summary
                              const Text(
                                'Bill summary',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),

                              _buildCostRow('Item total', '₹',
                                  cartList.getTotalCartPrice()),
                              _buildCostRow('Gst', '%', 18),
                              _buildCostRow('Treelov location Charges', '₹', 200),
                              _buildCostRow('Platform fee', '₹', 100),

                              const Divider(height: 32),
                              _buildCostRow(
                                  'Grand total',
                                  '₹',
                                  getGrandTotal(
                                      cartList.getTotalCartPrice(), 18, 200, 100),
                                  isBold: true),

                              // Pay Now Button
                              BlocListener<OrderPlaceBloc,
                                  ApiState<OrderPlacedResponse, ResponseModel>>(
                                listener: (context, state) {
                                  if (state is ApiLoading<OrderPlacedResponse, ResponseModel>) {
                                    EasyLoading.show();
                                  } else if (state is ApiSuccess<OrderPlacedResponse, ResponseModel>) {

                                    EasyLoading.dismiss();
                                    OrderPlacedResponse  placedData = state.data;
                                    final contributionUrl =  placedData.data.publicTreeContributionUrl;
                                    showNotification(context,
                                        message: state.data.message.toString(),
                                        type: Not.success);
                                    AppRoute.goToNextPage(
                                        context: context,
                                        screen: CongratulationsScreen.route,
                                        arguments: {
                                          'shareLink':contributionUrl
                                        });
                                  } else if (state
                                  is TokenExpired<OrderPlacedResponse, ResponseModel>) {
                                    EasyLoading.dismiss();
                                    AppRoute.pushReplacement(context, SignInScreen.route,
                                        arguments: {});
                                  } else if (state
                                  is ApiFailure<OrderPlacedResponse, ResponseModel>) {
                                    EasyLoading.dismiss();
                                    showNotification(context,
                                        message: state.error.message.toString(),
                                        type: Not.failed);
                                  }
                                },
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        /// fixed this after the testing
                                        /*
                                        final userId = await pref.getString(Keys.id);
                                        final order = OrderPlaceRequest(
                                          userId: userId,
                                          treeMessageType:widget.msgType,
                                          treeCustomMessage:widget.customMsg,
                                        );
                                        orderPlaceBloc.add(ApiAdd(order));

                                         */
                                                      var options = {
                                                        'key': 'rzp_live_RkQVukSjsAqPVe', // Replace with your actual key
                                                        ///amount must be required
                                                        'amount': 10,
                                                        'name': 'TreeLov',
                                                        'description': 'Plantation',
                                                        'retry': {'enabled': true, 'max_count': 2},
                                                        'send_sms_hash': true,
                                                      };
                                                      razorpay.open(options);


                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF00473E),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(40),
                                        ),
                                        // minimumSize:  Size.fromHeight(56),
                                      ),
                                      child: const Text(
                                        'Pay now',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }else{
                      return EmptyCartWithCard();
                    }

                  } else {
                    return EmptyCartWithCard();
                  }
                }),

              ],
            ),
          ),
        ));
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
