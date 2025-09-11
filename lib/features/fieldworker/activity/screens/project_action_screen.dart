import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:treelove/common/bloc/api_event.dart';
import 'package:treelove/common/repositories/service_repository.dart';
import 'package:treelove/core/config/themes/app_color.dart';
import 'package:treelove/core/network/api_connection.dart';
import 'package:treelove/features/fieldworker/activity/bloc/project_area_bloc.dart';
import 'package:treelove/features/fieldworker/home/screens/tree_monitor_list_screen.dart';

import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../core/config/route/app_route.dart';
import '../../../../core/config/themes/app_fonts.dart';
import '../../../../core/widgets/common_notification.dart';
import '../../../authentication/screens/sign_in_screen.dart';
import '../../home/screens/select_tree_species.dart';
import '../../home/screens/tree_maintenance_list_screen.dart';
import '../models/assigned_service_type_response.dart';

class ProjectActionScreen extends StatefulWidget {
  static const route ='/ProjectActionScreen';
  final String projectId;
  final String projectAreaId;

  const ProjectActionScreen({super.key,required this.projectId,required this.projectAreaId});

  @override
  State<ProjectActionScreen> createState() => _ProjectActionScreenState();
}

class _ProjectActionScreenState extends State<ProjectActionScreen> {

  late AreaDetailBloc areaDetailBloc;

  @override
  void initState() {
    areaDetailBloc = AreaDetailBloc(ServicesRepository(api: ApiConnection()));
    areaDetailBloc.add(ApiFetch(
        projectId: widget.projectId, projectAreaId: widget.projectAreaId));
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: BlocProvider(
        create: (context) => areaDetailBloc,
        child: BlocListener<AreaDetailBloc,
            ApiState<AssignedServiceTypeResponse, ResponseModel>>(
          listener: (context, state) {
            EasyLoading.dismiss();
              if (state is ApiFailure<AssignedServiceTypeResponse, ResponseModel>) {
              showNotification(context,
                  message: state.error.message.toString());
            } else if (state is TokenExpired<AssignedServiceTypeResponse, ResponseModel>) {
              AppRoute.pushReplacement(context, SignInScreen.route,
                  arguments: {});
            }
          },
          child: BlocBuilder<AreaDetailBloc,
              ApiState<AssignedServiceTypeResponse, ResponseModel>>(
            builder: (context, state) {
              if(state is ApiLoading){
                return Center(child: CircularProgressIndicator());
              }
             else if (state is ApiSuccess<AssignedServiceTypeResponse,
                  ResponseModel>) {
                AssignedServiceTypeResponse service = state.data;
                final areaData = service.data!;
                final summaryList = areaData.serviceSummary; // ✅ Get from API
                return CustomScrollView(
                  slivers: [
                    _buildHeader(
                        context: context,
                        title: service.data!.name,
                        subTitle: 'Thane, India'
                    ),

                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final summary = summaryList[index];

                            // Decide icon & color based on service_type
                            final iconData = _getServiceIcon(summary.serviceType);
                            final bgColor = _getServiceColor(summary.serviceType);

                            return _buildActionCard(
                              title: summary.serviceType,
                              icon: iconData,
                              totalRequired: summary.totalRequired,
                              totalDone: summary.totalDone,
                              bgColor: bgColor,
                              onTap: () {
                                switch (summary.serviceType.toLowerCase()) {
                                  case "plantation":
                                    AppRoute.goToNextPage(
                                      context: context,
                                      screen: SelectTreeTypeScreen.route,
                                      arguments: {
                                        "serviceType": summary.serviceType,
                                        "projectAreaId": widget.projectAreaId
                                      },
                                    );
                                    break;
                                  case "maintenance":
                                    AppRoute.goToNextPage(
                                        context: context,
                                        screen: TreeMaintenanceListScreen.route,
                                        arguments: {
                                          'serviceId': summary.serviceType
                                        }
                                    );
                                    break;
                                  case "monitoring":
                                    AppRoute.goToNextPage(
                                        context: context,
                                        screen: TreeMonitorListScreen.route,
                                        arguments: {}
                                    );
                                    break;
                                  default:
                                  // Handle other cases
                                    break;
                                }
                              },
                            );
                          },
                          childCount: summaryList.length,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: Text(
                    "No Details found",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader({
    required BuildContext context,
    String? title,
    String? subTitle,
    int? capacity,
  }) {
    return SliverAppBar(
      expandedHeight: 80,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF00695C),
                Color(0xFF004D40),
              ],
            ),
          ),
        ),
      ),
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          // backdropFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
          onPressed: () => AppRoute.pop(context),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title ?? "Project Area",
            style: AppFonts.body.copyWith(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            subTitle ?? 'Project management dashboard',
            style: AppFonts.regular.copyWith(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

// ✅ Small pill-like chip for quick info
  Widget _infoChip({required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white),
          SizedBox(width: 4.w),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }


  // ✅ Map service types to icons
  IconData _getServiceIcon(String type) {
    switch (type.toLowerCase()) {
      case "plantation":
        return Icons.spa;
      case "maintenance":
        return Icons.build_circle_outlined;
      case "monitoring":
        return Icons.remove_red_eye_outlined;
      default:
        return Icons.workspaces_outline;
    }
  }

  // ✅ Map service types to colors
  Color _getServiceColor(String type) {
    switch (type.toLowerCase()) {
      case "plantation":
        return Colors.green.shade100;
      case "maintenance":
        return Colors.blue.shade100;
      case "monitoring":
        return Colors.purple.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required int totalRequired,
    required int totalDone,
    required Color bgColor,
    VoidCallback? onTap,
  }) {
    double progress =
    totalRequired == 0 ? 0 : totalDone / totalRequired; // calculate %

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // ✅ Icon with soft background
              Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      bgColor.withOpacity(0.9),
                      bgColor.withOpacity(0.5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: Colors.black87, size: 26.sp),
              ),

              SizedBox(width: 14.w),

              // ✅ Text + progress bar
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Progress text
                    Text(
                      "$totalDone / $totalRequired completed",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey[700],
                      ),
                    ),

                    SizedBox(height: 6.h),

                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6.h,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progress >= 1.0 ? Colors.green : Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
            ],
          ),
        ),
      ),
    );
  }

}
