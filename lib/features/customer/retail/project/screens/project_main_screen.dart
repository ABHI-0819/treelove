/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:treelove/core/config/themes/app_color.dart';
import 'package:treelove/core/config/themes/app_fonts.dart';

import '../../../../../core/config/resource/images.dart';
String selectedLocation = 'Himachal';
class ProjectMainScreen extends StatefulWidget {


  @override
  State<ProjectMainScreen> createState() => _ProjectMainScreenState();
}

class _ProjectMainScreenState extends State<ProjectMainScreen> {
  final List<String> locations = [
    'Himachal', 'Arunachal', 'Mumbai', 'Hyderabad',
    'Meghalaya', 'Chennai', 'Assam', 'Nagpur'
  ];



  final List<Map<String, dynamic>> projects = [
    {'title': 'Great Himalayan National Park', 'isHighlighted': true},
    {'title': 'Manali wildlife sanctuary'},
    {'title': 'Chail Wildlife Sanctuary'},
    {'title': 'Chail Wildlife Sanctuary'},
    {'title': 'Kugti Wildlife Sanctuary'},
    {'title': 'Chail Wildlife Sanctuary'},
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Images.homeBgImg),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSearchBar(),
              // _buildTopBar(),
              _buildLocationChips(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Popular projects',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'Available projects(23)',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    )
                  ],
                ),
              ),
              Expanded(child: _buildProjectGrid())
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: locations.map((location) {
          final bool isSelected = location == selectedLocation;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedLocation = location;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected ? AppColor.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white),
              ),
              child: Text(
                location,
                style: TextStyle(color: isSelected ? Colors.white : Colors.white.withOpacity(0.8)),
              ),
            ),
          );
        }).toList(),
      )
    );
  }

  Widget _buildProjectGrid() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: projects.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (context, index) {
          final project = projects[index];
          final isHighlighted = project['isHighlighted'] == true;

          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade800,
                  image: isHighlighted
                      ? const DecorationImage(
                    image: AssetImage(Images.sampleImg),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(Images.projectIcon,color: AppColor.white,),
                        // const Icon(Icons.nature, color: Colors.white, size: 16),
                        const Icon(Icons.favorite_border, color: Colors.white, size: 16),
                        const Icon(Icons.bookmark_border, color: Colors.white, size: 16),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      project['title'],
                      style:AppFonts.body.copyWith(
                      color: Colors.white.withOpacity(isHighlighted ? 1.0 : 0.6),
                        fontWeight: FontWeight.w500,
                      )
                    ),
                    if (isHighlighted)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'See more',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}


class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
      decoration: BoxDecoration(
          color: Color(0xFFF6F1DE),

          borderRadius: BorderRadius.circular(25.r)
      ),
      child: Row(
        children: [
          // Hamburger Menu Icon
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.menu, size: 20),
          ),
          SizedBox(width: 12),
          // Search Text
          Expanded(
            child: Text(
                '${selectedLocation}',
                style: AppFonts.body.copyWith(
                    color: AppColor.black,
                    fontWeight: FontWeight.w500
                )
            ),
          ),
          // Notification Bell Icon
          CircleAvatar(
            backgroundColor: AppColor.white,// Color(0xFFF7F2E8),
            radius:18,
            child: SvgPicture.asset(Images.profileIcon),
          ),
        ],
      ),
    );
  }
}

 */
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/bloc/api_event.dart';
import '../../../../../common/bloc/api_state.dart';
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
import '../../../../vendor/home/screens/home_screen.dart';
import '../../home/screens/location_selection_screen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String selectedTab = 'All'; // status filter: 'active', 'draft', 'completed'
  String? selectedCategory;   // category filter: 'government', 'treelov', etc.

  late ProjectListBloc projectListBloc;
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;

  @override
  void initState() {
    projectListBloc = ProjectListBloc(ProjectRepository(api: ApiConnection()));
    projectListBloc.add(ApiListFetch(type: 'public'));//public,private
    _scrollController.addListener(_scrollListener);
    super.initState();
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

  void _loadNextPage() {
    debugLog('Loading page ${_currentPage + 1}', name: "Pagination");
    _currentPage++;
    projectListBloc.add(ApiListFetch(
      category: selectedCategory,
      type: 'public',
      page: _currentPage,
    ));
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
                onTap: () {
                  // Optional: Reset all filters
                  setState(() {
                    selectedTab = 'All';
                    selectedCategory = null;
                    _currentPage = 1;
                    projectListBloc.add(ApiListFetch(page: 1,type: 'public'));
                  });
                },
                child: Icon(
                  Icons.filter_list,
                  color: AppColor.black,
                ),
              ),
            )
          ],
        ),
      ),
      body: BlocProvider.value(
        value: projectListBloc,
        child: Column(
          children: [
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: TextField(
                style: const TextStyle(fontSize: 14),
                onSubmitted: (value) {
                  setState(() {
                    _currentPage = 1;
                    projectListBloc.add(ApiListFetch(
                      search: value,
                      filter: selectedTab == 'All' ? null : selectedTab,
                      category: selectedCategory,
                      page: 1,
                    ));
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
            /*
            // Status Tabs
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
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

             */
            // Category Tabs
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryTab('All', null),
                    _buildCategoryTab('Government', 'government'),
                    _buildCategoryTab('TreeLov', 'treelov'),
                    _buildCategoryTab('Farmer', 'farmer'),
                    _buildCategoryTab('NGO', 'ngo'),
                  ],
                ),
              ),
            ),
            // Project List
            Expanded(
              child: BlocListener<ProjectListBloc,
                  ApiState<ProjectListResponse, ResponseModel>>(
                listener: (context, state) {
                  EasyLoading.dismiss();
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
                          return Card(
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

  Widget _buildTab(String label, String? value) {
    bool isSelected = selectedTab == (value ?? 'All');
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = value?.toString() ?? 'All';
          _currentPage = 1;
          projectListBloc.add(ApiListFetch(
            filter: value,
            category: selectedCategory,
            page: 1,
          ));
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF1A5F3E) : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTab(String label, String? categoryValue) {
    bool isSelected = selectedCategory == categoryValue;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = categoryValue;
          _currentPage = 1;
          projectListBloc.add(ApiListFetch(
            filter: selectedTab == 'All' ? null : selectedTab,
            category: categoryValue,
            page: 1,
          ));
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1A5F3E).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1A5F3E)
                : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF1A5F3E) : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}


class Card extends StatelessWidget {
  final ProjectItem projectItem;
  const Card({super.key, required this.projectItem});

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
          AppRoute.goToNextPage(context: context, screen: MapScreen.route, arguments: {
            'projectId':projectItem.id,
          });
          // AppRoute.goToNextPage(
          //     context: context,
          //     screen: ProjectDetailScreen.route,
          //     arguments: {'projectId': projectItem.id});
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
        return Icons.satellite_alt;
    }
  }
}