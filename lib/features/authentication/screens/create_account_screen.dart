import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/core/config/themes/app_color.dart';
import 'package:treelove/features/authentication/screens/sign_in_screen.dart';

import '../../../common/bloc/api_event.dart';
import '../../../common/bloc/api_state.dart';
import '../../../common/models/response.mode.dart';
import '../../../common/repositories/sign_in_repository.dart';
import '../../../core/config/themes/app_fonts.dart';
import '../../../core/network/api_connection.dart';
import '../bloc/register_bloc.dart';
import '../models/register_request_model.dart';
/*
class CreateAccountScreen extends StatefulWidget {
  static const route ='/create-account';
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _agreedToTerms = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _legalNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();

  String _selectedUserType = 'Individual';
  final List<String> _userTypes = ['Individual', 'Organization'];

  void _submitForm() {
    if (_formKey.currentState!.validate() && _agreedToTerms) {
      // Handle API call
      print("Account Created");
    } else {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields and agree to terms.')),
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _legalNameController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _stateController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEF7),
      // backgroundColor: const Color(0xFFFCFAF2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 4), // reduce from default ~16 to 4 or less
          child: const BackButton(color: Colors.black),
        ),
        // actions: const [
        //   Padding(
        //     padding: EdgeInsets.only(right: 12),
        //     child: Icon(Icons.close, color: Colors.black),
        //   )
        // ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text("Create an account", style: AppFonts.subtitle.copyWith(color: AppColor.black,fontSize: 27)),
              const SizedBox(height: 8),
               Text("Your new password must be different from previously used password", style: AppFonts.caption.copyWith(color: AppColor.textSecondary)),
              const SizedBox(height: 24),
              _buildTextField(_firstNameController, 'First name',keyboardType: TextInputType.text),
              _buildTextField(_lastNameController, 'Last name',keyboardType: TextInputType.text),
              _buildTextField(_emailController, 'Email', suffix: _buildVerifyButton(),keyboardType: TextInputType.emailAddress,inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r"\s")), // Disallow spaces
              ],),
              _buildTextField(_phoneController, 'Phone number', suffix: _buildVerifyButton(),keyboardType: TextInputType.phone,
                 inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),]
              ),
              _buildPasswordField(),
              _buildDropdown(),
              _buildTextField(_legalNameController, 'Legal name'),
              _buildTextField(_cityController, 'City'),
              _buildTextField(_zipController, 'Zip code'),
              _buildTextField(_stateController, 'State'),
              _buildTextField(_streetController, 'Street address'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Transform.scale(
                    scale: 28 / 18, // default checkbox size is 18, so scale it to 20
                    child: Checkbox(
                      value: _agreedToTerms,
                      onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
                      checkColor: Color(0xFF00473C), // check mark color
                      activeColor: Colors.white,     // fill color when checked
                      side: MaterialStateBorderSide.resolveWith(
                            (states) => BorderSide(
                          color: Color(0xFF00473C), // dark green border color
                          width: 0.5,
                        ),
                      ),
                    ),
                  ),
                  // Checkbox(
                  //   activeColor: AppColor.white,
                  //   checkColor: Color(0xFF00473C),
                  //   value: _agreedToTerms,
                  //   onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
                  // ),
                  const Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'By checking this box, I agree to TreeLov’s ',
                        children: [
                          TextSpan(text: 'terms of service', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: ' and '),
                          TextSpan(text: 'privacy policy', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  // backgroundColor: const Color(0xFFF8F4E4),
                  // foregroundColor: const Color(0xFFBDB290),
                  backgroundColor: _agreedToTerms ? Color(0xFF00473C) : Color(0xFFF8F4E4),
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(
                  'Send again',
                  style: TextStyle(
                    color: _agreedToTerms ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {Widget? suffix,TextInputType? keyboardType,List<TextInputFormatter>? inputFormatters}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: suffix,
          border: const UnderlineInputBorder(),
        ),
        validator: (value) => value == null || value.trim().isEmpty ? 'Required' : null,
      ),
    );
  }

  Widget _buildVerifyButton() {
    return TextButton(
      onPressed: () {
        // Implement verification
      },
      child: const Text("Verify", style: TextStyle(color: Color(0xFF00473C))),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          labelText: 'Create password',
          suffixIcon: IconButton(
            icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
          ),
          border: const UnderlineInputBorder(),
        ),
        validator: (value) => value != null && value.length < 6 ? 'Min. 6 characters' : null,
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: _selectedUserType,
        items: _userTypes.map((type) {
          return DropdownMenuItem<String>(
            value: type,
            child: Text(type),
          );
        }).toList(),
        onChanged: (val) {
          if (val != null) setState(() => _selectedUserType = val);
        },
        decoration: const InputDecoration(labelText: 'User type'),
      ),
    );
  }
}

 */
