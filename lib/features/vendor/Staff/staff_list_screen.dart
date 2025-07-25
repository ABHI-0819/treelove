import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:treelove/common/bloc/api_state.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/features/vendor/Staff/bloc/staff_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common/bloc/api_event.dart';
import '../../../common/models/response.mode.dart';
import '../../../common/repositories/staff_repository.dart';
import '../../../core/config/resource/images.dart';
import '../../../core/config/themes/app_color.dart';
import '../../../core/config/themes/app_fonts.dart';
import '../../../core/network/api_connection.dart';
import '../../../core/widgets/common_notification.dart';
import '../../../core/widgets/common_warning_popup.dart';
import '../../authentication/screens/sign_in_screen.dart';
import 'models/staff_response_model.dart';
import 'new_staff_screen.dart';

class StaffListScreen extends StatefulWidget {
  const StaffListScreen({super.key});

  @override
  State<StaffListScreen> createState() => _StaffListScreenState();
}

class _StaffListScreenState extends State<StaffListScreen> {
  String selectedRole = 'All';
  String selectedRoleId = '';

  late StaffListBloc staffListBloc;
  late StaffSuspendBloc staffSuspendBloc;

  @override
  void initState() {
    staffListBloc = StaffListBloc(StaffRepository(api: ApiConnection()));
    staffSuspendBloc = StaffSuspendBloc(StaffRepository(api: ApiConnection()));
    staffListBloc.add(ApiListFetch());
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _launchPhone({required String phoneNumber}) async {
    final Uri uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => staffListBloc,
        ),
        BlocProvider(
          create: (context) => staffSuspendBloc,
        )
      ],
      child: Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          backgroundColor: AppColor.white,
          elevation: 0.5,
          automaticallyImplyLeading: false,
          toolbarHeight: 64,
          // Slightly taller for a modern look
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Users',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColor.black,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Add user screen navigation
                  AppRoute.goToNextPage(
                      context: context,
                      screen: AddNewStaffScreen.route,
                      arguments: {});
                },
                icon: const Icon(
                  Icons.add,
                  size: 18,
                  color: AppColor.white,
                ),
                label: const Text('Add User'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppColor.primary,
                  textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        inherit: true, // important
                      ),
                ),
              ),
            ],
          ),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<StaffListBloc,
                ApiState<StaffListResponseModel, ResponseModel>>(
              listener: (context, state) {
                if (state
                    is ApiFailure<StaffListResponseModel, ResponseModel>) {
                  showNotification(context,
                      message: state.error.message.toString());
                } else if (state
                    is TokenExpired<ResponseModel, ResponseModel>) {
                  AppRoute.pushReplacement(context, SignInScreen.route,
                      arguments: {});
                }
                // TODO: implement listener
              },
            ),

            BlocListener<StaffSuspendBloc,
                ApiState<ResponseModel, ResponseModel>>(
              listener: (context, state) {
                EasyLoading.dismiss();
                 if(state is ApiSuccess<ResponseModel,ResponseModel>){
                  showNotification(context,
                      message: state.data.message.toString());
                  staffListBloc.add(ApiListFetch());
                }
                else if (state is ApiFailure<ResponseModel, ResponseModel>) {
                  showNotification(context,
                      message: state.error.message.toString());
                } else if (state
                is TokenExpired<ResponseModel, ResponseModel>) {
                  AppRoute.pushReplacement(context, SignInScreen.route,
                      arguments: {});
                }
                // TODO: implement listener
              },
            )

          ],
          child: BlocBuilder<StaffListBloc,
              ApiState<StaffListResponseModel, ResponseModel>>(
            builder: (context, state) {
              if (state is ApiSuccess<StaffListResponseModel, ResponseModel>) {
                StaffListResponseModel staffList = state.data;
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: staffList.data!.length,
                        itemBuilder: (context, index) {
                          return ProfileCard(
                            profileImg:
                                staffList.data![index].profile!.profilePicture,
                            name: staffList.data![index].profile!.fullName,
                            title: 'staff',
                            isActive:staffList.data![index].isActive ,
                            onCall: () => _launchPhone(
                                phoneNumber: staffList.data![index].phone!),
                            avatarIcon: Icons.call,
                            onSuspended: () {
                              _showSuspendWarningPopup(
                                  context: context,
                                  userId: staffList.data![index].id);
                            },
                          );
                        },
                      ),
                    )
                  ],
                );
              } else {
                return const Center(
                  child: Text(
                    "No staff found",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void _showSuspendWarningPopup(
      {required BuildContext context, required String userId}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CommonWarningPopUp(
          title: 'Warning'.trim(),
          content:
              'Once suspended, the user will no longer be able to access their account. This action is irreversible.',
          ok: () {
            staffSuspendBloc.add(ApiDelete(userId));
            AppRoute.pop(context);
            EasyLoading.show();
          },
          okButtonLabel: 'Suspend',
          cancel: () {
            AppRoute.pop(context);
          },
          cancelButtonLabel: 'Cancel',
        );
      },
    );
  }
}

