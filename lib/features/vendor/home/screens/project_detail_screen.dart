import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treelove/common/bloc/api_event.dart';
import 'package:treelove/common/repositories/project_repository.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/core/config/themes/app_color.dart';
import 'package:treelove/core/config/themes/app_fonts.dart';
import 'package:treelove/core/network/api_connection.dart';
import 'package:treelove/features/vendor/home/bloc/project_bloc.dart';
import 'package:treelove/features/vendor/home/models/project_detail_model.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../core/config/resource/images.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/widgets/common_notification.dart';
import '../../../../core/widgets/common_refresh_indicator.dart';
import '../../../authentication/screens/sign_in_screen.dart';
import '../../task/screens/task_allocation_screen.dart';
import 'map_screen.dart';

/*
String  ? _selectedAreaId;

class ProjectDetailScreen extends StatefulWidget {
  static const route = "/project-detail-screen";
  final String projectId;

  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  final List<Map<String, dynamic>> _fieldworkers = const [
    {'initials': 'JC', 'name': 'John Cena'},
    {'initials': 'TU', 'name': 'The Undertaker'},
    {'initials': 'SA', 'name': 'Steve Austin'},
  ];

  late ProjectBloc projectBloc;
  ProjectDetailData? _projectData;
  List<Fieldworker> _filteredFieldworkers = [];


  void _filterFieldworkers() {
    if (_projectData == null || _selectedAreaId == null) {
      _filteredFieldworkers = [];
      return;
    }
    _filteredFieldworkers =
        _projectData!.getFieldworkersForArea(_selectedAreaId!);
  }

  ProjectArea? get selectedArea {
    if (_projectData == null || _selectedAreaId == null) return null;
    return _projectData!.projectAreas.firstWhere(
          (a) => a.id == _selectedAreaId,
      orElse: () => ProjectArea(
        id: '',
        name: '',
        capacity: 0,
        location: '',
        serviceSummary: [],
        fieldworkers: [],
      ),
    );
  }


  @override
  void initState() {
    projectBloc = ProjectBloc(ProjectRepository(api: ApiConnection()));
    projectBloc.add(ApiFetch(id: widget.projectId));

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.grey,
      body: BlocProvider(
        create: (context) => projectBloc,
        child: BlocListener<ProjectBloc,
            ApiState<ProjectDetailResponse, ResponseModel>>(
          listener: (context, state) {
            EasyLoading.dismiss();
            if (state is ApiFailure<ProjectDetailResponse, ResponseModel>) {
              showNotification(context,
                  message: state.error.message.toString());
            } else if (state
                is TokenExpired<ProjectDetailResponse, ResponseModel>) {
              AppRoute.pushReplacement(context, SignInScreen.route,
                  arguments: {});
            }
          },
          child: SingleChildScrollView(
            child: BlocBuilder<ProjectBloc, ApiState<ProjectDetailResponse, ResponseModel>>(
              builder: (context, state) {
                if (state is ApiSuccess<ProjectDetailResponse, ResponseModel>){
                  ProjectDetailResponse  projectDetail = state.data;
                  _projectData = projectDetail.data;

                  // ✅ Auto-select the first area ID if available, else null
                  if (_projectData!.projectAreas.isNotEmpty && _selectedAreaId == null) {
                    _selectedAreaId = _projectData!.projectAreas.first.id;
                  }
                  final currentArea = selectedArea;

                  _filterFieldworkers();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(title:projectDetail.data.projectInfo.name,location: projectDetail.data.projectInfo.description,endDate:projectDetail.data.projectInfo.endDate  ),
                      SizedBox(height: 20.h),
                      AreaSection(
                        projectAreas: _projectData!.projectAreas,
                        selectedAreaId: _selectedAreaId,
                        onAreaSelected: (areaId) {
                          setState(() {
                            _selectedAreaId = areaId;
                            _filterFieldworkers();
                          });
                        },
                      ),

                      // AreaSection(areaList: projectDetail.data.allProjectAreaNames,
                       //   selectedAreaId: _selectedAreaId,
                       //   onAreaSelected: (areaId) {
                       //     setState(() {
                       //       _selectedAreaId = areaId;
                       //       _filterFieldworkers();
                       //     });
                       //   },
                       // ),
                      if (currentArea != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _buildInfoCards(context, currentArea), // ✅ dynamic info cards
                        ),

                      SizedBox(height: 16.h),
                      _buildFieldworkersSection(_filteredFieldworkers),
                      // _buildFieldworkersSection(),
                      SizedBox(height: 16.h),
                      if (selectedArea != null)
                        AreaCoordinatesSection(area: selectedArea!),
                    ],
                  );
                }else{
                  return const Center(
                      child: Text(
                      "No staff found",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                ));
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader({required String title,required String location,required String endDate}) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Images.sampleImg),
          fit: BoxFit.cover,
        ),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black.withOpacity(0.8), Colors.transparent],
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderRow(title: title),
            SizedBox(height: 20.h),
            _buildLocationRow(location: location),
            SizedBox(height: 10.h),
            _buildDueDateCard(endDate: endDate),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow({required String title}) {
    return Row(
      children: [
        Container(
          width: 35.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.4),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
            onPressed: () => Navigator.pop(context),
            tooltip: 'Back',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            // 'Thane Plantation Metro Drive 2023',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                    blurRadius: 4, color: Colors.black54, offset: Offset(1, 1)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationRow({required String location}) {
    return  Row(
      children: [
        Icon(
          Icons.location_on,
          color: Colors.white,
          size: 18,
          shadows: [
            Shadow(blurRadius: 4, color: Colors.black54, offset: Offset(1, 1))
          ],
        ),
        SizedBox(width: 6),
        Text(
          location,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            shadows: [
              Shadow(blurRadius: 4, color: Colors.black54, offset: Offset(1, 1))
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDueDateCard({required String endDate}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child:  Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today, color: Colors.green, size: 18),
          SizedBox(width: 6),
          Text(
            'Due: $endDate',
            style: TextStyle(
              color: Colors.green,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildInfoCards(BuildContext context, ProjectArea selectedArea) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ Dynamic Area Name
        Text(
          selectedArea.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 20),

        // ✅ Loop through service summary dynamically
        ...selectedArea.serviceSummary.map((summary) {
          // Map service type name to an icon
          IconData icon;
          switch (summary.serviceTypeName.toLowerCase()) {
            case "plantation":
              icon = Icons.eco;
              break;
            case "maintenance":
              icon = Icons.water_drop;
              break;
            case "monitoring":
              icon = Icons.search;
              break;
            default:
              icon = Icons.task_alt; // fallback
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _InfoCard(
              icon: icon,
              title: summary.serviceTypeName,
              subtitle: "${summary.totalTrees}", // ✅ show tree count
            ),
          );
        }),
      ],
    );
  }


  /*
  Widget _buildFieldworkersSection() {
    return Container(
      width: double.infinity,
      color: AppColor.white,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldworkerHeader(),
          SizedBox(height: 10.h),
          Column(
            children: List.generate(_fieldworkers.length, (index) {
              final worker = _fieldworkers[index];
              return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueGrey,
                      child: Text(
                        worker['initials'],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(worker['name']),
                  ),
                  if (index < _fieldworkers.length - 1)
                    const Divider(height: 1),
                ],
              );
            }),
          ),
          SizedBox(height: 12.h),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                AppRoute.goToNextPage(
                    context: context,
                    screen: TaskAllocationScreen.route,
                    arguments: {});
              },
              icon: const Icon(Icons.add_task),
              label: const Text('Allocate Task'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldworkerHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Fieldworkers (${_fieldworkers.length})',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Manage'),
        ),
      ],
    );
  }

   */
  Widget _buildFieldworkersSection(List<Fieldworker> workers) {
    return Container(
      width: double.infinity,
      color: AppColor.white,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldworkerHeader(workers.length),
          SizedBox(height: 10.h),

          if (workers.isEmpty)
            const Text("No fieldworkers in this area", style: TextStyle(color: Colors.grey)),
          if (workers.isNotEmpty)
            Column(
              children: workers.map((worker) {
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueGrey,
                        child: Text(
                          worker.fullName.isNotEmpty
                              ? worker.fullName.substring(0, 1).toUpperCase()
                              : "?",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(worker.fullName),
                      subtitle: Text(worker.username),
                    ),
                    const Divider(height: 1),
                  ],
                );
              }).toList(),
            ),

          SizedBox(height: 12.h),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                AppRoute.goToNextPage(
                  context: context,
                  screen: TaskAllocationScreen.route,
                  arguments: {},
                );
              },
              icon: const Icon(Icons.add_task),
              label: const Text('Allocate Task'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldworkerHeader(int count) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        'Fieldworkers ($count)',
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text('Manage'),
      ),
    ],
  );

}


