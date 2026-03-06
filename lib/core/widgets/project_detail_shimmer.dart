import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProjectDetailShimmer extends StatelessWidget {
  const ProjectDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          ShimmerBox(
            height: MediaQuery.of(context).size.height * 0.3,
            width: double.infinity,
            radius: 0,
          ),

          const SizedBox(height: 20),

          /// AREA CHIPS
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, __) {
                return const ShimmerBox(
                  height: 30,
                  width: 80,
                  radius: 20,
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          /// INFO CARDS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: List.generate(
                3,
                (index) => const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: ShimmerBox(
                    height: 80,
                    width: double.infinity,
                    radius: 12,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// FIELDWORKERS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: List.generate(
                3,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(
                    children: const [
                      ShimmerBox(height: 40, width: 40, radius: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: ShimmerBox(height: 14, width: double.infinity),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// MAP SECTION
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const ShimmerBox(
              height: 180,
              width: double.infinity,
              radius: 12,
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class ShimmerBox extends StatelessWidget {
  final double height;
  final double width;
  final double radius;

  const ShimmerBox({
    super.key,
    required this.height,
    required this.width,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