/*
class UserCard extends StatelessWidget {
  final String name;
  final String role;
  final Color roleColor;
  final String userId;
  final String imageUrl;
  final VoidCallback onSuspended;
  final bool isActive;

  const UserCard({
    super.key,
    required this.name,
    required this.role,
    required this.roleColor,
    required this.userId,
    required this.imageUrl,
    required this.onSuspended,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          // Profile Picture
          CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
            radius: 26.r,
            backgroundColor: Colors.grey.shade100,
            onBackgroundImageError: (_, __) {},
          ),

          SizedBox(width: 12.w),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppFonts.regular.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'ID: $userId',
                  style: AppFonts.small.copyWith(color: AppColor.textMuted),
                ),
                SizedBox(height: 6.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: roleColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    role,
                    style: TextStyle(
                      color: roleColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Suspend Icon
          InkWell(
            onTap: isActive ? onSuspended : null,
            borderRadius: BorderRadius.circular(24),
            child: Tooltip(
              message: isActive ? 'Suspend User' : 'User is suspended',
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? Colors.red.shade50 : Colors.grey.shade200,
                ),
                child: SvgPicture.asset(
                  Images.suspendedIcon,
                  color: isActive ? Colors.redAccent : Colors.grey,
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

 */

class ProfileCard extends StatelessWidget {
  final String profileImg;
  final String name;
  final String title;
  final IconData avatarIcon;
  final bool isActive;
  final VoidCallback onSuspended;
  final void Function() onCall;

  const ProfileCard({
    Key? key,
    this.profileImg =
        'https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D',
    required this.name,
    required this.title,
    this.avatarIcon = Icons.emoji_people,
    this.isActive = true,
    required this.onSuspended,
    required this.onCall,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h, left: 10.w, right: 10.w),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 24.r,
            backgroundColor: Colors.grey[300],
            child: Image.network(
              profileImg,
              width: 32.r,
              // radius * 2
              height: 32.r,
              fit: BoxFit.contain,
              // or BoxFit.contain if you want full image inside
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.person, size: 24.r, color: Colors.grey),
            ),
          ),
          /*
          UserAvatar(
            imageUrl:profileImg,
            radius: 24.r,
            backgroundColor: Colors.grey[300],
          ),

           */
          SizedBox(width: 16),

          // Name and Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Icons
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8.w,
            children: [
              InkWell(
                onTap: onCall,
                borderRadius: BorderRadius.circular(24),
                child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                    ),
                    child: Icon(
                      Icons.phone,
                      color: Colors.green,
                    )),
              ),
              InkWell(
                onTap: isActive ? onSuspended : null,
                borderRadius: BorderRadius.circular(24),
                child: Tooltip(
                  message: isActive ? 'Suspend User' : 'User is suspended',
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          isActive ? Colors.red.shade50 : Colors.grey.shade200,
                    ),
                    child: SvgPicture.asset(
                      Images.suspendedIcon,
                      color: isActive ? Colors.redAccent : Colors.grey,
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final Color? backgroundColor;
  final Widget? errorWidget;
  final Widget? placeholderWidget;

  const UserAvatar({
    super.key,
    required this.imageUrl,
    this.radius = 24, // Default radius
    this.backgroundColor,
    this.errorWidget,
    this.placeholderWidget,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius.r,
      // Use .r if you're using flutter_screenutil
      backgroundColor: backgroundColor ?? Colors.grey[300],
      // Default background
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) =>
            placeholderWidget ??
            // Default placeholder: A simple circular progress indicator
            Center(
              child: SizedBox(
                width: radius / 2, // Adjust size relative to avatar radius
                height: radius / 2,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.grey[400],
                ),
              ),
            ),
        errorWidget: (context, url, error) =>
            errorWidget ??
            // Default error widget: A person icon or an empty circle
            Icon(
              Icons.person,
              size: radius, // Icon size scales with avatar radius
              color: Colors.grey[600],
            ),
        fadeInDuration: const Duration(milliseconds: 300),
        // Optional fade-in effect
        fit: BoxFit.cover, // Ensure the image covers the circle
      ),
    );
  }
}
