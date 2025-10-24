import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treelove/common/bloc/api_state.dart';

import '../../../../../common/bloc/api_event.dart';
import '../../../../../common/models/response.mode.dart';
import '../../../../../common/repositories/project_repository.dart';
import '../../../../../core/config/route/app_route.dart';
import '../../../../../core/config/themes/app_color.dart';
import '../../../../../core/config/themes/app_fonts.dart';
import '../../../../../core/network/api_connection.dart';
import '../../../../../core/utils/logger.dart';
import '../../../../../core/widgets/common_notification.dart';
import '../../../../authentication/screens/sign_in_screen.dart';
import '../../../../vendor/home/bloc/project_bloc.dart';
import '../../../../vendor/home/models/project_list_model.dart';
import '../../home/screens/location_selection_screen.dart';



class ProjectTemplateScreen extends StatefulWidget {
  static const route ='/project-template';
  final String title;
  final String? category; // e.g., 'government', 'farmer', or null for all

  const ProjectTemplateScreen({
    super.key,
    required this.title,
    this.category,
  });

  @override
  State<ProjectTemplateScreen> createState() => _ProjectTemplateScreenState();
}

class _ProjectTemplateScreenState extends State<ProjectTemplateScreen> {
  late ProjectListBloc projectListBloc;
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    projectListBloc = ProjectListBloc(ProjectRepository(api: ApiConnection()));
    _loadProjects(page: 1);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    projectListBloc.close();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadNextPage();
    }
  }

  void _loadProjects({required int page, String? search}) {
    projectListBloc.add(ApiListFetch(
      search: search,
      category: widget.category,
      type: 'public',
      page: page,
    ));
  }

  void _loadNextPage() {
    debugLog('Loading page ${_currentPage + 1}', name: "Pagination");
    _currentPage++;
    _loadProjects(page: _currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0.5,
        automaticallyImplyLeading: true, // Show back button
        toolbarHeight: 64,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColor.black,
          ),
        ),
      ),
      body: BlocProvider.value(
        value: projectListBloc,
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: TextField(
                style: const TextStyle(fontSize: 14),
                onSubmitted: (value) {
                  setState(() {
                    _currentPage = 1;
                    _loadProjects(page: 1, search: value);
                  });
                },
                decoration: InputDecoration(
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  hintText: 'Search project',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: const Icon(Icons.search, size: 20),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFF1A5F3E),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            // Project List
            Expanded(
              child: BlocListener<ProjectListBloc,
                  ApiState<ProjectListResponse, ResponseModel>>(
                listener: (context, state) {
                  // EasyLoading.dismiss(); // Uncomment if you use easy_loading
                  if (state is ApiFailure<ProjectListResponse, ResponseModel>) {
                    showNotification(
                        context, message: state.error.message.toString());
                  } else if (state is TokenExpired<
                      ProjectListResponse, ResponseModel>) {
                    AppRoute.pushReplacement(
                        context, SignInScreen.route, arguments: {});
                  }
                },
                child: BlocBuilder<ProjectListBloc,
                    ApiState<ProjectListResponse, ResponseModel>>(
                  builder: (context, state) {
                    if (state is ApiLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ApiSuccess<
                        ProjectListResponse, ResponseModel>) {
                      final projectData = state.data;
                      if (projectData.data.isEmpty) {
                        return const Center(
                          child: Text(
                            "No projects found",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        );
                      }
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: projectData.data.length,
                        itemBuilder: (context, index) {
                          return _ProjectCard(
                            projectItem: projectData.data[index],
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text(
                          "No projects found",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reuse your existing ProjectCard (just renamed from "Card" to avoid conflict)
class _ProjectCard extends StatelessWidget {
  final ProjectItem projectItem;
  const _ProjectCard({super.key, required this.projectItem});

  static const Map<String, Color> serviceTagColors = {
    "Geo-tagging": Color(0xFFFCE8E8),
    "Maintenance": Color(0xFFE6F3FB),
    "Monitoring": Color(0xFFEAEAFD),
    "Plantation": Color(0xFFE8F8E8),
  };

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
            screen: MapScreen.route,
            arguments: {'projectId': projectItem.id},
          );
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
                        projectItem.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        projectItem.category,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                          'Thane, Mumbai',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'Due: ${projectItem.endDate}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
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
        children: [
          Icon(
            _getIcon(text),
            size: 18,
            color: Colors.black54,
          ),
          const SizedBox(width: 6),
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
        return Icons.satellite_alt;
    }
  }
}