/*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:treelove/core/config/themes/app_color.dart';
import '../../../core/config/themes/app_fonts.dart';

class CreateAccountScreen extends StatefulWidget {
  static const route = '/create-account';
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _agreedToTerms = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _legalNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();

  String _selectedUserType = 'Individual';
  final List<String> _userTypes = ['Individual', 'Organization'];

  bool _emailVerified = false;
  bool _phoneVerified = false;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (!_agreedToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please agree to the terms and conditions'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (!_emailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please verify your email address'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      if (!_phoneVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please verify your phone number'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Handle API call
      print("Account Created");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _verifyEmail() {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email first')),
      );
      return;
    }
    // Implement OTP verification logic here
    showDialog(
      context: context,
      builder: (context) => _buildOTPDialog('Email', (otp) {
        // Verify OTP logic
        setState(() => _emailVerified = true);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email verified successfully!')),
        );
      }),
    );
  }

  void _verifyPhone() {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter phone number first')),
      );
      return;
    }
    // Implement OTP verification logic here
    showDialog(
      context: context,
      builder: (context) => _buildOTPDialog('Phone', (otp) {
        // Verify OTP logic
        setState(() => _phoneVerified = true);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Phone verified successfully!')),
        );
      }),
    );
  }

  Widget _buildOTPDialog(String type, Function(String) onVerify) {
    final otpController = TextEditingController();
    return AlertDialog(
      title: Text('Verify $type'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Enter the OTP sent to your $type'),
          const SizedBox(height: 16),
          TextField(
            controller: otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: const InputDecoration(
              labelText: 'Enter OTP',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => onVerify(otpController.text),
          child: const Text('Verify'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _legalNameController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _stateController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEF7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: const BackButton(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create an account",
                style: AppFonts.subtitle.copyWith(
                  color: AppColor.black,
                  fontSize: 27,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Join us today! Fill in your details below",
                style: AppFonts.caption.copyWith(
                  color: AppColor.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // User Type Selection (First for better UX)
              _buildDropdown(),

              // Personal Information Section
              _buildSectionHeader('Personal Information'),
              _buildTextField(
                _firstNameController,
                'First name',
                keyboardType: TextInputType.text,
                validator: _validateName,
              ),
              _buildTextField(
                _lastNameController,
                'Last name',
                keyboardType: TextInputType.text,
                validator: _validateName,
              ),

              // Show Legal Name only for Organizations
              if (_selectedUserType == 'Organization')
                _buildTextField(
                  _legalNameController,
                  'Legal name / Organization name',
                  keyboardType: TextInputType.text,
                  validator: _validateRequired,
                ),

              const SizedBox(height: 16),

              // Contact Information Section
              _buildSectionHeader('Contact Information'),
              _buildTextField(
                _emailController,
                'Email address',
                suffix: _buildVerifyButton('Email', _emailVerified, _verifyEmail),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r"\s")),
                ],
              ),
              _buildTextField(
                _phoneController,
                'Phone number',
                suffix: _buildVerifyButton('Phone', _phoneVerified, _verifyPhone),
                keyboardType: TextInputType.phone,
                validator: _validatePhone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),

              const SizedBox(height: 16),

              // Address Section
              _buildSectionHeader('Address'),
              _buildTextField(
                _streetController,
                'Street address',
                validator: _validateRequired,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildTextField(
                      _cityController,
                      'City',
                      validator: _validateRequired,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      _stateController,
                      'State',
                      validator: _validateRequired,
                    ),
                  ),
                ],
              ),
              _buildTextField(
                _zipController,
                'Zip code',
                keyboardType: TextInputType.number,
                validator: _validateZipCode,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
              ),

              const SizedBox(height: 16),

              // Security Section
              _buildSectionHeader('Security'),
              _buildPasswordField(),

              const SizedBox(height: 24),

              // Terms and Conditions
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      value: _agreedToTerms,
                      onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
                      checkColor: const Color(0xFF00473C),
                      fillColor: MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.selected)) {
                          return Colors.white;
                        }
                        return Colors.transparent;
                      }),
                      side: const BorderSide(
                        color: Color(0xFF00473C),
                        width: 1.5,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text.rich(
                        TextSpan(
                          text: 'By checking this box, I agree to TreeLov\'s ',
                          style: TextStyle(fontSize: 13),
                          children: [
                            TextSpan(
                              text: 'terms of service',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'privacy policy',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _agreedToTerms
                      ? const Color(0xFF00473C)
                      : const Color(0xFFE0E0E0),
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: _agreedToTerms ? 2 : 0,
                ),
                child: Text(
                  'Create Account',
                  style: TextStyle(
                    color: _agreedToTerms ? Colors.white : Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF00473C),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label, {
        Widget? suffix,
        TextInputType? keyboardType,
        List<TextInputFormatter>? inputFormatters,
        String? Function(String?)? validator,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: suffix,
          border: const UnderlineInputBorder(),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00473C), width: 2),
          ),
        ),
        validator: validator ?? _validateRequired,
      ),
    );
  }

  Widget _buildVerifyButton(String type, bool isVerified, VoidCallback onPressed) {
    return Container(
      padding: const EdgeInsets.only(right: 4),
      child: isVerified
          ? Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.check_circle, color: Colors.green, size: 20),
          SizedBox(width: 4),
          Text(
            'Verified',
            style: TextStyle(color: Colors.green, fontSize: 12),
          ),
        ],
      )
          : TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        child: const Text(
          "Verify",
          style: TextStyle(
            color: Color(0xFF00473C),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          labelText: 'Create password',
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
          ),
          border: const UnderlineInputBorder(),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00473C), width: 2),
          ),
          helperText: 'Minimum 8 characters with letters and numbers',
          helperStyle: const TextStyle(fontSize: 11),
        ),
        validator: _validatePassword,
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: DropdownButtonFormField<String>(
        value: _selectedUserType,
        items: _userTypes.map((type) {
          return DropdownMenuItem<String>(
            value: type,
            child: Text(type),
          );
        }).toList(),
        onChanged: (val) {
          if (val != null) {
            setState(() {
              _selectedUserType = val;
              // Clear legal name if switching to Individual
              if (val == 'Individual') {
                _legalNameController.clear();
              }
            });
          }
        },
        decoration: const InputDecoration(
          labelText: 'Account type',
          helperText: 'Select Individual for personal use or Organization for business',
          helperStyle: TextStyle(fontSize: 11),
          border: UnderlineInputBorder(),
        ),
      ),
    );
  }

  // Validation Methods
  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (value.length != 10) {
      return 'Phone number must be 10 digits';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'(?=.*[a-zA-Z])(?=.*[0-9])').hasMatch(value)) {
      return 'Password must contain both letters and numbers';
    }
    return null;
  }

  String? _validateZipCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Zip code is required';
    }
    if (value.length < 5) {
      return 'Enter a valid zip code';
    }
    return null;
  }
}

 */
