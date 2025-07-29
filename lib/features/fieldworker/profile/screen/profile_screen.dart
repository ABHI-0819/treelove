import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/bloc/api_event.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../common/repositories/login_repository.dart';
import '../../../../core/config/route/app_route.dart';
import '../../../../core/config/themes/app_color.dart';
import '../../../../core/config/themes/app_fonts.dart';
import '../../../../core/network/api_connection.dart';
import '../../../../core/storage/preference_keys.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/widgets/common_notification.dart';
import '../../../../core/widgets/input_field.dart';
import '../../../authentication/bloc/auth_bloc.dart';
import '../../../authentication/screens/sign_in_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const route = '/fieldworker-Profile';
  const  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _legalName = TextEditingController();
  final TextEditingController _website = TextEditingController();
  final TextEditingController _panNumber = TextEditingController();
  final TextEditingController _gstNumber = TextEditingController();

  late LogoutBloc logoutBloc;
  final pref = SecurePreference();

  // Mock user data (from your API response)
  String? profileImageUrl;
  String? dateOfBirth;

  @override
  void initState() {
    logoutBloc = LogoutBloc(LoginRepository(api: ApiConnection()));

    // Initialize all controllers with empty values (as per API)
    _firstName.text = "";
    _lastName.text = "";
    _bio.text = "";
    _legalName.text = "";
    _website.text = "";
    _panNumber.text = "";
    _gstNumber.text = "";

    super.initState();
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _bio.dispose();
    _legalName.dispose();
    _website.dispose();
    _panNumber.dispose();
    _gstNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => logoutBloc,
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: MultiBlocListener(
          listeners: [
            BlocListener<LogoutBloc, ApiState<ResponseModel, ResponseModel>>(
              listener: (context, state) {
                EasyLoading.dismiss();
                if (state is ApiSuccess) {
                  AppRoute.pushReplacement(context, SignInScreen.route, arguments: {});
                } else if (state is ApiFailure) {
                  showNotification(context, message: "Logout failed");
                }
              },
            ),
          ],
          child: Column(
            children: [
              _appBar(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(16.w),
                  children: [
                    _buildProfileHeader(),
                    SizedBox(height: 24.h),
                    _buildPersonalInfoSection(),
                    // SizedBox(height: 24.h),
                    // _buildBusinessInfoSection(),
                    SizedBox(height: 32.h),
                    _buildLogoutButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // AppBar
  Widget _appBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25.r),
          bottomRight: Radius.circular(25.r),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Profile',
              style: AppFonts.body.copyWith(color: AppColor.white, fontSize: 18.sp),
            ),
          ],
        ),
      ),
    );
  }

  // Profile Header (Image + Name)
  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50.r,
                backgroundColor: AppColor.grey,
                backgroundImage: profileImageUrl != null
                    ? NetworkImage(profileImageUrl!)
                    : null,
                child: profileImageUrl == null
                    ? Icon(Icons.person, size: 50.r, color: AppColor.grey)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 28.r,
                  height: 28.r,
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColor.white, width: 2.w),
                  ),
                  child: Icon(Icons.camera_alt, size: 16.r, color: AppColor.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (_firstName.text.isNotEmpty || _lastName.text.isNotEmpty)
            Text(
              "${_firstName.text} ${_lastName.text}".trim(),
              style: AppFonts.headline.copyWith(color: AppColor.black, fontSize: 16.sp),
            )
          else
            Text(
              "Unnamed User",//style: AppFonts.headline.copyWith(color: AppColor.black),
              style: AppFonts.body.copyWith(color: AppColor.black, fontSize: 14.sp),
            ),
          SizedBox(height: 4.h),
          Text(
            "~ Vendor",
            style: AppFonts.caption.copyWith(color: AppColor.primary, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }

  // Personal Information Section
  Widget _buildPersonalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Personal Information", style: AppFonts.title.copyWith(fontSize: 20.sp,color: AppColor.primary)),
        SizedBox(height: 12.h),
        InputTextField(
          controller: _firstName,
          labelText: 'First Name',
          hintText: 'Enter your first name',
        ),
        SizedBox(height: 12.h),
        InputTextField(
          controller: _lastName,
          labelText: 'Last Name',
          hintText: 'Enter your last name',
        ),
        SizedBox(height: 12.h),
        InputTextField(
          controller: _bio,
          labelText: 'Bio',
          hintText: 'Tell us about yourself',
          maxline: 3,
        ),
        SizedBox(height: 12.h),
      ],
    );
  }

  // Business Information Section
  /*
  Widget _buildBusinessInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Business Details", style: AppFonts.title.copyWith(fontSize: 20.sp,color: AppColor.primary)),
        SizedBox(height: 12.h),
        InputTextField(
          controller: _panNumber,
          labelText: 'PAN Number',
          hintText: 'Enter PAN (optional)',
        ),
        SizedBox(height: 12.h),
        InputTextField(
          controller: _gstNumber,
          labelText: 'GST Number',
          hintText: 'Enter GSTIN (optional)',
        ),
      ],
    );
  }

   */

  // Logout Button
  Widget _buildLogoutButton() {
    return Center(
      child: GestureDetector(
        onTap: () async {
          final refreshToken = await pref.getString(Keys.refreshToken) ?? '';
          if (refreshToken.isNotEmpty) {
            EasyLoading.show();
            logoutBloc.add(ApiDelete(refreshToken));
          } else {
            showNotification(context, message: "No refresh token found!");
          }
        },
        child: Container(
          width: 0.6.sw,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColor.primary,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: AppColor.primary.withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.logout, size: 18.r, color: AppColor.white),
              SizedBox(width: 8.w),
              Text(
                'Logout',
                style: AppFonts.body.copyWith(color: AppColor.white, fontSize: 14.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}