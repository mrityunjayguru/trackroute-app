import 'package:custom_info_window/custom_info_window.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_route_controller.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../../../constants/project_urls.dart';

class MapViewTrackRoute extends StatelessWidget {
  MapViewTrackRoute({super.key});
  final controller = Get.isRegistered<TrackRouteController>()
      ? Get.find<TrackRouteController>() // Find if already registered
      : Get.put(TrackRouteController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children:[
          GoogleMap(
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            onMapCreated: (mapCon) {
              controller.mapController = mapCon;
              controller.showLoader.value = false;
              controller.customInfoWindowController.googleMapController =
                  mapCon;
            },
            onTap: (position) {
              controller.customInfoWindowController.hideInfoWindow!();
            },
            initialCameraPosition: CameraPosition(
              target: controller.currentLocation.value,
              zoom: 7,
            ),
            markers:Set<Marker>.of(controller.markers),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            minMaxZoomPreference: MinMaxZoomPreference(0, 19),
          ),
          CustomInfoWindow(
            controller: controller.customInfoWindowController,
            width: 200,
            height: 60,
          ),
        ]
      ),
    );
  }
}
