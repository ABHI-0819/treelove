import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treelove/core/config/themes/app_color.dart';

import '../../../../../common/bloc/api_event.dart';
import '../../../../../common/bloc/api_state.dart';
import '../../../../../common/models/response.mode.dart';
import '../../../../../common/repositories/project_repository.dart';
import '../../../../../common/screens/maintenance_stats_screen.dart';
import '../../../../../core/config/route/app_route.dart';
import '../../../../../core/network/api_connection.dart';
import '../../../../authentication/screens/sign_in_screen.dart';
import '../bloc/b2b_project_bloc.dart';
import '../model/b2b_project_detail_response_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../../common/repositories/report_repository.dart';
import '../../../../../common/widgets/report_selection_sheet.dart';

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

  void _handleReportDownload(ReportType type) async {
    EasyLoading.show(status: 'Downloading report...');
    try {
      final repo = ReportRepository(api: ApiConnection());
      final file = await repo.downloadReport(widget.projectId, type);
      EasyLoading.dismiss();

      if (file != null) {
        await Share.shareXFiles([XFile(file.path)], text: 'Project Report');
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to download report')),
          );
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _showReportSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ReportSelectionSheet(
        onSelect: _handleReportDownload,
      ),
    );
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
                    AppRoute.pushReplacement(context, SignInScreen.route,
                        arguments: {});
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
                            totalAmount: project.data.projectInfo
                                .getFormattedContractValue(),
                            amountPaid:
                                project.data.projectInfo.totalAmountPaid,
                            projectAreasCount: project.data.totalProjectAreas,
                          ),
                          SizedBox(height: 20),
                          _buildServiceSummary(
                              serviceSummary: project.data.serviceSummary,
                              projectTitle: project.data.projectInfo.name),
                          SizedBox(height: 20),
                          _buildProjectAreas(
                              projectArea: project.data.projectAreas),
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

  Widget _buildReportButton() {
    return GestureDetector(
      onTap: _showReportSelection,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColor.primary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColor.primary.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.file_download_outlined, color: Colors.white, size: 16),
            SizedBox(width: 8),
            Text(
              'Download Report',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
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
                    top: 15,
                    left: 15,
                    child: SafeArea(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 18,
                          ),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.location_on,
                              color: AppColor.secondary, size: 18),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              projectInfo.locationDescription ??
                                  'Location not specified',
                              // 'Mumbai, Mahalaxmi',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColor.primaryDark,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildReportButton(),
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
    // Strip ending '.00' decimals to save horizontal space dynamically
    String cleanTotal = totalAmount.replaceAll('.00', '');
    String cleanPaid = amountPaid.replaceAll('.00', '');

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
              child: _buildCompactStatItem(
            cleanTotal,
            'Total Amount',
            Icons.account_balance_wallet_outlined,
            AppColor.primary,
          )),
          Container(height: 40, width: 1, color: Colors.grey.withOpacity(0.2)),
          Expanded(
              child: _buildCompactStatItem(
            cleanPaid,
            'Amount Paid',
            Icons.payments_outlined,
            AppColor.secondary,
          )),
          Container(height: 40, width: 1, color: Colors.grey.withOpacity(0.2)),
          Expanded(
              flex: 1,
              child: _buildCompactStatItem(
                projectAreasCount.toString(),
                'Areas',
                Icons.map_outlined,
                AppColor.secondaryDark,
              )),
        ],
      ),
    );
  }

  Widget _buildCompactStatItem(
      String value, String label, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColor.primaryDark,
              ),
            ),
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceSummary(
      {required List<ServiceSummary> serviceSummary,
      required String projectTitle}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
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
          SizedBox(height: 16.h),
          SizedBox(
            height: 105,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: serviceSummary.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final summary = serviceSummary[index];
                final sType = summary.serviceType;
                final icon = _getServiceIcon(sType);
                final color = _getServiceColor(sType);
                final required = summary.totalRequired;
                final done = summary.totalDone;
                
                final VoidCallback? onTap = sType.toLowerCase() == 'maintenance'
                    ? () {
                        AppRoute.goToNextPage(
                          context: context,
                          screen: MaintenanceStatsScreen.route,
                          arguments: {
                            'projectId': widget.projectId,
                            'projectAreaId': null,
                            'projectName': projectTitle,
                          },
                        );
                      }
                    : null;

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 155,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColor.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: color.withOpacity(0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(icon, color: color, size: 22),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  sType,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: AppColor.primaryDark,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Progress",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    "$done/$required",
                                    style: TextStyle(
                                      color: AppColor.primaryDark,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              if (onTap != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Row(
                                    children: [
                                      Text(
                                        "Dash",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 2),
                                      Icon(Icons.open_in_new, size: 10, color: Colors.white),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProjectAreas({required List<ProjectArea> projectArea}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
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
          _buildAreaFilterChips(projectArea: projectArea),

          SizedBox(height: 20),

          // Selected Area Details
          _buildSelectedAreaDetails(projectArea: projectArea),
        ],
      ),
    );
  }

  Widget _buildAreaFilterChips({required List<ProjectArea> projectArea}) {
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

  Widget _buildSelectedAreaDetails({required List<ProjectArea> projectArea}) {
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
                children: projectArea[selectedAreaIndex]
                    .serviceSummary
                    .map<Widget>((service) {
                  return _buildMiniStat(
                    '${service.totalDone}/${service.totalRequired}',
                    service.serviceType,
                    _getServiceIcon(service.serviceType),
                    _getServiceColor(service.serviceType),
                    onTap: service.serviceType.toLowerCase() == 'maintenance'
                        ? () {
                            AppRoute.goToNextPage(
                              context: context,
                              screen: MaintenanceStatsScreen.route,
                              arguments: {
                                'projectId': widget.projectId,
                                'projectAreaId': selectedArea.id,
                                'projectName': selectedArea.name,
                              },
                            );
                          }
                        : null,
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
      String value, String label, IconData icon, Color color,
      {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        decoration: onTap != null 
            ? BoxDecoration(
                color: color.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withOpacity(0.3)),
              )
            : null,
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
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
            if (onTap != null) ...[
              SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Dash",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(Icons.open_in_new, size: 9, color: Colors.white),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
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
