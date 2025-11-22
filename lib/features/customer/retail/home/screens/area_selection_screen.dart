import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/bloc/api_event.dart';
import '../../../../../common/bloc/api_state.dart';
import '../../../../../common/models/response.mode.dart';
import '../../../../../common/repositories/project_area_repository.dart';
import '../../../../../core/config/route/app_route.dart';
import '../../../../../core/config/themes/app_color.dart';
import '../../../../../core/config/themes/app_fonts.dart';
import '../../../../../core/network/api_connection.dart';
import '../../../../../core/utils/logger.dart';
import '../../../../fieldworker/activity/bloc/project_area_bloc.dart';
import '../../../../fieldworker/activity/models/project_area_list_response.dart';
import '../../tree-species/tree_species_list.dart';
/*
class AreaSelectionScreen extends StatefulWidget {
  static const route = "/area-selection";
  final String ? projectId;
  final int ? treeCount;
  const AreaSelectionScreen({Key? key, this.projectId,this.treeCount=1}) : super(key: key);

  @override
  State<AreaSelectionScreen> createState() => _AreaSelectionScreenState();
}

class _AreaSelectionScreenState extends State<AreaSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  late ProjectAreaBloc projectAreaBloc;

  @override
  void initState() {
    projectAreaBloc =
        ProjectAreaBloc(ProjectAreaRepository(api: ApiConnection()));
    if (widget.projectId != null) {
      debugLog(widget.projectId.toString(), name: "projectId");
      projectAreaBloc.add(ApiListFetch(id: widget.projectId));
    } else {
      projectAreaBloc.add(ApiListFetch());
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Area'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: BlocProvider(
        create: (context) => projectAreaBloc,
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search areas...',
                  prefixIcon: Icon(Icons.search, color: Colors.green.shade700),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                  )
                      : null,
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.green.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.green.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: Colors.green.shade600, width: 2),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),

            // Grid of Areas
            Expanded(
              child: BlocBuilder<ProjectAreaBloc, ApiState<ProjectAreasResponse, ResponseModel>>(
                builder: (context, state) {
                  if(state is ApiLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    );
                  }

                  if (state is ApiFailure) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 60,
                            color: Colors.red.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to load areas',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is ApiSuccess<ProjectAreasResponse, ResponseModel>) {
                    // final areaList = state.areas;
                    ProjectAreasResponse areaList = state.data;
                    // Filter areas based on search query
                    final filteredAreas = _searchQuery.isEmpty
                        ? areaList
                        : areaList.data.where((area) =>
                        (area.name ?? '')
                            .toLowerCase()
                            .contains(_searchQuery))
                        .toList();

                    if (areaList.data.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 60,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No areas found',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.85,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: areaList.data.length,
                      itemBuilder: (context, index) {
                        final area = areaList.data[index];
                        return _AreaGridItem(
                          area: area,
                          onTap: () {
                            AppRoute.goToNextPage(
                              context: context,
                              screen: TreeSpeciesList.route,
                              arguments: {
                                'areaId':area.id,
                                'treeCount':widget.treeCount,
                              },
                            );
                          },
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AreaGridItem extends StatelessWidget {
  final ProjectAreaItem area;
  final VoidCallback onTap;

  const _AreaGridItem({
    Key? key,
    required this.area,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.green.shade300,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Section
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child:Image.network(
                  'https://media.istockphoto.com/id/469538141/photo/plant-sprouting-from-the-dirt-with-a-blurred-background.jpg?s=612x612&w=0&k=20&c=uc-WaLHzRlsrBsHrTVO4fEqRqPjkh-MHtlGLj-QWI64=',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholder();
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                        color: Colors.green.shade600,
                        strokeWidth: 2,
                      ),
                    );
                  },
                ),
              ),
            ),

            // Area Name Section
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Text(
                  area.name ?? 'Unnamed Area',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade900,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: Icon(
          Icons.landscape,
          size: 50,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }
}

 */

class AreaSelectionScreen extends StatefulWidget {
  static const route = "/area-selection";
  final String? projectId;
  final int? treeCount;
  const AreaSelectionScreen({Key? key, this.projectId, this.treeCount = 1}) : super(key: key);

  @override
  State<AreaSelectionScreen> createState() => _AreaSelectionScreenState();
}

