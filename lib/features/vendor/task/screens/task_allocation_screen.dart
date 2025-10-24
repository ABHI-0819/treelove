import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:treelove/common/repositories/service_repository.dart';
import 'package:treelove/common/repositories/staff_repository.dart';
import 'package:treelove/common/repositories/task_allocation_respository.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/core/utils/logger.dart';
import 'package:treelove/core/widgets/common_notification.dart';
import 'package:treelove/features/vendor/Staff/bloc/staff_bloc.dart';
import 'package:treelove/features/vendor/task/bloc/service_detail_bloc.dart';
import 'package:treelove/features/vendor/task/bloc/task_allocation_bloc.dart';
import '../../../../common/bloc/api_event.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../core/config/resource/service_ids.dart';
import '../../../../core/config/themes/app_color.dart';
import '../../../../core/config/themes/app_fonts.dart';
import '../../../../core/network/api_connection.dart';
import '../../../authentication/screens/sign_in_screen.dart';
import '../../Staff/models/staff_response_model.dart';
import '../../home/models/project_detail_model.dart';
import '../models/service_detail_response_model.dart';
import '../models/task_allocation_request_model.dart';
import '../models/task_allocation_response_model.dart';

class TaskAllocationScreen extends StatefulWidget {
  static const route = '/TaskAllocationScreen';
  final String projectAreaId;
  final List<ServiceSummary> serviceSummary;
  const TaskAllocationScreen(
      {super.key, required this.projectAreaId, required this.serviceSummary});

  @override
  State<TaskAllocationScreen> createState() => _TaskAllocationScreenState();
}

