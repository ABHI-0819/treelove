/*
{
  "status": "success",
  "message": "Client Dashboard Fetched Successfully.",
  "data": {
    "project_overview": {
      "total_projects": 1,
      "total_investment": 1230000,
      "ongoing_projects": 1,
      "completed_projects": 0,
      "upcoming_projects": 0
    },
    "today_activity": {
      "trees_planted": 0,
      "trees_maintained": 0,
      "trees_monitored": 0
    },
    "weekly_summary": {
      "trees_planted": 0,
      "trees_maintained": 0,
      "trees_monitored": 0
    },
    "progress_by_service": {
      "Maintenance": {
        "total_trees": 1000,
        "completed_trees": 0,
        "completion_percent": 0
      },
      "Monitoring": {
        "total_trees": 1000,
        "completed_trees": 0,
        "completion_percent": 0
      },
      "Plantation": {
        "total_trees": 1000,
        "completed_trees": 0,
        "completion_percent": 0
      }
    }
  }
}
 */

/*
import 'dart:convert';

/// Helper functions
DashboardResponseModel dashboardResponseModelFromJson(String str) =>
    DashboardResponseModel.fromJson(json.decode(str));

String dashboardResponseModelToJson(DashboardResponseModel data) =>
    json.encode(data.toJson());

class DashboardResponseModel {
  final String status;
  final String message;
  final DashboardData data;

  DashboardResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DashboardResponseModel.fromJson(Map<String, dynamic> json) {
    return DashboardResponseModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: DashboardData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data.toJson(),
      };
}

class DashboardData {
  final ProjectOverview projectOverview;
  final Activity todayActivity;
  final Activity weeklySummary;
  final Map<String, ProgressByService> progressByService;

  DashboardData({
    required this.projectOverview,
    required this.todayActivity,
    required this.weeklySummary,
    required this.progressByService,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    final progressMap = <String, ProgressByService>{};
    if (json['progress_by_service'] != null) {
      (json['progress_by_service'] as Map<String, dynamic>)
          .forEach((key, value) {
        progressMap[key] = ProgressByService.fromJson(value);
      });
    }
    return DashboardData(
      projectOverview: ProjectOverview.fromJson(json['project_overview'] ?? {}),
      todayActivity: Activity.fromJson(json['today_activity'] ?? {}),
      weeklySummary: Activity.fromJson(json['weekly_summary'] ?? {}),
      progressByService: progressMap,
    );
  }

  Map<String, dynamic> toJson() => {
        'project_overview': projectOverview.toJson(),
        'today_activity': todayActivity.toJson(),
        'weekly_summary': weeklySummary.toJson(),
        'progress_by_service':
            progressByService.map((k, v) => MapEntry(k, v.toJson())),
      };
}

class ProjectOverview {
  final int totalProjects;
  final double totalInvestment;
  final int ongoingProjects;
  final int completedProjects;
  final int upcomingProjects;

  ProjectOverview({
    required this.totalProjects,
    required this.totalInvestment,
    required this.ongoingProjects,
    required this.completedProjects,
    required this.upcomingProjects,
  });

  factory ProjectOverview.fromJson(Map<String, dynamic> json) {
    return ProjectOverview(
      totalProjects: json['total_projects'] ?? 0,
      totalInvestment: json['total_investment'] ?? 0,
      ongoingProjects: json['ongoing_projects'] ?? 0,
      completedProjects: json['completed_projects'] ?? 0,
      upcomingProjects: json['upcoming_projects'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'total_projects': totalProjects,
        'total_investment': totalInvestment,
        'ongoing_projects': ongoingProjects,
        'completed_projects': completedProjects,
        'upcoming_projects': upcomingProjects,
      };
}

class Activity {
  final int treesPlanted;
  final int treesMaintained;
  final int treesMonitored;

  Activity({
    required this.treesPlanted,
    required this.treesMaintained,
    required this.treesMonitored,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      treesPlanted: json['trees_planted'] ?? 0,
      treesMaintained: json['trees_maintained'] ?? 0,
      treesMonitored: json['trees_monitored'] ?? 0,
    );
  }
  Map<String, dynamic> toJson() => {
        'trees_planted': treesPlanted,
        'trees_maintained': treesMaintained,
        'trees_monitored': treesMonitored,
      };
}

class ProgressByService {
  final int totalTrees;
  final int completedTrees;
  final int completionPercent;

  ProgressByService({
    required this.totalTrees,
    required this.completedTrees,
    required this.completionPercent,
  });

  factory ProgressByService.fromJson(Map<String, dynamic> json) {
    return ProgressByService(
      totalTrees: json['total_trees'] ?? 0,
      completedTrees: json['completed_trees'] ?? 0,
      completionPercent: json['completion_percent'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'total_trees': totalTrees,
        'completed_trees': completedTrees,
        'completion_percent': completionPercent,
      };
}

 */