class AreaSection extends StatefulWidget {
   // List<String> areaList;
   // final String? selectedAreaId;
   // final ValueChanged<String?> onAreaSelected;
  final List<ProjectArea> projectAreas;
  final String? selectedAreaId;
  final ValueChanged<String> onAreaSelected;
   AreaSection({super.key,required this.projectAreas,
     required this.selectedAreaId,
     required this.onAreaSelected,
   });

  @override
  State<AreaSection> createState() => _AreaSectionState();
}

class _AreaSectionState extends State<AreaSection> {


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChips(),
        const SizedBox(height: 16),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 20),
        //   child: _buildInfoCards(context),
        // ),
      ],
    );
  }
/*
  Widget _buildChips() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.areaList.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final currentArea = widget.areaList[index];
          final isSelected = currentArea == _selectedArea;

          return _AreaChip(
            area: currentArea,
            isSelected: isSelected,
            // onSelected: widget.onTap,
            onSelected: () => setState(() => _selectedArea = currentArea),
          );
        },
      ),
    );
  }

 */
  Widget _buildChips() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.projectAreas.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final area = widget.projectAreas[index];
          final isSelected = area.id == widget.selectedAreaId;

          return ChoiceChip(
            label: Text(
              area.name,
              style: AppFonts.caption.copyWith(
                color: isSelected ? AppColor.primary : Colors.black87,
              ),
            ),
            selected: isSelected,
            onSelected: (_) => widget.onAreaSelected(area.id),
            selectedColor: AppColor.white,
            backgroundColor: Colors.grey.shade100,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: BorderSide(
                color: isSelected ? AppColor.primary : Colors.grey.shade300,
                width: 1.2,
              ),
            ),
            elevation: isSelected ? 1 : 0,
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        },
      ),
    );
  }

  /*
  Widget _buildInfoCards(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thane Ghodbunder',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
        ),
        const SizedBox(height: 20),
        const _InfoCard(
          icon: Icons.eco,
          title: 'Plantation',
          subtitle: '9,786 / 40,000',
        ),
        const SizedBox(height: 10),
        const _InfoCard(
          icon: Icons.water_drop,
          title: 'Maintenance',
          subtitle: '40,000',
        ),
        const SizedBox(height: 10),
        const _InfoCard(
          icon: Icons.search,
          title: 'Monitoring',
          subtitle: '40,000',
        ),
      ],
    );
  }

   */

}

