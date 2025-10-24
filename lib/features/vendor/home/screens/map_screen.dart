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
import '../../../../common/screens/satellite_history_screen.dart';
import '../../../../core/config/resource/images.dart';
import '../../../../core/config/themes/app_color.dart';
import '../../../../core/network/api_connection.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/widgets/common_notification.dart';
import '../../../../core/widgets/tree_bottomsheet.dart';
import '../../../authentication/screens/sign_in_screen.dart';
import '../../../customer/retail/my-trees/screens/tree_maintenance_list.dart';
import '../../../customer/retail/my-trees/screens/tree_monitoring_history.dart';
import '../bloc/map_bloc.dart';
/// this is important
/*
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

 */

/*
class RecyclingPointsScreen extends StatefulWidget {
  static const route = '/RecyclingPointsScreen';
  const RecyclingPointsScreen({super.key});

  @override
  State<RecyclingPointsScreen> createState() => _RecyclingPointsScreenState();
}

class _RecyclingPointsScreenState extends State<RecyclingPointsScreen> {
  final MapController _mapController = MapController();
  bool _isMapTabActive = true; // Track which tab is active
  List<Map<String, dynamic>> _recyclingPoints = []; // Mock data for recycling points

  @override
  void initState() {
    super.initState();
    _fetchRecyclingPoints(); // Simulate fetching data
  }

  Future<void> _fetchRecyclingPoints() async {
    // Mock data for recycling points
    _recyclingPoints = [
      {
        'name': 'Gips-eco',
        'address': 'Paper, Plastic, Tetra pack',
        'coordinates': [52.2296756, 21.0122287],
        'distance': '1.5 km',
        'status': 'Always open',
      },
      {
        'name': 'Eco Center',
        'address': 'Plastic, Glass, Metal',
        'coordinates': [52.2300000, 21.0100000],
        'distance': '2.0 km',
        'status': 'Open 9 AM - 5 PM',
      },
      // Add more mock data as needed
    ];
    setState(() {});
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Implement filter functionality
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isMapTabActive = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _isMapTabActive ? Colors.green : Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Map'),
          ),
          SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isMapTabActive = false;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: !_isMapTabActive ? Colors.green : Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('List'),
          ),
        ],
      ),
    );
  }



  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: LatLng(52.2296756, 21.0122287), // Default location
        initialZoom: 14.0,
        minZoom: 6.0,
        maxZoom: 20.0,
        interactionOptions:InteractionOptions(
          flags: InteractiveFlag.all,
        )

      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        CurrentLocationLayer(),
        MarkerLayer(
          markers: _recyclingPoints.map((point) {
            final coordinates = point['coordinates'] as List<double>;
            return Marker(
              width: 40,
              height: 40,
              point: LatLng(coordinates[0], coordinates[1]),
              child: GestureDetector(
                onTap: () {
                  _showPointDetails(point);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      point['name'].substring(0, 2),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showPointDetails(Map<String, dynamic> point) {
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
              // Point Info
              Text(
                point['name'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 8),
              Text(
                point['address'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 16),
              // Status and Distance
              Row(
                children: [
                  Text(
                    point['status'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '(${point['distance']})',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      _openMapsApp(point['coordinates'][0], point['coordinates'][1]);
                      Navigator.pop(ctx); // Close bottom sheet
                    },
                    icon: Icon(Icons.directions, size: 18, color: Colors.white),
                    label: Text("Show direction"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      _openMapsApp(point['coordinates'][0], point['coordinates'][1]);
                      Navigator.pop(ctx); // Close bottom sheet
                    },
                    child: Text("Google Maps"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _openMapsApp(double lat, double lng) async {
    String url = "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open maps")),
      );
    }
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: _recyclingPoints.length,
      itemBuilder: (context, index) {
        final point = _recyclingPoints[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green,
            child: Text(
              point['name'].substring(0, 2),
              style: TextStyle(color: Colors.white),
            ),
          ),
          title: Text(point['name']),
          subtitle: Text(point['address']),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                point['status'],
                style: TextStyle(color: Colors.green),
              ),
              Text('(${point['distance']})'),
            ],
          ),
          onTap: () {
            _showPointDetails(point);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Recycling points'),
      // ),
      body: Column(
        children: [
          HeaderSection(),
          // _buildSearchBar(),
          // _buildTabs(),
          Expanded(
            child: _isMapTabActive ? _buildMap() : _buildList(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Points',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scanner',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 1, // Points tab is active by default
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }
}

class HeaderSection extends StatefulWidget {
  const HeaderSection({super.key});

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  bool _isMapTabActive = true; // Track which tab is active

  void _toggleTabs(bool isMap) {
    setState(() {
      _isMapTabActive = isMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () {
                  // Implement filter functionality
                },
              ),
            ],
          ),
        ),

        // Tabs
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  _toggleTabs(true);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: _isMapTabActive ? Colors.green : Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Map'),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  _toggleTabs(false);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: !_isMapTabActive ? Colors.green : Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('List'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


 */


