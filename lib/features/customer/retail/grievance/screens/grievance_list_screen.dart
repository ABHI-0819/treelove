import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/features/customer/retail/grievance/screens/raise_grievance_screen.dart';


import '../../../../../common/bloc/api_event.dart';
import '../../../../../common/bloc/api_state.dart';
import '../../../../../common/models/response.mode.dart';
import '../../../../../common/repositories/grievance_repository.dart';
import '../../../../../core/config/themes/app_color.dart';
import '../../../../../core/network/api_connection.dart';
import '../bloc/grievance_bloc.dart';
import '../model/grievance_list_response.dart';

// Your imports

class GrievanceListScreen extends StatefulWidget {
  static const route ="/grievance";
  const GrievanceListScreen({Key? key}) : super(key: key);

  @override
  State<GrievanceListScreen> createState() => _GrievanceListScreenState();
}

class _GrievanceListScreenState extends State<GrievanceListScreen> {

  late GrievanceListBloc grievanceListBloc;
  
  @override
  void initState() {
    super.initState();
    grievanceListBloc = GrievanceListBloc(GrievanceRepository(api: ApiConnection()));
    // Fetch grievances on load
    grievanceListBloc.add(ApiListFetch());
  }

  @override
  void dispose() {
    grievanceListBloc.close();
    // TODO: implement dispose
    super.dispose();
  }

  Widget _buildHeader() {
    return SafeArea(
      top: true,
      left: true,
      right: true,
      bottom: false,
      child: Container(
        padding:  EdgeInsets.symmetric(horizontal: 20,vertical: 5.h),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: AppColor.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.primary.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColor.primary,
                  size: 18,
                ),
              ),
            ),
            const Spacer(),
            Text(
              "Grievances",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColor.primary,
                letterSpacing: -0.5,
              ),
            ),
            const Spacer(),
            const SizedBox(width: 44), // Balance the back button
          ],
        ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: BlocProvider(
  create: (context) => grievanceListBloc,
  child: Column(
    children: [
      _buildHeader(),
      Expanded(
        flex: 1,
        child: BlocBuilder<GrievanceListBloc,
                ApiState<GrievanceListResponse, ResponseModel>>(
              builder: (context, state) {
                if (state is ApiLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ApiSuccess<GrievanceListResponse, ResponseModel>) {
                  final grievances = state.data.data;
                  if (grievances.isEmpty) {
                    return _buildEmptyState();
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: grievances.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _GrievanceCard(grievance: grievances[index]);
                    },
                  );
                }

                if (state is ApiFailure<GrievanceListResponse, ResponseModel>) {
                  return _buildErrorState(
                    message: state.error.message ?? 'Failed to load',
                    onRetry: () {
                      grievanceListBloc.add(ApiListFetch());
                    },
                  );
                }
                if(state is TokenExpired<GrievanceListResponse, ResponseModel>){
                  _buildErrorState(
                    message: state.error.message ?? 'Session expired',
                    onRetry: () {
                      grievanceListBloc.add(ApiListFetch());
                    },
                  );
                }

                return _buildEmptyState(); // fallback
              },
            ),
      ),
    ],
  ),
),
      /*
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.white,
        onPressed: () {
         AppRoute.goToNextPage(context: context, screen: RaiseGrievanceScreen.route, arguments: {});
        },
        child: const Icon(Icons.add),
      ),

       */
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.report_gmailerrorred_outlined,
            size: 64,
            color: AppColor.textMuted.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          const Text(
            'No grievances yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColor.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap + to raise a new grievance',
            style: TextStyle(
              color: AppColor.textMuted,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState({required String message, required VoidCallback onRetry}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColor.error,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColor.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _GrievanceCard extends StatelessWidget {
  final GrievanceRecord grievance;

  const _GrievanceCard({required this.grievance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category & Status
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(grievance.status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  grievance.statusDisplay,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                _formatDate(grievance.createdAt),
                style: TextStyle(
                  fontSize: 12,
                  color: AppColor.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Category Name
          Text(
            grievance.category.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColor.textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            grievance.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              color: AppColor.textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          // Location (if available)
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: AppColor.primary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    grievance.location ?? 'Not Available',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColor.textMuted,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return const Color(0xFFFFA726); // Amber
      case 'in_progress':
        return const Color(0xFF29B6F6); // Blue
      case 'resolved':
        return const Color(0xFF66BB6A); // Green
      case 'rejected':
        return AppColor.error;
      default:
        return AppColor.textMuted;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year) {
      if (date.month == now.month && date.day == now.day) {
        return 'Today';
      }
      return '${date.day} ${_getMonth(date.month)}';
    }
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getMonth(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}