/// A custom widget for displaying an area selection chip.
class _AreaChip extends StatelessWidget {
  const _AreaChip({
    required this.area,
    required this.isSelected,
    required this.onSelected,
  });

  final String area;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(
        area,
        style: AppFonts.caption.copyWith(
          color: isSelected ? AppColor.primary : Colors.black87,
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColor.white,
      backgroundColor: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
        side: BorderSide(
          color: isSelected ? AppColor.primary : Colors.grey.shade300,
          width: 1.2,
        ),
      ),
      elevation: isSelected ? 1 : 0,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor = Colors.green,
    this.backgroundColor = Colors.white,
    this.trailingIcon = Icons.arrow_forward_ios,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final Color backgroundColor;
  final IconData trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon Container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),

          // Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppFonts.body.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppFonts.caption.copyWith(color: AppColor.textMuted),
                ),
              ],
            ),
          ),
          // Optional Trailing Icon
          Icon(
            trailingIcon,
            size: 16,
            color: Colors.grey[500],
          ),
        ],
      ),
    );
  }
}

 */
/*



class AreaCoordinatesSection extends StatefulWidget {
  const AreaCoordinatesSection({super.key});

  @override
  State<AreaCoordinatesSection> createState() => _AreaCoordinatesSectionState();
}

class _AreaCoordinatesSectionState extends State<AreaCoordinatesSection> {
  bool _showCoordinates = false;

  final List<LatLng> _polygonPoints = [
    LatLng(19.124, 72.834),
    LatLng(19.125, 72.835),
    LatLng(19.126, 72.833),
    LatLng(19.124, 72.832),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10.h,
        children: [
          // Title
          Text(
            'Area co-ordinates',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1C1C1C),
            ),
          ),

          // Map Thumbnail with Fullscreen Icon
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 180,
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: _polygonPoints[2],
                      // interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        tileProvider: NetworkTileProvider(
                          headers: {
                            'User-Agent':
                                'TreelovApp/1.0 (https://yourapp.com)',
                          },
                        ),
                        errorTileCallback: (TileImage, Object, StackTrace) {
                          debugPrint('Tile error: $Object');
                        },
                        // userAgentPackageName: 'com.example.app',
                      ),
                      PolygonLayer(
                        polygons: [
                          Polygon(
                            points: _polygonPoints,
                            color: Colors.green.withOpacity(0.3),
                            borderColor: Colors.red,
                            borderStrokeWidth: 2,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.fullscreen,
                        color: Colors.white, size: 20),
                    onPressed: () {
                      AppRoute.goToNextPage(
                          context: context,
                          screen: VendorMapScreen.route,
                          arguments: {});
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

 */