class _AreaSelectionScreenState extends State<AreaSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  late ProjectAreaBloc projectAreaBloc;

  @override
  void initState() {
    projectAreaBloc = ProjectAreaBloc(ProjectAreaRepository(api: ApiConnection()));
    if (widget.projectId != null) {
      debugLog(widget.projectId.toString(), name: "projectId");
      projectAreaBloc.add(ApiListFetch(id: widget.projectId));
    } else {
      projectAreaBloc.add(ApiListFetch());
    }
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildHeader() {
    return SafeArea(
      top: true,
      left: true,
      right: true,
      bottom: false,
      child: Container(
        padding:  EdgeInsets.symmetric(horizontal: 20,vertical: 5.h),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: AppColor.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.primary.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColor.primary,
                  size: 18,
                ),
              ),
            ),
            const Spacer(),
            Text(
              "Select Area",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColor.primary,
                letterSpacing: -0.5,
              ),
            ),
            const Spacer(),
            const SizedBox(width: 44), // Balance the back button
          ],
        ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: BlocProvider(
        create: (context) => projectAreaBloc,
        child: Column(
          children: [
            _buildHeader(),
            // Search Bar
            Container(
              color: AppColor.scaffoldBackground,
              // color: AppColor.white,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColor.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Search for an area...',
                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: AppColor.textMuted,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColor.secondary,
                    size: 22,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 20,
                    ),
                    color: AppColor.textMuted,
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                  )
                      : null,
                  filled: true,
                  fillColor: AppColor.grey,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColor.secondary,
                      width: 1.5,
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase().trim();
                  });
                },
              ),
            ),

            // Grid of Areas
            Expanded(
              child: BlocBuilder<ProjectAreaBloc, ApiState<ProjectAreasResponse, ResponseModel>>(
                builder: (context, state) {
                  if (state is ApiLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.secondary,
                        strokeWidth: 3,
                      ),
                    );
                  }

                  if (state is ApiFailure) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 64,
                            color: AppColor.error.withOpacity(0.7),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Unable to load areas',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColor.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Please try again later',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColor.textMuted,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is ApiSuccess<ProjectAreasResponse, ResponseModel>) {
                    ProjectAreasResponse areaList = state.data;

                    // Filter areas based on search query
                    final filteredAreas = _searchQuery.isEmpty
                        ? areaList.data
                        : areaList.data
                        .where((area) =>
                        (area.name ?? '').toLowerCase().contains(_searchQuery))
                        .toList();

                    if (filteredAreas.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _searchQuery.isEmpty
                                  ? Icons.folder_open_rounded
                                  : Icons.search_off_rounded,
                              size: 64,
                              color: AppColor.textMuted.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'No areas available'
                                  : 'No results found',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColor.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'Areas will appear here once added'
                                  : 'Try a different search term',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColor.textMuted,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: filteredAreas.length,
                      itemBuilder: (context, index) {
                        final area = filteredAreas[index];
                        return _AreaGridItem(
                          area: area,
                          onTap: () {
                            AppRoute.goToNextPage(
                              context: context,
                              screen: TreeSpeciesList.route,
                              arguments: {
                                'areaId': area.id,
                                'treeCount': widget.treeCount,
                              },
                            );
                          },
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AreaGridItem extends StatelessWidget {
  final ProjectAreaItem area;
  final VoidCallback onTap;

  const _AreaGridItem({
    Key? key,
    required this.area,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: AppColor.secondary.withOpacity(0.1),
        highlightColor: AppColor.secondary.withOpacity(0.05),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColor.border,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Section
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        'https://media.istockphoto.com/id/469538141/photo/plant-sprouting-from-the-dirt-with-a-blurred-background.jpg?s=612x612&w=0&k=20&c=uc-WaLHzRlsrBsHrTVO4fEqRqPjkh-MHtlGLj-QWI64=',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholder();
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: AppColor.grey,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                                color: AppColor.secondary,
                                strokeWidth: 2.5,
                              ),
                            ),
                          );
                        },
                      ),
                      // Subtle gradient overlay for better text readability
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                AppColor.black.withOpacity(0.1),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Area Name Section
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                decoration: const BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColor.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.location_on_rounded,
                        color: AppColor.secondary,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        area.name ?? 'Unnamed Area',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColor.textPrimary,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
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

  Widget _buildPlaceholder() {
    return Container(
      color: AppColor.grey,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.park_rounded,
              size: 40,
              color: AppColor.textMuted.withOpacity(0.5),
            ),
            const SizedBox(height: 6),
            Text(
              'No Image',
              style: TextStyle(
                fontSize: 11,
                color: AppColor.textMuted.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Usage Example:
// Navigate to this screen and receive selected area
/*
final selectedArea = await Navigator.push<ProjectAreaItem>(
  context,
  MaterialPageRoute(
    builder: (context) => const AreaSelectionScreen(),
  ),
);

if (selectedArea != null) {
  // Use the selected area
  mapController.move(selectedArea.centroid, 13.0);
}
*/