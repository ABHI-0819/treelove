import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:geolocator/geolocator.dart';
import 'package:treelove/core/config/route/app_route.dart';
import 'dart:async';
import '../../../../common/bloc/api_event.dart';
import '../../../../common/bloc/api_state.dart';
import '../../../../common/models/response.mode.dart';
import '../../../../common/repositories/inquiries_repository.dart';
import '../../../../core/config/themes/app_color.dart';
/*
class SelectMonitoringScreen extends StatefulWidget {
  const SelectMonitoringScreen({super.key});

  @override
  State<SelectMonitoringScreen> createState() => _SelectMonitoringScreenState();
}

class _SelectMonitoringScreenState extends State<SelectMonitoringScreen> {
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final MapController _mapController = MapController();
  final Nominatim _nominatim = Nominatim.instance;

  latlong.LatLng _selectedLocation = latlong.LatLng(19.1746, 72.9472); // Use latlong prefix/ Default: Mulund, Mumbai
  final List<Marker> _markers = [];
  List<NominatimResult> _searchResults = [];
  bool _isLoadingLocation = false;
  bool _showSearchResults = false;

  @override
  void initState() {
    super.initState();
    _addMarker(_selectedLocation);
    _pincodeController.addListener(_onPincodeChanged);
  }

  @override
  void dispose() {
    _pincodeController.dispose();
    _addressController.dispose();
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  // Get current location
  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnackBar('Location permissions are permanently denied');
        setState(() => _isLoadingLocation = false);
        return;
      }

      if (permission == LocationPermission.denied) {
        _showSnackBar('Location permission denied');
        setState(() => _isLoadingLocation = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _selectedLocation = latlong.LatLng(position.latitude, position.longitude); // Use prefix
      _addMarker(_selectedLocation);
      _updateAddressFromLocation(_selectedLocation);

      _mapController.move(_selectedLocation, 15);
    } catch (e) {
      _showSnackBar('Error getting location: $e');
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }


  // Search location using Nominatim
  Timer? _searchDebounce;
  Future<void> _onSearchChanged(String query) async {
    if (_searchDebounce?.isActive ?? false) _searchDebounce!.cancel();

    if (query.length < 3) {
      setState(() {
        _showSearchResults = false;
        _searchResults = [];
      });
      return;
    }

    _searchDebounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        final results = await _nominatim.search(query);
        setState(() {
          _searchResults = results;
          _showSearchResults = true;
        });
      } catch (e) {
        _showSnackBar('Search error: $e');
      }
    });
  }

  void _selectSearchResult(NominatimResult result) {
    _selectedLocation = latlong.LatLng(result.lat, result.lon); // Use prefix
    _addMarker(_selectedLocation);

    setState(() {
      _addressController.text = result.displayName;
      _searchController.clear();
      _showSearchResults = false;
      _searchResults = [];
    });

    _mapController.move(_selectedLocation, 15);
  }


  // Add marker on map tap
  void _onMapTapped(TapPosition tapPosition, LatLng position) {
    _selectedLocation = position as latlong.LatLng;
    _addMarker(position);
    _updateAddressFromLocation(position);
  }

  // Add/Update marker on map
  void _addMarker(LatLng position) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          point: position as latlong.LatLng,
          width: 50,
          height: 50,
          child: const Icon(
            Icons.location_on,
            size: 50,
            color: Colors.red,
          ),
        ),
      );
    });
  }

  // Reverse geocoding: coordinates to address
  Future<void> _updateAddressFromLocation(LatLng position) async {
    try {
      final result = await _nominatim.getAddressFromLatLng(
        position.latitude,
        position.longitude,
      );

      if (result != null) {
        setState(() {
          _addressController.text = result.displayName;

          // Extract pincode if available
          if (result.placeId != null) {
            _pincodeController.text = result.placeId;
          }
        });
      }
    } catch (e) {
      _showSnackBar('Error getting address: $e');
    }
  }

  // Forward geocoding: pincode to coordinates
  Timer? _debounce;
  void _onPincodeChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      if (_pincodeController.text.length == 6) {
        _searchByPincode(_pincodeController.text);
      }
    });
  }

  Future<void> _searchByPincode(String pincode) async {
    try {
      final result = await _nominatim.getLatLngFromAddress('$pincode, India');

      if (result != null) {
        _selectedLocation = LatLng(result.latitude, result.longitude) as latlong.LatLng;
        _addMarker(_selectedLocation);

        // Get full address
        final address = await _nominatim.getAddressFromLatLng(
          result.latitude,
          result.longitude,
        );

        if (address != null) {
          setState(() {
            _addressController.text = address.displayName;
          });
        }

        _mapController.move(_selectedLocation, 14);
      }
    } catch (e) {
      _showSnackBar('Invalid pincode or location not found');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _onSubmit() {
    if (_addressController.text.isEmpty) {
      _showSnackBar('Please select a location on the map');
      return;
    }

    print('Pincode: ${_pincodeController.text}');
    print('Address: ${_addressController.text}');
    print('Coordinates: ${_selectedLocation.latitude}, ${_selectedLocation.longitude}');

    _showSnackBar('Location submitted successfully!');
  }

  void _onSelectFromTrees() {
    print('Select from trees clicked');
    // Add your navigation logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: AppBar(
        title: const Text("Monitoring", style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0.5,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
              child: Column(
                children: [
                  // Search Bar with Results
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColor.cardBackground,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColor.divider),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.black.withOpacity(0.4),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                            hintText: 'Search location (min 3 characters)',
                            hintStyle: const TextStyle(
                              color: AppColor.textSecondary,
                              fontSize: 16,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: AppColor.textMuted,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: _getCurrentLocation,
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColor.skyBlue,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: _isLoadingLocation
                                    ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColor.white,
                                    ),
                                  ),
                                )
                                    : const Icon(
                                  Icons.my_location,
                                  color: AppColor.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),

                      // Search Results Dropdown
                      if (_showSearchResults && _searchResults.isNotEmpty)
                        Positioned(
                          top: 60,
                          left: 0,
                          right: 0,
                          child: Container(
                            constraints: const BoxConstraints(maxHeight: 200),
                            decoration: BoxDecoration(
                              color: AppColor.cardBackground,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColor.divider),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: _searchResults.length,
                              separatorBuilder: (context, index) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final result = _searchResults[index];
                                return ListTile(
                                  leading: const Icon(Icons.location_on, size: 20),
                                  title: Text(
                                    result.displayName,
                                    style: const TextStyle(fontSize: 14),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  onTap: () => _selectSearchResult(result),
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // OpenStreetMap Container
                  Container(
                    height: 280,
                    decoration: BoxDecoration(
                      color: AppColor.cardBackground,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColor.divider),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _selectedLocation,
                          initialZoom: 15,
                          onTap: _onMapTapped,
                          interactionOptions: const InteractionOptions(
                            flags: InteractiveFlag.all,
                          ),
                        ),
                        children: [
                          // OpenStreetMap Tile Layer (No API Key!)
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.treelov.app',
                            tileBuilder: (context, tileWidget, tile) {
                              return ColorFiltered(
                                colorFilter: const ColorFilter.mode(
                                  Colors.transparent,
                                  BlendMode.multiply,
                                ),
                                child: tileWidget,
                              );
                            },
                          ),

                          // Marker Layer
                          MarkerLayer(markers: _markers),

                          // Attribution (Required for OSM)
                          RichAttributionWidget(
                            attributions: [
                              TextSourceAttribution(
                                '© OpenStreetMap',
                                onTap: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Pincode Input
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColor.divider),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.black.withOpacity(0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _pincodeController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: const InputDecoration(
                        hintText: 'Pincode (auto-fills address)',
                        hintStyle: TextStyle(
                          color: AppColor.textSecondary,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        counterText: '',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Address Input
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColor.divider),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.black.withOpacity(0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _addressController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Location address (auto-filled from map)',
                        hintStyle: TextStyle(
                          color: AppColor.textSecondary,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Select from Trees Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onSelectFromTrees,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        foregroundColor: AppColor.white,
                        elevation: 4,
                        shadowColor: Colors.black26,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Select from trees planted with us',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.secondaryLight,
                        foregroundColor: AppColor.primary,
                        elevation: 4,
                        shadowColor: Colors.black26,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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

 */