/*
import 'package:flutter_screenutil/flutter_screenutil.dart'; // If using ScreenUtil

// Assuming AppRoute, AppColor, AppFonts, Images are defined elsewhere

 */

class ProjectDetailScreen extends StatefulWidget {
  static const route = "/project-detail-screen";
  final String projectId;

  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  late final ProjectBloc _projectBloc;
  ProjectDetailData? _projectData;
  String? _selectedAreaId;
  List<Fieldworker> _filteredFieldworkers = [];

  /// Filters fieldworkers based on the currently selected area ID.
  void _filterFieldworkers() {
    if (_projectData == null || _selectedAreaId == null) {
      _filteredFieldworkers = [];
      return;
    }
    try {
      _filteredFieldworkers =
          _projectData!.getFieldworkersForArea(_selectedAreaId!);
    } catch (e) {
      // Handle potential errors in getFieldworkersForArea if needed
      debugPrint("Error filtering fieldworkers: $e");
      _filteredFieldworkers = [];
    }
  }

  /// Gets the currently selected ProjectArea object.
  ProjectArea? get _selectedArea {
    if (_projectData == null || _selectedAreaId == null) return null;
    try {
      return _projectData!.projectAreas
          .firstWhere((a) => a.id == _selectedAreaId);
    } catch (e) {
      // Return null or a default object if area not found
      debugPrint("Selected area not found in project data: $_selectedAreaId");
      return null; // Or return a default ProjectArea()
    }
  }

  @override
  void initState() {
    super.initState();
    _projectBloc = ProjectBloc(ProjectRepository(api: ApiConnection()));
    _projectBloc.add(ApiFetch(id: widget.projectId));
  }

  @override
  void dispose() {
    _projectBloc.close();
    super.dispose();
  }

