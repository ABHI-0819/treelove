import 'package:flutter/material.dart';
import 'package:treelove/features/authentication/screens/create_account_screen.dart';
import 'package:treelove/features/authentication/screens/forgot_password_screen.dart';
import 'package:treelove/features/authentication/screens/new_password_screen.dart';
import 'package:treelove/features/authentication/screens/otp_verification_screen.dart';
import 'package:treelove/features/authentication/screens/password_login_screen.dart';
import 'package:treelove/features/customer/retail/cart/cart_screen.dart';
import 'package:treelove/features/customer/retail/home/screens/main_screen.dart';
import 'package:treelove/features/customer/retail/tree-species/tree_species_list.dart';
import '../../../features/authentication/screens/sign_in_screen.dart';
import '../../../features/authentication/screens/user_type_screen.dart';
import '../../../features/customer/retail/home/screens/home_screen.dart';
import '../../../features/customer/retail/home/screens/location_selection_screen.dart';
import '../../../features/fieldworker/home/screens/main_screen.dart';
import '../../../features/fieldworker/home/screens/project_action_screen.dart';
import '../../../features/fieldworker/home/screens/select_tree_species.dart';
import '../../../features/fieldworker/home/screens/tree_plantation_screen.dart';
import '../../../features/vendor/home/screens/main-screen.dart';
import '../../widgets/screen_404.dart';

class AppRoute{
  Route onGenerateRoute(RouteSettings settings){
    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (_) => UserTypeSelectionScreen());
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
      case '/tree-species-list':
        return MaterialPageRoute(builder: (_)=> TreeSpeciesList());

      ///TODO : Field Worker Mobile API
      case '/fieldworker-main-screen':
        return MaterialPageRoute(builder: (_)=> FieldWorkerMainScreen());
      case '/ProjectActionScreen':
        return MaterialPageRoute(builder: (_)=> ProjectActionScreen());
      case '/PlantTreeScreen':
        return MaterialPageRoute(builder: (_)=> PlantTreeScreen());
      case '/select-species-plantation':
        return MaterialPageRoute(builder: (_)=> SelectTreeTypeScreen());
      case '/CartScreen':
        return MaterialPageRoute(builder: (_)=> CartScreen());

        ///TODO : vendor  Mobile API
      case '/vendor-main-screen':
        return MaterialPageRoute(builder: (_)=> VendorMainScreen());

      ///TODO : Organization  Mobile API
      case '/organization-home-screen':
        return MaterialPageRoute(builder: (_)=> FieldWorkerMainScreen());

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