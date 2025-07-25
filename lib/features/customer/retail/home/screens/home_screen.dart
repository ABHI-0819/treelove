import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:treelove/core/config/route/app_route.dart';

import '../../../../../core/config/resource/images.dart';
import '../../../../../core/config/themes/app_button_style.dart';
import '../../../../../core/config/themes/app_color.dart';
import '../../../../../core/config/themes/app_fonts.dart';
import '../../../../../core/storage/preference_keys.dart';
import '../../../../../core/storage/secure_storage.dart';
import '../../../../fieldworker/home/screens/main_screen.dart';
import 'location_selection_screen.dart';

SecurePreference preference= SecurePreference();
class HomeScreen extends StatefulWidget {
  static const route ='/retail-home-screen';
   const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFEF7),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeTopSection(),
            _buildTreeLovProjects(),
            _buildFarmerProjects(),
            GovtProjectsCard(
              imagePath: Images.birthdayBg, // Replace with your actual image path
              totalProjects: 7,
              onTap: () {
                // Navigate or show dialog
                print("Know more tapped");
              },
            ),
            TrendingTopicsWidget(),
            CustomerSatisfactionWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(String icon,String title) {
    return Container(
      height: 50.h,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColor.background.withOpacity(0.9),
        borderRadius: BorderRadius.circular(1),
      ),
      child: Row(
        children: [
          SvgPicture.asset(icon,width: 20,height: 20,),
          // Icon(Icons.check_circle_outline, color: Colors.green[800]),
          SizedBox(width: 20.w),
          Expanded(
            child: Text(
                title,
                style:AppFonts.body.copyWith(
                    color: AppColor.primary
                )
            ),
          ),
          SvgPicture.asset(Images.rightArrowIcon,width: 20,height: 20,),
        ],
      ),
    );
  }

  Widget _buildTreeLovProjects() {
    return _buildProjectSection("Tree Lov projects", "We planted 3 million\ntrees in one year.", true);
  }

  Widget _buildFarmerProjects() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader("Farmer projects"),
          SizedBox(height: 10.h,),
          _buildServiceCard(Images.monitorIcon,"Noida"),
          const SizedBox(height: 12),
          _buildServiceCard(Images.babyPlantIcon,"Delhi"),
        ],
      ),
    );
  }

  Widget _buildProjectSection(String title, String subtitle, [bool scrollable = false]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(title),
           SizedBox(height: 10.h),
          Text(subtitle,style: AppFonts.subtitle.copyWith(color: Colors.black,fontSize: 27.sp,height: 1.2,fontWeight: FontWeight.w300),),
           SizedBox(height: 4.h),
          Text('Our tree survival is at 93%. 25k of our members are carbon neutral.',style: AppFonts.caption,),
          SizedBox(height: 10.h),
          if (scrollable)
            SizedBox(
              height: 200.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return ProjectCard();
                },
              ),
            )
          else
            ProjectCard(),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const Text("See All", style: TextStyle(color: Colors.grey))
      ],
    );
  }

}




class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Color(0xFFF7F2E8),

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
              'Search',
              style: AppFonts.body.copyWith(
                color: AppColor.black,
                fontWeight: FontWeight.w500
              )
            ),
          ),
          // Notification Bell Icon
          InkWell(
            onTap: (){
              AppRoute.goToNextPage(context: context, screen: FieldWorkerMainScreen.route, arguments: {});
            },
            child: CircleAvatar(
              backgroundColor: AppColor.white,// Color(0xFFF7F2E8),
              radius: 20,
              child: SvgPicture.asset(Images.profileIcon),
            ),
          ),
        ],
      ),
    );
  }
}



class BirthdayPlantationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AspectRatio(
        aspectRatio: 1.3,
        // Keeps the widget square
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
              Images.birthdayBg,
                 fit: BoxFit.cover,
              ),
            ),
            // Overlay for text readability (optional, adjust opacity as needed)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.10),
              ),
            ),
            // Text Overlay
            Positioned(
              left: 0,
              right: 0,
              top: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Birthday plantation',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Serif', // Use a serif font if available
                      height: 1.1,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '20 trees package',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            // Bottom Button
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0xFF295D4A), // Deep green color
                height: 50,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Know More',
                      style: AppFonts.body.copyWith(
                        color: Color(0xFFF6F1DE)
                      ),
                    ),
                    SizedBox(width: 12),
                    SvgPicture.asset(Images.rightArrowIcon,color: Color(0xFFF6F1DE),)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
   ProjectCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height:250.h,
      margin: EdgeInsets.only(right: 10.w),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Images.birthdayBg),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.all(Radius.circular(4))
      ),
      // aspectRatio: 1, // Adjust to match your image's aspect ratio
      child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '7 total\nprojects',
                  textAlign: TextAlign.center,
                  style: AppFonts.subtitle.copyWith(
                  fontSize:27,
                    height: 1.2
                  ),
                ),
                Spacer(),
                // SizedBox(height: 24),
                // "Know more" Button
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF295D4A), // Deep green color
                    borderRadius: BorderRadius.circular(24),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 10.h),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  child: Text(
                    'Know more',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
    );
  }
}


class HomeTopSection extends StatelessWidget {
  const HomeTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Background image with black gradient overlay
        Container(
          width: double.infinity,
          height: screenHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Images.homeBgImg),
              fit: BoxFit.cover,
            ),
          ),
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
           // Solid black
                Color(0xFF000000),
                Colors.transparent,
                Color(0xAE00100E),

                // Black with 69% opacity
              ],
            ),
          ),
        ),

        // Main content
        SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSearchBar(),
                _buildGreeting(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Explore plantation",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                _buildHorizontalCards(context),
                SizedBox(
                  height: 20.h,
                ),
                _buildServiceSection(),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        "Quick Planting",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios,color: AppColor.white,)
                    ],
                  ),
                ),
                BirthdayPlantationWidget(),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Future<String> _getUserName() async {
    return await preference.getString(Keys.name, defaultValue: 'Naresh');
  }

  Widget _buildGreeting() {
    return FutureBuilder<String>(
      future: _getUserName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SizedBox(
              height: 30,
              child: LinearProgressIndicator(color: Colors.white),
            ),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              "Hello, what's on your mind today?",
              style: AppFonts.subtitle.copyWith(
                fontSize: 27
              )
            ),
          );
        } else {
          final name = snapshot.data ?? "Naresh";
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              "$name, what's on your mind today?",
                style: AppFonts.subtitle.copyWith(
                    fontSize: 27
                )
            ),
          );
        }
      },
    );
  }

  Widget _buildHorizontalCards(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          ExplorePlantationCard(
            title: 'Plant\nby location',
            imagePath: 'assets/location.jpg',
            icon: Icons.spa, // Use appropriate icon or custom
            onTap: () {
              AppRoute.goToNextPage(context: context, screen: MapScreen.route, arguments: {});
            },
          ),
          ExplorePlantationCard(
            title: 'Forest\nplantation',
            imagePath: 'assets/forest.jpg',
            icon: Icons.park,
            isActive: false,
            onTap: () {},
          ),
          ExplorePlantationCard(
            title: 'Farmers Plantation',
            imagePath: 'assets/type.jpg',
            icon: Icons.eco,
            onTap: () {},
          ),
        ],
      ),
    );
  }


  Widget _buildServiceSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Explore other services",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          const SizedBox(height: 12),
          _buildServiceCard(Images.monitorIcon,"Monitoring"),
          const SizedBox(height: 12),
          _buildServiceCard(Images.babyPlantIcon,"Maintenance"),
        ],
      ),
    );
  }

  Widget _buildServiceCard(String icon,String title) {
    return Container(
      height: 50.h,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColor.background.withOpacity(0.9),
        borderRadius: BorderRadius.circular(1),
      ),
      child: Row(
        children: [
          SvgPicture.asset(icon,width: 20,height: 20,),
          // Icon(Icons.check_circle_outline, color: Colors.green[800]),
           SizedBox(width: 20.w),
          Expanded(
            child: Text(
              title,
              style:AppFonts.body.copyWith(
                color: AppColor.primary
              )
            ),
          ),
          SvgPicture.asset(Images.rightArrowIcon,width: 20,height: 20,),
        ],
      ),
    );
  }
}

