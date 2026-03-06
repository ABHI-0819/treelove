import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:treelove/features/authentication/bloc/google_auth_event.dart';

import '../../../common/repositories/login_repository.dart';
import '../../../core/config/resource/images.dart';
import '../../../core/config/route/app_route.dart';
import '../../../core/config/themes/app_color.dart';
import '../../../core/config/themes/app_fonts.dart';
import '../../../core/network/api_connection.dart';
import '../../../core/services/auth_service.dart';
import '../../customer/b2b/home/screens/main_screen.dart';
import '../../customer/retail/home/screens/main_screen.dart';
import '../bloc/google_auth_bloc.dart';
import '../bloc/google_auth_state.dart';
import '../models/google.login.request.model.dart';
import '../models/google.login.response.model.dart';
/*
class UserTypeScreen extends StatefulWidget {
  static const route = '/user-type';
  const UserTypeScreen({super.key});

  @override
  State<UserTypeScreen> createState() => _UserTypeScreenState();
}

class _UserTypeScreenState extends State<UserTypeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}

 */

class UserTypeSelectionScreen extends StatefulWidget {
  static const route = '/user-type';
  GoogleUser? googleUser;

  UserTypeSelectionScreen({super.key, this.googleUser});

  @override
  State<UserTypeSelectionScreen> createState() =>
      _UserTypeSelectionScreenState();
}

class _UserTypeSelectionScreenState extends State<UserTypeSelectionScreen> {
  String? selectedUserType;

  final Map<String, String> userTypes = {
    'individual': 'Individual',
    'organization': 'Organization',
  };

  void _selectUserType(String type) {
    setState(() {
      selectedUserType = type;
    });
  }

  void _continueToNextStep(BuildContext context) {
    if (selectedUserType == null) {
      return;
    }
    googleAuthBloc.add(GoogleAuthLogin(
        request: GoogleLoginRequestModel(
            email: widget.googleUser?.email ?? '',
            name: widget.googleUser?.displayName ?? '',
            idToken: widget.googleUser?.idToken ?? '',
            oauthUid: widget.googleUser?.uid ?? '',
            provider: 'google',
            userTypeId: selectedUserType == 'individual'
                ? '03edfa34-3232-4fdf-85f9-a9d8d8270581'
                : 'b78f60fa-80a2-4346-8226-29e80ade040f',
            additionalData: {'userType': selectedUserType})));
  }

  late GoogleAuthBloc googleAuthBloc;

  @override
  void initState() {
    googleAuthBloc = GoogleAuthBloc(LoginRepository(api: ApiConnection()));
    // implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEF7),
      body: BlocProvider(
        create: (context) => googleAuthBloc,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SafeArea(
            child: BlocListener<GoogleAuthBloc, GoogleAuthState>(
              listener: (context, state) {
                if (state is GoogleAuthNavigateToHomeScreen) {
                  EasyLoading.dismiss();
                  if (state.userType == 'individual') {
                    AppRoute.goToNextPage(
                      context: context,
                      screen: RetailMainScreen.route,
                      arguments: {'type': 'individual'},
                    );
                  } else if (state.userType == 'organization') {
                    AppRoute.goToNextPage(
                      context: context,
                      screen: OrganizationMainScreen.route,
                      arguments: {'type': 'organisation'},
                    );
                  }
                } else if (state is GoogleAuthFailure) {
                  EasyLoading.dismiss();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(state.error.message ??
                            "Failed to login with Google")),
                  );
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Close/Back Button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white, // Subtle circular background
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.arrow_back,
                              size: 20, color: AppColor.black),
                        ),
                      ),

                      // Minimalist Step Indicator (Optional but helpful for account setup)

                      // Empty SizedBox to keep the title/indicator centered
                      const SizedBox(width: 40),
                    ],
                  ),
                  20.verticalSpace,
                  Text('What type of user are you?',
                      style: AppFonts.headline.copyWith(
                        fontSize: 30,
                        height: 1.3,
                        color: Colors.black87,
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  const Text(
                    'Choose an account type to customize your experience.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () => _selectUserType('individual'),
                    child: Stack(
                      children: [
                        Container(
                          width: size.width,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: selectedUserType == 'individual'
                                ? AppColor.primary.withOpacity(0.1)
                                : Colors.white,
                            border: Border.all(
                              color: selectedUserType == 'individual'
                                  ? AppColor.primaryDark
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: 50,
                                  height: 50,
                                  child:
                                      SvgPicture.asset(Images.individualIcon)),
                              const SizedBox(height: 15),
                              const Text(
                                'Individual',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'For personal accounts or solo users.',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        // ✅ Check mark
                        if (selectedUserType == 'individual')
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColor.primaryDark,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => _selectUserType('organization'),
                    child: Stack(
                      children: [
                        Container(
                          width: size.width,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: selectedUserType == 'organization'
                                ? AppColor.primary.withOpacity(0.1)
                                : Colors.white,
                            border: Border.all(
                              color: selectedUserType == 'organization'
                                  ? AppColor.primaryDark
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 50,
                                height: 50,
                                child:
                                    SvgPicture.asset(Images.organizationIcon),
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                'Organization',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'For companies, teams, or business accounts.',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        if (selectedUserType == 'organization')
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColor.primaryDark,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004D40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: selectedUserType != null
                          ? () => _continueToNextStep(context)
                          : null,
                      child: Text('Continue', style: AppFonts.regular),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
