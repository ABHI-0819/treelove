import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:treelove/common/bloc/api_event.dart';
import 'package:treelove/common/repositories/order_repository.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/features/customer/retail/order/bloc/order_bloc.dart';
import 'package:treelove/features/customer/retail/order/models/order_list_response.dart';

import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../core/network/api_connection.dart';
import 'order_tracker_screen.dart';

class OrderListScreen extends StatefulWidget {
  static const route = '/order-list';
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  late OrderListBloc orderListBloc;

  @override
  void initState() {
    orderListBloc = OrderListBloc(OrderRepository(api: ApiConnection()));
    orderListBloc.add(ApiListFetch());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => orderListBloc,
      child: Scaffold(
        backgroundColor: const Color(0xFFFEFEF7),
        appBar: AppBar(
          title: const Text("My Orders",
              style: TextStyle(fontWeight: FontWeight.w600)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.5,
          scrolledUnderElevation: 0,
        ),
        body: BlocBuilder<OrderListBloc,
                ApiState<OrderListResponse, ResponseModel>>(
            builder: (context, state) {
          if (state is ApiLoading<OrderListResponse, ResponseModel>) {
            return CircularProgressIndicator();
          } else if (state is ApiSuccess<OrderListResponse, ResponseModel>) {
            OrderListResponse orderList = state.data;

            return orderList.data.isEmpty
                ? _buildEmptyOrders()
                : ListView.separated(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: orderList.data.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _buildOrderCard(orderList.data[index]);
                    },
                  );
          } else {
            return _buildEmptyOrders();
          }
        }),
      ),
    );
  }

  Widget _buildOrderCard(OrderData order) {
    final statusColor = _getStatusColor(order.status);

    // Format Order ID
    String displayId = order.orderNumber ?? "N/A";
    if (displayId != "N/A" && !displayId.startsWith("#")) {
      displayId = "#$displayId";
    }

    // Format Price
    String priceDisplay = '';
    if (order.totalAmount != null && order.totalAmount!.isNotEmpty) {
      priceDisplay =
          '${order.currency.isNotEmpty ? order.currency : "₹"}${order.totalAmount}';
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            AppRoute.goToNextPage(
                context: context,
                screen: OrderTrackerScreen.route,
                arguments: {
                  'orderId': order.id,
                });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      displayId,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: statusColor.withOpacity(0.5), width: 0.5),
                      ),
                      child: Text(
                        order.status.toUpperCase().replaceAll('_', ' '),
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFFF0F0F0)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded,
                                size: 16, color: Colors.black54),
                            const SizedBox(width: 6),
                            Text(order.formattedCreatedAt,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.shopping_bag_outlined,
                                size: 16, color: Colors.black54),
                            const SizedBox(width: 6),
                            Text('${order.totalItemCount} Items',
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500)),
                            if (priceDisplay.isNotEmpty &&
                                priceDisplay != '₹null') ...[
                              const SizedBox(width: 12),
                              const Icon(Icons.payments_outlined,
                                  size: 16, color: Colors.black54),
                              const SizedBox(width: 4),
                              Text(priceDisplay,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF004D40),
                                      fontWeight: FontWeight.w700)),
                            ]
                          ],
                        ),
                      ],
                    ),
                    const Icon(Icons.chevron_right_rounded,
                        color: Colors.black38),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyOrders() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF004D40).withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.receipt_long_outlined,
                  size: 64, color: Color(0xFF004D40)),
            ),
            const SizedBox(height: 24),
            const Text("No Orders Yet",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            const SizedBox(height: 12),
            const Text(
              "Looks like you haven’t placed any orders yet.\nOnce you do, they'll show up here.",
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.black54, fontSize: 14, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  // Color _getStatusColor(String status) {
  //   switch (status.toLowerCase()) {
  //     case 'pending':
  //       return Colors.orange;
  //     case 'completed':
  //       return Colors.green;
  //     case 'cancelled':
  //       return Colors.red;
  //     default:
  //       return Colors.grey;
  //   }
  // }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      // Initial states
      case 'cart':
        return Colors.blueGrey; // items in cart
      case 'pending_payment':
        return Colors.amber; // waiting for payment
      case 'pending_review':
        return Colors.orangeAccent; // admin review pending

      // After checkout/approval
      case 'placed':
        return Colors.blue; // order placed
      case 'confirmed':
        return Colors.teal; // approved/confirmed
      case 'assigned':
        return Colors.indigo; // vendor assigned
      case 'in_progress':
        return Colors.lightBlue; // work ongoing

      // Completion states
      case 'completed':
        return Colors.green; // fully done
      case 'partially_completed':
        return Colors.lightGreen; // partially done

      // Cancellation/Failure
      case 'cancelled':
        return Colors.red; // cancelled by user/admin
      case 'rejected':
        return Colors.deepOrange; // admin rejected
      case 'failed':
        return Colors.redAccent; // failed execution

      // Default fallback
      default:
        return Colors.grey; // unknown/unexpected status
    }
  }
}

/*
class OrderListScreen extends StatefulWidget {

  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFFEFEF7),
      body: SingleChildScrollView(
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}

 */
