import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/core/config/themes/app_color.dart';
import 'package:badges/badges.dart' as badges;
import '../../../../common/bloc/api_event.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../common/repositories/service_repository.dart';
import '../../../../core/network/api_connection.dart';
import '../../../../core/widgets/common_refresh_indicator.dart';
import '../../../vendor/task/bloc/service_detail_bloc.dart';
import '../../../vendor/task/models/service_detail_response_model.dart';
import 'tree_plantation_screen.dart';

class SelectTreeTypeScreen extends StatefulWidget {
  static const route ="/select-species-plantation";
  final String serviceType;
  final String projectAreaId;
  const SelectTreeTypeScreen({super.key,required this.serviceType,required this.projectAreaId});

  @override
  State<SelectTreeTypeScreen> createState() => _SelectTreeTypeScreenState();
}

class _SelectTreeTypeScreenState extends State<SelectTreeTypeScreen> {

  late ServiceDetailBloc serviceDetailBloc;
  
  @override
  void initState() {
    serviceDetailBloc = ServiceDetailBloc(ServicesRepository(api: ApiConnection()));
    serviceDetailBloc.add(ApiListFetch(serviceName: widget.serviceType,projectAreaId: widget.projectAreaId));

    // TODO: implement initState
    super.initState();
  }

  Future<void>  _refreshData()async{
    serviceDetailBloc.add(ApiListFetch(serviceName: widget.serviceType,projectAreaId: widget.projectAreaId));

  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: const Text('Plant a tree'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color(0xFF0C4F47), // Dark green
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocProvider(
  create: (context) => serviceDetailBloc,
  child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select tree species',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
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
            BlocBuilder<ServiceDetailBloc,
                ApiState<ServiceDetailResponse, ResponseModel>>(
              builder: (context, state) {
                if(state is ApiLoading){
                  return Center(child: CircularProgressIndicator());
                } else if (state is ApiSuccess<ServiceDetailResponse,
                    ResponseModel>)
                {
                  ServiceDetailResponse service = state.data;
                  return   Expanded(
                    child:  CommonRefreshIndicator(
                      onRefresh: _refreshData,
                      isLoading: false,
                      child:
                      ListView.separated(
                      itemCount: service.data.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        // final tree = treeTypes[index];
                        return TreeTypeCard(tree: TreeType(
                          serviceType: widget.serviceType,
                            serviceId: service.data[index].serviceId,
                            projectAreaId: widget.projectAreaId,
                            name: service.data[index].name, species: service.data[index].scientificName,
                            imageUrl:service.data[index].media,
                            totalDone:service.data[index].totalDone,
                            totalRequired: service.data[index].totalRequired,
                        ));
                      },
                    ),
                  ));
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

          ],
        ),
      ),
),
    );
  }
}

class TreeType {
  final String serviceType;
  final String serviceId;
  final String projectAreaId;
  final String name;
  final String species;
  final String ? imageUrl;
  final int totalDone;
  final int totalRequired;

  const TreeType({
    required this.serviceType,
    required this.serviceId,
    required this.projectAreaId,
    required this.name,
    required this.species,
     this.imageUrl,
     required this.totalDone,
     required this.totalRequired,
  });
}

class TreeTypeCard extends StatelessWidget {
  final TreeType tree;

  const TreeTypeCard({super.key, required this.tree});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: Handle tree selection logic
        AppRoute.goToNextPage(context: context, screen: PlantTreeScreen.route, arguments: {
          'serviceType':tree.serviceType,
          'serviceId': tree.serviceId,
          'projectAreaId':tree.projectAreaId
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Row(
          spacing: 16.w,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                tree.imageUrl??"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRuCZtWNJjBjxoVw9OCxZXKQE-biHdtZ7c5Ig&s",
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tree.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  tree.species,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            Spacer(),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(tree.totalDone, tree.totalRequired)
                    .withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "${tree.totalDone} / ${tree.totalRequired}",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(tree.totalDone, tree.totalRequired),
                ),
              ),
            ),
            /*
            badges.Badge(
              badgeContent: Text(
                '3',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              badgeStyle: const badges.BadgeStyle(
                badgeColor: Colors.red,
                padding: EdgeInsets.all(8),
              ),
            ),

             */
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(int done, int required) {
    double progress = done / (required == 0 ? 1 : required);

    if (progress == 1.0) return Colors.green; // fully done ✅
    if (progress > 0.5) return Colors.orange; // partially done 🟠
    return Colors.red; // very low progress ❌
  }
}


