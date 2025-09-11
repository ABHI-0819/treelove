import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treelove/core/network/base_network.dart';
import 'package:treelove/features/fieldworker/home/screens/monitor_activity_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/bloc/api_event.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/planted.list.response.model.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../common/repositories/plantation_repository.dart';
import '../../../../core/config/resource/images.dart';
import '../../../../core/config/route/app_route.dart';
import '../../../../core/config/themes/app_color.dart';
import '../../../../core/config/themes/app_fonts.dart';
import '../../../../core/network/api_connection.dart';
import '../../../../core/widgets/common_notification.dart';
import '../../../authentication/screens/sign_in_screen.dart';
import '../../../vendor/home/bloc/map_bloc.dart';

class TreeMonitorListScreen extends StatefulWidget {
  static const route = '/tree-monitor-list';

  const TreeMonitorListScreen({super.key});

  @override
  State<TreeMonitorListScreen> createState() => _TreeMonitorListScreenState();
}

class _TreeMonitorListScreenState extends State<TreeMonitorListScreen> {
  final List<Map<String, dynamic>> _treeData = List.generate(
    4,
        (index) => {
      'id': '23be33fa-b2ef-4695-9c7a-d8c9bab8295${index.toString().padLeft(1, '0')}',
      'name': ['Ain','Ain','Ain','Ain'][index % 5],
      'scientificName': ['Terminalia elliptica','Terminalia elliptica','Terminalia elliptica','Terminalia elliptica'][index % 5],
      'imageUrl': Images.sampleImg,
      'healthStatus': ['Excellent', 'Good', 'Fair', 'Needs Attention', 'Critical'][index % 5],
      'lastMonitored': ['Today', '2 days ago', '1 week ago', '2 weeks ago', '1 month ago'][index % 5],
      'growthRate': ['Normal', 'Fast', 'Slow', 'Normal', 'Fast'][index % 5],
    },
  );

  late MapBloc  mapBloc;

