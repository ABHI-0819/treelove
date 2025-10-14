import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:treelove/common/repositories/plantation_repository.dart';
import 'package:treelove/features/authentication/screens/sign_in_screen.dart';
import 'package:treelove/features/customer/retail/my-trees/screens/tree_maintenance_list.dart';
import 'package:treelove/features/fieldworker/home/screens/tree_maintenance_list_screen.dart';
import '../../../../../common/bloc/api_event.dart';
import '../../../../../common/bloc/api_state.dart';
import '../../../../../common/models/planted.list.response.model.dart';
import '../../../../../common/models/response.mode.dart';
import '../../../../../common/screens/satellite_history_screen.dart';
import '../../../../../common/screens/satellite_monitoring_result_screen.dart';
import '../../../../../core/config/resource/images.dart';
import '../../../../../core/config/route/app_route.dart';
import '../../../../../core/config/themes/app_color.dart';
import '../../../../../core/network/api_connection.dart';
import '../../../../../core/network/base_network.dart';
import '../../../../../core/widgets/tree_bottomsheet.dart';
import '../../../../vendor/home/bloc/map_bloc.dart';
import '../../../../vendor/home/models/project_list_model.dart';
import '../../../retail/my-trees/screens/tree_monitoring_history.dart';
/*
class B2bMapScreen extends StatefulWidget {
  static const route = '/b2b-map';
  const B2bMapScreen({super.key});

  @override
  State<B2bMapScreen> createState() => _B2bMapScreenState();
}

class _B2bMapScreenState extends State<B2bMapScreen> with TickerProviderStateMixin {
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
          _showTreeDetails(tree);
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
      builder: (context) => _TreeDetailsBottomSheet(tree: tree),
    );
  }



  Widget _buildTreeBottomSheet() {
    return const SizedBox(); // Placeholder for the bottom sheet logic
  }
}

 */
class B2bMapScreen extends StatefulWidget {
  static const route = '/b2b-map';
  const B2bMapScreen({super.key});

  @override
  State<B2bMapScreen> createState() => _B2bMapScreenState();
}

class _B2bMapScreenState extends State<B2bMapScreen> {
  final MapController _mapController = MapController();
  PlantedTreeModel? selectedTree;

  late MapBloc mapBloc;

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

