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
            circles: controller.circles.value.toSet(),
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
          if (controller.isShowvehicleDetail.value &&
              (controller.deviceDetail.value!=null) &&
              controller.checkIfOffline(
                  vehicle: controller.deviceDetail.value))
            Positioned(
              top: 10,
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                    color: AppColors.selextedindexcolor,
                    borderRadius: BorderRadius.circular(AppSizes.radius_50)),
                child: Center(
                  child: Text(
                    "Device is offline",
                    style: AppTextStyles(context).display13W500,
                  ).paddingOnly(left: 5).paddingOnly(left: 6, bottom: 7, top: 7),
                ),
              ).paddingSymmetric(horizontal: 16),
            )
          /*  Positioned(
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
                      style: AppTextStyles(context).display18W500.copyWith(fontSize: MediaQuery.of(context).size.height < 670 ? 14 : null),
                    ),
                    Text(
                      "IMEI: ${controller.deviceDetail.value.data?[0].imei}",
                      style: AppTextStyles(context)
                          .display16W400
                          .copyWith(color: AppColors.grayLight, fontSize: MediaQuery.of(context).size.height < 670 ? 12 : null),
                    ),
                  ],
                ) : SizedBox.shrink(),
              ),
            ),
          ),*/
        ],
      ),
    );
  }
}
