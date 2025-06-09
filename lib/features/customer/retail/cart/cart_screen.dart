import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CartScreen extends StatelessWidget {
  static const route ="/CartScreen";
   CartScreen({super.key});

  Razorpay razorpay = Razorpay();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFDF7),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 56,
              color: const Color(0xF7F2E6),
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
                        fontFamily: 'Serif', // Use custom serif font if needed
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Item List
                    _buildCartItem('Alphanso mango', 129999),
                    _buildCartItem('Peepal', 129999),
                    _buildCartItem('Apple nutrition', 129999),
                    _buildCartItem('Mirinda orange', 129999),

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
                    _buildCostRow('Maintenance', 3000),

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

                    _buildCostRow('Item total', 3000),
                    _buildCostRow('Gst', 3000),
                    _buildCostRow('Treelov location Charges', 3000),
                    _buildCostRow('Platform fee', 3000),

                    const Divider(height: 32),
                    _buildCostRow(
                      'Grand total',
                      3000,
                      isBold: true,
                    ),
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
                    'key': 'rzp_test_g52cA1ZI1maLey', // Replace with your Razorpay Key ID
                    'amount':3000,
                    'name': 'TREELOVE',
                    'description': 'Plantation',
                    'retry': {'enabled': true, 'max_count': 1},
                    'send_sms_hash': true,
                  };
                  razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
                  razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
                  razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
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

  void handlePaymentErrorResponse(PaymentFailureResponse response){
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    // showAlertDialog(context, "Payment Failed", "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response){
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    // showAlertDialog(context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response){
    // showAlertDialog(context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message){
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed:  () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  Widget _buildCartItem(String title, int price) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Row(
              children: const [
                Icon(Icons.remove, size: 20),
                SizedBox(width: 4),
                Text('10'),
                SizedBox(width: 4),
                Icon(Icons.add, size: 20),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '₹ $price',
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



}