/*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:treelove/core/config/themes/app_color.dart';
import '../../../core/config/themes/app_fonts.dart';
import '../models/register_request_model.dart';

class CreateAccountScreen extends StatefulWidget {
  static const route = '/create-account';
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _agreedToTerms = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _legalNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();

  String _selectedUserType = 'Individual';
  final List<String> _userTypes = ['Individual', 'Organization'];

  bool _emailVerified = false;
  bool _phoneVerified = false;

  String _selectedCountryCode = '+91';
  final List<Map<String, String>> _countryCodes = [
    {'code': '+91', 'country': 'India'},
    {'code': '+1', 'country': 'USA'},
    {'code': '+44', 'country': 'UK'},
    {'code': '+61', 'country': 'Australia'},
    {'code': '+971', 'country': 'UAE'},
    {'code': '+65', 'country': 'Singapore'},
    {'code': '+60', 'country': 'Malaysia'},
  ];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (!_agreedToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please agree to the terms and conditions'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (!_emailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please verify your email address'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      if (!_phoneVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please verify your phone number'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Handle API call
      print("Account Created");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }



  /// ✅ Builds complete request from all UI controllers
  RegistrationRequest _buildRegistrationRequest() {
    // Determine oauth_provider based on what's provided
    // Prioritize email if both are available
    final String oauthProvider = _emailController.text.trim().isNotEmpty ? 'email' : 'phone';

    // Build Profile object
    final profile = Profile(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      legalName: _selectedUserType == 'Organization'
          ? _legalNameController.text.trim()
          : null, // Only for organizations
      bio: null, // Not in UI
      dateOfBirth: null, // Not in UI
      website: null, // Not in UI
      receiveNotifications: true, // Default to true since not in UI// Add the address
    );

    // Extract phone number without country code for validation
    final phoneNumber = _phoneController.text.trim();
    // Remove leading zeros if present (common in some countries)
    final cleanedPhone = phoneNumber.startsWith('0')
        ? phoneNumber.substring(1)
        : phoneNumber;

    // Create the final request
    return RegistrationRequest(
      email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
      phone: phoneNumber.isEmpty ? null : cleanedPhone,
      countryCode: _selectedCountryCode,
      oauthProvider: oauthProvider,
      password: _passwordController.text,
      confirmPassword: _passwordController.text, // Assuming you confirm elsewhere
      group: null, // Not in UI - set to null (optional)
      profile: profile,
      profilePicture: null, // File upload not in UI
    );
  }

  void _verifyEmail() {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email first')),
      );
      return;
    }
    // Implement OTP verification logic here
    showDialog(
      context: context,
      builder: (context) => _buildOTPDialog('Email', (otp) {
        // Verify OTP logic
        setState(() => _emailVerified = true);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email verified successfully!')),
        );
      }),
    );
  }

  void _verifyPhone() {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter phone number first')),
      );
      return;
    }
    // Implement OTP verification logic here
    showDialog(
      context: context,
      builder: (context) => _buildOTPDialog('Phone', (otp) {
        // Verify OTP logic
        setState(() => _phoneVerified = true);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Phone verified successfully!')),
        );
      }),
    );
  }

  Widget _buildOTPDialog(String type, Function(String) onVerify) {
    final List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());
    final List<FocusNode> otpFocusNodes = List.generate(6, (_) => FocusNode());

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'Verify $type',
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF00473C),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Enter the 6-digit code sent to your $type',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(6, (index) {
              return SizedBox(
                width: 45,
                height: 55,
                child: TextField(
                  controller: otpControllers[index],
                  focusNode: otpFocusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF00473C), width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      // Move to next field
                      if (index < 5) {
                        otpFocusNodes[index + 1].requestFocus();
                      } else {
                        // Last field, unfocus
                        otpFocusNodes[index].unfocus();
                      }
                    }
                  },
                  onTap: () {
                    // Clear field on tap for easier editing
                    otpControllers[index].clear();
                  },
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              // Resend OTP logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('OTP resent successfully!')),
              );
            },
            child: const Text(
              'Resend OTP',
              style: TextStyle(
                color: Color(0xFF00473C),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            String otp = otpControllers.map((c) => c.text).join();
            if (otp.length == 6) {
              onVerify(otp);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter all 6 digits'),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00473C),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('Verify', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _legalNameController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _stateController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEF7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: const BackButton(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create an account",
                style: AppFonts.subtitle.copyWith(
                  color: AppColor.black,
                  fontSize: 27,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Join us today! Fill in your details below",
                style: AppFonts.caption.copyWith(
                  color: AppColor.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // User Type Selection (First for better UX)
              _buildDropdown(),

              // Personal Information Section
              _buildSectionHeader('Personal Information'),
              _buildTextField(
                _firstNameController,
                'First name',
                keyboardType: TextInputType.text,
                validator: _validateName,
              ),
              _buildTextField(
                _lastNameController,
                'Last name',
                keyboardType: TextInputType.text,
                validator: _validateName,
              ),

              // Show Legal Name only for Organizations
              if (_selectedUserType == 'Organization')
                _buildTextField(
                  _legalNameController,
                  'Legal name / Organization name',
                  keyboardType: TextInputType.text,
                  validator: _validateRequired,
                ),

              const SizedBox(height: 16),

              // Contact Information Section
              _buildSectionHeader('Contact Information'),
              _buildTextField(
                _emailController,
                'Email address',
                suffix: _buildVerifyButton('Email', _emailVerified, _verifyEmail),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r"\s")),
                ],
              ),
              _buildPhoneField(),

              const SizedBox(height: 16),
              /*
              // Address Section
              _buildSectionHeader('Address'),
              _buildTextField(
                _streetController,
                'Street address',
                validator: _validateRequired,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildTextField(
                      _cityController,
                      'City',
                      validator: _validateRequired,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      _stateController,
                      'State',
                      validator: _validateRequired,
                    ),
                  ),
                ],
              ),
              _buildTextField(
                _zipController,
                'Zip code',
                keyboardType: TextInputType.number,
                validator: _validateZipCode,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
              ),

              const SizedBox(height: 16),

               */

              // Security Section
              _buildSectionHeader('Security'),
              _buildPasswordField(),

              const SizedBox(height: 24),

              // Terms and Conditions
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      value: _agreedToTerms,
                      onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
                      checkColor: const Color(0xFF00473C),
                      fillColor: MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.selected)) {
                          return Colors.white;
                        }
                        return Colors.transparent;
                      }),
                      side: const BorderSide(
                        color: Color(0xFF00473C),
                        width: 1.5,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text.rich(
                        TextSpan(
                          text: 'By checking this box, I agree to TreeLov\'s ',
                          style: TextStyle(fontSize: 13),
                          children: [
                            TextSpan(
                              text: 'terms of service',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'privacy policy',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _agreedToTerms
                      ? const Color(0xFF00473C)
                      : const Color(0xFFE0E0E0),
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: _agreedToTerms ? 2 : 0,
                ),
                child: Text(
                  'Create Account',
                  style: TextStyle(
                    color: _agreedToTerms ? Colors.white : Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF00473C),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label, {
        Widget? suffix,
        TextInputType? keyboardType,
        List<TextInputFormatter>? inputFormatters,
        String? Function(String?)? validator,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: suffix,
          border: const UnderlineInputBorder(),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00473C), width: 2),
          ),
        ),
        validator: validator ?? _validateRequired,
      ),
    );
  }

  Widget _buildVerifyButton(String type, bool isVerified, VoidCallback onPressed) {
    return Container(
      padding: const EdgeInsets.only(right: 4),
      child: isVerified
          ? Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.check_circle, color: Colors.green, size: 20),
          SizedBox(width: 4),
          Text(
            'Verified',
            style: TextStyle(color: Colors.green, fontSize: 12),
          ),
        ],
      )
          : TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        child: const Text(
          "Verify",
          style: TextStyle(
            color: Color(0xFF00473C),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          labelText: 'Create password',
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
          ),
          border: const UnderlineInputBorder(),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00473C), width: 2),
          ),
          helperText: 'Minimum 8 characters with letters and numbers',
          helperStyle: const TextStyle(fontSize: 11),
        ),
        validator: _validatePassword,
      ),
    );
  }

  Widget _buildPhoneField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Country Code Dropdown
          Container(
            width: 100,
            margin: const EdgeInsets.only(right: 12),
            child: DropdownButtonFormField<String>(
              value: _selectedCountryCode,
              decoration: const InputDecoration(
                labelText: 'Code',
                border: UnderlineInputBorder(),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF00473C), width: 2),
                ),
              ),
              items: _countryCodes.map((country) {
                return DropdownMenuItem<String>(
                  value: country['code'],
                  child: Text(
                    country['code']!,
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCountryCode = value);
                }
              },
            ),
          ),
          // Phone Number Field
          Expanded(
            child: TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone number',
                suffixIcon: _buildVerifyButton('Phone', _phoneVerified, _verifyPhone),
                border: const UnderlineInputBorder(),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF00473C), width: 2),
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: _validatePhone,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: DropdownButtonFormField<String>(
        value: _selectedUserType,
        items: _userTypes.map((type) {
          return DropdownMenuItem<String>(
            value: type,
            child: Text(type),
          );
        }).toList(),
        onChanged: (val) {
          if (val != null) {
            setState(() {
              _selectedUserType = val;
              // Clear legal name if switching to Individual
              if (val == 'Individual') {
                _legalNameController.clear();
              }
            });
          }
        },
        decoration: const InputDecoration(
          labelText: 'Account type',
          helperText: 'Select Individual for personal use or Organization for business',
          helperStyle: TextStyle(fontSize: 11),
          border: UnderlineInputBorder(),
        ),
      ),
    );
  }

  // Validation Methods
  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (value.length != 10) {
      return 'Phone number must be 10 digits';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'(?=.*[a-zA-Z])(?=.*[0-9])').hasMatch(value)) {
      return 'Password must contain both letters and numbers';
    }
    return null;
  }

  String? _validateZipCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Zip code is required';
    }
    if (value.length < 5) {
      return 'Enter a valid zip code';
    }
    return null;
  }
}

 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';


