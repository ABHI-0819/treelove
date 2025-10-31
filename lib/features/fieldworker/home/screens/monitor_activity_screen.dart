import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:treelove/common/repositories/monitor_repository.dart';
import 'package:treelove/features/fieldworker/activity/bloc/monitor_bloc.dart';
import '../../../../common/bloc/api_event.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../core/config/constants/enum/notification_enum.dart';
import '../../../../core/config/resource/images.dart';
import '../../../../core/config/route/app_route.dart';
import '../../../../core/config/themes/app_color.dart';
import '../../../../core/config/themes/app_fonts.dart';
import '../../../../core/network/api_connection.dart';
import '../../../../core/services/watermark_service.dart';
import '../../../../core/utils/location_permission_helper.dart';
import '../../../../core/widgets/common_notification.dart';
import '../../../../core/widgets/common_tree_diseases.dart';
/*
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


  late MonitorBloc monitorBloc;


  @override
  void initState() {
    today = getTodayDate();
    monitorBloc = MonitorBloc(
      MonitorRepository(api: ApiConnection()),
    );
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

    // showNotification(context,type: Not.success, message: "Record added successfully ");
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

 */


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

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter_svg/flutter_svg.dart';


import '../../../authentication/screens/sign_in_screen.dart';
import '../../activity/models/monitor_created_response_model.dart';
import '../../activity/models/monitor_request_model.dart';

class MonitorActivityScreen extends StatefulWidget {
  static const route = "/monitor-activity";
  final String plantationId;
  final String serviceId;

  const MonitorActivityScreen({
    super.key,
    required this.plantationId,
    required this.serviceId,
  });

  @override
  State<MonitorActivityScreen> createState() => _MonitorActivityScreenState();
}

class _MonitorActivityScreenState extends State<MonitorActivityScreen> {
  String? selectedHealth;
  String? selectedGrowthStage;
  List<String> treeDiseases = [];
  List<File> treeImages = [];
  final WatermarkCameraService _cameraService = WatermarkCameraService();
  TextEditingController remarkController = TextEditingController();
  late double lat;
  late double lng;

  bool _isProcessing = false;

  late MonitorBloc monitorBloc;

  @override
  void initState() {
    monitorBloc =MonitorBloc(MonitorRepository(api: ApiConnection()));
    super.initState();
  }

  @override
  void dispose() {
    remarkController.dispose();
    monitorBloc.close();
    super.dispose();
  }

  void setStateSafe(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  Future<void> _captureImage() async {
    if (_isProcessing) return;
    setStateSafe(() => _isProcessing = true);

    try {
      final file = await _cameraService.captureAndSaveImage();
      if (file != null && mounted) {
        setStateSafe(() => treeImages.add(file));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error capturing image: $e")),
        );
      }
    } finally {
      setStateSafe(() => _isProcessing = false);
    }
  }

  Future<void> _getCurrentLocation() async {
    final hasPermission = await handleLocationPermission(context);
    if (!hasPermission) return;

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (mounted) {
        setState(() {
          lat = position.latitude;
          lng = position.longitude;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to get location')),
        );
      }
    }
  }

