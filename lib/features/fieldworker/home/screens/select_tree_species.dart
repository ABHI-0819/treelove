import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/core/config/themes/app_color.dart';
import 'package:badges/badges.dart' as badges;
import 'tree_plantation_screen.dart';

class SelectTreeTypeScreen extends StatelessWidget {
  static const route ="/select-species-plantation";
  const SelectTreeTypeScreen({super.key});

  final List<TreeType> treeTypes = const [
    TreeType(
      name: 'Mango',
      species: 'Hapus',
      imageUrl:
      'https://cdn.pixabay.com/photo/2012/07/09/07/16/mango-51995_1280.jpg',
    ),
    TreeType(
      name: 'Bay',
      species: 'Red Drum',
      imageUrl:
      'https://cdn.pixabay.com/photo/2012/07/09/07/16/mango-51995_1280.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: const Text('Plant a tree'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color(0xFF0C4F47), // Dark green
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select tree species',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: treeTypes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final tree = treeTypes[index];
                  return TreeTypeCard(tree: tree);
                },
              ),
            ),
          ],
        ),
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

  const TreeTypeCard({super.key, required this.tree});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: Handle tree selection logic
        AppRoute.goToNextPage(context: context, screen: PlantTreeScreen.route, arguments: {});
      },
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
                tree.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
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
              badgeContent: Text(
                '3',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              badgeStyle: const badges.BadgeStyle(
                badgeColor: Colors.red,
                padding: EdgeInsets.all(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
