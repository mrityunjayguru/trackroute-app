import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/modules/route_history/controller/history_controller.dart';
import 'package:track_route_pro/utils/common_import.dart';
import '../../../../config/app_sizer.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_textstyle.dart';

class RouteHistoryMap extends StatelessWidget {
  RouteHistoryMap({super.key});

  final controller = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.showMarkers == true
        ? GoogleMap(
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            onMapCreated: controller.onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(28.6139, 77.2090),
              // Latitude and Longitude of Delhi
              zoom: 5,
            ),
            onTap: (val) {
              controller.showDetails.value = false;
            },
            markers: Set<Marker>.of(controller.markers),
            polylines: Set<Polyline>.of(controller.polylines),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            minMaxZoomPreference: MinMaxZoomPreference(5, 20),
          )
        : GoogleMap(
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            onMapCreated: controller.onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(28.6139, 77.2090),
              // Latitude and Longitude of Delhi
              zoom: 5,
            ),
            onTap: (val) {
              controller.showDetails.value = false;
            },
            markers: {},
            polylines: Set<Polyline>.of(controller.polylines),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            minMaxZoomPreference: MinMaxZoomPreference(5, 20),
          ));
  }
}
