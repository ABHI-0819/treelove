import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:treelove/features/authentication/screens/sign_in_screen.dart';

import '../../../../../common/bloc/api_event.dart';
import '../../../../../common/bloc/api_state.dart';
import '../../../../../common/models/response.mode.dart';
import '../../../../../common/repositories/grievance_repository.dart';
import '../../../../../core/config/route/app_route.dart';
import '../../../../../core/config/themes/app_color.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/network/api_connection.dart';
import '../bloc/grievance_bloc.dart';
import '../model/grievance_category_list_response.dart' as gc;
import '../model/grievance_request.dart';
import '../model/grievance_response.dart';

// Your app imports
class RaiseGrievanceScreen extends StatefulWidget {
  static const route ="/raise-grievance";
  const RaiseGrievanceScreen({super.key});

  @override
  State<RaiseGrievanceScreen> createState() => _RaiseGrievanceScreenState();
}

class _RaiseGrievanceScreenState extends State<RaiseGrievanceScreen> {
  final TextEditingController _problemController = TextEditingController();
  File? _selectedImage;
  String? _selectedLocation;
  gc.GrievanceCategory? _selectedCategory;
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  late GrievanceBloc grievanceBloc;
  late GrievanceCategoryBloc grievanceCategoryBloc;
  
  @override
  void initState() {
    super.initState();
    grievanceBloc = GrievanceBloc(GrievanceRepository(api: ApiConnection()));
    grievanceCategoryBloc = GrievanceCategoryBloc(GrievanceRepository(api: ApiConnection()));
    // Trigger data fetch when screen loads
    grievanceCategoryBloc.add(ApiListFetch());
    // .add(ApiListFetch());
  }

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

  void _submitGrievance() async {
    if (_selectedCategory == null) {
      _showError('Please select an issue type');
      return;
    }

    final description = _problemController.text.trim();
    if (description.isEmpty) {
      _showError('Please describe the problem');
      return;
    }

    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    final request = GrievanceRequestModel(
      relatedObject: null,
      category: _selectedCategory!.id,
      description: description,
      image: _selectedImage != null ? File(_selectedImage!.path) : null,
      location: _selectedLocation,
    );

   grievanceBloc.add(ApiAdd(request));
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColor.error,
        duration: const Duration(seconds: 3),
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
          'Raise grievance',
          style: TextStyle(
            color: AppColor.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: MultiBlocProvider(
  providers: [
    BlocProvider(
  create: (context) => grievanceBloc,
),
    BlocProvider(
      create: (context) => grievanceCategoryBloc,
    ),
  ],
  child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Issue Type - Searchable Dropdown
            BlocBuilder<GrievanceCategoryBloc,
                ApiState<gc.GrievanceCategoryListResponse, ResponseModel>>(
              builder: (context, state) {
                if (state is ApiLoading) {
                  return _buildDropdownField(
                    label: 'Issue Type',
                    child: const LinearProgressIndicator(),
                  );
                }

                if (state is ApiSuccess<gc.GrievanceCategoryListResponse, ResponseModel>) {
                  final categories = state.data.data
                      .where((c) => c.isActive)
                      .toList();

                  return _buildDropdownField(
                    label: 'Issue Type',
                    child: CustomDropdown<gc.GrievanceCategory>(
                      items: categories,
                      // This builds the dropdown field when collapsed
                      headerBuilder: (context, selectedItem, isOpen) {
                        return Text(
                          selectedItem.name ?? "Select Category", // Display the category name
                          style: TextStyle(fontSize: 16),
                        );
                      },
                      // This builds each item in the dropdown list
                      listItemBuilder: (context, item, isSelected, onTap) {
                        return Text(item.name,style: TextStyle(fontSize: 16));
                      },
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                  );
                }

                return _buildDropdownField(
                  label: 'Issue Type',
                  child: TextButton.icon(
                    onPressed: () {
                      context.read<GrievanceCategoryBloc>().add(ApiListFetch());
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Problem Description
            _buildTextField(
              label: 'Describe the Problem',
              controller: _problemController,
              maxLines: 4,
              hintText: 'e.g., Tree is dry and needs watering.',
            ),

            const SizedBox(height: 24),

            // Add Photo
            _buildPhotoSection(),

            const SizedBox(height: 24),

            // Add Location
            _buildLocationSection(),

            const SizedBox(height: 32),

            // Submit Button
            BlocListener<GrievanceBloc,
                ApiState<GrievanceResponse, ResponseModel>>(
              listener: (context, state) {
                setState(() => _isSubmitting = false);

                if (state is ApiSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Grievance submitted successfully!'),
                      backgroundColor: AppColor.success,
                    ),
                  );
                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.pop(context);
                  });
                } else if (state is ApiFailure<GrievanceResponse, ResponseModel>) {
                  _showError(state.error.message ?? 'Submission failed');
                } else if (state is TokenExpired) {
                  AppRoute.pushReplacement(context, SignInScreen.route, arguments: {});
                }
              },
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitGrievance,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: AppColor.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
),
    );
  }

  Widget _buildDropdownField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColor.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: AppColor.textMuted,
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
            style: const TextStyle(
              color: AppColor.textPrimary,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }

  @override
  void dispose() {
    _problemController.dispose();
    super.dispose();
  }
}