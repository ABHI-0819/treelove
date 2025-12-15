import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:treelove/core/config/themes/app_color.dart';

import '../../../../../common/bloc/api_event.dart';
import '../../../../../common/bloc/api_state.dart';
import '../../../../../common/models/response.mode.dart';
import '../../../../../common/repositories/project_repository.dart';
import '../../../../../core/config/resource/images.dart';
import '../../../../../core/config/route/app_route.dart';
import '../../../../../core/network/api_connection.dart';
import '../../../../../core/widgets/common_notification.dart';
import '../../../../authentication/screens/sign_in_screen.dart';
import '../../../../vendor/home/bloc/project_bloc.dart';
import '../../../../vendor/home/models/project_list_model.dart';
import '../../home/screens/location_selection_screen.dart';

class ProjectOverviewSection extends StatefulWidget {
  final String category;
  const ProjectOverviewSection({super.key,required this.category});

  @override
  State<ProjectOverviewSection> createState() => _ProjectOverviewSectionState();
}

class _ProjectOverviewSectionState extends State<ProjectOverviewSection> {
  late ProjectListBloc projectListBloc;

  @override
  void initState() {
    super.initState();
    projectListBloc = ProjectListBloc(ProjectRepository(api: ApiConnection()));
    projectListBloc.add(ApiListFetch(type: 'public', page: 1, pageSize: 2,category: widget.category));
  }

  @override
  void dispose() {
    projectListBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => projectListBloc,
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
                return Center(child: _buildEmptyState());
              }
              // ✅ Fixed: Using ListView for horizontal scrolling with proper spacing
              return SizedBox(
                height: 180.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  // padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: projectData.data.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 160.h,
                      width: MediaQuery.of(context).size.width * 0.4, // 45% of screen width
                      child: ProjectCategoryCard(
                        imageUrl: projectData.data[index].image.toString(),
                        title: projectData.data[index].name,
                        onTap: () {
                          AppRoute.goToNextPage(
                            context: context,
                            screen: MapScreen.route,
                            arguments: {
                              'projectId': projectData.data[index].id,
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            } else {
              return _buildEmptyState();
            }
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      color: const Color(0xFFF8F4E3),
      padding: const EdgeInsets.all(32),
      child:  Center(
        child: Column(
          children: [
            SvgPicture.asset(Images.projectIcon,
              width: 48,
              height: 48,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No projects found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///  Reusable Project Category Card
class ProjectCategoryCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final VoidCallback? onTap;

  const ProjectCategoryCard({
    super.key,
    required this.imageUrl,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ✅ Fixed: Using Image.network instead of Image.asset for URL images
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 50),
                  );
                },
              ),

              // Gradient Overlay (darker at bottom for text readability)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.7),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),

              // Text Content at Bottom
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///  Project Section Widget (for each category)
class ProjectCategorySection extends StatelessWidget {
  final String sectionTitle;
  final String category;
  final VoidCallback? onSeeAllTap;

  const ProjectCategorySection({
    super.key,
    required this.sectionTitle,
    required this.category,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionTitle,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF222222),
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: onSeeAllTap,
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF222222),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ProjectOverviewSection(
            category: category,
          )
        ],
      ),
    );
  }
}