/*

class SelectMonitoringScreen extends StatefulWidget {
  const SelectMonitoringScreen({super.key});

  @override
  State<SelectMonitoringScreen> createState() => _SelectMonitoringScreenState();
}

class _SelectMonitoringScreenState extends State<SelectMonitoringScreen> {
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final MapController _mapController = MapController();
  final Nominatim _nominatim = Nominatim.instance;

  latlong.LatLng _selectedLocation = latlong.LatLng(19.1746, 72.9472);
  final List<Marker> _markers = [];
  List<dynamic> _searchResults = []; // Changed to dynamic
  bool _isLoadingLocation = false;
  bool _showSearchResults = false;

  @override
  void initState() {
    super.initState();
    _addMarker(_selectedLocation);
    _pincodeController.addListener(_onPincodeChanged);
  }

  @override
  void dispose() {
    _pincodeController.dispose();
    _addressController.dispose();
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  // Get current location
  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnackBar('Location permissions are permanently denied');
        setState(() => _isLoadingLocation = false);
        return;
      }

      if (permission == LocationPermission.denied) {
        _showSnackBar('Location permission denied');
        setState(() => _isLoadingLocation = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _selectedLocation = latlong.LatLng(position.latitude, position.longitude);
      _addMarker(_selectedLocation);
      _updateAddressFromLocation(_selectedLocation);

      _mapController.move(_selectedLocation, 15);
    } catch (e) {
      _showSnackBar('Error getting location: $e');
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  // Search location using Nominatim
  Timer? _searchDebounce;
  Future<void> _onSearchChanged(String query) async {
    if (_searchDebounce?.isActive ?? false) _searchDebounce!.cancel();

    if (query.length < 3) {
      setState(() {
        _showSearchResults = false;
        _searchResults = [];
      });
      return;
    }

    _searchDebounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        final results = await _nominatim.search(query);
        setState(() {
          _searchResults = results.take(5).toList(); // Take first 5 results
          _showSearchResults = true;
        });
      } catch (e) {
        _showSnackBar('Search error: $e');
      }
    });
  }

  void _selectSearchResult(dynamic result) { // Changed parameter type
    // Access properties using dot notation
    _selectedLocation = latlong.LatLng(result.latitude, result.longitude);
    _addMarker(_selectedLocation);

    setState(() {
      _addressController.text = result.displayName;
      _searchController.clear();
      _showSearchResults = false;
      _searchResults = [];
    });

    _mapController.move(_selectedLocation, 15);
  }

  // Add marker on map tap
  void _onMapTapped(TapPosition tapPosition, latlong.LatLng position) {
    _selectedLocation = position;
    _addMarker(position);
    _updateAddressFromLocation(position);
  }

  // Add/Update marker on map
  void _addMarker(latlong.LatLng position) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          point: position,
          width: 50,
          height: 50,
          child: const Icon(
            Icons.location_on,
            size: 50,
            color: Colors.red,
          ),
        ),
      );
    });
  }

  // Reverse geocoding: coordinates to address
  Future<void> _updateAddressFromLocation(latlong.LatLng position) async {
    try {
      final result = await _nominatim.getAddressFromLatLng(
        position.latitude,
        position.longitude,
      );

      if (result != null) {
        setState(() {
          _addressController.text = result.displayName;

          // Extract pincode if available
          if (result.addressDetails != null && result.addressDetails['postcode'] != null) {
            _pincodeController.text = result.addressDetails['postcode'];
          }
        });
      }
    } catch (e) {
      _showSnackBar('Error getting address: $e');
    }
  }

  // Forward geocoding: pincode to coordinates
  Timer? _debounce;
  void _onPincodeChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      if (_pincodeController.text.length == 6) {
        _searchByPincode(_pincodeController.text);
      }
    });
  }

  Future<void> _searchByPincode(String pincode) async {
    try {
      final result = await _nominatim.getLatLngFromAddress('$pincode, India');

      if (result != null) {
        _selectedLocation = latlong.LatLng(result.latitude, result.longitude);
        _addMarker(_selectedLocation);

        // Get full address
        final address = await _nominatim.getAddressFromLatLng(
          result.latitude,
          result.longitude,
        );

        if (address != null) {
          setState(() {
            _addressController.text = address.displayName;
          });
        }

        _mapController.move(_selectedLocation, 14);
      }
    } catch (e) {
      _showSnackBar('Invalid pincode or location not found');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _onSubmit() {
    if (_addressController.text.isEmpty) {
      _showSnackBar('Please select a location on the map');
      return;
    }

    print('Pincode: ${_pincodeController.text}');
    print('Address: ${_addressController.text}');
    print('Coordinates: ${_selectedLocation.latitude}, ${_selectedLocation.longitude}');

    _showSnackBar('Location submitted successfully!');
  }

  void _onSelectFromTrees() {
    print('Select from trees clicked');
    // Add your navigation logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: AppBar(
        title: const Text("Monitoring", style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0.5,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
              child: Column(
                children: [
                  // Search Bar with Results
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColor.cardBackground,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColor.divider),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.black.withOpacity(0.4),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                            hintText: 'Search location (min 3 characters)',
                            hintStyle: const TextStyle(
                              color: AppColor.textSecondary,
                              fontSize: 16,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: AppColor.textMuted,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: _getCurrentLocation,
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColor.skyBlue,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: _isLoadingLocation
                                    ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColor.white,
                                    ),
                                  ),
                                )
                                    : const Icon(
                                  Icons.my_location,
                                  color: AppColor.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),

                      // Search Results Dropdown
                      if (_showSearchResults && _searchResults.isNotEmpty)
                        Positioned(
                          top: 60,
                          left: 0,
                          right: 0,
                          child: Container(
                            constraints: const BoxConstraints(maxHeight: 200),
                            decoration: BoxDecoration(
                              color: AppColor.cardBackground,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColor.divider),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: _searchResults.length,
                              separatorBuilder: (context, index) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final result = _searchResults[index];
                                return ListTile(
                                  leading: const Icon(Icons.location_on, size: 20),
                                  title: Text(
                                    result.displayName, // Access property directly
                                    style: const TextStyle(fontSize: 14),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    'Lat: ${result.latitude}, Lng: ${result.longitude}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  onTap: () => _selectSearchResult(result),
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // OpenStreetMap Container
                  Container(
                    height: 280,
                    decoration: BoxDecoration(
                      color: AppColor.cardBackground,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColor.divider),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _selectedLocation,
                          initialZoom: 15,
                          onTap: _onMapTapped,
                          interactionOptions: const InteractionOptions(
                            flags: InteractiveFlag.all,
                          ),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.treelov.app',
                          ),
                          MarkerLayer(markers: _markers),
                          RichAttributionWidget(
                            attributions: [
                              TextSourceAttribution(
                                '© OpenStreetMap',
                                onTap: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Pincode Input
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColor.divider),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.black.withOpacity(0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _pincodeController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: const InputDecoration(
                        hintText: 'Pincode (auto-fills address)',
                        hintStyle: TextStyle(
                          color: AppColor.textSecondary,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        counterText: '',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Address Input
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColor.divider),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.black.withOpacity(0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _addressController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Location address (auto-filled from map)',
                        hintStyle: TextStyle(
                          color: AppColor.textSecondary,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Select from Trees Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onSelectFromTrees,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        foregroundColor: AppColor.white,
                        elevation: 4,
                        shadowColor: Colors.black26,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Select from trees planted with us',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.secondaryLight,
                        foregroundColor: AppColor.primary,
                        elevation: 4,
                        shadowColor: Colors.black26,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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

 */


