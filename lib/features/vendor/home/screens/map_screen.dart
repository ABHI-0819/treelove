import 'package:flutter/material.dart';
/*
class VendorMapScreen extends StatefulWidget {
  const VendorMapScreen({super.key});

  @override
  State<VendorMapScreen> createState() => _VendorMapScreenState();
}

class _VendorMapScreenState extends State<VendorMapScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

 */
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


class VendorMapScreen extends StatefulWidget {
  static const route ='/VendorMapScreen';
  const VendorMapScreen({super.key});

  @override
  State<VendorMapScreen> createState() => _VendorMapScreenState();
}

class _VendorMapScreenState extends State<VendorMapScreen> {
  final LatLng _initialCenter = LatLng(19.0760, 72.8777); // Mumbai center

  //  Example Tree Data
  final List<Tree> _trees = [
    Tree(id: "1", name: "Neem Tree", latitude: 19.0760, longitude: 72.8777),
    Tree(id: "2", name: "Mango Tree", latitude: 19.0800, longitude: 72.8800),
    Tree(id: "3", name: "Peepal Tree", latitude: 19.0830, longitude: 72.8700),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tree Map"),
        backgroundColor: Colors.green,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _initialCenter,
          initialZoom: 13,
          maxZoom: 18.0,
          minZoom: 3.0,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all, // Pan, Zoom, etc.
          ),
        ),
        children: [
          // ✅ OpenStreetMap Tile Layer
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            tileProvider: NetworkTileProvider(
              headers: {
                'User-Agent': 'TreelovApp/1.0 (https://yourapp.com)',
              },
            ),
          ),

          // ✅ Tree Markers Layer
          MarkerLayer(
            markers: _trees.map((tree) {
              return Marker(
                point: LatLng(tree.latitude, tree.longitude),
                width: 60,
                height: 60,
                child: GestureDetector(
                  onTap: () => _showTreeDetails(context, tree),
                  child: const Icon(
                    Icons.park,
                    color: Colors.green,
                    size: 40,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// ✅ Show Bottom Sheet with Tree Info
  void _showTreeDetails(BuildContext context, Tree tree) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tree.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Tree ID: ${tree.id}"),
            Text("Lat: ${tree.latitude}, Lng: ${tree.longitude}"),
          ],
        ),
      ),
    );
  }
}

class Tree {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  Tree({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}


