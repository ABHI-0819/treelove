import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treelove/common/bloc/api_event.dart';
import 'package:treelove/common/screens/notification_screen.dart';
import 'package:treelove/core/config/themes/app_color.dart';
import 'package:treelove/core/config/themes/app_fonts.dart';
import 'package:treelove/core/network/api_connection.dart';
import 'package:treelove/features/customer/b2b/dashboard/bloc/dashboard_bloc.dart';

import '../../../../../common/bloc/api_state.dart';
import '../../../../../common/models/response.mode.dart';
import '../../../../../common/repositories/dashboard_repository.dart';
import '../../../../../core/config/route/app_route.dart';
import '../../../../../core/storage/preference_keys.dart';
import '../../../../../core/storage/secure_storage.dart';
import '../../map/screens/b2b_map_screen.dart';
import '../model/dashboard_response_model.dart';

class ClientDashboardScreen extends StatefulWidget {
  const ClientDashboardScreen({super.key});

  @override
  State<ClientDashboardScreen> createState() => _ClientDashboardScreenState();
}

class _ClientDashboardScreenState extends State<ClientDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  late B2BDashboardBloc dashboardBloc;

  final pref = SecurePreference();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();

    dashboardBloc = B2BDashboardBloc(
      DashboardRepository(api: ApiConnection()),
    );
    dashboardBloc.add(ApiFetch());
  }

  @override
  void dispose() {
    _animationController.dispose();
    dashboardBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: BlocProvider<B2BDashboardBloc>(
        create: (context) => dashboardBloc,
        child: BlocBuilder<B2BDashboardBloc,
            ApiState<DashboardResponseModel, ResponseModel>>(
          builder: (context, state) {
            if (state is ApiLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state
                is ApiSuccess<DashboardResponseModel, ResponseModel>) {
              final DashboardResponseModel dashboard = state.data;
              return FadeTransition(
                opacity: _fadeAnimation,
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 60.h,
                      pinned: true,
                      floating: false,
                      automaticallyImplyLeading: false,
                      backgroundColor: AppColor.primary.withValues(alpha: 0.60),
                      elevation: 0,
                      title: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 8.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /// 👋 Greeting Section
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                5.0.verticalSpace,
                                Text(
                                  "Hello 👋",
                                  style: AppFonts.caption.copyWith(
                                    color: AppColor.white.withOpacity(0.85),
                                  ),
                                ),
                                FutureBuilder<String?>(
                                  future: pref.getString(Keys.name),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final name =
                                          snapshot.data ?? 'Field Worker';
                                      return Text(
                                        name,
                                        style: AppFonts.title.copyWith(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          color: AppColor.white,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ],
                            ),

                            /// 🔔 Notification Button
                            InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: () {
                                AppRoute.goToNextPage(
                                  context: context,
                                  screen: NotificationsScreen.route,
                                  arguments: {},
                                );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.18),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.notifications_none_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),

                                  /// Notification Dot
                                  Positioned(
                                    right: 2,
                                    top: 2,
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 1.5),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                         
                          ],
                        ),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColor.primary,
                                AppColor.primaryLight,
                                AppColor.secondary.withOpacity(0.85),
                              ],
                            ),
                          ),

                          /// Decorative shapes
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(20.0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Investment Overview
                          mapOverView(),
                          const SizedBox(height: 28),
                          // Project Stats
                          _buildProjectStats(
                              totalProject: dashboard
                                  .data.projectOverview.totalProjects
                                  .toString(),
                              ongoingProject: dashboard
                                  .data.projectOverview.ongoingProjects
                                  .toString(),
                              upcomingProject: dashboard
                                  .data.projectOverview.upcomingProjects
                                  .toString(),
                              completedProject: dashboard
                                  .data.projectOverview.completedProjects
                                  .toString()),
                          const SizedBox(height: 28),

                          // Activity Summary
                          _buildActivitySection(
                            today: dashboard.data.todayActivity.toJson(),
                            week: dashboard.data.weeklySummary.toJson(),
                          ),
                          const SizedBox(height: 28),

                          // Service Progress
                          _buildServiceProgress(
                              plantation:
                                  dashboard.data.progressByService.plantation!,
                              maintenance:
                                  dashboard.data.progressByService.maintenance!,
                              monitor:
                                  dashboard.data.progressByService.monitoring!),
                          const SizedBox(height: 20),
                        ]),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state
                is ApiFailure<DashboardResponseModel, ResponseModel>) {
              return Center(child: Text(state.error.message.toString()));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  /*
  Widget mapOverView() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 180,
              child: FlutterMap(
                options: MapOptions(
                  // initialCenter:LatLng(polygonPoints.last.latitude, polygonPoints.first.longitude),
                  initialZoom: 12,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    tileProvider: NetworkTileProvider(
                      headers: {'User-Agent': 'TreelovApp/1.0'},
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon:
                    const Icon(Icons.fullscreen, color: Colors.white, size: 20),
                onPressed: () {
                  AppRoute.goToNextPage(
                    context: context,
                    screen: B2bMapScreen.route,
                    arguments: {},
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  */
  Widget mapOverView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            /// 🌍 Map
            SizedBox(
              height: 180.h,
              width: double.infinity,
              child: FlutterMap(
                options: MapOptions(
                  initialZoom: 12,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    tileProvider: NetworkTileProvider(
                      headers: {'User-Agent': 'TreelovApp/1.0'},
                    ),
                  ),
                ],
              ),
            ),

            /// 🌫️ Top gradient (better readability)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.25),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            /// 📍 Title
            Positioned(
              left: 12,
              top: 12,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Map Overview",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            /// 🔍 Fullscreen Button
            Positioned(
              right: 10,
              top: 10,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () {
                  AppRoute.goToNextPage(
                    context: context,
                    screen: B2bMapScreen.route,
                    arguments: {},
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.45),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.fullscreen,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectStats({
    required String totalProject,
    required String ongoingProject,
    required String completedProject,
    required String upcomingProject,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title
        Text(
          'Project Overview',
          style: AppFonts.title.copyWith(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: AppColor.primary,
          ),
        ),

        SizedBox(height: 16.h),

        /// Stats Container
        Container(
          // padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColor.cardBackground,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildProjectStatCard(
                      title: 'Total',
                      value: totalProject,
                      icon: Icons.folder_open,
                      color: AppColor.primary,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildProjectStatCard(
                      title: 'Ongoing',
                      value: ongoingProject,
                      icon: Icons.play_circle_outline,
                      color: AppColor.secondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: _buildProjectStatCard(
                      title: 'Completed',
                      value: completedProject,
                      icon: Icons.check_circle_outline,
                      color: AppColor.secondaryDark,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildProjectStatCard(
                      title: 'Upcoming',
                      value: upcomingProject,
                      icon: Icons.schedule,
                      color: AppColor.primaryLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProjectStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 34.h,
            width: 34.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 18.sp,
              color: color,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitySection({
    required Map<String, dynamic> today,
    required Map<String, dynamic> week,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity Summary',
          style: AppFonts.title.copyWith(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: AppColor.primary,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(child: _buildActivityCard('Today', today)),
            SizedBox(width: 10.w),
            Expanded(child: _buildActivityCard('Week', week)),
          ],
        ),
      ],
    );
  }

  Widget _buildActivityCard(String period, Map<String, dynamic> activities) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 14.w,
        vertical: 12.h,
      ), // smaller padding
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            period,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.primary,
            ),
          ),
          SizedBox(height: 8.h),
          _buildActivityItem(
            'Planted',
            activities['trees_planted'] ?? 0,
            Icons.eco,
            AppColor.secondary,
          ),
          SizedBox(height: 6.h),
          _buildActivityItem(
            'Maintained',
            activities['trees_maintained'] ?? 0,
            Icons.build,
            AppColor.primaryLight,
          ),
          SizedBox(height: 6.h),
          _buildActivityItem(
            'Monitored',
            activities['trees_monitored'] ?? 0,
            Icons.visibility,
            AppColor.secondaryDark,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    String type,
    int count,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          height: 26.h,
          width: 26.w,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Icon(
            icon,
            size: 14.sp,
            color: color,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            type,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColor.black,
            ),
          ),
        ),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceProgress(
      {required ProgressByService plantation,
      required ProgressByService maintenance,
      required ProgressByService monitor}) {
    final services = {
      'Plantation': {
        'total_trees': plantation.totalTrees,
        'completed_trees': plantation.completedTrees,
        'completion_percent': plantation.completionPercent,
        'icon': Icons.eco,
        'color': AppColor.secondary,
      },
      'Maintenance': {
        'total_trees': maintenance.totalTrees,
        'completed_trees': maintenance.completedTrees,
        'completion_percent': maintenance.completionPercent,
        'icon': Icons.build,
        'color': AppColor.primaryLight,
      },
      'Monitoring': {
        'total_trees': monitor.totalTrees,
        'completed_trees': monitor.completedTrees,
        'completion_percent': monitor.completionPercent,
        'icon': Icons.visibility,
        'color': AppColor.secondaryDark,
      },
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Service Progress',
          style: AppFonts.title.copyWith(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: AppColor.primary,
          ),
        ),
        const SizedBox(height: 16),
        ...services.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildServiceProgressCard(
              entry.key,
              entry.value['total_trees'] as int,
              entry.value['completed_trees'] as int,
              entry.value['completion_percent'] as int,
              entry.value['icon'] as IconData,
              entry.value['color'] as Color,
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildServiceProgressCard(
    String serviceName,
    int totalTrees,
    int completedTrees,
    int completionPercent,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border(
            left: BorderSide(
          color: color,
          width: 4,
        )),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      serviceName,
                      style: AppFonts.regular.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColor.primary,
                      ),
                    ),
                    Text(
                      '$completedTrees of $totalTrees trees',
                      style: AppFonts.caption.copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppColor.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$completionPercent%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
