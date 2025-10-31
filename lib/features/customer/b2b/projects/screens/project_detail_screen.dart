import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treelove/core/config/themes/app_color.dart';

import '../../../../../common/bloc/api_event.dart';
import '../../../../../common/bloc/api_state.dart';
import '../../../../../common/models/response.mode.dart';
import '../../../../../common/repositories/project_repository.dart';
import '../../../../../core/config/route/app_route.dart';
import '../../../../../core/network/api_connection.dart';
import '../../../../authentication/screens/sign_in_screen.dart';
import '../bloc/b2b_project_bloc.dart';
import '../model/b2b_project_detail_response_model.dart';

class ProjectB2BDetailsScreen extends StatefulWidget {
  static const route = "/b2b-project-detail";
  final String projectId;
  const ProjectB2BDetailsScreen({super.key, required this.projectId});

  @override
  _ProjectB2BDetailsScreenState createState() =>
      _ProjectB2BDetailsScreenState();
}

class _ProjectB2BDetailsScreenState extends State<ProjectB2BDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int selectedAreaIndex = 0;

  // Sample data - multiple areas
  final List<Map<String, dynamic>> projectAreas = [
    {
      "id": "3c7a426b-da29-4858-82ce-e3327464ba6a",
      "name": "Mahalaxmi Open Ground",
      "capacity": 10000,
      "service_summary": [
        {
          "service_type": "Maintenance",
          "total_required": 1000,
          "total_done": 250
        },
        {
          "service_type": "Monitoring",
          "total_required": 1000,
          "total_done": 180
        },
        {
          "service_type": "Plantation",
          "total_required": 1000,
          "total_done": 450
        }
      ]
    },
    {
      "id": "4d8b537c-eb3a-5959-93df-f4438575cb7b",
      "name": "Mahalaxmi Garden Area",
      "capacity": 5000,
      "service_summary": [
        {
          "service_type": "Maintenance",
          "total_required": 500,
          "total_done": 350
        },
        {
          "service_type": "Monitoring",
          "total_required": 500,
          "total_done": 400
        },
        {"service_type": "Plantation", "total_required": 500, "total_done": 500}
      ]
    },
    {
      "id": "5e9c648d-fc4b-6a6a-a4ee-05549686dc8c",
      "name": "Mahalaxmi Walkway",
      "capacity": 3000,
      "service_summary": [
        {
          "service_type": "Maintenance",
          "total_required": 300,
          "total_done": 150
        },
        {
          "service_type": "Monitoring",
          "total_required": 300,
          "total_done": 300
        },
        {"service_type": "Plantation", "total_required": 300, "total_done": 300}
      ]
    }
  ];

  late B2BProjectBloc b2bProjectBloc;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    _animationController.forward();
    b2bProjectBloc = B2BProjectBloc(ProjectRepository(api: ApiConnection()));
    // b2bProjectBloc = BlocProvider.of<B2BProjectBloc>(context);
    b2bProjectBloc.add(ApiFetch(id: widget.projectId));
  }

  @override
  void dispose() {
    _animationController.dispose();
    b2bProjectBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: BlocProvider(
              create: (context) => b2bProjectBloc,
              child: BlocListener<B2BProjectBloc,
                  ApiState<B2BProjectDetailResponseModel, ResponseModel>>(
                listener: (context, state) {
                  if (state is TokenExpired<B2BProjectDetailResponseModel,
                      ResponseModel>) {
                    // Handle token expiration
                    AppRoute.pushReplacement(
                        context, SignInScreen.route, arguments: {});
                  }
                },
                child: BlocBuilder<B2BProjectBloc,
                    ApiState<B2BProjectDetailResponseModel, ResponseModel>>(
                  builder: (context, state) {
                    if (state is ApiLoading<B2BProjectDetailResponseModel,
                        ResponseModel>) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is ApiSuccess<
                        B2BProjectDetailResponseModel, ResponseModel>) {
                      final B2BProjectDetailResponseModel project = state.data;
                      return Column(
                        children: [
                          // _buildHeader(),
                          // SizedBox(height: 20),
                          _buildProjectCard(
                            projectInfo: project.data.projectInfo,
                          ),
                          SizedBox(height: 20),
                          _buildStatsRow(
                            totalAmount:  project.data.projectInfo.getFormattedContractValue(),
                            amountPaid: project.data.projectInfo.totalAmountPaid,
                            projectAreasCount: project.data.totalProjectAreas,
                          ),
                          SizedBox(height: 20),
                          _buildServiceSummary(
                            serviceSummary: project.data.serviceSummary,
                            projectTitle:  project.data.projectInfo.name
                          ),
                          SizedBox(height: 20),
                          _buildProjectAreas(
                            projectArea: project.data.projectAreas
                          ),
                        ],
                      );
                    } else if (state is ApiFailure<
                        B2BProjectDetailResponseModel, ResponseModel>) {
                      return Center(
                          child: Text(state.error.message.toString()));
                    } else {
                      return Center(
                          child:
                              Text('Unexpected state: ${state.runtimeType}'));
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColor.primary, AppColor.primaryLight],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.eco,
                color: Colors.white,
                size: 28,
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Project Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'TreeLov Initiative',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.notifications,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard({required ProjectInfo projectInfo}) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        // borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            child: Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColor.secondary, AppColor.secondaryLight],
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      'http://43.205.169.130/media/project/image/istockphoto-1248915699-612x612_MuxMvDr.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColor.secondary,
                                AppColor.secondaryLight
                              ],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.park,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SafeArea(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    right: 15,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'ACTIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  projectInfo.name,
                  // 'Mahalaxmi Tree Plantation',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryDark,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  projectInfo.description ?? 'no description available',
                  // 'This project is meant for the plantation of Ain trees at multiple locations of Mahalaxmi',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Icon(Icons.location_on,
                        color: AppColor.secondary, size: 18),
                    SizedBox(width: 5),
                    Text(
                      projectInfo.locationDescription ??
                          'Location not specified',
                      // 'Mumbai, Mahalaxmi',
                      style: TextStyle(
                        color: AppColor.primaryDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        color: AppColor.secondary, size: 18),
                    SizedBox(width: 5),
                    Text(
                      // '05 Aug 2025 - 05 Oct 2025',
                      '${projectInfo.getFormattedStartDate()} - ${projectInfo.getFormattedEndDate()}',
                      style: TextStyle(
                        color: AppColor.primaryDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(
      {required String totalAmount,
      required String amountPaid,
      required int projectAreasCount}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              totalAmount,
              // '₹12.3L',
              'Total Amount',
              Icons.account_balance_wallet,
              AppColor.primary,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: _buildStatCard(
              amountPaid,
              // '₹5.23L',
              'Amount Paid',
              Icons.payments,
              AppColor.secondary,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: _buildStatCard(
              projectAreasCount.toString(),
              // '${projectAreas.length}',
              'Project Areas',
              Icons.map,
              AppColor.secondaryDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String value, String label, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.primaryDark,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceSummary({required List<ServiceSummary> serviceSummary,required String projectTitle}) {
    // Calculate overall service summary from selected area
    // var selectedArea = projectAreas[selectedAreaIndex];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart, color: AppColor.primary, size: 24),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Service Summary',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryDark,
                      ),
                    ),

                    Text(
                      projectTitle,
                      // selectedArea['name'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Column(
            spacing: 5.h,
            children: List.generate(
              serviceSummary.length,
              (int index) => _buildServiceItem(
                  serviceSummary[index].serviceType,
                  serviceSummary[index].totalRequired,
                  serviceSummary[index].totalDone,
                  _getServiceIcon(serviceSummary[index].serviceType),
                  _getServiceColor(serviceSummary[index].serviceType)),
            ),
          )
          /*
          SizedBox(height: 20),
          ...selectedArea['service_summary'].map<Widget>((service) {
            int index = selectedArea['service_summary'].indexOf(service);
            List<Color> colors = [
              AppColor.secondary,
              AppColor.primary,
              AppColor.secondaryDark
            ];
            List<IconData> icons = [Icons.eco, Icons.build, Icons.visibility];

            return Column(
              children: [
                _buildServiceItem(
                    service['service_type'],
                    service['total_required'],
                    service['total_done'],
                    icons[index % icons.length],
                    colors[index % colors.length]),
                if (index < selectedArea['service_summary'].length - 1)
                  SizedBox(height: 15),
              ],
            );
          }).toList(),

           */
        ],
      ),
    );
  }

  Widget _buildServiceItem(
      String service, int required, int done, IconData icon, Color color) {
    double progress = done / required;
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              SizedBox(width: 10),
              Text(
                service,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColor.primaryDark,
                ),
              ),
              Spacer(),
              Text(
                '$done/$required',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildProjectAreas(
  {required List<ProjectArea> projectArea}
      ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.nature, color: AppColor.primary, size: 24),
              SizedBox(width: 10),
              Text(
                'Project Areas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primaryDark,
                ),
              ),
              Spacer(),
              Text(
                '${projectArea.length} Areas',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Filter Chips
          _buildAreaFilterChips(
            projectArea: projectArea
          ),

          SizedBox(height: 20),

          // Selected Area Details
          _buildSelectedAreaDetails(
            projectArea: projectArea
          ),
        ],
      ),
    );
  }

  Widget _buildAreaFilterChips({
    required List<ProjectArea> projectArea
}) {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: projectArea.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedAreaIndex == index;
          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.only(right: 12),
            child: FilterChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.grass,
                    size: 16,
                    color: isSelected ? Colors.white : AppColor.secondary,
                  ),
                  SizedBox(width: 6),
                  Text(
                    projectArea[index].name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColor.primaryDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              onSelected: (selected) {
                setState(() {
                  selectedAreaIndex = index;
                });
              },
              backgroundColor: AppColor.background,
              selectedColor: AppColor.secondary,
              checkmarkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: BorderSide(
                  color: isSelected
                      ? AppColor.secondary
                      : AppColor.secondary.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: isSelected ? 4 : 0,
              shadowColor: AppColor.secondary.withOpacity(0.3),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedAreaDetails(
  { required List<ProjectArea> projectArea}
      ) {
    var selectedArea = projectArea[selectedAreaIndex];

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0.3, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Container(
        key: ValueKey(selectedAreaIndex),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColor.secondary.withOpacity(0.1),
              AppColor.secondaryLight.withOpacity(0.1)
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.secondary.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColor.secondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.grass,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedArea.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryDark,
                        ),
                      ),
                      Text(
                        'Capacity: ${_formatNumber(selectedArea.capacity)} trees',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getAreaStatusColor(selectedArea),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getAreaStatus(selectedArea),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),

            // Progress Overview
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:
                projectArea[selectedAreaIndex].serviceSummary.map<Widget>((service) {
                  return _buildMiniStat(
                    '${service.totalDone}/${service.totalRequired}',
                    service.serviceType,
                    _getServiceIcon(service.serviceType),
                    _getServiceColor(service.serviceType),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 10),

            // Overall Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Overall Progress',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColor.primaryDark,
                      ),
                    ),
                    Text(
                      '${_getOverallProgress(projectArea[selectedAreaIndex]).toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColor.secondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _getOverallProgress(selectedArea) / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getProgressColor(_getOverallProgress(selectedArea)),
                    ),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(
      String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColor.primaryDark,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // Helper methods
  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(number % 1000 == 0 ? 0 : 1)}K';
    }
    return number.toString();
  }

  IconData _getServiceIcon(String serviceType) {
    switch (serviceType.toLowerCase()) {
      case 'plantation':
        return Icons.eco;
      case 'maintenance':
        return Icons.build;
      case 'monitoring':
        return Icons.visibility;
      default:
        return Icons.work;
    }
  }

  Color _getServiceColor(String serviceType) {
    switch (serviceType.toLowerCase()) {
      case 'plantation':
        return AppColor.secondary;
      case 'maintenance':
        return AppColor.primary;
      case 'monitoring':
        return AppColor.secondaryDark;
      default:
        return AppColor.primary;
    }
  }

  // double _getOverallProgress(Map<String, dynamic> area) {
  //   List services = area['service_summary'];
  //   double totalProgress = 0;
  //
  //   for (var service in services) {
  //     double progress =
  //         (service['total_done'] / service['total_required']) * 100;
  //     totalProgress += progress;
  //   }
  //
  //   return totalProgress / services.length;
  // }
  double _getOverallProgress(ProjectArea area) {
    if (area.serviceSummary.isEmpty) return 0.0;

    double totalProgress = 0.0;

    for (ServiceSummary service in area.serviceSummary) {
      totalProgress += service.getCompletionPercentage();
    }

    return totalProgress / area.serviceSummary.length;
  }


  Color _getProgressColor(double progress) {
    if (progress >= 80) return Colors.green;
    if (progress >= 50) return AppColor.secondary;
    if (progress >= 25) return Colors.orange;
    return Colors.red;
  }

  String _getAreaStatus(area) {
    double progress = _getOverallProgress(area);
    if (progress >= 90) return 'COMPLETED';
    if (progress >= 60) return 'ON TRACK';
    if (progress >= 30) return 'IN PROGRESS';
    return 'STARTED';
  }

  Color _getAreaStatusColor(ProjectArea area) {
    double progress = _getOverallProgress(area);
    if (progress >= 90) return Colors.green;
    if (progress >= 60) return AppColor.secondary;
    if (progress >= 30) return Colors.orange;
    return Colors.red;
  }

  Widget _buildFAB() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.secondary, AppColor.secondaryLight],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.secondary.withOpacity(0.4),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Colors.transparent,
        elevation: 0,
        label: Text(
          'Add Progress',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        icon: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