  @override
  void initState() {
    mapBloc = MapBloc(
        PlantationRepository(api:  ApiConnection())
    );
    mapBloc.add(ApiListFetch());
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    mapBloc.close();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FFFE),
      body: BlocProvider(
  create: (context) => mapBloc,
  child:  BlocConsumer<MapBloc, ApiState<PlantedListResponseModel, ResponseModel>>(
    listener: (context, state) {
      if (state is TokenExpired<PlantedListResponseModel, ResponseModel>) {
        AppRoute.pushReplacement(context, SignInScreen.route, arguments: {});
      }
    },
    builder: (context, state) {
      if (state is ApiLoading<PlantedListResponseModel, ResponseModel>) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state is ApiFailure<PlantedListResponseModel, ResponseModel>) {
        return Center(
          child: Text(
            state.error.message ?? 'Something went wrong!',
            style: const TextStyle(color: Colors.red),
          ),
        );
      }

      if (state is ApiSuccess<PlantedListResponseModel, ResponseModel>) {
        final plantedTrees = state.data.data; //  real list of PlantedTreeModel


        return  CustomScrollView(
          slivers: [
            // Sleek App Bar
            SliverAppBar(
              expandedHeight: 80,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF00695C),
                        Color(0xFF004D40),
                      ],
                    ),
                  ),
                ),
              ),
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  // backdropFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                  onPressed: () => AppRoute.pop(context),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Tree Monitor',
                    style: AppFonts.body.copyWith(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Monitoring green spaces',
                    // '${_treeData.length} trees under observation',
                    style: AppFonts.regular.copyWith(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Tree List
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(15, 8, 15, 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => _TreeCard(
                    treeData: plantedTrees[index],
                    onDirectionPressed: () {
                      _openMapsApp(plantedTrees[index].location.coordinates[1], plantedTrees[index].location.coordinates[0]);
                      // debugPrint("Direction pressed for tree: ${_treeData[index]['id']}");
                    },
                    onMonitorPressed: () {
                      AppRoute.goToNextPage(
                          context: context,
                          screen: MonitorActivityScreen.route,
                          arguments: {}
                      );
                    },
                  ),
                  childCount: plantedTrees.length,
                ),
              ),
            ),
          ],
        );
      }

      return const SizedBox(); // fallback
    },
  )

)
    );
  }

  void _openMapsApp(double lat, double lng) async {
    String url = "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showNotification(context, message: "Could not open maps");
    }
  }

  Widget _buildFilterChip(String label, bool isSelected, {Color? dotColor}) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF0E5D57)
            : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF0E5D57)
              : const Color(0xFFE5E7EB),
          width: 1.5,
        ),
        boxShadow: isSelected ? [
          BoxShadow(
            color: const Color(0xFF0E5D57).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            // Handle filter selection
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (dotColor != null && !isSelected) ...[
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: AppFonts.body.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TreeCard extends StatelessWidget {
  final PlantedTreeModel treeData;
  final VoidCallback onDirectionPressed;
  final VoidCallback onMonitorPressed;

  const _TreeCard({
    required this.treeData,
    required this.onDirectionPressed,
    required this.onMonitorPressed,
  });

  @override
  Widget build(BuildContext context) {
    // final String name = treeData['name'] ?? 'Unknown Tree';
    // final String id = treeData['id'] ?? 'Unknown ID';
    // final String scientificName = treeData['scientificName'] ?? 'Unknown Species';
    // final String imageUrl = treeData['imageUrl'] ?? Images.sampleImg;
    // final String healthStatus = treeData['healthStatus'] ?? 'Unknown';
    // final String lastMonitored = treeData['lastMonitored'] ?? 'Never';
    // final String growthRate = treeData['growthRate'] ?? 'Unknown';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E5D57).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // Navigate to details
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Header Section
                  Row(
                    children: [
                      // Tree Image with Gradient Overlay
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF0E5D57).withOpacity(0.1),
                              const Color(0xFF10B981).withOpacity(0.1),
                            ],
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: _buildTreeImage(treeData.thumbnail??''),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Tree Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  treeData.treeSpecies.localName,
                                  style: AppFonts.body.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF2C2C2C),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE6F7FF),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    treeData.treeSpecies.id.length > 10
                                        ? '...${treeData.treeSpecies.id.substring(treeData.treeSpecies.id.length - 10)}'
                                        : treeData.treeSpecies.id, // fallback if less than 8 chars
                                    style: AppFonts.regular.copyWith(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF1A5F3E),
                                    ),
                                  )
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0E5D57).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.science,
                                    size: 12,
                                    color: Color(0xFF0E5D57),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    treeData.treeSpecies.scientificName,
                                    style: AppFonts.regular.copyWith(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                      color: const Color(0xFF6B7280),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6B7280).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.timeline,
                                    size: 12,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Last monitored: ${treeData.lastMonitoredDate}',
                                  style: AppFonts.regular.copyWith(
                                    fontSize: 13,
                                    color: const Color(0xFF9CA3AF),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),



                  const SizedBox(height: 16),

                  // Action Buttons
                  Row(
                    children: [
                      // Direction Button
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFE5E7EB),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: onDirectionPressed,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.navigation,
                                    size: 16,
                                    color: Color(0xFF6B7280),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Navigate',
                                    style: AppFonts.body.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Monitor Button
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF0E5D57),
                                Color(0xFF10B981),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: onMonitorPressed,
                              child: Center(
                                child: Text(
                                  'Start Monitoring',
                                  style: AppFonts.body.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: AppFonts.regular.copyWith(
              fontSize: 12,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                value,
                style: AppFonts.body.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getHealthColor(String health) {
    switch (health.toLowerCase()) {
      case 'excellent':
        return const Color(0xFF10B981);
      case 'good':
        return const Color(0xFF22C55E);
      case 'fair':
        return const Color(0xFFEAB308);
      case 'needs attention':
        return const Color(0xFFE97E7E);
      case 'critical':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  Color _getGrowthColor(String growth) {
    switch (growth.toLowerCase()) {
      case 'fast':
        return const Color(0xFF10B981);
      case 'normal':
        return const Color(0xFF2196F3);
      case 'slow':
        return const Color(0xFFEAB308);
      default:
        return const Color(0xFF6B7280);
    }
  }

  Widget _buildTreeImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey.shade200,
          width: 64,
          height: 64,
          child: const Icon(Icons.image),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey.shade200,
          width: 64,
          height: 64,
          child: const Icon(Icons.broken_image),
        ),
      );
    } else {
      return Image.network(
        BaseNetwork.BASE_Image_URL+imageUrl,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
      );
    }
  }




}

/*
const SizedBox(height: 20),

                  // Health & Growth Status Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatusIndicator(
                            'Health',
                            healthStatus,
                            _getHealthColor(healthStatus)
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatusIndicator(
                            'Growth',
                            growthRate,
                            _getGrowthColor(growthRate)
                        ),
                      ),
                    ],
                  ),
*/

