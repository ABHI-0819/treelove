import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:treelove/common/widgets/treelove_map.dart';
import 'package:treelove/common/bloc/api_event.dart';
import 'package:treelove/common/models/planted.list.response.model.dart';
import 'package:treelove/common/repositories/plantation_repository.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/core/network/base_network.dart';
import 'package:treelove/core/storage/preference_keys.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../common/screens/satellite_history_screen.dart';
import '../../../../core/config/resource/images.dart';
import '../../../../core/config/themes/app_color.dart';
import '../../../../core/network/api_connection.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/widgets/common_notification.dart';
import '../../../../core/widgets/tree_bottomsheet.dart';
import '../../../authentication/screens/sign_in_screen.dart';
import '../../../customer/retail/my-trees/screens/tree_maintenance_list.dart';
import '../../../customer/retail/my-trees/screens/tree_monitoring_history.dart';
import '../bloc/map_bloc.dart';

class VendorMapScreen extends StatefulWidget {
  static const route = '/VendorMapScreen';
  final String areaId;
  const VendorMapScreen({super.key, required this.areaId});

  @override
  State<VendorMapScreen> createState() => _VendorMapScreenState();
}

class _VendorMapScreenState extends State<VendorMapScreen>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  late MapBloc mapBloc;
  final pref = SecurePreference();
  bool _isMapView = true;
  String _searchQuery = '';
  late AnimationController _viewTransitionController;
  late Animation<double> _viewTransitionAnimation;

  @override
  void initState() {
    super.initState();
    mapBloc = MapBloc(PlantationRepository(api: ApiConnection()));
    _viewTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _viewTransitionAnimation = CurvedAnimation(
      parent: _viewTransitionController,
      curve: Curves.easeInOutCubic,
    );
    _fetchTreeList();
  }

  @override
  void dispose() {
    _viewTransitionController.dispose();
    super.dispose();
  }

  void _fetchTreeList() async {
    final vendorId = await pref.getString(Keys.id);
    mapBloc.add(ApiListFetch(areaId: widget.areaId, vendorId: vendorId));
  }

  void _toggleView(bool isMapView) {
    if (_isMapView == isMapView) return;

    setState(() {
      _isMapView = isMapView;
    });

    if (isMapView) {
      _viewTransitionController.reverse();
    } else {
      _viewTransitionController.forward();
    }
  }

  List<PlantedTreeModel> _filterTrees(List<PlantedTreeModel> trees) {
    if (_searchQuery.isEmpty) return trees;
    return trees
        .where((tree) =>
            tree.treeSpecies.localName
                    .toString()
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ==
                true ||
            tree.plantationDate.toString().contains(_searchQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      body: BlocProvider(
        create: (_) => mapBloc,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 8.h),
              SmoothToggleTab(
                isMapSelected: _isMapView,
                onToggle: _toggleView,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: BlocBuilder<MapBloc,
                    ApiState<PlantedListResponseModel, ResponseModel>>(
                  builder: (context, state) {
                    if (state is ApiLoading) {
                      return _buildLoadingState();
                    } else if (state is ApiSuccess<PlantedListResponseModel,
                        ResponseModel>) {
                      final plantedData = state.data;
                      final filteredTrees = _filterTrees(plantedData.data);

                      return AnimatedBuilder(
                        animation: _viewTransitionAnimation,
                        builder: (context, child) {
                          return Stack(
                            children: [
                              // Map View
                              IgnorePointer(
                                ignoring: !_isMapView,
                                child: Opacity(
                                  opacity: 1 - _viewTransitionAnimation.value,
                                  child: Transform.scale(
                                    scale: 1 -
                                        (_viewTransitionAnimation.value * 0.05),
                                    child: buildMapView(filteredTrees),
                                  ),
                                ),
                              ),
                              // List View
                              IgnorePointer(
                                ignoring: _isMapView,
                                child: Opacity(
                                  opacity: _viewTransitionAnimation.value,
                                  child: Transform.translate(
                                    offset: Offset(
                                        0,
                                        50 *
                                            (1 -
                                                _viewTransitionAnimation
                                                    .value)),
                                    child: _buildListView(filteredTrees),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      return _buildEmptyState();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child:
                  const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search trees...',
                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
                  prefixIcon:
                      Icon(Icons.search, color: Colors.grey[500], size: 20),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading trees...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.eco,
              size: 48,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "No trees found",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Try adjusting your search or check back later",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMapView(List<PlantedTreeModel> trees) {
    final markers = trees.map((datum) {
      final lat = datum.location.coordinates[1];
      final lng = datum.location.coordinates[0];
      return Marker(
        point: LatLng(lat, lng),
        width: 40,
        height: 40,
        child: GestureDetector(
          onTap: () {
            // _showEnhancedTreeBottomSheet(context, datum);
            TreeDetailsBottomSheet.show(
              context,
              treeName: datum.treeSpecies.localName,
              scientificName: datum.treeSpecies.scientificName,
              imageUrl: datum.thumbnail ?? datum.treeSpecies.image, // or null
              health: datum.treeHealth,
              growth: datum.treeGrowth,
              girth: '${datum.treeGirth} ${datum.treeGirthUnit}',
              treeHeight:
                  '${datum.treeHeight ?? '0'} ${datum.treeHeightUnit ?? 'ft'}',
              direction: 'Direction',
              onDirectionTap: () async {
                final url = Uri.parse(
                    'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              nextMaintenanceDate: datum.nextMaintenanceDate,
              nextMonitoringDate: datum.nextMonitoringDate,
              onMaintenanceHistoryTap: () {
                AppRoute.goToNextPage(
                    context: context,
                    screen: TreeMaintenanceHistoryScreen.route,
                    arguments: {'treeId': datum.id.toString()});
                // Navigate to maintenance history
              },
              onManualMonitorHistoryTap: () {
                AppRoute.goToNextPage(
                    context: context,
                    screen: TreeMonitoringHistoryScreen.route,
                    arguments: {'treeId': datum.id.toString()});
                // Navigate to manual monitoring history
              },
              onSatelliteMonitorHistoryTap: () {
                AppRoute.goToNextPage(
                    context: context,
                    screen: SatelliteHistoryScreen.route,
                    arguments: {
                      'plantationId': datum.id.toString(),
                    });
                // Navigate to satellite monitoring history
              },
            );
          },
          child: Container(
            // Add container to prevent tap conflicts
            width: 40,
            height: 40,
            child: SvgPicture.asset(Images.treeMarker),
          ),
        ),
      );
    }).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16), // Add margin here
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            TreeloveMap(
              mapController: _mapController,
              options: MapOptions(
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
                backgroundColor: Colors.grey.shade100,
                // Add tap handling at map level
                onTap: (tapPosition, point) {
                  // This prevents accidental bottom sheet opening when tapping on map
                  // Only markers should trigger the bottom sheet
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                  tileProvider: NetworkTileProvider(
                    headers: {
                      'User-Agent': 'TreelovApp/1.0 (https://yourapp.com)',
                    },
                  ),
                ),
                CurrentLocationLayer(),
                MarkerClusterLayerWidget(
                  options: MarkerClusterLayerOptions(
                    maxClusterRadius: 120,
                    size: const Size(48, 48),
                    disableClusteringAtZoom: 16,
                    markers: markers,
                    builder: (context, markers) {
                      final count = markers.length;
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF00473C),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            count > 99 ? '99+' : count.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            // Add zoom buttons only in map view
            buildZoomButtons(),
          ],
        ),
      ),
    );
  }

  // Improved zoom buttons with better positioning
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

  Widget _buildListView(List<PlantedTreeModel> trees) {
    if (trees.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        itemCount: trees.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final tree = trees[index];
          return _buildTreeCard(tree);
        },
      ),
    );
  }

  Widget _buildTreeCard(PlantedTreeModel tree) {
    final imageUrl = BaseNetwork.BASE_Image_URL + tree.thumbnail.toString();

    return GestureDetector(
      onTap: () {
        final lat = tree.location.coordinates[1];
        final lng = tree.location.coordinates[0];
        // _showEnhancedTreeBottomSheet(context, tree);
        TreeDetailsBottomSheet.show(
          context,
          treeName: tree.treeSpecies.localName,
          scientificName: tree.treeSpecies.scientificName,
          imageUrl: tree.thumbnail ?? tree.treeSpecies.image, // or null
          health: tree.treeHealth,
          growth: tree.treeGrowth,
          girth: '${tree.treeGirth} ${tree.treeGirthUnit}',
          treeHeight:
              '${tree.treeHeight ?? '0'} ${tree.treeHeightUnit ?? 'ft'}',
          direction: 'Direction',
          onDirectionTap: () async {
            final url = Uri.parse(
                'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            }
          },
          nextMaintenanceDate: tree.nextMaintenanceDate,
          nextMonitoringDate: tree.nextMonitoringDate,
          onMaintenanceHistoryTap: () {
            AppRoute.goToNextPage(
                context: context,
                screen: TreeMaintenanceHistoryScreen.route,
                arguments: {'treeId': tree.id});
            // Navigate to maintenance history
          },
          onManualMonitorHistoryTap: () {
            AppRoute.goToNextPage(
                context: context,
                screen: TreeMonitoringHistoryScreen.route,
                arguments: {'treeId': tree.id});
            // Navigate to manual monitoring history
          },
          onSatelliteMonitorHistoryTap: () {
            AppRoute.goToNextPage(
                context: context,
                screen: SatelliteHistoryScreen.route,
                arguments: {
                  'plantationId': tree.id,
                });
            // Navigate to satellite monitoring history
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.park_outlined,
                        color: Colors.green[400],
                        size: 32,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            tree.treeSpecies.localName.toString() ??
                                "Unknown Species",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColor.primaryDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildMiniHealthBadge(tree.treeHealth),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tree.treeSpecies.scientificName.toString() ?? "Unknown",
                      style: TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[500],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.height, size: 14, color: AppColor.secondary),
                        const SizedBox(width: 4),
                        Text(
                          "${tree.treeHeight ?? '0'} ${tree.treeHeightUnit ?? 'ft'}",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.straighten,
                            size: 14, color: AppColor.secondaryDark),
                        const SizedBox(width: 4),
                        Text(
                          "${tree.treeGirth ?? '0'} ${tree.treeGirthUnit ?? 'inch'}",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniHealthBadge(String health) {
    Color badgeColor = Colors.green;
    String status = health.toLowerCase();

    if (status.contains('warning') || status.contains('fair')) {
      badgeColor = Colors.orange;
    } else if (status.contains('critical') ||
        status.contains('poor') ||
        status.contains('bad')) {
      badgeColor = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: badgeColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite, size: 10, color: badgeColor),
          const SizedBox(width: 4),
          Text(
            health.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showEnhancedTreeBottomSheet(
      BuildContext context, PlantedTreeModel treeModel) {
    final lat = treeModel.location.coordinates[1];
    final lng = treeModel.location.coordinates[0];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  // Drag Handle
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildImageSection(treeModel),
                          const SizedBox(height: 24),
                          _buildTreeInfoSection(treeModel),
                          const SizedBox(height: 24),
                          _buildActionButtons(ctx, lat, lng),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildImageSection(PlantedTreeModel treeModel) {
    final imageUrl =
        BaseNetwork.BASE_Image_URL + treeModel.treeSpecies.image.toString();

    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     blurRadius: 15,
        //     offset: const Offset(0, 4),
        //   ),
        // ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.network(
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRuCZtWNJjBjxoVw9OCxZXKQE-biHdtZ7c5Ig&s");
          },
        ),
      ),
    );
  }

  Widget _buildTreeInfoSection(PlantedTreeModel datum) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          datum.treeSpecies.localName.toString() ?? "Unknown Tree",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(
          height: 2,
        ),
        Text(
          datum.treeSpecies.scientificName.toString() ??
              "Scientific name unavailable",
          style: TextStyle(
            fontSize: 18,
            fontStyle: FontStyle.italic,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildEnhancedInfoCard(
              "Height",
              "${datum.treeHeight} ft",
              Icons.height,
              Colors.blue,
            ),
            _buildEnhancedInfoCard(
              "Girth",
              "${datum.treeGirth} ft",
              Icons.donut_large,
              Colors.orange,
            ),
            _buildEnhancedInfoCard(
              "Planted",
              _formatDate(datum.plantationDate.toString()),
              Icons.calendar_today,
              Colors.green,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEnhancedInfoCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      width: (MediaQuery.of(context).size.width - 72) / 2,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: color,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext ctx, double lat, double lng) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                onPressed: () {
                  // Navigate to maintenance history
                  Navigator.pop(ctx);
                },
                icon: Icons.history,
                label: "History",
                isPrimary: false,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionButton(
                onPressed: () {
                  _openMapsApp(lat, lng);
                  Navigator.pop(ctx);
                },
                icon: Icons.navigation,
                label: "Navigate",
                isPrimary: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required bool isPrimary,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Colors.green[600] : Colors.grey[100],
          foregroundColor: isPrimary ? Colors.white : Colors.black87,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return dateString;
    }
  }

  void _openMapsApp(double lat, double lng) async {
    String url = "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showNotification(context, message: "Could not open maps");
    }
  }
}

class SmoothToggleTab extends StatefulWidget {
  final bool isMapSelected;
  final Function(bool) onToggle;

  const SmoothToggleTab({
    super.key,
    required this.isMapSelected,
    required this.onToggle,
  });

  @override
  State<SmoothToggleTab> createState() => _SmoothToggleTabState();
}

class _SmoothToggleTabState extends State<SmoothToggleTab>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    if (widget.isMapSelected) {
      _controller.reset();
    } else {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(SmoothToggleTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isMapSelected != widget.isMapSelected) {
      if (widget.isMapSelected) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Align(
                alignment: Alignment.lerp(
                  const Alignment(-1, 0),
                  const Alignment(1, 0),
                  _animation.value,
                )!,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    width: (MediaQuery.sizeOf(context).width - 40) / 2,
                    height: 42,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green[400]!, Colors.green[600]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => widget.onToggle(true),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'Map',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: widget.isMapSelected
                              ? Colors.white
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => widget.onToggle(false),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'List',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: !widget.isMapSelected
                              ? Colors.white
                              : Colors.grey[600],
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
    );
  }
}
