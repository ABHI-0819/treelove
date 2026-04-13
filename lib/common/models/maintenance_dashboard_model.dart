import 'dart:convert';

MaintenanceDashboardModel maintenanceDashboardModelFromJson(String str) =>
    MaintenanceDashboardModel.fromJson(json.decode(str));

class MaintenanceDashboardModel {
  final String? status;
  final String? message;
  final MaintenanceDashboardData? data;

  MaintenanceDashboardModel({this.status, this.message, this.data});

  factory MaintenanceDashboardModel.fromJson(Map<String, dynamic> json) =>
      MaintenanceDashboardModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : MaintenanceDashboardData.fromJson(json["data"]),
      );
}

class MaintenanceDashboardData {
  final String mode; // "project" or "area"
  final MaintProjectInfo? projectInfo;
  final MaintAreaInfo? areaInfo;

  // Project-level KPIs (mode == "project")
  final MaintProjectKpis? projectKpis;

  // Area-level KPIs (mode == "area")
  final MaintAreaKpis? areaKpis;

  final List<MaintActivityStat> activityStats;
  final List<MaintAreaWiseSummary> areaWiseSummary;
  final List<MaintService> services;
  final MaintTeam? team;
  final List<MaintRecentActivity> recentActivity;

  MaintenanceDashboardData({
    this.mode = 'project',
    this.projectInfo,
    this.areaInfo,
    this.projectKpis,
    this.areaKpis,
    this.activityStats = const [],
    this.areaWiseSummary = const [],
    this.services = const [],
    this.team,
    this.recentActivity = const [],
  });

  factory MaintenanceDashboardData.fromJson(Map<String, dynamic> json) =>
      MaintenanceDashboardData(
        mode: json["mode"] ?? 'project',
        projectInfo: json["project_info"] == null
            ? null
            : MaintProjectInfo.fromJson(json["project_info"]),
        areaInfo: json["area_info"] == null
            ? null
            : MaintAreaInfo.fromJson(json["area_info"]),
        projectKpis: json["project_kpis"] == null
            ? null
            : MaintProjectKpis.fromJson(json["project_kpis"]),
        areaKpis: json["area_kpis"] == null
            ? null
            : MaintAreaKpis.fromJson(json["area_kpis"]),
        activityStats: (json["activity_stats"] as List? ?? [])
            .map((x) => MaintActivityStat.fromJson(x))
            .toList(),
        areaWiseSummary: (json["area_wise_summary"] as List? ?? [])
            .map((x) => MaintAreaWiseSummary.fromJson(x))
            .toList(),
        services: (json["services"] as List? ?? [])
            .map((x) => MaintService.fromJson(x))
            .toList(),
        team: json["team"] == null ? null : MaintTeam.fromJson(json["team"]),
        recentActivity: (json["recent_activity"] as List? ?? [])
            .map((x) => MaintRecentActivity.fromJson(x))
            .toList(),
      );
}

// ─── Sub-models ──────────────────────────────────────────────────────────────

class MaintProjectInfo {
  final String id;
  final String name;
  final String type;
  final String endDate;

  MaintProjectInfo({
    this.id = '',
    this.name = '',
    this.type = '',
    this.endDate = '',
  });

  factory MaintProjectInfo.fromJson(Map<String, dynamic> json) =>
      MaintProjectInfo(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        type: json["type"] ?? '',
        endDate: json["end_date"] ?? '',
      );
}

class MaintAreaInfo {
  final String areaId;
  final String areaName;
  final double capacity;
  final String locationDescription;

  MaintAreaInfo({
    this.areaId = '',
    this.areaName = '',
    this.capacity = 0,
    this.locationDescription = '',
  });

  factory MaintAreaInfo.fromJson(Map<String, dynamic> json) => MaintAreaInfo(
        areaId: json["area_id"] ?? '',
        areaName: json["area_name"] ?? '',
        capacity: (json["capacity"] ?? 0).toDouble(),
        locationDescription: json["location_description"] ?? '',
      );
}

class MaintProjectKpis {
  final int totalServices;
  final int totalTreesTargeted;
  final int totalTreesMaintained;
  final double overallProgressPct;
  final int overdueServices;
  final int upcomingIn30Days;
  final double avgHealthScore;
  final double maintenanceGrowthRate;

  MaintProjectKpis({
    this.totalServices = 0,
    this.totalTreesTargeted = 0,
    this.totalTreesMaintained = 0,
    this.overallProgressPct = 0,
    this.overdueServices = 0,
    this.upcomingIn30Days = 0,
    this.avgHealthScore = 0,
    this.maintenanceGrowthRate = 0,
  });

