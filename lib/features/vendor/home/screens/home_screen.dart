import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treelove/common/screens/notification_screen.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/features/vendor/home/bloc/project_bloc.dart';
import 'package:treelove/features/vendor/home/screens/project_detail_screen.dart';

import '../../../../common/bloc/api_event.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../common/repositories/project_repository.dart';
import '../../../../core/network/api_connection.dart';
import '../../../../core/storage/preference_keys.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/project_list_model.dart';
import '../models/vendor_dashboard_model.dart';

final preference = SecurePreference();

class HomeScreen extends StatefulWidget {
  static const route = '/vendor-home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final VendorDashboardBloc _dashboardBloc;
  late final ProjectListBloc _projectListBloc;

  @override
  void initState() {
    super.initState();
    _dashboardBloc =
        VendorDashboardBloc(ProjectRepository(api: ApiConnection()));
    _projectListBloc = ProjectListBloc(ProjectRepository(api: ApiConnection()));
    _dashboardBloc.add(ApiListFetch());
    _projectListBloc.add(ApiListFetch(filter: 'active'));
  }

  @override
  void dispose() {
    _dashboardBloc.close();
    _projectListBloc.close();
    super.dispose();
  }

  Future<void> _refreshData() async {
    _dashboardBloc.add(ApiListFetch());
    _projectListBloc.add(ApiListFetch(filter: 'active'));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _dashboardBloc),
        BlocProvider.value(value: _projectListBloc),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6F8),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          color: const Color(0xFF0B5E42),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // --- HEADER ---
              SliverToBoxAdapter(child: _buildHeader()),

              // --- DASHBOARD CONTENT ---
              BlocBuilder<VendorDashboardBloc,
                  ApiState<VendorDashboardModel, ResponseModel>>(
                builder: (context, state) {
                  if (state is ApiLoading) {
                    return SliverToBoxAdapter(child: _buildShimmer());
                  } else if (state
                      is ApiSuccess<VendorDashboardModel, ResponseModel>) {
                    final data = state.data.data;
                    if (data == null)
                      return const SliverToBoxAdapter(child: SizedBox());
                    return SliverList(
                      delegate: SliverChildListDelegate([
                        _buildProjectOverview(data.projectOverview),
                        _buildSummaryStats(data.summaryStats),
                        _buildTodayActivity(data.todayActivity),
                        _buildServiceProgress(data.progressByService),
                        _buildWeeklySummary(data.weeklySummary),
                        _buildLeaderboard(data.fieldworkerLeaderboard),
                        SizedBox(height: 8.h),
                      ]),
                    );
                  }
                  return const SliverToBoxAdapter(child: SizedBox());
                },
              ),

              // --- ONGOING PROJECTS ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 4.h),
                  child: Row(
                    children: [
                      const Icon(Icons.work_outline_rounded,
                          size: 18, color: Color(0xFF0B5E42)),
                      SizedBox(width: 6.w),
                      Text('Ongoing Projects',
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87)),
                    ],
                  ),
                ),
              ),
              BlocBuilder<ProjectListBloc,
                  ApiState<ProjectListResponse, ResponseModel>>(
                builder: (context, state) {
                  if (state is ApiLoading) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                    );
                  } else if (state
                      is ApiSuccess<ProjectListResponse, ResponseModel>) {
                    final projects = state.data.data;
                    if (projects.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.h),
                            child: Text('No ongoing projects',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14.sp)),
                          ),
                        ),
                      );
                    }
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            ProjectCard(projectItem: projects[index]),
                        childCount: projects.length,
                      ),
                    );
                  }
                  return const SliverToBoxAdapter(child: SizedBox());
                },
              ),
              SliverToBoxAdapter(child: SizedBox(height: 24.h)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF063D2B), Color(0xFF0B5E42)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<String?>(
                        future: preference.getString(Keys.name),
                        builder: (context, snap) {
                          final name = snap.data?.isNotEmpty == true
                              ? snap.data!
                              : 'Vendor';
                          return Text(
                            'Hi, $name 👋',
                            style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          );
                        },
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "Here's your dashboard overview",
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white.withOpacity(0.75)),
                      ),
                    ],
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () => AppRoute.goToNextPage(
                      context: context,
                      screen: NotificationsScreen.route,
                      arguments: {},
                    ),
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.notifications_none_rounded,
                              color: Colors.white, size: 24),
                        ),
                        Positioned(
                          right: 2,
                          top: 2,
                          child: Container(
                            width: 9,
                            height: 9,
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.white, width: 1.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectOverview(ProjectOverview? overview) {
    final total = overview?.totalProjects ?? 0;
    final ongoing = overview?.ongoingProjects ?? 0;
    final completed = overview?.completedProjects ?? 0;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0B5E42), Color(0xFF1A8C60)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0B5E42).withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: const Icon(Icons.folder_open_rounded,
                      color: Colors.white, size: 20),
                ),
                SizedBox(width: 10.w),
                Text('Project Overview',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600)),
                const Spacer(),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text('$total Total',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _OverviewCard(
                    icon: Icons.loop_rounded,
                    value: '$ongoing',
                    label: 'Ongoing',
                    iconBg: Colors.orangeAccent.withOpacity(0.2),
                    iconColor: Colors.orange.shade200,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _OverviewCard(
                    icon: Icons.check_circle_outline_rounded,
                    value: '$completed',
                    label: 'Completed',
                    iconBg: Colors.greenAccent.withOpacity(0.2),
                    iconColor: Colors.greenAccent.shade200,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStats(SummaryStats? stats) {
    final items = [
      {
        'icon': Icons.people_alt_outlined,
        'label': 'Fieldworkers',
        'value': '${stats?.totalFieldworkers ?? 0}',
        'color': const Color(0xFF5C6BC0)
      },
      {
        'icon': Icons.miscellaneous_services_outlined,
        'label': 'Services',
        'value': '${stats?.totalServices ?? 0}',
        'color': const Color(0xFF00897B)
      },
      {
        'icon': Icons.assignment_outlined,
        'label': 'Assignments',
        'value': '${stats?.totalAssignments ?? 0}',
        'color': const Color(0xFF0288D1)
      },
      {
        'icon': Icons.warning_amber_rounded,
        'label': 'Overdue',
        'value': '${stats?.overdueAssignments ?? 0}',
        'color': const Color(0xFFE53935)
      },
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      child: Row(
        children: items.asMap().entries.map((e) {
          final item = e.value;
          final color = item['color'] as Color;
          return Expanded(
            child: Container(
              margin:
                  EdgeInsets.only(right: e.key < items.length - 1 ? 8.w : 0),
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 6.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(7.w),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child:
                        Icon(item['icon'] as IconData, color: color, size: 16),
                  ),
                  SizedBox(height: 6.h),
                  Text(item['value'] as String,
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87)),
                  Text(item['label'] as String,
                      style: TextStyle(
                          fontSize: 9.5.sp, color: Colors.grey.shade600),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTodayActivity(TodayActivity? activity) {
    return _SectionCard(
      title: "Today's Activity",
      icon: Icons.today_rounded,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _ActivityTile(
                  icon: Icons.park_outlined,
                  label: 'Planted',
                  value: '${activity?.treesPlanted ?? 0}',
                  color: const Color(0xFF43A047),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _ActivityTile(
                  icon: Icons.build_circle_outlined,
                  label: 'Maintained',
                  value: '${activity?.treesMaintained ?? 0}',
                  color: const Color(0xFF1E88E5),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _ActivityTile(
                  icon: Icons.remove_red_eye_outlined,
                  label: 'Monitored',
                  value: '${activity?.treesMonitored ?? 0}',
                  color: const Color(0xFF8E24AA),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: _ActivityTile(
                  icon: Icons.group_outlined,
                  label: 'Active FW',
                  value: '${activity?.activeFieldworkers ?? 0}',
                  color: const Color(0xFFFF8F00),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _ActivityTile(
                  icon: Icons.task_alt_outlined,
                  label: 'Assignments',
                  value: '${activity?.activeAssignments ?? 0}',
                  color: const Color(0xFF00ACC1),
                ),
              ),
              SizedBox(width: 8.w),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceProgress(Map<String, ServiceProgress>? services) {
    if (services == null || services.isEmpty) return const SizedBox();

    final serviceColors = {
      'Plantation': const Color(0xFF43A047),
      'Maintenance': const Color(0xFF1E88E5),
      'Monitoring': const Color(0xFF8E24AA),
      'Satellite_Monitoring': const Color(0xFF00ACC1),
    };

    final serviceIcons = {
      'Plantation': Icons.park_rounded,
      'Maintenance': Icons.build_rounded,
      'Monitoring': Icons.remove_red_eye_rounded,
      'Satellite_Monitoring': Icons.satellite_alt_rounded,
    };

    return _SectionCard(
      title: 'Service Progress',
      icon: Icons.bar_chart_rounded,
      child: Column(
        children: services.entries.map((entry) {
          final name = entry.key;
          final s = entry.value;
          final displayName = name.replaceAll('_', ' ');
          final color = serviceColors[name] ?? const Color(0xFF78909C);
          final icon =
              serviceIcons[name] ?? Icons.miscellaneous_services_rounded;
          final pct = s.totalTrees > 0
              ? (s.completedTrees / s.totalTrees).clamp(0.0, 1.0)
              : 0.0;

          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(7.w),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(icon, color: color, size: 16),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(displayName,
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87)),
                          Text('${s.completedTrees}/${s.totalTrees}',
                              style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Colors.grey.shade600)),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.r),
                        child: LinearProgressIndicator(
                          value: pct,
                          backgroundColor: color.withOpacity(0.12),
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                          minHeight: 6,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                          '${s.totalAssignments} assignments · ${s.completionPercent.toStringAsFixed(0)}% complete',
                          style:
                              TextStyle(fontSize: 10.sp, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWeeklySummary(WeeklySummary? weekly) {
    final overdueCount = weekly?.overdueAssignments ?? 0;

    return _SectionCard(
      title: 'Weekly Summary',
      icon: Icons.calendar_view_week_rounded,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _WeeklyTile(
                  label: 'Planted',
                  value: '${weekly?.treesPlanted ?? 0}',
                  color: const Color(0xFF43A047),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _WeeklyTile(
                  label: 'Maintained',
                  value: '${weekly?.treesMaintained ?? 0}',
                  color: const Color(0xFF1E88E5),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _WeeklyTile(
                  label: 'Monitored',
                  value: '${weekly?.treesMonitored ?? 0}',
                  color: const Color(0xFF8E24AA),
                ),
              ),
            ],
          ),
          if (overdueCount > 0) ...[
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.red.shade100),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.red.shade400, size: 18),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                        '$overdueCount overdue assignments require attention',
                        style: TextStyle(
                            fontSize: 12.sp, color: Colors.red.shade700)),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildLeaderboard(List<FieldworkerLeader>? leaders) {
    if (leaders == null || leaders.isEmpty) return const SizedBox();

    return _SectionCard(
      title: 'Top Fieldworkers',
      icon: Icons.emoji_events_rounded,
      child: Column(
        children: leaders.asMap().entries.map((entry) {
          final rank = entry.key + 1;
          final fw = entry.value;
          final isTop = rank == 1;

          return Padding(
            padding: EdgeInsets.only(bottom: rank < leaders.length ? 10.h : 0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: isTop ? const Color(0xFFFFF8E1) : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: isTop ? Colors.amber.shade200 : Colors.grey.shade200,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      color:
                          isTop ? Colors.amber.shade400 : Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text('#$rank',
                          style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w800,
                              color:
                                  isTop ? Colors.white : Colors.grey.shade700)),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  CircleAvatar(
                    radius: 16.r,
                    backgroundColor: const Color(0xFF0B5E42).withOpacity(0.15),
                    child: Text(
                      (fw.fullName?.isNotEmpty == true)
                          ? fw.fullName![0].toUpperCase()
                          : '?',
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0B5E42)),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(fw.fullName ?? '—',
                            style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87)),
                        Text(fw.username ?? '',
                            style: TextStyle(
                                fontSize: 10.5.sp, color: Colors.grey)),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B5E42).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.park_rounded,
                            size: 12, color: const Color(0xFF0B5E42)),
                        SizedBox(width: 4.w),
                        Text('${fw.treesHandled}',
                            style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0B5E42))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildShimmer() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: List.generate(
          4,
          (i) => Container(
            margin: EdgeInsets.only(bottom: 12.h),
            height: i == 0 ? 120.h : 80.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Reusable Sub-widgets ────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: const Color(0xFF0B5E42)),
                SizedBox(width: 6.w),
                Text(title,
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87)),
              ],
            ),
            SizedBox(height: 14.h),
            child,
          ],
        ),
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color iconBg;
  final Color iconColor;

  const _OverviewCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.iconBg,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white)),
              Text(label,
                  style: TextStyle(
                      fontSize: 11.sp, color: Colors.white.withOpacity(0.8))),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ActivityTile(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87)),
          Text(label,
              style: TextStyle(fontSize: 9.5.sp, color: Colors.grey.shade600),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _WeeklyTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _WeeklyTile(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 18.sp, fontWeight: FontWeight.w800, color: color)),
          SizedBox(height: 3.h),
          Text(label,
              style: TextStyle(fontSize: 10.sp, color: Colors.grey.shade600),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// ─── Project Card (kept as-is) ───────────────────────────────────────────────

class ProjectCard extends StatelessWidget {
  final ProjectItem projectItem;
  const ProjectCard({required this.projectItem});

  static const Map<String, Color> serviceTagColors = {
    "Geo-tagging": Color(0xFFFCE8E8),
    "Maintenance": Color(0xFFE6F3FB),
    "Monitoring": Color(0xFFEAEAFD),
    "Plantation": Color(0xFFE8F8E8),
  };

  Color _getServiceColor(String service) =>
      serviceTagColors[service] ?? const Color(0xFFEDEDED);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () => AppRoute.goToNextPage(
            context: context,
            screen: ProjectDetailScreen.route,
            arguments: {'projectId': projectItem.id}),
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
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
                  CircleAvatar(
                    radius: 18.r,
                    backgroundColor: Colors.grey.shade100,
                    backgroundImage: NetworkImage(projectItem.image.toString()),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(projectItem.name,
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 13.sp),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        Text(projectItem.category,
                            style:
                                TextStyle(fontSize: 11.sp, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Divider(height: 1, color: Colors.grey.shade100),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 14, color: Colors.grey),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      projectItem.description.isNotEmpty
                          ? projectItem.description
                          : 'Unknown Location',
                      style: TextStyle(
                          fontSize: 12.sp, color: Colors.grey.shade700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.calendar_today_outlined,
                      size: 14, color: Colors.grey),
                  SizedBox(width: 4.w),
                  Text('${projectItem.endDate}',
                      style: TextStyle(
                          fontSize: 12.sp, color: Colors.grey.shade700)),
                ],
              ),
              SizedBox(height: 10.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 6.h,
                children: projectItem.serviceTypes
                    .map((s) => _ProjectTag(
                          text: s,
                          color: _getServiceColor(s),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectTag extends StatelessWidget {
  final String text;
  final Color color;
  const _ProjectTag({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(20.r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getIcon(text), size: 13, color: Colors.black54),
          SizedBox(width: 5.w),
          Text(text, style: TextStyle(fontSize: 11.sp, color: Colors.black87)),
        ],
      ),
    );
  }

  IconData _getIcon(String label) {
    switch (label.toLowerCase()) {
      case 'plantation':
        return Icons.local_florist;
      case 'geo-tagging':
        return Icons.place_outlined;
      case 'maintenance':
        return Icons.settings_suggest;
      case 'monitoring':
        return Icons.remove_red_eye_outlined;
      default:
        return Icons.label;
    }
  }
}
