import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:treelove/features/customer/retail/maintenance/bloc/inquiry_bloc.dart';

import '../../../../common/bloc/api_event.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/planted.list.response.model.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../common/repositories/inquiries_repository.dart';
import '../../../../common/repositories/plantation_repository.dart';
import '../../../../core/config/resource/images.dart';
import '../../../../core/config/route/app_route.dart';
import '../../../../core/config/themes/app_color.dart';
import '../../../../core/network/api_connection.dart';
import '../../../authentication/screens/sign_in_screen.dart';
import '../../../vendor/home/bloc/map_bloc.dart';
/*
class PlantedTreeMapScreen extends StatefulWidget {
  static const route = '/planted-trees-map';
  const PlantedTreeMapScreen({super.key});

  @override
  State<PlantedTreeMapScreen> createState() => _PlantedTreeMapScreenState();
}

class _PlantedTreeMapScreenState extends State<PlantedTreeMapScreen>
    with TickerProviderStateMixin {

  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  late MapBloc mapBloc;

  List<PlantedTreeModel> _filteredTrees = [];
  List<PlantedTreeModel> _allTrees = [];
  Set<String> selectedTreeIds = {}; // Track selected tree IDs

  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    mapBloc = MapBloc(PlantationRepository(api: ApiConnection()));
    mapBloc.add(ApiListFetch());
    _searchController.addListener(_filterTrees);
  }

  void _filterTrees() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredTrees = _allTrees;
        isSearching = false;
      } else {
        isSearching = true;
        _filteredTrees = _allTrees.where((tree) {
          return tree.treeSpecies.localName.toLowerCase().contains(query) ||
              tree.treeSpecies.scientificName.toLowerCase().contains(query) ||
              tree.id.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void _toggleTreeSelection(PlantedTreeModel tree) {
    setState(() {
      if (selectedTreeIds.contains(tree.id)) {
        selectedTreeIds.remove(tree.id);
      } else {
        selectedTreeIds.add(tree.id);
      }
    });
  }

  void _submitSelection() {
    if (selectedTreeIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select at least one tree'),
          backgroundColor: AppColor.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Get selected trees
    final selectedTrees = _allTrees.where((tree) => selectedTreeIds.contains(tree.id)).toList();

    // TODO: Handle submission
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: AppColor.success),
            SizedBox(width: 12),
            Text('Confirm Selection'),
          ],
        ),
        content: Text(
          'You have selected ${selectedTreeIds.length} tree(s).\n\nDo you want to submit?',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColor.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Your submit logic here
              print('Selected Tree IDs: $selectedTreeIds');
              print('Selected Trees: ${selectedTrees.map((t) => t.treeSpecies.localName).join(", ")}');

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${selectedTreeIds.length} trees submitted successfully!'),
                  backgroundColor: AppColor.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );

              // Clear selection after submit
              setState(() {
                selectedTreeIds.clear();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              foregroundColor: AppColor.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _clearSelection() {
    setState(() {
      selectedTreeIds.clear();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: BlocProvider(
        create: (context) => mapBloc,
        child: Stack(
          children: [
            // Map
            Positioned.fill(
              child: _buildMapView(),
            ),

            // Header with Search
            _buildHeader(),

            // Zoom Controls
            _buildZoomControls(),

            // Selection Info Card (top right)
            if (selectedTreeIds.isNotEmpty) _buildSelectionCounter(),

            // Submit Button (bottom)
            if (selectedTreeIds.isNotEmpty) _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // 🎯 Header with Search
  Widget _buildHeader() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Bar
            Row(
              children: [
                // Back Button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.primary.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColor.primary,
                      size: 20,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Title
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.primary.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.park_rounded,
                          color: AppColor.primary,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "My Trees",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColor.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                style: TextStyle(fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Search trees by name or ID...',
                  hintStyle: TextStyle(
                    color: AppColor.textMuted,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(Icons.search, color: AppColor.primary, size: 22),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: Icon(Icons.clear, color: AppColor.textMuted, size: 20),
                    onPressed: () => _searchController.clear(),
                  )
                      : null,
                  filled: true,
                  fillColor: AppColor.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2);
  }

  // 🗺️ Map View
  Widget _buildMapView() {
    return BlocConsumer<MapBloc, ApiState<PlantedListResponseModel, ResponseModel>>(
      listener: (context, state) {
        if (state is TokenExpired<PlantedListResponseModel, ResponseModel>) {
          AppRoute.pushReplacement(context, SignInScreen.route, arguments: {});
        }
        if (state is ApiSuccess<PlantedListResponseModel, ResponseModel>) {
          setState(() {
            _allTrees = state.data.data;
            _filteredTrees = _allTrees;
          });
        }
      },
      builder: (context, state) {
        if (state is ApiLoading<PlantedListResponseModel, ResponseModel>) {
          return _buildLoadingState();
        }

        if (state is ApiFailure<PlantedListResponseModel, ResponseModel>) {
          return _buildErrorState(state.error.message ?? 'Something went wrong!');
        }

        if (state is ApiSuccess<PlantedListResponseModel, ResponseModel>) {
          final treesToShow = isSearching ? _filteredTrees : state.data.data;
          final markers = treesToShow.map((tree) => _buildTreeMarker(tree)).toList();

          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(19.112251, 72.864512),
              initialZoom: 12.0,
              minZoom: 3.0,
              maxZoom: 20.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.doubleTapZoom |
                InteractiveFlag.pinchZoom |
                InteractiveFlag.drag |
                InteractiveFlag.flingAnimation,
              ),
              backgroundColor: AppColor.grey,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
                tileProvider: NetworkTileProvider(
                  headers: {
                    'User-Agent': 'TreelovApp/1.0',
                  },
                ),
              ),
              if (markers.isNotEmpty) MarkerLayer(markers: markers),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }

  // 🌳 Tree Marker with Selection
  Marker _buildTreeMarker(PlantedTreeModel tree) {
    final lat = tree.location.coordinates[1];
    final lng = tree.location.coordinates[0];
    final isSelected = selectedTreeIds.contains(tree.id);

    return Marker(
      point: LatLng(lat, lng),
      width: isSelected ? 65 : 50,
      height: isSelected ? 65 : 50,
      child: GestureDetector(
        onTap: () => _toggleTreeSelection(tree),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Pulsing Ring for Selected
            if (isSelected)
              Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColor.accent,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.accent.withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              )
                  .animate(onPlay: (controller) => controller.repeat())
                  .scale(begin: Offset(1, 1), end: Offset(1.15, 1.15), duration: 1000.ms)
                  .then()
                  .scale(begin: Offset(1.15, 1.15), end: Offset(1, 1), duration: 1000.ms),

            // Tree Icon
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColor.accent : Colors.transparent,
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: AppColor.accent.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
                    : null,
              ),
              padding: EdgeInsets.all(isSelected ? 8 : 0),
              child: SvgPicture.asset(
                Images.treeMarker,
                width: isSelected ? 32 : 40,
                height: isSelected ? 32 : 40,
                color: isSelected ? AppColor.white : _getHealthColor(tree.treeHealth),
              ),
            ),

            // Check Badge
            if (isSelected)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColor.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColor.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.success.withOpacity(0.4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.check,
                    color: AppColor.white,
                    size: 12,
                  ),
                ),
              ).animate().scale(duration: 300.ms, curve: Curves.elasticOut),
          ],
        ),
      ),
    );//.animate(target: isSelected ? 1 : 0).scale(duration: 300.ms, curve: Curves.easeOut);
  }

  // 🎮 Zoom Controls
  Widget _buildZoomControls() {
    return Positioned(
      right: 16,
      bottom: selectedTreeIds.isNotEmpty ? 160 : 80,
      child: Column(
        children: [
          _buildZoomButton(Icons.add, () {
            final zoom = _mapController.camera.zoom;
            if (zoom < 20) _mapController.move(_mapController.camera.center, zoom + 1);
          }),
          const SizedBox(height: 10),
          _buildZoomButton(Icons.remove, () {
            final zoom = _mapController.camera.zoom;
            if (zoom > 3) _mapController.move(_mapController.camera.center, zoom - 1);
          }),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildZoomButton(IconData icon, VoidCallback onTap) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Icon(icon, size: 22, color: AppColor.primary),
        ),
      ),
    );
  }

  // 📊 Selection Counter (Top Right)
  Widget _buildSelectionCounter() {
    return Positioned(
      top: 160,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColor.primary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColor.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColor.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: AppColor.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${selectedTreeIds.length}',
                  style: TextStyle(
                    color: AppColor.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Selected',
                  style: TextStyle(
                    color: AppColor.white.withOpacity(0.9),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 300.ms)
          .slideX(begin: 0.3)
          .then()
          .shimmer(duration: 1500.ms, color: AppColor.white.withOpacity(0.3)),
    );
  }

  // ✅ Submit Button (Bottom)
  Widget _buildSubmitButton() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle Bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColor.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: 16),

              // Info Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColor.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.forest,
                      color: AppColor.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${selectedTreeIds.length} Tree${selectedTreeIds.length > 1 ? "s" : ""} Selected',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColor.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Ready to submit your selection',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColor.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _clearSelection,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColor.error,
                    ),
                    child: Text(
                      'Clear',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitSelection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: AppColor.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        'Submit Selection',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )
          .animate()
          .slideY(begin: 1, duration: 400.ms, curve: Curves.easeOutCubic)
          .fadeIn(),
    );
  }

  // 🔄 Loading State
  Widget _buildLoadingState() {
    return Container(
      color: AppColor.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColor.primary,
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            Text(
              'Loading trees...',
              style: TextStyle(
                color: AppColor.textSecondary,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ❌ Error State
  Widget _buildErrorState(String message) {
    return Container(
      color: AppColor.background,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 72, color: AppColor.error),
              const SizedBox(height: 20),
              Text(
                'Error Loading Trees',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: () => mapBloc.add(ApiListFetch()),
                icon: const Icon(Icons.refresh, size: 20),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  foregroundColor: AppColor.white,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getHealthColor(String health) {
    switch (health.toLowerCase()) {
      case 'excellent':
      case 'healthy':
        return AppColor.success;
      case 'good':
        return AppColor.secondary;
      case 'fair':
        return AppColor.warning;
      default:
        return AppColor.error;
    }
  }
}

 */
