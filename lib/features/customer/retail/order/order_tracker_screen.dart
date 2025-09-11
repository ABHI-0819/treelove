import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:treelove/common/bloc/api_event.dart';
import 'package:treelove/core/config/themes/app_color.dart';
import 'package:treelove/features/customer/retail/order/bloc/order_bloc.dart';

import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../common/repositories/order_repository.dart';
import '../../../../core/network/api_connection.dart';
import 'models/order_list_response.dart';
import 'models/order_tracking_response.dart';

class OrderTrackerScreen extends StatefulWidget {
  static const route = '/order-tracker';
  final String orderId;

  const OrderTrackerScreen({super.key, required this.orderId});

  @override
  State<OrderTrackerScreen> createState() => _OrderTrackerScreenState();
}

/*

class _OrderTrackerScreenState extends State<OrderTrackerScreen> {


  late OrderTrackerBloc orderTrackerBloc;

  @override
  void initState() {
    orderTrackerBloc = OrderTrackerBloc(
        OrderRepository(api: ApiConnection())
    );
    orderTrackerBloc.add(ApiFetch(orderId: widget.orderId));
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: const Text("Order Status"),
        backgroundColor: AppColor.background,
        centerTitle: true,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColor.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocProvider(
        create: (context) => orderTrackerBloc,
        child: BlocBuilder<OrderTrackerBloc,
            ApiState<OrderTrackingResponse, ResponseModel>>(
            builder: (context, state) {
              if (state is ApiLoading<OrderTrackingResponse, ResponseModel>) {
                return CircularProgressIndicator();
              } else if (state
              is ApiSuccess<OrderTrackingResponse, ResponseModel>) {
                OrderTrackingResponse data= state.data;
                final int currentStep =
                data.data.timeline.indexWhere((step) => step.achieved == true);
               return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Summary Card
                      Container(
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
                            Text(data.data.orderId,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text(
                                  "28 Aug 2025",
                                  // DateFormat('dd MMM yyyy').format(order['date']),
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        "Order Progress",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),

                      // Step List
                      Expanded(
                        child: ListView.builder(
                          itemCount: data.data.timeline.length,
                          itemBuilder: (context, index) {
                            final step = data.data.timeline[index];
                            final isCompleted = index < currentStep;
                            final isCurrent = index == currentStep;

                            return _buildStepTile(step, isCompleted, isCurrent);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return _buildEmptyOrders();
              }
            }),

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

  Widget _buildStepTile(Map<String, dynamic> step, bool isCompleted,
      bool isCurrent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Indicator
          Column(
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: isCompleted || isCurrent
                    ? AppColor.primary
                    : Colors.grey.shade300,
                child: Icon(
                  isCompleted
                      ? Icons.check
                      : isCurrent
                      ? Icons.circle
                      : Icons.circle_outlined,
                  size: 12,
                  color: Colors.white,
                ),
              ),
              if (step['title'] != 'Completed')
                Container(
                  height: 40,
                  width: 2,
                  color: isCompleted ? AppColor.primary : Colors.grey.shade300,
                ),
            ],
          ),
          const SizedBox(width: 12),

          // Step Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step['title'] ?? '',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                      color:
                      isCompleted || isCurrent ? Colors.black : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    step['desc'] ?? '',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}

 */
class _OrderTrackerScreenState extends State<OrderTrackerScreen> {
  late OrderTrackerBloc orderTrackerBloc;

  @override
  void initState() {
    super.initState();
    orderTrackerBloc = OrderTrackerBloc(OrderRepository(api: ApiConnection()));
    orderTrackerBloc.add(ApiFetch(orderId: widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: const Text("Order Status"),
        backgroundColor: AppColor.background,
        centerTitle: true,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocProvider(
        create: (context) => orderTrackerBloc,
        child: BlocBuilder<OrderTrackerBloc,
            ApiState<OrderTrackingResponse, ResponseModel>>(
          builder: (context, state) {
            if (state is ApiLoading<OrderTrackingResponse, ResponseModel>) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ApiSuccess<OrderTrackingResponse, ResponseModel>) {
              final data = state.data.data;
              final timeline = data.timeline;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Summary Card
                    Container(
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
                          Text(data.orderId,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text(
                                // you might parse timestamp for actual date
                                DateFormat('dd MMM yyyy').format(DateTime.now()),
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      "Order Progress",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),

                    Expanded(
                      child: ListView.builder(
                        itemCount: timeline.length,
                        itemBuilder: (context, index) {
                          final step = timeline[index];
                          return _buildStepTile(step);
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return _buildEmptyOrders();
            }
          },
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
          children: const [
            Icon(Icons.inbox_outlined, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text("No Orders Yet",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            SizedBox(height: 8),
            Text(
              "Looks like you haven’t placed any orders yet.\nOnce you do, they'll show up here.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepTile(TimelineItem step) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Indicator
          Column(
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: step.achieved || step.current
                    ? AppColor.primary
                    : Colors.grey.shade300,
                child: Icon(
                  step.achieved
                      ? Icons.check
                      : step.current
                      ? Icons.circle
                      : Icons.circle_outlined,
                  size: 12,
                  color: Colors.white,
                ),
              ),
              if (step.status.toLowerCase() != 'completed')
                Container(
                  height: 40,
                  width: 2,
                  color: step.achieved ? AppColor.primary : Colors.grey.shade300,
                ),
            ],
          ),
          const SizedBox(width: 12),

          // Step Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                      step.current ? FontWeight.bold : FontWeight.w500,
                      color: step.achieved || step.current
                          ? Colors.black
                          : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (step.timestamp != null)
                    Text(
                      step.formattedTimestamp,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

