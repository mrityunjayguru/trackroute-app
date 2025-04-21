import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_route_controller.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../../../config/app_sizer.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_textstyle.dart';

class MapViewTrackRoute extends StatelessWidget {
  MapViewTrackRoute({super.key});

  final controller = Get.isRegistered<TrackRouteController>()
      ? Get.find<TrackRouteController>() // Find if already registered
      : Get.put(TrackRouteController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            mapType: controller.isSatellite.value
                ? MapType.satellite
                : MapType.normal,
            // circles: controller.circles.value.toSet(),
            onMapCreated: (mapCon) {
              controller.height = MediaQuery.of(context).size.height;
              controller.mapController = mapCon;
              controller.showLoader.value = false;
            },
            initialCameraPosition: CameraPosition(
              target: controller.currentLocation.value,
              zoom: 7,
            ),
            markers: Set<Marker>.of(controller.markers),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            minMaxZoomPreference: MinMaxZoomPreference(0, 19),
          ),
        ],
      ),
    );
  }
}