/*
class TreeOnMapScreen extends StatefulWidget {
  const TreeOnMapScreen({super.key});

  @override
  State<TreeOnMapScreen> createState() => _TreeOnMapScreenState();
}

class _TreeOnMapScreenState extends State<TreeOnMapScreen> {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
       backgroundColor: Colors.white,
        body: Column(
          children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child:Row(
                  spacing: 10.w,
                  children: [
                    GestureDetector(
                      onTap: (){

                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.arrow_back, color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        // width: size.width*0.765,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            icon: Icon(Icons.search),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),

      
                  ],
                )
              ),
            const SizedBox(height: 12),
            SmoothToggleTab(),
            const SizedBox(height: 12),
            Expanded(
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(52.2297, 21.0122),
                  initialZoom: 14
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
                  MarkerLayer(
                    markers: [
                      Marker(
                        width:40,
                        height: 40,
                        point: LatLng(52.2297, 21.0122),
                       child:   SvgPicture.asset(Images.treeMarker)
                      ),
                      // Add more markers here
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

 */

/// Working code
/*
class VendorMapScreen extends StatefulWidget {
  static const route = '/VendorMapScreen';
  final  String areaId;
  const VendorMapScreen({super.key,required this.areaId});
  // const TreeOnMapScreen({super.key});

  @override
  State<VendorMapScreen> createState() => _VendorMapScreenState();
}

class _VendorMapScreenState extends State<VendorMapScreen> {
  final MapController _mapController = MapController();
  late MapBloc mapBloc;
  final pref = SecurePreference();

  @override
  void initState() {
    super.initState();
    mapBloc = MapBloc(PlantationRepository(api: ApiConnection()));
    _fetchTreeList();
  }

  void _fetchTreeList() async {
    final vendorId = await pref.getString(Keys.id);
    mapBloc.add(ApiListFetch()); // Same API event as VendorMapScreen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (_) => mapBloc,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  spacing: 10.w,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.arrow_back, color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            icon: Icon(Icons.search),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const SmoothToggleTab(),
              const SizedBox(height: 12),
          
              // 📍 Map with BlocBuilder
              Expanded(
                child: BlocBuilder<MapBloc,
                    ApiState<PlantedListResponseModel, ResponseModel>>(
                  builder: (context, state) {
                    if (state is ApiLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ApiSuccess<PlantedListResponseModel, ResponseModel>) {
                      final plantedData = state.data;
          
                      final markers = plantedData.data.map((datum) {
                        final lat = datum.location.coordinates[1]; // latitude
                        final lng = datum.location.coordinates[0]; // longitude
                        return Marker(
                          point: LatLng(lat, lng),
                          width: 40,
                          height: 40,
                          child: GestureDetector(
                            onTap: () => _showTreeInfoBottomSheet(context,datum),
                            child: SvgPicture.asset(Images.treeMarker),
                          ),
                        );
                      }).toList();
          
                      return Stack(
                        children: [
                          FlutterMap(
                            mapController: _mapController,
                            options: MapOptions(
                              initialCenter: LatLng(19.112251, 72.864512),
                              initialZoom: 10,
                              maxZoom: 20,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                                tileProvider: NetworkTileProvider(
                                  headers: {
                                    'User-Agent': 'TreelovApp/1.0 (https://yourapp.com)',
                                  },
                                ),
                              ),
                              CurrentLocationLayer(),
                              MarkerLayer(markers: markers),
                            ],
                          ),
                          _buildZoomButtons(),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildZoomButtons() {
    return Positioned(
      bottom: 20,
      right: 16,
      child: Column(
        children: [
          FloatingActionButton(
            heroTag: 'zoomIn',
            mini: true,
            backgroundColor: Colors.white,
            onPressed: () => _mapController.move(
              _mapController.camera.center,
              _mapController.camera.zoom + 1,
            ),
            child: Icon(Icons.add, color: Colors.green[800]),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'zoomOut',
            mini: true,
            backgroundColor: Colors.white,
            onPressed: () => _mapController.move(
              _mapController.camera.center,
              _mapController.camera.zoom - 1,
            ),
            child: Icon(Icons.remove, color: Colors.green[800]),
          ),
        ],
      ),
    );
  }

  void _showTreeInfoBottomSheet(BuildContext context, Datum datum) {
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
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image Carousel
              SizedBox(
                height: 180,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 1,
                  separatorBuilder: (_, __) => SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final imageUrl = BaseNetwork.BASE_Image_URL + datum.thumbnail.toString();
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(imageUrl, width: 140, fit: BoxFit.cover),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),

              // Tree Info Cards
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _infoCard("Species", datum.treeSpecies ?? "Unknown", Icons.eco),
                  _infoCard("Height", "${datum.treeHeight} ft", Icons.height),
                  _infoCard("Girth", "${datum.treeGirth} ft", Icons.circle),
                  _infoCard("Planted", datum.plantationDate.toString(), Icons.calendar_today),
                ],
              ),
              SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Navigate to maintenance history
                      },
                      icon: Icon(Icons.history),
                      label: Text("Maintenance History"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black87,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _openMapsApp(lat, lng);
                        Navigator.pop(ctx);
                      },
                      icon: Icon(Icons.navigation),
                      label: Text("Navigate"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _infoCard(String title, String value, IconData icon) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.green[700]),
          SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }


  void _openMapsApp(double lat, double lng) async {
    String url = "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showNotification(context, message: "Could not open maps");
    }
  }

/*
  void _showTreeInfoBottomSheet(BuildContext context, Datum datum) {
    // Same bottom sheet logic from VendorMapScreen
  }

 */
}


