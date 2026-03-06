import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treelove/common/bloc/api_event.dart';
import 'package:treelove/common/bloc/api_state.dart';
import 'package:treelove/common/repositories/project_repository.dart';
import 'package:treelove/core/config/themes/app_color.dart';
import 'package:treelove/core/config/themes/app_fonts.dart';
import 'package:treelove/core/network/api_connection.dart';
import 'package:treelove/core/utils/logger.dart';
import 'package:treelove/features/vendor/home/bloc/project_bloc.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../core/widgets/common_notification.dart';
import '../../../../core/widgets/project_list_shimmer.dart';
import '../models/project_list_model.dart';
import 'home_screen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String? selectedTab;

  late ProjectListBloc projectListBloc;

  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;

  @override
  void initState() {
    projectListBloc = ProjectListBloc(ProjectRepository(api: ApiConnection()));
    projectListBloc.add(ApiListFetch());
    _scrollController.addListener(_scrollListener);
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
    debugLog('${_currentPage++}', name: "checking scrolling");
    _currentPage++;
    projectListBloc.add(ApiListFetch(page: _currentPage));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        toolbarHeight: 64,
        // Slightly taller for a modern look
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
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                child: Icon(
                  Icons.filter_list,
                ),
              ),
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
                      onSubmitted: (value) {
                        projectListBloc.add(ApiListFetch(search: value));
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 12),
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
                              color: Color(0xFF1A5F3E), width: 1.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Tabs
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTab('All', null),
                  _buildTab('Ongoing', 'active'),
                  _buildTab('Upcoming', 'draft'),
                  _buildTab('Completed', 'completed'),
                ],
              ),
            ),

            // Project Cards

            BlocListener<ProjectListBloc,
                ApiState<ProjectListResponse, ResponseModel>>(
              listener: (context, state) {
                EasyLoading.dismiss();
                if (state is ApiFailure<ProjectListResponse, ResponseModel>) {
                  showNotification(context,
                      message: state.error.message.toString());
                } /* else
                if (state is TokenExpired<ProjectListResponse, ResponseModel>) {
                  AppRoute.pushReplacement(
                      context, SignInScreen.route, arguments: {});
                }
                */
              },
              child: BlocBuilder<ProjectListBloc,
                  ApiState<ProjectListResponse, ResponseModel>>(
                builder: (context, state) {
                  if (state is ApiLoading) {
                    return const ProjectListShimmer();
                  } else if (state
                      is ApiSuccess<ProjectListResponse, ResponseModel>) {
                    ProjectListResponse projectData = state.data;

                    return Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount:
                            projectData.data.length, // Number of projects
                        itemBuilder: (context, index) {
                          return ProjectCard(
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
  Widget _buildTab(String label, String? value) {
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
        child: Text(label,
            style: AppFonts.body.copyWith(
              color: isSelected ? Color(0xFF1A5F3E) : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            )),
      ),
    );
  }
}
