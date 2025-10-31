import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treelove/common/repositories/project_repository.dart';
import 'package:treelove/core/network/api_connection.dart';
import 'package:treelove/features/customer/b2b/projects/screens/project_detail_screen.dart';

import '../../../../../common/bloc/api_event.dart';
import '../../../../../common/bloc/api_state.dart';
import '../../../../../common/models/response.mode.dart';
import '../../../../../core/config/route/app_route.dart';
import '../../../../../core/config/themes/app_color.dart';
import '../../../../../core/config/themes/app_fonts.dart';
import '../../../../../core/utils/logger.dart';
import '../../../../../core/widgets/common_notification.dart';
import '../../../../authentication/screens/sign_in_screen.dart';
import '../../../../vendor/home/bloc/project_bloc.dart';
import '../../../../vendor/home/models/project_list_model.dart';
import '../../../../vendor/home/screens/home_screen.dart';

class B2BProjectScreen extends StatefulWidget {
  const B2BProjectScreen({super.key});

  @override
  State<B2BProjectScreen> createState() => _B2BProjectScreenState();
}

class _B2BProjectScreenState extends State<B2BProjectScreen> {
  String? selectedTab;

  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;

  late ProjectListBloc projectListBloc;

  @override
  void initState() {
    projectListBloc = ProjectListBloc(ProjectRepository(api:ApiConnection()));
    projectListBloc.add(ApiListFetch());
    // TODO: implement initState
    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Load next page when scrolled to bottom
      _loadNextPage();
    }
  }

  void _loadNextPage() {
    debugLog('${_currentPage++}',name: "checking scrolling");
    _currentPage++;
    projectListBloc.add(ApiListFetch(page: _currentPage));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar:AppBar(
        backgroundColor: AppColor.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        toolbarHeight: 64, // Slightly taller for a modern look
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Projects',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColor.black,
              ),
            ),
            GestureDetector(
              onTap: () {
                // Add filter action
              },
              child: Icon(Icons.filter_list),
            )
          ],
        ),
      ),

      body: BlocProvider(
  create: (context) => projectListBloc,
  child: Column(
        children: [
          SizedBox(
            height: 5.h,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Search Field
                Expanded(
                  child: TextField(
                    style: const TextStyle(fontSize: 14),
                    onSubmitted: (value){
                      projectListBloc.add(ApiListFetch(search: value));
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
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
                        borderSide: const BorderSide(color: Color(0xFF1A5F3E), width: 1.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Tabs
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w,vertical: 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTab('All', null),
                _buildTab('Ongoing', 'Ongoing'),
                _buildTab('Completed', 'Completed'),
              ],
            ),
          ),
            /// TODO: list of projects
          BlocListener<ProjectListBloc,
              ApiState<ProjectListResponse, ResponseModel>>(
            listener: (context, state) {
              EasyLoading.dismiss();
              if (state is ApiFailure<ProjectListResponse, ResponseModel>) {
                showNotification(
                    context, message: state.error.message.toString());
              } else
              if (state is TokenExpired<ProjectListResponse, ResponseModel>) {
                AppRoute.pushReplacement(
                    context, SignInScreen.route, arguments: {});
              }
            },
            child: BlocBuilder<ProjectListBloc,
                ApiState<ProjectListResponse, ResponseModel>>(
              builder: (context, state) {
                if(state is ApiLoading){
                  return SafeArea(child: Center(child: CircularProgressIndicator()));
                } else if (state is ApiSuccess<ProjectListResponse, ResponseModel>) {
                  ProjectListResponse projectData = state.data;

                  return Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: projectData.data.length, // Number of projects
                      itemBuilder: (context, index) {
                        return ProjectB2BCard(
                          projectItem: projectData.data[index],
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      "No Project found",
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
    );
  }

  // Reusable Tab Widget
  Widget _buildTab(String label, String ? value) {
    bool isSelected = selectedTab == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = value;
          projectListBloc.add(ApiListFetch(filter: value));
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Text(
            label,
            style: AppFonts.body.copyWith(
              color: isSelected ? Color(0xFF1A5F3E) : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            )
        ),
      ),
    );
  }
}


/*
      appBar:AppBar(
      automaticallyImplyLeading: false, // disable default
      backgroundColor: const Color(0xFF1A5F3E),
      title: Text(
        'Projects',
        style: AppFonts.regular.copyWith(
          color: AppColor.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

       */

// Project Cards
/*
          Expanded(
            child: ListView.builder(
              // padding: EdgeInsets.all(16),
              itemCount: 2, // Number of projects
              itemBuilder: (context, index) {
                return ProjectCard();
              },
            ),
          ),

           */

// Project Cards
/*
          Expanded(
            child: ListView.builder(
              // padding: EdgeInsets.all(16),
              itemCount: 2, // Number of projects
              itemBuilder: (context, index) {
                return ProjectCard();
              },
            ),
          ),

           */

class ProjectB2BCard extends StatelessWidget {
  final ProjectItem projectItem;
  const ProjectB2BCard({required this.projectItem});

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
              screen: ProjectB2BDetailsScreen.route,
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