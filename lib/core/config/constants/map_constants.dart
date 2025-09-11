import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapConstant{
  static const initialCameraFit = CameraFit.coordinates(coordinates: [
    LatLng(18.98038235, 72.83440898),
    LatLng(18.98015343, 72.83923891),
    LatLng(18.97657420, 72.83908574),
    LatLng(18.97770160, 72.83384466)
  ]);

  static LatLngBounds cameraConstrains = LatLngBounds(
      const LatLng(18.98038235, 72.83440898),
      const LatLng(18.97657420, 72.83908574));

  static const LatLng initialCenter = LatLng(18.97871986, 72.83684766);
  static const double minimumZoom = 8;
  static const double maximumZoom = 21.0;
  static const double initialZoom = 13.5;
  static const double zoomToPoint = 18.0;
  static const List<String> wmsBaseLayerName = ["RaniBagh:Ranibagh_Base_Map"];
}