class CreateAccountScreen extends StatefulWidget {
  static const route = '/create-account';
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _agreedToTerms = false;

  late RegisterBloc registerBloc;

  @override
  void initState() {
    registerBloc = RegisterBloc(SignInRepository(api: ApiConnection()));
    // TODO: implement initState
    super.initState();
  }

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _legalNameController = TextEditingController();

  String _selectedUserType = 'Individual';
  final List<String> _userTypes = ['Individual', 'Organization'];

  bool _emailVerified = false;
  bool _phoneVerified = false;

  String _selectedCountryCode = '+91';
  final List<Map<String, String>> _countryCodes = [
    {'code': '+91', 'country': 'India'},
    {'code': '+1', 'country': 'USA'},
    {'code': '+44', 'country': 'UK'},
    {'code': '+61', 'country': 'Australia'},
    {'code': '+971', 'country': 'UAE'},
    {'code': '+65', 'country': 'Singapore'},
    {'code': '+60', 'country': 'Malaysia'},
  ];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (!_agreedToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please agree to the terms and conditions'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (!_emailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please verify your email address'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      if (!_phoneVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please verify your phone number'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // ✅ Dispatch registration event to bloc
      final request = _buildRegistrationRequest();
      registerBloc.add(ApiAdd<RegistrationRequest>(request));
    }
  }