  @override
  void initState() {
    mapBloc = MapBloc(PlantationRepository(api: ApiConnection()));
    mapBloc.add(ApiListFetch());
    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    mapBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: BlocProvider.value(
        value: mapBloc,
        child: Stack(
          children: [
            _buildMap(),
            _buildHeader(),
            buildZoomButtons(),
          ],
        ),
      ),
    );
  }

  Widget buildZoomButtons() {
    return Positioned(
      right: 16,
      bottom: 80,
      child: Column(
        children: [
          _buildZoomButton(
            icon: Icons.add,
            onPressed: () {
              final currentZoom = _mapController.camera.zoom;
              if (currentZoom < 20) {
                _mapController.move(_mapController.camera.center, currentZoom + 1);
              }
            },
          ),
          const SizedBox(height: 8),
          _buildZoomButton(
            icon: Icons.remove,
            onPressed: () {
              final currentZoom = _mapController.camera.zoom;
              if (currentZoom > 3) {
                _mapController.move(_mapController.camera.center, currentZoom - 1);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildZoomButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
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
          onTap: onPressed,
          child: Container(
            width: 44,
            height: 44,
            child: Icon(icon, size: 20, color: Colors.black87),
          ),
        ),
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
              state.error.message ?? 'Failed to load trees.',
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        }

        if (state is ApiSuccess<PlantedListResponseModel, ResponseModel>) {
          final plantedTrees = state.data.data;

          // Build markers from real API data
          final markers = plantedTrees.map((tree) {
            final lat = tree.location.coordinates[1]; // GeoJSON: [lng, lat]
            final lng = tree.location.coordinates[0];
            return Marker(
              point: LatLng(lat, lng),
              width: 50,
              height: 50,
              child:  GestureDetector(
                onTap: () {
                  // _showTreeDetails(tree);
                  TreeDetailsBottomSheet.show(
                    context,
                    treeName: tree.treeSpecies.localName,
                    scientificName: tree.treeSpecies.scientificName,
                    imageUrl: BaseNetwork.BASE_Image_URL+tree.thumbnail!??tree.treeSpecies.image, // or null
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
                child: _buildTreeMarker(tree),
              ),
            );
          }).toList();

          return FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: LatLng(19.112251, 72.864512),
              initialZoom: 10.0,
              minZoom: 3.0,
              maxZoom: 20.0,
              interactionOptions: InteractionOptions(
                flags: InteractiveFlag.all,
                enableMultiFingerGestureRace: true,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.yourcompany.yourapp',
                tileProvider: NetworkTileProvider(
                  headers: {
                    'User-Agent': 'YourApp/1.0 (https://yourapp.com)',
                  },
                ),
              ),
              CurrentLocationLayer(),
              // CLUSTERED MARKERS
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  maxClusterRadius: 120,
                  size: const Size(48, 48),
                  // fitBoundsOptions: FitBoundsOptions(padding: const EdgeInsets.all(50)),
                  markers: markers,
                  builder: (context, markers) {
                    final count = markers.length;
                    return FloatingActionButton(
                      onPressed: null,
                      backgroundColor: count > 1 ? Colors.blue.shade600 : Colors.transparent,
                      elevation: 4,
                      child: count == 1
                          ? const SizedBox.shrink()
                          : Text(
                        '$count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildTreeMarker(PlantedTreeModel tree) {
    Color markerColor = Colors.green;
    final health = tree.treeHealth.toLowerCase();
    if (health.contains('warning') || health.contains('fair')) {
      markerColor = Colors.orange;
    } else if (health.contains('critical') || health.contains('poor')) {
      markerColor = Colors.red;
    }

    return SvgPicture.asset(Images.treeMarker);
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
                  Icon(Icons.forest_rounded, color: primary, size: 20),
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
    );
  }

  void _showTreeDetails(PlantedTreeModel tree) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TreeDetailsBottomSheet(tree: tree),
    );
  }
}


class _TreeDetailsBottomSheet extends StatefulWidget {
  final PlantedTreeModel tree;

  const _TreeDetailsBottomSheet({required this.tree});

  @override
  State<_TreeDetailsBottomSheet> createState() => _TreeDetailsBottomSheetState();
}

class _TreeDetailsBottomSheetState extends State<_TreeDetailsBottomSheet> {
  List<String> get imageUrls {
    final List<String> urls = [];
    if (widget.tree.thumbnail != null) {
      urls.add(BaseNetwork.BASE_Image_URL + widget.tree.thumbnail!);
    }
    // Add more images if available: e.g., widget.tree.additionalImages
    return urls.isEmpty ? [] : urls;
  }

  String _getHealthColor(String health) {
    switch (health.toLowerCase()) {
      case 'healthy':
      case 'good':
        return '0xFF4CAF50'; // Green
      case 'warning':
      case 'fair':
        return '0xFFFF9800'; // Amber
      case 'critical':
      case 'poor':
        return '0xFFF44336'; // Red
      default:
        return '0xFF9E9E9E'; // Grey
    }
  }

  @override
  Widget build(BuildContext context) {
    final healthColorHex = _getHealthColor(widget.tree.treeHealth);
    final healthColor = Color(int.parse(healthColorHex));

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.6,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                // Handle
                SliverToBoxAdapter(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 12, bottom: 8),
                    child: Container(
                      width: 48,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),

                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.tree.treeSpecies.localName,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.tree.treeSpecies.scientificName,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildHealthBadge(healthColor),
                      ],
                    ),
                  ),
                ),

                // Image Section
                if (imageUrls.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    sliver: SliverToBoxAdapter(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: AspectRatio(
                          aspectRatio: 1.5,
                          child: Image.network(
                            imageUrls[0],
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.grey.shade200,
                                child: const Center(child: CircularProgressIndicator()),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                // Tree Info Section
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildInfoCard(
                        title: "Health Status",
                        value: widget.tree.treeHealth,
                        icon: Icons.favorite,
                        color: healthColor,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        title: "Girth",
                        value: "${widget.tree.treeGirth} ft",
                        icon: Icons.forest,
                        color: Colors.brown,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        title: "Height",
                        value: "${widget.tree.treeHeight} ft",
                        icon: Icons.height,
                        color: Colors.blue,
                      ),
                    ]),
                  ),
                ),

                // Action Buttons
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        _buildActionButton(
                          context: context,
                          label: "Maintenance\nHistory",
                          icon: Images.maintenanceIcon,
                          color: AppColor.success,
                          onTap: () => AppRoute.goToNextPage(
                            context: context,
                            screen: TreeMaintenanceHistoryScreen.route,
                            arguments: {
                              'treeSpecies': widget.tree.treeSpecies.localName,
                              'location': "Mumbai",
                              'treeId': widget.tree.id,
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        _buildActionButton(
                          context: context,
                          label: "Monitoring\nHistory",
                          icon: Images.monitorIcon,
                          color: Colors.blue.shade600,
                          onTap: () => AppRoute.goToNextPage(
                            context: context,
                            screen: TreeMonitoringHistoryScreen.route,
                            arguments: {
                              'treeSpecies': widget.tree.treeSpecies.localName,
                              'location': "Mumbai",
                              'treeId': widget.tree.id,
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        _buildActionButton(
                          context: context,
                          label: "Satellite\nAnalysis",
                          icon: Images.monitorIcon,
                          color: Colors.purple.shade600,
                          onTap: () => AppRoute.goToNextPage(
                            context: context,
                            screen: SatelliteMonitoringResultScreen.route,
                            arguments:{
                              'monitorId': widget.tree.id
                            }, // Pass ID directly
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHealthBadge(Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            widget.tree.treeHealth,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                color: Colors.white,
                width: 24,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


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

/**/

