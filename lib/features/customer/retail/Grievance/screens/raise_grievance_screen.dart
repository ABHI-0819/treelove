import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/config/themes/app_color.dart';


class RaiseGrievanceScreen extends StatefulWidget {
  const RaiseGrievanceScreen({Key? key}) : super(key: key);

  @override
  State<RaiseGrievanceScreen> createState() => _RaiseGrievanceScreenState();
}

class _RaiseGrievanceScreenState extends State<RaiseGrievanceScreen> {
  String? selectedIssueType;
  final TextEditingController _problemController = TextEditingController();
  File? _selectedImage;
  String? _selectedLocation;
  final ImagePicker _picker = ImagePicker();

  final List<Map<String, dynamic>> issueTypes = [
    {'label': 'Plantation', 'icon': Icons.yard_outlined},
    {'label': 'Maintenance', 'icon': Icons.build_outlined},
    {'label': 'Tree Health', 'icon': Icons.local_hospital_outlined},
    {'label': 'Other', 'icon': Icons.more_horiz_outlined},
  ];

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColor.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColor.primary),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColor.primary),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _fetchLocation() {
    // Simulate location fetching
    setState(() {
      _selectedLocation = "Mumbai, Maharashtra, IN";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Location fetched successfully'),
        backgroundColor: AppColor.success,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _submitGrievance() {
    if (selectedIssueType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an issue type'),
          backgroundColor: AppColor.error,
        ),
      );
      return;
    }

    if (_problemController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please describe the problem'),
          backgroundColor: AppColor.error,
        ),
      );
      return;
    }

    // Handle submission
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Grievance submitted successfully!'),
        backgroundColor: AppColor.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Raise Grievance',
          style: TextStyle(
            color: AppColor.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            // Header Section
            /*
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.report_problem_outlined,
                    size: 48,
                    color: AppColor.accent,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Help us resolve your issue',
                    style: TextStyle(
                      color: AppColor.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

             */

            // Form Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Issue Type
                  /*
                  const Text(
                    'Issue Type',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColor.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.2,
                    ),
                    itemCount: issueTypes.length,
                    itemBuilder: (context, index) {
                      final issue = issueTypes[index];
                      final isSelected = selectedIssueType == issue['label'];
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedIssueType = issue['label'];
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColor.primary
                                : AppColor.cardBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColor.primary
                                  : AppColor.border,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                issue['icon'],
                                color: isSelected
                                    ? AppColor.white
                                    : AppColor.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                issue['label'],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? AppColor.white
                                      : AppColor.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                   */
                  // Form Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label
                      Text(
                        'Issue Type',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColor.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Chips Grid
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: issueTypes.map((issue) {
                          final isSelected = selectedIssueType == issue['label'];
                          return _IssueTypeChip(
                            label: issue['label'],
                            icon: issue['icon'],
                            isSelected: isSelected,
                            onTap: () {
                              setState(() {
                                selectedIssueType = issue['label'];
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),

                        const SizedBox(height: 24),

                  // Problem Description
                  const Text(
                    'Describe the Problem',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColor.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColor.border),
                    ),
                    child: TextField(
                      controller: _problemController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'e.g., Tree is dry and needs watering.',
                        hintStyle: TextStyle(
                          color: AppColor.textMuted,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                      style: const TextStyle(
                        color: AppColor.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Add Photo
                  const Text(
                    'Add Photo (Optional)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColor.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: _showImageSourceDialog,
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColor.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColor.border,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: _selectedImage != null
                          ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _selectedImage!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedImage = null;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppColor.error,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: AppColor.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 40,
                            color: AppColor.textMuted,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Tap to add photo',
                            style: TextStyle(
                              color: AppColor.textMuted,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Add Location
                  const Text(
                    'Add Location (Optional)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColor.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: _fetchLocation,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColor.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColor.border),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _selectedLocation != null
                                ? Icons.location_on
                                : Icons.location_on_outlined,
                            color: AppColor.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _selectedLocation ?? 'Tap to fetch location',
                              style: TextStyle(
                                color: _selectedLocation != null
                                    ? AppColor.textPrimary
                                    : AppColor.textMuted,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          if (_selectedLocation != null)
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedLocation = null;
                                });
                              },
                              child: const Icon(
                                Icons.close,
                                color: AppColor.textMuted,
                                size: 20,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _submitGrievance,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        foregroundColor: AppColor.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon(Icons.check_circle_outline, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _problemController.dispose();
    super.dispose();
  }
}

class _IssueTypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _IssueTypeChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primary : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColor.primary
                : AppColor.border.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : AppColor.primary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColor.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}