  void _onSubmit() async {
    if (selectedHealth == null) {
      showNotification(context,type: Not.failed, message: "Please select tree health");
      return;
    }
    if (selectedGrowthStage == null) {
      showNotification(context,type: Not.warning, message: "Please select growth stage");
      return;
    }

    await _getCurrentLocation();
    if (!mounted) return;

    final request = MonitorRequestModel(
      plantation: [widget.plantationId],
      monitoringDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      services: widget.serviceId,
      location: {
        "type": "Point",
        "coordinates": [lng, lat],
      },
      treeDiseases: treeDiseases.isEmpty ? null : treeDiseases,
      remarks: remarkController.text.trim().isEmpty ? null : remarkController.text.trim(),
      treeHealth: selectedHealth,
      treeGrowth: selectedGrowthStage,
      media: treeImages,
      treeGirth: 13,
      treeGirthUnit: 'ft',
      treeHeight: 17,
      treeHeightUnit: 'ft'
      // Optional fields can be added later if needed
    );

    monitorBloc.add(ApiAdd(request));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => monitorBloc,
      child: BlocConsumer<MonitorBloc, ApiState<MonitorResponse, ResponseModel>>(
        listener: (context, state) {
          if (state is ApiLoading) {
            EasyLoading.show(status: 'Submitting...');
          } else if (state is ApiSuccess<MonitorResponse, ResponseModel>) {
            EasyLoading.dismiss();
            showNotification(type: Not.success,context, message: state.data.message.toString());
            // Optional: reset form or go back
            AppRoute.pop(context);
          } else if (state is ApiFailure<MonitorResponse, ResponseModel>) {
            EasyLoading.dismiss();
            showNotification(type: Not.failed,context, message: state.error.toString());
          } else if (state is TokenExpired) {
            EasyLoading.dismiss();
            AppRoute.pushReplacement(context, SignInScreen.route,
                arguments: {});
          } else {
            EasyLoading.dismiss();
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColor.white,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF00695C), Color(0xFF004D40)],
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
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                titleSpacing: 0,
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
                    // Tree Health
                    _buildTreeHealth(),
                    SizedBox(height: 24),

                    // Tree Growth Stage
                    _buildGrowthStage(),
                    SizedBox(height: 24),

                    // Tree Diseases
                    CommonTreeDiseasesWidget(
                      onChanged: (selectedDiseases) {
                        treeDiseases = selectedDiseases.map((d) => d.id).toList();
                      },
                    ),
                    SizedBox(height: 24),

                    // Photo Picker
                    _buildPhotoPicker(),
                    SizedBox(height: 24),

                    // Remark
                    _buildRemarks(),
                    SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: state is ApiLoading ? null : _onSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF004D40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: state is ApiLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTreeHealth() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tree Health',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildButtonWithEmoji('Healthy', '🌳', 'healthy'),
            _buildButtonWithEmoji('Good', '😊', 'good'),
            _buildButtonWithEmoji('Better', '🙂', 'better'),
            _buildButtonWithEmoji('Require Attention', '🛠️', 'require_attention'),
            _buildButtonWithEmoji('Bad', '☹️', 'bad'),
            _buildButtonWithEmoji('Worse', '💀', 'worse'),
          ],
        ),
      ],
    );
  }

  Widget _buildGrowthStage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tree Growth Stage',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildButton('Sapling', 'sapling'),
            _buildButton('Young', 'young'),
            _buildButton('Mature', 'mature'),
            _buildButton('Half Grown', 'half_grown'),
            _buildButton('Fully Grown', 'fully_grown'),
          ],
        ),
      ],
    );
  }

  Widget _buildPhotoPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Take Photo",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ...treeImages.map((file) => Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: () {
                      if (!mounted) return;
                      // Optional: full-screen preview
                    },
                    child: Image.file(
                      file,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setStateSafe(() => treeImages.remove(file));
                  },
                  child: const CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.close, size: 14, color: Colors.white),
                  ),
                ),
              ],
            )),
            GestureDetector(
              onTap: _captureImage,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: _isProcessing
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Icon(Icons.camera_alt_outlined, size: 28),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRemarks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Remark (Optional)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        TextField(
          controller: remarkController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Write your remark here',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonWithEmoji(String label, String emoji, String value) {
    bool isSelected = selectedHealth == value;
    return OutlinedButton(
      onPressed: () => setState(() => selectedHealth = isSelected ? null : value),
      style: _buttonStyle(isSelected),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Text(emoji), SizedBox(width: 8), Text(label)],
      ),
    );
  }

  Widget _buildButton(String label, String value) {
    bool isSelected = selectedGrowthStage == value;
    return OutlinedButton(
      onPressed: () => setState(() => selectedGrowthStage = isSelected ? null : value),
      style: _buttonStyle(isSelected),
      child: Text(label),
    );
  }

  ButtonStyle _buttonStyle(bool isSelected) {
    return OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      side: BorderSide(
        color: isSelected ? const Color(0xFF004D40) : Colors.grey.shade300,
        width: 2,
      ),
      backgroundColor: isSelected ? const Color(0xFFD9F6EF) : null,
    );
  }
}
