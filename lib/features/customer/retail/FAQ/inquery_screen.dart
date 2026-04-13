import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/core/utils/logger.dart';
import 'package:treelove/features/customer/retail/home/screens/main_screen.dart';
import '../../../../common/bloc/api_event.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../common/repositories/inquiries_repository.dart';
import '../../../../core/config/constants/enum/inquiry_type_enum.dart';
import '../../../../core/config/themes/app_color.dart';
import '../../../../core/network/api_connection.dart';
import '../maintenance/bloc/inquiry_bloc.dart';
import '../maintenance/models/inquiry_request_model.dart';

class InquiryScreen extends StatefulWidget {
  static const route = '/inquiry';
  const InquiryScreen({super.key});

  @override
  State<InquiryScreen> createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _queryController = TextEditingController();

  // Focus nodes
  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _queryFocus = FocusNode();

  late InquiryBloc inquiryBloc;

  @override
  void initState() {
    inquiryBloc = InquiryBloc(InquiriesRepository(api: ApiConnection()));
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _queryController.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    _queryFocus.dispose();
    super.dispose();
  }

  void _submitInquiry() {
    if (_formKey.currentState!.validate()) {
      final inquiry = InquiryRequestModel.withoutLocation(
        inquiryType: InquiryType.mixed, // 🔑 Required & fixed for this screen
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        description: _queryController.text.trim(), // Using query as "address/message"
        // locationPin: '',      // add if collected
        // treeIds: [],          // add if needed
      );

      inquiryBloc.add(ApiAdd(inquiry));
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColor.secondary,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Inquiry Submitted!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColor.primary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "We'll get back to you within 24 hours.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColor.textSecondary),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // dismiss dialog
                  // ✅ Clear form & refocus
                  _formKey.currentState?.reset();
                  _nameController.clear();
                  _phoneController.clear();
                  _emailController.clear();
                  _queryController.clear();
                  FocusScope.of(context).requestFocus(_nameFocus);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.secondary,
                  foregroundColor: AppColor.cardBackground,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Done",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: BlocProvider(
        create: (context) =>inquiryBloc,
        child: BlocListener<InquiryBloc, ApiState<dynamic, ResponseModel>>(
          listener: (context, state) {
            debugLog(state.toString());
            if (state is ApiSuccess<dynamic, ResponseModel>) {
              _showSuccessDialog();
            } else if (state is ApiFailure<dynamic, ResponseModel>) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.error.message ?? 'Failed to submit inquiry.',
                  ),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 4),
                ),
              );
            }
          },
          child: BlocBuilder<InquiryBloc, ApiState<dynamic, ResponseModel>>(
            builder: (context, state) {
              final isLoading = state is ApiLoading;
              return SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 40),
                        _buildHeroSection(),
                        const SizedBox(height: 40),
                        _buildFormFields(),
                        const SizedBox(height: 40),
                        _buildSubmitButton(isLoading),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Header
  Widget _buildHeader() {
    return Center(
      child: Text(
        "Get in Touch",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColor.primary,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  // Hero section
  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColor.primary, AppColor.primaryDark],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: AppColor.cardBackground.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.chat_bubble_outline_rounded,
              size: 40,
              color: AppColor.cardBackground.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "How can we help you?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColor.cardBackground,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Share your questions or feedback with us. We're here to assist you every step of the way.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColor.cardBackground.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  // FORM FIELDS
  Widget _buildFormFields() {
    return Column(
      children: [
        _buildTextField(
          controller: _nameController,
          focusNode: _nameFocus,
          nextFocus: _phoneFocus,
          label: "Full Name",
          hint: "Enter your full name",
          maxLength: 50,
          icon: Icons.person_outline_rounded,
          validator: (value) {
            final v = value?.trim() ?? "";
            if (v.isEmpty) return "Please enter your full name";
            if (v.length < 3) return "Name must be at least 3 characters";
            if (!RegExp(r"^[A-Za-z ]+$").hasMatch(v)) {
              return "Name can contain letters and spaces only";
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        _buildTextField(
          controller: _phoneController,
          focusNode: _phoneFocus,
          nextFocus: _emailFocus,
          label: "Phone Number",
          hint: "98765 43210",
          maxLength: 10,
          keyboardType: TextInputType.phone,
          icon: Icons.phone_outlined,
          validator: (value) {
            final v = value?.trim() ?? "";
            if (v.isEmpty) return "Please enter your phone number";
            if (!RegExp(r"^[0-9]{10}$").hasMatch(v)) {
              return "Enter a valid phone number (10 digits)";
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        _buildTextField(
          controller: _emailController,
          focusNode: _emailFocus,
          nextFocus: _queryFocus,
          label: "Email Address",
          hint: "your.email@example.com",
          maxLength: 100,
          keyboardType: TextInputType.emailAddress,
          icon: Icons.email_outlined,
          validator: (value) {
            final v = value?.trim() ?? "";
            if (v.isEmpty) return "Please enter your email address";
            if (v.length > 100) return "Email cannot exceed 100 characters";
            if (!RegExp(
              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
            ).hasMatch(v)) {
              return "Enter a valid email address";
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        _buildTextField(
          controller: _queryController,
          focusNode: _queryFocus,
          label: "Your Query",
          hint: "Tell us what's on your mind...",
          maxLength: 500,
          maxLines: 5,
          icon: Icons.message_outlined,
          textInputAction: TextInputAction.done,
          validator: (value) {
            final v = value?.trim() ?? "";
            if (v.isEmpty) return "Please enter your query";
            if (v.length < 10) {
              return "Please provide more details (min 10 characters)";
            }
            return null;
          },
        ),
      ],
    );
  }

  // Reusable TextField Widget
  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocus,
    required String label,
    required String hint,
    required IconData icon,
    int maxLength = 100,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColor.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 16, color: AppColor.secondary),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColor.primary,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: TextFormField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              maxLines: maxLines,
              validator: validator,
              maxLength: maxLength,
              inputFormatters: [
                LengthLimitingTextInputFormatter(maxLength),
              ],
              buildCounter: (_, {required currentLength, maxLength, required isFocused}) => null,
              style: const TextStyle(
                fontSize: 16,
                color: AppColor.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  color: AppColor.textSecondary,
                  fontSize: 16,
                ),
                border: InputBorder.none,
              ),
              onFieldSubmitted: (_) {
                if (nextFocus != null) {
                  FocusScope.of(context).requestFocus(nextFocus);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(bool isLoading) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isLoading
              ? [AppColor.secondary, AppColor.secondaryLight]
              : [AppColor.secondary, AppColor.secondaryDark],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.secondary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : _submitInquiry,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColor.cardBackground,
                ),
              ),
            ),
            SizedBox(width: 12),
            Text(
              "Submitting...",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColor.cardBackground,
              ),
            ),
          ],
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.send_rounded,
              color: AppColor.cardBackground,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              "Submit Inquiry",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColor.cardBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



