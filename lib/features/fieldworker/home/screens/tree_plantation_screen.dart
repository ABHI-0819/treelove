import 'dart:convert';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:treelove/common/bloc/api_event.dart';
import 'package:treelove/common/repositories/plantation_repository.dart';
import 'package:treelove/core/config/constants/enum/notification_enum.dart';
import 'package:treelove/features/fieldworker/home/screens/select_tree_species.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../core/config/resource/images.dart';
import '../../../../core/config/route/app_route.dart';
import '../../../../core/config/themes/app_color.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../../core/network/api_connection.dart';
import '../../../../core/services/watermark_service.dart';
import '../../../../core/utils/location_permission_helper.dart';
import '../../../../core/widgets/common_notification.dart';
import '../../../../core/widgets/image_viewe.dart';
import '../../../authentication/screens/sign_in_screen.dart';
import '../../activity/screens/project_action_screen.dart';
import '../../plantation/bloc/plantation_bloc.dart';
import '../../plantation/models/plantation_model.dart';

class PlantTreeScreen extends StatefulWidget {
  static const route = '/PlantTreeScreen';
  final String serviceType;
  final String serviceId;
  final String projectAreaId;
  const PlantTreeScreen({super.key,required this.serviceType,required this.serviceId,required this.projectAreaId});

  @override
  State<PlantTreeScreen> createState() => _PlantTreeScreenState();
}

class _PlantTreeScreenState extends State<PlantTreeScreen> {
  String plantationType = 'Fresh';
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController girthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  DateTime plantationDate = DateTime.now();

  final List<String> _areaList = const ['Thane', 'Kurla'];

  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedImages = []; // ✅ store picked images
  List<File> treeImages = [];
  late PlantationBloc plantationBloc;

  LatLng? selectedLatLng; // store current selection
  final mapController = MapController();

