import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:treelove/common/repositories/order_flow_state.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/core/config/themes/app_fonts.dart';
import 'package:treelove/core/utils/logger.dart';
import 'package:treelove/features/customer/retail/tree-species/tree_species_list.dart';
import '../../../../../common/bloc/api_event.dart';
import '../../../../../common/bloc/api_state.dart';
import '../../../../../common/models/response.mode.dart';
import '../../../../../common/repositories/project_area_repository.dart';
import '../../../../../core/config/constants/enum/notification_enum.dart';
import '../../../../../core/config/constants/enum/order_enum.dart';
import '../../../../../core/config/constants/map_constants.dart';
import '../../../../../core/config/resource/images.dart';
import '../../../../../core/config/themes/app_color.dart';
import 'package:turf/turf.dart' as turf;
import '../../../../../core/network/api_connection.dart';
import '../../../../../core/services/order_item_service.dart';
import '../../../../../core/utils/geofence_helper.dart';
import '../../../../../core/widgets/common_notification.dart';
import '../../../../authentication/screens/sign_in_screen.dart';
import '../../../../fieldworker/activity/bloc/project_area_bloc.dart';
import '../../../../fieldworker/activity/models/project_area_list_response.dart';

class MapScreen extends StatefulWidget {
  static const route ="/plant-by-location";
  final String ? projectId;
  const MapScreen({this.projectId,super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController mapController = MapController();
  LatLng? selectedPoint;
  int treeCount = 1;

  bool isNavigate = false;

  final List<LatLng> polygonPoints = const [
    LatLng(19.1245, 72.8315),
    LatLng(19.1240, 72.8340),
    LatLng(19.1250, 72.8350),
    LatLng(19.1265, 72.8330),
    LatLng(19.1255, 72.8310),
    LatLng(19.1245, 72.8315), // Closed loop
  ];

  final manager = OrderItemMapManager();

  String? insideAreaId;
  void _onMapTap(LatLng point, List<ProjectAreaItem> areas) {
    bool insideAnyArea = false;

    for (final area in areas) {
      if (area.polygonLatLngs.isEmpty) continue; // skip if no polygon

      final polygonCoords = [
        area.polygonLatLngs
            .map((latLng) => turf.Position(latLng.longitude, latLng.latitude))
            .toList()
      ];

      final bool isInside = isPointInsidePolygon(
        latitude: point.latitude,
        longitude: point.longitude,
        polygonCoordinates: polygonCoords,
      );

      if (isInside) {
         insideAreaId= area.id;
        insideAnyArea = true;
        break;
      }
    }

    if (insideAnyArea) {
      isNavigate = true;
    } else {
      HapticFeedback.mediumImpact();
      showNotification(
        context,
        message: 'Please drop the pin inside the green area to plant.',
        type: Not.warning,
      );
    }

    setState(() {
      selectedPoint = point;
      treeCount = 1;
    });
  }



  /*
  void _onMapTap(LatLng point) {
    setState(() {
      selectedPoint = point;
      treeCount = 1;
    });
  }

   */

  void _updateTreeCount(int count) {
    setState(() {
      treeCount = count;
    });
  }

  Widget _buildTreeCountMarker(int count) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.location_on, color: Colors.green[900], size: 40),
        Positioned(
          top: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "$count", // Display the individual tree count
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  late ProjectAreaBloc projectAreaBloc;

  @override
  void initState() {
    projectAreaBloc = ProjectAreaBloc(ProjectAreaRepository(api: ApiConnection()));
    if(widget.projectId!=null){
      debugLog(widget.projectId.toString(),name: "projectId");
      projectAreaBloc.add(ApiListFetch(id: widget.projectId));
    }else{
      projectAreaBloc.add(ApiListFetch());
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(create:(context)=> projectAreaBloc,
        child:  BlocListener<ProjectAreaBloc,
            ApiState<ProjectAreasResponse, ResponseModel>>(
          listener: (context, state) {
            EasyLoading.dismiss();
            if (state
            is ApiFailure<ProjectAreasResponse, ResponseModel>) {
              showNotification(context,
                  message: state.error.message.toString());
            } else if (state
            is TokenExpired<ProjectAreasResponse, ResponseModel>) {
              AppRoute.pushReplacement(context, SignInScreen.route,
                  arguments: {});
            }
          },
          child: BlocBuilder<ProjectAreaBloc,
              ApiState<ProjectAreasResponse, ResponseModel>>(
            builder: (context, state) {
              if(state is ApiLoading){
                return Center(child: CircularProgressIndicator());
              } else  if (state is ApiSuccess<ProjectAreasResponse, ResponseModel>) {
                ProjectAreasResponse areaList = state.data;
                if(areaList.data.isEmpty){
                  return  EmptyProjectAreasWidget(
                    onRetry: () {
                      // Add your retry logic here
                      // Example: bloc.add(FetchProjectAreas());
                      // Or: setState(() { _loadData(); });
                    },
                  );
                }

                return
                  Stack(
                  children: [
                    FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        initialCenter:   areaList.data.isEmpty? MapConstant.initialCenter: areaList.data[0].centroid,
                        // MapConstant.initialCenter,
                        initialZoom: MapConstant.initialZoom,
                        maxZoom: MapConstant.maximumZoom,
                        minZoom: MapConstant.minimumZoom,
                        onTap: (_, latLng) => _onMapTap(latLng,areaList.data),
                      ),
                      children: [
                        // TileLayer(
                        //   urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        //   tileProvider: NetworkTileProvider(
                        //     headers: {
                        //       'User-Agent': 'TreelovApp/1.0 (https://yourapp.com)',
                        //     },
                        //   ),
                        //   // subdomains: ['a', 'b', 'c'],
                        //   // userAgentPackageName: 'com.example.app',
                        // ),
                        TileLayer(
                          urlTemplate: 'https://a.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                          tileProvider: NetworkTileProvider(
                            headers: {
                              'User-Agent': 'Treelov/1.0',
                            },
                          ),
                        ),
                        CurrentLocationLayer(),
                        //  Show Polygon
                        PolygonLayer(
                          polygons: [
                            ...List.generate(areaList.data.length, (index)=> Polygon(

                              points: areaList.data[index].polygonLatLngs,
                              color: Colors.green.withOpacity(0.2),
                              borderColor: Colors.green,
                              borderStrokeWidth: 2,
                            ),)

                          ],
                        ),
                        FutureBuilder<List<Map<String, dynamic>>>(
                          // Fetch all stored tree items once
                          future: Future.value(manager.getAllOrderItems()),

                          builder: (context, snapshot) {

                            // 1. Handle loading state
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            // 2. Safely get the data list (defaults to empty if null/error)
                            final List<Map<String, dynamic>> items = snapshot.data ?? [];

                            // 3. Generate a list of Markers
                            List<Marker> treeMarkers = [];

                            // Iterate through every stored tree item to create a marker
                            for (var item in items) {
                              // Safely extract data
                              final double lat = item['latitude'] as double? ?? 0.0;
                              final double lon = item['longitude'] as double? ?? 0.0;
                              final int count = item['count'] as int? ?? 1; // Default to 1 if count is missing

                              // Skip if location data is invalid
                              if (lat == 0.0 && lon == 0.0) continue;

                              treeMarkers.add(
                                Marker(
                                  point: LatLng(lat, lon), // Use the specific coordinates from the item
                                  width: 50,
                                  height: 50,
                                  child: _buildTreeCountMarker(count), // Helper to build the visual icon
                                ),
                              );
                            }

                            // 4. Return the MarkerLayer with the final list of markers
                            return MarkerLayer(
                              markers: treeMarkers,
                            );
                          },
                        ),
                        if (selectedPoint != null)
                          MarkerLayer(
                            markers: [
                              Marker(
                                  point: selectedPoint!,
                                  width: 50,
                                  height: 50,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Icon(Icons.location_on,
                                          color: Colors.green[900], size: 40),
                                      Positioned(
                                        top: 10,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            "$treeCount",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                      ],
                    ),
                    Positioned(
                      top: 120, // Below your search bar
                      left: 15,
                      right: 15,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade300),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Icon(Icons.place_rounded, color: Colors.green.shade800, size: 20),
                            // const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '🌳Please tap **inside the green zone** to plant a tree.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green.shade900,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          spacing: 10,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: AppColor.cardBackground,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColor.primary.withOpacity(0.15),
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
                            
                            Expanded(
                              child: SizedBox(
                                height: 55,
                                child: CustomDropdown<ProjectAreaItem>.search(
                                  hintText: 'Search and select area',
                                  items: areaList.data,
                                  // Custom item builder to display area names
                                  listItemBuilder: (context, item, isSelected, onItemSelect) {
                                    return Text(
                                      item.name ?? 'Unnamed Area',
                                      style: TextStyle(
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                        color: isSelected ? Colors.green.shade900 : Colors.black87,
                                      ),
                                    );
                                  },

                                  // Custom header builder (what shows when item is selected)
                                  headerBuilder: (context, selectedItem, enabled) {
                                    return Text(
                                      selectedItem.name ?? 'Unnamed Area',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  },
                                  excludeSelected: false,
                                  decoration: CustomDropdownDecoration(
                                    closedFillColor: Colors.white,
                                    expandedFillColor: Colors.white,
                                    closedBorder: Border.all(color: Colors.green.shade300, width: 1.5),
                                    expandedBorder: Border.all(color: Colors.green.shade400, width: 1.5),
                                    closedBorderRadius: BorderRadius.circular(12),
                                    expandedBorderRadius: BorderRadius.circular(12),
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                    headerStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                    closedSuffixIcon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.green.shade700,
                                    ),
                                    expandedSuffixIcon: Icon(
                                      Icons.keyboard_arrow_up,
                                      color: Colors.green.shade700,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.location_on,
                                      color: Colors.green.shade700,
                                      size: 20,
                                    ),
                                    searchFieldDecoration: SearchFieldDecoration(
                                      fillColor: Colors.grey.shade50,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: Colors.green.shade300),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: Colors.green.shade600, width: 2),
                                      ),
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade500,
                                      ),
                                      textStyle: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  onChanged: (ProjectAreaItem? newArea) {
                                    if (newArea != null) {
                                      setState(() {
                                        // selectedArea = newArea;
                                      });

                                      // Animate map to selected area's centroid
                                      mapController.move(
                                        newArea.centroid,
                                        13.0, // Adjust zoom level as needed
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // SafeArea(
                    //     child: _SearchBar(mapController: mapController,
                    //       onBackPressed: () {
                    //         Navigator.of(context).pop(); // or pushReplacement, etc.
                    //       },
                    //     )),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SafeArea(
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _TreeCounter(
                                initialCount: treeCount,
                                onChanged: _updateTreeCount,
                              ),
                              const SizedBox(width: 20),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // await OrderItemMapManager().clear();
                                  if(insideAreaId!=null){
                                  /*

                                    final String uniqueId = 'T${DateTime.now().microsecondsSinceEpoch}';
                                  await  manager.addItem(
                                      treeId: uniqueId,
                                      latitude:selectedPoint!.latitude,
                                      longitude:selectedPoint!.longitude,
                                      count: treeCount,
                                    );

                                   */
                                    AppRoute.goToNextPage(
                                      context: context,
                                      screen: TreeSpeciesList.route,
                                      arguments: {
                                        'areaId':insideAreaId,
                                        'treeCount':treeCount,
                                        'latitude':selectedPoint!.latitude,
                                        'longitude':selectedPoint!.longitude,
                                      },
                                    );
                                  }else{
                                    HapticFeedback.mediumImpact();
                                    showNotification(
                                      context,
                                      message: 'Please drop the pin inside the green area to plant.',
                                      type: Not.warning,
                                    );
                                  }
                                },
                                icon: const Icon(Icons.eco, color: Colors.black87),
                                label: const Text(
                                  'Plant here',
                                  style: TextStyle(color: Colors.black87, fontSize: 16),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF0EAD6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 10),
                                  elevation: 5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                );
              } else {
                return const Center(
                  child: Text(
                    "No project areas found.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }
            },
          ),
        ),

      )

    );
  }
}


class _SearchBar extends StatelessWidget {
  final MapController mapController;
  final VoidCallback? onBackPressed; // Optional back callback

  const _SearchBar({
    required this.mapController,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false, // Avoid double padding at bottom
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          spacing: 10,
          children: [
            // Back Button
            if (onBackPressed != null)
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: AppColor.black, size: 18),
                  onPressed: onBackPressed!,
                ),
              )
            /*
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: onBackPressed!,
                child: Icon(
                  CupertinoIcons.back,
                  color: Theme.of(context).platform == TargetPlatform.iOS
                      ? CupertinoColors.systemBlue
                      : Theme.of(context).iconTheme.color,
                  size: 30,
                ),
              )

               */
            else
              const SizedBox(width: 36), // Reserve space if no back button

            // Search Field
            Expanded(
              child: Container(
                height: 44, // Standard iOS control height
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(12), // iOS-style rounding
                  boxShadow: Theme.of(context).platform == TargetPlatform.iOS
                      ? [] // iOS typically avoids heavy shadows
                      : [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  onSubmitted: (value) async {
                    final location = await getLatLngFromQuery(value);
                    if (location != null) {
                      mapController.move(location, 17);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Search for location...",
                    hintStyle: const TextStyle(fontSize: 16),
                    border: InputBorder.none,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Replace this with your actual geocoding logic (e.g., using geocoding package)
  Future<LatLng?> getLatLngFromQuery(String query) async {
    // Example:
    // final geocoding = Geocoding();
    // final results = await geocoding.search(query);
    // if (results.isNotEmpty) {
    //   final first = results.first;
    //   return LatLng(first.latitude, first.longitude);
    // }
    // return null;

    // For now, return null or mock
    return null;
  }
}
/*
class _SearchBar extends StatelessWidget {
  final MapController mapController;

  const _SearchBar({required this.mapController});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
              ),
            ],
          ),
          child: TextField(
            onSubmitted: (value) async {
              // Replace this with actual geocoding logic
              final location =
                  await getLatLngFromQuery(value); // your geocoding function
              if (location != null) {
                mapController.move(location, 17);
              }
            },
            decoration: InputDecoration(
              hintText: "Search for location...",
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ),
    );
  }

  Future<LatLng?> getLatLngFromQuery(String query) async {
    // Replace with actual API call
    // Return example: LatLng(19.0760, 72.8777);
  }
}

 */
/*
class _TreeCounter extends StatefulWidget {
  final int initialCount;
  final void Function(int) onChanged;

  const _TreeCounter({
    required this.initialCount,
    required this.onChanged,
    super.key,
  });

  @override
  State<_TreeCounter> createState() => _TreeCounterState();
}

class _TreeCounterState extends State<_TreeCounter> {
  late int count;

  @override
  void initState() {
    super.initState();
    count = widget.initialCount;
  }

  void _increment() {
    setState(() => count++);
    widget.onChanged(count);
  }

  void _decrement() {
    if (count > 1) {
      setState(() => count--);
      widget.onChanged(count);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF0F4C3B),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Selected:',
              style: TextStyle(
                color: AppColor.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              onPressed: count > 1 ? _decrement : null,
              icon: Icon(Icons.remove_circle,
                  color: count > 1 ? Colors.white : Colors.white24),
              iconSize: 24,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '$count',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
            IconButton(
              onPressed: _increment,
              icon: const Icon(Icons.add_circle, color: Colors.white),
              iconSize: 24,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}

 */


class _TreeCounter extends StatefulWidget {
  final int initialCount;
  final void Function(int) onChanged;

  const _TreeCounter({required this.initialCount, required this.onChanged});

  @override
  State<_TreeCounter> createState() => _TreeCounterState();
}

class _TreeCounterState extends State<_TreeCounter> {
  late int count;

  @override
  void initState() {
    super.initState();
    count = widget.initialCount;
    debugLog(OrderFlowState().orderType.name,name: "orderType");
    if (OrderFlowState().orderType == OrderType.birthday) {
      count = 20;
    }

    if (OrderFlowState().orderType == OrderType.anniversary) {
      count = 25;
    }
  }

  void _increment() {
    setState(() => count++);
    widget.onChanged(count);
  }

  void _decrement() {
    if (count > 1) {
      setState(() => count--);
      widget.onChanged(count);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 55,
      padding:  EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
          color: const Color(0xFF0F4C3B),
          borderRadius: BorderRadius.all(Radius.circular(25))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 4.w,
        children: [
          Text('Selected',
              style: AppFonts.body.copyWith(
                  fontWeight: FontWeight.bold, color: AppColor.white)),
          IconButton(
              onPressed: _decrement,
              icon: Icon(Icons.remove, color: Colors.white)),
          Text("$count",
              style: AppFonts.body.copyWith(
                  fontWeight: FontWeight.bold, color: AppColor.white)),
          IconButton(
              onPressed: _increment,
              icon: Icon(Icons.add, color: Colors.white)),
        ],
      ),
    );
  }
}





class _BottomButtons extends StatelessWidget {
  final VoidCallback onContinue;

  const _BottomButtons({required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 16,
      right: 16,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00473C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: onContinue,
        child: const Text(
          'Continue',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}

/*
MapController mapController = MapController();

class MapScreen extends StatelessWidget {


  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final zone1 = [
      LatLng(19.0760, 72.8777), // Near CST
      LatLng(19.0765, 72.8777),
      LatLng(19.0765, 72.8785),
      LatLng(19.0760, 72.8785),
    ];

    final zone2 = [
      LatLng(19.0896, 72.8656), // Near Dadar
      LatLng(19.0901, 72.8656),
      LatLng(19.0901, 72.8664),
      LatLng(19.0896, 72.8664),
    ];

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              maxZoom: MapConstant.maximumZoom,
              minZoom: MapConstant.minimumZoom,
              initialZoom: MapConstant.initialZoom,
              backgroundColor: AppColor.white,
              initialCenter: MapConstant.initialCenter,
              // cameraConstraint: CameraConstraint.containCenter(bounds: MapConstant.cameraConstrains),
              onTap: (TapPosition, LatLng){

                // hidePopup();
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              PolygonLayer(
                polygons: [
                  Polygon(
                    points: zone1,
                    color: AppColor.primary,
                    borderColor: Colors.green[900]!,
                    borderStrokeWidth: 1.5,
                  ),
                  Polygon(
                    points: zone2,
                    color: AppColor.warning,
                    borderColor: Colors.green[900]!,
                    borderStrokeWidth: 1.5,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(37.421, -122.083),
                    width: 30,
                    height: 30,
                    child: Icon(Icons.location_on, color: Colors.green[900], size: 30),
                  ),
                ],
              ),
            ],
          ),
          _TopBar(),
          _BottomButtons(),

        ],
      ),
    );
  }


}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(Icons.menu, color: Colors.black),
              const SizedBox(width: 8),
              const Expanded(
                child: Text("Search by location", style: TextStyle(fontWeight: FontWeight.w500)),
              ),
              Icon(Icons.notifications_none),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 16,
      right: 16,
      child: Column(
        spacing: 15.h,
        children: [
          Row(
            children: [
              Expanded(
                  child:CounterContainer()
                /*
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: Text("Selected - 10 +", style: TextStyle(color: Colors.white)),
              ),
            ),

             */
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFFF6EFD8),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Text("Plant here", style: TextStyle(color: Colors.black)),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 1.sw,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00473C),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              onPressed: () {
                // TODO: Navigate to next screen
                // AppRoute.goToNextPage(context: context, screen: SignInScreen.route, arguments: {});
              },
              child: Text(
                'Continue',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: const Color(0xFFF8F4E3),
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      )

    );
  }
}



class CounterContainer extends StatefulWidget {
  const CounterContainer({Key? key}) : super(key: key);

  @override
  _CounterContainerState createState() => _CounterContainerState();
}

class _CounterContainerState extends State<CounterContainer> {
  int _count = 10; // Initial count

  void _incrementCount() {
    setState(() {
      _count++;
    });
  }

  void _decrementCount() {
    setState(() {
      if (_count > 0) { // Prevent negative counts, adjust as needed
        _count--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 5.w,
        children: [
          Text(
            "Selected",
            style: AppFonts.body.copyWith(color: AppColor.white)
          ),
          // Decrement button
          InkWell(
            onTap: _decrementCount,
            child:  Icon(Icons.remove,color: AppColor.white,)
          ),
          // Display the count
          Text(
            "$_count",
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          // Increment button
          InkWell(
            onTap: _incrementCount,
            child: Icon(Icons.add,color: AppColor.white,)
          ),
        ],
      ),
    );
  }
}

 */

class DynamicPinMapScreen extends StatefulWidget {
  const DynamicPinMapScreen({super.key});

  @override
  State<DynamicPinMapScreen> createState() => _DynamicPinMapScreenState();
}

class _DynamicPinMapScreenState extends State<DynamicPinMapScreen> {
  final MapController _mapController = MapController();
  final List<PinData> _pins = [];
  double _zoom = 13;

  void _dropPin(LatLng point) {
    setState(() {
      _pins.add(PinData(position: point, plantCount: 1));
    });
  }

  void _increment(PinData pin) {
    setState(() {
      pin.plantCount++;
    });
  }

  void _decrement(PinData pin) {
    setState(() {
      if (pin.plantCount > 0) {
        pin.plantCount--;
      }
      if (pin.plantCount <= 0) {
        _pins.removeWhere((p) => p.position == pin.position);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          maxZoom: MapConstant.maximumZoom,
          minZoom: MapConstant.minimumZoom,
          initialZoom: MapConstant.initialZoom,
          backgroundColor: AppColor.white,
          initialCenter: MapConstant.initialCenter,
          // cameraConstraint: CameraConstraint.containCenter(bounds: MapConstant.cameraConstrains),
          onTap: (_, point) => _dropPin(point),
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
          CurrentLocationLayer(
            style: const LocationMarkerStyle(
              marker: DefaultLocationMarker(
                child: Icon(
                  Icons.navigation,
                  color: Colors.white,
                ),
              ),
              markerSize: Size(40, 40),
              markerDirection: MarkerDirection.heading,
            ),
          ),
          MarkerLayer(
            markers: _pins.map((pin) {
              return Marker(
                point: pin.position,
                width: 160,
                height: 120,
                child: Column(
                  children: [
                    _buildCounterCard(pin),
                    const SizedBox(height: 6),
                    SvgPicture.asset(Images.pinIcon),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterCard(PinData pin) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4.w,
        children: [
          IconButton(
            onPressed: () => _decrement(pin),
            icon: const Icon(Icons.remove_circle, color: Colors.red),
          ),
          Text(
            '${pin.plantCount}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () => _increment(pin),
            icon: const Icon(Icons.add_circle, color: AppColor.primary),
          ),
        ],
      ),
    );
  }
}

class PinData {
  final LatLng position;
  int plantCount;

  PinData({required this.position, required this.plantCount});
}


class EmptyProjectAreasWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const EmptyProjectAreasWidget({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Tree Illustration
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: AppColor.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background circles for depth
                  Positioned(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColor.secondary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Main icon
                  Icon(
                    Icons.park_outlined,
                    size: 80,
                    color: AppColor.primary.withOpacity(0.7),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Title
            const Text(
              "No Project Areas Yet",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColor.textPrimary,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              "We couldn't find any project areas at the moment.\nThis could be because:",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: AppColor.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),

            // Reasons List
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColor.cardBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColor.border,
                  width: 1,
                ),
              ),
              child: _buildReasonItem(
                icon: Icons.folder_outlined,
                text: "No areas have been created yet",
                color: AppColor.secondary,
              ),
            ),
            const SizedBox(height: 28),

            // Retry Button
            if (onRetry != null)
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: const Text(
                  "Try Again",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  foregroundColor: AppColor.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  shadowColor: AppColor.primary.withOpacity(0.3),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReasonItem({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: color,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColor.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}