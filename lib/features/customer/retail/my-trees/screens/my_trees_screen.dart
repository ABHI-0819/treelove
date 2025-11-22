import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:treelove/common/repositories/plantation_repository.dart';
import 'package:treelove/common/screens/satellite_history_screen.dart';
import 'package:treelove/common/screens/satellite_monitoring_result_screen.dart';
import 'package:treelove/features/authentication/screens/sign_in_screen.dart';
import 'package:treelove/features/customer/retail/my-trees/screens/tree_maintenance_list.dart';
import 'package:treelove/features/fieldworker/home/screens/tree_maintenance_list_screen.dart';

/*
class MyTreesScreen extends StatelessWidget {

  const MyTreesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> treeData = [
      {
        'name': 'Banyan Tree',
        'latLng': LatLng(19.0760, 72.8777),
      },
      {
        'name': 'Peepal Tree',
        'latLng': LatLng(19.0765, 72.8772),
      },
      {
        'name': 'Neem Tree',
        'latLng': LatLng(19.0755, 72.8780),
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: treeData.first['latLng'] as LatLng,
              initialZoom: 17,
              interactionOptions: const InteractionOptions(
                flags: ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                tileProvider: NetworkTileProvider(
                  headers: {
                    'User-Agent': 'TreelovApp/1.0 (https://yourapp.com)',
                  },
                ),
              ),
              MarkerLayer(
                markers: treeData.map((tree) {
                  final latLng = tree['latLng'] as LatLng;
                  return Marker(
                    width: 40,
                    height: 40,
                    point: latLng,
                    child: Tooltip(
                      message: tree['name'],
                      child: const Icon(
                        Icons.park_rounded,
                        color: Colors.green,
                        size: 36,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          // Custom Back Button
          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 8.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

 */


import '../../../../../common/bloc/api_event.dart';
import '../../../../../common/bloc/api_state.dart';
import '../../../../../common/models/planted.list.response.model.dart';
import '../../../../../common/models/response.mode.dart';
import '../../../../../core/config/resource/images.dart';
import '../../../../../core/config/route/app_route.dart';
import '../../../../../core/config/themes/app_color.dart';
import '../../../../../core/network/api_connection.dart';
import '../../../../../core/network/base_network.dart';
import '../../../../../core/widgets/tree_bottomsheet.dart';
import '../../../../vendor/home/bloc/map_bloc.dart';
import '../../../../vendor/home/models/project_list_model.dart';
import 'tree_monitoring_history.dart';

class MyTreeScreen extends StatefulWidget {
  static const route = '/my-trees';
  const MyTreeScreen({super.key});

  @override
  State<MyTreeScreen> createState() => _MyTreeScreenState();
}

class _MyTreeScreenState extends State<MyTreeScreen> with TickerProviderStateMixin {
  final MapController _mapController = MapController();

