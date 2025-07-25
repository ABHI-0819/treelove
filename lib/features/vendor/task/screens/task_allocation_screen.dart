import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:treelove/common/repositories/task_allocation_respository.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/core/widgets/common_notification.dart';
import 'package:treelove/features/vendor/task/bloc/task_allocation_bloc.dart';
import '../../../../common/bloc/api_event.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../core/config/resource/service_ids.dart';
import '../../../../core/config/themes/app_color.dart';
import '../../../../core/config/themes/app_fonts.dart';
import '../../../../core/network/api_connection.dart';
import '../../../authentication/screens/sign_in_screen.dart';
import '../models/task_allocation_request_model.dart';
import '../models/task_allocation_response_model.dart';

class TaskAllocationScreen extends StatefulWidget {

  static const route = '/TaskAllocationScreen';
  const TaskAllocationScreen({super.key});

  @override
  State<TaskAllocationScreen> createState() => _TaskAllocationScreenState();
}
/*
class _TaskAllocationScreenState extends State<TaskAllocationScreen> {
  String? selectedArea;
  String? selectedStaff;
  final TextEditingController treeController = TextEditingController();

  final Map<String, int> areaTreeMap = {
    'Area 1': 3000,
    'Area 2': 2000,
    'Area 3': 1500,
  };

  final List<String> staffList = [
    'Rahul Sharma',
    'Sneha Patil',
    'Amit Kumar',
    'John Dsouza',
  ];

  final _formKey = GlobalKey<FormState>();

  int get pendingTreeCount => areaTreeMap[selectedArea] ?? 0;
  
  late TaskAllocationBloc taskAllocationBloc;
  
  @override
  void initState() {
    taskAllocationBloc = TaskAllocationBloc(
      TaskAllocationRepository(api: ApiConnection()),
    );
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    treeController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final assignedTrees = int.parse(treeController.text.trim());

      if (assignedTrees > pendingTreeCount) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You can’t assign more than $pendingTreeCount trees.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // TODO: Send data to backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task allocated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => taskAllocationBloc,
  child: Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        title: const Text('Task Allocation', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select Area'),
              const SizedBox(height: 8),
              CustomDropdown<String>.search(
                hintText: 'Choose Area',
                items: areaTreeMap.keys.toList(),
                initialItem: selectedArea,
                onChanged: (value) => setState(() => selectedArea = value),
                decoration: CustomDropdownDecoration(
                  closedFillColor: Colors.white,
                  closedBorder: Border.all(color: Colors.grey, width: 1.5),
                  closedBorderRadius: BorderRadius.circular(8),
                  hintStyle: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),

              const SizedBox(height: 16),

              const Text('Select Staff'),
              const SizedBox(height: 8),
              CustomDropdown<String>.search(
                hintText: 'Choose Staff',
                items: staffList,
                initialItem: selectedStaff,
                onChanged: (value) => setState(() => selectedStaff = value),
                decoration: CustomDropdownDecoration(
                  closedFillColor: Colors.white,
                  closedBorder: Border.all(color: Colors.grey, width: 1.5),
                  closedBorderRadius: BorderRadius.circular(8),
                  hintStyle: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),

              const SizedBox(height: 16),

              const Text('Number of Trees to Assign'),
              const SizedBox(height: 8),
              TextFormField(
                controller: treeController,
                keyboardType: TextInputType.numberWithOptions(decimal: false,signed: false),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter number of trees',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+$')), // Only digits
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter number of trees';
                  }
                  final numValue = int.tryParse(value.trim());
                  if (numValue == null || numValue <= 0) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              if (selectedArea != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColor.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColor.primary.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Pending trees for ${selectedArea!}: $pendingTreeCount',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text('Allocate Task', style: AppFonts.regular),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
);
  }

}

 */
class _TaskAllocationScreenState extends State<TaskAllocationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController treeController = TextEditingController();

  String? selectedArea;
  String? selectedStaff;
  int pendingTreeCount = 50; // Example value
  final Map<String, int> areaTreeMap = {
    'Thane': 50,
    'Kurla': 30,
  };

  // Example staff list
  final List<String> staffList = [
    'John Doe',
    'Jane Smith',
  ];

  late final TaskAllocationBloc taskAllocationBloc;

  @override
  void initState() {
    super.initState();
    taskAllocationBloc = TaskAllocationBloc(TaskAllocationRepository(api: ApiConnection()));
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final assignedTrees = int.parse(treeController.text.trim());

      if (assignedTrees > pendingTreeCount) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You can’t assign more than $pendingTreeCount trees.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (selectedStaff == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a staff'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      //  Create the request model
      final request = TaskAllocationRequestModel(
        fieldworker: '0e16bbad-7df1-49f6-b329-cd73919cef36', // TODO: Map from selectedStaff
        services: ServiceIds.plantationId ?? "", //  Example: Plantation service ID
        quantity: assignedTrees,
      );

      //  Call Bloc event
      taskAllocationBloc.add(ApiAdd(request));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => taskAllocationBloc,
      child: BlocListener<TaskAllocationBloc, ApiState<TaskAllocationResponseModel, ResponseModel>>(
        listener: (context, state) {
          EasyLoading.dismiss();
          if (state is ApiSuccess<TaskAllocationResponseModel, ResponseModel>) {
            showNotification(context, message: state.data.message);
          } else if (state is ApiFailure<TaskAllocationResponseModel, ResponseModel>) {
            showNotification(context, message: state.error.message.toString());
          } else if (state is TokenExpired<TaskAllocationResponseModel, ResponseModel>) {
            AppRoute.pushReplacement(context, SignInScreen.route, arguments: {});
          }
        },
        child: Scaffold(
          backgroundColor: AppColor.white,
          appBar: AppBar(
            backgroundColor: AppColor.primary,
            title: const Text('Task Allocation', style: TextStyle(color: Colors.white)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Area'),
                  const SizedBox(height: 8),
                  CustomDropdown<String>.search(
                    hintText: 'Choose Area',
                    items: areaTreeMap.keys.toList(),
                    initialItem: selectedArea,
                    onChanged: (value) {
                      setState(() {
                        selectedArea = value;
                        pendingTreeCount = areaTreeMap[value] ?? 0;
                      });
                    },
                    decoration: CustomDropdownDecoration(
                      closedFillColor: Colors.white,
                      closedBorder: Border.all(color: Colors.grey, width: 1.5),
                      closedBorderRadius: BorderRadius.circular(8),
                      hintStyle: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text('Select Staff'),
                  const SizedBox(height: 8),
                  CustomDropdown<String>.search(
                    hintText: 'Choose Staff',
                    items: staffList,
                    initialItem: selectedStaff,
                    onChanged: (value) => setState(() => selectedStaff = value),
                    decoration: CustomDropdownDecoration(
                      closedFillColor: Colors.white,
                      closedBorder: Border.all(color: Colors.grey, width: 1.5),
                      closedBorderRadius: BorderRadius.circular(8),
                      hintStyle: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text('Number of Trees to Assign'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: treeController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter number of trees',
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+$')),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter number of trees';
                      }
                      final numValue = int.tryParse(value.trim());
                      if (numValue == null || numValue <= 0) {
                        return 'Enter a valid number';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  if (selectedArea != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColor.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColor.primary.withOpacity(0.5)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Pending trees for ${selectedArea!}: $pendingTreeCount',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 40),

                  BlocBuilder<TaskAllocationBloc, ApiState<TaskAllocationResponseModel, ResponseModel>>(
                    builder: (context, state) {
                      final isLoading = state is ApiLoading;
                      return SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text('Allocate Task', style: AppFonts.regular),
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
