import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:treelove/common/repositories/maintenance_repository.dart';
import 'package:treelove/common/repositories/tree_diseases_repository.dart';
import 'package:treelove/core/config/themes/app_fonts.dart';
import 'package:treelove/features/fieldworker/activity/bloc/maintenance_bloc.dart';
import 'package:treelove/features/fieldworker/activity/bloc/tree_diseases_bloc.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import '../../../../common/bloc/api_event.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../core/config/constants/enum/notification_enum.dart';
import '../../../../core/config/route/app_route.dart';
import '../../../../core/config/themes/app_color.dart';

/*
class MaintenanceActivityScreen extends StatefulWidget {
  static const route ="/maintenance-activity";
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
      appBar: PreferredSize(
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
                'Tree Care',
                style: AppFonts.body.copyWith(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Making nature healthier',
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

 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

import '../../../../core/network/api_connection.dart';
import '../../../../core/services/watermark_service.dart';
import '../../../../core/utils/location_permission_helper.dart';
import '../../../../core/widgets/common_notification.dart';
import '../../../../core/widgets/common_tree_diseases.dart';
import '../../../../core/widgets/image_viewe.dart';
import '../../../../core/widgets/multi_select_searchable_dropdown.dart';
import '../../../authentication/screens/sign_in_screen.dart';
import '../../activity/models/maintenance_activity_response_model.dart';
import '../../activity/models/maintenance_created_response_model.dart';
import '../../activity/models/maintenance_request_model.dart';
import '../../activity/models/tree_diseases_list_response_model.dart';



class MaintenanceActivityScreen extends StatefulWidget {
  static const route = "/maintenance-activity";
  final String plantationId;
  final String serviceId;
  const MaintenanceActivityScreen({super.key,required this.plantationId,required this.serviceId});

  @override
  _MaintenanceActivityScreenState createState() => _MaintenanceActivityScreenState();
}

class _MaintenanceActivityScreenState extends State<MaintenanceActivityScreen> {
  String? selectedHealth;
  String? selectedGrowthStage;
  List<String> selectedMaintenanceActivities = [];

  List<XFile> photos = [];
  final ImagePicker _imagePicker = ImagePicker();
  TextEditingController remarkController = TextEditingController();
  DateTime? nextMaintenanceDate;
   List<String> treeDiseases=[];
  List<File> treeImages = [];
  final WatermarkCameraService _service = WatermarkCameraService();

  late MaintenanceBloc maintenanceBloc;

  late MaintenanceActivityBloc maintenanceActivityBloc;

  @override
  void initState() {
    maintenanceBloc = MaintenanceBloc(
      MaintenanceRepository(api: ApiConnection()),
    );
    maintenanceActivityBloc = MaintenanceActivityBloc(
      MaintenanceRepository(api: ApiConnection()),
    );
    maintenanceActivityBloc.add(ApiListFetch());
    // TODO: implement initState
    super.initState();
  }

  bool _isProcessing = false;
  Future<void> _captureImage() async {
    if (_isProcessing) return; // prevent double-tap spam

    setStateSafe(() {
      _isProcessing = true;
    });

    try {
      final file = await _service.captureAndSaveImage();

      if (file != null && mounted) {
        setStateSafe(() {
          treeImages.add(file);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error capturing image: $e")),
        );
      }
    } finally {
      setStateSafe(() {
        _isProcessing = false;
      });
    }
  }

  /// Safe setState to avoid calling after dispose
  void setStateSafe(VoidCallback fn) {
    if (mounted) setState(fn);
  }


  @override
  void dispose() {
    remarkController.dispose();
    maintenanceBloc.close();
    // treeDiseasesBloc.close();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
  providers: [
    BlocProvider(
      create: (context) => maintenanceBloc, // inject repository
),
    BlocProvider(
      create: (context) => maintenanceActivityBloc,
    ),
  ],
  child: Scaffold(
        backgroundColor: AppColor.white,
          appBar: PreferredSize(
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
                    'Tree Care',
                    style: AppFonts.body.copyWith(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Making nature healthier',
                    style: AppFonts.regular.copyWith(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        body: BlocProvider(create: (context)=>maintenanceBloc,
          child: BlocConsumer<MaintenanceBloc, ApiState<MaintenanceResponse, ResponseModel>>(
            listener: (context, state) {
              if(state is ApiLoading){
                EasyLoading.show();
              }
              if (state is ApiSuccess<MaintenanceResponse, ResponseModel>) {
                EasyLoading.dismiss();
                showNotification(type: Not.success,context, message: state.data.message.toString());
              } else if (state is ApiFailure<MaintenanceResponse, ResponseModel>) {
                EasyLoading.dismiss();
                showNotification(type: Not.failed,context, message: state.error.toString());
              }else if (state is TokenExpired<MaintenanceResponse, ResponseModel>) {
                EasyLoading.dismiss();
                AppRoute.pushReplacement(context, SignInScreen.route,
                    arguments: {});
              }else{
                EasyLoading.dismiss();
              }
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 20.h,
                    children: [
                      /// 1. Maintenance Activity
                      _buildMaintenanceActivities(),
                      /// 2. Tree Growth Stage
                      _buildGrowthStage(),
                      /// 3. Tree Health
                      _buildTreeHealth(),
                      /// 4. Tree Diseases
                      CommonTreeDiseasesWidget(
                        onChanged: (selectedDiseases) {
                          treeDiseases=selectedDiseases.map((d) => d.id).toList();
                          debugPrint("Selected IDs: ${selectedDiseases.map((d) => d.id).toList()}");
                        },
                      ),
                      /// 5. Tree Photos
                      _buildPhotoPicker(),
                      /// 6. Tree Remark
                      _buildRemarks(),
                      /// 8. next Maintenance Activity
                      _buildNextMaintenanceDate(),
                      /// 9. submit
                      // _buildSubmitButton(context),
                      // ✅ SUBMIT BUTTON
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
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
);
  }

  /// On Submit Method
  _onSubmit() async{
    await _getCurrentLocation();
    // showNotification(context,type: Not.success, message: "Record added successfully ");
    final request = MaintenanceRequestModel(
        plantation:[widget.plantationId],
        maintenanceDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        location: {
          "type": "Point",
          "coordinates": [lng,lat],
        },
        treeDiseases: treeDiseases,
        treeHealth: selectedHealth,
        treeGrowth: selectedGrowthStage,
        maintenanceActivity: ["0823aaf6-1f78-4221-93d7-b182789b5ad8"],
        // maintenance_activity: selectedMaintenanceActivities,
        remarks: remarkController.text.trim(),
        media: photos.map((p) => File(p.path)).toList(),
        nextScheduledDate: nextMaintenanceDate != null ? DateFormat('yyyy-MM-dd').format(nextMaintenanceDate!) : null,
        services: widget.serviceId
    );
    maintenanceBloc.add(ApiAdd(request));
  }

  /// ---------------- UI Components ----------------

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text("Maintenance Activity"),
      backgroundColor: Colors.green.shade700,
    );
  }
  /*
  Widget _buildTreeHealth() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tree health', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
      ],
    );
  }

   */
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
            _buildButtonWithEmoji('Bad', '☹️', 'bad'),
            _buildButtonWithEmoji('Worse', '💀', 'worse'),
            _buildButtonWithEmoji('Require Attention', '🛠️', 'require_attention'),
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
          'Tree growth stage',
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

  /*
  Widget _buildMaintenanceActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Maintenance activity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
      ],
    );
  }

   */
  Widget _buildMaintenanceActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Maintenance activity',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        BlocBuilder<MaintenanceActivityBloc, ApiState<MaintenanceActivityResponseModel, ResponseModel>>(
          builder: (context, state) {
            if (state is ApiLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ApiSuccess<MaintenanceActivityResponseModel, ResponseModel>) {
              final activities = state.data.data; // List<Activity>
              return Column(
                children: [
                  for (var activity in activities)
                    _buildMaintenanceCardFromActivity(activity),
                ],
              );
            }

            if (state is ApiFailure || state is TokenExpired) {
              return Column(
                children: [
                  const Text("Failed to load activities", style: TextStyle(color: Colors.red)),
                  TextButton(
                    onPressed: () => context.read<MaintenanceActivityBloc>().add(ApiListFetch()),
                    child: const Text("Retry"),
                  ),
                ],
              );
            }

            // Initial or unknown state
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildMaintenanceCardFromActivity(Activity activity) {
    final isSelected = selectedMaintenanceActivities.contains(activity.id);
    return GestureDetector(
      onTap: () => setState(() {
        if (isSelected) {
          selectedMaintenanceActivities.remove(activity.id);
        } else {
          selectedMaintenanceActivities.add(activity.id);
        }
      }),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.green.shade700 : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.green.shade50 : null,
        ),
        child: Row(
          children: [
            // You can map activity.name to an icon if needed, or use a default
            Icon(_getIconForActivity(activity.name), color: Colors.green.shade700),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  if (activity.description.isNotEmpty)
                    Text(
                      activity.description,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForActivity(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('water')) return Icons.water_drop;
    if (lower.contains('fertilizer') || lower.contains('ferti')) return Icons.local_shipping;
    if (lower.contains('pesticide') || lower.contains('pest')) return Icons.local_hospital;
    if (lower.contains('fenc')) return Icons.border_all;
    if (lower.contains('trim') || lower.contains('prune')) return Icons.ac_unit_sharp;
    return Icons.build; // fallback
  }

  Widget _buildNextMaintenanceDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Next Maintenance Date',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
          // style: TextStyle(
          //   fontSize: 16,
          //   fontWeight: FontWeight.bold,
          //   // color: Color(0xFF1A5F3E), // Theme green
          // ),
        ),
        SizedBox(height: 8),
        InkWell(
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now().add(Duration(days: 1)),
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() {
                nextMaintenanceDate = picked;
              });
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        color: Color(0xFF1A5F3E), size: 20),
                    SizedBox(width: 12),
                    Text(
                      nextMaintenanceDate != null
                          ? DateFormat('EEE, MMM d, yyyy')
                          .format(nextMaintenanceDate!)
                          : "Select date",
                      style: TextStyle(
                        fontSize: 16,
                        color: nextMaintenanceDate != null
                            ? Colors.black
                            : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 16, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Take Photo",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
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
                      AppRoute.goToNextPage(
                        context: context,
                        screen: FullScreenImageViewer.route,
                        arguments: {
                          'imagePath': file.path,
                          'heroTag': 'photo_${file.hashCode}',
                        },
                      );
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

  Widget _photoButton(IconData icon) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1.5),
      ),
      child: Icon(icon, size: 32, color: Colors.grey.withOpacity(0.3)),
    );
  }

  Widget _buildRemarks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Remark (Optional)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        TextField(
          controller: remarkController,
          decoration: InputDecoration(
            hintText: 'Write your remark here',
            // border: Border.all(color: Colors.grey.shade300, width: 1.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.r)),
              borderSide: BorderSide(
                color: Colors.grey.shade50, // Default border color
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  late double lat;
  late double lng;
  //Location
  Future<void> _getCurrentLocation() async {
    final hasPermission = await handleLocationPermission(context);
    if (!hasPermission) return;

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      lat = position.latitude;
      lng= position.longitude;
    });

    debugPrint(
        "📍 Current Location: ${position.latitude}, ${position.longitude}");
  }

  Widget _buildSubmitButton(BuildContext context) {
    return BlocConsumer<MaintenanceBloc, ApiState<MaintenanceResponse, ResponseModel>>(
      listener: (context, state) {
        if (state is ApiSuccess<MaintenanceResponse, ResponseModel>) {
          showNotification(type: Not.success,context, message: state.data.toString());
        } else if (state is ApiFailure<MaintenanceResponse, ResponseModel>) {
          showNotification(type: Not.failed,context, message: state.error.toString());
        }else if (state is TokenExpired<MaintenanceResponse, ResponseModel>) {
          AppRoute.pushReplacement(context, SignInScreen.route,
              arguments: {});
        }
      },
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state is ApiLoading
              ? null
              : () async{
            await _getCurrentLocation();
            // showNotification(context,type: Not.success, message: "Record added successfully ");
            final request = MaintenanceRequestModel(
              plantation:[widget.plantationId],
              maintenanceDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                location: {
                  "type": "Point",
                  "coordinates": [lng,lat],
                },
              treeDiseases: treeDiseases,
              treeHealth: selectedHealth,
              treeGrowth: selectedGrowthStage,
                maintenanceActivity: ["0823aaf6-1f78-4221-93d7-b182789b5ad8"],
              // maintenance_activity: selectedMaintenanceActivities,
              remarks: remarkController.text.trim(),
              media: photos.map((p) => File(p.path)).toList(),
              nextScheduledDate: nextMaintenanceDate != null ? DateFormat('yyyy-MM-dd').format(nextMaintenanceDate!) : null,
              services: widget.serviceId
            );
            maintenanceBloc.add(ApiAdd(request));

          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: state is ApiLoading
              ? CircularProgressIndicator(color: Colors.white)
              : Text('Submit', style: TextStyle(color: Colors.white)),
        );
      },
    );
  }

  /// Reusable Button with Emoji
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

  /// Reusable Button without Emoji
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
      side: BorderSide(color: isSelected ? Colors.green.shade700 : Colors.grey.shade300, width: 2),
      backgroundColor: isSelected ? Colors.green.shade50 : null,
    );
  }

  Widget _buildMaintenanceCard(IconData icon, String label, String value) {
    bool isSelected = selectedMaintenanceActivities.contains(value);
    return GestureDetector(
      onTap: () => setState(() {
        if (isSelected) {
          selectedMaintenanceActivities.remove(value);
        } else {
          selectedMaintenanceActivities.add(value);
        }
      }),
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Colors.green.shade700 : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.green.shade50 : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.green.shade700),
            SizedBox(width: 16),
            Expanded(child: Text(label, style: TextStyle(fontSize: 16))),
          ],
        ),
      ),
    );
  }
}


