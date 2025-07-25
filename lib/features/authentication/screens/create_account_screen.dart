import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:treelove/core/config/themes/app_color.dart';

import '../../../core/config/themes/app_fonts.dart';

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
