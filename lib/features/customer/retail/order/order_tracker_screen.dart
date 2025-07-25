import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:treelove/core/config/themes/app_color.dart';

class OrderTrackerScreen extends StatefulWidget {
  const OrderTrackerScreen({super.key});

  @override
  State<OrderTrackerScreen> createState() => _OrderTrackerScreenState();
}

class _OrderTrackerScreenState extends State<OrderTrackerScreen> {
  final Map<String, dynamic> order = {
    'id': 'ORD-20349',
    'date': DateTime.now().subtract(const Duration(days: 2)),
    'status': 'Plantation Completed',
    'steps': [
      {
        'title': 'Order Placed',
        'desc': 'Placed on 06 June 2025 at 3:12 PM',
      },
      {
        'title': 'Plantation Assigned',
        'desc': 'Assigned to Vendor',
      },
      {
        'title': 'Plantation Completed',
        'desc': 'Completed on 08 June 2025',
      },
      {
        'title': 'Completed',
        'desc': 'Order fully processed and closed',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final int currentStep =
        order['steps'].indexWhere((step) => step['title'] == order['status']);

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
      /*
      appBar: AppBar(
        title: const Text("Order Status"),
        backgroundColor: AppColor.background,
        // backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.5,
      ),

       */
      body: Padding(
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
                  Text(order['id'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('dd MMM yyyy').format(order['date']),
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
                itemCount: order['steps'].length,
                itemBuilder: (context, index) {
                  final step = order['steps'][index] as Map<String, dynamic>;
                  final isCompleted = index < currentStep;
                  final isCurrent = index == currentStep;

                  return _buildStepTile(step, isCompleted, isCurrent);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepTile(
      Map<String, dynamic> step, bool isCompleted, bool isCurrent) {
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
