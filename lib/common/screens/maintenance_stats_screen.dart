import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../bloc/maintenance_dashboard_bloc.dart';
import '../models/maintenance_dashboard_model.dart';
import '../repositories/maintenance_dashboard_repository.dart';
import '../../core/network/api_connection.dart';
import '../../core/network/base_network.dart';
import '../../core/config/themes/app_color.dart';

class MaintenanceStatsScreen extends StatefulWidget {
  static const route = '/maintenance-stats-screen';

  final String projectId;
  final String? projectAreaId;
  final String? projectName;

  const MaintenanceStatsScreen({
    super.key,
    required this.projectId,
    this.projectAreaId,
    this.projectName,
  });

  @override
  State<MaintenanceStatsScreen> createState() => _MaintenanceStatsScreenState();
}

class _MaintenanceStatsScreenState extends State<MaintenanceStatsScreen> {
  late final MaintenanceDashboardBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = MaintenanceDashboardBloc(
        MaintenanceDashboardRepository(api: ApiConnection()));
    _bloc.add(FetchMaintenanceDashboard(
      projectId: widget.projectId,
      projectAreaId: widget.projectAreaId,
    ));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  Future<void> _refresh() async {
    _bloc.add(FetchMaintenanceDashboard(
      projectId: widget.projectId,
      projectAreaId: widget.projectAreaId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: AppColor.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: AppColor.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Maintenance Stats',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700)),
              if (widget.projectName != null)
                Text(widget.projectName!,
                    style: TextStyle(fontSize: 11.sp, color: Colors.white70)),
            ],
          ),
        ),
        body: BlocBuilder<MaintenanceDashboardBloc, MaintenanceDashboardState>(
          builder: (context, state) {
            if (state is MaintenanceDashboardLoading) {
              return _buildLoadingSkeleton();
            } else if (state is MaintenanceDashboardSuccess) {
              final data = state.data.data;
              if (data == null) {
                return const Center(child: Text('No data available'));
              }
              return RefreshIndicator(
                onRefresh: _refresh,
                color: AppColor.primary,
                child: _buildContent(data),
              );
            } else if (state is MaintenanceDashboardFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.grey.shade400),
                    SizedBox(height: 12.h),
                    Text(state.message,
                        style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: _refresh,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primary),
                      child:
                          const Text('Retry', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildContent(MaintenanceDashboardData data) {
    final isProjectMode = data.mode == 'project';

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(bottom: 24.h),
      children: [
        // KPI Banner
        if (isProjectMode && data.projectKpis != null)
          _buildProjectKpiBanner(data.projectKpis!),
        if (!isProjectMode && data.areaKpis != null)
          _buildAreaKpiBanner(data.areaKpis!, data.areaInfo),

        // Quick Stats Row
        if (isProjectMode && data.projectKpis != null)
          _buildQuickStats(data.projectKpis!),
        if (!isProjectMode && data.areaKpis != null)
          _buildAreaQuickStats(data.areaKpis!),

        // Activity Breakdown
        if (data.activityStats.isNotEmpty)
          _buildActivityBreakdown(data.activityStats),

        // Service Progress (area mode)
        if (!isProjectMode && data.services.isNotEmpty)
          _buildServicesList(data.services),

        // Area-wise Summary (project mode)
        if (isProjectMode && data.areaWiseSummary.isNotEmpty)
          _buildAreaWiseSummary(data.areaWiseSummary),

        // Team
        if (data.team != null && data.team!.fieldworkers.isNotEmpty)
          _buildTeamSection(data.team!),

        // Recent Activity
        if (data.recentActivity.isNotEmpty)
          _buildRecentActivitySection(data.recentActivity),
      ],
    );
  }

  // ─── KPI Banner (Project Mode) ─────────────────────────────────────────────

  Widget _buildProjectKpiBanner(MaintProjectKpis kpis) {
    final pct = kpis.overallProgressPct.clamp(0.0, 100.0);

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.primary, AppColor.secondaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withOpacity(0.3),
            blurRadius: 14,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: const Icon(Icons.build_rounded, color: Colors.white, size: 20),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text('Maintenance Overview',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600)),
              ),
              _HealthBadge(score: kpis.avgHealthScore),
            ],
          ),
          SizedBox(height: 16.h),
          // Progress
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Overall Progress',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 11.sp)),
                    SizedBox(height: 6.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: pct / 100,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Text('${pct.toStringAsFixed(0)}%',
                  style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white)),
            ],
          ),
          SizedBox(height: 14.h),
          // Trees
          Row(
            children: [
              _KpiBubble(
                label: 'Targeted',
                value: _formatCount(kpis.totalTreesTargeted),
                icon: Icons.forest_rounded,
              ),
              SizedBox(width: 8.w),
              _KpiBubble(
                label: 'Maintained',
                value: _formatCount(kpis.totalTreesMaintained),
                icon: Icons.eco_rounded,
              ),
              SizedBox(width: 8.w),
              _KpiBubble(
                label: 'Services',
                value: '${kpis.totalServices}',
                icon: Icons.miscellaneous_services_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── KPI Banner (Area Mode) ────────────────────────────────────────────────

  Widget _buildAreaKpiBanner(MaintAreaKpis kpis, MaintAreaInfo? areaInfo) {
    final pct = kpis.progressPct.clamp(0.0, 100.0);

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.secondaryDark, AppColor.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.secondaryDark.withOpacity(0.25),
            blurRadius: 14,
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
                child: const Icon(Icons.map_rounded, color: Colors.white, size: 20),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(areaInfo?.areaName ?? 'Area',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600)),
                    if (areaInfo?.locationDescription.isNotEmpty == true)
                      Text(areaInfo!.locationDescription,
                          style: TextStyle(
                              color: Colors.white70, fontSize: 10.sp)),
                  ],
                ),
              ),
              _HealthBadge(score: kpis.avgHealthScore),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Area Progress',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 11.sp)),
                    SizedBox(height: 6.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: pct / 100,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Text('${pct.toStringAsFixed(0)}%',
                  style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white)),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              _KpiBubble(
                label: 'Targeted',
                value: _formatCount(kpis.totalTreesTargeted),
                icon: Icons.forest_rounded,
              ),
              SizedBox(width: 8.w),
              _KpiBubble(
                label: 'Maintained',
                value: _formatCount(kpis.totalTreesMaintained),
                icon: Icons.eco_rounded,
              ),
              SizedBox(width: 8.w),
              _KpiBubble(
                label: 'Services',
                value: '${kpis.totalServices}',
                icon: Icons.miscellaneous_services_rounded,
              ),
            ],
          ),
          if (kpis.isOverdue) ...[
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Colors.white, size: 14),
                  SizedBox(width: 6.w),
                  Text('Overdue — Next: ${kpis.nextScheduledDate}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─── Quick Stats ───────────────────────────────────────────────────────────

  Widget _buildQuickStats(MaintProjectKpis kpis) {
    final items = [
      {
        'icon': Icons.warning_amber_rounded,
        'label': 'Overdue',
        'value': '${kpis.overdueServices}',
        'color': AppColor.error
      },
      {
        'icon': Icons.event_note_rounded,
        'label': 'Upcoming',
        'value': '${kpis.upcomingIn30Days}',
        'color': AppColor.warning
      },
      {
        'icon': Icons.trending_up_rounded,
        'label': 'Growth',
        'value': '${kpis.maintenanceGrowthRate.toStringAsFixed(0)}%',
        'color': AppColor.success
      },
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      child: Row(
        children: items.map((item) {
          final color = item['color'] as Color;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(
                  right: item != items.last ? 8.w : 0),
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(item['icon'] as IconData, color: color, size: 16),
                  ),
                  SizedBox(height: 6.h),
                  Text(item['value'] as String,
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87)),
                  Text(item['label'] as String,
                      style: TextStyle(
                          fontSize: 10.sp, color: Colors.grey.shade600),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAreaQuickStats(MaintAreaKpis kpis) {
    final items = [
      {
        'icon': Icons.warning_amber_rounded,
        'label': 'Overdue',
        'value': '${kpis.overdueServices}',
        'color': AppColor.error
      },
      {
        'icon': Icons.health_and_safety_rounded,
        'label': 'Health',
        'value': '${kpis.avgHealthScore.toStringAsFixed(0)}',
        'color': AppColor.success
      },
      {
        'icon': Icons.schedule_rounded,
        'label': 'Next Date',
        'value': kpis.nextScheduledDate.isNotEmpty
            ? kpis.nextScheduledDate.substring(5)
            : '—',
        'color': AppColor.primary
      },
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      child: Row(
        children: items.map((item) {
          final color = item['color'] as Color;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(
                  right: item != items.last ? 8.w : 0),
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.w),
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
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87)),
                  Text(item['label'] as String,
                      style: TextStyle(
                          fontSize: 10.sp, color: Colors.grey.shade600),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── Activity Breakdown ────────────────────────────────────────────────────

  Widget _buildActivityBreakdown(List<MaintActivityStat> stats) {
    final activityIcons = {
      'watering': Icons.water_drop_rounded,
      'fertilizer': Icons.science_rounded,
      'pruning': Icons.content_cut_rounded,
      'weeding': Icons.grass_rounded,
    };
    final activityColors = {
      'watering': AppColor.skyBlue,
      'fertilizer': AppColor.warning,
      'pruning': AppColor.primaryDark,
      'weeding': AppColor.success,
    };

    return _SectionContainer(
      title: 'Activity Breakdown',
      icon: Icons.pie_chart_outline_rounded,
      child: Column(
        children: stats.map((stat) {
          final key = stat.activityName.toLowerCase();
          final color = activityColors[key] ?? const Color(0xFF78909C);
          final icon =
              activityIcons[key] ?? Icons.miscellaneous_services_rounded;

          return Container(
            margin: EdgeInsets.only(bottom: 8.h),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: color.withOpacity(0.06),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: color.withOpacity(0.12)),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(icon, color: color, size: 16),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(stat.activityName,
                          style: TextStyle(
                              fontSize: 13.sp, fontWeight: FontWeight.w600)),
                      Text(
                          '${stat.totalTrees} trees · ${stat.maintenanceCount} records',
                          style: TextStyle(
                              fontSize: 10.5.sp, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${stat.singleTrees}',
                        style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: color)),
                    Text('single',
                        style: TextStyle(
                            fontSize: 9.sp, color: Colors.grey.shade500)),
                  ],
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${stat.bulkTrees}',
                        style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: color)),
                    Text('bulk',
                        style: TextStyle(
                            fontSize: 9.sp, color: Colors.grey.shade500)),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── Services (Area mode) ──────────────────────────────────────────────────

  Widget _buildServicesList(List<MaintService> services) {
    return _SectionContainer(
      title: 'Species Services',
      icon: Icons.local_florist_rounded,
      child: Column(
        children: services.map((s) {
          final pct =
              s.numTrees > 0 ? (s.treesMaintained / s.numTrees).clamp(0.0, 1.0) : 0.0;
          return Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.speciesName,
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700)),
                          Text(s.scientificName,
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey)),
                        ],
                      ),
                    ),
                    if (s.isOverdue)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text('OVERDUE',
                            style: TextStyle(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.red.shade700)),
                      ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    _MiniStat(label: 'Trees', value: '${s.numTrees}'),
                    _MiniStat(label: 'Done', value: '${s.treesMaintained}'),
                    _MiniStat(
                        label: 'Health',
                        value: '${s.avgHealth.toStringAsFixed(0)}'),
                    _MiniStat(label: 'FW', value: '${s.assignedFieldworkers}'),
                  ],
                ),
                SizedBox(height: 8.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: pct,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        pct > 0.5 ? AppColor.success : AppColor.warning),
                    minHeight: 5,
                  ),
                ),
                SizedBox(height: 6.h),
                Wrap(
                  spacing: 6.w,
                  children: s.topActivities
                      .map((a) => _TagChip(label: a))
                      .toList(),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── Area-wise Summary (Project mode) ──────────────────────────────────────

  Widget _buildAreaWiseSummary(List<MaintAreaWiseSummary> areas) {
    return _SectionContainer(
      title: 'Area Breakdown',
      icon: Icons.map_outlined,
      child: Column(
        children: areas.map((area) {
          final pct = area.totalTreesTargeted > 0
              ? (area.totalTreesMaintained / area.totalTreesTargeted)
                  .clamp(0.0, 1.0)
              : 0.0;

          return Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: area.isOverdue
                  ? Colors.red.shade50.withOpacity(0.5)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: area.isOverdue
                    ? Colors.red.shade100
                    : Colors.grey.shade100,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: AppColor.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: const Icon(Icons.location_on_rounded,
                          color: AppColor.primary, size: 16),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(area.areaName,
                          style: TextStyle(
                              fontSize: 13.sp, fontWeight: FontWeight.w700)),
                    ),
                    if (area.isOverdue)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.warning_amber_rounded,
                                size: 10, color: Colors.red.shade700),
                            SizedBox(width: 3.w),
                            Text('Overdue',
                                style: TextStyle(
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red.shade700)),
                          ],
                        ),
                      ),
                    _HealthBadge(score: area.avgHealthScore, compact: true),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    _MiniStat(
                        label: 'Targeted',
                        value: _formatCount(area.totalTreesTargeted)),
                    _MiniStat(
                        label: 'Done',
                        value: _formatCount(area.totalTreesMaintained)),
                    _MiniStat(
                        label: 'Services', value: '${area.totalServices}'),
                    _MiniStat(
                        label: 'Progress',
                        value: '${area.progressPct.toStringAsFixed(0)}%'),
                  ],
                ),
                SizedBox(height: 8.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: pct,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        area.isOverdue
                            ? AppColor.error
                            : AppColor.success),
                    minHeight: 5,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── Team Section ──────────────────────────────────────────────────────────

  Widget _buildTeamSection(MaintTeam team) {
    return _SectionContainer(
      title: 'Assigned Team (${team.fieldworkers.length})',
      icon: Icons.groups_rounded,
      child: Wrap(
        spacing: 10.w,
        runSpacing: 10.h,
        children: team.fieldworkers.map((fw) {
          final hasPhoto = fw.profilePicture != null &&
              fw.profilePicture!.isNotEmpty;

          return Container(
            width: (MediaQuery.of(context).size.width - 64.w) / 2,
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16.r,
                  backgroundColor:
                      AppColor.primary.withOpacity(0.15),
                  child: hasPhoto
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl:
                                '${BaseNetwork.BASE_Image_URL}${fw.profilePicture}',
                            width: 32.r,
                            height: 32.r,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Text(
                              fw.name.isNotEmpty
                                  ? fw.name[0].toUpperCase()
                                  : '?',
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.primary),
                            ),
                          ),
                        )
                      : Text(
                          fw.name.isNotEmpty
                              ? fw.name[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColor.primary),
                        ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fw.name,
                          style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      Text(fw.email,
                          style: TextStyle(
                              fontSize: 9.sp, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
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

  // ─── Recent Activity ───────────────────────────────────────────────────────

  Widget _buildRecentActivitySection(List<MaintRecentActivity> activities) {
    // Show max 5 items
    final displayItems = activities.take(5).toList();

    return _SectionContainer(
      title: 'Recent Activity',
      icon: Icons.history_rounded,
      child: Column(
        children: displayItems.asMap().entries.map((entry) {
          final a = entry.value;
          final isLast = entry.key == displayItems.length - 1;

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline dot & line
                SizedBox(
                  width: 24.w,
                  child: Column(
                    children: [
                      Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(
                          color: _healthColor(a.avgHealth),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _healthColor(a.avgHealth).withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 1.5,
                            color: Colors.grey.shade200,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                // Content
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: isLast ? 0 : 12.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(a.speciesName,
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600)),
                            const Spacer(),
                            Text(a.maintenanceDate,
                                style: TextStyle(
                                    fontSize: 10.sp, color: Colors.grey)),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(Icons.person_outline_rounded,
                                size: 12, color: Colors.grey.shade500),
                            SizedBox(width: 4.w),
                            Text(a.performedBy?.name ?? '—',
                                style: TextStyle(
                                    fontSize: 10.5.sp, color: Colors.grey.shade600)),
                            const Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: _healthColor(a.avgHealth)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                '${a.treesCovered} trees · ${a.avgHealth}',
                                style: TextStyle(
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w600,
                                    color: _healthColor(a.avgHealth)),
                              ),
                            ),
                          ],
                        ),
                        if (a.activities.isNotEmpty) ...[
                          SizedBox(height: 4.h),
                          Wrap(
                            spacing: 6.w,
                            children: a.activities
                                .map((act) => _TagChip(
                                    label:
                                        '${act.activityName} (${act.treesCovered})'))
                                .toList(),
                          ),
                        ],
                        if (a.areaName != null && a.areaName!.isNotEmpty) ...[
                          SizedBox(height: 3.h),
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined,
                                  size: 10, color: Colors.grey.shade400),
                              SizedBox(width: 3.w),
                              Text(a.areaName!,
                                  style: TextStyle(
                                      fontSize: 9.sp,
                                      color: Colors.grey.shade500)),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── Loading ───────────────────────────────────────────────────────────────

  Widget _buildLoadingSkeleton() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: List.generate(
          5,
          (i) => Container(
            margin: EdgeInsets.only(bottom: 12.h),
            height: i == 0 ? 150.h : 80.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  String _formatCount(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)}K';
    return n.toString();
  }

  Color _healthColor(String health) {
    switch (health.toLowerCase()) {
      case 'healthy':
        return AppColor.success;
      case 'moderate':
        return AppColor.warning;
      case 'unhealthy':
      case 'critical':
        return AppColor.error;
      default:
        return const Color(0xFF78909C);
    }
  }
}

// ─── Reusable Sub-Widgets ────────────────────────────────────────────────────

class _SectionContainer extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionContainer({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: AppColor.primary),
                SizedBox(width: 6.w),
                Text(title,
                    style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87)),
              ],
            ),
            SizedBox(height: 12.h),
            child,
          ],
        ),
      ),
    );
  }
}

class _KpiBubble extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _KpiBubble(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white70, size: 14),
            SizedBox(height: 4.h),
            Text(value,
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white)),
            Text(label,
                style: TextStyle(
                    fontSize: 9.sp, color: Colors.white.withOpacity(0.7)),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _HealthBadge extends StatelessWidget {
  final double score;
  final bool compact;

  const _HealthBadge({required this.score, this.compact = false});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    if (score >= 70) {
      color = AppColor.success;
      label = compact ? '${score.toStringAsFixed(0)}' : 'Health: ${score.toStringAsFixed(0)}';
    } else if (score >= 40) {
      color = AppColor.warning;
      label = compact ? '${score.toStringAsFixed(0)}' : 'Health: ${score.toStringAsFixed(0)}';
    } else {
      color = AppColor.error;
      label = compact ? '${score.toStringAsFixed(0)}' : 'Health: ${score.toStringAsFixed(0)}';
    }

    return Container(
      margin: compact ? EdgeInsets.only(left: 6.w) : EdgeInsets.zero,
      padding: EdgeInsets.symmetric(
          horizontal: compact ? 6.w : 8.w, vertical: compact ? 2.h : 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!compact) ...[
            Icon(Icons.favorite_rounded, color: color, size: 12),
            SizedBox(width: 4.w),
          ],
          Text(label,
              style: TextStyle(
                  fontSize: compact ? 9.sp : 10.sp,
                  fontWeight: FontWeight.w700,
                  color: color)),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87)),
          Text(label,
              style: TextStyle(fontSize: 9.sp, color: Colors.grey.shade600),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;

  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColor.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w500,
              color: AppColor.primary)),
    );
  }
}
