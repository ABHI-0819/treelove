import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treelove/common/repositories/maintenance_repository.dart';
import 'package:treelove/core/config/themes/app_fonts.dart';
import 'package:treelove/features/fieldworker/activity/bloc/maintenance_bloc.dart';
import '../../../../common/bloc/api_event.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../core/config/constants/enum/navigation_enum.dart';
import '../../../../core/config/constants/enum/notification_enum.dart';
import '../../../../core/config/route/app_route.dart';
import '../../../../core/config/themes/app_color.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/network/api_connection.dart';
import '../../../../core/services/watermark_service.dart';
import '../../../../core/utils/location_permission_helper.dart';
import '../../../../core/widgets/common_notification.dart';
import '../../../../core/widgets/common_tree_diseases.dart';
import '../../../../core/widgets/image_viewe.dart';
import '../../../authentication/screens/sign_in_screen.dart';
import '../../activity/models/maintenance_activity_response_model.dart';
import '../../activity/models/maintenance_created_response_model.dart';
import '../../activity/models/maintenance_request_model.dart';

class MaintenanceActivityScreen extends StatefulWidget {
  static const route = "/maintenance-activity";
  final String plantationId;
  final String serviceId;

  const MaintenanceActivityScreen({
    super.key,
    required this.plantationId,
    required this.serviceId,
  });

  @override
  _MaintenanceActivityScreenState createState() =>
      _MaintenanceActivityScreenState();
}

class _MaintenanceActivityScreenState extends State<MaintenanceActivityScreen> {
  // ── Form State ───────────────────────────────────────────
  String? selectedHealth;
  String? selectedGrowthStage;
  final List<String> selectedMaintenanceActivities = [];
  final List<File> treeImages = [];
  final List<String> treeDiseases = [];
  DateTime? nextMaintenanceDate;

  // ── Validation: only show errors after first submit tap ──
  bool _submitted = false;
  bool get _activityError =>
      _submitted && selectedMaintenanceActivities.isEmpty;
  bool get _healthError => _submitted && selectedHealth == null;
  bool get _growthError => _submitted && selectedGrowthStage == null;
  bool get _photoError => _submitted && treeImages.isEmpty;

  // ── Camera state ─────────────────────────────────────────
  bool _isProcessing = false;

  // ── Controllers / Services ───────────────────────────────
  final TextEditingController remarkController = TextEditingController();
  final WatermarkCameraService _service = WatermarkCameraService();

  // ── BLoCs ────────────────────────────────────────────────
  late final MaintenanceBloc maintenanceBloc;
  late final MaintenanceActivityBloc maintenanceActivityBloc;

  // ── Constants ────────────────────────────────────────────
  static const int _maxPhotos = 3;
  static const int _maxRemarkChars = 100;
  static const Color _primaryGreen = Color(0xFF004D40);
  static const Color _lightGreen = Color(0xFF00695C);

  // ── Icon Map (O(1) lookup, built once at compile time) ───
  static const Map<String, IconData> _activityIconMap = {
    'water': Icons.water_drop,
    'fertiliz': Icons.local_shipping,
    'ferti': Icons.local_shipping,
    'pesticide': Icons.local_hospital,
    'pest': Icons.local_hospital,
    'fenc': Icons.border_all,
    'trim': Icons.ac_unit_sharp,
    'prune': Icons.ac_unit_sharp,
  };

