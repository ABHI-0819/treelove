import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';


class CartScreen extends StatefulWidget {
  static const route = "/CartScreen";
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class CartItem {
  String title;
  int price;
  int quantity;

  CartItem({
    required this.title,
    required this.price,
    this.quantity = 10, // default quantity
  });
}

class _CartScreenState extends State<CartScreen> {
  late Razorpay razorpay;

  List<CartItem> cartItems = [
    CartItem(title: 'Alphanso mango', price: 400),
    CartItem(title: 'Peepal', price: 300),
    CartItem(title: 'Apple nutrition', price: 200),
    CartItem(title: 'Mirinda orange', price: 800),
  ];

  int maintenanceCost = 3000;

  @override
  void initState() {
    super.initState();
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

  int getItemTotal() {
    return cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  int getGrandTotal() {
    return getItemTotal() + maintenanceCost + 3000 + 3000 + 3000; // Gst + Location Charges + Platform Fee
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    _showAlertDialog(context, "Payment Failed", "Code: ${response.code}\nDescription: ${response.message}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    _showAlertDialog(context, "Payment Successful", "Payment ID: ${response.paymentId}");
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
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              '₹ ${item.price * item.quantity}',
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

  Widget _buildCostRow(String label, int amount, {bool isBold = false}) {
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
            '₹ $amount',
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
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              margin:  EdgeInsets.symmetric(horizontal: 8),
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
                  const Icon(Icons.close),
                ],
              ),
            ),

            Expanded(
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
                    ...cartItems.map((item) => _buildCartItem(item)).toList(),

                    const SizedBox(height: 16),

                    // Geo Tagging
                    Container(
                      color: const Color(0xFFF9F4E2),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Geo - tagging',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Added',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Divider(height: 32),
                    _buildCostRow('Maintenance', maintenanceCost),

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

                    _buildCostRow('Item total', getItemTotal()),
                    _buildCostRow('Gst', 3000),
                    _buildCostRow('Treelov location Charges', 3000),
                    _buildCostRow('Platform fee', 3000),

                    const Divider(height: 32),
                    _buildCostRow('Grand total', getGrandTotal(), isBold: true),
                  ],
                ),
              ),
            ),

            // Pay Now Button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  var options = {
                    'key': 'your_razorpay_key', // Replace with your actual key
                    'amount': getGrandTotal(),
                    'name': 'TREELOVE',
                    'description': 'Plantation',
                    'retry': {'enabled': true, 'max_count': 1},
                    'send_sms_hash': true,
                  };
                  razorpay.open(options);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00473E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  minimumSize: const Size.fromHeight(56),
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
            )
          ],
        ),
      ),
    );
  }
}