  final WatermarkCameraService _service = WatermarkCameraService();

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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => plantationBloc,
      child: BlocListener<PlantationBloc,
          ApiState<PlantationResponseModel, ResponseModel>>(
        listener: (context, state) {
          if(state is ApiLoading){
            EasyLoading.show();
          } else if (state is ApiSuccess<PlantationResponseModel, ResponseModel>) {
            EasyLoading.dismiss();
            showNotification(type: Not.success,context, message: state.data.message);
            // AppRoute.pop(context);
          } else if (state is ApiFailure<PlantationResponseModel, ResponseModel>) {
            EasyLoading.dismiss();
            showNotification(type: Not.failed,context, message: state.error.message.toString());
          } else if (state is TokenExpired<PlantationResponseModel, ResponseModel>) {
            AppRoute.pushReplacement(context, SignInScreen.route,
                arguments: {});
          }else{
            EasyLoading.dismiss();
          }
        },
        child: Scaffold(
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
                    'Plant a Tree',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Making the world greener', // generic and reusable
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ PLANTATION TYPE
                const Text("Plantation Type", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildToggleButton('Fresh'),
                    const SizedBox(width: 12),
                    _buildToggleButton('Transplant'),
                  ],
                ),

                const SizedBox(height: 24),

                // ✅ LOCATION INPUTS
                const Text("Location",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: latitudeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Latitude',
                          labelStyle: TextStyle(color: AppColor.primaryDark),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black54),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: longitudeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Longitude',
                          labelStyle: TextStyle(color: AppColor.primaryDark),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black54),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _locationButton(), // ✅ neatly aligned
                  ],
                ),

                const SizedBox(height: 20),

                // ✅ MAP PREVIEW
                const Text("Location Preview",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LocationPreviewMap(
                    latitude: double.tryParse(latitudeController.text),
                    longitude: double.tryParse(longitudeController.text),
                  ),
                ),

                const SizedBox(height: 24),

                // ✅ PLANTATION DATE
                const Text("Plantation Date",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 8),
                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: DateFormat('dd MMM yyyy').format(plantationDate),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ✅ TREE DETAILS SECTION
                const Text("Tree Details",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: girthController,
                        decoration: InputDecoration(
                          labelText: "Tree Girth (ft)",
                          labelStyle: TextStyle(color: AppColor.primaryDark),
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          // You can store it in a variable if needed
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: heightController,
                        decoration: InputDecoration(
                          labelText: "Tree Height (ft)",
                          labelStyle: TextStyle(color: AppColor.primaryDark),
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          // You can store it in a variable if needed
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                // ✅ IMAGE PICKER SECTION
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
                const SizedBox(height: 16),
                TextFormField(
                  maxLines: 2,
                  controller: remarkController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: "Remark (optional)",
                    alignLabelWithHint: true,
                    labelStyle: TextStyle(color: AppColor.primaryDark),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    // Save remark in a variable
                  },
                ),


                const SizedBox(height: 40),

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
        ),
      ),
    );
  }




  Widget _locationButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: _getCurrentLocation,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFE7F1FC), // soft blue background
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          Icons.my_location_rounded,
          size: 26,
          color: const Color(0xFF0E5D57), // deep green for contrast
        ),
      ),
    );
  }


  Future<String> convertImageToBase64(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return base64Encode(bytes);
  }

  //  IMAGE PICKER FUNCTION
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera, // Or ImageSource.gallery
      imageQuality: 65,
      maxWidth: 1024,
      maxHeight: 1024,// compress
    );

    if (pickedFile != null) {
      setState(() {
        treeImages.add(File(pickedFile.path));
        // _selectedImages.add(pickedFile);
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

  Future<void> _onSubmit() async {
    final lat = double.tryParse(latitudeController.text.trim());
    final lng = double.tryParse(longitudeController.text.trim());
    if (lat == null || lng == null) {
      showNotification(context, type: Not.warning,message: "Please enter valid latitude & longitude");
    }
    if(treeImages.isEmpty){
      showNotification(context, type: Not.warning,message: "At least one picture needs to be upload");
    }
    final request = PlantationRequestModel(
      plantationDate: DateFormat('yyyy-MM-dd').format(plantationDate),
      plantationType: plantationType.toLowerCase() == 'fresh' ? 'new' : 'existing',
      // services: '3fa85f64-5717-4562-b3fc-2c963f66afa6', // TODO: dynamic service ID
      services: widget.serviceId,
      location: {
        "type": "Point",
        "coordinates": [lng,lat],
      },
      treeHeight: heightController.text.trim(),
      treeGirth: girthController.text.trim(),
      treeHeightUnit: "ft",
      treeGirthUnit: "ft",
      treeHealth: "healthy",
      treeGrowth: "sapling",
      remarks: remarkController.text.trim(),
      treeDiseases: [],
      media: treeImages,
    );
    plantationBloc.add(ApiAdd(request));
  }

  Widget _buildToggleButton(String type) {
    final bool isSelected = plantationType == type;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4), // slight spacing between buttons
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: isSelected ? const Color(0xFFE6F0ED) : Colors.white,
            side: BorderSide(
              color: isSelected ? const Color(0xFF0E5D57) : Colors.grey.shade400,
              width: 1.3,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // less rounded = cleaner look
            ),
            padding: const EdgeInsets.symmetric(vertical: 14), // balanced height
            elevation: 0,
          ),
          onPressed: () => setState(() => plantationType = type),
          child: Text(
            type,
            style: TextStyle(
              color: isSelected ? const Color(0xFF0E5D57) : Colors.black87,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

}

class LocationPreviewMap extends StatelessWidget {
  final double? latitude;
  final double? longitude;
  final double zoom;

  const LocationPreviewMap({
    super.key,
    required this.latitude,
    required this.longitude,
    this.zoom = 14,
  });

  @override
  Widget build(BuildContext context) {
    if (latitude == null || longitude == null) {
      return Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Center(
          child: Text(
            "No location selected",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    final LatLng point = LatLng(latitude!, longitude!);

    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: point,
            initialZoom: zoom,
            // interactiveFlags: InteractiveFlag.none, // ✅ Non-interactive preview
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
              tileProvider: NetworkTileProvider(
                headers: {
                  'User-Agent': 'TreelovApp/1.0 (https://yourapp.com)',
                },
              ),
            ),
            CurrentLocationLayer(
              alignPositionOnUpdate: AlignOnUpdate.always,
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: point,
                  width: 40,
                  height: 40,
                  child: SvgPicture.asset(
                    Images.pinIcon,
                    // color: Colors.redAccent,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


/*
    // ✅ Convert selected images into PlantationMedia objects
    final List<PlantationMedia> mediaList = _selectedImages.map((file) {
      return PlantationMedia(
        media: file.path, // compressed path
        type: "image",
      );
    }).toList();

     */