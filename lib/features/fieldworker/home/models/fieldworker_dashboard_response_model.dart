import 'dart:convert';

FieldworkerDashboardResponseModel fieldworkerDashboardResponseModelFromJson(
        String str) =>
    FieldworkerDashboardResponseModel.fromJson(json.decode(str));

String fieldworkerDashboardResponseModelToJson(
        FieldworkerDashboardResponseModel data) =>
    json.encode(data.toJson());

class FieldworkerDashboardResponseModel {
  final List<TodayTask>
      todayTasks; // Removed ? to keep UI logic cleaner with empty lists
  final ThisWeekTasks? thisWeekTasks;
  final OverallSummary? overallSummary;

  FieldworkerDashboardResponseModel({
    required this.todayTasks,
    this.thisWeekTasks,
    this.overallSummary,
  });

  factory FieldworkerDashboardResponseModel.fromJson(
      Map<String, dynamic>? json) {
    return FieldworkerDashboardResponseModel(
      // Handle null list or null elements within the list
      todayTasks: json?['today_tasks'] == null
          ? []
          : (json!['today_tasks'] as List)
              .map((e) => TodayTask.fromJson(e))
              .toList(),
      // Handle null nested objects
      thisWeekTasks: json?['this_week_tasks'] != null
          ? ThisWeekTasks.fromJson(json!['this_week_tasks'])
          : null,
      overallSummary: json?['overall_summary'] != null
          ? OverallSummary.fromJson(json!['overall_summary'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'today_tasks': todayTasks.map((e) => e.toJson()).toList(),
      'this_week_tasks': thisWeekTasks?.toJson(),
      'overall_summary': overallSummary?.toJson(),
    };
  }
}

class TodayTask {
  final String serviceType;
  final String area;
  final String startDate;
  final String endDate;
  final int totalTrees;
  final int expectedToday;
  final int completedToday;
  final int progressPercent;

  TodayTask({
    required this.serviceType,
    required this.area,
    required this.startDate,
    required this.endDate,
    required this.totalTrees,
    required this.expectedToday,
    required this.completedToday,
    required this.progressPercent,
  });

  factory TodayTask.fromJson(Map<String, dynamic>? json) {
    return TodayTask(
      serviceType: json?['service_type']?.toString() ?? '',
      area: json?['area']?.toString() ?? '',
      startDate: json?['start_date']?.toString() ?? '',
      endDate: json?['end_date']?.toString() ?? '',
      totalTrees: json?['total_trees'] ?? 0,
      expectedToday: json?['expected_today'] ?? 0,
      completedToday: json?['completed_today'] ?? 0,
      progressPercent: json?['progress_percent'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_type': serviceType,
      'area': area,
      'start_date': startDate,
      'end_date': endDate,
      'total_trees': totalTrees,
      'expected_today': expectedToday,
      'completed_today': completedToday,
      'progress_percent': progressPercent,
    };
  }
}

class ThisWeekTasks {
  final int plantation;
  final int maintenance;
  final int monitoring;

  ThisWeekTasks({
    required this.plantation,
    required this.maintenance,
    required this.monitoring,
  });

  factory ThisWeekTasks.fromJson(Map<String, dynamic>? json) {
    return ThisWeekTasks(
      plantation: json?['Plantation'] ?? 0,
      maintenance: json?['Maintenance'] ?? 0,
      monitoring: json?['Monitoring'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Plantation': plantation,
      'Maintenance': maintenance,
      'Monitoring': monitoring,
    };
  }
}

class OverallSummary {
  final int totalAssignments;
  final int totalTreesAssigned;
  final int totalTreesCompleted;

  OverallSummary({
    required this.totalAssignments,
    required this.totalTreesAssigned,
    required this.totalTreesCompleted,
  });

  factory OverallSummary.fromJson(Map<String, dynamic>? json) {
    return OverallSummary(
      totalAssignments: json?['total_assignments'] ?? 0,
      totalTreesAssigned: json?['total_trees_assigned'] ?? 0,
      totalTreesCompleted: json?['total_trees_completed'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_assignments': totalAssignments,
      'total_trees_assigned': totalTreesAssigned,
      'total_trees_completed': totalTreesCompleted,
    };
  }
}
