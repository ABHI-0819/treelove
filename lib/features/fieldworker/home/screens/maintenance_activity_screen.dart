import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:treelove/core/config/themes/app_fonts.dart';

import '../../../../core/config/themes/app_color.dart';

class MaintenanceActivityScreen extends StatefulWidget {
  const MaintenanceActivityScreen({super.key});

  @override
  _MaintenanceActivityScreenState createState() => _MaintenanceActivityScreenState();
}

class _MaintenanceActivityScreenState extends State<MaintenanceActivityScreen> {
  // Selected values for each section
  String? selectedHealth;
  String? selectedGrowthStage;
  List<String> selectedMaintenanceActivities = []; // Track multiple selections

  // Photo-related state
  List<XFile> photos = []; // To store captured photos
  final ImagePicker _imagePicker = ImagePicker();

  // Remark text field state
  TextEditingController remarkController = TextEditingController();

  @override
  void dispose() {
    remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maintenance',style: AppFonts.regular,),
        backgroundColor: Color(0xFF1A5F3E), // Dark green color
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: AppColor.white,),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tree Health Section
              Text(
                'Tree health',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildButtonWithEmoji('Good', '😊', 'Good'),
                  _buildButtonWithEmoji('Better', '😐', 'Better'),
                  _buildButtonWithEmoji('Sick', '😟', 'Sick'),
                  _buildButtonWithEmoji('Worse', '🙁', 'Worse'),
                  _buildButtonWithEmoji('Bad', '☹️', 'Bad'),
                ],
              ),
          
              // Tree Growth Stage Section
              SizedBox(height: 24),
              Text(
                'Tree growth stage',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildButton('Sapling', 'Sapling'),
                  _buildButton('Half growth', 'Half growth'),
                  _buildButton('Full growth', 'Full growth'),
                ],
              ),
          
              // Maintenance Activity Section
              SizedBox(height: 24),
              Text(
                'Maintenance activity',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Column(
                children: [
                  _buildMaintenanceCard(Icons.water_drop, 'Watering', 'Watering'),
                  _buildMaintenanceCard(Icons.local_shipping, 'Fertilizer', 'Fertilizer'),
                  _buildMaintenanceCard(Icons.local_hospital, 'Pesticides', 'Pesticides'),
                  _buildMaintenanceCard(Icons.border_all, 'Fencing', 'Fencing'),
                  _buildMaintenanceCard(Icons.ac_unit_sharp, 'Trimming', 'Trimming'),
                ],
              ),
          
              // Take Photo Section
              SizedBox(height: 24),
              Text(
                'Take photo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [

                  InkWell(
                    onTap: () async {
                      final XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          photos.add(pickedFile);
                        });
                      }
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColor.textSecondary.withOpacity(0.5), // Border color
                          width: 1.5, // Border width (optional)
                        ),
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        size: 32,
                        color: AppColor.textSecondary.withOpacity(0.3),
                      ),
                    ),
                  ),

                  // Camera Button
                  SizedBox(width: 8),
          
                  // Display Existing Photos
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: photos.map((photo) {
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(photo.path),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: IconButton(
                                icon: Icon(Icons.delete, size: 20, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    photos.remove(photo);
                                  });
                                },
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
          
              // Remark Section
              SizedBox(height: 24),
              Text(
                'Remark (Optional)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: remarkController,
                decoration: InputDecoration(
                  hintText: 'Write your remark here',
                  border: OutlineInputBorder(),
                ),
              ),
          
              // Submit Button
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Handle submission logic here
                  print('Selected Maintenance Activities: $selectedMaintenanceActivities');
                  print('Photos: ${photos.map((photo) => photo.path).toList()}');
                  print('Remark: ${remarkController.text}');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1A5F3E),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Submit',style: AppFonts.caption.copyWith(color: AppColor.white),),
              ),
              SizedBox(height: 20.h,)
            ],
          ),
        ),
      ),
    );
  }

  // Reusable Button with Emoji
  Widget _buildButtonWithEmoji(String label, String emoji, String value) {
    bool isSelected = selectedHealth == value;
    return OutlinedButton(
      onPressed: () {
        setState(() {
          selectedHealth = isSelected ? null : value; // Toggle selection
        });
      },
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide(
          color: isSelected ? Color(0xFF1A5F3E) : Colors.grey[300]!,
          width: 2,
        ),
        backgroundColor: isSelected ? Color(0xFFD9F6EF) : null, // Light green background for selected
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji),
          SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  // Reusable Button without Emoji
  Widget _buildButton(String label, String value) {
    bool isSelected = selectedGrowthStage == value;
    return OutlinedButton(
      onPressed: () {
        setState(() {
          selectedGrowthStage = isSelected ? null : value; // Toggle selection
        });
      },
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide(
          color: isSelected ? Color(0xFF1A5F3E) : Colors.grey[300]!,
          width: 2,
        ),
        backgroundColor: isSelected ? Color(0xFFD9F6EF) : null, // Light green background for selected
      ),
      child: Text(label),
    );
  }

  // Reusable Maintenance Card (Multiple Choice)
  Widget _buildMaintenanceCard(IconData icon, String label, String value) {
    bool isSelected = selectedMaintenanceActivities.contains(value);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedMaintenanceActivities.remove(value); // Deselect
          } else {
            selectedMaintenanceActivities.add(value); // Select
          }
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Color(0xFF1A5F3E) : Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Color(0xFFD9F6EF) : null, // Light green background for selected
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Color(0xFF1A5F3E), // Green color
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

