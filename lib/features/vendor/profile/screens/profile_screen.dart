import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:treelove/core/utils/logger.dart';
import 'package:treelove/features/authentication/bloc/auth_bloc.dart';

import '../../../../common/bloc/api_event.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../common/repositories/login_repository.dart';
import '../../../../core/config/resource/images.dart';
import '../../../../core/config/route/app_route.dart';
import '../../../../core/config/themes/app_color.dart';
import '../../../../core/config/themes/app_fonts.dart';
import '../../../../core/network/api_connection.dart';
import '../../../../core/storage/preference_keys.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/widgets/common_notification.dart';
import '../../../../core/widgets/input_field.dart';
import '../../../authentication/models/login.response.model.dart';
import '../../../authentication/screens/sign_in_screen.dart';
class ProfileScreen extends StatefulWidget {
  static const route = '/Vendor-Profile';
  const  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final pref = SecurePreference();
  late LogoutBloc logoutBloc;

  @override
  void initState() {
    logoutBloc = LogoutBloc(LoginRepository(api: ApiConnection()));
    _name.text ="Jayesh Shah";
    _email.text ="jshah123@gmail.com";
    _phone.text = "+91 9768661441";
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => logoutBloc,
  child: Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
          child:MultiBlocListener(
            listeners: [
              /// ✅ Listener for ProfileBloc
              /*
              BlocListener<ProfileBloc, ApiState<ProfileResponseModel, ResponseModel>>(
                listener: (context, state) {
                  if (state is ApiLoading) {
                    showLoadingDialog(context);
                  } else if (state is ApiSuccess<ProfileResponseModel, ResponseModel>) {
                    Navigator.pop(context);
                    // Update profile UI or show success message
                  } else if (state is ApiFailure<ProfileResponseModel, ResponseModel>) {
                    Navigator.pop(context);
                    showNotification(context, message: state.error.message ?? "Profile fetch failed");
                  }
                },
              ),

               */

              /// ✅ Listener for AuthBloc (Logout)
              BlocListener<LogoutBloc, ApiState<ResponseModel, ResponseModel>>(
                listener: (context, state) {
                  debugLog(state.toString(),name: "State");
                  EasyLoading.dismiss();
                 if (state is ApiSuccess<ResponseModel, ResponseModel>) {
                    /// Clear navigation stack & go to login
                    AppRoute.pushReplacement(context, SignInScreen.route, arguments: {});
                  } else if (state is ApiFailure<ResponseModel, ResponseModel>) {
                    Navigator.pop(context);
                    showNotification(context, message:"Logout failed");
                  }
                },
              ),
            ],
            child: mainBody(), // ✅ Your actual UI
          )
      ),
    ),
);
  }

  /// App Bar
  Widget appBar(){
    return AppBar(
      // backgroundColor: AppColor.white,
      elevation: 0,
      automaticallyImplyLeading: false, // To avoid default back button
      flexibleSpace:  Container(
          decoration: BoxDecoration(
              color: AppColor.black,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25.r),bottomRight: Radius.circular(25.r))
          ),
          child: SafeArea(
            child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 10.h),
                child: Row(

                )
            ),
          )
      ),
    );
  }

  Widget mainBody(){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildProfileHeader(),
          const SizedBox(height: 32.0),
          InputTextField(
            controller: _name,
            labelText: 'Full Name',
            hintText: 'Enter your name here',
          ),
          SizedBox(height: 15.h,),
          InputTextField(
            controller: _email,
            labelText: 'Email ID',
            hintText: 'Enter your email here',
          ),
          SizedBox(height: 15.h,),
          InputTextField(
            controller: _phone,
            labelText: 'Contact No',
            hintText: 'Enter your phone here',
          ),
          SizedBox(height: 15.h,),
          Spacer(),// Increased spacing// Increased spacing before button
          Center(
              child:  GestureDetector(
                onTap: ()async{
                  final refreshToken = await pref.getString(Keys.refreshToken) ?? '';
                  if (refreshToken.isNotEmpty) {
                    EasyLoading.show();
                    logoutBloc.add(ApiDelete(refreshToken));
                  } else {
                    showNotification(context, message: "No refresh token found!");
                  }
                },
                child: Container(
                  width: 0.50.sw,
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: AppColor.primary,
                  ),
                  child: Row(
                    spacing: 6.w,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.logout,color: AppColor.white,),
                      Text(
                        'Logout',
                        style: AppFonts.body.copyWith(color: AppColor.white),
                      ),
                    ],
                  ),
                ),
              )
          ),
          SizedBox(height: 15.h,),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: <Widget>[
        Stack(
          children: <Widget>[
            const CircleAvatar(
              radius: 50.0,
              backgroundImage: NetworkImage(
                  'https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'), // Replace
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4.0),
                decoration: const BoxDecoration(
                  color: Color(0xFF616161), // Darker grey for camera icon bg
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 16.0,
                  color: Colors.white, // White camera icon
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Jayesh Shah',style: AppFonts.headline.copyWith(color: AppColor.black),),
            const SizedBox(height: 6.0), //increased
            Text('~ Vendor',style: AppFonts.caption.copyWith(color: Colors.black),),

          ],
        ),
      ],
    );
  }
}