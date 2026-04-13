import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:treelove/core/config/themes/app_color.dart';

class TreeloveMap extends StatefulWidget {
  final MapController? mapController;
  final MapOptions options;
  final List<Widget> children;
  final bool showLocationButton;

  const TreeloveMap({
    super.key,
    this.mapController,
    required this.options,
    required this.children,
    this.showLocationButton = true,
  });

  @override
  State<TreeloveMap> createState() => _TreeloveMapState();
}

class _TreeloveMapState extends State<TreeloveMap> {
  late final StreamController<double?> _alignPositionStreamController;

  @override
  void initState() {
    super.initState();
    _alignPositionStreamController = StreamController<double?>.broadcast();
  }

  @override
  void dispose() {
    _alignPositionStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter out any explicitly manual CurrentLocationLayer provided by previous code
    final filteredChildren = widget.children.where((layer) {
      return layer.runtimeType.toString() != 'CurrentLocationLayer';
    }).toList();

    // Insert auto-centering Location Layer (usually right after TileLayer)
    final currentLocationLayer = CurrentLocationLayer(
      alignPositionOnUpdate: AlignOnUpdate.once,
      alignPositionStream: _alignPositionStreamController.stream,
    );

    int insertIndex = filteredChildren.isNotEmpty ? 1 : 0;
    if (insertIndex > filteredChildren.length) {
      insertIndex = filteredChildren.length;
    }
    
    filteredChildren.insert(insertIndex, currentLocationLayer);

    return Stack(
      children: [
        FlutterMap(
          mapController: widget.mapController,
          options: widget.options,
          children: filteredChildren,
        ),
        if (widget.showLocationButton)
          Positioned(
            bottom: 24.0,
            right: 16.0,
            child: FloatingActionButton(
              heroTag: null, // Avoid conflicts if multiple maps exist in the tree
              mini: true,
              backgroundColor: AppColor.primary,
              elevation: 4,
              child: const Icon(Icons.my_location, color: Colors.white, size: 20),
              onPressed: () {
                // Centers to current location and sets a zoom
                _alignPositionStreamController.add(15.0);
              },
            ),
          ),
      ],
    );
  }
}
