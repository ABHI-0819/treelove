import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treelove/common/repositories/inquiries_repository.dart';
import 'package:treelove/common/widgets/inquiry_section.dart';
import 'package:treelove/core/config/themes/app_color.dart';
import 'package:treelove/core/network/api_connection.dart';
import 'package:treelove/features/customer/retail/maintenance/bloc/inquiry_bloc.dart';

class InquiryTabScreen extends StatelessWidget {
  const InquiryTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InquiryBloc(
        InquiriesRepository(api: ApiConnection()),
      ),
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: AppBar(
          backgroundColor: AppColor.background,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Inquiries',
            style: TextStyle(
              color: AppColor.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              InquirySection(),
              SizedBox(height: 100), // Space for bottom nav
            ],
          ),
        ),
      ),
    );
  }
}
