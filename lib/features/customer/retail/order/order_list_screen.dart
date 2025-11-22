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
  static const route ='/order-list';
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {


  late OrderListBloc orderListBloc;

  @override
  void initState() {
    orderListBloc = OrderListBloc(
      OrderRepository(api:  ApiConnection())
    );
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
          title: const Text("My Orders", style: TextStyle(fontWeight: FontWeight.w600)),
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
            } else if (state
            is ApiSuccess<OrderListResponse, ResponseModel>) {

              OrderListResponse orderList = state.data;

             return orderList.data.isEmpty
                  ? _buildEmptyOrders()
                  : ListView.separated(
                padding: const EdgeInsets.all(16.0),
                itemCount:  orderList.data.length,
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

    return InkWell(
      onTap: (){
        AppRoute.goToNextPage(context: context, screen: OrderTrackerScreen.route, arguments: {
          'orderId':order.id,
        });
      },
      child:  Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  order.orderNumber??"Order id not Found",
                  // order.id.length > 10 ? order.id.substring(order.id.length - 10) : order.id,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                // Text(
                //   order.id.,
                //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                // ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(order.formattedCreatedAt, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const Spacer(),
                Text('Items(${order.totalItemCount})', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ],
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
            const Icon(Icons.inbox_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text("No Orders Yet",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            const Text(
              "Looks like you haven’t placed any orders yet.\nOnce you do, they'll show up here.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
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
