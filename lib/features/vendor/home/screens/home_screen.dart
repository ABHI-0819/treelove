import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treelove/common/screens/notification_screen.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/core/config/themes/app_color.dart';
import 'package:treelove/core/config/themes/app_fonts.dart';
import 'package:treelove/features/vendor/home/bloc/project_bloc.dart';
import 'package:treelove/features/vendor/home/screens/project_detail_screen.dart';

import '../../../../common/bloc/api_event.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../common/repositories/project_repository.dart';
import '../../../../core/network/api_connection.dart';
import '../../../../core/widgets/common_notification.dart';
import '../../../authentication/screens/sign_in_screen.dart';
import '../models/project_list_model.dart';

class HomeScreen extends StatefulWidget {
  static const route = '/vendor-home-screen'; // Define the route name

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ProjectListBloc
      _projectListBloc; // Use late final for bloc initialized in initState

  @override
  void initState() {
    super.initState();
    // Initialize the BLoC with its dependencies
    _projectListBloc = ProjectListBloc(ProjectRepository(api: ApiConnection()));
    // Trigger the API call to fetch active projects
    _projectListBloc.add(ApiListFetch(filter: 'active'));
  }

  @override
  void dispose() {
    // Important: Close the BLoC stream to prevent memory leaks
    _projectListBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: BlocProvider<ProjectListBloc>.value(
        // Use .value since bloc is created in initState
        value: _projectListBloc,
        child: SafeArea(
           maintainBottomViewPadding : true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _HeaderSection(),
              const _StatsSection(),
              const SizedBox(height: 16),
              // Expanded widget to take remaining vertical space for the project list
              Expanded(
                  child: _ProjectListSection(projectListBloc: _projectListBloc)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget responsible for displaying the list of projects using BLoC.
class _ProjectListSection extends StatelessWidget {
  final ProjectListBloc projectListBloc;

  const _ProjectListSection({required this.projectListBloc});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProjectListBloc,
        ApiState<ProjectListResponse, ResponseModel>>(
      // Listen for BLoC state changes
      listener: (context, state) {
        EasyLoading.dismiss();
        if (state is ApiFailure<ProjectListResponse, ResponseModel>) {
          showNotification(context,
              message: state.error.message ?? "An error occurred");
        } else if (state is TokenExpired<ProjectListResponse, ResponseModel>) {
          AppRoute.pushReplacement(context, SignInScreen.route, arguments: {});
        }
      },
      child: BlocBuilder<
          ProjectListBloc, // Build UI based on BLoC state
          ApiState<ProjectListResponse, ResponseModel>>(
        builder: (context, state) {
          if (state is ApiLoading<ProjectListResponse, ResponseModel>) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ApiSuccess<ProjectListResponse, ResponseModel>) {
            final projectData = state.data;
            final projects = projectData.data; // Get the list of projects

            if (projects.isEmpty) {
              return const Center(
                child: Text(
                  "No ongoing projects found.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Ongoing projects (${projects.length})',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Expanded(
                  child: ListView.builder(
                    itemCount: projects.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: ProjectCard(projectItem: projects[index]),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            final errorMessage =
                state is ApiFailure<ProjectListResponse, ResponseModel>
                    ? state.error.message ?? "Failed to load projects."
                    : "Unable to load projects.";
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    errorMessage,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  if (state
                      is ApiFailure) // Add retry button only on explicit failure
                    TextButton(
                      onPressed: () {
                        projectListBloc.add(ApiListFetch(filter: 'active'));
                      },
                      child: const Text('Retry'),
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

/// Widget for the header section containing greeting and notification icon.
class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0B5E42), Color(0xFF196D54)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: EdgeInsets.all(16.r), // Use ScreenUtil for responsive padding
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Flexible(
              // Use Flexible to prevent overflow
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello Yash 🙂', // Consider making this dynamic based on user data
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis, // Handle long names
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: (){
                AppRoute.goToNextPage(context: context, screen: NotificationsScreen.route, arguments: {});
              },
              child: Icon(
                Icons.notifications,
                color: Colors.white,
                size: 24.r, // Responsive icon size
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// Widget for the statistics section displaying ongoing and upcoming projects.
class _StatsSection extends StatelessWidget {
  const _StatsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF196D54),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          _StatBox(
              title: 'Ongoing Projects',
              value: '02'), // Consider making these dynamic
          _StatBox(title: 'Upcoming Projects', value: '00'),
        ],
      ),
    );
  }
}

/// Widget for displaying individual statistic boxes.
class _StatBox extends StatelessWidget {
  final String title;
  final String value;

  const _StatBox({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize:
          MainAxisSize.min, // Prevent row from expanding unnecessarily
      children: [
        Container(
          width: 2,
          height: 65.h, // Thickness of the line, responsive height
          color: const Color(0xFF00FF00), // Color of the line
        ),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: 8.w, vertical: 15.h), // Responsive padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Prevent column from expanding
            spacing: 5.h, // Responsive spacing
            children: [
              Text(
                value,
                style: AppFonts.regular.copyWith(
                  // Assuming AppFonts is defined
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                title,
                style: AppFonts.caption.copyWith(
                  // Assuming AppFonts is defined
                  color: AppColor.white, // Assuming AppColor is defined
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class ProjectCard extends StatelessWidget {
  final ProjectItem projectItem;
  const ProjectCard({required this.projectItem});

  /// ✅ Service → Color Mapping
  static const Map<String, Color> serviceTagColors = {
    "Geo-tagging": Color(0xFFFCE8E8),
    "Maintenance": Color(0xFFE6F3FB),
    "Monitoring": Color(0xFFEAEAFD),
    "Plantation": Color(0xFFE8F8E8),
  };

  /// ✅ Get color safely (fallback: light grey)
  Color _getServiceColor(String service) {
    return serviceTagColors[service] ?? const Color(0xFFEDEDED);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: InkWell(
        onTap: () {
          AppRoute.goToNextPage(
              context: context,
              screen: ProjectDetailScreen.route,
              arguments: {'projectId': projectItem.id});
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10.h,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(projectItem.image.toString()),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // 'Thane Plantation Drive 2023',
                        projectItem.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(projectItem.category,
                          style: TextStyle(fontSize: 12)),
                    ],
                  )
                ],
              ),
              Container(
                height: 0.4, // Thickness of the line
                color: Colors.grey, // Color of the line
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text('Thane, Mumbai', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text('Due: ${projectItem.endDate}',
                          style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ],
              ),

              /// ✅ Tags
              /// ✅ Dynamic Tags with Specific Colors
              Wrap(
                spacing: 15,
                runSpacing: 10,
                children: projectItem.serviceTypes.map((service) {
                  return _ProjectTag(
                    text: service,
                    color: _getServiceColor(service),
                  );
                }).toList(),
              ),
              /*
              Wrap(
                spacing: 20.w,
                runSpacing: 10.h,
                children: [
                  _ProjectTag(text: 'Geo-tagging', color: Color(0xFFFCE8E8)),
                  _ProjectTag(text: 'Maintenance', color: Color(0xFFE6F3FB)),
                  _ProjectTag(text: 'Monitoring', color: Color(0xFFEAEAFD)),
                ],
              )

               */
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
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 10.w,
        children: [
          Icon(
            _getIcon(text),
            size: 18,
            color: Colors.black54,
          ),
          Text(
            text,
            style: AppFonts.caption,
          ),
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
