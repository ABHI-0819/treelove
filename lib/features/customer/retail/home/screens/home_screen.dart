import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:treelove/common/screens/notification_screen.dart';
import 'package:treelove/core/config/route/app_route.dart';

import '../../../../../common/repositories/order_flow_state.dart';
import '../../../../../core/config/constants/enum/inquiry_type_enum.dart';
import '../../../../../core/config/constants/enum/order_enum.dart';
import '../../../../../core/config/resource/images.dart';
import '../../../../../core/config/resource/service_ids.dart';
import '../../../../../core/config/themes/app_button_style.dart';
import '../../../../../core/config/themes/app_color.dart';
import '../../../../../core/config/themes/app_fonts.dart';
import '../../../../../core/services/order_item_service.dart';
import '../../../../../core/storage/preference_keys.dart';
import '../../../../../core/storage/secure_storage.dart';
import '../../../../fieldworker/home/screens/main_screen.dart';
import '../../cart/cart_screen.dart';
import '../../maintenance/select_maintenance_location.dart';
import '../../project/screens/project_overview_section.dart';
import '../../project/screens/project_template_screen.dart';
import 'area_selection_screen.dart';
import 'location_selection_screen.dart';
/*
final SecurePreference preference = SecurePreference();

class HomeScreen extends StatefulWidget {
  static const String route = '/retail-home-screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    ServiceIds.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFEF7),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeTopSection(),
            /*
            _buildTreeLovProjects(),

             */
            _buildServiceSection(),
            QuickPlantingOptionsSection(),
            ProjectCategorySection(
              sectionTitle: 'TreeLov Projects',
              category: 'treelov',
              onSeeAllTap: (){
                AppRoute.goToNextPage(
                  context: context,
                  screen: ProjectTemplateScreen.route,
                  arguments: {
                    'title': 'TreeLov Project',
                    'category': 'treelov',
                  },
                );
              },
            ),
            ProjectCategorySection(
              sectionTitle: 'Government Plantations',
              category: 'government',
              onSeeAllTap: (){
                AppRoute.goToNextPage(
                  context: context,
                  screen: ProjectTemplateScreen.route,
                  arguments: {
                    'title': 'Government Plantations',
                    'category': 'government',
                  },
                );
              },
            ),
            ProjectCategorySection(
              sectionTitle: 'Farmer Projects',
              category: 'farmer',
              onSeeAllTap: (){
                AppRoute.goToNextPage(
                  context: context,
                  screen: ProjectTemplateScreen.route,
                  arguments: {
                    'title': 'Farmer Projects',
                    'category': 'farmer',
                  },
                );
              },
            ),
            /*
            _buildFarmerProjects(),

             */
            /*
            GovtProjectsCard(
              imagePath: Images.birthdayBg,
              totalProjects: 0,
              onSeeAllTap: () {
                AppRoute.goToNextPage(
                  context: context,
                  screen: ProjectTemplateScreen.route,
                  arguments: {
                    'title': 'Government Plantations',
                    'category': 'government',
                  },
                );
              },
              onTap: () {
                AppRoute.goToNextPage(
                  context: context,
                  screen: ProjectTemplateScreen.route,
                  arguments: {
                    'title': 'Government Plantations',
                    'category': 'government',
                  },
                );
              },
            ),

             */
            TrendingTopicsWidget(topics: []),
            const CustomerSatisfactionWidget(),
          ],
        ),
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
            'Explore other services',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF222222),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12.h),
          _buildServiceCard(
            icon: Images.monitorIcon,
            title: 'Monitoring',
            onTap: () {
              // Add navigation or action
            },
          ),
          SizedBox(height: 12.h),
          _buildServiceCard(
            icon: Images.babyPlantIcon,
            title: 'Maintenance',
            onTap: () {
              // Add navigation or action
            },
          ),
        ],
      ),
    );
  }


  Widget _buildServiceCard({
    required String icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColor.background.withOpacity(0.9),
          borderRadius: BorderRadius.circular(1),
        ),
        child: Row(
          children: [
            SvgPicture.asset(icon, width: 20, height: 20),
            SizedBox(width: 20.w),
            Expanded(
              child: Text(
                title,
                style: AppFonts.body.copyWith(color: AppColor.primary),
              ),
            ),
            SvgPicture.asset(Images.rightArrowIcon, width: 20, height: 20),
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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 40.h, 16.w, 24.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.primary,
            AppColor.primaryLight,
          ],
        ),
      ),
      child: Column(
        children: [
          // Compact Header Row
          Row(
            children: [
              // Logo
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Image.asset(
                  Images.appLogo,
                  width: 28,
                  height: 28,
                ),
              ),
              SizedBox(width: 12.w),

              // User Info - Compact
              Expanded(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18.r,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 16.r,
                        backgroundImage: AssetImage(Images.accountIcon),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Good Morning',
                            style: AppFonts.caption.copyWith(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          FutureBuilder<String?>(
                            future: preference.getString(Keys.username),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.data ?? 'Ankit Sharma',
                                  style: AppFonts.subtitle.copyWith(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    height: 1.2,
                                  ),
                                );
                              }
                              return SizedBox.shrink(); // or a loading indicator
                            },
                          )

                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Action Icons - Compact
              Row(
                children: [
                  // Notification Bell
                  _ActionIcon(
                    icon: Icons.notifications_outlined,
                    hasNotification: true,
                    onTap: () {
                      AppRoute.goToNextPage(context: context, screen: NotificationsScreen.route, arguments: {});
                    },
                  ),
                  SizedBox(width: 10.w),

                  // Cart Icon
                  _ActionIcon(
                    icon: Icons.shopping_bag_outlined,
                    badgeCount: 3,
                    onTap: () {
                      AppRoute.goToNextPage(context: context, screen: CartScreen.route, arguments: {});
                    },
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Enhanced Search Bar
          GestureDetector(
            onTap: () {
              // Navigate to search screen
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: AppColor.textMuted,
                    size: 22,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Search',
                      style: AppFonts.body.copyWith(
                        color: AppColor.textMuted,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: AppColor.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.filter_list,
                      color: AppColor.secondary,
                      size: 18,
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

///  Quick Planting Options Section Widget
class QuickPlantingOptionsSection extends StatelessWidget {
  const QuickPlantingOptionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          const Text(
            'Quick Planting Options',
            style:TextStyle(
              fontSize: 16,
              color: Color(0xFF222222),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),

          // Birthday Plantation Card
          PlantingOptionCard(
            icon: Icons.cake_outlined,
            title: 'Birthday Plantation',
            subtitle: '20 trees package',
            onTap: () {
              // Navigate to birthday plantation
            },
          ),
          const SizedBox(height: 12),

          // Anniversary Gifts Card
          PlantingOptionCard(
            icon: Icons.favorite_border,
            title: 'Anniversary Gifts',
            subtitle: '25 trees package',
            onTap: () {
              // Navigate to anniversary gifts
            },
          ),
        ],
      ),
    );
  }
}

///  Reusable Planting Option Card Widget
class PlantingOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const PlantingOptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding:  EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColor.secondaryLight.withOpacity(0.3), // Light green background
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColor.secondary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Icon Section
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColor.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 24,
                color: AppColor.primary,
              ),
            ),
            const SizedBox(width: 16),

            // Text Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColor.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColor.secondary,
                    ),
                  ),
                ],
              ),
            ),

            // Trailing Arrow Icon
            Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: AppColor.primary.withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final bool hasNotification;
  final int? badgeCount;
  final VoidCallback onTap;

  const _ActionIcon({
    required this.icon,
    this.hasNotification = false,
    this.badgeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            if (hasNotification || badgeCount != null)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: EdgeInsets.all(badgeCount != null ? 4.w : 6.w),
                  decoration: BoxDecoration(
                    color: AppColor.accent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColor.primary,
                      width: 2,
                    ),
                  ),
                  child: badgeCount != null
                      ? Text(
                    badgeCount! > 9 ? '9+' : badgeCount.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  )
                      : SizedBox(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CustomerSatisfactionWidget extends StatefulWidget {
  const CustomerSatisfactionWidget({super.key});

  @override
  State<CustomerSatisfactionWidget> createState() =>
      _CustomerSatisfactionWidgetState();
}

class _CustomerSatisfactionWidgetState extends State<CustomerSatisfactionWidget> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;

  final List<List<Map<String, String>>> _customerPages = [
    [
      {
        'name': 'Satya Singh',
        'age': '32y',
        'location': 'Bengaluru',
        'image':
        'https://plus.unsplash.com/premium_photo-1690407617542-2f210cf20d7e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cGVyc29ufGVufDB8fDB8fHww'
      },
      {
        'name': 'Priya Sharma',
        'age': '28y',
        'location': 'Mumbai',
        'image':
        'https://plus.unsplash.com/premium_photo-1690407617542-2f210cf20d7e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cGVyc29ufGVufDB8fDB8fHww'
      },
    ],
    [
      {
        'name': 'Rajesh Kumar',
        'age': '45y',
        'location': 'Delhi',
        'image':
        'https://plus.unsplash.com/premium_photo-1690407617542-2f210cf20d7e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cGVyc29ufGVufDB8fDB8fHww'
      },
      {
        'name': 'Anita Devi',
        'age': '35y',
        'location': 'Chennai',
        'image':
        'https://plus.unsplash.com/premium_photo-1690407617542-2f210cf20d7e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cGVyc29ufGVufDB8fDB8fHww'
      },
    ],
    [
      {
        'name': 'Vikram Patel',
        'age': '50y',
        'location': 'Ahmedabad',
        'image':
        'https://plus.unsplash.com/premium_photo-1690407617542-2f210cf20d7e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cGVyc29ufGVufDB8fDB8fHww'
      },
      {
        'name': 'Neha Gupta',
        'age': '29y',
        'location': 'Pune',
        'image':
        'https://plus.unsplash.com/premium_photo-1690407617542-2f210cf20d7e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cGVyc29ufGVufDB8fDB8fHww'
      },
    ],
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final nextPageIndex = _pageController.page?.round() ?? 0;
      if (nextPageIndex != _currentPage) {
        setState(() => _currentPage = nextPageIndex);
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
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '5 lakh+ plantation Completed.',
            style: AppFonts.body.copyWith(color: const Color(0xFF00473C)),
          ),
          SizedBox(height: 12.h),
          Text(
            '10k+ customers satisfied.',
            style: AppFonts.subtitle.copyWith(
              color: AppColor.black,
              fontSize: 27.sp,
            ),
          ),
          SizedBox(height: 10.h),
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
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 30.h),
          SizedBox(
            height: 250.h,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _customerPages.length,
              itemBuilder: (context, pageIndex) {
                final pageCustomers = _customerPages[pageIndex];
                return Row(
                  children: [
                    Expanded(
                      child: CustomerCard(
                        imagePath: pageCustomers[0]['image']!,
                        name: pageCustomers[0]['name']!,
                        age: pageCustomers[0]['age']!,
                        location: pageCustomers[0]['location']!,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: CustomerCard(
                        imagePath: pageCustomers[1]['image']!,
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
          SizedBox(height: 30.h),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _customerPages.length,
                    (index) => Dot(
                  color: _currentPage == index
                      ? const Color(0xFF115D41)
                      : const Color(0xFFF5F2E9),
                  width: _currentPage == index ? 24.w : 12.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
        borderRadius: BorderRadius.circular(10.r),
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
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              imagePath,
              height: 180.h,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(child: CircularProgressIndicator(value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null));
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Icon(Icons.error));
              },
            ),
          ),
          SizedBox(height: 8.h),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(
            '$age, $location',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class Dot extends StatelessWidget {
  final Color color;
  final double width;

  const Dot({
    super.key,
    this.color = const Color(0xFFF5F2E9),
    this.width = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 6.h,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3.r),
      ),
    );
  }
}

class TrendingTopic {
  final String id;
  final String imagePath;
  final String headline;
  final String subHeadline;
  final String durationText;
  final String category;
  final DateTime publishedDate;
  final String? readMoreUrl;

  const TrendingTopic({
    required this.id,
    required this.imagePath,
    required this.headline,
    required this.subHeadline,
    required this.durationText,
    required this.category,
    required this.publishedDate,
    this.readMoreUrl,
  });
}

class TrendingTopicsWidget extends StatefulWidget {
  final List<TrendingTopic> topics;
  final String? sectionTitle;
  final VoidCallback? onSeeAll;
  final Function(TrendingTopic)? onTopicTap;

  const TrendingTopicsWidget({
    super.key,
    required this.topics,
    this.sectionTitle,
    this.onSeeAll,
    this.onTopicTap,
  });

  @override
  State<TrendingTopicsWidget> createState() => _TrendingTopicsWidgetState();
}

class _TrendingTopicsWidgetState extends State<TrendingTopicsWidget> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    // Temporary code to clear the box for testing:

    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.topics.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      color: const Color(0xFFF8F4E3),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 20.h),
          _buildTopicsCarousel(),
          SizedBox(height: 16.h),
          _buildPageIndicators(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.sectionTitle ?? "Read up on trending\n'Plantation' topics",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF3D3D3D),
              height: 1.3,
            ),
          ),
        ),
        if (widget.onSeeAll != null)
          TextButton(
            onPressed: widget.onSeeAll,
            child: Text(
              'See All',
              style: TextStyle(
                color: const Color(0xFF115D41),
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTopicsCarousel() {
    return SizedBox(
      height: 320.h,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        itemCount: widget.topics.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: TrendingTopicCard(
              topic: widget.topics[index],
              onTap: () => widget.onTopicTap?.call(widget.topics[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPageIndicators() {
    if (widget.topics.length <= 1) return const SizedBox.shrink();

    return Center(
      child: PageIndicators(
        currentIndex: _currentIndex,
        total: widget.topics.length,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      color: const Color(0xFFF8F4E3),
      padding: const EdgeInsets.all(32),
      child: const Center(
        child: Column(
          children: [
            Icon(
              Icons.article_outlined,
              size: 48,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No trending topics available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrendingTopicCard extends StatelessWidget {
  final TrendingTopic topic;
  final VoidCallback? onTap;

  const TrendingTopicCard({
    super.key,
    required this.topic,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            _buildBackgroundImage(),
            _buildGradientOverlay(),
            _buildCategoryBadge(),
            _buildContent(),
            _buildDurationBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: Image.asset(
        topic.imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
              color: Colors.grey[300],
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Image not found', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              )
          );
        },
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryBadge() {
    return Positioned(
      top: 12.h,
      left: 12.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: const Color(0xFF115D41),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          topic.category.toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Positioned(
      left: 16.w,
      right: 16.w,
      bottom: 20.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            topic.headline,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8.h),
          Text(
            topic.subHeadline,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.9),
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF115D41),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
                elevation: 0,
              ),
              onPressed: onTap,
              child: Text(
                'Read Now',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationBadge() {
    return Positioned(
      top: 12.h,
      right: 12.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.access_time,
              size: 12,
              color: Colors.white,
            ),
            SizedBox(width: 4.w),
            Text(
              topic.durationText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
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
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          height: 6.h,
          width: isActive ? 24.w : 12.w,
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFF115D41)
                : const Color(0xFF115D41).withOpacity(0.3),
            borderRadius: BorderRadius.circular(3.r),
          ),
        );
      }),
    );
  }
}

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
        width: 130.w,
        height: 170.h,
        margin: EdgeInsets.only(right: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          image: DecorationImage(
            image: AssetImage(Images.sampleImg),
            fit: BoxFit.cover,
            colorFilter: isActive
                ? null
                : const ColorFilter.mode(
              Colors.black45,
              BlendMode.saturation,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: const Color(0xFF114D3E),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(
                    Icons.arrow_forward,
                    color: Color(0xFF114D3E),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

 */

final SecurePreference preference = SecurePreference();
class HomeScreen extends StatefulWidget {
  static const String route = '/retail-home-screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    ServiceIds.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFEF7),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeTopSection(),

            // NEW: Featured Plantation Types Section
            _buildFeaturedPlantationTypes(),

            // Quick Planting Options
            const QuickPlantingOptionsSection(),

            // Service Section
            _buildServiceSection(),

            // Project Categories
            ProjectCategorySection(
              sectionTitle: 'TreeLov Projects',
              category: 'treelov',
              onSeeAllTap: () {
                AppRoute.goToNextPage(
                  context: context,
                  screen: ProjectTemplateScreen.route,
                  arguments: {
                    'title': 'TreeLov Project',
                    'category': 'treelov',
                  },
                );
              },
            ),
            ProjectCategorySection(
              sectionTitle: 'Government Plantations',
              category: 'government',
              onSeeAllTap: () {
                AppRoute.goToNextPage(
                  context: context,
                  screen: ProjectTemplateScreen.route,
                  arguments: {
                    'title': 'Government Plantations',
                    'category': 'government',
                  },
                );
              },
            ),
            ProjectCategorySection(
              sectionTitle: 'Farmer Projects',
              category: 'farmer',
              onSeeAllTap: () {
                AppRoute.goToNextPage(
                  context: context,
                  screen: ProjectTemplateScreen.route,
                  arguments: {
                    'title': 'Farmer Projects',
                    'category': 'farmer',
                  },
                );
              },
            ),

            // Trending Topics
            TrendingTopicsWidget(topics: []),

            // Customer Satisfaction
            const CustomerSatisfactionWidget(),
          ],
        ),
      ),
    );
  }

  // NEW: Featured Plantation Types Section
  Widget _buildFeaturedPlantationTypes() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Text(
            'Plant Trees Your Way',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF222222),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Choose where your trees grow',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF666666),
            ),
          ),
          SizedBox(height: 20.h),

          // Three Cards
          _buildPlantationTypeCard(
            icon: Icons.location_on,
            title: 'Plantation Near You',
            description: 'Plant trees in your local area',
            color: const Color(0xFF2E7D32),
            iconBgColor: const Color(0xFFE8F5E9),
            onTap: () {
              OrderFlowState().orderType = OrderType.normal;
              AppRoute.goToNextPage(context: context, screen: MapScreen.route, arguments: {});
              // Navigate to nearby plantations
            },
          ),
          SizedBox(height: 12.h),

          _buildPlantationTypeCard(
            icon: Icons.forest,
            title: 'Forest Plantation',
            description: 'Contribute to forest conservation',
            color: const Color(0xFF1B5E20),
            iconBgColor: const Color(0xFFE8F5E9),
            onTap: () {
              OrderFlowState().orderType = OrderType.normal;
              AppRoute.goToNextPage(context: context, screen: ProjectTemplateScreen.route, arguments: {
                'title':'Forest Projects',
                'category':'ngo'
              });
              // Navigate to forest plantations
            },
          ),
          SizedBox(height: 12.h),

          _buildPlantationTypeCard(
            icon: Icons.agriculture,
            title: 'Farmer Plantation',
            description: 'Support farmers with tree planting',
            color: const Color(0xFF827717),
            iconBgColor: const Color(0xFFF9FBE7),
            onTap: () {
              OrderFlowState().orderType = OrderType.normal;
              AppRoute.goToNextPage(context: context, screen: ProjectTemplateScreen.route, arguments: {
                'title':'Farmers Plantations',
                'category':'farmer'
              });
              // Navigate to farmer plantations
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlantationTypeCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required Color iconBgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                size: 28,
                color: color,
              ),
            ),
            SizedBox(width: 16.w),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF222222),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),

            // Arrow Icon
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Additional Services',
            style: TextStyle(
              fontSize: 18.sp,
              color: const Color(0xFF222222),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Keep your trees healthy and thriving',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF666666),
            ),
          ),
          SizedBox(height: 16.h),

          _buildServiceCard(
            icon: Images.monitorIcon,
            title: 'Tree Monitoring',
            subtitle: 'Track your tree growth',
            onTap: () {
              AppRoute.goToNextPage(context: context, screen: SelectMonitoringScreen.route, arguments: {
                'inquiryType': InquiryType.monitoring
              });
              // Add navigation
            },
          ),
          SizedBox(height: 12.h),

          _buildServiceCard(
            icon: Images.babyPlantIcon,
            title: 'Tree Maintenance',
            subtitle: 'Keep trees healthy',
            onTap: () {
              // Add navigation
              AppRoute.goToNextPage(context: context, screen: SelectMonitoringScreen.route, arguments: {
                'inquiryType': InquiryType.maintenance
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard({
    required String icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColor.primary.withOpacity(0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: AppColor.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: SvgPicture.asset(icon, width: 24, height: 24),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF222222),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColor.primary.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}

// IMPROVED Home Top Section with better visual hierarchy
class HomeTopSection extends StatelessWidget {
  const HomeTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 50.h, 16.w, 24.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.primary,
            AppColor.primaryLight,
          ],
        ),
      ),
      child: Column(
        children: [
          // Header Row
          Row(
            children: [
              // Logo
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Image.asset(
                  Images.appLogo,
                  width: 32,
                  height: 32,
                ),
              ),
              SizedBox(width: 14.w),

              // User Info
              Expanded(
                child: Row(
                  children: [
                    // CircleAvatar(
                    //   radius: 22.r,
                    //   backgroundColor: Colors.white,
                    //   child: CircleAvatar(
                    //     radius: 20.r,
                    //     backgroundImage: AssetImage(Images.accountIcon),
                    //   ),
                    // ),
                    // SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Good Morning',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          FutureBuilder<String?>(
                            future: preference.getString(Keys.name),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.data ?? 'User',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    height: 1.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Action Icons
              Row(
                children: [
                  _ActionIcon(
                    icon: Icons.notifications_outlined,
                    hasNotification: true,
                    badgeCount: 2,
                    onTap: () {
                      AppRoute.goToNextPage(
                        context: context,
                        screen: NotificationsScreen.route,
                        arguments: {

                        },
                      );
                    },
                  ),
                  SizedBox(width: 10.w),
                  _ActionIcon(
                    icon: Icons.shopping_bag_outlined,
                    badgeCount: 3,
                    onTap: () {
                      AppRoute.goToNextPage(
                        context: context,
                        screen: CartScreen.route,
                        arguments: {
                          'msgType':'',
                          'customMsg':''
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Search Bar
          GestureDetector(
            onTap: () {
              // Navigate to search screen
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: AppColor.textMuted,
                    size: 22,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Search for trees, projects...',
                      style: TextStyle(
                        color: AppColor.textMuted,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColor.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.tune,
                      color: AppColor.secondary,
                      size: 18,
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

// IMPROVED Quick Planting Options Section
class QuickPlantingOptionsSection extends StatelessWidget {
  const QuickPlantingOptionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Special Occasions',
            style: TextStyle(
              fontSize: 18.sp,
              color: const Color(0xFF222222),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Plant trees for memorable moments',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF666666),
            ),
          ),
          SizedBox(height: 16.h),

          PlantingOptionCard(
            icon: Icons.cake_outlined,
            title: 'Birthday Plantation',
            subtitle: '20 trees package',
            color: const Color(0xFFE91E63),
            onTap: () {
              OrderFlowState().orderType = OrderType.birthday;
              AppRoute.goToNextPage(context: context, screen: AreaSelectionScreen.route, arguments: {
                'treeCount': 20,
              });
              // Navigate to birthday plantation
            },
          ),
          SizedBox(height: 12.h),

          PlantingOptionCard(
            icon: Icons.favorite_border,
            title: 'Anniversary Gifts',
            subtitle: '25 trees package',
            color: const Color(0xFFD32F2F),
            onTap: () {
              OrderFlowState().orderType = OrderType.anniversary;
              AppRoute.goToNextPage(context: context, screen: AreaSelectionScreen.route, arguments: {
                'treeCount': 25,
              });
              // Navigate to anniversary gifts
            },
          ),
        ],
      ),
    );
  }
}

// IMPROVED Planting Option Card
class PlantingOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  const PlantingOptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                size: 26,
                color: color,
              ),
            ),
            SizedBox(width: 16.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF222222),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Keep all other classes (ActionIcon, CustomerSatisfactionWidget, etc.) as they were...
class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final bool hasNotification;
  final int? badgeCount;
  final VoidCallback onTap;

  const _ActionIcon({
    required this.icon,
    this.hasNotification = false,
    this.badgeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            if (hasNotification || badgeCount != null)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: EdgeInsets.all(badgeCount != null ? 4.w : 6.w),
                  decoration: BoxDecoration(
                    color: AppColor.accent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColor.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
class TrendingTopic {
  final String id;
  final String imagePath;
  final String headline;
  final String subHeadline;
  final String durationText;
  final String category;
  final DateTime publishedDate;
  final String? readMoreUrl;

  const TrendingTopic({
    required this.id,
    required this.imagePath,
    required this.headline,
    required this.subHeadline,
    required this.durationText,
    required this.category,
    required this.publishedDate,
    this.readMoreUrl,
  });
}

class TrendingTopicsWidget extends StatefulWidget {
  final List<TrendingTopic> topics;
  final String? sectionTitle;
  final VoidCallback? onSeeAll;
  final Function(TrendingTopic)? onTopicTap;

  const TrendingTopicsWidget({
    super.key,
    required this.topics,
    this.sectionTitle,
    this.onSeeAll,
    this.onTopicTap,
  });

  @override
  State<TrendingTopicsWidget> createState() => _TrendingTopicsWidgetState();
}

class _TrendingTopicsWidgetState extends State<TrendingTopicsWidget> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    // Temporary code to clear the box for testing:

    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.topics.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      color: const Color(0xFFF8F4E3),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trending Topic',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF222222),
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: (){

                },
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF222222),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          _buildHeader(),
          SizedBox(height: 20.h),
          _buildTopicsCarousel(),
          SizedBox(height: 16.h),
          _buildPageIndicators(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.sectionTitle ?? "Read up on trending\n'Plantation' topics",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF3D3D3D),
              height: 1.3,
            ),
          ),
        ),
        if (widget.onSeeAll != null)
          TextButton(
            onPressed: widget.onSeeAll,
            child: Text(
              'See All',
              style: TextStyle(
                color: const Color(0xFF115D41),
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTopicsCarousel() {
    return SizedBox(
      height: 320.h,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        itemCount: widget.topics.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: TrendingTopicCard(
              topic: widget.topics[index],
              onTap: () => widget.onTopicTap?.call(widget.topics[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPageIndicators() {
    if (widget.topics.length <= 1) return const SizedBox.shrink();

    return Center(
      child: PageIndicators(
        currentIndex: _currentIndex,
        total: widget.topics.length,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      color: const Color(0xFFF8F4E3),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: const EdgeInsets.all(32),
      child: const Center(
        child: Column(
          children: [
            Icon(
              Icons.article_outlined,
              size: 48,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No trending topics available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrendingTopicCard extends StatelessWidget {
  final TrendingTopic topic;
  final VoidCallback? onTap;

  const TrendingTopicCard({
    super.key,
    required this.topic,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            _buildBackgroundImage(),
            _buildGradientOverlay(),
            _buildCategoryBadge(),
            _buildContent(),
            _buildDurationBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: Image.asset(
        topic.imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
              color: Colors.grey[300],
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Image not found', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              )
          );
        },
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryBadge() {
    return Positioned(
      top: 12.h,
      left: 12.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: const Color(0xFF115D41),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          topic.category.toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Positioned(
      left: 16.w,
      right: 16.w,
      bottom: 20.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            topic.headline,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8.h),
          Text(
            topic.subHeadline,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.9),
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF115D41),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
                elevation: 0,
              ),
              onPressed: onTap,
              child: Text(
                'Read Now',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationBadge() {
    return Positioned(
      top: 12.h,
      right: 12.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.access_time,
              size: 12,
              color: Colors.white,
            ),
            SizedBox(width: 4.w),
            Text(
              topic.durationText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
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
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          height: 6.h,
          width: isActive ? 24.w : 12.w,
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFF115D41)
                : const Color(0xFF115D41).withOpacity(0.3),
            borderRadius: BorderRadius.circular(3.r),
          ),
        );
      }),
    );
  }
}

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
        width: 130.w,
        height: 170.h,
        margin: EdgeInsets.only(right: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          image: DecorationImage(
            image: AssetImage(Images.sampleImg),
            fit: BoxFit.cover,
            colorFilter: isActive
                ? null
                : const ColorFilter.mode(
              Colors.black45,
              BlendMode.saturation,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: const Color(0xFF114D3E),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(
                    Icons.arrow_forward,
                    color: Color(0xFF114D3E),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomerSatisfactionWidget extends StatefulWidget {
  const CustomerSatisfactionWidget({super.key});

  @override
  State<CustomerSatisfactionWidget> createState() =>
      _CustomerSatisfactionWidgetState();
}

class _CustomerSatisfactionWidgetState extends State<CustomerSatisfactionWidget> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;

  final List<List<Map<String, String>>> _customerPages = [
    [
      {
        'name': 'Satya Singh',
        'age': '32y',
        'location': 'Bengaluru',
        'image':
        'https://plus.unsplash.com/premium_photo-1690407617542-2f210cf20d7e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cGVyc29ufGVufDB8fDB8fHww'
      },
      {
        'name': 'Priya Sharma',
        'age': '28y',
        'location': 'Mumbai',
        'image':
        'https://plus.unsplash.com/premium_photo-1690407617542-2f210cf20d7e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cGVyc29ufGVufDB8fDB8fHww'
      },
    ],
    [
      {
        'name': 'Rajesh Kumar',
        'age': '45y',
        'location': 'Delhi',
        'image':
        'https://plus.unsplash.com/premium_photo-1690407617542-2f210cf20d7e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cGVyc29ufGVufDB8fDB8fHww'
      },
      {
        'name': 'Anita Devi',
        'age': '35y',
        'location': 'Chennai',
        'image':
        'https://plus.unsplash.com/premium_photo-1690407617542-2f210cf20d7e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cGVyc29ufGVufDB8fDB8fHww'
      },
    ],
    [
      {
        'name': 'Vikram Patel',
        'age': '50y',
        'location': 'Ahmedabad',
        'image':
        'https://plus.unsplash.com/premium_photo-1690407617542-2f210cf20d7e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cGVyc29ufGVufDB8fDB8fHww'
      },
      {
        'name': 'Neha Gupta',
        'age': '29y',
        'location': 'Pune',
        'image':
        'https://plus.unsplash.com/premium_photo-1690407617542-2f210cf20d7e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cGVyc29ufGVufDB8fDB8fHww'
      },
    ],
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final nextPageIndex = _pageController.page?.round() ?? 0;
      if (nextPageIndex != _currentPage) {
        setState(() => _currentPage = nextPageIndex);
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
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '5 lakh+ plantation Completed.',
            style: AppFonts.body.copyWith(color: const Color(0xFF00473C)),
          ),
          SizedBox(height: 12.h),
          Text(
            '10k+ customers satisfied.',
            style: AppFonts.subtitle.copyWith(
              color: AppColor.black,
              fontSize: 27.sp,
            ),
          ),
          SizedBox(height: 10.h),
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
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 30.h),
          SizedBox(
            height: 250.h,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _customerPages.length,
              itemBuilder: (context, pageIndex) {
                final pageCustomers = _customerPages[pageIndex];
                return Row(
                  children: [
                    Expanded(
                      child: CustomerCard(
                        imagePath: pageCustomers[0]['image']!,
                        name: pageCustomers[0]['name']!,
                        age: pageCustomers[0]['age']!,
                        location: pageCustomers[0]['location']!,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: CustomerCard(
                        imagePath: pageCustomers[1]['image']!,
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
          SizedBox(height: 30.h),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _customerPages.length,
                    (index) => Dot(
                  color: _currentPage == index
                      ? const Color(0xFF115D41)
                      : const Color(0xFFF5F2E9),
                  width: _currentPage == index ? 24.w : 12.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class Dot extends StatelessWidget {
  final Color color;
  final double width;

  const Dot({
    super.key,
    this.color = const Color(0xFFF5F2E9),
    this.width = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 6.h,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3.r),
      ),
    );
  }
}

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
        borderRadius: BorderRadius.circular(10.r),
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
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              imagePath,
              height: 180.h,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(child: CircularProgressIndicator(value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null));
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Icon(Icons.error));
              },
            ),
          ),
          SizedBox(height: 8.h),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(
            '$age, $location',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