class TrendingPlantationSection extends StatelessWidget {
  const TrendingPlantationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 24, top: 40),
      color: const Color(0xFFF8F4E3),
      width: double.infinity,
      height: 370,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Read up on trending\n‘Plantation’ topics',
            style: TextStyle(
              color: Color(0xFF3D3D3D),
              fontFamily: 'Poppins',
              fontSize: 14,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 300,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 0),
              children:  [
                PlantationCard(
                  imagePath: 'assets/images/Frame2278.png',
                  bgColor: Color(0xFF00473C),
                  headline: 'This is an example of headline',
                  subHeadline: 'This is an example of sub-headline',
                ),
                SizedBox(width: 12),
                PlantationCard(
                  imagePath: 'assets/images/Frame2283.png',
                  bgColor: Color(0xFF4F4F4F),
                  headline: 'This is an example of headline',
                  subHeadline: 'This is an example of sub-headline',
                ),
                SizedBox(width: 12),
                PlantationCard(
                  imagePath: 'assets/images/Frame2284.png',
                  bgColor: Color(0xFF070502),
                  headline: 'This is an example of\nheadline',
                  subHeadline: 'This is an example of sub-headline',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PlantationCard extends StatelessWidget {
  final String imagePath;
  final Color bgColor;
  final String headline;
  final String subHeadline;

  const PlantationCard({
    super.key,
    required this.imagePath,
    required this.bgColor,
    required this.headline,
    required this.subHeadline,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          // width: 134,
          height: 226,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Images.birthdayBg),
              // fit: BoxFit.fitWidth,
            ),
          ),
        ),
        Positioned(
          top: 176,
          left: -4,
          child: Container(
            width: 142,
            height: 67,
            color: const Color(0xFF070502),
          ),
        ),
        const Positioned(
          top: 134,
          left: 58,
          child: Image(
            image: AssetImage(Images.birthdayBg),
            width: 18,
            height: 18,
          ),
        ),
        Positioned(
          top: 16,
          left: 17,
          child: Text(
            headline,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Rasa',
              fontSize: 24,
              height: 1.2,
            ),
          ),
        ),
        Positioned(
          top: 189,
          left: 14,
          child: Text(
            subHeadline,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 10,
              height: 1.2,
            ),
          ),
        ),
        Positioned(
          top: 159,
          left: 28,
          child:  ElevatedButton(
            style: AppButtonStyle.secondary,
            onPressed: (){

            },
            child: const Text('Know more'),
          )
        ),
      ],
    );
  }
}


/*
class CustomerSatisfactionWidget extends StatelessWidget {
  const CustomerSatisfactionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFDFBF6),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text("5 lakh+ plantation Completed.", style: AppFonts.body.copyWith(color: Color(0xFF00473C)),),
          const SizedBox(height: 12),
           Text(
            '10k+ customers satisfied.',
            style: AppFonts.subtitle.copyWith(color: AppColor.black,fontSize: 27)
          ),
          const SizedBox(height: 10),
           Row(
             children: [
               Text(
                 'Our tree survival is at 93%.\n25k of our members are\ncarbon neutral.',
                 style: AppFonts.caption,
               ),
               Spacer(),
               Text(
                 'Read more',
                 style: TextStyle(
                   color: Colors.grey.shade800,
                   fontSize: 16,
                 ),
               ),
             ],
           ),
          const SizedBox(height: 30),
          Row(
            children: const [
              Expanded(
                child: CustomerCard(
                  imagePath: Images.sampleImg1,
                  name: 'Satya singh',
                  age: '32y',
                  location: 'Bengaluru',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: CustomerCard(
                  imagePath: Images.sampleImg1,
                  name: 'Satya singh',
                  age: '32y',
                  location: 'Bengaluru',
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Dot(color: Color(0xFF115D41)),
                Dot(),
                Dot(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

 */

class CustomerSatisfactionWidget extends StatefulWidget {
  const CustomerSatisfactionWidget({super.key});

