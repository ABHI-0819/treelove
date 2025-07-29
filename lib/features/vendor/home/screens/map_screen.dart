import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:treelove/common/bloc/api_event.dart';
import 'package:treelove/common/models/planted.list.response.model.dart';
import 'package:treelove/common/repositories/plantation_repository.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/core/network/base_network.dart';
import 'package:treelove/core/storage/preference_keys.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../core/config/resource/images.dart';
import '../../../../core/config/themes/app_color.dart';
import '../../../../core/network/api_connection.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/widgets/common_notification.dart';
import '../../../authentication/screens/sign_in_screen.dart';
import '../bloc/map_bloc.dart';

class VendorMapScreen extends StatefulWidget {
  static const route = '/VendorMapScreen';
  final  String areaId;
  const VendorMapScreen({super.key,required this.areaId});

  @override
  State<VendorMapScreen> createState() => _VendorMapScreenState();
}

class _VendorMapScreenState extends State<VendorMapScreen> {

  final MapController _mapController = MapController();

  late MapBloc mapBloc;
  final pref = SecurePreference();

  @override
  void initState() {
    mapBloc = MapBloc(PlantationRepository(api: ApiConnection()));
    _fetchList();
    // MapBloc(PlantationRepository(api: AppConn))
    // TODO: implement initState
    super.initState();
  }

  void _fetchList()async{
    final vendorId= await pref.getString(Keys.id);
    mapBloc.add(ApiListFetch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: BlocProvider(
        create: (context) => mapBloc,
        child: Stack(
          children: [
            // Flutter Map
            BlocListener<MapBloc,
                ApiState<PlantedListResponseModel, ResponseModel>>(
              listener: (context, state) {
                EasyLoading.dismiss();
                if (state is ApiFailure<PlantedListResponseModel, ResponseModel>) {
                  showNotification(
                      context, message: state.error.message.toString());
                } else
                if (state is TokenExpired<PlantedListResponseModel, ResponseModel>) {
                  AppRoute.pushReplacement(
                      context, SignInScreen.route, arguments: {});
                }
              },
              child: BlocBuilder<MapBloc,
                  ApiState<PlantedListResponseModel, ResponseModel>>(
                builder: (context, state) {
                  if(state is ApiLoading){
                    return SafeArea(child: Center(child: CircularProgressIndicator()));
                  } else if (state is ApiSuccess<PlantedListResponseModel, ResponseModel>) {
                    PlantedListResponseModel plantedData = state.data;
                    final markers = plantedData.data.map((datum) {
                      final lat = datum.location.coordinates[0]; // Latitude  ← [lng, lat] in GeoJSON
                      final lng = datum.location.coordinates[1]; // Longitude

                      return Marker(
                        point: LatLng(lat, lng),
                        width: 40.0,
                        height: 40.0,
                        child: GestureDetector(
                          onTap: () {
                            _showTreeInfoBottomSheet(context,datum);
                          },
                          child: SvgPicture.asset(
                            Images.treeMarker,
                            width: 40,
                            height: 40,
                            // fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }).toList();
                    return FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: LatLng(19.112251, 72.864512),
                        initialZoom: 10.0,
                        minZoom: 6.0,
                        maxZoom: 20.0,
                        interactionOptions: InteractionOptions(
                            flags: InteractiveFlag.all
                        ), // Enable pinch, pan, zoom
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                          tileProvider: NetworkTileProvider(
                            headers: {
                              'User-Agent': 'TreelovApp/1.0 (https://yourapp.com)',
                            },
                          ),
                        ),
                        CurrentLocationLayer(),
                        MarkerLayer(markers: markers),
                      ],
                    );
                  } else {
                    return const Center(
                      child: Text(
                        "No tree found",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }
                },
              ),
            ),

            Positioned(
              left: 20.w,
              right: 20.w, // Below your search bar
              child: SafeArea(
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
                      GestureDetector(
                        onTap: () {
                          AppRoute.pop(context); // Go back
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.green.shade800,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '🌳Tap on the tree to view tree details.',
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
            ),
            // Custom Zoom Controls (Bottom Right)
            _buildZoomButtons(context),
          ],
        ),
      ),
    );
  }

  void _showTreeInfoBottomSheet(BuildContext context, Datum datum) {
    final speciesName = "Unknown Species"; // Replace with actual species name if available
    final lat = datum.location.coordinates[1];
    final lng = datum.location.coordinates[0];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Draggable Handle
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),

              // Tree Image (if available)
              if (datum.thumbnail != null && datum.thumbnail!.isNotEmpty)

                Container(
                  height: 200.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(BaseNetwork.BASE_Image_URL + datum.thumbnail!),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Container(
                  height: 150,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.eco, size: 50, color: Colors.green[400]),
                ),
              SizedBox(height: 16),

              // Tree Info
              Text(
                "Tree Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 12),

              _buildInfoRow("Species", 'N/A'),
              _buildInfoRow("Height", "${datum.treeHeight}ft"),
              _buildInfoRow("Girth", "${datum.treeGirth}ft"),
              _buildInfoRow("Planted On", datum.plantationDate.toString()),
              //
              SizedBox(height: 10),
              // See More / See Less Button
              GestureDetector(
                onTap: () {
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("See More",
                        style: TextStyle(
                          color: AppColor.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Direction Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _openMapsApp(lat, lng);
                    Navigator.pop(ctx); // Close bottom sheet
                  },
                  icon: Icon(Icons.directions, size: 18, color: Colors.white),
                  label: Text("Get Directions"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  // Format snake_case or lowercase to Title Case
  String toTitleCase(String? text) {
    if (text == null) return "Unknown";
    return text
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() + w.substring(1).toLowerCase() : '')
        .join(' ');
  }

// Open Google Maps / Apple Maps
  void _openMapsApp(double lat, double lng) async {
    String url = "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showNotification(context, message: "Could not open maps");
    }
  }
  /*

  Widget _buildInfoRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: color ?? Colors.grey[800],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

   */
  Widget _buildInfoRow(String label, String value,
      {Color? color, IconData? icon, bool showDivider = true}) {
    return Column(
      children: [
        Row(
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Icon(
                  icon,
                  size: 18,
                  color: color ?? AppColor.primary, // Use your theme color
                ),
              ),
            Expanded(
              flex: 2,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13.5,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14.5,
                  color: color ?? Colors.grey[800],
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Divider(
              height: 1,
              thickness: 0.6,
              color: Colors.grey[200],
              indent: icon != null ? 32 : 0,
            ),
          ),
      ],
    );
  }

  Widget _buildZoomButtons(BuildContext context) {
    return Positioned(
      bottom: 32.h,
      right: 16.w,
      child: Column(
        children: [
          FloatingActionButton(
            heroTag: 'btnZoomIn',
            mini: true,
            backgroundColor: Colors.white,
            elevation: 4,
            onPressed: () {
              _mapController.move(
                _mapController.camera.center,
                _mapController.camera.zoom + 1.0,
              );
            },
            child: Icon(Icons.add, color: Colors.green[800], size: 24),
          ),
          SizedBox(height: 8.h),
          FloatingActionButton(
            heroTag: 'btnZoomOut',
            mini: true,
            backgroundColor: Colors.white,
            elevation: 4,
            onPressed: () {
              _mapController.move(
                _mapController.camera.center,
                _mapController.camera.zoom - 1.0,
              );
            },
            child: Icon(Icons.remove, color: Colors.green[800], size: 24),
          ),
        ],
      ),
    );
  }
}