import '../../../../core/config/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:nominatim_flutter/nominatim_flutter.dart';
import 'package:nominatim_flutter/model/request/request.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import '../../../../core/config/themes/app_color.dart';
import '../../../../core/network/api_connection.dart';
import 'bloc/inquiry_bloc.dart';
import 'models/inquiry_request_model.dart';
import 'planted_tree_map_screen.dart';
/*
class SelectMonitoringScreen extends StatefulWidget {
  static const route ='/SelectMonitoringScreen';
  const SelectMonitoringScreen({super.key});

  @override
  State<SelectMonitoringScreen> createState() => _SelectMonitoringScreenState();
}

class _SelectMonitoringScreenState extends State<SelectMonitoringScreen> {
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final MapController _mapController = MapController();

  latlong.LatLng _selectedLocation = latlong.LatLng(19.1746, 72.9472);
  final List<Marker> _markers = [];
  final List<Marker> _searchMarkers = []; // NEW: For search result markers
  List<dynamic> _searchResults = [];
  bool _isLoadingLocation = false;
  bool _isSearching = false;
  bool _showSearchResults = false;

  @override
  void initState() {
    super.initState();

    NominatimFlutter.instance.configureNominatim(
      userAgent: 'TreeLovApp/1.0',
      enableCurlLog: false,
      printOnSuccess: false,
    );

    _addMarker(_selectedLocation);
    _pincodeController.addListener(_onPincodeChanged);
  }

  @override
  void dispose() {
    _pincodeController.dispose();
    _addressController.dispose();
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnackBar('Location permissions are permanently denied');
        setState(() => _isLoadingLocation = false);
        return;
      }

      if (permission == LocationPermission.denied) {
        _showSnackBar('Location permission denied');
        setState(() => _isLoadingLocation = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _selectedLocation = latlong.LatLng(position.latitude, position.longitude);
      _addMarker(_selectedLocation);
      _updateAddressFromLocation(_selectedLocation);

      _mapController.move(_selectedLocation, 15);
    } catch (e) {
      _showSnackBar('Error getting location: $e');
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  // Search location using Nominatim
  Timer? _searchDebounce;
  Future<void> _onSearchChanged(String query) async {
    if (_searchDebounce?.isActive ?? false) _searchDebounce!.cancel();

    if (query.length < 3) {
      setState(() {
        _showSearchResults = false;
        _searchResults = [];
        _searchMarkers.clear(); // Clear search markers
      });
      return;
    }

    setState(() => _isSearching = true);

    _searchDebounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        final searchRequest = SearchRequest(
          query: query,
          limit: 10, // Increased to show more results on map
          addressDetails: true,
          nameDetails: true,
        );

        final results = await NominatimFlutter.instance.search(
          searchRequest: searchRequest,
          language: 'en-US,en;q=0.5',
        );

        setState(() {
          _searchResults = results;
          _showSearchResults = results.isNotEmpty;
          _isSearching = false;

          // Add markers for all search results on map
          _addSearchMarkersToMap(results);

          // Fit map bounds to show all search results
          if (results.isNotEmpty) {
            _fitMapToSearchResults(results);
          }
        });
      } catch (e) {
        _showSnackBar('Search error: $e');
        setState(() {
          _isSearching = false;
          _showSearchResults = false;
        });
      }
    });
  }

  // NEW: Add multiple markers for search results
  void _addSearchMarkersToMap(List<dynamic> results) {
    _searchMarkers.clear();

    for (int i = 0; i < results.length; i++) {
      final result = results[i];
      final lat = result.lat ?? result.latitude;
      final lon = result.lon ?? result.longitude;

      if (lat != null && lon != null) {
        _searchMarkers.add(
          Marker(
            point: latlong.LatLng(
              double.parse(lat.toString()),
              double.parse(lon.toString()),
            ),
            width: 40,
            height: 40,
            child: GestureDetector(
              onTap: () => _selectSearchResult(result),
              child: Stack(
                children: [
                  // Blue marker for search results
                  const Icon(
                    Icons.location_on,
                    size: 40,
                    color: Colors.blue,
                  ),
                  // Number badge
                  Positioned(
                    top: 8,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
  }

  // NEW: Fit map to show all search results
  void _fitMapToSearchResults(List<dynamic> results) {
    if (results.isEmpty) return;

    double minLat = double.infinity;
    double maxLat = -double.infinity;
    double minLon = double.infinity;
    double maxLon = -double.infinity;

    for (var result in results) {
      final lat = double.parse((result.lat ?? result.latitude).toString());
      final lon = double.parse((result.lon ?? result.longitude).toString());

      if (lat < minLat) minLat = lat;
      if (lat > maxLat) maxLat = lat;
      if (lon < minLon) minLon = lon;
      if (lon > maxLon) maxLon = lon;
    }

    // Add padding to bounds
    final latPadding = (maxLat - minLat) * 0.2;
    final lonPadding = (maxLon - minLon) * 0.2;

    final bounds = LatLngBounds(
      latlong.LatLng(minLat - latPadding, minLon - lonPadding),
      latlong.LatLng(maxLat + latPadding, maxLon + lonPadding),
    );

    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(50),
      ),
    );
  }

  void _selectSearchResult(dynamic result) {
    final lat = result.lat ?? result.latitude;
    final lon = result.lon ?? result.longitude;

    _selectedLocation = latlong.LatLng(
      double.parse(lat.toString()),
      double.parse(lon.toString()),
    );
    _addMarker(_selectedLocation);

    setState(() {
      _addressController.text = result.displayName ?? '';

      if (result.address != null && result.address['postcode'] != null) {
        _pincodeController.text = result.address['postcode'];
      }

      _searchController.clear();
      _showSearchResults = false;
      _searchResults = [];
      _searchMarkers.clear(); // Clear search markers after selection
    });

    _mapController.move(_selectedLocation, 15);
  }

  void _onMapTapped(TapPosition tapPosition, latlong.LatLng position) {
    _selectedLocation = position;
    _addMarker(position);
    _updateAddressFromLocation(position);

    // Clear search results when tapping on map
    setState(() {
      _searchMarkers.clear();
      _showSearchResults = false;
      _searchResults = [];
    });
  }

  // Selected location marker (Red)
  void _addMarker(latlong.LatLng position) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          point: position,
          width: 50,
          height: 50,
          child: const Icon(
            Icons.location_on,
            size: 50,
            color: Colors.red,
          ),
        ),
      );
    });
  }

  Future<void> _updateAddressFromLocation(latlong.LatLng position) async {
    try {
      final reverseRequest = ReverseRequest(
        lat: position.latitude,
        lon: position.longitude,
        addressDetails: true,
      );

      final result = await NominatimFlutter.instance.reverse(
        reverseRequest: reverseRequest,
        language: 'en-US,en;q=0.5',
      );

      if (result != null) {
        setState(() {
          _addressController.text = result.displayName ?? '';

          if (result.address != null && result.address!['postcode'] != null) {
            _pincodeController.text = result.address!['postcode'];
          }
        });
      }
    } catch (e) {
      _showSnackBar('Error getting address: $e');
    }
  }

  Timer? _debounce;
  void _onPincodeChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      if (_pincodeController.text.length == 6) {
        _searchByPincode(_pincodeController.text);
      }
    });
  }

  Future<void> _searchByPincode(String pincode) async {
    try {
      final searchRequest = SearchRequest(
        query: '$pincode, India',
        limit: 1,
        addressDetails: true,
      );

      final results = await NominatimFlutter.instance.search(
        searchRequest: searchRequest,
        language: 'en-US,en;q=0.5',
      );

      if (results.isNotEmpty) {
        final result = results.first;
        final lat = result.lat ?? result.lat;
        final lon = result.lon ?? result.lon;

        _selectedLocation = latlong.LatLng(double.parse(lat!), double.parse(lon!));
        _addMarker(_selectedLocation);

        setState(() {
          _addressController.text = result.displayName ?? '';
        });

        _mapController.move(_selectedLocation, 14);
      } else {
        _showSnackBar('Invalid pincode or location not found');
      }
    } catch (e) {
      _showSnackBar('Error searching pincode: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _onSubmit() {
    if (_addressController.text.isEmpty) {
      _showSnackBar('Please select a location on the map');
      return;
    }

    print('Pincode: ${_pincodeController.text}');
    print('Address: ${_addressController.text}');
    print('Coordinates: ${_selectedLocation.latitude}, ${_selectedLocation.longitude}');

    _showSnackBar('Location submitted successfully!');
  }

  void _onSelectFromTrees() {
    // print('Select from trees clicked');
    AppRoute.goToNextPage(context: context, screen: PlantedTreeMapScreen.route, arguments: {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: AppBar(
        title: const Text("Monitoring", style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0.5,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
              child: Column(
                children: [
                  // Search Bar with Results
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColor.cardBackground,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColor.divider),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.black.withOpacity(0.4),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                            hintText: 'Search location (e.g., Mulund West, Mumbai)',
                            hintStyle: const TextStyle(
                              color: AppColor.textSecondary,
                              fontSize: 16,
                            ),
                            prefixIcon: _isSearching
                                ? const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                                : const Icon(
                              Icons.search,
                              color: AppColor.textMuted,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: _getCurrentLocation,
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColor.skyBlue,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: _isLoadingLocation
                                    ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColor.white,
                                    ),
                                  ),
                                )
                                    : const Icon(
                                  Icons.my_location,
                                  color: AppColor.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),

                      // Search Results Dropdown
                      if (_showSearchResults && _searchResults.isNotEmpty)
                        Positioned(
                          top: 60,
                          left: 0,
                          right: 0,
                          child: Container(
                            constraints: const BoxConstraints(maxHeight: 250),
                            decoration: BoxDecoration(
                              color: AppColor.cardBackground,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColor.divider),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.black.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: ListView.separated(
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                itemCount: _searchResults.length,
                                separatorBuilder: (context, index) =>
                                const Divider(height: 1, indent: 16, endIndent: 16),
                                itemBuilder: (context, index) {
                                  final result = _searchResults[index];
                                  final displayName = result.displayName ?? 'Unknown location';

                                  return ListTile(
                                    dense: true,
                                    leading: Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${index + 1}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      displayName,
                                      style: const TextStyle(fontSize: 14),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    onTap: () => _selectSearchResult(result),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // OpenStreetMap Container with multiple markers
                  Container(
                    height: 280,
                    decoration: BoxDecoration(
                      color: AppColor.cardBackground,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColor.divider),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _selectedLocation,
                          initialZoom: 15,
                          onTap: _onMapTapped,
                          interactionOptions: const InteractionOptions(
                            flags: InteractiveFlag.all,
                          ),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.treelov.app',
                          ),
                          // Search result markers (Blue) - shown first
                          if (_searchMarkers.isNotEmpty)
                            MarkerLayer(markers: _searchMarkers),
                          // Selected location marker (Red) - shown on top
                          MarkerLayer(markers: _markers),
                          RichAttributionWidget(
                            attributions: [
                              TextSourceAttribution(
                                '© OpenStreetMap',
                                onTap: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Pincode Input
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColor.divider),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.black.withOpacity(0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _pincodeController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: const InputDecoration(
                        hintText: 'Pincode (auto-fills address)',
                        hintStyle: TextStyle(
                          color: AppColor.textSecondary,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        counterText: '',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Address Input
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColor.divider),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.black.withOpacity(0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _addressController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Location address (auto-filled from map)',
                        hintStyle: TextStyle(
                          color: AppColor.textSecondary,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Select from Trees Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onSelectFromTrees,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        foregroundColor: AppColor.white,
                        elevation: 4,
                        shadowColor: Colors.black26,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Select from trees planted with us',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.secondaryLight,
                        foregroundColor: AppColor.primary,
                        elevation: 4,
                        shadowColor: Colors.black26,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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

 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:nominatim_flutter/nominatim_flutter.dart';

import '../../../../core/config/constants/enum/inquiry_type_enum.dart';

class SelectMonitoringScreen extends StatefulWidget {
  static const route = '/SelectMonitoringScreen';
  final InquiryType inquiryType;
  const SelectMonitoringScreen({required this.inquiryType,super.key});

  @override
  State<SelectMonitoringScreen> createState() => _SelectMonitoringScreenState();
}

class _SelectMonitoringScreenState extends State<SelectMonitoringScreen> {
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final MapController _mapController = MapController();

  latlong.LatLng _selectedLocation = latlong.LatLng(19.1746, 72.9472);
  final List<Marker> _markers = [];
  // Removed: _searchMarkers

  List<dynamic> _searchResults = [];
  bool _isLoadingLocation = false;
  bool _isSearching = false;
  bool _showSearchResults = false;

  late InquiryBloc inquiryBloc;

  @override
  void initState() {
    super.initState();
    inquiryBloc = InquiryBloc(InquiriesRepository(api: ApiConnection()));
    NominatimFlutter.instance.configureNominatim(
      userAgent: 'TreeLovApp/1.0',
      enableCurlLog: false,
      printOnSuccess: false,
    );

    _addMarker(_selectedLocation);
    _pincodeController.addListener(_onPincodeChanged);
  }

  @override
  void dispose() {
    _pincodeController.dispose();
    _addressController.dispose();
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnackBar('Location permissions are permanently denied');
        setState(() => _isLoadingLocation = false);
        return;
      }

      if (permission == LocationPermission.denied) {
        _showSnackBar('Location permission denied');
        setState(() => _isLoadingLocation = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _selectedLocation = latlong.LatLng(position.latitude, position.longitude);
      _addMarker(_selectedLocation);
      _updateAddressFromLocation(_selectedLocation);

      _mapController.move(_selectedLocation, 15);
    } catch (e) {
      _showSnackBar('Error getting location: $e');
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  // 🔍 Search with debounce – NO MARKERS
  Timer? _searchDebounce;
  Future<void> _onSearchChanged(String query) async {
    if (_searchDebounce?.isActive ?? false) _searchDebounce!.cancel();

    if (query.length < 3) {
      setState(() {
        _showSearchResults = false;
        _searchResults = [];
      });
      return;
    }

    setState(() => _isSearching = true);

    _searchDebounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        final searchRequest = SearchRequest(
          query: query,
          limit: 10,
          addressDetails: true,
          nameDetails: true,
        );

        final results = await NominatimFlutter.instance.search(
          searchRequest: searchRequest,
          language: 'en-US,en;q=0.5',
        );

        setState(() {
          _searchResults = results;
          _showSearchResults = results.isNotEmpty;
          _isSearching = false;
          // ✅ NO MAP MARKERS ADDED HERE
        });
      } catch (e) {
        _showSnackBar('Search error: $e');
        setState(() {
          _isSearching = false;
          _showSearchResults = false;
        });
      }
    });
  }

  void _selectSearchResult(dynamic result) {
    final lat = result.lat ?? result.latitude;
    final lon = result.lon ?? result.longitude;

    _selectedLocation = latlong.LatLng(
      double.parse(lat.toString()),
      double.parse(lon.toString()),
    );
    _addMarker(_selectedLocation);

    setState(() {
      _addressController.text = result.displayName ?? '';

      if (result.address != null && result.address['postcode'] != null) {
        _pincodeController.text = result.address['postcode'];
      }

      _searchController.clear();
      _showSearchResults = false;
      _searchResults = [];
    });

    _mapController.move(_selectedLocation, 15);
  }

  void _onMapTapped(TapPosition tapPosition, latlong.LatLng position) {
    _selectedLocation = position;
    _addMarker(position);
    _updateAddressFromLocation(position);

    // Clear search results when tapping on map
    setState(() {
      _showSearchResults = false;
      _searchResults = [];
    });
  }

  // Selected location marker (Red)
  void _addMarker(latlong.LatLng position) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          point: position,
          width: 50,
          height: 50,
          child: const Icon(
            Icons.location_on,
            size: 50,
            color: Colors.red,
          ),
        ),
      );
    });
  }

  Future<void> _updateAddressFromLocation(latlong.LatLng position) async {
    try {
      final reverseRequest = ReverseRequest(
        lat: position.latitude,
        lon: position.longitude,
        addressDetails: true,
      );

      final result = await NominatimFlutter.instance.reverse(
        reverseRequest: reverseRequest,
        language: 'en-US,en;q=0.5',
      );

      if (result != null) {
        setState(() {
          _addressController.text = result.displayName ?? '';

          if (result.address != null && result.address!['postcode'] != null) {
            _pincodeController.text = result.address!['postcode'];
          }
        });
      }
    } catch (e) {
      _showSnackBar('Error getting address: $e');
    }
  }

  Timer? _debounce;
  void _onPincodeChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      if (_pincodeController.text.length == 6) {
        _searchByPincode(_pincodeController.text);
      }
    });
  }

  Future<void> _searchByPincode(String pincode) async {
    try {
      final searchRequest = SearchRequest(
        query: '$pincode, India',
        limit: 1,
        addressDetails: true,
      );

      final results = await NominatimFlutter.instance.search(
        searchRequest: searchRequest,
        language: 'en-US,en;q=0.5',
      );

      if (results.isNotEmpty) {
        final result = results.first;
        final lat = result.lat;
        final lon = result.lon;

        if (lat != null && lon != null) {
          _selectedLocation = latlong.LatLng(double.parse(lat), double.parse(lon));
          _addMarker(_selectedLocation);

          setState(() {
            _addressController.text = result.displayName ?? '';
          });

          _mapController.move(_selectedLocation, 14);
        }
      } else {
        _showSnackBar('Invalid pincode or location not found');
      }
    } catch (e) {
      _showSnackBar('Error searching pincode: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _onSubmit() {
    if (_addressController.text.isEmpty) {
      _showSnackBar('Please select a location on the map');
      return;
    }

    final request = InquiryRequestModel.withLocation(
      inquiryType: widget.inquiryType,
      longitude: _selectedLocation.longitude,
      latitude: _selectedLocation.latitude,
      address: _addressController.text.trim(),
      description: "Inquiry",
      // Add other fields if available (fullName, email, phone)
    );

    inquiryBloc.add(ApiAdd(request));
  }

  void _onSelectFromTrees() {
    AppRoute.goToNextPage(context: context, screen: PlantedTreeMapScreen.route, arguments: {
      'inquiryType':widget.inquiryType
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColor.secondary,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Inquiry Submitted!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColor.primary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "We'll get back to you within 24 hours.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColor.textSecondary),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // dismiss dialog
                  // ✅ Clear form & refocus
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.secondary,
                  foregroundColor: AppColor.cardBackground,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Done",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => inquiryBloc,
  child: BlocListener<InquiryBloc, ApiState<ResponseModel, ResponseModel>>(
      listener: (context, state) {
        if (state is ApiLoading) {
          // Optional: show global loading
        } else if (state is ApiSuccess) {
          // _showSnackBar('Monitoring request submitted successfully!');
          _showSuccessDialog();
          // Optionally reset form or navigate
        } else if (state is ApiFailure<ResponseModel, ResponseModel>) {
          _showSnackBar(state.error.message ?? 'Failed to submit request.');
        }
      },
      child: Scaffold(
        // backgroundColor: AppColor.scaffoldBackground,
        appBar: AppBar(
          title:  Text(widget.inquiryType==InquiryType.monitoring?"Monitoring":"Maintenance", style: TextStyle(fontWeight: FontWeight.w600)),
          centerTitle: true,
          elevation: 0.5,
          scrolledUnderElevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                child: Column(
                  children: [
                    // 🔍 Search Bar with Results LIST ONLY
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColor.cardBackground,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColor.divider),
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.black.withOpacity(0.4),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: _onSearchChanged,
                            decoration: InputDecoration(
                              hintText: 'Search location (e.g., Mulund West, Mumbai)',
                              hintStyle: const TextStyle(
                                color: AppColor.textSecondary,
                                fontSize: 16,
                              ),
                              prefixIcon: _isSearching
                                  ? const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                                  : const Icon(
                                Icons.search,
                                color: AppColor.textMuted,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: _getCurrentLocation,
                                child: Container(
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColor.skyBlue,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: _isLoadingLocation
                                      ? const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColor.white,
                                      ),
                                    ),
                                  )
                                      : const Icon(
                                    Icons.my_location,
                                    color: AppColor.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),

                        // ✅ Search Results Dropdown – LIST ONLY
                        if (_showSearchResults && _searchResults.isNotEmpty)
                          Positioned(
                            top: 60,
                            left: 0,
                            right: 0,
                            child: Container(
                              constraints: const BoxConstraints(maxHeight: 250),
                              decoration: BoxDecoration(
                                color: AppColor.cardBackground,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColor.divider),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColor.black.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  itemCount: _searchResults.length,
                                  separatorBuilder: (context, index) =>
                                  const Divider(height: 1, indent: 16, endIndent: 16),
                                  itemBuilder: (context, index) {
                                    final result = _searchResults[index];
                                    final displayName = result.displayName ?? 'Unknown location';

                                    return ListTile(
                                      dense: true,
                                      leading: Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${index + 1}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        displayName,
                                        style: const TextStyle(fontSize: 14),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      onTap: () => _selectSearchResult(result),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // 🗺️ Map – ONLY RED SELECTED MARKER
                    Container(
                      height: 280,
                      decoration: BoxDecoration(
                        color: AppColor.cardBackground,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColor.divider),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: _selectedLocation,
                            initialZoom: 15,
                            onTap: _onMapTapped,
                            interactionOptions: const InteractionOptions(
                              flags: InteractiveFlag.all,
                            ),
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://a.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.app',
                              tileProvider: NetworkTileProvider(
                                headers: {
                                  'User-Agent': 'Treelov/1.0',
                                },
                              ),
                            ),
                            // TileLayer(
                            //   urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            //   userAgentPackageName: 'com.treelov.app',
                            // ),
                            // ✅ Only show selected location (red marker)
                            MarkerLayer(markers: _markers),
                            /*
                            RichAttributionWidget(
                              attributions: [
                                TextSourceAttribution(
                                  '© OpenStreetMap',
                                  onTap: () {},
                                ),
                              ],
                            ),

                             */
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 📍 Pincode
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.cardBackground,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColor.divider),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.black.withOpacity(0.4),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _pincodeController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: const InputDecoration(
                          hintText: 'Pincode (auto-fills address)',
                          hintStyle: TextStyle(
                            color: AppColor.textSecondary,
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          counterText: '',
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 🏠 Address
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.cardBackground,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColor.divider),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.black.withOpacity(0.4),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _addressController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Location address (auto-filled from map)',
                          hintStyle: TextStyle(
                            color: AppColor.textSecondary,
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 🌳 Select from Trees Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _onSelectFromTrees,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primary,
                          foregroundColor: AppColor.white,
                          elevation: 4,
                          shadowColor: Colors.black26,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Select from trees planted with us',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ✉️ Submit Button
                    BlocBuilder<InquiryBloc, ApiState<ResponseModel, ResponseModel>>(
                      builder: (context, state) {
                        final isLoading = state is ApiLoading;
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null // disable during loading
                                : _onSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.secondaryLight,
                              foregroundColor: AppColor.primary,
                              elevation: 4,
                              shadowColor: Colors.black26,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                              ),
                            )
                                : const Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
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
          ],
        ),
      ),
    ),
);
  }
}