  @override
  State<CustomerSatisfactionWidget> createState() => _CustomerSatisfactionWidgetState();
}

class _CustomerSatisfactionWidgetState extends State<CustomerSatisfactionWidget> {
  // We'll manage the page view for customer cards
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;

  // Dummy data for customer cards.
  // Each list in this list represents a "page" of customer cards.
  final List<List<Map<String, String>>> _customerPages = [
    [
      {'name': 'Satya Singh', 'age': '32y', 'location': 'Bengaluru', 'image': Images.sampleImg1},
      {'name': 'Priya Sharma', 'age': '28y', 'location': 'Mumbai', 'image': Images.sampleImg1},
    ],
    [
      {'name': 'Rajesh Kumar', 'age': '45y', 'location': 'Delhi', 'image': Images.sampleImg1},
      {'name': 'Anita Devi', 'age': '35y', 'location': 'Chennai', 'image': Images.sampleImg1},
    ],
    [
      {'name': 'Vikram Patel', 'age': '50y', 'location': 'Ahmedabad', 'image': Images.sampleImg1},
      {'name': 'Neha Gupta', 'age': '29y', 'location': 'Pune', 'image': Images.sampleImg1},
    ],
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int nextPageIndex = _pageController.page?.round() ?? 0;
      if (nextPageIndex != _currentPage) {
        setState(() {
          _currentPage = nextPageIndex;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFDFBF6),
      padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed text content
          Text(
            "5 lakh+ plantation Completed.",
            style: AppFonts.body.copyWith(color: const Color(0xFF00473C)),
          ),
          const SizedBox(height: 12),
          Text(
            '10k+ customers satisfied.',
            style: AppFonts.subtitle.copyWith(color: AppColor.black, fontSize: 27),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Our tree survival is at 93%.\n25k of our members are\ncarbon neutral.',
                style: AppFonts.caption,
              ),
              const Spacer(),
              Text(
                'Read more',
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // --- Dynamic Customer Cards using PageView ---
          SizedBox(
            height: 250, // Give PageView a specific height
            child: PageView.builder(
              controller: _pageController,
              itemCount: _customerPages.length,
              itemBuilder: (context, pageIndex) {
                final pageCustomers = _customerPages[pageIndex];
                return Row(
                  children: [
                    Expanded(
                      child: CustomerCard(
                        imagePath: 'https://plus.unsplash.com/premium_photo-1690407617542-2f210cf20d7e?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cGVyc29ufGVufDB8fDB8fHww',
                        name: pageCustomers[0]['name']!,
                        age: pageCustomers[0]['age']!,
                        location: pageCustomers[0]['location']!,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomerCard(
                        imagePath: 'https://plus.unsplash.com/premium_photo-1690407617542-2f210cf20d7e?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cGVyc29ufGVufDB8fDB8fHww',
                        name: pageCustomers[1]['name']!,
                        age: pageCustomers[1]['age']!,
                        location: pageCustomers[1]['location']!,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // --- End Dynamic Customer Cards ---

          const SizedBox(height: 30),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _customerPages.length, // Generate a dot for each page
                    (index) => Dot(
                  color: _currentPage == index
                      ? const Color(0xFF115D41) // Active dot color
                      : const Color(0xFFF5F2E9), // Inactive dot color
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*
class CustomerCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String age;
  final String location;

  const CustomerCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.age,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.asset(
            imagePath,
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          height: 250,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.6), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StarRating(),
              const SizedBox(height: 10),
               Text(
                'Our tree survival is at 93%.25k of our members are carbon neutral...',
                style: AppFonts.small,
                 maxLines: 3,

              ),
              const SizedBox(height: 10),
              Text(
                '$name, $age,\n$location',
                style: AppFonts.small.copyWith(
                  fontWeight: FontWeight.bold
                )
              ),
            ],
          ),
        ),
      ],
    );
  }
}

 */

class CustomerCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String age;
  final String location;

  const CustomerCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.age,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imagePath,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('$age, $location', style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  const StarRating({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF115D41),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          5,
              (index) => const Icon(Icons.star, color: Colors.white, size: 14),
        ),
      ),
    );
  }
}

class Dot extends StatelessWidget {
  final Color color;
  final double width; // New property for dynamic width

  const Dot({
    super.key,
    this.color = const Color(0xFFF5F2E9),
    this.width = 6.0, // Default width
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300), // Smooth transition for color and width
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 6, // Fixed height
      width: width, // Use the provided width
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
/*
class Dot extends StatelessWidget {
  final Color color;
  const Dot({super.key, this.color = const Color(0xFFF5F2E9)});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 6,
      width: 30,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

 */


// TODO : After That make it new file

class TrendingTopicsWidget extends StatelessWidget {
  const TrendingTopicsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F4E3),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Read up on trending \n‘Plantation’ topics",
            style: AppFonts.regular.copyWith(color: Color(0xFF3D3D3D))
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 3, // Change as needed
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                return const TrendingTopicCard(
                  imagePath: 'assets/plant.jpg',
                  headline: 'This is an example of headline',
                  subHeadline: 'This is an example of sub-headline',
                  durationText: '5 min',
                  isHighlighted: true,
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Center(child: PageIndicators(currentIndex: 0, total: 3)),
        ],
      ),
    );
  }
}

class TrendingTopicCard extends StatelessWidget {
  final String imagePath;
  final String headline;
  final String subHeadline;
  final String durationText;
  final bool isHighlighted;

  const TrendingTopicCard({
    super.key,
    required this.imagePath,
    required this.headline,
    required this.subHeadline,
    required this.durationText,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              Images.birthdayBg,
              fit: BoxFit.fill,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          Positioned(
            left: 10,
            right: 10,
            top: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  headline,
                  style:AppFonts.subtitle.copyWith(fontSize:22.sp )
                ),

                const SizedBox(height: 50),
                ElevatedButton(
                  style: AppButtonStyle.secondary,
                  onPressed: (){

                  },
                  child: const Text('Read now'),
                ),
                const SizedBox(height: 20),
                Text(
                  subHeadline,
                  style:AppFonts.small.copyWith()
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PageIndicators extends StatelessWidget {
  final int currentIndex;
  final int total;

  const PageIndicators({
    super.key,
    required this.currentIndex,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (index) {
        bool isActive = index == currentIndex;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: isActive ? 30 : 20,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF115D41) : const Color(0xFFF5F2E9),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}

//TODO : Make it Superate file for this

class GovtProjectsCard extends StatelessWidget {
  final String imagePath;
  final int totalProjects;
  final VoidCallback onTap;

  const GovtProjectsCard({
    super.key,
    required this.imagePath,
    required this.totalProjects,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFDFBF6),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Govt projects',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF222222),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'See All',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF222222),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Image Card
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: 350,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    color: const Color(0xFFF8F4E3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: '$totalProjects ',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF115D41),
                            ),
                            children: const [
                              TextSpan(
                                text: 'total\nprojects',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF115D41),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ElevatedButton(
                      style: AppButtonStyle.secondary,
                      onPressed: onTap,
                      child: const Text('Know more'),
                    )
                        /*
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF115D41),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          onPressed: onTap,
                          child:  Text(
                            'Know more',
                            style: AppFonts.body.copyWith(color: AppColor.white),
                          ),
                        ),
                        
                         */
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          // Indicator bar
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFF115D41),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 20,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F2E9),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 20,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F2E9),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
          // Indicator bar
        ],
      ),
    );
  }
}

// TODO : Widget for expore



class ExplorePlantationCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  const ExplorePlantationCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.icon,
    required this.onTap,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        height: 170,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          image: DecorationImage(
            image: AssetImage(Images.sampleImg,),
            fit: BoxFit.cover,

            colorFilter: isActive
                ? null
                : const ColorFilter.mode(
              Colors.black45,
              BlendMode.saturation,
            ),
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF114D3E),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.arrow_forward,
                        color: Color(0xFF114D3E),
                      ),
                      // Icon(
                      //   icon,
                      //   color: const Color(0xFF114D3E),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

