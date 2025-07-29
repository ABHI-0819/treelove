import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF070707);

  // Primary & Secondary
  static const Color primary = Color(0xFF00473C); // Deep Forest Green
  static const Color primaryDark = Color(0xFF002D26);
  static const Color primaryLight = Color(0xFF1C665A);

  static const Color secondary = Color(0xFF63B27F); // Muted leafy green
  static const Color secondaryLight = Color(0xFF9DD9A5);
  static const Color secondaryDark = Color(0xFF387A58);

  // Backgrounds
  static const Color background = Color(0xFFF8F4E3); // Soft Creamy Beige
  static const Color scaffoldBackground = Color(0xFFF8F4E3);
  static const Color cardBackground = Color(0xFFFFFFFF);
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground.withOpacity(0.6),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120.h),
        child: Container(
          height: 100.h,
          padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0B5B4D), Color(0xFF0E6655)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Hello John 😊',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar


            // Content
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Overall Summary Cards
                  _buildSummarySection(),
                  const SizedBox(height: 24),

                  // This Week Progress
                  _buildWeeklyProgressSection(),
                  const SizedBox(height: 24),

                  // Today's Tasks
                  // _buildTodayTasksSection(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overall Summary',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'Total Assignments',
                value: '6',
                icon: Icons.assignment_outlined,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                title: 'Trees Assigned',
                value: '3,000',
                icon: Icons.park_outlined,
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildSummaryCard(
          title: 'Trees Completed',
          value: '18',
          subtitle: 'Total Progress: 0.6%',
          icon: Icons.check_circle_outline,
          color: AppColors.secondaryDark,
          isWide: true,
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    String? subtitle,
    required IconData icon,
    required Color color,
    bool isWide = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              if (!isWide) const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: isWide ? 28 : 24,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.black.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWeeklyProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'This Week Progress',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildWeeklyProgressItem('Plantation', 18, Icons.eco, AppColors.secondary),
              const SizedBox(height: 16),
              _buildWeeklyProgressItem('Maintenance', 0, Icons.build, AppColors.primaryLight),
              const SizedBox(height: 16),
              _buildWeeklyProgressItem('Monitoring', 0, Icons.visibility, AppColors.secondaryDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyProgressItem(String type, int count, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              Text(
                '$count trees completed',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.black.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  /*
  Widget _buildTodayTasksSection() {
    final todayTasks = [
      {
        "service_type": "Plantation",
        "area": "Thane West",
        "start_date": "2025-07-24",
        "end_date": "2025-10-24",
        "total_trees": 500,
        "expected_today": 5,
        "completed_today": 7,
        "progress_percent": 140
      },
      {
        "service_type": "Plantation",
        "area": "Thane West",
        "start_date": "2025-07-24",
        "end_date": "2025-10-24",
        "total_trees": 400,
        "expected_today": 4,
        "completed_today": 10,
        "progress_percent": 250
      },
      {
        "service_type": "Plantation",
        "area": "Thane East",
        "start_date": "2025-07-24",
        "end_date": "2025-10-24",
        "total_trees": 500,
        "expected_today": 5,
        "completed_today": 0,
        "progress_percent": 0
      },
      {
        "service_type": "Maintenance",
        "area": "Thane West",
        "start_date": "2025-07-24",
        "end_date": "2025-10-24",
        "total_trees": 400,
        "expected_today": 4,
        "completed_today": 0,
        "progress_percent": 0
      },
      {
        "service_type": "Monitoring",
        "area": "Thane West",
        "start_date": "2025-07-24",
        "end_date": "2025-10-24",
        "total_trees": 400,
        "expected_today": 4,
        "completed_today": 0,
        "progress_percent": 0
      },
      {
        "service_type": "Monitoring",
        "area": "Thane West",
        "start_date": "2025-07-24",
        "end_date": "2025-10-24",
        "total_trees": 800,
        "expected_today": 8,
        "completed_today": 0,
        "progress_percent": 0
      }
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Today\'s Tasks',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        ...todayTasks.map((task) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildTaskCard(task),
        )).toList(),
      ],
    );
  }

   */

  Widget _buildTaskCard(Map<String, dynamic> task) {
    final serviceType = task['service_type'] as String;
    final area = task['area'] as String;
    final totalTrees = task['total_trees'] as int;
    final expectedToday = task['expected_today'] as int;
    final completedToday = task['completed_today'] as int;
    final progressPercent = task['progress_percent'] as int;

    IconData icon;
    Color serviceColor;

    switch (serviceType) {
      case 'Plantation':
        icon = Icons.eco;
        serviceColor = AppColors.secondary;
        break;
      case 'Maintenance':
        icon = Icons.build;
        serviceColor = AppColors.primaryLight;
        break;
      case 'Monitoring':
        icon = Icons.visibility;
        serviceColor = AppColors.secondaryDark;
        break;
      default:
        icon = Icons.work;
        serviceColor = AppColors.primary;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        // border: Border.(
        //   color: serviceColor,
        //   width: 4,
        // ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: serviceColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: serviceColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      serviceType,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    Text(
                      area,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.black.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: progressPercent > 100
                      ? AppColors.secondary.withOpacity(0.1)
                      : progressPercent > 0
                      ? AppColors.primaryLight.withOpacity(0.1)
                      : AppColors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$progressPercent%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: progressPercent > 100
                        ? AppColors.secondary
                        : progressPercent > 0
                        ? AppColors.primaryLight
                        : AppColors.black.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTaskMetric('Expected', expectedToday.toString()),
              ),
              Expanded(
                child: _buildTaskMetric('Completed', completedToday.toString()),
              ),
              Expanded(
                child: _buildTaskMetric('Total Trees', totalTrees.toString()),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progressPercent / 100,
            backgroundColor: AppColors.black.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(
              progressPercent > 100 ? AppColors.secondary : serviceColor,
            ),
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildTaskMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.black.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}