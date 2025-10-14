import 'package:flutter/material.dart';
import 'package:treelove/features/authentication/screens/create_account_screen.dart';
import 'package:treelove/features/authentication/screens/forgot_password_screen.dart';
import 'package:treelove/features/authentication/screens/new_password_screen.dart';
import 'package:treelove/features/authentication/screens/otp_verification_screen.dart';
import 'package:treelove/features/authentication/screens/password_login_screen.dart';
import 'package:treelove/features/customer/retail/cart/cart_screen.dart';
import 'package:treelove/features/customer/retail/home/screens/main_screen.dart';
import 'package:treelove/features/customer/retail/invite-friend/screens/invite_friend_screen.dart';
import 'package:treelove/features/customer/retail/my-trees/screens/my_trees_screen.dart';
import 'package:treelove/features/customer/retail/tree-species/tree_species_details.dart';
import 'package:treelove/features/customer/retail/tree-species/tree_species_list.dart';
import 'package:treelove/features/onboarding/screens/welcome_screen.dart';
import 'package:treelove/features/vendor/home/screens/project_detail_screen.dart';
import '../../../common/screens/satellite_history_screen.dart';
import '../../../common/screens/satellite_monitoring_result_screen.dart';
import '../../../features/authentication/screens/sign_in_screen.dart';
import '../../../features/customer/b2b/home/screens/main_screen.dart';
import '../../../features/customer/b2b/map/screens/b2b_map_screen.dart';
import '../../../features/customer/b2b/projects/screens/project_detail_screen.dart';
import '../../../features/customer/retail/FAQ/faq_screen.dart';
import '../../../features/customer/retail/Grievance/screens/raise_grievance_screen.dart';
import '../../../features/customer/retail/home/screens/home_screen.dart';
import '../../../features/customer/retail/home/screens/location_selection_screen.dart';
import '../../../features/customer/retail/my-trees/screens/tree_maintenance_list.dart';
import '../../../features/customer/retail/my-trees/screens/tree_monitoring_history.dart';
import '../../../features/customer/retail/order/congratulations_screen.dart';
import '../../../features/customer/retail/order/order_list_screen.dart';
import '../../../features/customer/retail/order/order_tracker_screen.dart';
import '../../../features/customer/retail/profile/screen/account_screen.dart';
import '../../../features/fieldworker/home/screens/main_screen.dart';
import '../../../features/fieldworker/activity/screens/project_action_screen.dart';
import '../../../features/fieldworker/home/screens/maintenance_activity_screen.dart';
import '../../../features/fieldworker/home/screens/monitor_activity_screen.dart';
import '../../../features/fieldworker/home/screens/select_tree_species.dart';
import '../../../features/fieldworker/home/screens/tree_maintenance_list_screen.dart';
import '../../../features/fieldworker/home/screens/tree_monitor_list_screen.dart';
import '../../../features/fieldworker/home/screens/tree_plantation_screen.dart';
import '../../../features/fieldworker/profile/screen/profile_screen.dart';
import '../../../features/vendor/Staff/new_staff_screen.dart';
import '../../../features/vendor/home/screens/main-screen.dart';
import '../../../features/vendor/home/screens/map_screen.dart';
import '../../../features/vendor/task/screens/task_allocation_screen.dart';
import '../../widgets/image_viewe.dart';
import '../../widgets/screen_404.dart';