  // Color Palette
  static const Color primary = Color(0xFF00473C);
  static const Color primaryDark = Color(0xFF002D26);
  static const Color primaryLight = Color(0xFF1C665A);
  static const Color secondary = Color(0xFF63B27F);
  static const Color secondaryLight = Color(0xFF9DD9A5);
  static const Color secondaryDark = Color(0xFF387A58);
  static const Color background = Color(0xFFF8F4E3);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);


  // Sample tree data
  /*
  final List<TreeData> trees = [
    TreeData(
      id: 'T001',
      name: 'Oak Magnificus',
      species: 'White Oak',
      position: const LatLng(19.0760, 72.8777),
      healthStatus: TreeHealth.excellent,
      age: '5 years',
      height: '12 feet',
      plantedDate: '2019-03-15',
      images: [
        'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400',
        'https://images.unsplash.com/photo-1574263867128-b3e6f57b20b8?w=400',
        'https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=400',
      ],
      lastMaintenance: DateTime.now().subtract(const Duration(days: 30)),
      needsMaintenance: false,
      maintenanceHistory: [
        MaintenanceRecord(
          date: DateTime.now().subtract(const Duration(days: 30)),
          type: 'Watering & Pruning',
          status: 'Completed',
          notes: 'Tree is healthy, pruned dead branches',
        ),
        MaintenanceRecord(
          date: DateTime.now().subtract(const Duration(days: 90)),
          type: 'Fertilization',
          status: 'Completed',
          notes: 'Applied organic fertilizer',
        ),
      ],
    ),
    TreeData(
      id: 'T002',
      name: 'Neem Guardian',
      species: 'Neem Tree',
      position: const LatLng(19.0780, 72.8790),
      healthStatus: TreeHealth.good,
      age: '3 years',
      height: '8 feet',
      plantedDate: '2021-06-20',
      images: [
        'https://images.unsplash.com/photo-1583212292454-1fe6229603b7?w=400',
        'https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=400',
      ],
      lastMaintenance: DateTime.now().subtract(const Duration(days: 75)),
      needsMaintenance: true,
      maintenanceHistory: [
        MaintenanceRecord(
          date: DateTime.now().subtract(const Duration(days: 75)),
          type: 'General Checkup',
          status: 'Completed',
          notes: 'Minor pest control needed',
        ),
      ],
    ),
    TreeData(
      id: 'T003',
      name: 'Mango Delight',
      species: 'Mango Tree',
      position: const LatLng(19.0800, 72.8760),
      healthStatus: TreeHealth.excellent,
      age: '4 years',
      height: '10 feet',
      plantedDate: '2020-07-10',
      images: [
        'https://images.unsplash.com/photo-1605185529743-1d4df42d6e06?w=400',
      ],
      lastMaintenance: DateTime.now().subtract(const Duration(days: 15)),
      needsMaintenance: false,
      maintenanceHistory: [
        MaintenanceRecord(
          date: DateTime.now().subtract(const Duration(days: 15)),
          type: 'Watering',
          status: 'Completed',
          notes: 'Regular watering schedule maintained',
        ),
      ],
    ),
  ];

   */

  PlantedTreeModel? selectedTree;

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      body: BlocProvider(
  create: (context) => mapBloc,
  child: Stack(
        children: [
          _buildMap(),
          buildZoomButtons(),
          _buildHeader(),
          if (selectedTree != null) _buildTreeBottomSheet(),
        ],
      ),
),
    );
  }

  Widget buildZoomButtons() {
    return Positioned(
      right: 16,
      bottom: 80, // Changed from top to bottom for better UX
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  final currentZoom = _mapController.camera.zoom;
                  if (currentZoom < 20) {
                    _mapController.move(
                      _mapController.camera.center,
                      currentZoom + 1,
                    );
                  }
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 20,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  final currentZoom = _mapController.camera.zoom;
                  if (currentZoom > 3) {
                    _mapController.move(
                      _mapController.camera.center,
                      currentZoom - 1,
                    );
                  }
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.remove,
                    size: 20,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return BlocConsumer<MapBloc, ApiState<PlantedListResponseModel, ResponseModel>>(
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

          final markers = plantedTrees.map((tree) => _buildTreeMarker(tree)).toList();

          return FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: const LatLng(19.112251, 72.864512),
              initialZoom: 10.0,
              minZoom: 3.0,
              maxZoom: 20.0,
              // Fixed interaction options
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.doubleTapZoom |
                InteractiveFlag.pinchZoom |
                InteractiveFlag.drag |
                InteractiveFlag.flingAnimation,
                enableMultiFingerGestureRace: true,
                scrollWheelVelocity: 0.005,
                pinchZoomWinGestures: MultiFingerGesture.pinchZoom,
              ),
              keepAlive: true,
              backgroundColor: Colors.grey,
              // Add tap handling at map level

            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
                tileProvider: NetworkTileProvider(
                  headers: {
                    'User-Agent': 'TreelovApp/1.0 (https://yourapp.com)',
                  },
                ),
              ),
              if (markers.isNotEmpty) MarkerLayer(markers: markers),
            ],
          );
        }

        return const SizedBox(); // fallback
      },
    );
  }

  /*
  Widget _buildMap() {
    return BlocConsumer<MapBloc, ApiState<PlantedListResponseModel, ResponseModel>>(
      listener: (context, state) {
        if (state is TokenExpired<PlantedListResponseModel, ResponseModel>) {
          AppRoute.pushReplacement(
            context,
            SignInScreen.route,
            arguments: {},
          );
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
          final plantData = state.data.data ?? [];
          final markers = trees.isNotEmpty
              ? trees.map((tree) => _buildTreeMarker(tree)).toList()
              : <Marker>[];

          return FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: LatLng(19.0760, 72.8777),
              initialZoom: 15.0,
              minZoom: 10.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
                tileProvider: NetworkTileProvider(
                  headers: {
                    'User-Agent': 'TreelovApp/1.0 (https://yourapp.com)',
                  },
                ),
              ),
              if (markers.isNotEmpty) MarkerLayer(markers: markers),
            ],
          );
        }

        return const SizedBox(); // fallback
      },
    );
  }

   */




  /*

  Widget _buildMap() {
    return BlocConsumer<MapBloc,
        ApiState<ProjectListResponse, ResponseModel>>(
  listener: (context, state) {
    if(state is TokenExpired<ProjectListResponse, ResponseModel>){
      return AppRoute.pushReplacement( context, SignInScreen.route, arguments: {});
    }
    // TODO: implement listener
  },
  builder: (context, state) {
    if(state is ApiSuccess<ProjectListResponse, ResponseModel> ){
      return FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: const LatLng(19.0760, 72.8777),
          initialZoom: 15.0,
          minZoom: 10.0,
          maxZoom: 18.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
            tileProvider: NetworkTileProvider(
              headers: {
                'User-Agent': 'TreelovApp/1.0 (https://yourapp.com)',
              },
            ),
          ),
          MarkerLayer(
            markers: trees.map((tree) => _buildTreeMarker(tree)).toList(),
          ),
        ],
      );
    }else {
      return SizedBox();
    }

  },
);
  }

   */