  factory MaintProjectKpis.fromJson(Map<String, dynamic> json) =>
      MaintProjectKpis(
        totalServices: json["total_services"] ?? 0,
        totalTreesTargeted: json["total_trees_targeted"] ?? 0,
        totalTreesMaintained: json["total_trees_maintained"] ?? 0,
        overallProgressPct: (json["overall_progress_pct"] ?? 0).toDouble(),
        overdueServices: json["overdue_services"] ?? 0,
        upcomingIn30Days: json["upcoming_in_30_days"] ?? 0,
        avgHealthScore: (json["avg_health_score"] ?? 0).toDouble(),
        maintenanceGrowthRate:
            (json["maintenance_growth_rate"] ?? 0).toDouble(),
      );
}

class MaintAreaKpis {
  final int totalServices;
  final int totalTreesTargeted;
  final int totalTreesMaintained;
  final double progressPct;
  final int overdueServices;
  final String nextScheduledDate;
  final bool isOverdue;
  final double avgHealthScore;

  MaintAreaKpis({
    this.totalServices = 0,
    this.totalTreesTargeted = 0,
    this.totalTreesMaintained = 0,
    this.progressPct = 0,
    this.overdueServices = 0,
    this.nextScheduledDate = '',
    this.isOverdue = false,
    this.avgHealthScore = 0,
  });

  factory MaintAreaKpis.fromJson(Map<String, dynamic> json) => MaintAreaKpis(
        totalServices: json["total_services"] ?? 0,
        totalTreesTargeted: json["total_trees_targeted"] ?? 0,
        totalTreesMaintained: json["total_trees_maintained"] ?? 0,
        progressPct: (json["progress_pct"] ?? 0).toDouble(),
        overdueServices: json["overdue_services"] ?? 0,
        nextScheduledDate: json["next_scheduled_date"] ?? '',
        isOverdue: json["is_overdue"] ?? false,
        avgHealthScore: (json["avg_health_score"] ?? 0).toDouble(),
      );
}

class MaintActivityStat {
  final String activityId;
  final String activityName;
  final int totalTrees;
  final int singleTrees;
  final int bulkTrees;
  final int maintenanceCount;

  MaintActivityStat({
    this.activityId = '',
    this.activityName = '',
    this.totalTrees = 0,
    this.singleTrees = 0,
    this.bulkTrees = 0,
    this.maintenanceCount = 0,
  });

  factory MaintActivityStat.fromJson(Map<String, dynamic> json) =>
      MaintActivityStat(
        activityId: json["activity_id"] ?? '',
        activityName: json["activity_name"] ?? '',
        totalTrees: json["total_trees"] ?? 0,
        singleTrees: json["single_trees"] ?? 0,
        bulkTrees: json["bulk_trees"] ?? 0,
        maintenanceCount: json["maintenance_count"] ?? 0,
      );
}

class MaintAreaWiseSummary {
  final String areaId;
  final String areaName;
  final double capacity;
  final int totalServices;
  final int totalTreesTargeted;
  final int totalTreesMaintained;
  final double progressPct;
  final int overdueServices;
  final String nextScheduledDate;
  final bool isOverdue;
  final double avgHealthScore;
  final List<MaintActivityStat> activityStats;
  final List<MaintService> services;
  final MaintTeam? team;
  final List<MaintRecentActivity> recentActivity;

  MaintAreaWiseSummary({
    this.areaId = '',
    this.areaName = '',
    this.capacity = 0.0,
    this.totalServices = 0,
    this.totalTreesTargeted = 0,
    this.totalTreesMaintained = 0,
    this.progressPct = 0,
    this.overdueServices = 0,
    this.nextScheduledDate = '',
    this.isOverdue = false,
    this.avgHealthScore = 0,
    this.activityStats = const [],
    this.services = const [],
    this.team,
    this.recentActivity = const [],
  });

  factory MaintAreaWiseSummary.fromJson(Map<String, dynamic> json) =>
      MaintAreaWiseSummary(
        areaId: json["area_id"] ?? '',
        areaName: json["area_name"] ?? '',
        capacity: (json["capacity"] ?? 0).toDouble(),
        totalServices: json["total_services"] ?? 0,
        totalTreesTargeted: json["total_trees_targeted"] ?? 0,
        totalTreesMaintained: json["total_trees_maintained"] ?? 0,
        progressPct: (json["progress_pct"] ?? 0).toDouble(),
        overdueServices: json["overdue_services"] ?? 0,
        nextScheduledDate: json["next_scheduled_date"] ?? '',
        isOverdue: json["is_overdue"] ?? false,
        avgHealthScore: (json["avg_health_score"] ?? 0).toDouble(),
        activityStats: (json["activity_stats"] as List? ?? [])
            .map((x) => MaintActivityStat.fromJson(x))
            .toList(),
        services: (json["services"] as List? ?? [])
            .map((x) => MaintService.fromJson(x))
            .toList(),
        team: json["team"] == null ? null : MaintTeam.fromJson(json["team"]),
        recentActivity: (json["recent_activity"] as List? ?? [])
            .map((x) => MaintRecentActivity.fromJson(x))
            .toList(),
      );
}

