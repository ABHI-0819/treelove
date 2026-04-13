import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:treelove/common/bloc/api_event.dart';
import 'package:treelove/common/bloc/api_state.dart';
import 'package:treelove/common/models/response.mode.dart';
import 'package:treelove/core/config/constants/enum/inquiry_type_enum.dart';
import 'package:treelove/core/config/themes/app_color.dart';
import 'package:treelove/core/config/themes/app_fonts.dart';
import 'package:treelove/features/customer/retail/maintenance/bloc/inquiry_bloc.dart';
import 'package:treelove/features/customer/retail/maintenance/models/inquiry_model.dart';
import 'package:treelove/features/customer/retail/maintenance/models/inquiry_request_model.dart';

class InquirySection extends StatefulWidget {
  const InquirySection({super.key});

  @override
  State<InquirySection> createState() => _InquirySectionState();
}

class _InquirySectionState extends State<InquirySection> {
  @override
  void initState() {
    super.initState();
    context.read<InquiryBloc>().add(ApiFetch());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Inquiries',
                style: AppFonts.title.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.primary,
                ),
              ),
              TextButton.icon(
                onPressed: () => _showNewInquirySheet(context),
                icon: const Icon(Icons.add_circle_outline, size: 20),
                label: Text(
                  'New Inquiry',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.secondary,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: AppColor.secondary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        BlocBuilder<InquiryBloc, ApiState<dynamic, ResponseModel>>(
          builder: (context, state) {
            if (state is ApiLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ApiSuccess) {
              final successState = state as ApiSuccess<dynamic, ResponseModel>;
              if (successState.data is InquiryListResponse) {
                final inquiries =
                    (successState.data as InquiryListResponse).data;
                if (inquiries.isEmpty) {
                  return _buildEmptyState();
                }
                return SizedBox(
                  height: 140.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: inquiries.length,
                    itemBuilder: (context, index) {
                      return _buildInquiryCard(inquiries[index]);
                    },
                  ),
                );
              }
            } else if (state is ApiFailure) {
              final failureState = state as ApiFailure<dynamic, ResponseModel>;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  failureState.error.message ?? 'Failed to load inquiries',
                  style: TextStyle(color: Colors.red, fontSize: 12.sp),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 30.h),
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColor.primary.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(Icons.query_builder, size: 40, color: Colors.grey[400]),
          SizedBox(height: 12.h),
          Text(
            'No inquiries yet',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInquiryCard(InquiryListItem item) {
    return Container(
      width: 260.w,
      margin: EdgeInsets.only(right: 16.w, bottom: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: _getStatusColor(item.status).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.inquiryNumber,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.primaryDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildStatusBadge(item),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(Icons.category_outlined, size: 14, color: Colors.grey[600]),
              SizedBox(width: 6.w),
              Text(
                item.inquiryTypeDisplay,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('MMM dd, yyyy').format(item.createdAt),
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.grey[500],
                ),
              ),
              if (item.urgencyLevel.isNotEmpty)
                Text(
                  item.urgencyLevel.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: _getUrgencyColor(item.urgencyLevel),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(InquiryListItem item) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _getStatusColor(item.status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        item.statusDisplay,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
          color: _getStatusColor(item.status),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'rejected':
      case 'cancelled':
        return Colors.red;
      case 'approved':
      case 'completed':
        return AppColor.secondary;
      case 'pending':
        return Colors.orange;
      default:
        return AppColor.primary;
    }
  }

  Color _getUrgencyColor(String level) {
    switch (level.toLowerCase()) {
      case 'high':
        return Colors.red[700]!;
      case 'medium':
        return Colors.orange[700]!;
      default:
        return AppColor.secondary;
    }
  }

  void _showNewInquirySheet(BuildContext context) {
    final inquiryBloc = context.read<InquiryBloc>();
    final queryController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider.value(
        value: inquiryBloc,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: AppColor.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
              ),
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'New Inquiry',
                    style: AppFonts.title.copyWith(
                      fontSize: 20.sp,
                      color: AppColor.primary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Submit your request or question and we\'ll get back to you shortly.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: queryController,
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your inquiry description';
                        }
                        if (value.trim().length < 10) {
                          return 'Minimum 10 characters required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Tell us what\'s on your mind...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        contentPadding: EdgeInsets.all(16.w),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  BlocConsumer<InquiryBloc, ApiState<dynamic, ResponseModel>>(
                    listener: (context, state) {
                      if (state is ApiSuccess) {
                        final successState =
                            state as ApiSuccess<dynamic, ResponseModel>;
                        if (successState.data is ResponseModel) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Inquiry submitted successfully!')),
                          );
                          // Refresh the list
                          inquiryBloc.add(ApiFetch());
                        }
                      } else if (state is ApiFailure) {
                        final failureState =
                            state as ApiFailure<dynamic, ResponseModel>;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(failureState.error.message ??
                                  'Failed to submit.')),
                        );
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state is ApiLoading;
                      return SizedBox(
                        width: double.infinity,
                        height: 45.h,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    final inquiry =
                                        InquiryRequestModel.withoutLocation(
                                      inquiryType: InquiryType.mixed,
                                      description: queryController.text.trim(),
                                    );
                                    context
                                        .read<InquiryBloc>()
                                        .add(ApiAdd(inquiry));
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primaryDark,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : Text(
                                  'Submit Inquiry',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