/*
  Marker _buildTreeMarker(PlantedTreeModel tree) {
    // decide marker color based on tree health
    Color markerColor;
    if (tree.treeHealth.toLowerCase().contains("healthy")) {
      markerColor = secondary;
    } else if (tree.treeHealth.toLowerCase().contains("good")) {
      markerColor = secondaryLight;
    } else {
      markerColor = Colors.orange;
    }

    final lat = tree.location.coordinates[1]; // GeoJSON: [lng, lat]
    final lng = tree.location.coordinates[0];

    return Marker(
      point: LatLng(lat, lng),
      width: 50,
      height: 50,
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTree = tree; // ✅ save selected planted tree
          });
          _showTreeDetails(tree);
        },
        child: SvgPicture.asset(
          Images.treeMarker,
          color: markerColor,
        ),
      ),
    );
  }

 */



  Marker _buildTreeMarker(PlantedTreeModel tree) {

    final lat = tree.location.coordinates[1]; // GeoJSON: [lng, lat]
    final lng = tree.location.coordinates[0];
    return Marker(
      point: LatLng(lat, lng),
      width: 50,
      height: 50,
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTree = tree;
          });
          // _showTreeDetails(tree);
          TreeDetailsBottomSheet.show(
            context,
            treeName: tree.treeSpecies.localName,
            scientificName: tree.treeSpecies.scientificName,
            imageUrl: tree.thumbnail??tree.treeSpecies.image, // or null
            health: tree.treeHealth,
            growth:tree.treeGrowth,
            girth: '${tree.treeGirth} ${tree.treeGirthUnit}',
            direction: 'Direction',
            onDirectionTap: (){

            },
            nextMaintenanceDate: tree.nextMaintenanceDate,
            nextMonitoringDate: tree.nextMonitoringDate,
            onMaintenanceHistoryTap: () {
              AppRoute.goToNextPage(context: context, screen: TreeMaintenanceHistoryScreen.route, arguments: {
                'treeSpecies':'neem',
                'location':"mumbai",
                'treeId':'2131'
              });
              // Navigate to maintenance history
            },
            onManualMonitorHistoryTap: () {
              AppRoute.goToNextPage(context: context, screen: TreeMonitoringHistoryScreen.route, arguments: {
                'treeSpecies':'neem',
                'location':"mumbai",
                'treeId':'2131'
              });
              // Navigate to manual monitoring history
            },
            onSatelliteMonitorHistoryTap: () {
              AppRoute.goToNextPage(context: context, screen: SatelliteHistoryScreen.route, arguments: {
                'plantationId':tree.id,
              });
              // Navigate to satellite monitoring history
            },
          );
        },
        child: SvgPicture.asset(Images.treeMarker),
      ),
    );
  }



  Widget _buildHeader() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: primary,
                  size: 18,
                ),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: cardBackground,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: primary.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.forest_rounded,
                    color: primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "My Trees",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: primary,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            const SizedBox(width: 44),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3);
  }
  /*
  Widget _buildStatsCard() {
    return Positioned(
      top: 120,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: primary.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildStatItem(
                icon: Icons.park_rounded,
                label: "Total Trees",
                value: "${trees.length}",
                color: secondary,
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: Colors.grey.shade200,
            ),
            Expanded(
              child: _buildStatItem(
                icon: Icons.health_and_safety_rounded,
                label: "Healthy",
                value: "${trees.where((t) => t.healthStatus == TreeHealth.excellent).length}",
                color: secondary,
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: Colors.grey.shade200,
            ),
            Expanded(
              child: _buildStatItem(
                icon: Icons.warning_rounded,
                label: "Need Care",
                value: "${trees.where((t) => t.needsMaintenance).length}",
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.2),
    );
  }

   */

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /*
  void _showTreeDetails(PlantedTreeModel tree) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TreeDetailsBottomSheet(tree: tree),
    );
  }

   */



  void _showTreeDetails(PlantedTreeModel tree) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          _TreeDetailsBottomSheet(tree: tree),
    );
  }



  Widget _buildTreeBottomSheet() {
    return const SizedBox(); // Placeholder for the bottom sheet logic
  }
}


