import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:treelove/common/repositories/maintenance_repository.dart';
import 'package:treelove/common/widgets/full_screen_image_viewer.dart';
import 'package:treelove/core/config/themes/app_color.dart';
import 'package:treelove/core/config/themes/app_fonts.dart';
import 'package:treelove/core/network/base_network.dart';
import 'package:treelove/features/customer/retail/my-trees/bloc/maintenance_history_bloc.dart';
import 'package:treelove/features/customer/retail/my-trees/models/maintenance_history_list_response.dart';

import '../../../../../common/bloc/api_event.dart';
import '../../../../../common/bloc/api_state.dart';
import '../../../../../common/models/response.mode.dart';
import '../../../../../core/network/api_connection.dart';

class TreeMaintenanceHistoryScreen extends StatefulWidget {
  static const route = '/tree-maintenance-history';
  final String treeId;

  const TreeMaintenanceHistoryScreen({
    super.key,
    required this.treeId,
  });

  @override
  State<TreeMaintenanceHistoryScreen> createState() =>
      _TreeMaintenanceHistoryScreenState();
}

class _TreeMaintenanceHistoryScreenState
    extends State<TreeMaintenanceHistoryScreen> {
  late MaintenanceHistoryBloc maintenanceHistoryBloc;

  @override
  void initState() {
    super.initState();
    maintenanceHistoryBloc =
        MaintenanceHistoryBloc(MaintenanceRepository(api: ApiConnection()));
    // Trigger data fetch when screen loads
    maintenanceHistoryBloc.add(ApiListFetch(id: widget.treeId));
  }

  @override
  void dispose() {
    maintenanceHistoryBloc.close();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text(
          "Maintenance History",
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
        create: (context) => maintenanceHistoryBloc,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: BlocBuilder<MaintenanceHistoryBloc,
                      ApiState<MaintenanceHistoryListResponse, ResponseModel>>(
                    builder: (context, state) {
                      if (state is ApiLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ApiSuccess<
                          MaintenanceHistoryListResponse, ResponseModel>) {
                        final records =
                            state.data.data; // List<MaintenanceRecord>
                        if (records.isEmpty) {
                          return const Center(
                              child: Text('No maintenance records found.'));
                        }
                        return ListView.builder(
                          itemCount: records.length,
                          itemBuilder: (context, index) {
                            return _buildMaintenanceCardFromModel(
                                records[index]);
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
                                        MaintenanceHistoryListResponse,
                                        ResponseModel>
                                    ? 'Session expired. Please log in again.'
                                    : 'Failed to load data.',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.red),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  maintenanceHistoryBloc
                                      .add(ApiListFetch(id: widget.treeId));
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // ApiInitial or unknown
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

  Widget _buildMaintenanceCardFromModel(MaintenanceRecord record) {
    String activities =
        record.maintenanceActivity.map((a) => a.name).join(', ');

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
                        heroTag: 'maintain_image_${record.id}',
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: 'maintain_image_${record.id}',
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
                    DateFormat('MMM dd, yyyy').format(record.maintenanceDate),
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
                // Activity Performed
                Text(
                  "Activity Performed:",
                  style: AppFonts.caption.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColor.textMuted,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  activities,
                  style: AppFonts.title.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColor.primary,
                    fontSize: 16.sp,
                  ),
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

  Widget _buildStatusBadge(String health) {
    Color color;
    String statusText;

    switch (health.toLowerCase()) {
      case 'good':
      case 'excellent':
        color = AppColor.success;
        statusText = "Completed";
        break;
      case 'fair':
        color = AppColor.warning;
        statusText = "Completed (Fair)";
        break;
      default:
        color = AppColor.primary;
        statusText = "Completed";
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        statusText,
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

  Widget _buildStatusIcon(String health) {
    Color color;
    IconData icon;
    switch (health.toLowerCase()) {
      case 'good':
      case 'excellent':
        color = AppColor.success;
        icon = Icons.check_circle_rounded;
        break;
      case 'fair':
        color = AppColor.warning;
        icon = Icons.info_rounded;
        break;
      default:
        color = AppColor.primary;
        icon = Icons.history_rounded;
    }

    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20.sp),
    );
  }
}
