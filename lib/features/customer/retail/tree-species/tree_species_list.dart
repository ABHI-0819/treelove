import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:badges/badges.dart' as badges;
import 'package:treelove/common/bloc/api_event.dart';
import 'package:treelove/features/customer/retail/tree-species/bloc/tree_species_bloc.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../common/repositories/tree_species_repository.dart';
import '../../../../core/config/resource/images.dart';
import '../../../../core/config/route/app_route.dart';
import '../../../../core/config/themes/app_color.dart';
import '../../../../core/config/themes/app_fonts.dart';
import '../../../../core/network/api_connection.dart';
import '../../../../core/utils/logger.dart';
import 'models/tree_species_model.dart';
import 'tree_species_details.dart';

class TreeSpeciesList extends StatefulWidget {
  static const route = "/tree-species-list";
  final String areaId;
  final int treeCount;
  final double ? latitude;
  final double ? longitude;

  const TreeSpeciesList({super.key,required this.areaId,this.treeCount=1,this.latitude,this.longitude});

  @override
  State<TreeSpeciesList> createState() => _TreeSpeciesListState();
}

class _TreeSpeciesListState extends State<TreeSpeciesList> {

  late TreeSpeciesBloc _treeSpeciesBloc;

  @override
  void initState() {
    _treeSpeciesBloc = TreeSpeciesBloc(
      TreeSpeciesRepository(api: ApiConnection()),
    );
    _treeSpeciesBloc.add(ApiListFetch());
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColor.background,
      appBar: AppBar(
        automaticallyImplyLeading: false, // We add the back button manually
        backgroundColor: AppColor.background,
        elevation: 0,
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 30.w,
          children: [
            InkWell(
                onTap: () => AppRoute.pop(context),
                child: Icon(Icons.arrow_back, size: 24)),
            Text(
                'Tree Species',
                style: AppFonts.subtitle.copyWith(
                    color: AppColor.black, fontSize: 22)
            ),
            Spacer(),
            IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.black),
              onPressed: () {
                debugLog('Filter button pressed!');
              },
            ),
          ],
        ),
      ),
      body: _mainBody(),
    );
  }

  Widget _mainBody() {
    return BlocProvider(
      create: (context) => _treeSpeciesBloc,
      child: BlocBuilder<TreeSpeciesBloc, ApiState<TreeSpeciesListResponse, ResponseModel>>(
        builder: (context, state) {

          if(state is ApiLoading){
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ApiSuccess<TreeSpeciesListResponse, ResponseModel>) {
            final speciesList = state.data.data ?? [];

            return CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  floating: false,
                  delegate: StickySearchBar(
                    hintText: 'Search Station Here',
                    onChanged: (value) {

                    },
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                         final item = speciesList[index];
                        return Card(
                            elevation: 1,
                            child: TreeTypeCard(
                              onTap: (){
                                AppRoute.goToNextPage(
                                    context: context, screen: TreeSpeciesDetails.route, arguments: {
                                      'id' :item.id,
                                      'areaId':widget.areaId,
                                      'treeCount':widget.treeCount,
                                      'latitude':widget.latitude,
                                      'longitude':widget.longitude
                                });
                              },
                              tree: TreeType(
                                name: item.treeName,
                                species: item.scientificName,
                                imageUrl:item.image??"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRuCZtWNJjBjxoVw9OCxZXKQE-biHdtZ7c5Ig&s",
                              ),)
                        );
                      },
                      childCount: speciesList.length,
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}


class StickySearchBar extends SliverPersistentHeaderDelegate {
  final String hintText;
  final Function(String) onChanged;

  StickySearchBar({required this.hintText, required this.onChanged});

  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
    return Container(
      color:  AppColor.background,
      // color: AppColor.background,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: AppColor.cardBackground,
          borderRadius: BorderRadius.circular(6),
        ),
        child: TextField(
          onChanged: onChanged,
          decoration: const InputDecoration(
            hintText: 'Search species by tree name',
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
            suffixIcon: Icon(Icons.search, color: Colors.grey),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          ),
        ),
      ),
    );
  }

  // @override
  // double get maxExtent => 60;
  //
  // @override
  // double get minExtent => 60;

  @override
  double get maxExtent => 45.h + 10;

  @override
  double get minExtent => 45.h + 10;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

class RoleFilter extends StatefulWidget {
  final void Function(String selectedRole)? onRoleSelected;

  const RoleFilter({super.key, this.onRoleSelected});

  @override
  State<RoleFilter> createState() => _RoleFilterState();
}

class _RoleFilterState extends State<RoleFilter> {
  final roles = ['Flower', 'Native', 'Fruit', 'Medicinal'];
  String selectedRole = 'All';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w!, vertical: 5.h!),
      child: Row(
        children: roles
            .map(
              (role) =>
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(role),
                  selected: role == selectedRole,
                  onSelected: (isSelected) {
                    setState(() {
                      selectedRole = role;
                    });
                    if (widget.onRoleSelected != null) {
                      widget.onRoleSelected!(role);
                    }
                  },
                ),
              ),
        ).toList(),
      ),
    );
  }
}


class TreeType {
  final String name;
  final String species;
  final String imageUrl;

  const TreeType({
    required this.name,
    required this.species,
    required this.imageUrl,
  });
}

class TreeTypeCard extends StatelessWidget {
  final TreeType tree;
  void Function() onTap;
   TreeTypeCard({super.key, required this.tree, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Row(
          spacing: 16.w,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                tree.imageUrl ?? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRuCZtWNJjBjxoVw9OCxZXKQE-biHdtZ7c5Ig&s', // Fallback to empty string if null to avoid errors
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    Images.sampleImg, // Replace with your asset path
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  );
                },
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) return child;
                  return AnimatedOpacity(
                    opacity: frame == null ? 0 : 1,
                    duration: const Duration(milliseconds: 300),
                    child: child,
                  );
                },
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tree.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  tree.species,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            Spacer(),
            badges.Badge(
              badgeContent: Icon(Icons.arrow_forward, color: AppColor.white,),
              badgeStyle: const badges.BadgeStyle(
                badgeColor: AppColor.primary,
                padding: EdgeInsets.all(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
