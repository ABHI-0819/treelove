import 'dart:convert';

VendorDashboardModel vendorDashboardModelFromJson(String str) =>
    VendorDashboardModel.fromJson(json.decode(str));

class VendorDashboardModel {
  final String? status;
  final String? message;
  final DashboardData? data;

  VendorDashboardModel({this.status, this.message, this.data});

  factory VendorDashboardModel.fromJson(Map<String, dynamic> json) =>
      VendorDashboardModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : DashboardData.fromJson(json["data"]),
      );
}

class DashboardData {
  final ProjectOverview? projectOverview;
  final TodayActivity? todayActivity;
  final WeeklySummary? weeklySummary;
  final Map<String, ServiceProgress>? progressByService;
  final List<FieldworkerLeader>? fieldworkerLeaderboard;
  final SummaryStats? summaryStats;

  DashboardData({
    this.projectOverview,
    this.todayActivity,
    this.weeklySummary,
    this.progressByService,
    this.fieldworkerLeaderboard,
    this.summaryStats,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) => DashboardData(
        projectOverview: json["project_overview"] == null
            ? null
            : ProjectOverview.fromJson(json["project_overview"]),
        todayActivity: json["today_activity"] == null
            ? null
            : TodayActivity.fromJson(json["today_activity"]),
        weeklySummary: json["weekly_summary"] == null
            ? null
            : WeeklySummary.fromJson(json["weekly_summary"]),
        progressByService: json["progress_by_service"] == null
            ? null
            : (json["progress_by_service"] as Map<String, dynamic>).map(
                (k, v) => MapEntry(k, ServiceProgress.fromJson(v)),
              ),
        fieldworkerLeaderboard: json["fieldworker_leaderboard"] == null
            ? []
            : List<FieldworkerLeader>.from(
                json["fieldworker_leaderboard"].map((x) => FieldworkerLeader.fromJson(x))),
        summaryStats: json["summary_stats"] == null
            ? null
            : SummaryStats.fromJson(json["summary_stats"]),
      );
}

class ProjectOverview {
  final int totalProjects;
  final int ongoingProjects;
  final int completedProjects;

  ProjectOverview({
    this.totalProjects = 0,
    this.ongoingProjects = 0,
    this.completedProjects = 0,
  });

  factory ProjectOverview.fromJson(Map<String, dynamic> json) => ProjectOverview(
        totalProjects: json["total_projects"] ?? 0,
        ongoingProjects: json["ongoing_projects"] ?? 0,
        completedProjects: json["completed_projects"] ?? 0,
      );
}

class TodayActivity {
  final int treesPlanted;
  final int treesMaintained;
  final int treesMonitored;
  final int activeFieldworkers;
  final int activeAssignments;

  TodayActivity({
    this.treesPlanted = 0,
    this.treesMaintained = 0,
    this.treesMonitored = 0,
    this.activeFieldworkers = 0,
    this.activeAssignments = 0,
  });

  factory TodayActivity.fromJson(Map<String, dynamic> json) => TodayActivity(
        treesPlanted: json["trees_planted"] ?? 0,
        treesMaintained: json["trees_maintained"] ?? 0,
        treesMonitored: json["trees_monitored"] ?? 0,
        activeFieldworkers: json["active_fieldworkers"] ?? 0,
        activeAssignments: json["active_assignments"] ?? 0,
      );
}

class WeeklySummary {
  final int treesPlanted;
  final int treesMaintained;
  final int treesMonitored;
  final int overdueAssignments;

  WeeklySummary({
    this.treesPlanted = 0,
    this.treesMaintained = 0,
    this.treesMonitored = 0,
    this.overdueAssignments = 0,
  });

  factory WeeklySummary.fromJson(Map<String, dynamic> json) => WeeklySummary(
        treesPlanted: json["trees_planted"] ?? 0,
        treesMaintained: json["trees_maintained"] ?? 0,
        treesMonitored: json["trees_monitored"] ?? 0,
        overdueAssignments: json["overdue_assignments"] ?? 0,
      );
}

class ServiceProgress {
  final int totalAssignments;
  final int totalTrees;
  final int completedTrees;
  final double completionPercent;

  ServiceProgress({
    this.totalAssignments = 0,
    this.totalTrees = 0,
    this.completedTrees = 0,
    this.completionPercent = 0.0,
  });

  factory ServiceProgress.fromJson(Map<String, dynamic> json) => ServiceProgress(
        totalAssignments: json["total_assignments"] ?? 0,
        totalTrees: json["total_trees"] ?? 0,
        completedTrees: json["completed_trees"] ?? 0,
        completionPercent: (json["completion_percent"] ?? 0).toDouble(),
      );
}

class FieldworkerLeader {
  final String? id;
  final String? username;
  final String? fullName;
  final String? profilePicture;
  final int treesHandled;

  FieldworkerLeader({
    this.id,
    this.username,
    this.fullName,
    this.profilePicture,
    this.treesHandled = 0,
  });

  factory FieldworkerLeader.fromJson(Map<String, dynamic> json) => FieldworkerLeader(
        id: json["id"],
        username: json["username"],
        fullName: json["full_name"],
        profilePicture: json["profile_picture"],
        treesHandled: json["trees_handled"] ?? 0,
      );
}

class SummaryStats {
  final int totalFieldworkers;
  final int totalServices;
  final int totalAssignments;
  final int overdueAssignments;
  final int totalTreesAssigned;
  final int totalTreesCompleted;

  SummaryStats({
    this.totalFieldworkers = 0,
    this.totalServices = 0,
    this.totalAssignments = 0,
    this.overdueAssignments = 0,
    this.totalTreesAssigned = 0,
    this.totalTreesCompleted = 0,
  });

  factory SummaryStats.fromJson(Map<String, dynamic> json) => SummaryStats(
        totalFieldworkers: json["total_fiedlworkers"] ?? 0, // note: typo in API
        totalServices: json["total_services"] ?? 0,
        totalAssignments: json["total_assignments"] ?? 0,
        overdueAssignments: json["overdue_assignments"] ?? 0,
        totalTreesAssigned: json["total_trees_assigned"] ?? 0,
        totalTreesCompleted: json["total_trees_completed"] ?? 0,
      );
}
