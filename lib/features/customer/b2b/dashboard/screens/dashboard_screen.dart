import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:treelove/common/bloc/api_event.dart';
import 'package:treelove/core/config/themes/app_color.dart';
import 'package:treelove/core/config/themes/app_fonts.dart';
import 'package:treelove/core/network/api_connection.dart';
import 'package:treelove/features/customer/b2b/dashboard/bloc/dashboard_bloc.dart';
import 'package:treelove/features/fieldworker/home/screens/dashboard_screen.dart';

import '../../../../../common/bloc/api_state.dart';
import '../../../../../common/models/response.mode.dart';
import '../../../../../common/repositories/dashboard_repository.dart';
import '../../../../../core/config/resource/images.dart';
import '../../../../../core/config/route/app_route.dart';
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
      backgroundColor: AppColor.scaffoldBackground,
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
                      expandedHeight: 75,
                      floating: false,
                      pinned: true,
                      automaticallyImplyLeading: false,
                      // This removes the back button
                      backgroundColor: Colors.transparent,
                      title: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Hello,Arman',
                              style: AppFonts.title.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),

                            ),
                            // Profile Avatar
                            CircleAvatar(
                              backgroundColor: AppColor.white.withOpacity(0.2),
                              child: const Icon(
                                  Icons.person, color: AppColor.white),
                            ),
                          ],
                        ),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        // The background is kept here, but the title is now in the SliverAppBar itself
                        background: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColor.primary,
                                AppColor.primaryLight,
                                AppColor.secondary.withOpacity(0.8),
                              ],
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 20,
                                right: -20,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: AppColor.white.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -30,
                                left: -30,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: AppColor.secondary.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: null, // The actions property is no longer needed
                    ),

                    // Content
                    SliverPadding(
                      padding: const EdgeInsets.all(20.0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Investment Overview
                          mapOverView(),
                          /*
                          _buildInvestmentOverview(
                              investment: dashboard.data.projectOverview
                                  .totalInvestment.toString()),

                           */
                          const SizedBox(height: 28),

                          // Project Stats
                          _buildProjectStats(
                              totalProject: dashboard.data.projectOverview
                                  .totalProjects.toString(),
                              ongoingProject: dashboard.data.projectOverview
                                  .ongoingProjects.toString(),
                              upcomingProject: dashboard.data.projectOverview
                                  .upcomingProjects.toString(),
                              completedProject: dashboard.data.projectOverview
                                  .completedProjects.toString()
                          ),
                          const SizedBox(height: 28),

                          // Activity Summary
                          _buildActivitySection(
                            today: dashboard.data.todayActivity.toJson(),
                            week: dashboard.data.weeklySummary.toJson(),
                          ),
                          const SizedBox(height: 28),

                          // Service Progress
                          _buildServiceProgress(
                              plantation: dashboard.data.progressByService
                                  .plantation!,
                              maintenance: dashboard.data.progressByService
                                  .maintenance!,
                              monitor: dashboard.data.progressByService
                                  .monitoring!
                          ),
                          const SizedBox(height: 20),
                        ]),
                      ),
                    ),
                  ],
                ),
              );
            } else
            if (state is ApiFailure<DashboardResponseModel, ResponseModel>) {
              return Center(child: Text(state.error.message.toString()));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  /*
  Widget _buildInvestmentOverview({required String investment}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.primary,
            AppColor.primaryLight,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
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
                  color: AppColor.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: AppColor.white,
                  size: 24,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColor.secondary.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Active Investment',
                  style: TextStyle(
                    color: AppColor.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Total Investment',
            style: TextStyle(
              color: AppColor.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            investment,
            style: TextStyle(
              color: AppColor.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: AppColor.black.withOpacity(0.2),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: AppColor.secondaryLight,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                'Growing your green impact',
                style: TextStyle(
                  color: AppColor.white.withOpacity(0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

   */

  Widget mapOverView(){
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
                icon: const Icon(Icons.fullscreen,
                    color: Colors.white, size: 20),
                onPressed: () {
                  AppRoute.goToNextPage(
                    context: context,
                    screen: B2bMapScreen.route,
                    arguments: {
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectStats(
      {required String totalProject, required String ongoingProject, required String completedProject, required String upcomingProject}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project Overview',
          style: AppFonts.title.copyWith(
            fontSize: 24,
            color: AppColor.primary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColor.cardBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColor.primary.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildProjectStatCard(
                      'Total Projects',
                      totalProject,
                      Icons.folder_open,
                      AppColor.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildProjectStatCard(
                      'Ongoing',
                      ongoingProject,
                      Icons.play_circle_outline,
                      AppColor.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildProjectStatCard(
                      'Completed',
                      completedProject,
                      Icons.check_circle_outline,
                      AppColor.secondaryDark,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildProjectStatCard(
                      'Upcoming',
                      upcomingProject,
                      Icons.schedule,
                      AppColor.primaryLight,
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

  Widget _buildProjectStatCard(String title, String value, IconData icon,
      Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          /*
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),

           */
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppColor.black.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActivitySection(
      {required Map<String, dynamic> today, required Map<String,
          dynamic> week}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity Summary',
          style: AppFonts.title.copyWith(
            fontSize: 24,
            color: AppColor.primary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActivityCard('Today', today),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActivityCard('This Week', week),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActivityCard(String period, Map<String, dynamic> activities) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(16),
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
          Text(
            period,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColor.primary,
            ),
          ),
          const SizedBox(height: 16),
          _buildActivityItem('Planted', activities['trees_planted']!, Icons.eco,
              AppColor.secondary),
          const SizedBox(height: 12),
          _buildActivityItem('Maintained', activities['trees_maintained']!,
              Icons.build, AppColor.primaryLight),
          const SizedBox(height: 12),
          _buildActivityItem('Monitored', activities['trees_monitored']!,
              Icons.visibility, AppColor.secondaryDark),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String type, int count, IconData icon,
      Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            type,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColor.black,
            ),
          ),
        ),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceProgress(
      {required ProgressByService plantation, required ProgressByService maintenance, required ProgressByService monitor}) {
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
            fontSize: 24,
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

  Widget _buildServiceProgressCard(String serviceName,
      int totalTrees,
      int completedTrees,
      int completionPercent,
      IconData icon,
      Color color,) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border(
            left: BorderSide(
              color: color,
              width: 4,
            )),
        // border: Border.left(
        //   color: color,
        //   width: 4,
        // ),
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
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor.black,
                      ),
                    ),
                    Text(
                      '$completedTrees of $totalTrees trees',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColor.black.withOpacity(0.6),
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
          /*
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: completionPercent / 100,
              backgroundColor: AppColor.black.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),

           */
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColor.primary, AppColor.primaryLight],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.eco,
                color: Colors.white,
                size: 28,
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Project Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'TreeLov Initiative',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.notifications,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
