import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:treelove/common/repositories/project_area_repository.dart';
import 'package:treelove/core/network/api_connection.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../common/bloc/api_event.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../core/config/resource/images.dart';
import '../../../../core/config/resource/service_ids.dart';
import '../../../../core/config/route/app_route.dart';
import '../../../../core/config/themes/app_color.dart';
import '../../../../core/widgets/common_notification.dart';
import '../../../authentication/screens/sign_in_screen.dart';
import '../bloc/project_area_bloc.dart';
import '../models/project_area_list_response.dart';
import 'project_action_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ProjectAreaBloc projectAreaBloc;

  @override
  void initState() {
    ServiceIds.load();
    projectAreaBloc =
        ProjectAreaBloc(ProjectAreaRepository(api: ApiConnection()));
    projectAreaBloc.add(ApiListFetch());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,

      body: BlocProvider(
        create: (context) => projectAreaBloc,
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 15.h),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ongoing Areas (2)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                BlocListener<ProjectAreaBloc,
                    ApiState<ProjectAreasResponse, ResponseModel>>(
                  listener: (context, state) {
                    EasyLoading.dismiss();
                    if (state
                        is ApiFailure<ProjectAreasResponse, ResponseModel>) {
                      showNotification(context,
                          message: state.error.message.toString());
                    } else if (state
                        is TokenExpired<ProjectAreasResponse, ResponseModel>) {
                      AppRoute.pushReplacement(context, SignInScreen.route,
                          arguments: {});
                    }
                  },
                  child: BlocBuilder<ProjectAreaBloc,
                      ApiState<ProjectAreasResponse, ResponseModel>>(
                    builder: (context, state) {
                      if(state is ApiLoading){
                        return Center(child: CircularProgressIndicator());
                      } else  if (state is ApiSuccess<ProjectAreasResponse, ResponseModel>) {
                        ProjectAreasResponse areaList = state.data;
                        return Expanded(
                          child: ListView.builder(
                            // controller: _scrollController,
                            itemCount: areaList.data.length, // Number of projects
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  AppRoute.goToNextPage(
                                      context: context,
                                      screen: ProjectActionScreen.route,
                                      arguments: {
                                        'projectId':areaList.data[index].projectId,
                                        'projectAreaId':areaList.data[index].id
                                      });
                                },
                                child: ProjectAreaCard(
                                  title: areaList.data[index].name,
                                  subtitle: areaList.data[index].type,
                                  location:
                                      areaList.data[index].locationDescription,
                                  taskCount: areaList.data[index].capacity,
                                  latitude: areaList.data[index].centroid.latitude,
                                  longitude: areaList.data[index].centroid.longitude,
                                  todayTasks: areaList.data[index].todayTasks
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return const Center(
                          child: Text(
                            "No staff found",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
/*
class ProjectAreaCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String location;
  final int taskCount;
  final double latitude;
  final double longitude;
  final List<TodayTask> todayTasks;

  const ProjectAreaCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.location,
    required this.taskCount,
    required this.latitude,
    required this.longitude,
    required this.todayTasks
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.white,
      // margin: EdgeInsets.only(bottom: 10.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 HEADER SECTION
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// ICON CONTAINER
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F1FC), // soft blue background
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    Images.areaIcon,
                    color: const Color(0xFF2C4A66), // dark navy icon
                  ),
                ),
                const SizedBox(width: 12),

                /// TITLE + SUBTITLE
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                /// 📍 DIRECTION ICON
                InkWell(
                  onTap: () {
                    openGoogleMaps(lat: 19.2183, lng: 72.9781);
                    // TODO: Handle directions tap
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEFCF3), //Color(0xFFE7F1FC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.directions_outlined,
                      size: 24,
                        color: AppColor.primaryDark
                      // color: Color(0xFF2C4A66), // dark navy
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 0.4),

          /// 🔹 FOOTER SECTION
          Container(
            decoration: const BoxDecoration(
              // color: Color(0xFFE7F1FC),
              color: const Color(0xFFFEFCF3),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Text(
                  "today tasks",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColor.primaryDark//Color(0xFF2C4A66),
                  ),
                ),
                const Spacer(),

                /// ✅ SOFT BADGE STYLE FOR LARGE COUNTS
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColor.error,
                  //  color: const Color(0xFF2C4A66), // dark navy badge
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _formatCount(taskCount),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
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

  /// 🔹 Format large numbers like 30k, 12.5k
  String _formatCount(int count) {
    if (count >= 1000000) return "${(count / 1000000).toStringAsFixed(1)}M";
    if (count >= 1000) return "${(count / 1000).toStringAsFixed(1)}k";
    return count.toString();
  }


  Future<void> openGoogleMaps({double? lat, double? lng, String? query}) async {
    String googleMapsUrl;

    if (lat != null && lng != null) {
      // Open coordinates directly
      googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
    } else if (query != null) {
      // Search by location name
      googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}";
    } else {
      throw "Either lat/lng or query is required!";
    }

    final Uri uri = Uri.parse(googleMapsUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch Google Maps";
    }
  }
}

 */
class ProjectAreaCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String location;
  final int taskCount;
  final double latitude;
  final double longitude;
  final List<TodayTask> todayTasks;

  const ProjectAreaCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.location,
    required this.taskCount,
    required this.latitude,
    required this.longitude,
    required this.todayTasks
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 HEADER SECTION
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// ICON CONTAINER
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F1FC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    Images.areaIcon,
                    color: const Color(0xFF2C4A66),
                  ),
                ),
                const SizedBox(width: 12),

                /// TITLE + SUBTITLE
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                /// 📍 DIRECTION ICON
                InkWell(
                  onTap: () {
                    openGoogleMaps(lat: latitude, lng: longitude);
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFEFCF3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.directions_outlined,
                      size: 24,
                      color: AppColor.primaryDark,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 0.4),

          /// 🔹 TODAY TASKS SECTION
          if (todayTasks.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Today's Tasks",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColor.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// TASKS LIST
                  ...todayTasks.map((task) => _buildTaskItem(task)).toList(),

                  const SizedBox(height: 8),

                  /// SUMMARY ROW
                  _buildSummaryRow(),
                ],
              ),
            ),
          ] else ...[
            /// 🔹 EMPTY STATE
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFEFCF3),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.task_alt_outlined,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "No tasks scheduled for today",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 🔹 INDIVIDUAL TASK ITEM
  Widget _buildTaskItem(TodayTask task) {
    final progress = task.expectedToday > 0
        ? (task.completedToday / task.expectedToday).clamp(0.0, 1.0)
        : 0.0;

    final isCompleted = task.completedToday >= task.expectedToday;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted
              ? const Color(0xFF4CAF50).withOpacity(0.3)
              : Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          /// TASK HEADER
          Row(
            children: [
              /// SERVICE TYPE ICON
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _getServiceTypeColor(task.serviceType).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getServiceTypeIcon(task.serviceType),
                  size: 18,
                  color: _getServiceTypeColor(task.serviceType),
                ),
              ),
              const SizedBox(width: 12),

              /// SERVICE TYPE AND PROGRESS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.serviceType,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${task.completedToday}/${task.expectedToday} trees",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              /// STATUS INDICATOR
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? const Color(0xFF4CAF50)
                      : task.completedToday > 0
                      ? const Color(0xFFFF9800)
                      : Colors.grey[400],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isCompleted
                      ? "Done"
                      : task.completedToday > 0
                      ? "In Progress"
                      : "Pending",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// PROGRESS BAR
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Calculate progress width with minimum 2px for visibility
                double progressWidth = constraints.maxWidth * progress.clamp(0.0, 1.0);
                if (task.completedToday > 0 && progressWidth < 2) {
                  progressWidth = 2; // Minimum visible width
                }

                return Stack(
                  children: [
                    if (progressWidth > 0)
                      Container(
                        width: progressWidth,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? const Color(0xFF4CAF50)
                              : task.completedToday > 0
                              ? const Color(0xFFFF9800)
                              : const Color(0xFF6B7280),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),

        ],
      ),
    );
  }

  /// 🔹 SUMMARY ROW
  Widget _buildSummaryRow() {
    final totalExpected = todayTasks.fold<int>(0, (sum, task) => sum + task.expectedToday);
    final totalCompleted = todayTasks.fold<int>(0, (sum, task) => sum + task.completedToday);
    final overallProgress = totalExpected > 0 ? (totalCompleted / totalExpected) : 0.0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 20,
            color: AppColor.primaryDark,
          ),
          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Overall Progress",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "$totalCompleted of $totalExpected trees",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          /// CIRCULAR PROGRESS
          SizedBox(
            width: 40,
            height: 40,
            child: Stack(
              children: [
                CircularProgressIndicator(
                  value: overallProgress,
                  strokeWidth: 3,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    overallProgress >= 1.0
                        ? const Color(0xFF4CAF50)
                        : overallProgress > 0
                        ? const Color(0xFFFF9800)
                        : Colors.grey[400]!,
                  ),
                ),
                Center(
                  child: Text(
                    "${(overallProgress * 100).round()}%",
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
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

  /// 🔹 GET SERVICE TYPE ICON
  IconData _getServiceTypeIcon(String serviceType) {
    switch (serviceType.toLowerCase()) {
      case 'plantation':
        return Icons.park_outlined;
      case 'maintenance':
        return Icons.build_outlined;
      case 'monitoring':
        return Icons.visibility_outlined;
      default:
        return Icons.task_outlined;
    }
  }

  /// 🔹 GET SERVICE TYPE COLOR
  Color _getServiceTypeColor(String serviceType) {
    switch (serviceType.toLowerCase()) {
      case 'plantation':
        return const Color(0xFF4CAF50); // Green
      case 'maintenance':
        return const Color(0xFF2196F3); // Blue
      case 'monitoring':
        return const Color(0xFFFF9800); // Orange
      default:
        return AppColor.primaryDark;
    }
  }

  /// 🔹 Format large numbers like 30k, 12.5k
  String _formatCount(int count) {
    if (count >= 1000000) return "${(count / 1000000).toStringAsFixed(1)}M";
    if (count >= 1000) return "${(count / 1000).toStringAsFixed(1)}k";
    return count.toString();
  }

  Future<void> openGoogleMaps({double? lat, double? lng, String? query}) async {
    String googleMapsUrl;

    if (lat != null && lng != null) {
      googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
    } else if (query != null) {
      googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}";
    } else {
      throw "Either lat/lng or query is required!";
    }

    final Uri uri = Uri.parse(googleMapsUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch Google Maps";
    }
  }
}