class _TaskAllocationScreenState extends State<TaskAllocationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController treeController = TextEditingController();


  String? selectedArea;
  String? selectedServiceType;
  String?serviceId;
  String? stuffId;
  StaffData? selectedStaff;
  int pendingTreeCount = 50; // Example value

  /// Bloc Initialization
  late TaskAllocationBloc taskAllocationBloc;
  late ServiceDetailBloc serviceDetailBloc;
  late StaffListBloc staffListBloc;

  @override
  void initState() {
    debugLog(widget.serviceSummary.toString(), name: "Service Summary ");
    debugLog(widget.projectAreaId.toString(), name: "Project Area Id ");
    taskAllocationBloc =
        TaskAllocationBloc(TaskAllocationRepository(api: ApiConnection()));
    serviceDetailBloc =
        ServiceDetailBloc(ServicesRepository(api: ApiConnection()));
    staffListBloc = StaffListBloc(StaffRepository(api: ApiConnection()));
    staffListBloc.add(ApiListFetch());
    super.initState();
  }

  void _handleSubmit() {
    final size = MediaQuery.of(context).size;
    if (_formKey.currentState!.validate()) {
      final assignedTrees = int.parse(treeController.text.trim());
      if (stuffId == null) {
        showNotification(context, message: 'Please select a staff');
        return;
      }

      if (assignedTrees > pendingTreeCount) {
        showNotification(context, message: 'You can’t assign more than $pendingTreeCount trees.');
        return;
      }

      //  Create the request model
      final request = TaskAllocationRequestModel(
        fieldworker:stuffId!, // TODO: Map from selectedStaff
        services: serviceId!, //  Example: Plantation service ID
        quantity: assignedTrees,
      );
      //  Call Bloc event
      taskAllocationBloc.add(ApiAdd(request));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ServiceDetailBloc>(
          create: (_) => serviceDetailBloc,
        ),
        BlocProvider<StaffListBloc>(
          create: (_) => staffListBloc,
        ),
        BlocProvider<TaskAllocationBloc>(
          create: (_) => taskAllocationBloc,
        ),
      ],
      child: BlocListener<TaskAllocationBloc,
          ApiState<TaskAllocationResponseModel, ResponseModel>>(
        listener: (context, state) {
          EasyLoading.dismiss();
          if (state is ApiSuccess<TaskAllocationResponseModel, ResponseModel>) {
            showNotification(context, message: state.data.message);
          } else if (state
              is ApiFailure<TaskAllocationResponseModel, ResponseModel>) {
            showNotification(context, message: state.error.message.toString());
          } else if (state
              is TokenExpired<TaskAllocationResponseModel, ResponseModel>) {
            AppRoute.pushReplacement(context, SignInScreen.route,
                arguments: {});
          }
        },
        child: Scaffold(
          backgroundColor: AppColor.white,
          appBar: AppBar(
            backgroundColor: AppColor.primary,
            title: const Text('Task Allocation',
                style: TextStyle(color: Colors.white)),
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
                  const Text('Select Staff'),
                  const SizedBox(height: 8),
                  BlocBuilder<StaffListBloc,
                      ApiState<StaffListResponseModel, ResponseModel>>(
                    builder: (context, state) {
                      if (state is ApiSuccess<StaffListResponseModel,
                          ResponseModel>) {
                        StaffListResponseModel staffList = state.data;
                        return CustomDropdown<StaffData>.search(
                          hintText: 'Choose Staff',
                          items: staffList.data,
                          validateOnChange: true,
                          //  Show the selected value
                          headerBuilder: (context, selectedItem, isSelected) {
                            return Text(
                              selectedItem.profile!.fullName ?? '',
                              style: const TextStyle(fontSize: 14, color: Colors.black),
                            );
                          },
                          //  Show list items while searching
                          listItemBuilder: (context, staff, isSelected, onTap) {
                            return  Text(staff.profile!.fullName ?? '');// optional: show ID// ✅ Required to select item
                          },
                          // initialItem: selectedStaff,
                          onChanged: (value) {
                            stuffId =value!.id;
                            setState(() => selectedStaff = value);
                          },
                          decoration: CustomDropdownDecoration(
                            closedFillColor: Colors.white,
                            closedBorder:
                            Border.all(color: Colors.grey, width: 1.5),
                            closedBorderRadius: BorderRadius.circular(8),
                            hintStyle: const TextStyle(
                                fontSize: 14, color: Colors.black54),
                          ),
                        );
                      } else {
                        return const Center(
                          child: Text(
                            "No staff found",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('Service Type'),
                  const SizedBox(height: 8),
                  CustomDropdown<ServiceSummary>.search(
                    hintText: 'Choose Service Type',
                    items: widget.serviceSummary,
                    // initialItem: selectedArea,
                    headerBuilder: (context, selectedItem, isSelected) {
                      return Text(
                        selectedItem.serviceType,
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                      );
                    },

                    listItemBuilder: (context, services, isSelected, onTap) {
                      return  InkWell(
                        onTap: onTap,
                          child: Text(services.serviceType ?? ''));// optional: show ID// ✅ Required to select item
                    },

                    onChanged: (value) {
                      selectedServiceType=value!.serviceType;
                      serviceDetailBloc.add(ApiListFetch(serviceName: value.serviceType,projectAreaId: widget.projectAreaId));

                      setState(() {

                      });
                      // setState(() {
                      //   selectedArea = value!.serviceType;
                      //   pendingTreeCount = value.totalRequired-value.totalDone ?? 0;
                      // });
                    },
                    decoration: CustomDropdownDecoration(
                      closedFillColor: Colors.white,
                      closedBorder: Border.all(color: Colors.grey, width: 1.5),
                      closedBorderRadius: BorderRadius.circular(8),
                      hintStyle:
                          const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if(selectedServiceType!=null)
                  const Text('Select Tree Species'),
                  if(selectedServiceType!=null)
                  const SizedBox(height: 8),
                  if(selectedServiceType!=null)
                  BlocBuilder<ServiceDetailBloc,
                      ApiState<ServiceDetailResponse, ResponseModel>>(
                    builder: (context, state) {
                      if (state is ApiSuccess<ServiceDetailResponse,
                          ResponseModel>) {
                        ServiceDetailResponse service = state.data;
                        return CustomDropdown<ServiceSpeciesItem>.search(
                          hintText: 'Choose Tree Species',
                          items: service.data,
                          validateOnChange: true,
                          //  Show the selected value
                          headerBuilder: (context, selectedItem, isSelected) {
                            return Text(
                              selectedItem.name,
                              style: const TextStyle(fontSize: 14, color: Colors.black),
                            );
                          },
                          //  Show list items while searching
                          listItemBuilder: (context, service, isSelected, onTap) {
                            return  ListTile(
                              title: Text(service.name ?? ''),
                              subtitle: Text(service.scientificName), // optional: show ID
                              onTap: onTap, // ✅ Required to select item
                            );// optional: show ID// ✅ Required to select item
                          },
                          // initialItem: selectedStaff,
                          onChanged: (value) {
                            serviceId = value!.serviceId;
                            selectedArea = value.name;
                            pendingTreeCount = value.totalRequired-value.totalDone;
                            setState(() {

                            });
                          },
                          decoration: CustomDropdownDecoration(
                            closedFillColor: Colors.white,
                            closedBorder:
                            Border.all(color: Colors.grey, width: 1.5),
                            closedBorderRadius: BorderRadius.circular(8),
                            hintStyle: const TextStyle(
                                fontSize: 14, color: Colors.black54),
                          ),
                        );
                      } else {
                        return const Center(
                          child: Text(
                            "No tree species found",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('Number of Trees to Assign'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: treeController,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: false, signed: false),
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
                        border: Border.all(
                            color: AppColor.primary.withOpacity(0.5)),
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
                  BlocBuilder<TaskAllocationBloc,
                      ApiState<TaskAllocationResponseModel, ResponseModel>>(
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
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
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
