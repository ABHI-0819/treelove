import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:treelove/common/bloc/api_event.dart';
import 'package:treelove/common/repositories/plantation_repository.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../core/config/resource/service_ids.dart';
import '../../../../core/config/route/app_route.dart';
import '../../../../core/config/themes/app_color.dart';
import '../../../../core/config/themes/app_fonts.dart';
/*
class PlantTreeScreen extends StatefulWidget {
  static const route ='/PlantTreeScreen';
  const PlantTreeScreen({super.key});

  @override
  State<PlantTreeScreen> createState() => _PlantTreeScreenState();
}

class _PlantTreeScreenState extends State<PlantTreeScreen> {
  String plantationType = 'Fresh';
  bool maintenanceRequired = true;
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  DateTime plantationDate = DateTime(2023, 5, 6);

  final  List<String> _areaList = const [
    'Thane',
     'Kurla'
  ];


  @override
  void initState() {
    plantationDate = DateTime.now();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E5D57),
        title: const Text('Plant a tree', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon:  Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => AppRoute.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
             height: 10.h,
            ),
            const Text('Plantation type'),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildToggleButton('Fresh'),
                const SizedBox(width: 12),
                _buildToggleButton('Transplant'),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Location'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: latitudeController,
                    decoration: const InputDecoration(
                      labelText: 'Latitude',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: longitudeController,
                    decoration: const InputDecoration(
                      labelText: 'Longitude',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(
                      color: Colors.grey, // Change to your desired color
                      width: 1.5,
                    ),
                  ),
                  child:  IconButton(
                    onPressed: () {
                      // TODO: Add location picker logic
                    },
                    icon:  Icon(Icons.my_location,size: 26.r),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            const Text('Area'),
            const SizedBox(height: 8),
            CustomDropdown<String>.search(
              hintText: 'Select Area',
              items: _areaList,
              decoration:CustomDropdownDecoration(
                closedFillColor: Colors.white, // Optional: background color
                closedBorder: Border.all(
                  color: Colors.grey, // Change to your desired color
                  width: 1.5,
                ),
                closedBorderRadius: BorderRadius.circular(8), // Optional: rounded corners
                hintStyle: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ) ,
              // initialItem: _areaList[0],
              onChanged: (value) {
                debugLog('changing value to: $value');
              },
            ),
            const SizedBox(height: 20),
            const Text('Plantation date'),
            const SizedBox(height: 8),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: DateFormat('dd MMM yyyy').format(plantationDate),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Take photo'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                // TODO: Add image picker
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey,  width: 1.5,),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.camera_alt_outlined, size: 28),
                ),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004D40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                onPressed: () {
                  // AppRoute.goToNextPage(context: context, screen: PasswordLoginScreen.route, arguments: {});
                },
                child:  Text(
                    'Submit',
                    style: AppFonts.regular

                ),
              ),
            ),
            /*
            const Text('Maintenance required'),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildMaintenanceButton(true),
                const SizedBox(width: 12),
                _buildMaintenanceButton(false),
              ],
            ),

             */
          ],
        ),
      ),
    );
  }

  /*
  Widget _buildToggleButton(String type) {
    final bool isSelected = plantationType == type;
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFFE6F0ED) : Colors.white,
          side: BorderSide(color: isSelected ? const Color(0xFF0E5D57) : Colors.grey),
        ),
        onPressed: () {
          setState(() => plantationType = type);
        },
        child: Text(
          type,
          style: TextStyle(
            color: isSelected ? const Color(0xFF0E5D57) : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

   */

  Widget _buildToggleButton(String type) {
    final bool isSelected = plantationType == type;

    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFFE6F0ED) : Colors.white,
          side: BorderSide(
            color: isSelected ? const Color(0xFF0E5D57) : Colors.grey,
            width: 1.5
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Rectangle shape
          ),
          padding: const EdgeInsets.symmetric(vertical: 16), // Optional: better tap target
        ),
        onPressed: () {
          setState(() => plantationType = type);
        },
        child: Text(
          type,
          style: TextStyle(
            color: isSelected ? const Color(0xFF0E5D57) : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }




  Widget _buildMaintenanceButton(bool value) {
    final bool isSelected = maintenanceRequired == value;
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFFE6F0ED) : Colors.white,
          side: BorderSide(color: isSelected ? const Color(0xFF0E5D57) : Colors.grey),
        ),
        onPressed: () {
          setState(() => maintenanceRequired = value);
        },
        child: Text(
          value ? 'Yes' : 'No',
          style: TextStyle(
            color: isSelected ? const Color(0xFF0E5D57) : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

 */

import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../../../core/network/api_connection.dart';
import '../../../../core/utils/location_permission_helper.dart';
import '../../plantation/bloc/plantation_bloc.dart';
import '../../plantation/models/plantation_model.dart';

class PlantTreeScreen extends StatefulWidget {
  static const route = '/PlantTreeScreen';

  const PlantTreeScreen({super.key});

  @override
  State<PlantTreeScreen> createState() => _PlantTreeScreenState();
}

class _PlantTreeScreenState extends State<PlantTreeScreen> {
  String plantationType = 'Fresh';
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  DateTime plantationDate = DateTime.now();

  final List<String> _areaList = const ['Thane', 'Kurla'];

  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedImages = []; // ✅ store picked images

  late PlantationBloc plantationBloc;

  @override
  void initState() {
    plantationBloc = PlantationBloc(
      PlantationRepository(api: ApiConnection()),
    );
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => plantationBloc,
      child: BlocListener<PlantationBloc,
          ApiState<PlantationResponseModel, ResponseModel>>(
        listener: (context, state) {
          if (state is ApiLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else {
            Navigator.pop(context); // close loader
          }

          if (state is ApiSuccess<PlantationResponseModel, ResponseModel>) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Plantation created successfully!')),
            );
            Navigator.pop(context); // go back after success
          }

          if (state is ApiFailure<PlantationResponseModel, ResponseModel>) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      state.error.message ?? 'Failed to create plantation')),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColor.white,
          appBar: AppBar(
            backgroundColor: const Color(0xFF0E5D57),
            title: const Text('Plant a tree',
                style: TextStyle(color: Colors.white)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => AppRoute.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Plantation type'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildToggleButton('Fresh'),
                    const SizedBox(width: 12),
                    _buildToggleButton('Transplant'),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Location'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: latitudeController,
                        decoration: const InputDecoration(
                          labelText: 'Latitude',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: longitudeController,
                        decoration: const InputDecoration(
                          labelText: 'Longitude',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: _getCurrentLocation,
                      icon: Icon(Icons.my_location, size: 26.r),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Area'),
                const SizedBox(height: 8),
                CustomDropdown<String>.search(
                  hintText: 'Select Area',
                  items: _areaList,
                  decoration: CustomDropdownDecoration(
                    closedFillColor: Colors.white,
                    closedBorder: Border.all(
                      color: Colors.grey,
                      width: 1.5,
                    ),
                    closedBorderRadius: BorderRadius.circular(8),
                    hintStyle: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  onChanged: (value) {
                    areaController.text = value ?? '';
                  },
                ),
                const SizedBox(height: 20),
                const Text('Plantation date'),
                const SizedBox(height: 8),
                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: DateFormat('dd MMM yyyy').format(plantationDate),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                // ✅ IMAGE PICKER SECTION
                const Text('Take photo'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ..._selectedImages.map((file) => Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(file.path),
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedImages.remove(file);
                                });
                              },
                              child: const CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.red,
                                child: Icon(Icons.close,
                                    size: 14, color: Colors.white),
                              ),
                            )
                          ],
                        )),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Icon(Icons.camera_alt_outlined, size: 28),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004D40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    onPressed: _onSubmit,
                    child: Text('Submit', style: AppFonts.regular),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //  IMAGE PICKER FUNCTION
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera, // Or ImageSource.gallery
      imageQuality: 70, // compress
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(pickedFile);
      });
    }
  }

  //Location
  Future<void> _getCurrentLocation() async {
    final hasPermission = await handleLocationPermission(context);
    if (!hasPermission) return;

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      latitudeController.text = position.latitude.toStringAsFixed(6);
      longitudeController.text = position.longitude.toStringAsFixed(6);
    });

    debugPrint(
        "📍 Current Location: ${position.latitude}, ${position.longitude}");
  }

  void _onSubmit() {
    final lat = double.tryParse(latitudeController.text.trim());
    final lng = double.tryParse(longitudeController.text.trim());
    if (lat == null || lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter valid latitude & longitude')),
      );
      return;
    }

    // ✅ Convert selected images into PlantationMedia objects
    final List<PlantationMedia> mediaList = _selectedImages.map((file) {
      return PlantationMedia(
        media: file.path, // compressed path
        type: "image",
      );
    }).toList();

    final request = PlantationRequestModel(
      plantationDate: DateFormat('yyyy-MM-dd').format(plantationDate),
      plantationType:
          plantationType.toLowerCase() == 'fresh' ? 'new' : 'existing',
      // services: '3fa85f64-5717-4562-b3fc-2c963f66afa6', // TODO: dynamic service ID
      services: ServiceIds.plantationId!,
      location: {
        "type": "Point",
        "coordinates": [lat, lng],
      },
      treeHeight: "8.0",
      treeGirth: "10.0",
      treeHeightUnit: "ft",
      treeGirthUnit: "ft",
      treeHealth: "healthy",
      treeGrowth: "sapling",
      remarks: "Planted via UI",
      treeDiseases: [],
      media: mediaList,
    );

    plantationBloc.add(ApiAdd(request));
  }

  Widget _buildToggleButton(String type) {
    final bool isSelected = plantationType == type;
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFFE6F0ED) : Colors.white,
          side: BorderSide(
            color: isSelected ? const Color(0xFF0E5D57) : Colors.grey,
            width: 1.5,
          ),
        ),
        onPressed: () => setState(() => plantationType = type),
        child: Text(
          type,
          style: TextStyle(
            color: isSelected ? const Color(0xFF0E5D57) : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
