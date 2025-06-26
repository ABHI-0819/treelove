import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/resource/images.dart';
import '../../../../core/config/route/app_route.dart';
import '../../../../core/config/themes/app_color.dart';
import '../../../../core/config/themes/app_fonts.dart';
import '../cart/cart_screen.dart';
import '../home/screens/location_selection_screen.dart';

class TreeSpeciesDetails extends StatefulWidget {
  static const route ='/tree-species-details';
  const TreeSpeciesDetails({super.key});

  @override
  State<TreeSpeciesDetails> createState() => _TreeSpeciesDetailsState();
}

class _TreeSpeciesDetailsState extends State<TreeSpeciesDetails> {

  int quantity = 10;
  bool geoTagging = true;
  bool monitoring = true;
  bool maintenance = false;

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    if (quantity > 0) {
      setState(() {
        quantity--;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              Images.sampleImg, // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),

          // Dark Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 15.w,vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   InkWell(
                     onTap: (){
                       AppRoute.pop(context);
                     },
                       child: Icon(Icons.arrow_back,color: AppColor.white,)
                   ),
                  SizedBox(
                    height: 20.h,
                  ),
                  // Title
                  Text(
                    "Alphanso mango",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Description
                  SizedBox(height: 16),
                  Text(
                    "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),

                  // Separator Line
                  SizedBox(height: 16),
                  Divider(color: Colors.white),

                  // Cost per Tree Section
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Cost per tree – ₹900",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove, color: Colors.white),
                            onPressed: decrementQuantity,
                          ),
                          Text(
                            "$quantity",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add, color: Colors.white),
                            onPressed: incrementQuantity,
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Geo - Tagging Toggle
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Geo – tagging",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Switch(
                        value: geoTagging,
                        onChanged: (value) {
                          // setState(() {
                          //   geoTagging = value;
                          // });
                        },
                        activeColor: Colors.white,
                      ),
                    ],
                  ),

                  // Monitoring Toggle
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Monitoring – ₹300",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Switch(
                        value: monitoring,
                        onChanged: (value) {
                          setState(() {
                            monitoring = value;
                          });
                        },
                        activeColor: Colors.white,
                      ),
                    ],
                  ),

                  // Maintenance Toggle
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Maintenance – ₹300",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Switch(
                        value: maintenance,
                        onChanged: (value) {
                          setState(() {
                            maintenance = value;
                          });
                        },
                        activeColor: Colors.white,
                      ),
                    ],
                  ),

                  // Add to Cart Button
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF6F2E8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      onPressed: (){
                        AppRoute.goToNextPage(context: context, screen: MapScreen.route, arguments: {});
                      },
                      child: Text('Add other Tree species', style: AppFonts.regular.copyWith(color: Color(0xFFD2C7A6))),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004D40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      onPressed: (){
                        AppRoute.goToNextPage(context: context, screen: CartScreen.route, arguments: {});
                      },
                      child: Text('Add to cart', style: AppFonts.regular),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
/*
  backgroundColor: const Color(0xFFF6F2E8),
                    foregroundColor: const Color(0xFFD2C7A6),
*/






