import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'package:treelove/core/config/themes/app_fonts.dart';
import 'package:treelove/features/customer/retail/tree-species/tree_species_list.dart';

import '../../../../../core/config/constants/map_constants.dart';
import '../../../../../core/config/resource/images.dart';
import '../../../../../core/config/themes/app_color.dart';

class MapScreen extends StatefulWidget {
  static const route ="/plant-by-location";
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController mapController = MapController();
  LatLng? selectedPoint;
  int treeCount = 1;

  void _onMapTap(LatLng point) {
    setState(() {
      selectedPoint = point;
      treeCount = 1;
    });
  }

  void _updateTreeCount(int count) {
    setState(() {
      treeCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: MapConstant.initialCenter,
              initialZoom: MapConstant.initialZoom,
              maxZoom: MapConstant.maximumZoom,
              minZoom: MapConstant.minimumZoom,
              onTap: (_, latLng) => _onMapTap(latLng),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
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
          _SearchBar(mapController: mapController),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              // Adjust to lift above bottom nav bar
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 15,
                children: [
                  // "Selected - 10 +" Button
                  _TreeCounter(
                    initialCount: treeCount,
                    onChanged: _updateTreeCount,
                  ),
                  ElevatedButton(
                    onPressed: () {
                     AppRoute.goToNextPage(context: context, screen: TreeSpeciesList.route, arguments: {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF0EAD6), // Light beige
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(25), // Rounded corners
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 15),
                      elevation: 5, // Shadow
                    ),
                    child: const Text(
                      'Plant here',
                      style: TextStyle(color: Colors.black87, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 15),
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