  /// Builds complete request from all UI controllers
  RegistrationRequest _buildRegistrationRequest() {
    final String oauthProvider = _emailController.text.trim().isNotEmpty ? 'email' : 'phone';
    final phoneNumber = _phoneController.text.trim();
    final cleanedPhone = phoneNumber.startsWith('0') ? phoneNumber.substring(1) : phoneNumber;

    // Profile without addresses (since address section removed)
    final profile = Profile(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      legalName: _selectedUserType == 'Organization' ? _legalNameController.text.trim() : null,
      bio: null,
      dateOfBirth: null,
      website: null,
      receiveNotifications: true,
    );

    return RegistrationRequest(
      email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
      phone: phoneNumber.isEmpty ? null : cleanedPhone,
      countryCode: _selectedCountryCode,
      oauthProvider: oauthProvider,
      password: _passwordController.text,
      confirmPassword: _passwordController.text,
      group: null,
      profile: profile,
      profilePicture: null,
    );
  }

  void _verifyEmail() {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email first')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) => _buildOTPDialog('Email', (otp) {
        setState(() => _emailVerified = true);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email verified successfully!')),
        );
      }),
    );
  }

  void _verifyPhone() {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter phone number first')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) => _buildOTPDialog('Phone', (otp) {
        setState(() => _phoneVerified = true);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Phone verified successfully!')),
        );
      }),
    );
  }

  Widget _buildOTPDialog(String type, Function(String) onVerify) {
    final List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());
    final List<FocusNode> otpFocusNodes = List.generate(6, (_) => FocusNode());

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'Verify $type',
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF00473C),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Enter the 6-digit code sent to your $type',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(6, (index) {
              return SizedBox(
                width: 45,
                height: 55,
                child: TextField(
                  controller: otpControllers[index],
                  focusNode: otpFocusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      if (index < 5) {
                        otpFocusNodes[index + 1].requestFocus();
                      } else {
                        otpFocusNodes[index].unfocus();
                      }
                    }
                  },
                  onTap: () {
                    otpControllers[index].clear();
                  },
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('OTP resent successfully!')),
              );
            },
            child: const Text(
              'Resend OTP',
              style: TextStyle(
                color: Color(0xFF00473C),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            String otp = otpControllers.map((c) => c.text).join();
            if (otp.length == 6) {
              onVerify(otp);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter all 6 digits'),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00473C),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('Verify', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _legalNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => registerBloc,
      child: BlocListener<RegisterBloc, ApiState<ResponseModel, ResponseModel>>(
        listener: (context, state) {
          if (state is ApiSuccess<ResponseModel, ResponseModel>) {
            // Navigate to success screen or login
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Account created successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate after delay to show success message
            Future.delayed(const Duration(seconds: 1), () {
             AppRoute.goToNextPage(context: context, screen: SignInScreen.route, arguments: {});
            });
          } else if (state is ApiFailure<ResponseModel, ResponseModel>) {
            //  Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error.message ?? 'Registration failed'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is TokenExpired<ResponseModel, ResponseModel>) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Session expired. Please try again.'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        },
        child: BlocBuilder<RegisterBloc, ApiState<ResponseModel, ResponseModel>>(
          builder: (context, state) {
            final isLoading = state is ApiLoading;

            return Scaffold(
              backgroundColor: const Color(0xFFFEFEF7),
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: const BackButton(color: Colors.black),
                ),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Create an account",
                        style: AppFonts.subtitle.copyWith(
                          color: AppColor.black,
                          fontSize: 27,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Join us today! Fill in your details below",
                        style: AppFonts.caption.copyWith(
                          color: AppColor.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // User Type Selection
                      _buildDropdown(),

                      // Personal Information Section
                      _buildSectionHeader('Personal Information'),
                      _buildTextField(
                        _firstNameController,
                        'First name',
                        keyboardType: TextInputType.text,
                        validator: _validateName,
                        enabled: !isLoading,
                      ),
                      _buildTextField(
                        _lastNameController,
                        'Last name',
                        keyboardType: TextInputType.text,
                        validator: _validateName,
                        enabled: !isLoading,
                      ),

                      // Show Legal Name only for Organizations
                      if (_selectedUserType == 'Organization')
                        _buildTextField(
                          _legalNameController,
                          'Legal name / Organization name',
                          keyboardType: TextInputType.text,
                          validator: _validateRequired,
                          enabled: !isLoading,
                        ),

                      const SizedBox(height: 16),

                      // Contact Information Section
                      _buildSectionHeader('Contact Information'),
                      _buildTextField(
                        _emailController,
                        'Email address',
                        suffix: _buildVerifyButton('Email', _emailVerified, _verifyEmail),
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                        enabled: !isLoading,
                      ),
                      _buildPhoneField(),

                      const SizedBox(height: 16),

                      // Security Section
                      _buildSectionHeader('Security'),
                      _buildPasswordField(),

                      const SizedBox(height: 24),

                      // Terms and Conditions
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              value: _agreedToTerms,
                              onChanged: isLoading
                                  ? null
                                  : (val) => setState(() => _agreedToTerms = val ?? false),
                              checkColor: const Color(0xFF00473C),
                              fillColor: MaterialStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.selected)) {
                                  return Colors.white;
                                }
                                return Colors.transparent;
                              }),
                              side: const BorderSide(
                                color: Color(0xFF00473C),
                                width: 1.5,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: Text.rich(
                                TextSpan(
                                  text: 'By checking this box, I agree to TreeLov\'s ',
                                  style: TextStyle(fontSize: 13),
                                  children: [
                                    TextSpan(
                                      text: 'terms of service',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'privacy policy',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Submit Button with Loading
                      ElevatedButton(
                        onPressed: isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _agreedToTerms
                              ? const Color(0xFF00473C)
                              : const Color(0xFFE0E0E0),
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: _agreedToTerms ? 2 : 0,
                        ),
                        child: isLoading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : Text(
                          'Create Account',
                          style: TextStyle(
                            color: _agreedToTerms ? Colors.white : Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF00473C),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label, {
        Widget? suffix,
        TextInputType? keyboardType,
        List<TextInputFormatter>? inputFormatters,
        String? Function(String?)? validator,
        bool enabled = true,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: suffix,
          border: const UnderlineInputBorder(),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00473C), width: 2),
          ),
          disabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        validator: validator ?? _validateRequired,
      ),
    );
  }

  Widget _buildVerifyButton(String type, bool isVerified, VoidCallback onPressed) {
    return Container(
      padding: const EdgeInsets.only(right: 4),
      child: isVerified
          ? Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.check_circle, color: Colors.green, size: 20),
          SizedBox(width: 4),
          Text('Verified', style: TextStyle(color: Colors.green, fontSize: 12)),
        ],
      )
          : TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        child: const Text(
          "Verify",
          style: TextStyle(
            color: Color(0xFF00473C),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          labelText: 'Create password',
          suffixIcon: IconButton(
            icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
          ),
          border: const UnderlineInputBorder(),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00473C), width: 2),
          ),
          helperText: 'Minimum 8 characters with letters and numbers',
          helperStyle: const TextStyle(fontSize: 11),
        ),
        validator: _validatePassword,
      ),
    );
  }

  Widget _buildPhoneField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            margin: const EdgeInsets.only(right: 12),
            child: DropdownButtonFormField<String>(
              value: _selectedCountryCode,
              decoration: const InputDecoration(
                labelText: 'Code',
                border: UnderlineInputBorder(),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF00473C), width: 2),
                ),
              ),
              items: _countryCodes.map((country) {
                return DropdownMenuItem<String>(
                  value: country['code'],
                  child: Text(country['code']!, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCountryCode = value);
                }
              },
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone number',
                suffixIcon: _buildVerifyButton('Phone', _phoneVerified, _verifyPhone),
                border: const UnderlineInputBorder(),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF00473C), width: 2),
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: _validatePhone,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: DropdownButtonFormField<String>(
        value: _selectedUserType,
        items: _userTypes.map((type) {
          return DropdownMenuItem<String>(
            value: type,
            child: Text(type),
          );
        }).toList(),
        onChanged: (val) {
          if (val != null) {
            setState(() {
              _selectedUserType = val;
              if (val == 'Individual') {
                _legalNameController.clear();
              }
            });
          }
        },
        decoration: const InputDecoration(
          labelText: 'Account type',
          helperText: 'Select Individual for personal use or Organization for business',
          helperStyle: TextStyle(fontSize: 11),
          border: UnderlineInputBorder(),
        ),
      ),
    );
  }

  // Validation Methods
  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (value.length != 10) {
      return 'Phone number must be 10 digits';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'(?=.*[a-zA-Z])(?=.*[0-9])').hasMatch(value)) {
      return 'Password must contain both letters and numbers';
    }
    return null;
  }
}
