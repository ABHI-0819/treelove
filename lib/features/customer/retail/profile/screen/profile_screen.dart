/*
{
  "status": "success",
  "message": "Details fetched successfully",
  "data": {
    "id": "f20c83cf-5a73-417b-9407-a650316e5da5",
    "user": "d4b034ae-cb6a-4926-9293-f9c1ec9a2eda",
    "first_name": "Ankit",
    "last_name": "Sharma",
    "profile_picture": "http://43.205.169.130/media/user/profile_pics/man.png",
    "bio": "Make the world green.",
    "date_of_birth": "2000-06-19",
    "legal_name": "",
    "website": "",
    "pan_number": null,
    "gst_number": null,
    "receive_notifications": true,
    "created_by": null,
    "modified_by": "d4b034ae-cb6a-4926-9293-f9c1ec9a2eda",
    "created_at": "2025-07-24T20:49:49.968833+05:30",
    "updated_at": "2025-11-15T17:46:59.872365+05:30"
  }
}
*/

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../../../core/config/themes/app_color.dart';

class RetailProfileScreen extends StatefulWidget {
  static const route = '/retail-profile';

  const RetailProfileScreen({Key? key}) : super(key: key);

  @override
  State<RetailProfileScreen> createState() => _RetailProfileScreenState();
}

class _RetailProfileScreenState extends State<RetailProfileScreen> {
  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _bioController = TextEditingController();
  final _websiteController = TextEditingController();

  // Variables
  String? _profilePicture;
  DateTime? _dateOfBirth;
  File? _newProfileImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() {
    // Load your API data here
    setState(() {
      _firstNameController.text = "Ankit";
      _lastNameController.text = "Sharma";
      _bioController.text = "Make the world green.";
      _websiteController.text = "";
      _profilePicture = "http://43.205.169.130/media/user/profile_pics/man.png";
      _dateOfBirth = DateTime(2000, 6, 19);
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _newProfileImage = File(image.path);
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColor.primary,
              onPrimary: AppColor.white,
              surface: AppColor.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  Future<void> _updateProfile() async {
    setState(() => _isLoading = true);

    // Your PATCH API call here
    // Example:
    // final response = await apiService.updateProfile({
    //   'first_name': _firstNameController.text,
    //   'last_name': _lastNameController.text,
    //   'bio': _bioController.text,
    //   'website': _websiteController.text,
    //   'date_of_birth': _dateOfBirth?.toIso8601String(),
    //   'profile_picture': _newProfileImage,
    // });

    await Future.delayed(const Duration(seconds: 1)); // Simulated delay

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: AppColor.success,
        ),
      );
    }
  }

  Widget _buildHeader() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: AppColor.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.primary.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColor.primary,
                  size: 18,
                ),
              ),
            ),
            const Spacer(),
            Text(
              "My Profile",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColor.primary,
                letterSpacing: -0.5,
              ),
            ),
            const Spacer(),
            const SizedBox(width: 44), // Balance the back button
          ],
        ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      /*
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.primary,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: AppColor.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      
       */
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            // Header Section with Profile Picture
            _buildHeaderSection(),

            const SizedBox(height: 24),

            // Form Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Personal Information'),
                  const SizedBox(height: 16),

                  _buildInputCard(
                    label: 'First Name',
                    controller: _firstNameController,
                    icon: Icons.person_outline,
                  ),

                  const SizedBox(height: 12),

                  _buildInputCard(
                    label: 'Last Name',
                    controller: _lastNameController,
                    icon: Icons.person_outline,
                  ),

                  const SizedBox(height: 12),

                  _buildDateCard(),

                  const SizedBox(height: 24),

                  _buildSectionTitle('About'),
                  const SizedBox(height: 16),

                  _buildInputCard(
                    label: 'Bio',
                    controller: _bioController,
                    icon: Icons.edit_note,
                    maxLines: 3,
                    hint: 'Tell us about yourself...',
                  ),

                  const SizedBox(height: 12),

                  _buildInputCard(
                    label: 'Website',
                    controller: _websiteController,
                    icon: Icons.link,
                    hint: 'www.example.com',
                  ),

                  const SizedBox(height: 32),

                  // Update Button
                  _buildUpdateButton(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        // color: AppColor.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Profile Picture
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColor.white,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColor.grey,
                  backgroundImage: _newProfileImage != null
                      ? FileImage(_newProfileImage!)
                      : (_profilePicture != null
                      ? NetworkImage(_profilePicture!)
                      : null) as ImageProvider?,
                  child: _profilePicture == null && _newProfileImage == null
                      ? const Icon(Icons.person, size: 60, color: AppColor.textMuted)
                      : null,
                ),
              ),

              // Edit Icon
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColor.accent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColor.white,
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: AppColor.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Name
          Text(
            '${_firstNameController.text} ${_lastNameController.text}',
            style: const TextStyle(
              color: AppColor.primary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColor.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildInputCard({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? hint,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColor.primary,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller,
                maxLines: maxLines,
                style: const TextStyle(
                  color: AppColor.textPrimary,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  labelText: label,
                  hintText: hint,
                  labelStyle: const TextStyle(
                    color: AppColor.textSecondary,
                    fontSize: 14,
                  ),
                  hintStyle: const TextStyle(
                    color: AppColor.textMuted,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCard() {
    return GestureDetector(
      onTap: _selectDate,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.cardBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              const Icon(
                Icons.cake_outlined,
                color: AppColor.primary,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Date of Birth',
                      style: TextStyle(
                        color: AppColor.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _dateOfBirth != null
                          ? '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}'
                          : 'Select date',
                      style: const TextStyle(
                        color: AppColor.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.calendar_today,
                color: AppColor.textMuted,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _updateProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
          foregroundColor: AppColor.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBackgroundColor: AppColor.textMuted,
        ),
        child: _isLoading
            ? const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(AppColor.white),
          ),
        )
            : const Text(
          'Update Profile',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _bioController.dispose();
    _websiteController.dispose();
    super.dispose();
  }
}