class MaintService {
  final String serviceId;
  final String speciesName;
  final String scientificName;
  final int numTrees;
  final int treesMaintained;
  final double progressPct;
  final double avgHealth;
  final String nextScheduledDate;
  final bool isOverdue;
  final String lastMaintenanceDate;
  final List<String> topActivities;
  final int assignedVendors;
  final int assignedFieldworkers;

  MaintService({
    this.serviceId = '',
    this.speciesName = '',
    this.scientificName = '',
    this.numTrees = 0,
    this.treesMaintained = 0,
    this.progressPct = 0,
    this.avgHealth = 0,
    this.nextScheduledDate = '',
    this.isOverdue = false,
    this.lastMaintenanceDate = '',
    this.topActivities = const [],
    this.assignedVendors = 0,
    this.assignedFieldworkers = 0,
  });

  factory MaintService.fromJson(Map<String, dynamic> json) => MaintService(
        serviceId: json["service_id"] ?? '',
        speciesName: json["species_name"] ?? '',
        scientificName: json["scientific_name"] ?? '',
        numTrees: json["num_trees"] ?? 0,
        treesMaintained: json["trees_maintained"] ?? 0,
        progressPct: (json["progress_pct"] ?? 0).toDouble(),
        avgHealth: (json["avg_health"] ?? 0).toDouble(),
        nextScheduledDate: json["next_scheduled_date"] ?? '',
        isOverdue: json["is_overdue"] ?? false,
        lastMaintenanceDate: json["last_maintenance_date"] ?? '',
        topActivities: (json["top_activities"] as List? ?? [])
            .map((x) => x.toString())
            .toList(),
        assignedVendors: json["assigned_vendors"] ?? 0,
        assignedFieldworkers: json["assigned_fieldworkers"] ?? 0,
      );
}

class MaintTeam {
  final List<MaintFieldworker> fieldworkers;

  MaintTeam({this.fieldworkers = const []});

  factory MaintTeam.fromJson(Map<String, dynamic> json) => MaintTeam(
        fieldworkers: (json["fieldworkers"] as List? ?? [])
            .map((x) => MaintFieldworker.fromJson(x))
            .toList(),
      );
}

class MaintFieldworker {
  final String id;
  final String name;
  final String email;
  final String? profilePicture;

  MaintFieldworker({
    this.id = '',
    this.name = '',
    this.email = '',
    this.profilePicture,
  });

  factory MaintFieldworker.fromJson(Map<String, dynamic> json) =>
      MaintFieldworker(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        email: json["email"] ?? '',
        profilePicture: json["profile_picture"],
      );
}

class MaintRecentActivity {
  final String maintenanceId;
  final String maintenanceDate;
  final String maintenanceType;
  final int treesCovered;
  final String speciesName;
  final String serviceId;
  final List<MaintActivityDetail> activities;
  final String weather;
  final MaintPerformedBy? performedBy;
  final String avgHealth;
  final String? areaName;

  MaintRecentActivity({
    this.maintenanceId = '',
    this.maintenanceDate = '',
    this.maintenanceType = '',
    this.treesCovered = 0,
    this.speciesName = '',
    this.serviceId = '',
    this.activities = const [],
    this.weather = '',
    this.performedBy,
    this.avgHealth = '',
    this.areaName,
  });

  factory MaintRecentActivity.fromJson(Map<String, dynamic> json) =>
      MaintRecentActivity(
        maintenanceId: json["maintenance_id"] ?? '',
        maintenanceDate: json["maintenance_date"] ?? '',
        maintenanceType: json["maintenance_type"] ?? '',
        treesCovered: json["trees_covered"] ?? 0,
        speciesName: json["species_name"] ?? '',
        serviceId: json["service_id"] ?? '',
        activities: (json["activities"] as List? ?? [])
            .map((x) => MaintActivityDetail.fromJson(x))
            .toList(),
        weather: json["weather"] ?? '',
        performedBy: json["performed_by"] == null
            ? null
            : MaintPerformedBy.fromJson(json["performed_by"]),
        avgHealth: json["avg_health"] ?? '',
        areaName: json["area_name"],
      );
}

class MaintActivityDetail {
  final String activityName;
  final int treesCovered;

  MaintActivityDetail({this.activityName = '', this.treesCovered = 0});

  factory MaintActivityDetail.fromJson(Map<String, dynamic> json) =>
      MaintActivityDetail(
        activityName: json["activity_name"] ?? '',
        treesCovered: json["trees_covered"] ?? 0,
      );
}

class MaintPerformedBy {
  final String id;
  final String name;
  final String? profilePicture;

  MaintPerformedBy({this.id = '', this.name = '', this.profilePicture});

  factory MaintPerformedBy.fromJson(Map<String, dynamic> json) =>
      MaintPerformedBy(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        profilePicture: json["profile_picture"],
      );
}