/*
class PlantedTreeMapScreen extends StatefulWidget {
  static const route = '/planted-trees-map';
  const PlantedTreeMapScreen({super.key});

  @override
  State<PlantedTreeMapScreen> createState() => _PlantedTreeMapScreenState();
}

class _PlantedTreeMapScreenState extends State<PlantedTreeMapScreen>
    with TickerProviderStateMixin {

  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  late MapBloc mapBloc;
  late InquiryBloc inquiryBloc;
  List<PlantedTreeModel> _filteredTrees = [];
  List<PlantedTreeModel> _allTrees = [];
  Set<String> selectedTreeIds = {};

  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    mapBloc = MapBloc(PlantationRepository(api: ApiConnection()));
    inquiryBloc = InquiryBloc(InquiriesRepository(api: ApiConnection()));
    mapBloc.add(ApiListFetch());
    _searchController.addListener(_filterTrees);
  }

  void _filterTrees() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredTrees = _allTrees;
        isSearching = false;
      } else {
        isSearching = true;
        _filteredTrees = _allTrees.where((tree) {
          return tree.treeSpecies.localName.toLowerCase().contains(query) ||
              tree.treeSpecies.scientificName.toLowerCase().contains(query) ||
              tree.id.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void _toggleTreeSelection(PlantedTreeModel tree) {
    setState(() {
      if (selectedTreeIds.contains(tree.id)) {
        selectedTreeIds.remove(tree.id);
      } else {
        selectedTreeIds.add(tree.id);
      }
    });
  }

  void _submitSelection() {
    if (selectedTreeIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select at least one tree'),
          backgroundColor: AppColor.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final selectedTrees = _allTrees.where((tree) => selectedTreeIds.contains(tree.id)).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: AppColor.success),
            SizedBox(width: 12),
            Text('Confirm Selection'),
          ],
        ),
        content: Text(
          'You have selected ${selectedTreeIds.length} tree(s).\n\nDo you want to submit?',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColor.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              print('Selected Tree IDs: $selectedTreeIds');
              print('Selected Trees: ${selectedTrees.map((t) => t.treeSpecies.localName).join(", ")}');

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${selectedTreeIds.length} trees submitted successfully!'),
                  backgroundColor: AppColor.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );

              setState(() {
                selectedTreeIds.clear();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              foregroundColor: AppColor.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _clearSelection() {
    setState(() {
      selectedTreeIds.clear();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: MultiBlocProvider(
  providers: [
    BlocProvider(
        create: (context) => mapBloc,
),
    BlocProvider(
      create: (context) => inquiryBloc,
    ),
  ],
  child: Stack(
          children: [
            // Map Layer - Full Screen
            Positioned.fill(
              child: _buildMapView(),
            ),

            // Header with Search - Fixed at top with proper padding
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildHeader(topPadding),
            ),

            // Selection Counter - Below header on right side
            if (selectedTreeIds.isNotEmpty)
              Positioned(
                top: topPadding + 140, // Below header (adjust based on your header height)
                right: 16,
                child: _buildSelectionCounter(),
              ),

            // Zoom Controls - Right side, above bottom button
            Positioned(
              right: 16,
              bottom: selectedTreeIds.isNotEmpty ? 200 + bottomPadding : 80 + bottomPadding,
              child: _buildZoomControls(),
            ),

            // Submit Button - Fixed at bottom
            if (selectedTreeIds.isNotEmpty)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildSubmitButton(bottomPadding),
              ),
          ],
        ),
),
    );
  }

  // 🎯 Header with Search - Updated with explicit padding parameter
  Widget _buildHeader(double topPadding) {
    return Container(
      padding: EdgeInsets.only(
        top: topPadding + 16,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColor.white,
            AppColor.white.withOpacity(0.9),
            AppColor.white.withOpacity(0.0),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Bar
          Row(
            children: [
              // Back Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.primary.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColor.primary,
                    size: 20,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Title
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.primary.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.park_rounded,
                        color: AppColor.primary,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "My Trees",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColor.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColor.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              style: TextStyle(fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Search trees by name or ID...',
                hintStyle: TextStyle(
                  color: AppColor.textMuted,
                  fontSize: 14,
                ),
                prefixIcon: Icon(Icons.search, color: AppColor.primary, size: 22),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear, color: AppColor.textMuted, size: 20),
                  onPressed: () => _searchController.clear(),
                )
                    : null,
                filled: true,
                fillColor: AppColor.grey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2);
  }

  // 🗺️ Map View - Same as before
  Widget _buildMapView() {
    return BlocConsumer<MapBloc, ApiState<PlantedListResponseModel, ResponseModel>>(
      listener: (context, state) {
        if (state is TokenExpired<PlantedListResponseModel, ResponseModel>) {
          AppRoute.pushReplacement(context, SignInScreen.route, arguments: {});
        }
        if (state is ApiSuccess<PlantedListResponseModel, ResponseModel>) {
          setState(() {
            _allTrees = state.data.data;
            _filteredTrees = _allTrees;
          });
        }
      },
      builder: (context, state) {
        if (state is ApiLoading<PlantedListResponseModel, ResponseModel>) {
          return _buildLoadingState();
        }

        if (state is ApiFailure<PlantedListResponseModel, ResponseModel>) {
          return _buildErrorState(state.error.message ?? 'Something went wrong!');
        }

        if (state is ApiSuccess<PlantedListResponseModel, ResponseModel>) {
          final treesToShow = isSearching ? _filteredTrees : state.data.data;
          final markers = treesToShow.map((tree) => _buildTreeMarker(tree)).toList();

          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(19.112251, 72.864512),
              initialZoom: 12.0,
              minZoom: 3.0,
              maxZoom: 20.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.doubleTapZoom |
                InteractiveFlag.pinchZoom |
                InteractiveFlag.drag |
                InteractiveFlag.flingAnimation,
              ),
              backgroundColor: AppColor.grey,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
                tileProvider: NetworkTileProvider(
                  headers: {
                    'User-Agent': 'TreelovApp/1.0',
                  },
                ),
              ),
              if (markers.isNotEmpty) MarkerLayer(markers: markers),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }

  // 🌳 Tree Marker - Same as before
  Marker _buildTreeMarker(PlantedTreeModel tree) {
    final lat = tree.location.coordinates[1];
    final lng = tree.location.coordinates[0];
    final isSelected = selectedTreeIds.contains(tree.id);

    return Marker(
      point: LatLng(lat, lng),
      width: isSelected ? 65 : 50,
      height: isSelected ? 65 : 50,
      child: GestureDetector(
        onTap: () => _toggleTreeSelection(tree),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isSelected)
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColor.accent,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.accent.withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              )
                  .animate(onPlay: (controller) => controller.repeat())
                  .scale(begin: Offset(1, 1), end: Offset(1.15, 1.15), duration: 1000.ms)
                  .then()
                  .scale(begin: Offset(1.15, 1.15), end: Offset(1, 1), duration: 1000.ms),

            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColor.accent : Colors.transparent,
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: AppColor.accent.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
                    : null,
              ),
              padding: EdgeInsets.all(isSelected ? 8 : 0),
              child: SvgPicture.asset(
                Images.treeMarker,
                width: isSelected ? 32 : 40,
                height: isSelected ? 32 : 40,
                // color: isSelected ? AppColor.white : _getHealthColor(tree.treeHealth),
              ),
            ),

            if (isSelected)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColor.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColor.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.success.withOpacity(0.4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.check,
                    color: AppColor.white,
                    size: 12,
                  ),
                ),
              ).animate().scale(duration: 300.ms, curve: Curves.elasticOut),
          ],
        ),
      ),
    );
  }

  // 🎮 Zoom Controls - Updated to return widget directly
  Widget _buildZoomControls() {
    return Column(
      children: [
        _buildZoomButton(Icons.add, () {
          final zoom = _mapController.camera.zoom;
          if (zoom < 20) _mapController.move(_mapController.camera.center, zoom + 1);
        }),
        const SizedBox(height: 10),
        _buildZoomButton(Icons.remove, () {
          final zoom = _mapController.camera.zoom;
          if (zoom > 3) _mapController.move(_mapController.camera.center, zoom - 1);
        }),
      ],
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildZoomButton(IconData icon, VoidCallback onTap) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Icon(icon, size: 22, color: AppColor.primary),
        ),
      ),
    );
  }

  // 📊 Selection Counter - Updated to return widget directly
  Widget _buildSelectionCounter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColor.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              color: AppColor.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${selectedTreeIds.length}',
                style: TextStyle(
                  color: AppColor.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Selected',
                style: TextStyle(
                  color: AppColor.white.withOpacity(0.9),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideX(begin: 0.3)
        .then()
        .shimmer(duration: 1500.ms, color: AppColor.white.withOpacity(0.3));
  }

  // ✅ Submit Button - Updated with explicit padding parameter
  Widget _buildSubmitButton(double bottomPadding) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: 20 + bottomPadding,
      ),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle Bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColor.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 16),

          // Info Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColor.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.forest,
                  color: AppColor.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${selectedTreeIds.length} Tree${selectedTreeIds.length > 1 ? "s" : ""} Selected',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColor.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Ready to submit your selection',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColor.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: _clearSelection,
                style: TextButton.styleFrom(
                  foregroundColor: AppColor.error,
                ),
                child: Text(
                  'Clear',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitSelection,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                foregroundColor: AppColor.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    'Submit Selection',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .slideY(begin: 1, duration: 400.ms, curve: Curves.easeOutCubic)
        .fadeIn();
  }

  // 🔄 Loading State - Same as before
  Widget _buildLoadingState() {
    return Container(
      color: AppColor.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColor.primary,
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            Text(
              'Loading trees...',
              style: TextStyle(
                color: AppColor.textSecondary,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ❌ Error State - Same as before
  Widget _buildErrorState(String message) {
    return Container(
      color: AppColor.background,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 72, color: AppColor.error),
              const SizedBox(height: 20),
              Text(
                'Error Loading Trees',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: () => mapBloc.add(ApiListFetch()),
                icon: const Icon(Icons.refresh, size: 20),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  foregroundColor: AppColor.white,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getHealthColor(String health) {
    switch (health.toLowerCase()) {
      case 'excellent':
      case 'healthy':
        return AppColor.success;
      case 'good':
        return AppColor.secondary;
      case 'fair':
        return AppColor.warning;
      default:
        return AppColor.error;
    }
  }
}

 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Core

import '../../../../core/config/constants/enum/inquiry_type_enum.dart';

// Network
import '../../../../core/network/api_connection.dart';
import 'models/inquiry_request_model.dart';

class PlantedTreeMapScreen extends StatefulWidget {
  static const route = '/planted-trees-map';
  final InquiryType inquiryType;
  const PlantedTreeMapScreen({required this.inquiryType,super.key});

  @override
  State<PlantedTreeMapScreen> createState() => _PlantedTreeMapScreenState();
}

class _PlantedTreeMapScreenState extends State<PlantedTreeMapScreen>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  late MapBloc mapBloc;
  late InquiryBloc inquiryBloc;
  List<PlantedTreeModel> _filteredTrees = [];
  List<PlantedTreeModel> _allTrees = [];
  Set<String> selectedTreeIds = {};

  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    mapBloc = MapBloc(PlantationRepository(api: ApiConnection()));
    inquiryBloc = InquiryBloc(InquiriesRepository(api: ApiConnection()));
    mapBloc.add(ApiListFetch());
    _searchController.addListener(_filterTrees);
  }

  @override
  void dispose() {
    _searchController.dispose();
    // Let BlocProvider handle disposal — no need to close manually
    super.dispose();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColor.secondary,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Inquiry Submitted!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColor.primary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "We'll get back to you within 24 hours.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColor.textSecondary),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  selectedTreeIds.clear();// dismiss dialog
                  //  Clear form & refocus
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.secondary,
                  foregroundColor: AppColor.cardBackground,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Done",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _filterTrees() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredTrees = _allTrees;
        isSearching = false;
      } else {
        isSearching = true;
        _filteredTrees = _allTrees.where((tree) {
          return tree.treeSpecies.localName.toLowerCase().contains(query) ||
              tree.treeSpecies.scientificName.toLowerCase().contains(query) ||
              tree.id.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void _toggleTreeSelection(PlantedTreeModel tree) {
    setState(() {
      if (selectedTreeIds.contains(tree.id)) {
        selectedTreeIds.remove(tree.id);
      } else {
        selectedTreeIds.add(tree.id);
      }
    });
  }

  void _submitSelection() {
    if (selectedTreeIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select at least one tree'),
          backgroundColor: AppColor.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: AppColor.success),
            SizedBox(width: 12),
            Text('Confirm Selection'),
          ],
        ),
        content: Text(
          'You have selected ${selectedTreeIds.length} tree(s).\n\nDo you want to submit?',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColor.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final request = InquiryRequestModel.withoutLocation(
                inquiryType: widget.inquiryType,
                treeIds: selectedTreeIds.toList(),
                 description: "Inquiry" ,
              );
              // Use context.read to go through provider
              inquiryBloc.add(ApiAdd(request));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              foregroundColor: AppColor.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _clearSelection() {
    setState(() {
      selectedTreeIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    // ✅ CORRECT ORDER: MultiBlocProvider > BlocListener > Scaffold
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => mapBloc),
        BlocProvider(create: (context) => inquiryBloc),
      ],
      child: BlocListener<InquiryBloc, ApiState<ResponseModel, ResponseModel>>(
        listener: (context, state) {
          if (state is ApiSuccess) {
            _showSuccessDialog();
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text('${selectedTreeIds.length} trees submitted successfully!'),
            //     backgroundColor: AppColor.success,
            //     behavior: SnackBarBehavior.floating,
            //   ),
            // );
            setState(() {
              selectedTreeIds.clear();
            });
          } else if (state is ApiFailure<ResponseModel, ResponseModel>) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error.message ?? 'Failed to submit inquiry.'),
                backgroundColor: AppColor.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColor.scaffoldBackground,
          body: Stack(
            children: [
              // Map Layer - Full Screen
              Positioned.fill(
                child: _buildMapView(),
              ),

              // Header with Search
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildHeader(topPadding),
              ),

              // Selection Counter
              if (selectedTreeIds.isNotEmpty)
                Positioned(
                  top: topPadding + 140,
                  right: 16,
                  child: _buildSelectionCounter(),
                ),

              // Zoom Controls
              Positioned(
                right: 16,
                bottom: selectedTreeIds.isNotEmpty
                    ? 200 + bottomPadding
                    : 80 + bottomPadding,
                child: _buildZoomControls(),
              ),

              // Submit Button
              if (selectedTreeIds.isNotEmpty)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildSubmitButton(bottomPadding),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double topPadding) {
    return Container(
      padding: EdgeInsets.only(
        top: topPadding + 16,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColor.white,
            AppColor.white.withOpacity(0.9),
            AppColor.white.withOpacity(0.0),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.primary.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColor.primary,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.primary.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.park_rounded,
                        color: AppColor.primary,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "My Trees",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColor.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColor.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              style: TextStyle(fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Search trees by name or ID...',
                hintStyle: TextStyle(
                  color: AppColor.textMuted,
                  fontSize: 14,
                ),
                prefixIcon: Icon(Icons.search, color: AppColor.primary, size: 22),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear, color: AppColor.textMuted, size: 20),
                  onPressed: () => _searchController.clear(),
                )
                    : null,
                filled: true,
                fillColor: AppColor.grey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return BlocConsumer<MapBloc, ApiState<PlantedListResponseModel, ResponseModel>>(
      listener: (context, state) {
        if (state is TokenExpired<PlantedListResponseModel, ResponseModel>) {
          AppRoute.pushReplacement(context, SignInScreen.route, arguments: {});
        }
        if (state is ApiSuccess<PlantedListResponseModel, ResponseModel>) {
          setState(() {
            _allTrees = state.data.data;
            _filteredTrees = _allTrees;
          });
        }
      },
      builder: (context, state) {
        if (state is ApiLoading<PlantedListResponseModel, ResponseModel>) {
          return _buildLoadingState();
        }
        if (state is ApiFailure<PlantedListResponseModel, ResponseModel>) {
          return _buildErrorState(state.error.message ?? 'Something went wrong!');
        }
        if (state is ApiSuccess<PlantedListResponseModel, ResponseModel>) {
          final treesToShow = isSearching ? _filteredTrees : state.data.data;
          final markers = treesToShow.map((tree) => _buildTreeMarker(tree)).toList();
          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(19.112251, 72.864512),
              initialZoom: 12.0,
              minZoom: 3.0,
              maxZoom: 20.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.doubleTapZoom |
                InteractiveFlag.pinchZoom |
                InteractiveFlag.drag |
                InteractiveFlag.flingAnimation,
              ),
              backgroundColor: AppColor.grey,

            ),
            children: [
              TileLayer(
                urlTemplate: 'https://a.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
                tileProvider: NetworkTileProvider(
                  headers: {
                    'User-Agent': 'Treelov/1.0',
                  },
                ),
              ),
              if (markers.isNotEmpty) MarkerLayer(markers: markers),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  Marker _buildTreeMarker(PlantedTreeModel tree) {
    final lat = tree.location.coordinates[1];
    final lng = tree.location.coordinates[0];
    final isSelected = selectedTreeIds.contains(tree.id);

    return Marker(
      point: LatLng(lat, lng),
      width: isSelected ? 65 : 50,
      height: isSelected ? 65 : 50,
      child: GestureDetector(
        onTap: () => _toggleTreeSelection(tree),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isSelected)
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColor.accent,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.accent.withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColor.accent : Colors.transparent,
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: AppColor.accent.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
                    : null,
              ),
              padding: EdgeInsets.all(isSelected ? 8 : 0),
              child: SvgPicture.asset(
                Images.treeMarker,
                width: isSelected ? 32 : 40,
                height: isSelected ? 32 : 40,
              ),
            ),
            if (isSelected)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColor.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColor.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.success.withOpacity(0.4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.check,
                    color: AppColor.white,
                    size: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildZoomControls() {
    return Column(
      children: [
        _buildZoomButton(Icons.add, () {
          final zoom = _mapController.camera.zoom;
          if (zoom < 20) _mapController.move(_mapController.camera.center, zoom + 1);
        }),
        const SizedBox(height: 10),
        _buildZoomButton(Icons.remove, () {
          final zoom = _mapController.camera.zoom;
          if (zoom > 3) _mapController.move(_mapController.camera.center, zoom - 1);
        }),
      ],
    );
  }

  Widget _buildZoomButton(IconData icon, VoidCallback onTap) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Icon(icon, size: 22, color: AppColor.primary),
        ),
      ),
    );
  }

  Widget _buildSelectionCounter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColor.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              color: AppColor.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${selectedTreeIds.length}',
                style: TextStyle(
                  color: AppColor.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Selected',
                style: TextStyle(
                  color: AppColor.white.withOpacity(0.9),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(double bottomPadding) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: 20 + bottomPadding,
      ),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColor.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColor.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.forest,
                  color: AppColor.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${selectedTreeIds.length} Tree${selectedTreeIds.length > 1 ? "s" : ""} Selected',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColor.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Ready to submit your selection',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColor.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: _clearSelection,
                style: TextButton.styleFrom(
                  foregroundColor: AppColor.error,
                ),
                child: Text(
                  'Clear',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          BlocBuilder<InquiryBloc, ApiState<ResponseModel, ResponseModel>>(
            builder: (context, state) {
              final isLoading = state is ApiLoading;
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submitSelection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLoading ? AppColor.grey : AppColor.primary,
                    foregroundColor: AppColor.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  child: isLoading
                      ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        'Submit Selection',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      color: AppColor.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColor.primary,
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            Text(
              'Loading trees...',
              style: TextStyle(
                color: AppColor.textSecondary,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      color: AppColor.background,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 72, color: AppColor.error),
              const SizedBox(height: 20),
              Text(
                'Error Loading Trees',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: () => mapBloc.add(ApiListFetch()),
                icon: const Icon(Icons.refresh, size: 20),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  foregroundColor: AppColor.white,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getHealthColor(String health) {
    switch (health.toLowerCase()) {
      case 'excellent':
      case 'healthy':
        return AppColor.success;
      case 'good':
        return AppColor.secondary;
      case 'fair':
        return AppColor.warning;
      default:
        return AppColor.error;
    }
  }
}