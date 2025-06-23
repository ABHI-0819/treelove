import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/config/resource/images.dart';
import '../../../core/config/themes/app_fonts.dart';
/*
class UserTypeScreen extends StatefulWidget {
  static const route = '/user-type';
  const UserTypeScreen({super.key});

  @override
  State<UserTypeScreen> createState() => _UserTypeScreenState();
}

class _UserTypeScreenState extends State<UserTypeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}

 */

class UserTypeSelectionScreen extends StatefulWidget {
  static const route = '/user-type';

  const UserTypeSelectionScreen({super.key});

  @override
  State<UserTypeSelectionScreen> createState() =>
      _UserTypeSelectionScreenState();
}

class _UserTypeSelectionScreenState extends State<UserTypeSelectionScreen> {
  String? selectedUserType;

  final Map<String, String> userTypes = {
    'individual': 'Individual',
    'organization': 'Organization',
  };

  void _selectUserType(String type) {
    setState(() {
      selectedUserType = type;
    });
  }

  void _continueToNextStep(BuildContext context) {
    if (selectedUserType == null) return;

    // Navigate to next screen or handle accordingly
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$selectedUserType selected')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Your Account Type',
                  style: AppFonts.headline.copyWith(
                    fontSize: 32,
                    height: 1.3,
                    color: Colors.black87,
                  )),
              SizedBox(
                height: 5,
              ),
              const Text(
                'Choose whether you’re signing up as an individual or organization.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () => _selectUserType('individual'),
                child: Container(
                  width: size.width,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: selectedUserType == 'individual'
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.white,
                    border: Border.all(
                      color: selectedUserType == 'individual'
                          ? Colors.blue
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 50,
                          height: 50,
                          child: SvgPicture.asset(Images.individualIcon)),
                      const SizedBox(height: 15),
                      const Text(
                        'Individual',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'For personal accounts or solo users.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _selectUserType('organization'),
                child: Container(
                  width: size.width,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: selectedUserType == 'organization'
                        ? Colors.green.withOpacity(0.1)
                        : Colors.white,
                    border: Border.all(
                      color: selectedUserType == 'organization'
                          ? Colors.green
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: SvgPicture.asset(Images.organizationIcon),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Organization',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'For companies, teams, or business accounts.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: selectedUserType != null
                      ? () => _continueToNextStep(context)
                      : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Continue'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
