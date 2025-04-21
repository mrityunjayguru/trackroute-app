import 'package:defer_pointer/defer_pointer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_device_controller.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_route_controller.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../../../../config/app_sizer.dart';
import '../../../../../config/theme/app_colors.dart';
import '../../../../../config/theme/app_textstyle.dart';
import '../../../../../constants/project_urls.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../utils/utils.dart';
import '../../../../splash_screen/controller/data_controller.dart';

class TrackDeviceView extends StatelessWidget {
  TrackDeviceView({super.key});

  final controller = Get.isRegistered<DeviceController>()
      ? Get.find<DeviceController>() // Find if already registered
      : Get.put(DeviceController());

  final trackController = Get.isRegistered<TrackRouteController>()
      ? Get.find<TrackRouteController>() // Find if already registered
      : Get.put(TrackRouteController());

  final dataController = Get.isRegistered<DataController>()
      ? Get.find<DataController>() // Find if already registered
      : Get.put(DataController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        bool isActive = true;
        if (controller.deviceDetail.value?.status?.toLowerCase() !=
            "active") {
          isActive = false;
        }
        return Stack(
        alignment: Alignment.center,
        children: [

          GoogleMap(
            zoomControlsEnabled: false,
            mapType: controller.isSatellite.value
                ? MapType.satellite
                : MapType.normal,
            circles: controller.circles.value.toSet(),
            onMapCreated: (mapCon) {
              controller.mapController = mapCon;
              controller.isLoading.value = false;
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
          SafeArea(
            child: Column(
              children: [
                Obx(
                  () => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppSizes.radius_50),
                          topRight: Radius.circular(AppSizes.radius_50),
                          bottomRight: controller.isExpanded.value
                              ? Radius.circular(AppSizes.radius_16)
                              : Radius.circular(AppSizes.radius_50),
                          bottomLeft: controller.isExpanded.value
                              ? Radius.circular(AppSizes.radius_16)
                              : Radius.circular(AppSizes.radius_50)),
                      color: AppColors.whiteOff,
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.deferToChild,
                          onTap: () {
                            controller.isExpanded.value =
                                !controller.isExpanded.value;
                            // controller.searchController.clear(); //todo
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height < 670
                                ? 7.h
                                : 6.h,
                            // Increase height for smaller screens
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(AppSizes.radius_50),
                              color: AppColors.black,
                            ),
                            child: Row(
                              children: [
                                Obx(
                                  () => Image.network(
                                      width: 25,
                                      height: 25,
                                      "${ProjectUrls.imgBaseUrl}${dataController.settings.value.logo}",
                                      errorBuilder: (context, error,
                                              stackTrace) =>
                                          SvgPicture.asset(
                                            Assets.images.svg.icIsolationMode,
                                            color: AppColors.black,
                                          )).paddingSymmetric(horizontal: 10),
                                ),
                                Expanded(
                                  child: Text(
                                    "name",
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles(context)
                                        .display20W400
                                        .copyWith(color: AppColors.whiteOff),
                                  ),
                                ),
                                SvgPicture.asset(
                                        /* !controller.isExpanded.value
                            ? Assets.images.svg.icArrowDown
                            :*/ //todo
                                        'assets/images/svg/ic_arrow_left.svg')
                                    .paddingOnly(right: 12, left: 7.w)
                              ],
                            ).paddingOnly(left: 8, right: 8),
                          ),
                        ),
                        //todo- vehicle list
                      ],
                    ),
                  ).paddingOnly(top: 12),
                ),
                if ((controller.deviceDetail.value != null) &&
                    trackController.checkIfOffline(
                        vehicle: controller.deviceDetail.value))
                  IntrinsicWidth(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: AppColors.color_F26221,
                          borderRadius:
                              BorderRadius.circular(AppSizes.radius_50)),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/images/svg/no_internet.svg",
                          ).paddingOnly(right: 2),
                          Text(
                            "No Internet Connection - you're offline",
                            style: AppTextStyles(context)
                                .display13W500
                                .copyWith(color: Colors.white),
                          ).paddingOnly(left: 6, bottom: 7, top: 7),
                        ],
                      ).paddingSymmetric(horizontal: 16),
                    ).paddingSymmetric(horizontal: 16, vertical: 10),
                  ),
                Spacer(),

                Obx(() {

                  return Stack(
                    children: [
                      SvgPicture.asset(
                        "assets/images/svg/tracking_bg_widget.svg",
                      ),

                    ],
                  );
                })
              ],
            ).paddingSymmetric(horizontal: 4.w * 0.9),
          ),
          Positioned(
            left: 2.w,
            child: InkWell(
              onTap: () {
                if (isActive &&
                    (controller.deviceDetail.value?.mobileNo
                        ?.isNotEmpty ??
                        false)) {
                  Utils.makePhoneCall(
                      '${controller.deviceDetail.value?.mobileNo}');
                } else if (controller
                    .deviceDetail.value?.mobileNo?.isNotEmpty ??
                    true) {
                  Get.snackbar("", "",
                      snackStyle: SnackStyle.FLOATING,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                      messageText: Text(
                        "Please add a calling number in manage device",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors
                                .selextedindexcolor), // Ensure text is visible
                      ),
                      backgroundColor: AppColors.black,
                      colorText: AppColors.selextedindexcolor,
                      snackPosition: SnackPosition.BOTTOM);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(AppSizes.radius_50),
                  color: AppColors.black,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      height: 35,
                      width: 35,
                      child: CircleAvatar(
                        backgroundColor: isActive
                            ? AppColors.selextedindexcolor
                            : AppColors.grayLight,
                        child: Icon(Icons.call),
                      ),
                    ),
                    Text(
                      'Call Driver',
                      style: AppTextStyles(context)
                          .display14W500
                          .copyWith(
                        color: isActive
                            ? AppColors.selextedindexcolor
                            : AppColors.grayLight,
                      ),
                    ).paddingOnly(left: 6, right: 16),
                  ],
                ).paddingOnly(
                    top: 0.8.h, bottom: 0.8.h, left: 0.5.h),
              ),
            ),
          ),

          // Directions button
          Positioned(
            right: 2.w,
            child: ElevatedButton(
              onPressed: () async {
                if (isActive) {
                  LatLng vehiclePosition = LatLng(
                    controller.deviceDetail.value?.trackingData
                        ?.location?.latitude ??
                        0.0,
                    controller.deviceDetail.value?.trackingData
                        ?.location?.longitude ??
                        0.0,
                  );
                  trackController.openMaps(data: vehiclePosition);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                isActive ? AppColors.blue : AppColors.grayLight,
                shape: CircleBorder(),
                padding: EdgeInsets.all(9),
              ),
              child: Icon(
                Icons.directions,
                size: 29,
                color: AppColors.white,
              ),
            ),
          ),

          Positioned(

            right: 4.w,
            child: Column(children: [
              SizedBox(
                width: 50,
                height: 50,
                child: FloatingActionButton(
                  heroTag: 'satellite',
                  child: Image.asset(
                    !controller.isSatellite.value
                        ? "assets/images/png/satellite.png"
                        : "assets/images/png/default.png",
                    fit: BoxFit.fill,
                  ),
                  backgroundColor: AppColors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        AppSizes.radius_50),
                  ),
                  onPressed: () {
                    controller.isSatellite.value =
                    !controller.isSatellite.value;
                  },
                ),
              ).paddingOnly(bottom: 16),
              SizedBox(
                width: 50,
                height: 50,
                child: FloatingActionButton(
                  heroTag: 'nav1',
                  child: SvgPicture.asset(
                    Assets.images.svg.navigation1,
                    fit: BoxFit.fill,
                  ),
                  backgroundColor: AppColors.selextedindexcolor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        AppSizes.radius_50),
                  ),
                  onPressed: () async {
                    // Fetch the current location
                    Position? position = await trackController
                        .getCurrentLocation();
                    if (position != null) {
                      trackController.updateCameraPosition(
                          course: 0,
                          latitude: position.latitude - 1,
                          longitude: position.longitude);
                    } else {
                      Utils.getSnackbar("Error",
                          "Current location not available");
                    }
                  },
                ),
              ),
            ]),
          )
        ],
      );
      },
    );
  }
}