class AppRoute{
  Route onGenerateRoute(RouteSettings settings){
    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (_) => WelcomeScreen());
        // return MaterialPageRoute(builder: (_) => TreeMaintenanceHistoryScreen(
        //   treeSpecies: 'Neem',
        //   location: 'Mumbai Zone 2',
        //   treeId: 'TL-001',
        // ));
      case '/sign-in':
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case 'user-type':
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case '/login-password':
        Map? argument = settings.arguments as Map?;
        return MaterialPageRoute(builder: (_) => PasswordLoginScreen(
              username: argument!['username'],
              type :argument['type']
        ));
      case '/create-account':
        return MaterialPageRoute(builder: (_) => CreateAccountScreen());
      case '/forgot-password':
        return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());
      case '/otp-verification':
        return MaterialPageRoute(builder: (_) => OtpVerificationScreen());
      case '/new-password':
        return MaterialPageRoute(builder: (_) => NewPasswordScreen());
      case '/retail-main':
        return MaterialPageRoute(builder: (_) => RetailMainScreen());
      case '/retail-home-screen':
        return MaterialPageRoute(builder: (_)=> HomeScreen());
      case '/plant-by-location':
        return MaterialPageRoute(builder: (_)=> MapScreen());
      case '/satellite-history':
        Map? argument = settings.arguments as Map?;
        return MaterialPageRoute(builder: (_)=> SatelliteHistoryScreen(
          plantationId: argument!['plantationId'],
        ));
      case '/tree-species-list':
        Map? argument = settings.arguments as Map?;
        return MaterialPageRoute(builder: (_)=> TreeSpeciesList(
            areaId :argument!['areaId']
        ));
      case '/satellite':
        Map? argument = settings.arguments as Map?;
        return MaterialPageRoute(builder: (_)=> SatelliteMonitoringResultScreen(
            monitorId :argument!['monitorId']
        ));
      case '/faq-section':
        return MaterialPageRoute(builder: (_)=> FaqScreen());
      case '/invite-friend':
        return MaterialPageRoute(builder: (_)=> InviteAndEarnScreen());
      case '/my-trees':
        return MaterialPageRoute(builder: (_)=> MyTreeScreen());
      case '/congratulations':
        Map? argument = settings.arguments as Map?;
        return MaterialPageRoute(builder: (_)=> CongratulationsScreen(
            shareLink: argument!['shareLink'],
        ));
      // case '/orders':
      //   return MaterialPageRoute(builder: (_)=> MyTreeScreen());
      case '/order-list' :
        return MaterialPageRoute(builder: (_)=> OrderListScreen());
      case '/order-tracker':
        Map? argument = settings.arguments as Map?;
        return MaterialPageRoute(builder: (_)=> OrderTrackerScreen(
          orderId :argument!['orderId'],
        ));
      case '/tree-maintenance-history':
        Map? argument = settings.arguments as Map?;
        return MaterialPageRoute(builder: (_)=> TreeMaintenanceHistoryScreen(
            treeSpecies:argument!['treeSpecies'],
            treeId: argument['treeId'],
            location: argument['location'],
          //orderId :argument!['orderId'],
        ));
      case '/tree-monitoring-history':
        Map? argument = settings.arguments as Map?;
        return MaterialPageRoute(builder: (_)=> TreeMonitoringHistoryScreen(
          treeSpecies:argument!['treeSpecies'],
          treeId: argument['treeId'],
          location: argument['location'],
          //orderId :argument!['orderId'],
        ));
      case '/tree-species-details':
        Map? argument = settings.arguments as Map?;
        return MaterialPageRoute(builder: (_)=> TreeSpeciesDetails(
            id :argument!['id'],
          areaId: argument['areaId'],
        ));

      ///TODO : Field Worker Mobile API
      case '/fieldworker-main-screen':
        return MaterialPageRoute(builder: (_)=> FieldWorkerMainScreen());
      case '/ProjectActionScreen':
        Map? argument = settings.arguments as Map?;
        return MaterialPageRoute(builder: (_)=> ProjectActionScreen(
          projectId: argument!['projectId'],
          projectAreaId: argument['projectAreaId'],
        ));
      case '/PlantTreeScreen':
        Map? argument = settings.arguments as Map?;
        return MaterialPageRoute(builder: (_)=> PlantTreeScreen(
          serviceType:argument!['serviceType'],
          serviceId: argument['serviceId'],
            projectAreaId:argument['projectAreaId']
        ));
      case '/select-species-plantation':
        Map? argument = settings.arguments as Map?;
        return MaterialPageRoute(builder: (_)=> SelectTreeTypeScreen(
          serviceType: argument!['serviceType'] ,
          projectAreaId:argument['projectAreaId'] ,
        ));
      case '/tree-maintenance-list':
        Map ? argument = settings.arguments as Map?;
        return MaterialPageRoute(builder: (_)=>TreeMaintenanceListScreen(
          serviceId: argument!['serviceId'] ,
        ));
      case '/maintenance-activity':
        Map? argument = settings.arguments as Map?;
        return MaterialPageRoute(builder: (_)=>MaintenanceActivityScreen(
          plantationId: argument!['plantationId'],
          serviceId: argument['serviceId'] ,
        ));
      case '/tree-monitor-list':
        return MaterialPageRoute(builder: (_)=>TreeMonitorListScreen());
      case '/monitor-activity':
        return MaterialPageRoute(builder: (_)=>MonitorActivityScreen());

      case '/CartScreen':
        return MaterialPageRoute(builder: (_)=> CartScreen());

        ///TODO : vendor  Mobile API
      case '/vendor-home-screen':
        return MaterialPageRoute(builder: (_)=> VendorMainScreen());
      case '/project-detail-screen':
        Map? argument = settings.arguments as Map?;
        return MaterialPageRoute(builder: (_)=> ProjectDetailScreen(
            projectId :argument!['projectId']
        ));
      case '/addNewStaff':
        return MaterialPageRoute(builder: (_)=> AddNewStaffScreen());
      case '/TaskAllocationScreen':
        Map ? argument = settings.arguments as Map?;
        return MaterialPageRoute(builder: (_)=> TaskAllocationScreen(
            projectAreaId: argument!['projectAreaId'],
            serviceSummary: argument['serviceSummary'],
        ));
      case '/VendorMapScreen':
        Map? argument = settings.arguments as Map?;
        return MaterialPageRoute(builder: (_)=>VendorMapScreen(
            areaId :argument!['areaId']
        ));


    ///TODO : Organization Mobile API
      case '/organization-main-screen':
        return MaterialPageRoute(builder: (_)=> OrganizationMainScreen());

      case '/b2b-project-detail':
        Map ? argument = settings.arguments as Map?;
        return MaterialPageRoute(builder: (_)=> ProjectB2BDetailsScreen(
            projectId :argument!['projectId']
        ));

      case '/b2b-map':
        return MaterialPageRoute(builder: (_)=> B2bMapScreen(
        ));

      case '/image-viewer':
        Map ? argument = settings.arguments as Map ?;
        return MaterialPageRoute(builder: (_)=>FullScreenImageViewer(
          imagePath: argument!['imagePath'],
          heroTag: argument['heroTag'],
        ));
      default:
        return  MaterialPageRoute(builder: (_) => const Screen404(
          title: "404",
          message: "'This is a Dead End'",
        ));
    }
  }

  static void goToNextPage({ required BuildContext context,  required String screen, required Map arguments}) {
    Navigator.pushNamed(context, screen,arguments: arguments);
  }

  static void pop(BuildContext context) {
    Navigator.canPop(context) ? Navigator.of(context).pop() : _showErrorCantGoBack(context);
  }

  static void  pushReplacement(BuildContext context, String routeName, { required Map arguments, screen}) {
    Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }


  static void popUntil(BuildContext context,String routeName,{required Map arguments}){
    Navigator.of(context).popUntil(ModalRoute.withName(routeName));
  }

  static void pushAndRemoveUntil(BuildContext context, String routeName, {required Map arguments}) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
          (Route<dynamic> route) => false,
      arguments: arguments,
    );
  }

  static void pushAndRemoveUntilNamed(
      BuildContext context,
      String routeToPush,
      String untilRouteName, {
        Map<String, dynamic>? arguments,
      }) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeToPush,
      ModalRoute.withName(untilRouteName),
      arguments: arguments,
    );
  }

  static _showErrorCantGoBack(BuildContext context) {
    const SnackBar(
      content: Text(
        'Oops! Something went wrong. There are no previous screens to navigate back to.',
        style: TextStyle(fontSize: 16),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    );
  }
}
//No Screen to go Back