// Tree Details Bottom Sheet Widget
class _TreeDetailsBottomSheet extends StatefulWidget {
  final PlantedTreeModel tree;

  const _TreeDetailsBottomSheet({required this.tree});

  @override
  State<_TreeDetailsBottomSheet> createState() => _TreeDetailsBottomSheetState();
}

class _TreeDetailsBottomSheetState extends State<_TreeDetailsBottomSheet>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _imageController;
  int _currentImageIndex = 0;

  List<String> imageUrls= [
  'https://picsum.photos/400/400?random=1',
  'https://picsum.photos/400/400?random=2',
  'https://picsum.photos/400/400?random=3',
  'https://picsum.photos/400/400?random=4',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _imageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        // final image =BaseNetwork.BASE_Image_URL+widget.tree.thumbnail!;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: const BoxDecoration(
            color: AppColor.cardBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              /// Handle + Header (pinned at top)
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    _buildBottomSheetHeader(),
                  ],
                ),
              ),

              /// Grid Section
              /// Grid Section - Updated Image Management
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final imageUrl = widget.tree.thumbnail != null
                          ? BaseNetwork.BASE_Image_URL + widget.tree.thumbnail!
                          : null;

                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: imageUrl != null
                            ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey.shade200,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                      : null,
                                  strokeWidth: 2,
                                  color: AppColor.success,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey.shade400,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Image not available',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                            : Container(
                          color: Colors.grey.shade200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image,
                                color: Colors.grey.shade400,
                                size: 48,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'No image',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: 1,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                    childAspectRatio: 1.2,
                  ),
                ),
              ),

              /*
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {

                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          image,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                    childCount: 1,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.0,
                  ),
                ),
              ),

               */

              /// Tree Info Section
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    _buildTreeInfoRow(
                      icon: Icons.favorite,
                      iconColor: Colors.green,
                      title: "Health",
                      value: widget.tree.treeHealth.isNotEmpty
                          ? widget.tree.treeHealth[0].toUpperCase() + widget.tree.treeHealth.substring(1).toLowerCase()
                          : '',
                    ),

                    // _buildTreeInfoRow(
                    //   icon: Icons.favorite,
                    //   iconColor: Colors.green,
                    //   title: "Health",
                    //   value: widget.tree.treeHealth.toUpperCase(),
                    // ),
                    const Divider(),

                    _buildTreeInfoRow(
                      icon: Icons.forest,
                      iconColor: Colors.brown,
                      title: "Girth",
                      value: "${widget.tree.treeGirth} ft",
                    ),
                    const Divider(),

                    _buildTreeInfoRow(
                      icon: Icons.height,
                      iconColor: Colors.blue,
                      title: "Height",
                      value: "${widget.tree.treeHeight} ft",
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        // Maintenance History
                        Expanded(
                          child: InkWell(
                            onTap: () => AppRoute.goToNextPage(context: context, screen: TreeMaintenanceHistoryScreen.route, arguments: {
                              'treeSpecies':'neem',
                              'location':"mumbai",
                              'treeId':'2131'
                            }),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                              decoration: BoxDecoration(
                                color: AppColor.success,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 10,
                                children: [
                                  SvgPicture.asset(
                                    Images.maintenanceIcon,
                                    color: Colors.white,
                                    width: 26,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Maintenance\nHistory",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Monitoring History
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              AppRoute.goToNextPage(context: context, screen: SatelliteMonitoringResultScreen.route, arguments: {
                                'monitorId':'653a1175-f498-421d-9668-5841533e102d'
                              });
                            //   AppRoute.goToNextPage(context: context, screen: TreeMonitoringHistoryScreen.route, arguments: {
                            //   'treeSpecies':'neem',
                            //   'location':"mumbai",
                            //   'treeId':'2131'
                            // });
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade600,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 10,
                                children: [
                                  SvgPicture.asset(
                                    Images.monitorIcon,
                                    color: Colors.white,
                                    width: 26,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Monitoring\nHistory",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )

                  ],
                ),
              ),
            ],
          ),
        ).animate().slideY(begin: 1.0, duration: 400.ms, curve: Curves.easeOut);
      },
    );
  }



  /*
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12,vertical: 10),
          decoration: const BoxDecoration(
            color: AppColor.cardBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              _buildBottomSheetHeader(),
              Flexible(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrls[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),

              /// 🌿 Tree Health
              _buildTreeInfoRow(
                icon: Icons.favorite,
                iconColor: Colors.green,
                title: "Health",
                value: "Healthy",
              ),

              const Divider(),

              /// 🌲 Tree Girth
              _buildTreeInfoRow(
                icon: Icons.forest,
                iconColor: Colors.brown,
                title: "Girth",
                value: "65 cm",
              ),

              const Divider(),

              /// 🌴 Tree Height
              _buildTreeInfoRow(
                icon: Icons.height,
                iconColor: Colors.blue,
                title: "Height",
                value: "12.5 m",
              ),

            ],
          ),
        ).animate().slideY(begin: 1.0, duration: 400.ms, curve: Curves.easeOut);
      },
    );
  }

   */

  /*
              _buildTabBar(),

              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildDetailsTab(scrollController),
                    _buildMaintenanceTab(scrollController),
                  ],
                ),
              ),

               */

  /// Reusable Row Widget
  Widget _buildTreeInfoRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: iconColor.withOpacity(0.1),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheetHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 24, 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.tree.treeSpecies.localName,
                  style:  TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColor.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.tree.treeSpecies.scientificName,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColor.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          _buildHealthBadge(),
        ],
      ),
    );
  }

  Widget _buildHealthBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.directions, color: Colors.blueAccent, size: 16),
          const SizedBox(width: 6),
          Text(
            'Navigate',
            style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCarousel() {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PageView.builder(
            controller: _imageController,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemCount: 1,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.primary.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    widget.tree.thumbnail!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.error, size: 50),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          /*
          if (widget.tree.images.length > 1)
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.tree.images.length,
                      (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: _currentImageIndex == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: _currentImageIndex == index
                          ? AppColor.primary
                          : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

           */
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColor.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColor.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColor.textSecondary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        tabs: const [
          Tab(text: "Details"),
          Tab(text: "Maintenance"),
        ],
      ),
    );
  }
