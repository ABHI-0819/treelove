import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../common/bloc/api_event.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/bloc/profile_bloc.dart';
import '../../../../common/models/profile_response_model.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../common/models/update_profile_request_model.dart';
import '../../../../common/repositories/login_repository.dart';
import '../../../../common/repositories/profile_repository.dart';
import '../../../../core/config/route/app_route.dart';
import '../../../../core/config/themes/app_color.dart';
import '../../../../core/config/themes/app_fonts.dart';
import '../../../../core/network/api_connection.dart';
import '../../../../core/storage/preference_keys.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/widgets/common_notification.dart';
import '../../../authentication/bloc/auth_bloc.dart';
import '../../../authentication/screens/sign_in_screen.dart';
import '../../../vendor/profile/screens/profile_shimmer.dart';
import 'package:intl/intl.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final pref = SecurePreference();
  bool notificationEnabled = true;

  File? _newProfileImage;
  final ImagePicker _picker = ImagePicker();

  late ProfileBloc profileBloc;
  late LogoutBloc logoutBloc;

  @override
  void initState() {
    profileBloc = ProfileBloc(ProfileRepository(api: ApiConnection()));
    logoutBloc = LogoutBloc(LoginRepository(api: ApiConnection()));
    profileBloc.add(ApiFetch());
    super.initState();
  }

  @override
  void dispose() {
    profileBloc.close();
    logoutBloc.close();
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> _pickImage(ProfileData profile) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _newProfileImage = File(pickedFile.path);
      });

      // Send image via your UpdateProfileRequest
      profileBloc.add(
        ApiUpdate(
          UpdateProfileRequest(
            media: [_newProfileImage!], // Use your media list
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => profileBloc,
          ),
          BlocProvider(
            create: (context) => logoutBloc,
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            ///  Logout Listener
            BlocListener<LogoutBloc, ApiState<ResponseModel, ResponseModel>>(
              listener: (context, state) {
                if (state is ApiSuccess) {
                  EasyLoading.dismiss();
                  AppRoute.reset(context, SignInScreen.route);
                } else if (state is ApiFailure) {
                  EasyLoading.dismiss();
                  showNotification(context, message: "Logout failed");
                }
              },
            ),

            ///  Profile Update Listener
            BlocListener<ProfileBloc,
                ApiState<ProfileResponseModel, ResponseModel>>(
              listener: (context, state) async {
                if (state is ApiSuccess<ProfileResponseModel, ResponseModel>) {
                  final profile = state.data.data!;
                  await pref.setString(Keys.firstName, profile.firstName);
                  await pref.setString(Keys.lastName, profile.lastName);
                  await pref.setString(Keys.name, profile.fullName);
                }
                if (state is ApiFailure<ProfileResponseModel, ResponseModel>) {
                  showNotification(context,
                      message: state.error.data ??
                          state.error.message ??
                          "Failed to update profile");
                }
              },
            ),
          ],
          child: SafeArea(
            child: BlocBuilder<ProfileBloc,
                ApiState<ProfileResponseModel, ResponseModel>>(
              builder: (context, state) {
                if (state is ApiLoading) {
                  return const ProfileShimmer();
                }

                if (state is ApiSuccess<ProfileResponseModel, ResponseModel>) {
                  final ProfileData profile = state.data.data!;
                  notificationEnabled = profile.receiveNotifications;
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildHeader(context, profile),
                      const SizedBox(height: 24),

                      /// PERSONAL
                      _buildSectionCard(
                        title: "Personal Information",
                        children: [
                          _profileTile(
                            context,
                            "First Name",
                            profile.firstName,
                            "first_name",
                          ),
                          _divider(),
                          _profileTile(
                            context,
                            "Last Name",
                            profile.lastName,
                            "last_name",
                          ),
                          _divider(),
                          _profileTile(
                            context,
                            "Bio",
                            profile.bio,
                            "bio",
                          ),
                          _divider(),
                          _profileTile(
                            context,
                            "Date of Birth",
                            profile.formattedDateOfBirth,
                            "date_of_birth",
                            isDate: true,
                          ),
                          _divider(),
                          // Phone Tile
                          // Phone Tile
                          FutureBuilder<String?>(
                            future: _getContact(Keys.phone, Keys.email),
                            builder: (context, snapshot) {
                              final value = snapshot.data ?? "Not set";
                              return _profileTile(
                                context,
                                "Phone",
                                value,
                                "phone",
                                isEditable: false, // allow editing if needed
                              );
                            },
                          ),
                          _divider(),
// Email Tile
                          FutureBuilder<String?>(
                            future: _getContact(Keys.email, Keys.phone),
                            builder: (context, snapshot) {
                              final value = snapshot.data ?? "Not set";
                              return _profileTile(
                                context,
                                "Email",
                                value,
                                "email",
                                isEditable: false, // not editable if you want
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      _actionTile(
                        icon: Icons.notifications,
                        color: AppColor.primary,
                        title: "Notifications",
                        switchValue: notificationEnabled,
                        onToggle: (value) {
                          profileBloc.add(
                            ApiUpdate(
                              UpdateProfileRequest(
                                receiveNotifications: value,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      /// LOGOUT
                      // _logoutTile(context),
                      _actionTile(
                        icon: Icons.logout,
                        color: AppColor.error,
                        title: 'Logout',
                        onTap: () {
                          _showLogoutDialog(context);
                        },
                      ),
                    ],
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }

  void _pickDate(
      BuildContext context, String field, String currentValue) async {
    // Parse current value safely
    DateTime initialDate = DateTime.now();
    if (currentValue.isNotEmpty) {
      try {
        // Try parsing "19 Feb 2025" format if already displayed
        final parts = currentValue.split(' ');
        if (parts.length == 3) {
          final day = int.parse(parts[0]);
          final month = _monthIndex(parts[1]);
          final year = int.parse(parts[2]);
          initialDate = DateTime(year, month, day);
        } else {
          // fallback to ISO parse
          initialDate = DateTime.tryParse(currentValue) ?? DateTime.now();
        }
      } catch (_) {}
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(const Duration(days: 1)),
    );

    if (picked != null) {
      // UI display format: 19 Feb 2025
      final formatted =
          "${picked.day} ${_monthName(picked.month)} ${picked.year}";

      // Backend format: yyyyMMdd
      final backendDate = DateFormat('yyyy-MM-dd').format(picked);
      // Update via Bloc
      profileBloc.add(
        ApiUpdate(
          UpdateProfileRequest(
            dateOfBirth: backendDate,
          ),
        ),
      );

      // Update UI immediately
      setState(() {});
    }
  }

  /// Helper to get month short name for UI
  String _monthName(int month) {
    const months = [
      '', // placeholder for 0 index
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }

  /// Helper to convert month short name to index
  int _monthIndex(String shortName) {
    const months = [
      '', // placeholder
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months.indexOf(shortName);
  }

  Widget _buildHeader(BuildContext context, ProfileData profile) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColor.secondaryLight,
              backgroundImage: _newProfileImage != null
                  ? FileImage(_newProfileImage!)
                  : (profile.profilePicture != null
                      ? NetworkImage(profile.profilePicture!)
                      : null) as ImageProvider?,
              child: (profile.profilePicture == null &&
                      _newProfileImage == null)
                  ? const Icon(Icons.person, size: 45, color: AppColor.white)
                  : null,
            ),
            GestureDetector(
              onTap: () => _pickImage(profile),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColor.white, width: 2),
                ),
                child: const Icon(Icons.camera_alt,
                    color: AppColor.white, size: 20),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          profile.fullName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColor.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "~ Field Worker ~",
          style: TextStyle(
            color: AppColor.primary,
            fontSize: 12,
          ),
        )
      ],
    );
  }

  // Helper function to get phone/email
  Future<String?> _getContact(String primaryKey, String fallbackKey) async {
    final primary = await pref.getString(primaryKey);
    final fallback = await pref.getString(fallbackKey);
    return (primary != null && primary.isNotEmpty) ? primary : fallback;
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColor.primary,
              )),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _divider() {
    return const Divider(
      color: AppColor.divider,
      height: 1,
    );
  }

  Widget _profileTile(
    BuildContext context,
    String title,
    String value,
    String field, {
    bool isEditable = true,
    bool isDate = false,
  }) {
    return InkWell(
      onTap: isEditable
          ? () {
              if (isDate) {
                _pickDate(context, field, value);
              } else {
                _openEditSheet(context, title, field, value);
              }
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isEditable ? AppColor.textPrimary : AppColor.textMuted,
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 150,
                  child: Text(
                    value.isEmpty ? "Not set" : value,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColor.textMuted,
                    ),
                  ),
                ),
                if (isEditable) ...[
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: AppColor.textMuted,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openEditSheet(
      BuildContext context, String title, String field, String currentValue) {
    final controller = TextEditingController(text: currentValue);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: const BoxDecoration(
              color: AppColor.cardBackground,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drag Handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColor.divider,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Title
                    Text(
                      "Edit $title",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColor.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Subtitle
                    Text(
                      "Update your $title information below.",
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColor.textMuted,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Input Field
                    TextField(
                      controller: controller,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: "Enter $title",
                        filled: true,
                        fillColor: AppColor.grey,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColor.border,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColor.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColor.primary),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Buttons Row
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColor.border),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                color: AppColor.textSecondary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              final value = controller.text.trim();

                              profileBloc.add(
                                ApiUpdate(
                                  UpdateProfileRequest(
                                    firstName:
                                        field == "first_name" ? value : null,
                                    lastName:
                                        field == "last_name" ? value : null,
                                    bio: field == "bio" ? value : null,
                                    legalName:
                                        field == "legal_name" ? value : null,
                                    website: field == "website" ? value : null,
                                    panNumber:
                                        field == "pan_number" ? value : null,
                                    gstNumber:
                                        field == "gst_number" ? value : null,
                                  ),
                                ),
                              );

                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Save Changes",
                              style: TextStyle(color: AppColor.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Log out',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColor.textPrimary,
              fontSize: 20,
            ),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(
              color: AppColor.textSecondary,
              fontSize: 15,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppColor.textMuted,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                final refreshToken =
                    await pref.getString(Keys.refreshToken) ?? '';
                if (refreshToken.isNotEmpty) {
                  EasyLoading.show(
                    status: "Logging out...",
                    // maskType: EasyLoadingMaskType.,
                  );
                  logoutBloc.add(ApiDelete(refreshToken));
                } else {
                  showNotification(context, message: "No refresh token found!");
                }
              },
              child: const Text(
                'Log out',
                style: TextStyle(
                  color: AppColor.error,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _actionTile({
    required IconData icon,
    required Color color,
    required String title,
    VoidCallback? onTap,
    bool? switchValue,
    ValueChanged<bool>? onToggle,
  }) {
    final bool isToggle = switchValue != null;

    return Container(
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        title: Text(
          title,
          style: AppFonts.subtitle.copyWith(
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),

        /// 👇 Toggle OR Arrow
        trailing: isToggle
            ? Switch(
                value: switchValue!,
                activeColor: color,
                onChanged: onToggle,
              )
            : Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: color.withOpacity(0.7),
              ),

        /// Disable tap for toggle tiles
        onTap: isToggle ? null : onTap,
      ),
    );
  }
}
