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
                return Column(
                  children: [
                    _buildHeader(context: context,
                        title: service.data!.name,
                        subTitle: 'Thane,India'),
                    Expanded(
                      child: ListView.builder(
                        itemCount: summaryList.length,
                        itemBuilder: (context, index) {
                          final summary = summaryList[index];

                          //  Decide icon & color based on service_type
                          final iconData = _getServiceIcon(summary.serviceType);
                          final bgColor = _getServiceColor(summary.serviceType);

                          return _buildActionCard(
                            title: summary.serviceType,
                            icon: iconData,
                            totalRequired: summary.totalRequired,
                            totalDone: summary.totalDone,
                            // badgeCount: summary.totalRequired - summary.totalDone, // remaining work
                            bgColor: bgColor,
                            onTap: () {

                              switch (summary.serviceType.toLowerCase()) {
                                case "plantation":
                                  AppRoute.goToNextPage(
                                      context: context,
                                      screen: SelectTreeTypeScreen.route,
                                      arguments: {
                                        "serviceType": summary.serviceType,
                                        "projectAreaId":widget.projectAreaId
                                      },
                                    );
                                case "maintenance":
                                  AppRoute.goToNextPage(context: context, screen:  TreeMaintenanceListScreen.route, arguments: {});
                                case "monitoring":
                                  AppRoute.goToNextPage(context: context, screen:  TreeMonitorListScreen.route, arguments: {});
                                default:
                                  // AppRoute.goToNextPage(context: context, screen:  , arguments: {});
                              }
                            },
                          );
                        },
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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00695C), Color(0xFF004D40)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20), // soft curve bottom
        ),
      ),
      child: SafeArea(
        top: true,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 35, // centers vertically
          children: [

            GestureDetector(
              onTap: () => AppRoute.pop(context),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),

            SizedBox(width: 10.w), // ✅ space between back & text

            // 📍 Title + Location column
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // ✅ aligns within column
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? "Area Name",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: Colors.white70, size: 18),
                    SizedBox(width: 4.w),
                    Text(
                      subTitle ?? "Unknown location",
                      style:
                      const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
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



/*

class ProjectActionScreen extends StatelessWidget {
  static const route = '/ProjectActionScreen';

  final List<_ActionItem> actions = const [
    _ActionItem(
      title: 'Plantation',
      icon: Icons.spa,
      color: Color(0xFFC8E6C9), // Colors.green.shade100
      badge: 5,
    ),
    _ActionItem(
      title: 'Geo-tagging',
      icon: Icons.location_on,
      color: Color(0xFFFFCDD2), // Colors.red.shade100
      badge: 5,
    ),
    _ActionItem(
      title: 'Monitoring',
      icon: Icons.search,
      color: Color(0xFFE1BEE7), // Colors.purple.shade100
      badge: 5,
    ),
    _ActionItem(
      title: 'Maintenance',
      icon: Icons.water_drop,
      color: Color(0xFFBBDEFB), // Colors.blue.shade100
      badge: 5,
    ),
  ];

  const ProjectActionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.only(top: 16.h),
                itemCount: actions.length,
                separatorBuilder: (_, __) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  final item = actions[index];
                  return _ActionCard(
                    title: item.title,
                    icon: item.icon,
                    badgeCount: item.badge,
                    bgColor: item.color,
                    onTap: () {
                      // Navigate or handle tap
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 180.h,
          width: double.infinity,
          color: const Color(0xFF005247),
          padding: EdgeInsets.only(top: 20.h, left: 16.w, right: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              SizedBox(height: 16.h),
              const Text(
                'Thane Plantation Metro Drive 2023',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4.h),
              const Row(
                children: [
                  Icon(Icons.location_on, color: Colors.white70, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Thane, Mumbai',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 30.h,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
          ),
        ),
      ],
    );
  }
}

*/