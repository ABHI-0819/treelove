import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../core/config/constants/enum/notification_enum.dart';
import '../../../../core/config/resource/images.dart';
import '../../../../core/config/themes/app_color.dart';
import '../../../../core/config/themes/app_fonts.dart';
import '../../../../core/widgets/common_notification.dart';
import '../../../../core/widgets/common_tree_diseases.dart';

class MonitorActivityScreen extends StatefulWidget {
  static const route = "/monitor-activity";
  const MonitorActivityScreen({super.key});

  @override
  State<MonitorActivityScreen> createState() => _MonitorActivityScreenState();
}

class _MonitorActivityScreenState extends State<MonitorActivityScreen> {

  String today = '';

  List<String> treeDiseases=[];

  /// get today date
  String getTodayDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(now);
  }

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
  void initState() {
    today = getTodayDate();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar:PreferredSize(
        preferredSize: const Size.fromHeight(80), // same height
        child: AppBar(
          automaticallyImplyLeading: false, // we'll use our custom button
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF00695C),
                  Color(0xFF004D40),
                ],
              ),
            ),
          ),
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.white, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          titleSpacing: 0, // aligns title properly
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tree Monitor',
                style: AppFonts.body.copyWith(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Monitoring green spaces',
                // '${_treeData.length} trees under observation',
                style: AppFonts.regular.copyWith(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tree Health Section
              Column(
                spacing: 10.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monitoring date',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: 1.sw,
                    height: 40.h,
                    padding:  EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:Colors.grey.shade400,
                      ),
                      borderRadius: BorderRadius.circular(6),
                      // color:AppColor.white,
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      spacing: 10.w,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(today,style: AppFonts.body.copyWith(
                            color: Color(0xFF1A5F3E),
                            fontWeight: FontWeight.w500
                        ),),
                        InkWell(
                            onTap: (){
                              // _selectDate(context);
                            },
                            child: SvgPicture.asset(Images.calendarIcon,width: 18.w,height: 18.h,))
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 24),
              /// tree Health
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
              SizedBox(height: 24),
              CommonTreeDiseasesWidget(
                onChanged: (selectedDiseases) {
                  treeDiseases=selectedDiseases.map((d) => d.id).toList();
                  debugPrint("Selected IDs: ${selectedDiseases.map((d) => d.id).toList()}");
                },
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
                      final XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
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
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004D40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // less rounded
                    ),
                  ),
                  onPressed: _onSubmit,
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 16,color: AppColor.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              /*
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

               */
              SizedBox(height: 20.h,)
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmit(){
    showNotification(context,type: Not.success, message: "Record added successfully ");
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

}
/*
class UnderlinedText extends StatelessWidget {
  final String text;
  const UnderlinedText({super.key,required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColor.black, width: 1),
          )
      ),
      child: Text(
        '$text :',
        style: AppFonts.body.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColor.black, // Remove default underline
        ),
      ),
    );
  }
}

 */


