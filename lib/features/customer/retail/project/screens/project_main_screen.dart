import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:treelove/core/config/themes/app_color.dart';
import 'package:treelove/core/config/themes/app_fonts.dart';

import '../../../../../core/config/resource/images.dart';
String selectedLocation = 'Himachal';
class ProjectMainScreen extends StatefulWidget {


  @override
  State<ProjectMainScreen> createState() => _ProjectMainScreenState();
}

class _ProjectMainScreenState extends State<ProjectMainScreen> {
  final List<String> locations = [
    'Himachal', 'Arunachal', 'Mumbai', 'Hyderabad',
    'Meghalaya', 'Chennai', 'Assam', 'Nagpur'
  ];



  final List<Map<String, dynamic>> projects = [
    {'title': 'Great Himalayan National Park', 'isHighlighted': true},
    {'title': 'Manali wildlife sanctuary'},
    {'title': 'Chail Wildlife Sanctuary'},
    {'title': 'Chail Wildlife Sanctuary'},
    {'title': 'Kugti Wildlife Sanctuary'},
    {'title': 'Chail Wildlife Sanctuary'},
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Images.homeBgImg),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSearchBar(),
              // _buildTopBar(),
              _buildLocationChips(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Popular projects',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'Available projects(23)',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    )
                  ],
                ),
              ),
              Expanded(child: _buildProjectGrid())
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: locations.map((location) {
          final bool isSelected = location == selectedLocation;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedLocation = location;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected ? AppColor.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white),
              ),
              child: Text(
                location,
                style: TextStyle(color: isSelected ? Colors.white : Colors.white.withOpacity(0.8)),
              ),
            ),
          );
        }).toList(),
      )
    );
  }

  Widget _buildProjectGrid() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: projects.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (context, index) {
          final project = projects[index];
          final isHighlighted = project['isHighlighted'] == true;

          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade800,
                  image: isHighlighted
                      ? const DecorationImage(
                    image: AssetImage(Images.sampleImg),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(Images.projectIcon,color: AppColor.white,),
                        // const Icon(Icons.nature, color: Colors.white, size: 16),
                        const Icon(Icons.favorite_border, color: Colors.white, size: 16),
                        const Icon(Icons.bookmark_border, color: Colors.white, size: 16),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      project['title'],
                      style:AppFonts.body.copyWith(
                      color: Colors.white.withOpacity(isHighlighted ? 1.0 : 0.6),
                        fontWeight: FontWeight.w500,
                      )
                    ),
                    if (isHighlighted)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'See more',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}


class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
      decoration: BoxDecoration(
          color: Color(0xFFF6F1DE),

          borderRadius: BorderRadius.circular(25.r)
      ),
      child: Row(
        children: [
          // Hamburger Menu Icon
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.menu, size: 20),
          ),
          SizedBox(width: 12),
          // Search Text
          Expanded(
            child: Text(
                '${selectedLocation}',
                style: AppFonts.body.copyWith(
                    color: AppColor.black,
                    fontWeight: FontWeight.w500
                )
            ),
          ),
          // Notification Bell Icon
          CircleAvatar(
            backgroundColor: AppColor.white,// Color(0xFFF7F2E8),
            radius:18,
            child: SvgPicture.asset(Images.profileIcon),
          ),
        ],
      ),
    );
  }
}