/*
  Widget _buildDetailsTab(ScrollController scrollController) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow("Tree ID", widget.tree.id),
          _buildDetailRow("Age", widget.tree.),
          _buildDetailRow("Height", widget.tree.height),
          _buildDetailRow("Planted Date", widget.tree.plantedDate),
          _buildDetailRow("Location", "${widget.tree.position.latitude.toStringAsFixed(4)}, ${widget.tree.position.longitude.toStringAsFixed(4)}"),

          const SizedBox(height: 24),

          // Navigate Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Handle navigation to tree location
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Navigation started to tree location"),
                    backgroundColor: AppColor.secondary,
                  ),
                );
              },
              icon: const Icon(Icons.navigation_rounded),
              label: const Text("Navigate to Tree"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.secondary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceTab(ScrollController scrollController) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Maintenance Status
          if (widget.tree.needsMaintenance) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning_rounded, color: Colors.orange, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        "Maintenance Required",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _requestMaintenance();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Request Maintenance"),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Maintenance History
          const Text(
            "Maintenance History",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColor.primary,
            ),
          ),
          const SizedBox(height: 16),

          ...widget.tree.maintenanceHistory.map((record) => _buildMaintenanceRecord(record)),
        ],
      ),
    );
  }

 */

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColor.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColor.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceRecord(MaintenanceRecord record) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColor.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  record.status,
                  style: const TextStyle(
                    color: AppColor.secondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                "${record.date.day}/${record.date.month}/${record.date.year}",
                style: const TextStyle(
                  color: AppColor.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            record.type,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          if (record.notes.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              record.notes,
              style: const TextStyle(
                color: AppColor.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /*
  void _requestMaintenance() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Request Maintenance",
          style: TextStyle(
            color: AppColor.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          "A maintenance request has been submitted for ${widget.tree.name}. Our team will contact you within 24 hours.",
          style: const TextStyle(color: AppColor.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              "OK",
              style: TextStyle(color: AppColor.secondary),
            ),
          ),
        ],
      ),
    );
  }

   */
}

 /*
class _TreeDetailsBottomSheet extends StatelessWidget {
  final PlantedTreeModel tree;

  const _TreeDetailsBottomSheet({required this.tree});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 40,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                tree.treeSpecies.localName,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              _buildTreeInfoRow("Health", tree.treeHealth),
              _buildTreeInfoRow("Height", "${tree.treeHeight} ${tree.treeHeightUnit}"),
              _buildTreeInfoRow("Girth", "${tree.treeGirth} ${tree.treeGirthUnit}"),
              if (tree.remarks != null && tree.remarks!.isNotEmpty)
                _buildTreeInfoRow("Remarks", tree.remarks!),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTreeInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
              child: Text(label,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
          Text(value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

  */


// Data Models
enum TreeHealth { excellent, good, needsAttention }

class TreeData {
  final String id;
  final String name;
  final String species;
  final LatLng position;
  final TreeHealth healthStatus;
  final String age;
  final String height;
  final String plantedDate;
  final List<String> images;
  final DateTime lastMaintenance;
  final bool needsMaintenance;
  final List<MaintenanceRecord> maintenanceHistory;

  TreeData({
    required this.id,
    required this.name,
    required this.species,
    required this.position,
    required this.healthStatus,
    required this.age,
    required this.height,
    required this.plantedDate,
    required this.images,
    required this.lastMaintenance,
    required this.needsMaintenance,
    required this.maintenanceHistory,
  });
}

class MaintenanceRecord {
  final DateTime date;
  final String type;
  final String status;
  final String notes;

  MaintenanceRecord({
    required this.date,
    required this.type,
    required this.status,
    required this.notes,
  });
}