class SmoothToggleTab extends StatefulWidget {
  const SmoothToggleTab({super.key});

  @override
  State<SmoothToggleTab> createState() => _SmoothToggleTabState();
}

class _SmoothToggleTabState extends State<SmoothToggleTab> with TickerProviderStateMixin {
  bool _isMapSelected = true;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 280));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle(bool isMap) {
    if (_isMapSelected == isMap) return; // Prevent redundant taps
    setState(() {
      _isMapSelected = isMap;
    });
    _controller
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    // final isSmallScreen = size.width < 600 || kIsWeb; // Responsive touch area

    return Container(
      height: 45,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 🟡 Animated Slide Indicator
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              // Interpolate position: 0 = Map (left), 1 = List (right)
              final position = _animation.value;
              final t = _isMapSelected ? 1 - position : position;

              return Align(
                alignment: Alignment.lerp(const Alignment(-1, 0), const Alignment(1, 0), t)!,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    width: (MediaQuery.sizeOf(context).width - 40) / 2,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // 🔘 Toggle Labels (GestureDetector)
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _toggle(true),
                  child: Center(
                    child: Text(
                      'Map',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: _isMapSelected ? FontWeight.w600 : FontWeight.w500,
                        color: _isMapSelected ? Colors.blueGrey[800] : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _toggle(false),
                  child: Center(
                    child: Text(
                      'List',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: !_isMapSelected ? FontWeight.w600 : FontWeight.w500,
                        color: !_isMapSelected ? Colors.blueGrey[800] : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

 */

/*
class VendorMapScreen extends StatefulWidget {
  static const route = '/VendorMapScreen';
  final String areaId;
  const VendorMapScreen({super.key, required this.areaId});

  @override
  State<VendorMapScreen> createState() => _VendorMapScreenState();
}

class _VendorMapScreenState extends State<VendorMapScreen>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  late MapBloc mapBloc;
  final pref = SecurePreference();
  bool _isMapView = true;
  String _searchQuery = '';
  late AnimationController _viewTransitionController;
  late Animation<double> _viewTransitionAnimation;

  @override
  void initState() {
    super.initState();
    mapBloc = MapBloc(PlantationRepository(api: ApiConnection()));
    _viewTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _viewTransitionAnimation = CurvedAnimation(
      parent: _viewTransitionController,
      curve: Curves.easeInOutCubic,
    );
    _fetchTreeList();
  }

  @override
  void dispose() {
    _viewTransitionController.dispose();
    super.dispose();
  }

  void _fetchTreeList() async {
    final vendorId = await pref.getString(Keys.id);
    mapBloc.add(ApiListFetch());
  }

  void _toggleView(bool isMapView) {
    if (_isMapView == isMapView) return;

    setState(() {
      _isMapView = isMapView;
    });

    if (isMapView) {
      _viewTransitionController.reverse();
    } else {
      _viewTransitionController.forward();
    }
  }

  List<Datum> _filterTrees(List<Datum> trees) {
    if (_searchQuery.isEmpty) return trees;
    return trees.where((tree) =>
    tree.treeSpecies.localName.toString().toLowerCase().contains(_searchQuery.toLowerCase()) == true ||
        tree.plantationDate.toString().contains(_searchQuery)
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      body: BlocProvider(
        create: (_) => mapBloc,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              SmoothToggleTab(
                isMapSelected: _isMapView,
                onToggle: _toggleView,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<MapBloc,
                    ApiState<PlantedListResponseModel, ResponseModel>>(
                  builder: (context, state) {
                    if (state is ApiLoading) {
                      return _buildLoadingState();
                    } else if (state is ApiSuccess<PlantedListResponseModel, ResponseModel>) {
                      final plantedData = state.data;
                      final filteredTrees = _filterTrees(plantedData.data);

                      return AnimatedBuilder(
                        animation: _viewTransitionAnimation,
                        builder: (context, child) {
                          return Stack(
                            children: [
                              // Map View
                              Opacity(
                                opacity: 1 - _viewTransitionAnimation.value,
                                child: Transform.scale(
                                  scale: 1 - (_viewTransitionAnimation.value * 0.05),
                                  child: _buildMapView(filteredTrees),
                                ),
                              ),
                              // List View
                              Opacity(
                                opacity: _viewTransitionAnimation.value,
                                child: Transform.translate(
                                  offset: Offset(0, 50 * (1 - _viewTransitionAnimation.value)),
                                  child: _buildListView(filteredTrees),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      return _buildEmptyState();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search trees...',
                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading trees...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.eco,
              size: 48,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "No trees found",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Try adjusting your search or check back later",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView(List<Datum> trees) {
    final markers = trees.map((datum) {
      final lat = datum.location.coordinates[1];
      final lng = datum.location.coordinates[0];
      return Marker(
        point: LatLng(lat, lng),
        width: 40,
        height: 40,
        child: GestureDetector(
          onTap: () => _showEnhancedTreeBottomSheet(context, datum),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SvgPicture.asset(Images.treeMarker),
            ),
          ),
        ),
      );
    }).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: const LatLng(19.112251, 72.864512),
                initialZoom: 10,
                maxZoom: 20,
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
            ),
            _buildZoomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(List<Datum> trees) {
    if (trees.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        itemCount: trees.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final tree = trees[index];
          return _buildTreeCard(tree);
        },
      ),
    );
  }

  Widget _buildTreeCard(Datum tree) {
    final imageUrl = BaseNetwork.BASE_Image_URL + tree.thumbnail.toString();

    return GestureDetector(
      onTap: () => _showEnhancedTreeBottomSheet(context, tree),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.eco,
                        color: Colors.green[600],
                        size: 32,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tree.treeSpecies.localName.toString() ?? "Unknown Species",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Height: ${tree.treeHeight} ft",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Planted: ${tree.plantationDate.toString()}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.eco,
                  color: Colors.green[600],
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildZoomButtons() {
    return Positioned(
      bottom: 20,
      right: 16,
      child: Column(
        children: [
          _buildZoomButton(
            icon: Icons.add,
            onPressed: () => _mapController.move(
              _mapController.camera.center,
              _mapController.camera.zoom + 1,
            ),
          ),
          const SizedBox(height: 8),
          _buildZoomButton(
            icon: Icons.remove,
            onPressed: () => _mapController.move(
              _mapController.camera.center,
              _mapController.camera.zoom - 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoomButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(28),
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Icon(
              icon,
              color: Colors.green[700],
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  void _showEnhancedTreeBottomSheet(BuildContext context, Datum datum) {
    final lat = datum.location.coordinates[1];
    final lng = datum.location.coordinates[0];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  // Drag Handle
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildImageSection(datum),
                          const SizedBox(height: 24),
                          _buildTreeInfoSection(datum),
                          const SizedBox(height: 24),
                          _buildActionButtons(ctx, lat, lng),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildImageSection(Datum datum) {
    final imageUrl = BaseNetwork.BASE_Image_URL + datum.thumbnail.toString();

    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.green[200]!, Colors.green[400]!],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Icon(
                  Icons.eco,
                  size: 64,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTreeInfoSection(Datum datum) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          datum.treeSpecies.localName.toString() ?? "Unknown Species",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildEnhancedInfoCard(
              "Height",
              "${datum.treeHeight} ft",
              Icons.height,
              Colors.blue,
            ),
            _buildEnhancedInfoCard(
              "Girth",
              "${datum.treeGirth} ft",
              Icons.donut_large,
              Colors.orange,
            ),
            _buildEnhancedInfoCard(
              "Planted",
              _formatDate(datum.plantationDate.toString()),
              Icons.calendar_today,
              Colors.green,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEnhancedInfoCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: (MediaQuery.of(context).size.width - 72) / 2,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: color,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext ctx, double lat, double lng) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                onPressed: () {
                  // Navigate to maintenance history
                  Navigator.pop(ctx);
                },
                icon: Icons.history,
                label: "History",
                isPrimary: false,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionButton(
                onPressed: () {
                  _openMapsApp(lat, lng);
                  Navigator.pop(ctx);
                },
                icon: Icons.navigation,
                label: "Navigate",
                isPrimary: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required bool isPrimary,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: isPrimary
            ? [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ]
            : null,
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Colors.green[600] : Colors.grey[100],
          foregroundColor: isPrimary ? Colors.white : Colors.black87,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return dateString;
    }
  }

  void _openMapsApp(double lat, double lng) async {
    String url = "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showNotification(context, message: "Could not open maps");
    }
  }
}

class SmoothToggleTab extends StatefulWidget {
  final bool isMapSelected;
  final Function(bool) onToggle;

  const SmoothToggleTab({
    super.key,
    required this.isMapSelected,
    required this.onToggle,
  });

  @override
  State<SmoothToggleTab> createState() => _SmoothToggleTabState();
}

class _SmoothToggleTabState extends State<SmoothToggleTab>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    if (widget.isMapSelected) {
      _controller.reset();
    } else {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(SmoothToggleTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isMapSelected != widget.isMapSelected) {
      if (widget.isMapSelected) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Align(
                alignment: Alignment.lerp(
                  const Alignment(-1, 0),
                  const Alignment(1, 0),
                  _animation.value,
                )!,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    width: (MediaQuery.sizeOf(context).width - 40) / 2,
                    height: 42,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green[400]!, Colors.green[600]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => widget.onToggle(true),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'Map',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: widget.isMapSelected ? Colors.white : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => widget.onToggle(false),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'List',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: !widget.isMapSelected ? Colors.white : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

 */

class VendorMapScreen extends StatefulWidget {
  static const route = '/VendorMapScreen';
  final String areaId;
  const VendorMapScreen({super.key, required this.areaId});

  @override
  State<VendorMapScreen> createState() => _VendorMapScreenState();
}

class _VendorMapScreenState extends State<VendorMapScreen>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  late MapBloc mapBloc;
  final pref = SecurePreference();
  bool _isMapView = true;
  String _searchQuery = '';
  late AnimationController _viewTransitionController;
  late Animation<double> _viewTransitionAnimation;

  @override
  void initState() {
    super.initState();
    mapBloc = MapBloc(PlantationRepository(api: ApiConnection()));
    _viewTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _viewTransitionAnimation = CurvedAnimation(
      parent: _viewTransitionController,
      curve: Curves.easeInOutCubic,
    );
    _fetchTreeList();
  }

  @override
  void dispose() {
    _viewTransitionController.dispose();
    super.dispose();
  }

  void _fetchTreeList() async {
    final vendorId = await pref.getString(Keys.id);
    mapBloc.add(ApiListFetch());
  }

  void _toggleView(bool isMapView) {
    if (_isMapView == isMapView) return;

    setState(() {
      _isMapView = isMapView;
    });

    if (isMapView) {
      _viewTransitionController.reverse();
    } else {
      _viewTransitionController.forward();
    }
  }

  List<PlantedTreeModel> _filterTrees(List<PlantedTreeModel> trees) {
    if (_searchQuery.isEmpty) return trees;
    return trees.where((tree) =>
    tree.treeSpecies.localName.toString().toLowerCase().contains(_searchQuery.toLowerCase()) == true ||
        tree.plantationDate.toString().contains(_searchQuery)
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      body: BlocProvider(
        create: (_) => mapBloc,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 8.h),
              SmoothToggleTab(
                isMapSelected: _isMapView,
                onToggle: _toggleView,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: BlocBuilder<MapBloc,
                    ApiState<PlantedListResponseModel, ResponseModel>>(
                  builder: (context, state) {
                    if (state is ApiLoading) {
                      return _buildLoadingState();
                    } else if (state is ApiSuccess<PlantedListResponseModel, ResponseModel>) {
                      final plantedData = state.data;
                      final filteredTrees = _filterTrees(plantedData.data);

                      return AnimatedBuilder(
                        animation: _viewTransitionAnimation,
                        builder: (context, child) {
                          return Stack(
                            children: [
                              // Map View
                              if (_isMapView)
                                Opacity(
                                  opacity: 1 - _viewTransitionAnimation.value,
                                  child: Transform.scale(
                                    scale: 1 - (_viewTransitionAnimation.value * 0.05),
                                    child: buildMapView(filteredTrees),
                                  ),
                                ),
                              // List View
                              if (!_isMapView)
                                Opacity(
                                  opacity: _viewTransitionAnimation.value,
                                  child: Transform.translate(
                                    offset: Offset(0, 50 * (1 - _viewTransitionAnimation.value)),
                                    child: _buildListView(filteredTrees),
                                  ),
                                ),
                            ],
                          );
                        },
                      );
                    } else {
                      return _buildEmptyState();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search trees...',
                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading trees...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.eco,
              size: 48,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "No trees found",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Try adjusting your search or check back later",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMapView(List<PlantedTreeModel> trees) {
    final markers = trees.map((datum) {
      final lat = datum.location.coordinates[0];
      final lng = datum.location.coordinates[1];
      return Marker(
        point: LatLng(lat, lng),
        width: 40,
        height: 40,
        child: GestureDetector(
          onTap: () {
            // _showEnhancedTreeBottomSheet(context, datum);
            TreeDetailsBottomSheet.show(
              context,
              treeName: datum.treeSpecies.localName,
              scientificName: datum.treeSpecies.scientificName,
              imageUrl: BaseNetwork.BASE_Image_URL+datum.thumbnail!??datum.treeSpecies.image, // or null
              health: datum.treeHealth,
              growth:datum.treeGrowth,
              girth: '${datum.treeGirth} ${datum.treeGirthUnit}',
              direction: 'Direction',
              onDirectionTap: (){

              },
              nextMaintenanceDate: datum.nextMaintenanceDate,
              nextMonitoringDate: datum.nextMonitoringDate,
              onMaintenanceHistoryTap: () {
                AppRoute.goToNextPage(context: context, screen: TreeMaintenanceHistoryScreen.route, arguments: {
                  'treeSpecies':'neem',
                  'location':"mumbai",
                  'treeId':'2131'
                });
                // Navigate to maintenance history
              },
              onManualMonitorHistoryTap: () {
                AppRoute.goToNextPage(context: context, screen: TreeMonitoringHistoryScreen.route, arguments: {
                  'treeSpecies':'neem',
                  'location':"mumbai",
                  'treeId':'2131'
                });
                // Navigate to manual monitoring history
              },
              onSatelliteMonitorHistoryTap: () {
                AppRoute.goToNextPage(context: context, screen: SatelliteHistoryScreen.route, arguments: {
                  'plantationId':datum.id,
                });
                // Navigate to satellite monitoring history
              },
            );
          },
          child: Container(
            // Add container to prevent tap conflicts
            width: 40,
            height: 40,
            child: SvgPicture.asset(Images.treeMarker),
          ),
        ),
      );
    }).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16), // Add margin here
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: const LatLng(19.112251, 72.864512),
                initialZoom: 10.0,
                minZoom: 3.0,
                maxZoom: 20.0,
                // Fixed interaction options
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.doubleTapZoom |
                  InteractiveFlag.pinchZoom |
                  InteractiveFlag.drag |
                  InteractiveFlag.flingAnimation,
                  enableMultiFingerGestureRace: true,
                  scrollWheelVelocity: 0.005,
                  pinchZoomWinGestures: MultiFingerGesture.pinchZoom,
                ),
                keepAlive: true,
                backgroundColor: Colors.grey.shade100,
                // Add tap handling at map level
                onTap: (tapPosition, point) {
                  // This prevents accidental bottom sheet opening when tapping on map
                  // Only markers should trigger the bottom sheet
                },
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
            ),
            // Add zoom buttons only in map view
            if (_isMapView) buildZoomButtons(),
          ],
        ),
      ),
    );
  }

  // Improved zoom buttons with better positioning
  Widget buildZoomButtons() {
    return Positioned(
      right: 16,
      bottom: 80, // Changed from top to bottom for better UX
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  final currentZoom = _mapController.camera.zoom;
                  if (currentZoom < 20) {
                    _mapController.move(
                      _mapController.camera.center,
                      currentZoom + 1,
                    );
                  }
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 20,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  final currentZoom = _mapController.camera.zoom;
                  if (currentZoom > 3) {
                    _mapController.move(
                      _mapController.camera.center,
                      currentZoom - 1,
                    );
                  }
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.remove,
                    size: 20,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<PlantedTreeModel> trees) {
    if (trees.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        itemCount: trees.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final tree = trees[index];
          return _buildTreeCard(tree);
        },
      ),
    );
  }

  Widget _buildTreeCard(PlantedTreeModel tree) {
    final imageUrl = BaseNetwork.BASE_Image_URL + tree.thumbnail.toString();

    return GestureDetector(
      onTap: () {
        // _showEnhancedTreeBottomSheet(context, tree);
        TreeDetailsBottomSheet.show(
          context,
          treeName: tree.treeSpecies.localName,
          scientificName: tree.treeSpecies.scientificName,
          imageUrl: BaseNetwork.BASE_Image_URL+tree.thumbnail!??tree.treeSpecies.image, // or null
          health: tree.treeHealth,
          growth:tree.treeGrowth,
          girth: '${tree.treeGirth} ${tree.treeGirthUnit}',
          direction: 'Direction',
          onDirectionTap: (){

          },
          nextMaintenanceDate: tree.nextMaintenanceDate,
          nextMonitoringDate: tree.nextMonitoringDate,
          onMaintenanceHistoryTap: () {
            AppRoute.goToNextPage(context: context, screen: TreeMaintenanceHistoryScreen.route, arguments: {
              'treeId':tree.id
            });
            // Navigate to maintenance history
          },
          onManualMonitorHistoryTap: () {
            AppRoute.goToNextPage(context: context, screen: TreeMonitoringHistoryScreen.route, arguments: {
              'treeId':tree.id
            });
            // Navigate to manual monitoring history
          },
          onSatelliteMonitorHistoryTap: () {
            AppRoute.goToNextPage(context: context, screen: SatelliteHistoryScreen.route, arguments: {
              'plantationId':tree.id,
            });
            // Navigate to satellite monitoring history
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.eco,
                        color: Colors.green[600],
                        size: 32,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tree.treeSpecies.localName.toString() ?? "Unknown Species",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Height: ${tree.treeHeight} ft",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Planted: ${tree.plantationDate.toString()}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.eco,
                  color: Colors.green[600],
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEnhancedTreeBottomSheet(BuildContext context, PlantedTreeModel treeModel) {
    final lat = treeModel.location.coordinates[1];
    final lng = treeModel.location.coordinates[0];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  // Drag Handle
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildImageSection(treeModel),
                          const SizedBox(height: 24),
                          _buildTreeInfoSection(treeModel),
                          const SizedBox(height: 24),
                          _buildActionButtons(ctx, lat, lng),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildImageSection(PlantedTreeModel treeModel) {
    final imageUrl = BaseNetwork.BASE_Image_URL + treeModel.treeSpecies.image.toString();

    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     blurRadius: 15,
        //     offset: const Offset(0, 4),
        //   ),
        // ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.network(
               "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRuCZtWNJjBjxoVw9OCxZXKQE-biHdtZ7c5Ig&s"
            );
          },
        ),
      ),
    );
  }

  Widget _buildTreeInfoSection(PlantedTreeModel datum) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          datum.treeSpecies.localName.toString() ?? "Unknown Tree",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
       SizedBox(
         height: 2,
       ),
        Text(
          datum.treeSpecies.scientificName.toString() ?? "Scientific name unavailable",
          style: TextStyle(
            fontSize: 18,
            fontStyle: FontStyle.italic,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildEnhancedInfoCard(
              "Height",
              "${datum.treeHeight} ft",
              Icons.height,
              Colors.blue,
            ),
            _buildEnhancedInfoCard(
              "Girth",
              "${datum.treeGirth} ft",
              Icons.donut_large,
              Colors.orange,
            ),
            _buildEnhancedInfoCard(
              "Planted",
              _formatDate(datum.plantationDate.toString()),
              Icons.calendar_today,
              Colors.green,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEnhancedInfoCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: (MediaQuery.of(context).size.width - 72) / 2,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: color,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          )

        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext ctx, double lat, double lng) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                onPressed: () {
                  // Navigate to maintenance history
                  Navigator.pop(ctx);
                },
                icon: Icons.history,
                label: "History",
                isPrimary: false,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionButton(
                onPressed: () {
                  _openMapsApp(lat, lng);
                  Navigator.pop(ctx);
                },
                icon: Icons.navigation,
                label: "Navigate",
                isPrimary: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required bool isPrimary,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: isPrimary
            ? [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ]
            : null,
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Colors.green[600] : Colors.grey[100],
          foregroundColor: isPrimary ? Colors.white : Colors.black87,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return dateString;
    }
  }

  void _openMapsApp(double lat, double lng) async {
    String url = "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showNotification(context, message: "Could not open maps");
    }
  }
}

class SmoothToggleTab extends StatefulWidget {
  final bool isMapSelected;
  final Function(bool) onToggle;

  const SmoothToggleTab({
    super.key,
    required this.isMapSelected,
    required this.onToggle,
  });

  @override
  State<SmoothToggleTab> createState() => _SmoothToggleTabState();
}

class _SmoothToggleTabState extends State<SmoothToggleTab>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    if (widget.isMapSelected) {
      _controller.reset();
    } else {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(SmoothToggleTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isMapSelected != widget.isMapSelected) {
      if (widget.isMapSelected) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Align(
                alignment: Alignment.lerp(
                  const Alignment(-1, 0),
                  const Alignment(1, 0),
                  _animation.value,
                )!,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    width: (MediaQuery.sizeOf(context).width - 40) / 2,
                    height: 42,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green[400]!, Colors.green[600]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => widget.onToggle(true),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'Map',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: widget.isMapSelected ? Colors.white : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => widget.onToggle(false),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'List',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: !widget.isMapSelected ? Colors.white : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}