import 'dart:convert';

/// Helper functions
DashboardResponseModel dashboardResponseModelFromJson(String str) =>
    DashboardResponseModel.fromJson(json.decode(str));

String dashboardResponseModelToJson(DashboardResponseModel data) =>
    json.encode(data.toJson());

class DashboardResponseModel {
  final String status;
  final String message;
  final DashboardData data;

  DashboardResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DashboardResponseModel.fromJson(Map<String, dynamic> json) {
    return DashboardResponseModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: DashboardData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data.toJson(),
  };
}

class DashboardData {
  final ProjectOverview projectOverview;
  final Activity todayActivity;
  final Activity weeklySummary;
  final ProgressByServiceWrapper progressByService;

  DashboardData({
    required this.projectOverview,
    required this.todayActivity,
    required this.weeklySummary,
    required this.progressByService,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      projectOverview: ProjectOverview.fromJson(json['project_overview'] ?? {}),
      todayActivity: Activity.fromJson(json['today_activity'] ?? {}),
      weeklySummary: Activity.fromJson(json['weekly_summary'] ?? {}),
      progressByService:
      ProgressByServiceWrapper.fromJson(json['progress_by_service'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'project_overview': projectOverview.toJson(),
    'today_activity': todayActivity.toJson(),
    'weekly_summary': weeklySummary.toJson(),
    'progress_by_service': progressByService.toJson(),
  };
}

class ProjectOverview {
  final int totalProjects;
  final double totalInvestment;
  final int ongoingProjects;
  final int completedProjects;
  final int upcomingProjects;

  ProjectOverview({
    required this.totalProjects,
    required this.totalInvestment,
    required this.ongoingProjects,
    required this.completedProjects,
    required this.upcomingProjects,
  });

  factory ProjectOverview.fromJson(Map<String, dynamic> json) {
    return ProjectOverview(
      totalProjects: json['total_projects'] ?? 0,
      totalInvestment: json['total_investment'] ?? 0,
      ongoingProjects: json['ongoing_projects'] ?? 0,
      completedProjects: json['completed_projects'] ?? 0,
      upcomingProjects: json['upcoming_projects'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'total_projects': totalProjects,
    'total_investment': totalInvestment,
    'ongoing_projects': ongoingProjects,
    'completed_projects': completedProjects,
    'upcoming_projects': upcomingProjects,
  };
}

class Activity {
  final int treesPlanted;
  final int treesMaintained;
  final int treesMonitored;

  Activity({
    required this.treesPlanted,
    required this.treesMaintained,
    required this.treesMonitored,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      treesPlanted: json['trees_planted'] ?? 0,
      treesMaintained: json['trees_maintained'] ?? 0,
      treesMonitored: json['trees_monitored'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'trees_planted': treesPlanted,
    'trees_maintained': treesMaintained,
    'trees_monitored': treesMonitored,
  };
}

class ProgressByServiceWrapper {
  final ProgressByService? maintenance;
  final ProgressByService? monitoring;
  final ProgressByService? plantation;

  ProgressByServiceWrapper({
    this.maintenance,
    this.monitoring,
    this.plantation,
  });

  factory ProgressByServiceWrapper.fromJson(Map<String, dynamic> json) {
    return ProgressByServiceWrapper(
      maintenance: json['Maintenance'] != null
          ? ProgressByService.fromJson(json['Maintenance'])
          : null,
      monitoring: json['Monitoring'] != null
          ? ProgressByService.fromJson(json['Monitoring'])
          : null,
      plantation: json['Plantation'] != null
          ? ProgressByService.fromJson(json['Plantation'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'Maintenance': maintenance?.toJson(),
    'Monitoring': monitoring?.toJson(),
    'Plantation': plantation?.toJson(),
  };
}

class ProgressByService {
  final int totalTrees;
  final int completedTrees;
  final int completionPercent;

  ProgressByService({
    required this.totalTrees,
    required this.completedTrees,
    required this.completionPercent,
  });

  factory ProgressByService.fromJson(Map<String, dynamic> json) {
    return ProgressByService(
      totalTrees: json['total_trees'] ?? 0,
      completedTrees: json['completed_trees'] ?? 0,
      completionPercent: json['completion_percent'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'total_trees': totalTrees,
    'completed_trees': completedTrees,
    'completion_percent': completionPercent,
  };
}
