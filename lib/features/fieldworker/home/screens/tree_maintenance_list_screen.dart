import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/core/config/themes/app_fonts.dart';
import 'package:treelove/core/network/base_network.dart';
import 'package:treelove/core/utils/logger.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/bloc/api_event.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/planted.list.response.model.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../common/repositories/plantation_repository.dart';
import '../../../../core/config/resource/images.dart';
import '../../../../core/config/themes/app_color.dart';
import '../../../../core/network/api_connection.dart';
import '../../../../core/widgets/common_notification.dart';
import '../../../authentication/screens/sign_in_screen.dart';
import '../../../vendor/home/bloc/map_bloc.dart';
import 'maintenance_activity_screen.dart';
/*
class TreeMaintenanceListScreen extends StatelessWidget {
  static const route = "/tree-maintenance-list";

  const TreeMaintenanceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FFFE), // Ultra clean background
      body: CustomScrollView(
        slivers: [
          // Sleek App Bar
          SliverAppBar(
            // expandedHeight: 120,
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
                      Color(0xFF0F4C3A),
                      Color(0xFF1A5F3E),
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
                onPressed: () => Navigator.pop(context),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Tree Care',
                  style: AppFonts.body.copyWith(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '5 trees need attention',
                  style: AppFonts.regular.copyWith(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Filter Section
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter by Status',
                    style: AppFonts.body.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2C2C2C),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('All', true),
                        const SizedBox(width: 8),
                        _buildFilterChip('Today', false,
                            dotColor: const Color(0xFFE53935)),
                        const SizedBox(width: 8),
                        _buildFilterChip('Overdue', false,
                            dotColor: const Color(0xFFFF8C00)),
                        const SizedBox(width: 8),
                        _buildFilterChip('This Week', false,
                            dotColor: const Color(0xFF2196F3)),
                        const SizedBox(width: 8),
                        _buildFilterChip('Future', false,
                            dotColor: const Color(0xFF4CAF50)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tree List
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildTreeCard(context, index),
                childCount: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, {Color? dotColor}) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF1A5F3E)
            : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF1A5F3E)
              : const Color(0xFFE5E7EB),
          width: 1.5,
        ),
        boxShadow: isSelected ? [
          BoxShadow(
            color: const Color(0xFF1A5F3E).withOpacity(0.2),
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

  Widget _buildTreeCard(BuildContext context, int index) {
    // Different maintenance scenarios
    final List<Map<String, dynamic>> maintenanceStatuses = [
      {
        'text': 'Maintenance Today',
        'bgColor': Color(0xFFFFEBEE),
        'borderColor': Color(0xFFFFCDD2),
        'dotColor': Color(0xFFE53935),
        'textColor': Color(0xFFD32F2F),
      },
      {
        'text': 'Maintenance in 2 days',
        'bgColor': Color(0xFFE8F4FD),
        'borderColor': Color(0xFFB6E2FF),
        'dotColor': Color(0xFF2196F3),
        'textColor': Color(0xFF1565C0),
      },
      {
        'text': 'Overdue by 1 day',
        'bgColor': Color(0xFFFFF4E6),
        'borderColor': Color(0xFFFFE4B5),
        'dotColor': Color(0xFFFF8C00),
        'textColor': Color(0xFFCC6600),
      },
      {
        'text': 'Maintenance in 1 week',
        'bgColor': Color(0xFFE8F5E8),
        'borderColor': Color(0xFFC8E6C9),
        'dotColor': Color(0xFF4CAF50),
        'textColor': Color(0xFF2E7D32),
      },
    ];

    final status = maintenanceStatuses[index % maintenanceStatuses.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A5F3E).withOpacity(0.06),
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
                              const Color(0xFF1A5F3E).withOpacity(0.1),
                              const Color(0xFF4CAF50).withOpacity(0.1),
                            ],
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            Images.sampleImg,
                            fit: BoxFit.cover,
                          ),
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
                                  'Neem Tree',
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
                                    color: const Color(0xFFE8F5E8),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '23be33fa...',
                                    style: AppFonts.regular.copyWith(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF1A5F3E),
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
                                    color: const Color(0xFF1A5F3E).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.science,
                                    size: 12,
                                    color: Color(0xFF1A5F3E),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Azadirachta indica',
                                  style: AppFonts.regular.copyWith(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    color: const Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Status Indicator
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: status['bgColor'],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: status['borderColor'],
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: status['dotColor'],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          status['text'],
                          style: AppFonts.body.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: status['textColor'],
                          ),
                        ),
                      ],
                    ),
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
                              onTap: () {},
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

                      // Maintenance Button
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF1A5F3E),
                                Color(0xFF2E7D32),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                // AppRoute.goToNextPage(context: context, ...)
                              },
                              child: Center(
                                child: Text(
                                  'Start Maintenance',
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
}

 */

class TreeMaintenanceListScreen extends StatefulWidget {
  static const route = "/tree-maintenance-list";
  final String serviceId;
  const TreeMaintenanceListScreen({super.key,required this.serviceId});

  @override
  State<TreeMaintenanceListScreen> createState() => _TreeMaintenanceListScreenState();
}

