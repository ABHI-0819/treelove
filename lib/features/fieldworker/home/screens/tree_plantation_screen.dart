import 'dart:convert';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../../../core/config/constants/enum/navigation_enum.dart';
import '../../../../core/config/resource/images.dart';
import '../../../../core/config/route/app_route.dart';
import '../../../../core/config/themes/app_color.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../../core/config/themes/app_fonts.dart';
import '../../../../core/network/api_connection.dart';
import '../../../../core/services/watermark_service.dart';
import '../../../../core/utils/location_permission_helper.dart';
import '../../../../core/widgets/common_notification.dart';
import '../../../../core/widgets/image_viewe.dart';
import '../../../../core/widgets/section_label.dart';
import '../../../../core/widgets/success_dialog.dart';
import '../../../authentication/screens/sign_in_screen.dart';
import '../../activity/screens/project_action_screen.dart';
import '../../plantation/bloc/plantation_bloc.dart';
import '../../plantation/models/plantation_model.dart';

class PlantTreeScreen extends StatefulWidget {
  static const route = '/PlantTreeScreen';
  final String serviceType;
  final String serviceId;
  final String projectAreaId;

  const PlantTreeScreen({
    super.key,
    required this.serviceType,
    required this.serviceId,
    required this.projectAreaId,
  });

  @override
  State<PlantTreeScreen> createState() => _PlantTreeScreenState();
}

class _PlantTreeScreenState extends State<PlantTreeScreen> {
  // ── Form State ───────────────────────────────────────────
  bool _isPopped = false;

  String plantationType = 'Fresh';
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController girthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  DateTime plantationDate = DateTime.now();

  final List<File> treeImages = [];

  // ── Validation flag ──────────────────────────────────────
  bool _submitted = false;
  bool get _locationError =>
      _submitted &&
      (double.tryParse(latitudeController.text.trim()) == null ||
          double.tryParse(longitudeController.text.trim()) == null);
  bool get _photoError => _submitted && treeImages.isEmpty;

  // ── Camera state ─────────────────────────────────────────
  bool _isProcessing = false;

  // ── Services / BLoC ──────────────────────────────────────
  final WatermarkCameraService _cameraService = WatermarkCameraService();
  late final PlantationBloc plantationBloc;

  // ── Constants ────────────────────────────────────────────
  static const int _maxPhotos = 3;
  static const int _maxRemarkChars = 100;
  static const Color _primaryGreen = Color(0xFF004D40);
  static const Color _lightGreen = Color(0xFF00695C);

  // ── Cached Button Styles ─────────────────────────────────
  late final ButtonStyle _selectedToggleStyle = OutlinedButton.styleFrom(
    backgroundColor: const Color(0xFFE6F0ED),
    side: const BorderSide(color: Color(0xFF0E5D57), width: 1.3),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    padding: const EdgeInsets.symmetric(vertical: 14),
  );
  late final ButtonStyle _unselectedToggleStyle = OutlinedButton.styleFrom(
    backgroundColor: Colors.white,
    side: BorderSide(color: Colors.grey.shade400, width: 1.3),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    padding: const EdgeInsets.symmetric(vertical: 14),
  );

