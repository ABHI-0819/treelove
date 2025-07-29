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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120.h),
        child: Container(
          height: 100.h,
          padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0B5B4D), Color(0xFF0E6655)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Hello John 😊',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => projectAreaBloc,
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 15.h),
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
                                latitude: areaList.data[index].centroid[1],
                                longitude: areaList.data[index].centroid[0],
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
              /*
              InkWell(
                onTap: () {
                  AppRoute.goToNextPage(context: context,
                      screen: ProjectActionScreen.route,
                      arguments: {});
                },
                child: ProjectAreaCard(
                  title: 'Thane Plantation Drive 2023',
                  subtitle: 'Jio Platforms',
                  location: 'Thane, Mumbai',
                  taskCount: 15,
                ),
              ),
              const SizedBox(height: 12),
              ProjectAreaCard(
                title: 'Mumbai Metro Line 1',
                subtitle: 'Jio Platforms',
                location: 'Thane, Mumbai',
                taskCount: 20,
              ),

               */
            ],
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

  const ProjectAreaCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.location,
    required this.taskCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: AppColor.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  // spacing inside the background
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEFCF3), // background color
                    borderRadius:
                        BorderRadius.circular(8.r), // rounded rectangle
                  ),
                  child: SvgPicture.asset(Images.areaIcon),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16)),
                      Text(subtitle,
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 14)),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE7F1FC),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Text(
                  "Total tasks",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                // ✅ Pill-shaped badge for large count
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$taskCount',
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
}

 */
class ProjectAreaCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String location;
  final int taskCount;
  final double latitude;
  final double longitude;

  const ProjectAreaCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.location,
    required this.taskCount,
    required this.latitude,
    required this.longitude
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
                  "Total tasks",
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


