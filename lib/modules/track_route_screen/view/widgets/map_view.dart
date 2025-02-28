import 'package:custom_info_window/custom_info_window.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_route_controller.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../../../config/theme/app_colors.dart';
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
        children: [
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
          Positioned(
            left: -9999,
            child: RepaintBoundary(
              key: controller.markerKey,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 1), // Black Border
                  borderRadius: BorderRadius.circular(12),
                ),
                child: (controller.deviceDetail.value.data?.isNotEmpty ?? false) ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon(Icons.directions_car, size: 40, color: Colors.blue),
                    Text(
                      "Vehicle No.: ${controller.deviceDetail.value.data?[0].vehicleNo}",
                      style:AppTextStyles(context).display18W500,
                    ),
                    Text(
                      "IMEI: ${controller.deviceDetail.value.data?[0].imei}",
                      style: AppTextStyles(context).display16W400.copyWith( color: AppColors.grayLight),
                    ),
                  ],
                ) : SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