  // ── Lifecycle ────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    plantationBloc = PlantationBloc(
      PlantationRepository(api: ApiConnection()),
    );
  }

  @override
  void dispose() {
    latitudeController.dispose();
    longitudeController.dispose();
    girthController.dispose();
    heightController.dispose();
    remarkController.dispose();
    plantationBloc.close();
    super.dispose();
  }

  void _setStateSafe(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  void _resetForm() {
    _setStateSafe(() {
      plantationType = 'Fresh';
      latitudeController.clear();
      longitudeController.clear();
      girthController.clear();
      heightController.clear();
      remarkController.clear();
      plantationDate = DateTime.now();
      treeImages.clear();
      _submitted = false;
    });
  }

  // ── Camera with smooth processing ────────────────────────
  Future<void> _captureImage() async {
    if (_isProcessing) return;
    if (treeImages.length >= _maxPhotos) {
      _showSnack('Maximum $_maxPhotos photos allowed.');
      return;
    }

    _setStateSafe(() => _isProcessing = true);

    try {
      final file = await _cameraService.captureAndSaveImage();
      if (file != null && mounted) {
        _setStateSafe(() => treeImages.add(file));
      }
    } on PlatformException catch (e) {
      _showSnack('Camera error: ${e.message ?? 'Unknown error'}');
    } catch (e) {
      _showSnack('Could not capture photo. Please try again.');
      debugPrint('captureImage error: $e');
    } finally {
      _setStateSafe(() => _isProcessing = false);
    }
  }

  // ── Location ─────────────────────────────────────────────
  Future<void> _getCurrentLocation() async {
    final hasPermission = await handleLocationPermission(context);
    if (!hasPermission) return;

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (mounted) {
        _setStateSafe(() {
          latitudeController.text = position.latitude.toStringAsFixed(6);
          longitudeController.text = position.longitude.toStringAsFixed(6);
        });
      }
    } catch (e) {
      _showSnack('Failed to get location. Please enter manually.');
    }
  }

  // ── Submit ───────────────────────────────────────────────
  Future<void> _onSubmit() async {
    _setStateSafe(() => _submitted = true);

    // Validate mandatory fields
    if (_locationError) {
      showNotification(
          type: Not.warning,
          context,
          message: 'Please provide valid latitude and longitude.');

      return;
    }
    if (_photoError) {
      showNotification(
          type: Not.warning,
          context,
          message: 'Please capture at least one tree photo.');
      return;
    }

    final lat = double.parse(latitudeController.text.trim());
    final lng = double.parse(longitudeController.text.trim());

    final request = PlantationRequestModel(
      plantationDate: DateFormat('yyyy-MM-dd').format(plantationDate),
      plantationType:
          plantationType.toLowerCase() == 'fresh' ? 'new' : 'existing',
      services: widget.serviceId,
      location: {
        'type': 'Point',
        'coordinates': [lng, lat],
      },
      treeHeight: heightController.text.trim(),
      treeGirth: girthController.text.trim(),
      treeHeightUnit: 'ft',
      treeGirthUnit: 'ft',
      treeHealth: 'healthy', // default or future enhancement
      treeGrowth: 'sapling', // default
      remarks: remarkController.text.trim().isEmpty
          ? null
          : remarkController.text.trim(),
      treeDiseases: [],
      media: treeImages,
    );

    plantationBloc.add(ApiAdd(request));
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  // ════════════════════════════════════════════════════════
  //  BUILD
  // ════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: plantationBloc,
      child: BlocListener<PlantationBloc,
          ApiState<PlantationResponseModel, ResponseModel>>(
        listener: (context, state) {
          EasyLoading.dismiss(); // Ensure loading is dismissed for all states
          if (state is ApiSuccess<PlantationResponseModel, ResponseModel>) {
            _resetForm();
            SuccessDialog.showAndPop(
              context: context, 
              message: state.data.message ?? 'Plantation submitted successfully.',
            );
          } else if (state
              is ApiFailure<PlantationResponseModel, ResponseModel>) {
            showNotification(
                type: Not.failed,
                context,
                message: state.error.message.toString());
          } else if (state
              is TokenExpired<PlantationResponseModel, ResponseModel>) {
            AppRoute.pushReplacement(context, SignInScreen.route,
                arguments: {});
          }
        },
        child: Scaffold(
          backgroundColor: AppColor.white,
          appBar: _buildAppBar(),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),

                  // ── PLANTATION TYPE (Optional, defaulted) ──
                  SectionLabel(title: 'Plantation Type', mandatory: true),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildToggleButton('Fresh'),
                      const SizedBox(width: 12),
                      _buildToggleButton('Transplant'),
                    ],
                  ),
                  SizedBox(height: 24),

                  // ── MANDATORY: LOCATION ───────────────────
                  SectionLabel(
                    title: 'Location',
                    mandatory: true,
                    subtitle: 'Enter coordinates or use the locate button',
                    hasError: _locationError,
                  ),
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
                            errorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 2),
                            ),
                            errorText: _locationError ? 'Required' : null,
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
                            errorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 2),
                            ),
                            errorText: _locationError ? 'Required' : null,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _locationButton(),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Map Preview
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LocationPreviewMap(
                      latitude: double.tryParse(latitudeController.text.trim()),
                      longitude:
                          double.tryParse(longitudeController.text.trim()),
                    ),
                  ),
                  SizedBox(height: 24),

                  // ── OPTIONAL: PLANTATION DATE (display only) ──
                  SectionLabel(title: 'Plantation Date', mandatory: true),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today_rounded,
                            size: 20, color: _primaryGreen),
                        const SizedBox(width: 12),
                        Text(
                          DateFormat('dd MMM yyyy').format(plantationDate),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),

                  // ── OPTIONAL: TREE DETAILS ─────────────────
                  SectionLabel(
                    title: 'Tree Details',
                    mandatory: true,
                    subtitle: 'Approximate measurements',
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: girthController,
                          decoration: const InputDecoration(
                            labelText: 'Tree Girth (ft)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: heightController,
                          decoration: const InputDecoration(
                            labelText: 'Tree Height (ft)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // ── MANDATORY: TREE PHOTOS ─────────────────
                  _buildPhotoPicker(),
                  SizedBox(height: 24),

                  // ── OPTIONAL: REMARKS ──────────────────────
                  _buildRemarks(),
                  SizedBox(height: 24),

                  // ── SUBMIT BUTTON ──────────────────────────
                  _buildSubmitButton(),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  //  APP BAR
  // ════════════════════════════════════════════════════════
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_lightGreen, _primaryGreen],
            ),
          ),
          child: SizedBox.expand(),
        ),
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.white, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Plant a Tree',
              style: AppFonts.body.copyWith(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Making the world greener',
              style: AppFonts.regular.copyWith(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  //  TOGGLE BUTTONS (Plantation Type)
  // ════════════════════════════════════════════════════════
  Widget _buildToggleButton(String type) {
    final bool isSelected = plantationType == type;
    return Expanded(
      child: OutlinedButton(
        style: isSelected ? _selectedToggleStyle : _unselectedToggleStyle,
        onPressed: () => _setStateSafe(() => plantationType = type),
        child: Text(
          type,
          style: TextStyle(
            color: isSelected ? const Color(0xFF0E5D57) : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  //  LOCATION BUTTON
  // ════════════════════════════════════════════════════════
  Widget _locationButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: _getCurrentLocation,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFE7F1FC),
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
          color: _primaryGreen,
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  //  PHOTO PICKER (mandatory)
  // ════════════════════════════════════════════════════════
  Widget _buildPhotoPicker() {
    final count = treeImages.length;
    final canAddMore = count < _maxPhotos;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SectionLabel(
                title: 'Tree Photos',
                mandatory: true,
                subtitle: 'Capture clear photos of the planted tree',
                hasError: _photoError,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: count > 0
                    ? _primaryGreen.withOpacity(0.08)
                    : (_photoError ? Colors.red.shade50 : Colors.grey.shade100),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: count > 0
                      ? _primaryGreen.withOpacity(0.3)
                      : (_photoError
                          ? Colors.red.shade300
                          : Colors.grey.shade300),
                ),
              ),
              child: Text(
                '$count / $_maxPhotos',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: count > 0
                      ? _primaryGreen
                      : (_photoError
                          ? Colors.red.shade600
                          : Colors.grey.shade500),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemCount: count + (canAddMore ? 1 : 0),
          itemBuilder: (_, index) {
            if (index == count) return _buildCameraCell();
            return _buildPhotoCell(treeImages[index], index);
          },
        ),
      ],
    );
  }

  Widget _buildPhotoCell(File file, int index) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => AppRoute.goToNextPage(
              context: context,
              screen: FullScreenImageViewer.route,
              arguments: {
                'imagePath': file.path,
                'heroTag': 'plant_photo_$index',
              },
            ),
            child: Hero(
              tag: 'plant_photo_$index',
              child: Image.file(file, fit: BoxFit.cover),
            ),
          ),
        ),
        // Gradient overlay for delete button
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Container(
              height: 36,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x88000000), Colors.transparent],
                ),
              ),
            ),
          ),
        ),
        // Delete button
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _setStateSafe(() => treeImages.removeAt(index)),
            child: Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                  color: Colors.red, shape: BoxShape.circle),
              child: const Icon(Icons.close, size: 13, color: Colors.white),
            ),
          ),
        ),
        // Photo index badge
        Positioned(
          bottom: 4,
          left: 6,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCameraCell() {
    return AbsorbPointer(
      absorbing: _isProcessing,
      child: GestureDetector(
        onTap: _captureImage,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _isProcessing
                ? _primaryGreen.withOpacity(0.08)
                : (_photoError
                    ? Colors.red.shade50
                    : _primaryGreen.withOpacity(0.04)),
            border: Border.all(
              color: _isProcessing
                  ? _primaryGreen.withOpacity(0.5)
                  : (_photoError
                      ? Colors.red.shade300
                      : _primaryGreen.withOpacity(0.35)),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: _isProcessing
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: _primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Processing…',
                      style: TextStyle(
                        fontSize: 10,
                        color: _primaryGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: (_photoError ? Colors.red : _primaryGreen)
                            .withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        size: 20,
                        color:
                            _photoError ? Colors.red.shade400 : _primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Add Photo',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color:
                            _photoError ? Colors.red.shade400 : _primaryGreen,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  //  OPTIONAL — REMARKS
  // ════════════════════════════════════════════════════════
  Widget _buildRemarks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(
          title: 'Remarks',
          mandatory: false,
          subtitle: 'Any additional notes about this plantation',
        ),
        const SizedBox(height: 10),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: remarkController,
          builder: (context, value, _) {
            final charCount = value.text.length;
            final isNearLimit = charCount > _maxRemarkChars * 0.8;
            final isAtLimit = charCount >= _maxRemarkChars;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: remarkController,
                  maxLines: 4,
                  minLines: 3,
                  maxLength: _maxRemarkChars,
                  textInputAction: TextInputAction.done,
                  buildCounter: (_,
                          {required currentLength,
                          required isFocused,
                          maxLength}) =>
                      null,
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                  decoration: InputDecoration(
                    hintText: 'e.g. Planted near fence, soil condition…',
                    hintStyle:
                        TextStyle(color: Colors.grey.shade400, fontSize: 13),
                    prefixIcon: Padding(
                      padding:
                          const EdgeInsets.only(left: 14, right: 10, top: 14),
                      child: Icon(Icons.edit_note_rounded,
                          size: 22, color: Colors.grey.shade400),
                    ),
                    prefixIconConstraints:
                        const BoxConstraints(minWidth: 0, minHeight: 0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: _primaryGreen, width: 1.8),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$charCount / $_maxRemarkChars',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight:
                        isNearLimit ? FontWeight.w600 : FontWeight.normal,
                    color: isAtLimit
                        ? Colors.red
                        : (isNearLimit
                            ? Colors.orange.shade700
                            : Colors.grey.shade400),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════
  //  SUBMIT BUTTON
  // ════════════════════════════════════════════════════════
  Widget _buildSubmitButton() {
    return BlocBuilder<PlantationBloc,
        ApiState<PlantationResponseModel, ResponseModel>>(
      builder: (context, state) {
        final isLoading = state is ApiLoading;
        return SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryGreen,
              disabledBackgroundColor: _primaryGreen.withOpacity(0.6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            onPressed: isLoading ? null : _onSubmit,
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5),
                  )
                : const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColor.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        );
      },
    );
  }
}

// ════════════════════════════════════════════════════════
//  LOCATION PREVIEW MAP (unchanged, kept as is)
// ════════════════════════════════════════════════════════
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
            keepAlive: true,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.none,
            ),
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
