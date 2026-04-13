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
import '../../../core/network/api_connection.dart';
import '../../../core/widgets/common_notification.dart';
import '../../../core/widgets/common_refresh_indicator.dart';
import '../../../core/widgets/common_warning_popup.dart';
import '../../authentication/screens/sign_in_screen.dart';
import 'models/staff_response_model.dart';
import 'new_staff_screen.dart';
import 'staff_list_simmer.dart';

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
  late StaffActivateBloc staffActivateBloc;

  @override
  void initState() {
    staffListBloc = StaffListBloc(StaffRepository(api: ApiConnection()));
    staffSuspendBloc = StaffSuspendBloc(StaffRepository(api: ApiConnection()));
    staffActivateBloc = StaffActivateBloc(StaffRepository(api: ApiConnection()));
    staffListBloc.add(ApiListFetch());
    // TODO: implement initState
    super.initState();
  }

  Future<void> _refreshData() async {
    staffListBloc.add(ApiListFetch());
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
        ),
        BlocProvider(
          create: (context) => staffActivateBloc,
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
                if (state is ApiSuccess<ResponseModel, ResponseModel>) {
                  showNotification(context,
                      message: state.data.message.toString());
                  staffListBloc.add(ApiListFetch());
                } else if (state is ApiFailure<ResponseModel, ResponseModel>) {
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
            BlocListener<StaffActivateBloc,
                ApiState<ResponseModel, ResponseModel>>(
              listener: (context, state) {
                EasyLoading.dismiss();
                if (state is ApiSuccess<ResponseModel, ResponseModel>) {
                  showNotification(context,
                      message: state.data.message.toString());
                  staffListBloc.add(ApiListFetch());
                } else if (state is ApiFailure<ResponseModel, ResponseModel>) {
                  showNotification(context,
                      message: state.error.message.toString());
                } else if (state
                    is TokenExpired<ResponseModel, ResponseModel>) {
                  AppRoute.pushReplacement(context, SignInScreen.route,
                      arguments: {});
                }
              },
            )
          ],
          child: BlocBuilder<StaffListBloc,
              ApiState<StaffListResponseModel, ResponseModel>>(
            builder: (context, state) {
              if (state is ApiLoading) {
                return const StaffListShimmer();
              } else if (state
                  is ApiSuccess<StaffListResponseModel, ResponseModel>) {
                StaffListResponseModel staffList = state.data;
                return Column(
                  spacing: 5.h,
                  children: [
                    Text(
                      "↓ Pull down to refresh",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Expanded(
                      child: CommonRefreshIndicator(
                        onRefresh: _refreshData,
                        isLoading: false,
                        child: ListView.builder(
                          itemCount: staffList.data!.length,
                          itemBuilder: (context, index) {
                            return ProfileCard(
                              profileImg: staffList
                                  .data![index].profile!.profilePicture,
                              name: staffList.data![index].profile!.fullName,
                              title: 'staff',
                              isActive: staffList.data![index].isActive,
                              onCall: () => _launchPhone(
                                  phoneNumber: staffList.data![index].phone!),
                              avatarIcon: Icons.call,
                              onSuspended: () {
                                _showSuspendWarningPopup(
                                    context: context,
                                    userId: staffList.data![index].id);
                              },
                              onActivate: () {
                                _showActivateWarningPopup(
                                    context: context,
                                    userId: staffList.data![index].id);
                              },
                            );
                          },
                        ),
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

  void _showActivateWarningPopup(
      {required BuildContext context, required String userId}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CommonWarningPopUp(
          title: 'Activate User',
          content: 'Are you sure you want to activate this user? They will regain access to their account.',
          ok: () {
            staffActivateBloc.add(ApiUpdate<String>(userId));
            AppRoute.pop(context);
            EasyLoading.show();
          },
          okButtonLabel: 'Activate',
          cancel: () {
            AppRoute.pop(context);
          },
          cancelButtonLabel: 'Cancel',
        );
      },
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String profileImg;
  final String name;
  final String title;
  final IconData avatarIcon;
  final bool isActive;
  final VoidCallback onSuspended;
  final VoidCallback onActivate;
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
    required this.onActivate,
    required this.onCall,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h, left: 16.w, right: 16.w),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: isActive ? Border.all(color: Colors.grey.shade100) : Border.all(color: Colors.grey.shade300),
        boxShadow: isActive ? [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ] : [],
      ),
      child: Row(
        children: [
          // Avatar with Active/Inactive dot
          Stack(
            children: [
              CircleAvatar(
                radius: 26.r,
                backgroundColor: Colors.grey[200],
                child: ClipOval(
                  child: Image.network(
                    profileImg,
                    width: 52.r,
                    height: 52.r,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.person, size: 28.r, color: Colors.grey),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.green : Colors.redAccent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),

          // Name, Title and Badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isActive ? Colors.black87 : Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[500],
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.green.shade50 : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                         isActive ? 'ACTIVE' : 'SUSPENDED',
                         style: TextStyle(
                           fontSize: 10,
                           fontWeight: FontWeight.w700,
                           color: isActive ? Colors.green.shade700 : Colors.red.shade700,
                         )
                      )
                    )
                  ],
                ),
              ],
            ),
          ),

          // Action Icons
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8.w,
            children: [
              if (isActive)
                InkWell(
                  onTap: onCall,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.withOpacity(0.1),
                      ),
                      child: const Icon(
                        Icons.phone,
                        size: 20,
                        color: Colors.green,
                      )),
                ),
              InkWell(
                onTap: isActive ? onSuspended : onActivate,
                borderRadius: BorderRadius.circular(24),
                child: Tooltip(
                  message: isActive ? 'Suspend User' : 'Activate User',
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                    ),
                    child: isActive 
                        ? SvgPicture.asset(
                            Images.suspendedIcon,
                            color: Colors.redAccent,
                            width: 20,
                            height: 20,
                          )
                        : const Icon(
                            Icons.settings_backup_restore,
                            color: Colors.green,
                            size: 20,
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
