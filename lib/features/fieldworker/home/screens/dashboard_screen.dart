import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treelove/core/config/route/app_route.dart';

import '../../../../common/bloc/api_event.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../common/repositories/dashboard_repository.dart';
import '../../../../common/screens/notification_screen.dart';
import '../../../../core/config/resource/service_ids.dart';
import '../../../../core/config/themes/app_color.dart';
import '../../../../core/config/themes/app_fonts.dart';
import '../../../../core/network/api_connection.dart';
import '../../../../core/storage/preference_keys.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/widgets/common_refresh_indicator.dart';
import '../bloc/fieldwork_dashboard_bloc.dart';
import '../models/fieldworker_dashboard_response_model.dart';

class DashboardScreen extends StatefulWidget {
  static const route = '/dashboard';
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final pref = SecurePreference();
  late FieldworkDashboardBloc dashboardBloc;
  late AnimationController _fadeCtrl;

  @override
  void initState() {
    super.initState();
    ServiceIds.load();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    dashboardBloc = FieldworkDashboardBloc(
      DashboardRepository(api: ApiConnection()),
    );
    dashboardBloc.add(ApiFetch());
    Future.delayed(const Duration(milliseconds: 80), _fadeCtrl.forward);
  }

  @override
  void dispose() {
    dashboardBloc.close();
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: BlocProvider(
        create: (_) => dashboardBloc,
        child: CommonRefreshIndicator(
          isLoading: dashboardBloc.state is ApiLoading,
          onRefresh: () {
            dashboardBloc.add(ApiFetch());
            return Future.delayed(const Duration(seconds: 1));
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(),
              BlocBuilder<FieldworkDashboardBloc,
                  ApiState<FieldworkerDashboardResponseModel, ResponseModel>>(
                builder: (context, state) {
                  if (state is ApiLoading) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColor.primary,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  } else if (state is ApiFailure<
                      FieldworkerDashboardResponseModel, ResponseModel>) {
                    return SliverFillRemaining(
                      child: _ErrorView(message: state.error.message),
                    );
                  } else if (state is ApiSuccess<
                      FieldworkerDashboardResponseModel, ResponseModel>) {
                    return _buildContent(state.data);
                  }
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── App Bar ──────────────────────────────────────────────────────────────

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: AppColor.cardBackground,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: Colors.black.withOpacity(0.06),
      toolbarHeight: 64.h,
      title: Row(
        children: [
          // Brand icon
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: AppColor.primary,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child:
                const Icon(Icons.eco_rounded, color: AppColor.white, size: 18),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Good morning 👋',
                style: TextStyle(fontSize: 11.sp, color: AppColor.textMuted),
              ),
              FutureBuilder<String?>(
                future: pref.getString(Keys.name),
                builder: (context, snap) => Text(
                  snap.data ?? 'Field Worker',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          // Notification button
          GestureDetector(
            onTap: () => AppRoute.goToNextPage(
                context: context,
                screen: NotificationsScreen.route,
                arguments: {}),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 38.w,
                  height: 38.w,
                  decoration: BoxDecoration(
                    color: AppColor.grey,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    color: AppColor.textSecondary,
                    size: 20,
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColor.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Content ──────────────────────────────────────────────────────────────

  Widget _buildContent(FieldworkerDashboardResponseModel data) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 40.h),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Center(
            child: Text(
              "↓ Pull down to refresh",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          _FadeSlide(
            ctrl: _fadeCtrl,
            delay: 0.00,
            child: _OverallSummaryCard(summary: data.overallSummary),
          ),
          SizedBox(height: 16.h),
          _FadeSlide(
            ctrl: _fadeCtrl,
            delay: 0.10,
            child: _ThisWeekCard(week: data.thisWeekTasks),
          ),
          SizedBox(height: 16.h),
          _FadeSlide(
            ctrl: _fadeCtrl,
            delay: 0.18,
            child: _TodayTasksHeader(count: data.todayTasks.length),
          ),
          SizedBox(height: 10.h),
          ...List.generate(
              data.todayTasks.length,
              (i) => _FadeSlide(
                    ctrl: _fadeCtrl,
                    delay: 0.22 + i * 0.06,
                    child: _TaskCard(task: data.todayTasks[i]),
                  )),
        ]),
      ),
    );
  }
}

// ─── OVERALL SUMMARY CARD ────────────────────────────────────────────────────

class _OverallSummaryCard extends StatelessWidget {
  final OverallSummary? summary;
  const _OverallSummaryCard({this.summary});

  @override
  Widget build(BuildContext context) {
    final assignments = summary?.totalAssignments ?? 0;
    final assigned = summary?.totalTreesAssigned ?? 0;
    final completed = summary?.totalTreesCompleted ?? 0;
    final pct =
        assigned > 0 ? (completed / assigned * 100).toStringAsFixed(0) : '0';

    return Container(
      decoration: _cardDecor,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              _CardIconBadge(
                  icon: Icons.bar_chart_rounded, color: AppColor.primary),
              SizedBox(width: 10.w),
              Text(
                'Overall Summary',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // Three stat chips — first one highlighted (dark), like the reference
          Row(
            children: [
              _StatChip(
                value: '$assignments',
                label: 'Assignments',
                icon: Icons.assignment_outlined,
                highlighted: true,
              ),
              SizedBox(width: 10.w),
              _StatChip(
                value: '$assigned',
                label: 'Trees Assigned',
                icon: Icons.park_outlined,
              ),
              SizedBox(width: 10.w),
              _StatChip(
                value: '$completed',
                label: 'Completed',
                icon: Icons.check_circle_outline_rounded,
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // Progress bar + percentage
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: assigned > 0 ? completed / assigned : 0,
                    backgroundColor: AppColor.border,
                    color: AppColor.primary,
                    minHeight: 6,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                '$pct%',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── THIS WEEK CARD ──────────────────────────────────────────────────────────

class _ThisWeekCard extends StatelessWidget {
  final ThisWeekTasks? week;
  const _ThisWeekCard({this.week});

  @override
  Widget build(BuildContext context) {
    final plantation = week?.plantation ?? 0;
    final maintenance = week?.maintenance ?? 0;
    final monitoring = week?.monitoring ?? 0;
    final total = plantation + maintenance + monitoring;

    final rows = [
      _WeekRowData(
          'Plantation', plantation, Icons.eco_outlined, AppColor.secondary),
      _WeekRowData(
          'Maintenance', maintenance, Icons.build_outlined, AppColor.accent),
      _WeekRowData('Monitoring', monitoring, Icons.visibility_outlined,
          AppColor.skyBlue),
    ];

    return Container(
      decoration: _cardDecor,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              _CardIconBadge(
                icon: Icons.calendar_month_outlined,
                color: AppColor.secondaryDark,
              ),
              SizedBox(width: 10.w),
              Text(
                'This Week',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '$total tasks',
                style: TextStyle(fontSize: 11.sp, color: AppColor.textMuted),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Rows
          ...rows.map((r) => _WeekItemRow(data: r, total: total)),
        ],
      ),
    );
  }
}

class _WeekRowData {
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  const _WeekRowData(this.label, this.value, this.icon, this.color);
}

class _WeekItemRow extends StatelessWidget {
  final _WeekRowData data;
  final int total;
  const _WeekItemRow({required this.data, required this.total});

  @override
  Widget build(BuildContext context) {
    final frac = total > 0 ? data.value / total : 0.0;
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(data.icon, color: data.color, size: 16),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(data.label,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColor.textPrimary,
                        )),
                    Text('${data.value}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: data.color,
                        )),
                  ],
                ),
                SizedBox(height: 5.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: frac,
                    backgroundColor: AppColor.border,
                    color: data.color,
                    minHeight: 5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── TODAY TASKS HEADER ──────────────────────────────────────────────────────

class _TodayTasksHeader extends StatelessWidget {
  final int count;
  const _TodayTasksHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CardIconBadge(icon: Icons.task_alt_rounded, color: AppColor.primary),
        SizedBox(width: 10.w),
        Text(
          "Today's Tasks",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColor.textPrimary,
          ),
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColor.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(99),
          ),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColor.secondary,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 5.w),
              Text(
                '$count active',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── TASK CARD ───────────────────────────────────────────────────────────────

class _TaskCard extends StatelessWidget {
  final TodayTask task;
  const _TaskCard({required this.task});

  Color get _color {
    switch (task.serviceType.toLowerCase()) {
      case 'plantation':
        return AppColor.secondary;
      case 'maintenance':
        return AppColor.accent;
      case 'monitoring':
        return AppColor.skyBlue;
      default:
        return AppColor.textMuted;
    }
  }

  String _fmtDate(String raw) {
    try {
      final d = DateTime.parse(raw);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]}';
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    final pct = task.progressPercent;
    final remaining = task.expectedToday - task.completedToday;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: _cardDecor,
      child: Column(
        children: [
          // ── Main body ────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type pill + progress %
                Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                                color: color, shape: BoxShape.circle),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            task.serviceType,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$pct%',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColor.textPrimary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),

                // Area location
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 13, color: AppColor.textMuted),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        task.area,
                        style: TextStyle(
                            fontSize: 12.sp, color: AppColor.textMuted),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: pct / 100,
                    backgroundColor: AppColor.border,
                    color: color,
                    minHeight: 6,
                  ),
                ),
                SizedBox(height: 14.h),

                // Three inline stats: Today | Total Trees | Remaining
                IntrinsicHeight(
                  child: Row(
                    children: [
                      _InlineStat(
                        label: 'Today',
                        value: '${task.completedToday}/${task.expectedToday}',
                        valueColor: color,
                      ),
                      _VertDivider(),
                      _InlineStat(
                        label: 'Total trees',
                        value: '${task.totalTrees}',
                        valueColor: AppColor.textPrimary,
                      ),
                      _VertDivider(),
                      _InlineStat(
                        label: 'Remaining',
                        value: remaining > 0 ? '$remaining left' : 'Done ✓',
                        valueColor:
                            remaining > 0 ? AppColor.warning : AppColor.success,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Date range footer ────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColor.grey,
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(16.r)),
            ),
            child: Row(
              children: [
                const Icon(Icons.date_range_outlined,
                    size: 12, color: AppColor.textMuted),
                SizedBox(width: 6.w),
                Text(
                  '${_fmtDate(task.startDate)}  –  ${_fmtDate(task.endDate)}',
                  style: TextStyle(fontSize: 11.sp, color: AppColor.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── REUSABLE COMPONENTS ─────────────────────────────────────────────────────

/// Tinted square icon badge used as section headers (mirrors reference style)
class _CardIconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _CardIconBadge({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(icon, color: color, size: 16),
    );
  }
}

/// Stat chip used in Overall Summary — first chip is dark/highlighted
class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final bool highlighted;
  const _StatChip({
    required this.value,
    required this.label,
    required this.icon,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = highlighted ? AppColor.primary : AppColor.grey;
    final fgStrong = highlighted ? AppColor.white : AppColor.textPrimary;
    final fgMuted =
        highlighted ? AppColor.white.withOpacity(0.65) : AppColor.textMuted;

    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 14, color: fgMuted),
                Icon(Icons.chevron_right_rounded, size: 14, color: fgMuted),
              ],
            ),
            SizedBox(height: 6.h),
            Text(value,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: fgStrong,
                )),
            SizedBox(height: 2.h),
            Text(label,
                style: TextStyle(fontSize: 9.sp, color: fgMuted),
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

/// Inline stat cell inside task cards
class _InlineStat extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  const _InlineStat({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: valueColor,
              )),
          SizedBox(height: 2.h),
          Text(label,
              style: TextStyle(fontSize: 10.sp, color: AppColor.textMuted)),
        ],
      ),
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        color: AppColor.divider,
        margin: EdgeInsets.symmetric(horizontal: 8.w),
      );
}

// ─── ERROR VIEW ──────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String? message;
  const _ErrorView({this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_outlined,
              size: 44, color: AppColor.textMuted),
          SizedBox(height: 12.h),
          Text(
            message ?? 'Unable to load data',
            style: TextStyle(color: AppColor.textSecondary, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }
}

// ─── FADE + SLIDE ANIMATION HELPER ───────────────────────────────────────────

class _FadeSlide extends StatelessWidget {
  final AnimationController ctrl;
  final double delay;
  final Widget child;
  const _FadeSlide(
      {required this.ctrl, required this.delay, required this.child});

  @override
  Widget build(BuildContext context) {
    final start = delay.clamp(0.0, 0.9);
    final end = (delay + 0.4).clamp(0.1, 1.0);
    final anim = CurvedAnimation(
      parent: ctrl,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
    return AnimatedBuilder(
      animation: anim,
      builder: (_, __) => Opacity(
        opacity: anim.value,
        child: Transform.translate(
          offset: Offset(0, 14 * (1 - anim.value)),
          child: child,
        ),
      ),
    );
  }
}

BoxDecoration get _cardDecor => BoxDecoration(
      color: AppColor.cardBackground,
      borderRadius: BorderRadius.circular(12.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