class _TreeMaintenanceListScreenState extends State<TreeMaintenanceListScreen> {
  String selectedFilter='All';

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
      backgroundColor: const Color(0xFFF8FFFE), // Ultra clean background
      body: BlocProvider(
  create: (context) => mapBloc,
  child: BlocConsumer<MapBloc, ApiState<PlantedListResponseModel, ResponseModel>>(
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
        final plantedTrees = state.data.data; // ✅ real list of PlantedTreeModel


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
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Tree Care',
                    style: AppFonts.body.copyWith(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Making nature healthier',
                    style: AppFonts.regular.copyWith(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Filter Section
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filter by Status',
                      style: AppFonts.body.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('All'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Today',
                              dotColor: const Color(0xFFE53935)),
                          const SizedBox(width: 8),
                          _buildFilterChip('Tomorrow',
                              dotColor: const Color(0xFF4CAF50)),
                          const SizedBox(width: 8),
                          _buildFilterChip('Overdue',
                              dotColor: const Color(0xFFFF8C00)),
                          const SizedBox(width: 8),
                          _buildFilterChip('Maintenance in 2 days',
                              dotColor: const Color(0xFF2196F3)),
                          const SizedBox(width: 8),
                          _buildFilterChip('Upcoming',
                              dotColor: const Color(0xFF4CAF50)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tree List
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildTreeCard(context,plantedTrees[index] ,index),
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

),
    );
  }

  Widget _buildFilterChip(String label, {Color? dotColor}) {
    final isSelected = selectedFilter == label;

    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1A5F3E) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected ? const Color(0xFF1A5F3E) : const Color(0xFFE5E7EB),
          width: 1.5,
        ),
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: const Color(0xFF1A5F3E).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            setState(() {
              selectedFilter = label; // ✅ only one filter active
            });
            mapBloc.add(ApiListFetch(
              maintenanceStatus: label,
            ));
            debugLog(label, name: "filter");
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
                  color: isSelected ? Colors.white : const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildTreeCard(BuildContext context,PlantedTreeModel treeData ,int index) {
    // Different maintenance scenarios
    final List<Map<String, dynamic>> maintenanceStatuses = [
      {
        'text': 'Maintenance Today',
        'bgColor': Color(0xFFFFEBEE),
        'borderColor': Color(0xFFFFCDD2),
        'dotColor': Color(0xFFE53935),
        'textColor': Color(0xFFD32F2F),
        'lastMaintained': '8 Aug 2025',
      },
      {
        'text': 'Maintenance in 2 days',
        'bgColor': Color(0xFFE8F4FD),
        'borderColor': Color(0xFFB6E2FF),
        'dotColor': Color(0xFF2196F3),
        'textColor': Color(0xFF1565C0),
        'lastMaintained': '25 Jul 2025',
      },
      {
        'text': 'Overdue by 1 day',
        'bgColor': Color(0xFFFFF4E6),
        'borderColor': Color(0xFFFFE4B5),
        'dotColor': Color(0xFFFF8C00),
        'textColor': Color(0xFFCC6600),
        'lastMaintained': '20 Jun 2025',
      },
      {
        'text': 'Maintenance in 1 week',
        'bgColor': Color(0xFFE8F5E8),
        'borderColor': Color(0xFFC8E6C9),
        'dotColor': Color(0xFF4CAF50),
        'textColor': Color(0xFF2E7D32),
        'lastMaintained': '5 Aug 2025',
      },
    ];

    final status = maintenanceStatuses[index % maintenanceStatuses.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A5F3E).withOpacity(0.06),
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
                              const Color(0xFF1A5F3E).withOpacity(0.1),
                              const Color(0xFF4CAF50).withOpacity(0.1),
                            ],
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            '${BaseNetwork.BASE_Image_URL}${treeData.thumbnail ?? ''}',

                            // Images.sampleImg,
                            fit: BoxFit.cover,
                          ),
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
                                    color: const Color(0xFFE8F5E8),
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
/*Text(
                                    treeData.treeSpecies.id,
                                    // '23be33fa...',
                                    style: AppFonts.regular.copyWith(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF1A5F3E),
                                    ),
                                  ),
                                  */
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
                                    color: const Color(0xFF1A5F3E).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.science,
                                    size: 12,
                                    color: Color(0xFF1A5F3E),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  treeData.treeSpecies.scientificName,
                                  // 'Terminalia elliptica',
                                  style: AppFonts.regular.copyWith(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    color: const Color(0xFF6B7280),
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
                                    Icons.history,
                                    size: 12,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Last maintained: ${treeData.lastMaintainedAgo}',
                                  // 'Last maintained: ${status['lastMaintained']}',
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

                  const SizedBox(height: 20),

                  // Status Indicator
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: status['bgColor'],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: status['borderColor'],
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: status['dotColor'],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${treeData.maintenanceStatus}',
                          // status['text'],
                          style: AppFonts.body.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: status['textColor'],
                          ),
                        ),
                      ],
                    ),
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
                              onTap: () {
                                _openMapsApp(context,treeData.location.coordinates[1], treeData.location.coordinates[0]);
                              },
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

                      // Maintenance Button
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF1A5F3E),
                                Color(0xFF2E7D32),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                AppRoute.goToNextPage(context: context, screen: MaintenanceActivityScreen.route, arguments: {
                                  // 'plantationId':treeData.,
                                  // 'serviceId':treeData.sevi
                                });
                                // AppRoute.goToNextPage(context: context, ...)
                              },
                              child: Center(
                                child: Text(
                                  'Start Maintenance',
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

  void _openMapsApp(context,double lat, double lng) async {
    String url = "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showNotification(context, message: "Could not open maps");
    }
  }
}