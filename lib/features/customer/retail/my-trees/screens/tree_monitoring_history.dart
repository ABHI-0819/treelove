import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:treelove/common/repositories/monitor_repository.dart';
import 'package:treelove/common/widgets/full_screen_image_viewer.dart';
import 'package:treelove/core/config/themes/app_color.dart';
import 'package:treelove/core/config/themes/app_fonts.dart';
import 'package:treelove/core/network/base_network.dart';
import 'package:treelove/features/customer/retail/my-trees/bloc/monitor_history_bloc.dart';

import '../../../../../common/bloc/api_event.dart';
import '../../../../../common/bloc/api_state.dart';
import '../../../../../common/models/response.mode.dart';
import '../../../../../core/network/api_connection.dart';
import '../models/monitor_history_list_response.dart';

class TreeMonitoringHistoryScreen extends StatefulWidget {
  static const route = '/tree-monitoring-history';
  final String treeId;

  const TreeMonitoringHistoryScreen({
    super.key,
    required this.treeId,
  });

  @override
  State<TreeMonitoringHistoryScreen> createState() =>
      _TreeMonitoringHistoryScreenState();
}

class _TreeMonitoringHistoryScreenState
    extends State<TreeMonitoringHistoryScreen> {
  late MonitoringHistoryBloc monitoringHistoryBloc;

  @override
  void initState() {
    super.initState();
    monitoringHistoryBloc =
        MonitoringHistoryBloc(MonitorRepository(api: ApiConnection()));
    monitoringHistoryBloc.add(ApiListFetch(id: widget.treeId));
  }

  @override
  void dispose() {
    monitoringHistoryBloc.close();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text(
          "Monitoring History",
          style: AppFonts.title.copyWith(
            color: AppColor.primary,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColor.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocProvider(
        create: (context) => monitoringHistoryBloc,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: BlocBuilder<MonitoringHistoryBloc,
                      ApiState<MonitoringHistoryListResponse, ResponseModel>>(
                    builder: (context, state) {
                      if (state is ApiLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ApiSuccess<
                          MonitoringHistoryListResponse, ResponseModel>) {
                        final records = state.data.data;
                        if (records.isEmpty) {
                          return const Center(
                              child: Text('No monitoring records found.'));
                        }
                        return ListView.builder(
                          itemCount: records.length,
                          itemBuilder: (context, index) {
                            return _buildMonitoringCardFromModel(
                                records[index], index, records.length);
                          },
                        );
                      } else if (state is ApiFailure || state is TokenExpired) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error,
                                  color: Colors.red, size: 48),
                              const SizedBox(height: 12),
                              Text(
                                state is TokenExpired<
                                        MonitoringHistoryListResponse,
                                        ResponseModel>
                                    ? 'Session expired. Please log in again.'
                                    : 'Failed to load data.',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.red),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  monitoringHistoryBloc
                                      .add(ApiListFetch(id: widget.treeId));
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonitoringCardFromModel(
      MonitoringRecord record, int index, int total) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Section: Image & Date Badge
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  final imageUrl = (record.thumbnail?.isNotEmpty ?? false)
                      ? '${BaseNetwork.BASE_Image_URL}${record.thumbnail}'
                      : record.treeSpecies.image;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImageViewer(
                        imageUrl: imageUrl,
                        heroTag: 'monitor_image_${record.id}',
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: 'monitor_image_${record.id}',
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16.r)),
                    child: CachedNetworkImage(
                      imageUrl: (record.thumbnail?.isNotEmpty ?? false)
                          ? '${BaseNetwork.BASE_Image_URL}${record.thumbnail}'
                          : record.treeSpecies.image,
                      height: 180.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 180.h,
                        color: Colors.grey[100],
                        child:
                            const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 180.h,
                        color: Colors.grey[100],
                        child: const Icon(Icons.image_not_supported,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              // Floating Date Badge
              Positioned(
                top: 12.h,
                right: 12.w,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColor.primary.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    DateFormat('MMM dd, yyyy').format(record.monitoringDate),
                    style: AppFonts.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Body section
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Metrics Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMetricDetail(
                      icon: Icons.straighten_rounded,
                      label: "Girth",
                      value: record.treeGirth != null
                          ? "${record.treeGirth}${record.treeGirthUnit ?? 'cm'}"
                          : "—",
                    ),
                    _buildMetricDetail(
                      icon: Icons.height_rounded,
                      label: "Height",
                      value: record.treeHeight != null
                          ? "${record.treeHeight}${record.treeHeightUnit ?? 'ft'}"
                          : "—",
                    ),
                    _buildMetricDetail(
                      icon: Icons.eco_outlined,
                      label: "Stage",
                      value: record.monitoringType,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Remarks area
                if (record.remarks.isNotEmpty) ...[
                  Text(
                    "Remarks:",
                    style: AppFonts.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColor.textMuted,
                      fontSize: 11.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    record.remarks,
                    style: AppFonts.body.copyWith(
                      color: AppColor.textSecondary,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricDetail({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20.sp, color: AppColor.primary.withOpacity(0.7)),
        SizedBox(height: 6.h),
        Text(
          label,
          style: AppFonts.caption.copyWith(
            color: AppColor.textMuted,
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: AppFonts.body.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColor.textPrimary,
            fontSize: 13.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildColoredBadge({required String text, required Color color}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        text,
        style: AppFonts.caption.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12.sp,
        ),
      ),
    );
  }

  Widget _buildFooterIcon(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: Colors.grey[400]),
        SizedBox(width: 6.w),
        Text(
          label,
          style: AppFonts.caption.copyWith(
            color: Colors.grey[500],
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return SizedBox(
      width: 90.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              value.isEmpty ? '—' : value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonitoringTypeBadge(String type) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColor.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        type.toUpperCase(),
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
          color: AppColor.primary,
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    Color? color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color ?? AppColor.grey,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: AppColor.primary),
          SizedBox(width: 4.w),
          Text(
            label,
            style: AppFonts.caption.copyWith(
              color: AppColor.textSecondary,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getHealthColor(String? health) {
    if (health == null) return AppColor.textMuted;
    switch (health.toLowerCase()) {
      case 'excellent':
      case 'very good':
      case 'good':
        return AppColor.success;
      case 'fair':
      case 'average':
        return AppColor.warning;
      case 'poor':
      case 'critical':
        return AppColor.error;
      default:
        return AppColor.primary;
    }
  }
}