  Future<void> _refreshData() async {
    _projectBloc.add(ApiFetch(id: widget.projectId));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.grey,
      body: CommonRefreshIndicator(
        onRefresh: _refreshData,
        isLoading: false,
        child: BlocProvider<ProjectBloc>.value(
          // Use .value since it's already created
          value: _projectBloc,
          child: BlocListener<ProjectBloc,
              ApiState<ProjectDetailResponse, ResponseModel>>(
            listener: (context, state) {
              EasyLoading.dismiss();
              if (state is ApiFailure<ProjectDetailResponse, ResponseModel>) {
                showNotification(context,
                    message: state.error.message ?? "An error occurred");
              } else if (state
                  is TokenExpired<ProjectDetailResponse, ResponseModel>) {
                AppRoute.pushReplacement(context, SignInScreen.route,
                    arguments: {});
              } else if (state
                  is ApiSuccess<ProjectDetailResponse, ResponseModel>) {
                final data = state.data.data;
                if (_selectedAreaId == null && data.projectAreas.isNotEmpty) {
                  setState(() {
                    _selectedAreaId = data.projectAreas.first.id;
                  });
                }
              }
            },
            child: SingleChildScrollView(
              child: BlocBuilder<ProjectBloc,
                  ApiState<ProjectDetailResponse, ResponseModel>>(
                builder: (context, state) {
                  if (state is ApiLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state
                      is ApiSuccess<ProjectDetailResponse, ResponseModel>) {
                    final ProjectDetailResponse projectDetail = state.data;
                    _projectData = projectDetail.data;
        
                    // Auto-select the first area ID if available and none is selected
                    if (_projectData != null &&
                        _projectData!.projectAreas.isNotEmpty &&
                        _selectedAreaId == null) {
                      setState(() {
                        _selectedAreaId = _projectData!.projectAreas.first.id;
                      });
                    }
        
                    // Ensure filtering happens after data and selection are updated
                    _filterFieldworkers();
        
                    final ProjectArea? currentArea =
                        _selectedArea; // Get the selected area object
        
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(
                          title: projectDetail.data.projectInfo.name,
                          location: projectDetail.data.projectInfo.description,
                          endDate: projectDetail.data.projectInfo.endDate,
                        ),
                        SizedBox(height: 5.h),
                        Center(
                          child: Text(
                            "↓ Pull down to refresh",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        if (_projectData !=
                            null) // Check if data exists before building AreaSection
                          AreaSection(
                            projectAreas: _projectData!.projectAreas,
                            selectedAreaId: _selectedAreaId,
                            onAreaSelected: (areaId) {
                              setState(() {
                                _selectedAreaId = areaId;
                                // Filtering is now done in _filterFieldworkers
                              });
                            },
                          ),
                        SizedBox(height: 16.h),
                        if (currentArea != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: _buildInfoCards(context, currentArea),
                          ),
                        SizedBox(height: 16.h),
                        _buildFieldworkersSection(_filteredFieldworkers),
                        SizedBox(height: 16.h),
                        if (currentArea !=
                            null) // Use currentArea for consistency
                          AreaCoordinatesSection(area: currentArea),
                      ],
                    );
                  } else if (state
                      is ApiFailure<ProjectDetailResponse, ResponseModel>) {
                    // Show specific error message if available, otherwise generic
                    final errorMessage =
                        state.error.message ?? "Failed to load project details.";
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            errorMessage,
                            style:
                                const TextStyle(fontSize: 16, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                            onPressed: () {
                              _projectBloc
                                  .add(ApiFetch(id: widget.projectId)); // Retry
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Includes initial state or unexpected states
                    return const Center(
                      child: Text(
                        "Loading project details...",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader({
    required String title,
    required String location,
    required String endDate,
  }) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Images.sampleImg), // Ensure this asset exists
          fit: BoxFit.cover,
        ),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black.withOpacity(0.8), Colors.transparent],
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderRow(title: title),
            SizedBox(height: 20.h),
            _buildLocationRow(location: 'Thane,Mumbai'),
            SizedBox(height: 10.h),
            _buildDueDateCard(endDate: endDate),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow({required String title}) {
    return Row(
      children: [
        Container(
          width: 35.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.4),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
            onPressed: () => Navigator.pop(context),
            tooltip: 'Back',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                    blurRadius: 4, color: Colors.black54, offset: Offset(1, 1)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationRow({required String location}) {
    return Row(
      children: [
        Icon(
          Icons.location_on,
          color: Colors.white,
          size: 18,
          shadows: const [
            Shadow(
                blurRadius: 4,
                color: Colors.black54,
                offset: const Offset(1, 1))
          ],
        ),
        const SizedBox(width: 6),
        Text(
          location,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            shadows: const [
              Shadow(
                  blurRadius: 4,
                  color: Colors.black54,
                  offset: const Offset(1, 1))
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDueDateCard({required String endDate}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.calendar_today, color: Colors.green, size: 18),
          const SizedBox(width: 6),
          Text(
            'Due: $endDate',
            style: const TextStyle(
              color: Colors.green,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCards(BuildContext context, ProjectArea selectedArea) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          selectedArea.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
        ),
        const SizedBox(height: 20),
        if (selectedArea.serviceSummary.isEmpty)
          const Text(
            "No service summary available for this area.",
            style: TextStyle(color: Colors.grey),
          ),
        ...selectedArea.serviceSummary.map((summary) {
          IconData icon = Icons.task_alt_outlined; // Default icon
          switch (summary.serviceType.toLowerCase()) {
            case "plantation":
              icon = Icons.eco;
              break;
            case "maintenance":
              icon = Icons.water_drop;
              break;
            case "monitoring":
              icon = Icons.search;
              break;
            // Add more cases as needed
          }
          // Show both required and done, robust to nulls
          final int required = summary.totalRequired;
          final int done = summary.totalDone;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _InfoCard(
              icon: icon,
              title: summary.serviceType,
              subtitle: "$done/$required",
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildFieldworkersSection(List<Fieldworker> workers) {
    return Container(
      width: double.infinity,
      color: AppColor.white,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldworkerHeader(workers.length),
          SizedBox(height: 10.h),
          if (workers.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "No fieldworkers assigned to this area.",
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            )
          else
            Column(
              children: workers.map((worker) {
                return Column(
                  children: [
                    ListTile(
                      contentPadding:
                          EdgeInsets.zero, // Adjust padding if needed
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueGrey,
                        child: Text(
                          worker.fullName.isNotEmpty
                              ? worker.fullName
                                  .trim()
                                  .split(' ')
                                  .first
                                  .substring(0, 1)
                                  .toUpperCase()
                              : "?",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(worker.fullName),
                      subtitle: Text(worker.username),
                      // Consider adding onTap if needed
                    ),
                    const Divider(height: 1),
                  ],
                );
              }).toList(),
            ),
          SizedBox(height: 12.h),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                // Pass projectAreaId and serviceSummary to TaskAllocationScreen
                final area = _selectedArea;
                AppRoute.goToNextPage(
                  context: context,
                  screen: TaskAllocationScreen.route,
                  arguments: {
                    'projectAreaId': _selectedAreaId,
                    'serviceSummary': area?.serviceSummary
                  },
                );
              },
              icon: const Icon(Icons.add_task),
              label: const Text('Allocate Task'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldworkerHeader(int count) => Text(
        'Fieldworkers ($count)',
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      );
}

/// A custom widget for displaying an area selection chip.

/// A custom widget for displaying service summary information cards.
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.green, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppFonts.body.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppFonts.caption.copyWith(color: AppColor.textMuted),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey[500],
          ),
        ],
      ),
    );
  }
}

/// Widget to display area selection chips.
class AreaSection extends StatefulWidget {
  final List<ProjectArea> projectAreas;
  final String? selectedAreaId;
  final ValueChanged<String> onAreaSelected; // Changed to non-nullable String

  const AreaSection({
    super.key,
    required this.projectAreas,
    required this.selectedAreaId,
    required this.onAreaSelected,
  });

  @override
  State<AreaSection> createState() => _AreaSectionState();
}

class _AreaSectionState extends State<AreaSection> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50, // Adjust height if needed
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.projectAreas.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final area = widget.projectAreas[index];
          final isSelected = area.id == widget.selectedAreaId;
          return ChoiceChip(
            label: Text(
              area.name,
              style: AppFonts.caption.copyWith(
                color: isSelected ? AppColor.primary : Colors.black87,
              ),
            ),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                // Only trigger if selected (prevents deselection)
                widget.onAreaSelected(area.id);
              }
            }, // Pass the area ID
            selectedColor: AppColor.white,
            backgroundColor: Colors.grey.shade100,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: BorderSide(
                color: isSelected ? AppColor.primary : Colors.grey.shade300,
                width: 1.2,
              ),
            ),
            elevation: isSelected ? 1 : 0,
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        },
      ),
    );
  }
}
/*
class AreaCoordinatesSection extends StatelessWidget {
  final ProjectArea area; //  Dynamic area from selected chip

  const AreaCoordinatesSection({super.key, required this.area});

  @override
  Widget build(BuildContext context) {
    //  Parse GeoJSON → Polygon Coordinates
    final List<LatLng> polygonPoints = _convertGeoJSONToLatLng(area);

    // Find center (fallback if not available)
    final LatLng initialCenter =
        polygonPoints.isNotEmpty ? polygonPoints.first : LatLng(19.124, 72.834);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  Title with area name
          Text(
            "Area Coordinates (${area.name})",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1C1C1C),
            ),
          ),
          const SizedBox(height: 10),

          //  Map Thumbnail with Fullscreen Icon
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 180,
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: initialCenter,
                      initialZoom: 15,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        tileProvider: NetworkTileProvider(
                          headers: {'User-Agent': 'TreelovApp/1.0'},
                        ),
                      ),

                      //  Show polygon only if valid
                      if (polygonPoints.isNotEmpty)
                        PolygonLayer(
                          polygons: [
                            Polygon(
                              points: area.polygon,
                              color: Colors.green.withOpacity(0.3),
                              borderColor: Colors.red,
                              borderStrokeWidth: 2,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.fullscreen,
                        color: Colors.white, size: 20),
                    onPressed: () {
                      AppRoute.goToNextPage(
                        context: context,
                        screen: VendorMapScreen.route,
                        arguments: {
                          'areaId':area.id,
                          // "polygon": polygonPoints,
                          // "areaName": area.name,
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Helper to parse GeoJSON → List<LatLng>
  List<LatLng> _convertGeoJSONToLatLng(ProjectArea area) {
    try {
      final polygonCoords = area.polygonCoordinates;
      if (polygonCoords == null || polygonCoords.isEmpty) return [];

      // GeoJSON standard → [[[lng, lat], [lng, lat], ...]]
      final List<List<double>> outerRing = polygonCoords.first;

      return outerRing
          .map((coord) => LatLng(coord[1], coord[0])) // lat = 1, lng = 0
          .toList();
    } catch (e) {
      debugPrint("GeoJSON parsing failed for area ${area.name}: $e");
      return [];
    }
  }
}

 */

class AreaCoordinatesSection extends StatelessWidget {
  final ProjectArea area; // Dynamic area from selected chip

  const AreaCoordinatesSection({super.key, required this.area});

  @override
  Widget build(BuildContext context) {
    // Use polygonLatLngs directly from ProjectArea
    final List<LatLng> polygonPoints = area.polygonLatLngs;

    // Use effectiveCenter (centroid if available, otherwise polygon center, otherwise fallback)
    // final LatLng initialCenter = area.effectiveCenter.latitude != 0 ||
    //     area.effectiveCenter.longitude != 0
    //     ? area.effectiveCenter
    //     : const LatLng(19.124, 72.834);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with area name
          Text(
            "Area Coordinates (${area.name})",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1C1C1C),
            ),
          ),
          const SizedBox(height: 10),

          // Map Thumbnail with Fullscreen Icon
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 180,
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter:LatLng(polygonPoints.last.latitude, polygonPoints.first.longitude),
                      initialZoom: 12,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        tileProvider: NetworkTileProvider(
                          headers: {'User-Agent': 'TreelovApp/1.0'},
                        ),
                      ),

                      // Show polygon only if valid
                      if (polygonPoints.isNotEmpty)
                        PolygonLayer(
                          polygons: [
                            Polygon(
                              points: polygonPoints,
                              color: Colors.green.withOpacity(0.3),
                              borderColor: Colors.red,
                              borderStrokeWidth: 2,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.fullscreen,
                        color: Colors.white, size: 20),
                    onPressed: () {
                      AppRoute.goToNextPage(
                        context: context,
                        screen: VendorMapScreen.route,
                        arguments: {
                          'areaId': area.id,
                          // you can also pass polygonPoints here if needed
                          // "polygon": polygonPoints,
                          // "areaName": area.name,
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

