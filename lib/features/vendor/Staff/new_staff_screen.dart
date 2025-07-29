import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:treelove/common/bloc/api_state.dart';
import 'package:treelove/core/config/themes/app_color.dart';
import 'package:treelove/features/vendor/Staff/bloc/staff_bloc.dart';

import '../../../common/bloc/api_event.dart';
import '../../../common/models/response.mode.dart';
import '../../../common/repositories/staff_repository.dart';
import '../../../core/config/route/app_route.dart';
import '../../../core/config/themes/app_fonts.dart';
import '../../../core/network/api_connection.dart';
import '../../../core/widgets/common_notification.dart';
import '../../../core/widgets/input_field.dart';
import '../../authentication/screens/sign_in_screen.dart';
import 'models/staff_request_model.dart';
import 'models/staff_response_model.dart';

class AddNewStaffScreen extends StatefulWidget {
  static const String route = '/addNewStaff';

  const AddNewStaffScreen({super.key});

  @override
  State<AddNewStaffScreen> createState() => _AddNewStaffScreenState();
}

class _AddNewStaffScreenState extends State<AddNewStaffScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  late StaffBloc staffBloc;

  @override
  void initState() {
    staffBloc = StaffBloc(StaffRepository(api: ApiConnection()));
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  //Country Code
  String _selectedCountryCode = '+91';

  final List<String> _countryCodes = [
    '+91', // India
    '+1', // USA
    '+44', // UK
    '+61', // Australia
    '+971', // UAE
  ];

  // Profile Pic
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  /// ✅ Pick image from Camera or Gallery
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
      imageQuality: 70, // Compress for smaller uploads
    );

    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      //  Validate password match
      if(firstNameController.text.isEmpty){
        showNotification(context, message: "First name is required");
      }else if(lastNameController.text.isEmpty){
        showNotification(context, message: "Last name is required");
      }else if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
        showNotification(context, message: "Passwords do not match");
      }{
        // Create request model
        final staffRequest = AddStaffRequestModel(
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          email: emailController.text.trim().isEmpty ? null : emailController.text.trim(),
          phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
          countryCode: _selectedCountryCode,
          oauthProvider: "email", // or phone/google/facebook depending on your logic
          password: passwordController.text.trim(),
          profilePicture: _profileImage, // File
        );

        // Call BLoC event or repository
        staffBloc.add(ApiAdd(staffRequest));
        EasyLoading.dismiss();
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text('Add New Staff',
            style: AppFonts.regular.copyWith(fontSize: 18)),
        backgroundColor: const Color(0xFF0E5D57),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocProvider(
        create: (context) => staffBloc,
        child: BlocListener<StaffBloc, ApiState<StaffResponseModel, ResponseModel>>(
          listener: (context, state) {
            EasyLoading.dismiss();
            if (state is ApiSuccess<StaffResponseModel, ResponseModel>) {
              showNotification(context, message: state.data.message);
            } else if (state is ApiFailure<StaffResponseModel, ResponseModel>) {
              showNotification(context, message: state.error.message.toString());
            } else if (state is TokenExpired<ResponseModel, ResponseModel>) {
              AppRoute.pushReplacement(context, SignInScreen.route, arguments: {});
            }
            // TODO: implement listener
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  //  Profile Image Picker
                  GestureDetector(
                    onTap: _showImageSourceSheet,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : null,
                      child: _profileImage == null
                          ? const Icon(Icons.camera_alt,
                              size: 40, color: Colors.white70)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Profile Photo",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: size.width * 0.42,
                          child: SecondaryInputField(
                            controller: firstNameController,
                            asterisk: "*",
                            labelText: 'First name',
                            hintText: 'Enter name',
                            inputType: TextInputType.name,
                            maxline: 1,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50)
                            ],
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.42,
                          child: SecondaryInputField(
                            controller: lastNameController,
                            asterisk: "*",
                            labelText: 'Name',
                            hintText: 'Last name',
                            inputType: TextInputType.name,
                            maxline: 1,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50)
                            ],
                          ),
                        ),
                      ]),
                  const SizedBox(height: 16),
                  SecondaryInputField(
                    controller: emailController,
                    labelText: 'Email',
                    hintText: 'Enter email',
                    inputType: TextInputType.emailAddress,
                    asterisk: "*",
                    maxline: 1,
                    inputFormatters: [LengthLimitingTextInputFormatter(50)],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // Country Code Dropdown
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: 'Code',
                                  style:
                                      const TextStyle(color: AppColor.primary)),
                              TextSpan(
                                  text: "*",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 14.sp))
                            ]),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 2.h, horizontal: 8.w),
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

                      // Phone Number Field
                      Expanded(
                        child: SecondaryInputField(
                          controller: phoneController,
                          labelText: 'Phone Number',
                          hintText: 'Enter phone number',
                          asterisk: "*",
                          inputType: TextInputType.phone,
                          maxline: 1,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                    ],
                  ),
                  /*
              SecondaryInputField(
                controller: phoneController,
                labelText: 'Phone Number',
                hintText: 'Enter phone number',
                inputType: TextInputType.number,
                maxline: 1,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),

               */
                  const SizedBox(height: 16),
                  SecondaryInputField(
                    controller: passwordController,
                    labelText: 'Password',
                    hintText: 'Enter password',
                    asterisk: "*",
                    obscuringCharacter: '*',
                    isSecret: true,
                    inputType: TextInputType.visiblePassword,
                    maxline: 1,
                    inputFormatters: [LengthLimitingTextInputFormatter(50)],
                  ),
                  const SizedBox(height: 16),
                  SecondaryInputField(
                    controller: confirmPasswordController,
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter password',
                    asterisk: "*",
                    isSecret: true,
                    inputType: TextInputType.visiblePassword,
                    maxline: 1,
                    inputFormatters: [LengthLimitingTextInputFormatter(50)],
                  ),
                  const SizedBox(height: 30),
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
                      onPressed: _submit,
                      child: const Text('Add Staff',
                          style: TextStyle(color: Colors.white)),
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
