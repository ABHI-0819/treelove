import 'package:flutter/material.dart';
import 'package:treelove/features/customer/retail/home/screens/home_screen.dart';

import '../../../../../core/widgets/custom_bottom_nav.dart';
import '../../../../fieldworker/home/screens/main_screen.dart';
import '../../cart/cart_screen.dart';
import '../../project/screens/project_main_screen.dart';
import 'location_selection_screen.dart';

class RetailMainScreen extends StatefulWidget {
  static const route ='/retail-main';
  const RetailMainScreen({super.key});

  @override
  State<RetailMainScreen> createState() => _RetailMainScreenState();
}

class _RetailMainScreenState extends State<RetailMainScreen> {

  final _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  Widget buildPageView(List<Widget> bottomBarPages) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: bottomBarPages,
    );
  }


  @override
  Widget build(BuildContext context) {
    final bottomBarPages = [
       HomeScreen(),
       ProjectMainScreen(),

      // CartScreen(),
      FieldWorkerMainScreen(),
      //  DynamicPinMapScreen(),
       MapScreen(),
    ];
    return Scaffold(
      body: buildPageView(bottomBarPages),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

}
