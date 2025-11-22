import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/config/themes/app_color.dart';
import '../bloc/api_event.dart';
import '../bloc/api_state.dart';
import '../bloc/plantation_bloc.dart';
import '../models/planted.list.response.model.dart';
import '../models/response.mode.dart';

class PlantedTreeListScreen extends StatefulWidget {
  const PlantedTreeListScreen({Key? key}) : super(key: key);

  @override
  State<PlantedTreeListScreen> createState() => _PlantedTreeListScreenState();
}

class _PlantedTreeListScreenState extends State<PlantedTreeListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<PlantedTreeModel> _filteredTrees = [];
  List<PlantedTreeModel> _allTrees = [];

  @override
  void initState() {
    super.initState();
    _loadTrees();
    _searchController.addListener(_filterTrees);
  }

  void _loadTrees() {
    context.read<PlantedTreeBloc>().add(ApiListFetch());
  }

  void _filterTrees() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredTrees = _allTrees;
      } else {
        _filteredTrees = _allTrees.where((tree) {
          return tree.treeSpecies.localName.toLowerCase().contains(query) ||
              tree.treeSpecies.scientificName.toLowerCase().contains(query) ||
              tree.id.toLowerCase().contains(query);
        }).toList();
      }
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.primary,
        title: const Text(
          'Planted Trees',
          style: TextStyle(
            color: AppColor.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColor.white),
            onPressed: () {
              // TODO: Add filter functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: BlocConsumer<PlantedTreeBloc, ApiState<PlantedListResponseModel, ResponseModel>>(
              listener: (context, state) {
                if (state is ApiSuccess<PlantedListResponseModel, ResponseModel>) {
                  _allTrees = state.data.data;
                  _filteredTrees = _allTrees;
                }
              },
              builder: (context, state) {
                if (state is ApiLoading<PlantedListResponseModel, ResponseModel>) {
                  return _buildLoadingState();
                }

                if (state is ApiFailure<PlantedListResponseModel, ResponseModel>) {
                  return _buildErrorState(state.error.message.toString());
                }

                if (state is ApiSuccess<PlantedListResponseModel, ResponseModel>) {
                  if (_filteredTrees.isEmpty) {
                    return _buildEmptyState();
                  }
                  return _buildTreeList();
                }

                return _buildInitialState();
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🔍 Search Bar
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search by name, scientific name or ID...',
          hintStyle: TextStyle(
            color: AppColor.textMuted,
            fontSize: 14,
          ),
          prefixIcon: Icon(Icons.search, color: AppColor.primary),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.clear, color: AppColor.textMuted),
            onPressed: () {
              _searchController.clear();
            },
          )
              : null,
          filled: true,
          fillColor: AppColor.grey,
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
            borderSide: BorderSide(color: AppColor.primary, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  // 📋 Tree List
  Widget _buildTreeList() {
    return RefreshIndicator(
      onRefresh: () async {
        _loadTrees();
      },
      color: AppColor.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredTrees.length,
        itemBuilder: (context, index) {
          return _buildTreeCard(_filteredTrees[index]);
        },
      ),
    );
  }

  // 🌳 Tree Card
  Widget _buildTreeCard(PlantedTreeModel tree) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to tree detail screen
          // Navigator.push(context, MaterialPageRoute(builder: (_) => TreeDetailScreen(tree: tree)));
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tree Image
              _buildTreeImage(tree.thumbnail),
              const SizedBox(width: 12),

              // Tree Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tree Name
                    Text(
                      tree.treeSpecies.localName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColor.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Scientific Name
                    Text(
                      tree.treeSpecies.scientificName,
                      style: TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: AppColor.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // ID & Status Row
                    Row(
                      children: [
                        // Tree ID
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColor.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.tag, size: 12, color: AppColor.primary),
                              const SizedBox(width: 4),
                              Text(
                                tree.id.length > 8 ? '${tree.id.substring(0, 8)}...' : tree.id,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),

                        // Verification Badge
                        if (tree.isVerified)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColor.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.verified, size: 12, color: AppColor.success),
                                const SizedBox(width: 4),
                                Text(
                                  'Verified',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.success,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Status Indicators
                    _buildStatusRow(tree),
                  ],
                ),
              ),

              // Arrow Icon
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColor.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🖼️ Tree Image
  Widget _buildTreeImage(String? thumbnail) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80,
        height: 80,
        color: AppColor.primaryLight.withOpacity(0.1),
        child: thumbnail != null && thumbnail.isNotEmpty
            ? Image.network(
          thumbnail,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
        )
            : _buildPlaceholderImage(),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Icon(
      Icons.park,
      size: 40,
      color: AppColor.primary.withOpacity(0.5),
    );
  }

  // 📊 Status Row
  Widget _buildStatusRow(PlantedTreeModel tree) {
    return Row(
      children: [
        // Maintenance Status
        if (tree.maintenanceStatus != null)
          _buildStatusChip(
            tree.maintenanceStatus!,
            _parseColor(tree.maintenanceStatusColor),
            Icons.build_circle,
          ),

        if (tree.maintenanceStatus != null && tree.monitoringStatus != null)
          const SizedBox(width: 6),

        // Monitoring Status
        if (tree.monitoringStatus != null)
          _buildStatusChip(
            tree.monitoringStatus!,
            _parseColor(tree.monitoringStatusColor),
            Icons.visibility,
          ),
      ],
    );
  }

  Widget _buildStatusChip(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String? colorString) {
    if (colorString == null || colorString.isEmpty) return AppColor.textMuted;
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return AppColor.textMuted;
    }
  }

  // 🔄 Loading State
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColor.primary),
          const SizedBox(height: 16),
          Text(
            'Loading trees...',
            style: TextStyle(color: AppColor.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ❌ Error State
  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColor.error),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColor.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadTrees,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                foregroundColor: AppColor.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 📭 Empty State
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: AppColor.textMuted.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isEmpty ? 'No trees planted yet' : 'No results found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColor.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchController.text.isEmpty
                  ? 'Start planting trees to see them here'
                  : 'Try searching with different keywords',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textSecondary, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  // 🏁 Initial State
  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.park, size: 80, color: AppColor.primary.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            'Welcome to Planted Trees',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColor.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}