  // ── ButtonStyle cache (built once per instance) ──────────
  late final ButtonStyle _selectedStyle = OutlinedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    side: BorderSide(color: Colors.green.shade700, width: 2),
    backgroundColor: Colors.green.shade50,
  );
  late final ButtonStyle _unselectedStyle = OutlinedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    side: BorderSide(color: Colors.grey.shade300, width: 1.5),
  );
  // Red outline used for un-selected buttons in error state
  static final ButtonStyle _errorStyle = OutlinedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    side: BorderSide(color: Colors.red.shade300, width: 1.5),
  );

  // ── Lifecycle ────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    maintenanceBloc = MaintenanceBloc(
      MaintenanceRepository(api: ApiConnection()),
    );
    maintenanceActivityBloc = MaintenanceActivityBloc(
      MaintenanceRepository(api: ApiConnection()),
    )..add(ApiListFetch());
  }

  @override
  void dispose() {
    remarkController.dispose();
    maintenanceBloc.close();
    maintenanceActivityBloc.close();
    super.dispose();
  }

  void _setStateSafe(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  // ── Camera — smooth watermark flow ───────────────────────
  // Key points:
  //  1. _isProcessing flips to true BEFORE the camera opens so
  //     the grid cell immediately shows the spinner.
  //  2. captureAndSaveImage() applies the watermark internally;
  //     the UI stays responsive because Flutter runs this on its
  //     own async queue — we never block the main isolate.
  //  3. The finally block always resets _isProcessing, even when
  //     the user cancels the camera without taking a photo.
  //  4. PlatformException is caught separately for cleaner messages.
  Future<void> _captureImage() async {
    if (_isProcessing) return;
    if (treeImages.length >= _maxPhotos) {
      _showSnack('Maximum $_maxPhotos photos allowed.');
      return;
    }

    _setStateSafe(() => _isProcessing = true);

    try {
      final file = await _service.captureAndSaveImage();
      if (file != null && mounted) {
        _setStateSafe(() => treeImages.add(file));
      }
    } on PlatformException catch (e) {
      _showSnack('Camera error: ${e.message ?? 'Unknown error'}');
    } catch (e) {
      _showSnack('Could not capture photo. Please try again.');
      debugPrint('captureImage error: $e');
    } finally {
      // Always reset — handles cancel + error + success uniformly
      _setStateSafe(() => _isProcessing = false);
    }
  }

  // ── Submit ───────────────────────────────────────────────
  Future<void> _onSubmit() async {
    // Turn on inline error highlighting before showing any snackbar
    _setStateSafe(() => _submitted = true);

    if (selectedMaintenanceActivities.isEmpty) {
      showNotification(
          type: Not.warning,
          context,
          message: 'Please select at least one maintenance activity.');
      return;
    }
    if (selectedHealth == null) {
      showNotification(
          type: Not.warning, context, message: 'Please select tree health.');
      return;
    }
    if (selectedGrowthStage == null) {
      showNotification(
          type: Not.warning,
          context,
          message: 'Please select tree growth stage.');
      return;
    }
    if (treeImages.isEmpty) {
      showNotification(
          type: Not.warning,
          context,
          message: 'Please capture at least one tree photo.');
      return;
    }

    EasyLoading.show();

    try {
      await _getCurrentLocation().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          EasyLoading.dismiss();
          _showSnack('Could not fetch location. Please try again.');
          throw TimeoutException('Location timeout');
        },
      );

      final request = MaintenanceRequestModel(
        plantation: [widget.plantationId],
        maintenanceDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        location: {
          'type': 'Point',
          'coordinates': [_lng, _lat],
        },
        treeDiseases: treeDiseases.isEmpty ? null : treeDiseases,
        treeHealth: selectedHealth,
        treeGrowth: selectedGrowthStage,
        maintenanceActivity: selectedMaintenanceActivities,
        remarks: remarkController.text.trim(),
        media: treeImages,
        nextScheduledDate: nextMaintenanceDate != null
            ? DateFormat('yyyy-MM-dd').format(nextMaintenanceDate!)
            : null,
        services: widget.serviceId,
      );

      maintenanceBloc.add(ApiAdd(request));
    } on TimeoutException {
      // handled in onTimeout callback above
    } catch (e) {
      EasyLoading.dismiss();
      _showSnack('Submission failed: $e');
    }
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  // ── Location ─────────────────────────────────────────────
  double _lat = 0.0;
  double _lng = 0.0;

  Future<void> _getCurrentLocation() async {
    final hasPermission = await handleLocationPermission(context);
    if (!hasPermission) return;
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _lat = position.latitude;
    _lng = position.longitude;
  }

  // ── Icon Lookup ──────────────────────────────────────────
  IconData _getIconForActivity(String name) {
    final lower = name.toLowerCase();
    for (final entry in _activityIconMap.entries) {
      if (lower.contains(entry.key)) return entry.value;
    }
    return Icons.build;
  }

  // ════════════════════════════════════════════════════════
  //  BUILD
  // ════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: maintenanceBloc),
        BlocProvider.value(value: maintenanceActivityBloc),
      ],
      child: Scaffold(
        backgroundColor: AppColor.white,
        appBar: _buildAppBar(),
        body: BlocConsumer<MaintenanceBloc,
            ApiState<MaintenanceResponse, ResponseModel>>(
          listener: _blocListener,
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),

                    // ── MANDATORY FIELDS ───────────────────
                    _buildMaintenanceActivities(),
                    SizedBox(height: 20.h),
                    _buildGrowthStage(),
                    SizedBox(height: 20.h),
                    _buildTreeHealth(),
                    SizedBox(height: 20.h),
                    _buildPhotoPicker(),

                    // ── OPTIONAL FIELDS ────────────────────
                    SizedBox(height: 20.h),
                    CommonTreeDiseasesWidget(
                      onChanged: (selectedDiseases) {
                        treeDiseases
                          ..clear()
                          ..addAll(selectedDiseases.map((d) => d.id));
                      },
                    ),
                    SizedBox(height: 20.h),
                    _buildRemarks(),
                    SizedBox(height: 20.h),
                    _buildNextMaintenanceDate(),
                    SizedBox(height: 20.h),
                    _buildSubmitButton(state),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── BLoC Listener ────────────────────────────────────────
  void _blocListener(BuildContext context,
      ApiState<MaintenanceResponse, ResponseModel> state) {
    EasyLoading.dismiss();
    if (state is ApiSuccess<MaintenanceResponse, ResponseModel>) {
      _showSnack(
          state.data.message ?? 'Maintenance activity submitted successfully');
      AppRoute.safePopWithResult(context, NavigationResult.success);
    } else if (state is ApiFailure<MaintenanceResponse, ResponseModel>) {
      showNotification(
          type: Not.failed, context, message: state.error.data.toString());
    } else if (state is TokenExpired<MaintenanceResponse, ResponseModel>) {
      AppRoute.pushReplacement(context, SignInScreen.route, arguments: {});
    }
  }

  // ════════════════════════════════════════════════════════
  //  SHARED LABEL BUILDERS
  // ════════════════════════════════════════════════════════

  /// Mandatory label: "Title *"
  /// Optional label : "Title  [Optional pill]"
  Widget _sectionLabel({
    required String title,
    required bool mandatory,
    String? subtitle,
    bool hasError = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: hasError ? Colors.red.shade700 : const Color(0xFF1A1A1A),
              ),
            ),
            if (mandatory) ...[
              const SizedBox(width: 2),
              Text(
                '*',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: hasError ? Colors.red.shade700 : Colors.red,
                  height: 1.1,
                ),
              ),
            ] else ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  'Optional',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
        // Inline "required" error text
        if (hasError) ...[
          const SizedBox(height: 3),
          Row(
            children: [
              Icon(Icons.error_outline, size: 12, color: Colors.red.shade500),
              const SizedBox(width: 4),
              Text(
                'This field is required',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.red.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  /// Lightweight optional section header used for widgets that
  /// render their own content (e.g. CommonTreeDiseasesWidget).
  Widget _buildOptionalSectionHeader({
    required String title,
    String? subtitle,
  }) {
    return _sectionLabel(
      title: title,
      mandatory: false,
      subtitle: subtitle,
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
            Text('Tree Care',
                style: AppFonts.body.copyWith(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600)),
            Text('Making nature healthier',
                style: AppFonts.regular
                    .copyWith(color: Colors.white70, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  //  SUBMIT BUTTON
  // ════════════════════════════════════════════════════════
  Widget _buildSubmitButton(
      ApiState<MaintenanceResponse, ResponseModel> state) {
    final isLoading = state is ApiLoading;
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryGreen,
          disabledBackgroundColor: _primaryGreen.withOpacity(0.6),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            : const Text('Submit',
                style: TextStyle(
                    fontSize: 16,
                    color: AppColor.white,
                    fontWeight: FontWeight.w600)),
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  //  MANDATORY — MAINTENANCE ACTIVITY
  // ════════════════════════════════════════════════════════
  Widget _buildMaintenanceActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(
          title: 'Maintenance Activity',
          mandatory: true,
          subtitle: 'Select all activities performed today',
          hasError: _activityError,
        ),
        const SizedBox(height: 10),
        BlocBuilder<MaintenanceActivityBloc,
            ApiState<MaintenanceActivityResponseModel, ResponseModel>>(
          builder: (context, state) {
            if (state is ApiLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }
            if (state is ApiSuccess<MaintenanceActivityResponseModel,
                ResponseModel>) {
              final activities = state.data.data;
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activities.length,
                itemBuilder: (_, i) => _buildActivityCard(activities[i]),
              );
            }
            if (state is ApiFailure || state is TokenExpired) {
              return Column(children: [
                const Text('Failed to load activities',
                    style: TextStyle(color: Colors.red)),
                TextButton(
                  onPressed: () => context
                      .read<MaintenanceActivityBloc>()
                      .add(ApiListFetch()),
                  child: const Text('Retry'),
                ),
              ]);
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildActivityCard(Activity activity) {
    final isSelected = selectedMaintenanceActivities.contains(activity.id);
    return GestureDetector(
      onTap: () => _setStateSafe(() {
        isSelected
            ? selectedMaintenanceActivities.remove(activity.id)
            : selectedMaintenanceActivities.add(activity.id);
      }),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
              color: isSelected
                  ? Colors.green.shade700
                  : (_activityError
                      ? Colors.red.shade300
                      : Colors.grey.shade300)),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.green.shade50 : null,
        ),
        child: Row(
          children: [
            Icon(_getIconForActivity(activity.name),
                color: Colors.green.shade700),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(activity.name,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500)),
                  if (activity.description.isNotEmpty)
                    Text(activity.description,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded,
                  color: Colors.green.shade700, size: 20),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  //  MANDATORY — TREE GROWTH STAGE
  // ════════════════════════════════════════════════════════
  Widget _buildGrowthStage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(
          title: 'Tree Growth Stage',
          mandatory: true,
          hasError: _growthError,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            ('Sapling', 'sapling'),
            ('Young', 'young'),
            ('Mature', 'mature'),
            ('Half Grown', 'half_grown'),
            ('Fully Grown', 'fully_grown'),
          ].map((t) => _buildButton(t.$1, t.$2)).toList(),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════
  //  MANDATORY — TREE HEALTH
  // ════════════════════════════════════════════════════════
  Widget _buildTreeHealth() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(
          title: 'Tree Health',
          mandatory: true,
          hasError: _healthError,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            ('Healthy', '🌳', 'healthy'),
            ('Good', '😊', 'good'),
            ('Better', '🙂', 'better'),
            ('Bad', '☹️', 'bad'),
            ('Worse', '💀', 'worse'),
            ('Require Attention', '🛠️', 'require_attention'),
          ].map((t) => _buildButtonWithEmoji(t.$1, t.$2, t.$3)).toList(),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════
  //  MANDATORY — PHOTO PICKER
  // ════════════════════════════════════════════════════════
  Widget _buildPhotoPicker() {
    final count = treeImages.length;
    final canAddMore = count < _maxPhotos;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row: label (with *) + count badge
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _sectionLabel(
                title: 'Tree Photos',
                mandatory: true,
                subtitle: 'Capture clear photos from multiple angles',
                hasError: _photoError,
              ),
            ),
            const SizedBox(width: 12),
            // X / 6 counter badge
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

        // 3-column photo grid
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

  /// Single photo thumbnail with gradient, delete button, index badge
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
                'heroTag': 'photo_$index',
              },
            ),
            child: Hero(
              tag: 'photo_$index',
              child: Image.file(file, fit: BoxFit.cover),
            ),
          ),
        ),
        // Top gradient for legible delete button
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
        // Delete ✕
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
        // Photo number badge bottom-left
        Positioned(
          bottom: 4,
          left: 6,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text('${index + 1}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  /// Camera add-button cell.
  /// Shows a "Processing…" spinner while watermark is being applied so the
  /// user gets immediate visual feedback that something is happening.
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
              // ── PROCESSING: spinner + label ───────────────
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
              // ── IDLE: camera icon + label ─────────────────
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
        _sectionLabel(
          title: 'Remarks',
          mandatory: false,
          subtitle: 'Any observations about the tree condition',
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
                      null, // custom counter rendered below
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                  decoration: InputDecoration(
                    hintText:
                        'e.g. Leaves showing signs of yellowing on north side…',
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
                    // All 4 border states — prevents Flutter default blue focus ring
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
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 1.2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 1.8),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 4),
                // Character counter — turns orange near limit, red at limit
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
  //  OPTIONAL — NEXT MAINTENANCE DATE
  // ════════════════════════════════════════════════════════
  Widget _buildNextMaintenanceDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(
          title: 'Next Maintenance Date',
          mandatory: false,
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now().add(const Duration(days: 1)),
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              _setStateSafe(() => nextMaintenanceDate = picked);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300, width: 1.2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D000000),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Icon(Icons.calendar_today_rounded,
                      color: Color(0xFF1A5F3E), size: 20),
                  const SizedBox(width: 12),
                  Text(
                    nextMaintenanceDate != null
                        ? DateFormat('EEE, MMM d, yyyy')
                            .format(nextMaintenanceDate!)
                        : 'Select date',
                    style: TextStyle(
                      fontSize: 15,
                      color: nextMaintenanceDate != null
                          ? Colors.black
                          : Colors.grey.shade500,
                    ),
                  ),
                ]),
                // Clear button when date is selected
                if (nextMaintenanceDate != null)
                  GestureDetector(
                    onTap: () =>
                        _setStateSafe(() => nextMaintenanceDate = null),
                    child: Icon(Icons.close,
                        size: 16, color: Colors.grey.shade500),
                  )
                else
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 14, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════
  //  BUTTON HELPERS (health + growth stage)
  // ════════════════════════════════════════════════════════
  Widget _buildButtonWithEmoji(String label, String emoji, String value) {
    final isSelected = selectedHealth == value;
    return OutlinedButton(
      onPressed: () =>
          _setStateSafe(() => selectedHealth = isSelected ? null : value),
      style: isSelected
          ? _selectedStyle
          : (_healthError ? _errorStyle : _unselectedStyle),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildButton(String label, String value) {
    final isSelected = selectedGrowthStage == value;
    return OutlinedButton(
      onPressed: () =>
          _setStateSafe(() => selectedGrowthStage = isSelected ? null : value),
      style: isSelected
          ? _selectedStyle
          : (_growthError ? _errorStyle : _unselectedStyle),
      child: Text(label),
    );
  }
}
