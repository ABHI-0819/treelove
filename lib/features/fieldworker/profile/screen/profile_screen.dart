/*
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

 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:treelove/core/widgets/input_field.dart';
import 'dart:io';

// Assuming these exist in your project

import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../common/repositories/staff_repository.dart';
import '../../../../core/config/themes/app_color.dart';
import '../../../../core/config/themes/app_fonts.dart';
import '../../../../core/network/api_connection.dart';
import '../../../../core/widgets/common_notification.dart';
import '../../../vendor/Staff/bloc/staff_bloc.dart';
import '../../../vendor/Staff/models/staff_response_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';



class ProfileScreen extends StatefulWidget {
  static const String route = '/profile';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late StaffBloc staffBloc;

  // Controllers for editable fields
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Country Code
  String _selectedCountryCode = '+91';
  final List<String> _countryCodes = ['+91', '+1', '+44', '+61', '+971'];

  // Profile Pic
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    staffBloc = StaffBloc(StaffRepository(api: ApiConnection()));
    _loadProfile(); // Load current user profile
  }

  Future<void> _loadProfile() async {
    // TODO: Fetch current staff profile from API/BLoC
    // For now, we'll simulate with mock data
    // final mockProfile = StaffResponseModel(
    //   id: "1",
    //   firstName: "John",
    //   lastName: "Doe",
    //   email: "john.doe@example.com",
    //   phone: "9876543210",
    //   countryCode: "+91",
    //   profilePictureUrl: null,
    // );
    //
    // _populateFields(mockProfile);
  }

  // void _populateFields(StaffResponseModel profile) {
  //   firstNameController.text = profile.firstName ?? "";
  //   lastNameController.text = profile.lastName ?? "";
  //   emailController.text = profile.email ?? "";
  //   phoneController.text = profile.phone ?? "";
  //   _selectedCountryCode = profile.countryCode ?? "+91";
  //   setState(() {});
  // }

  Future<void> _showImageSourceSheet() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text("Take a Photo"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.close, color: Colors.red),
              title: const Text("Cancel"),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedImage = await _picker.pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 70,
    );

    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveProfile() {
    // TODO: Validate and send update request
    showNotification(context, message: "Profile updated successfully");
    setState(() {
      _isEditing = false;
    });
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              showNotification(context, message: "Logged out successfully");
              Future.delayed(const Duration(milliseconds: 800), () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/signIn', // Replace with your SignIn route
                      (route) => false,
                );
              });
            },
            child: const Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    staffBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.white,
      body: BlocProvider.value(
        value: staffBloc,
        child: BlocListener<StaffBloc, ApiState<StaffResponseModel, ResponseModel>>(
          listener: (context, state) {
            // Handle API states if needed
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 👇 Optional Title (Remove if not needed)
                const SizedBox(height: 10),
                Text(
                  'My Profile',
                  style: AppFonts.subtitle.copyWith(fontSize: 24, color: Colors.black87),
                ),
                const SizedBox(height: 30),

                // Profile Picture
                GestureDetector(
                  onTap: _isEditing ? _showImageSourceSheet : null,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : const AssetImage("assets/images/default_avatar.png") as ImageProvider?,
                        child: _profileImage == null
                            ? const Icon(Icons.person, size: 40, color: Colors.white70)
                            : null,
                      ),
                      if (_isEditing)
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey, width: 2),
                          ),
                          child: const Icon(Icons.edit, size: 16, color: Colors.grey),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (!_isEditing)
                  Text(
                    "${firstNameController.text} ${lastNameController.text}".trim(),
                    style: AppFonts.subtitle.copyWith(fontSize: 20),
                  ),
                if (!_isEditing)
                  const SizedBox(height: 4),
                if (!_isEditing)
                  Text(
                    emailController.text,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                const SizedBox(height: 32),

                // ✏️ Edit Mode
                if (_isEditing) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: size.width * 0.42,
                        child: SecondaryInputField(
                          controller: firstNameController,
                          asterisk: "*",
                          labelText: 'First Name',
                          hintText: 'Enter first name',
                          inputType: TextInputType.name,
                          maxline: 1,
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.42,
                        child: SecondaryInputField(
                          controller: lastNameController,
                          asterisk: "*",
                          labelText: 'Last Name',
                          hintText: 'Enter last name',
                          inputType: TextInputType.name,
                          maxline: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SecondaryInputField(
                    controller: emailController,
                    labelText: 'Email',
                    hintText: 'Enter email',
                    inputType: TextInputType.emailAddress,
                    asterisk: "*",
                    maxline: 1,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: 'Code',
                                  style: const TextStyle(color: AppColor.primary)),
                              const TextSpan(
                                  text: "*", style: TextStyle(color: Colors.red, fontSize: 14))
                            ]),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedCountryCode,
                                dropdownColor: AppColor.white,
                                items: _countryCodes.map((code) {
                                  return DropdownMenuItem(
                                    value: code,
                                    child: Text(code),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() => _selectedCountryCode = value!);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SecondaryInputField(
                          controller: phoneController,
                          labelText: 'Phone Number',
                          hintText: 'Enter phone number',
                          asterisk: "*",
                          inputType: TextInputType.phone,
                          maxline: 1,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004D40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      onPressed: _saveProfile,
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ]
                // 👀 View Mode
                else ...[
                  _buildProfileRow(Icons.person, "Name", "${firstNameController.text} ${lastNameController.text}"),
                  _buildProfileRow(Icons.email, "Email", emailController.text),
                  _buildProfileRow(Icons.phone, "Phone", "$_selectedCountryCode ${phoneController.text}"),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0E5D57),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      onPressed: _toggleEditMode,
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: const Text(
                        'Edit Profile',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 🔴 Logout Button
                  GestureDetector(
                    onTap: _logout,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.logout, color: Colors.red, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileRow(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}