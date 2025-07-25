import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


class MyTreesScreen extends StatelessWidget {
  const MyTreesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> treeData = [
      {
        'name': 'Banyan Tree',
        'latLng': LatLng(19.0760, 72.8777),
      },
      {
        'name': 'Peepal Tree',
        'latLng': LatLng(19.0765, 72.8772),
      },
      {
        'name': 'Neem Tree',
        'latLng': LatLng(19.0755, 72.8780),
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: treeData.first['latLng'] as LatLng,
              initialZoom: 17,
              interactionOptions: const InteractionOptions(
                flags: ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                tileProvider: NetworkTileProvider(
                  headers: {
                    'User-Agent': 'TreelovApp/1.0 (https://yourapp.com)',
                  },
                ),
              ),
              MarkerLayer(
                markers: treeData.map((tree) {
                  final latLng = tree['latLng'] as LatLng;
                  return Marker(
                    width: 40,
                    height: 40,
                    point: latLng,
                    child: Tooltip(
                      message: tree['name'],
                      child: const Icon(
                        Icons.park_rounded,
                        color: Colors.green,
                        size: 36,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          // Custom Back Button
          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 8.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
