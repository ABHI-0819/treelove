import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:treelove/common/bloc/api_event.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/core/config/themes/app_color.dart';
import 'package:treelove/core/config/themes/app_fonts.dart';
import 'package:treelove/features/customer/retail/order/bloc/order_bloc.dart';

import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../common/repositories/order_repository.dart';
import '../../../../core/network/api_connection.dart';
import '../grievance/screens/raise_grievance_screen.dart';
import 'models/order_list_response.dart';
import 'models/order_tracking_response.dart';

class OrderTrackerScreen extends StatefulWidget {
  static const route = '/order-tracker';
  final String orderId;

  const OrderTrackerScreen({super.key, required this.orderId});

  @override
  State<OrderTrackerScreen> createState() => _OrderTrackerScreenState();
}

class _OrderTrackerScreenState extends State<OrderTrackerScreen> {
  late OrderTrackerBloc orderTrackerBloc;

  @override
  void initState() {
    super.initState();
    orderTrackerBloc = OrderTrackerBloc(OrderRepository(api: ApiConnection()));
    orderTrackerBloc.add(ApiFetch(orderId: widget.orderId));
  }

  @override
  void dispose() {
    orderTrackerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          "Order Tracking",
          style: AppFonts.body.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        shadowColor: Colors.black12,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: AppColor.black,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocProvider(
        create: (context) => orderTrackerBloc,
        child: BlocBuilder<OrderTrackerBloc,
            ApiState<OrderTrackingResponse, ResponseModel>>(
          builder: (context, state) {
            if (state is ApiLoading<OrderTrackingResponse, ResponseModel>) {
              return _buildLoading();
            } else if (state
                is ApiSuccess<OrderTrackingResponse, ResponseModel>) {
              return _buildContent(state.data.data);
            } else if (state
                is ApiFailure<OrderTrackingResponse, ResponseModel>) {
              return _buildErrorState(state.error?.message ?? 'Failed to load order details.');
            } else {
              return _buildErrorState('No tracking details found.');
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColor.primary),
          SizedBox(height: 16.h),
          Text(
            'Fetching order details...',
            style: AppFonts.caption.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(OrderTrackingData data) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOrderSummaryCard(data),
          SizedBox(height: 16.h),
          if (data.items.isNotEmpty) ...[
            _buildItemsCard(data.items),
            SizedBox(height: 16.h),
          ],
          _buildTimelineCard(data.timeline),
          SizedBox(height: 16.h),
          _buildReportButton(),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  // ─── Order Summary Card ───────────────────────────────────────────────────

  Widget _buildOrderSummaryCard(OrderTrackingData data) {
    final statusColor = _getStatusColor(data.currentStatus);
    final statusIcon = _getStatusIcon(data.currentStatus);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: Order number + Status badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  data.orderNumber ?? 'Order Details',
                  style: AppFonts.body.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              _buildStatusBadge(data.currentStatus, statusColor),
            ],
          ),
          SizedBox(height: 12.h),
          const Divider(color: Color(0xFFF0F0F0), height: 1),
          SizedBox(height: 12.h),

          // Metadata row
          Row(
            children: [
              _buildMetaItem(
                icon: Icons.calendar_today_outlined,
                label: 'Order Date',
                value: data.createdAt != null
                    ? DateFormat('MMM dd, yyyy').format(data.createdAt!.toLocal())
                    : '—',
              ),
              SizedBox(width: 24.w),
              _buildMetaItem(
                icon: Icons.receipt_long_outlined,
                label: 'Total Amount',
                value: data.totalAmount != null
                    ? '₹${data.totalAmount!.toStringAsFixed(2)}'
                    : '—',
                valueColor: AppColor.primary,
                valueBold: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetaItem({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool valueBold = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14.sp, color: Colors.grey[400]),
        SizedBox(width: 6.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppFonts.caption
                  .copyWith(color: Colors.grey[500], fontSize: 10.sp),
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              style: AppFonts.body.copyWith(
                fontSize: 13.sp,
                fontWeight:
                    valueBold ? FontWeight.bold : FontWeight.w500,
                color: valueColor ?? const Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        _formatStatus(status),
        style: AppFonts.caption.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 11.sp,
        ),
      ),
    );
  }

  // ─── Items Card ───────────────────────────────────────────────────────────

  Widget _buildItemsCard(List<OrderItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
            child: Row(
              children: [
                Icon(Icons.shopping_bag_outlined,
                    size: 16.sp, color: AppColor.primary),
                SizedBox(width: 8.w),
                Text(
                  'Order Items',
                  style: AppFonts.body.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          ...items.asMap().entries.map((entry) {
            final item = entry.value;
            final isLast = entry.key == items.length - 1;
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.w, vertical: 10.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: AppColor.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.nature_outlined,
                          size: 16.sp,
                          color: AppColor.primary,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.serviceTypeName,
                              style: AppFonts.body.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 13.sp,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              item.treeName,
                              style: AppFonts.caption.copyWith(
                                color: Colors.grey[500],
                                fontSize: 11.sp,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Qty: ${item.quantity}  ×  ₹${item.unitPrice.toStringAsFixed(2)}',
                              style: AppFonts.caption.copyWith(
                                color: Colors.grey[600],
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '₹${item.totalPrice.toStringAsFixed(2)}',
                        style: AppFonts.body.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                          color: AppColor.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    color: Colors.grey[100],
                    indent: 16.w,
                    endIndent: 16.w,
                  ),
              ],
            );
          }),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  // ─── Timeline Card ────────────────────────────────────────────────────────

  Widget _buildTimelineCard(List<TimelineItem> timeline) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.track_changes_rounded,
                  size: 16.sp, color: AppColor.primary),
              SizedBox(width: 8.w),
              Text(
                'Order Progress',
                style: AppFonts.body.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          ...timeline.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isLast = index == timeline.length - 1;
            return _buildTimelineStep(step, isLast);
          }),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(TimelineItem step, bool isLast) {
    final bool isActive = step.achieved || step.current;
    final Color activeColor = step.current ? AppColor.primary : Colors.green;
    final Color inactiveColor = Colors.grey.shade300;
    final Color dotColor = isActive ? activeColor : inactiveColor;
    final Color lineColor = step.achieved ? Colors.green : inactiveColor;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: dot + line
          SizedBox(
            width: 30.w,
            child: Column(
              children: [
                // Dot
                Container(
                  width: 26.w,
                  height: 26.w,
                  decoration: BoxDecoration(
                    color: isActive
                        ? dotColor.withOpacity(0.12)
                        : Colors.grey.shade100,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: dotColor,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: step.achieved
                        ? Icon(Icons.check_rounded,
                            size: 14.sp, color: Colors.green)
                        : step.current
                            ? Container(
                                width: 8.w,
                                height: 8.w,
                                decoration: BoxDecoration(
                                  color: AppColor.primary,
                                  shape: BoxShape.circle,
                                ),
                              )
                            : Container(
                                width: 8.w,
                                height: 8.w,
                                decoration: BoxDecoration(
                                  color: inactiveColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                  ),
                ),
                // Connecting line
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: EdgeInsets.symmetric(vertical: 4.h),
                      decoration: BoxDecoration(
                        color: lineColor,
                        borderRadius: BorderRadius.circular(1.r),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          // Right: label + timestamp
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: isLast ? 0 : 20.h, top: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.label,
                    style: AppFonts.body.copyWith(
                      fontSize: 14.sp,
                      fontWeight: step.current
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isActive
                          ? const Color(0xFF1A1A2E)
                          : Colors.grey[400],
                    ),
                  ),
                  if (step.timestamp != null && step.timestamp!.isNotEmpty) ...[
                    SizedBox(height: 3.h),
                    Text(
                      step.formattedTimestamp,
                      style: AppFonts.caption.copyWith(
                        fontSize: 11.sp,
                        color: step.achieved
                            ? Colors.green.shade600
                            : Colors.grey[400],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Report Button ────────────────────────────────────────────────────────

  Widget _buildReportButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          AppRoute.goToNextPage(
            context: context,
            screen: RaiseGrievanceScreen.route,
            arguments: {},
          );
        },
        icon: Icon(Icons.report_problem_outlined,
            size: 18.sp, color: AppColor.primary),
        label: Text(
          "Report an Issue",
          style: AppFonts.body.copyWith(
            color: AppColor.primary,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          side: BorderSide(color: AppColor.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          backgroundColor: AppColor.primary.withOpacity(0.03),
        ),
      ),
    );
  }

  // ─── Error State ──────────────────────────────────────────────────────────

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 80.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.inbox_outlined,
                  size: 48.sp, color: Colors.orange),
            ),
            SizedBox(height: 16.h),
            Text(
              "Unable to load",
              style: AppFonts.body.copyWith(
                  fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppFonts.caption.copyWith(color: Colors.grey),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () {
                orderTrackerBloc.add(ApiFetch(orderId: widget.orderId));
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  String _formatStatus(String status) {
    return status
        .split('_')
        .map((word) =>
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.blue;
      case 'assigned':
        return Colors.orange;
      case 'confirmed':
        return AppColor.primary;
      case 'placed':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle_outline;
      case 'in_progress':
        return Icons.pending_outlined;
      case 'assigned':
        return Icons.person_outline;
      default:
        return Icons.circle_outlined;
    }
  }
}