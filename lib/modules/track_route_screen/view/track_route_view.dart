import 'package:defer_pointer/defer_pointer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/app_sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_route_controller.dart';
import 'package:track_route_pro/modules/track_route_screen/view/widgets/map_view.dart';
import 'package:track_route_pro/modules/track_route_screen/view/widgets/vehicle_selected.dart';
import 'package:track_route_pro/modules/track_route_screen/view/widgets/vehicles_detail_bottom_sheet.dart';
import 'package:track_route_pro/modules/track_route_screen/view/widgets/vehicles_filter.dart';
import 'package:track_route_pro/utils/common_import.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../utils/utils.dart';
import '../../route_history/view/route_history_filter.dart';

class TrackRouteView extends StatelessWidget {
  TrackRouteView({super.key});

  final controller = Get.isRegistered<TrackRouteController>()
      ? Get.find<TrackRouteController>() // Find if already registered
      : Get.put(TrackRouteController());

  @override
  Widget build(BuildContext context) {
    WakelockPlus.enable();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, val) {
        controller.stackIndex.value = 0;
        controller.isShowvehicleDetail.value = false;
        controller.isExpanded.value = false;
        controller.showAllVehicles();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Obx(() {
          return Stack(
            children: [
              if (controller.stackIndex.value == 2)
                RouteHistoryPage()
              else ...[
                MapViewTrackRoute(),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: controller.stackIndex.value == 0
                            ? Offset(-1, 0)
                            : Offset(1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                  child: controller.stackIndex.value == 0
                      ? VehiclesList()
                      : VehicleSelected(),
                ),
                if (controller.isShowvehicleDetail.value &&
                    (controller.deviceDetail.value != null)) ...[
                  DraggableScrollableSheet(
                    initialChildSize: 0.32, // Initial size of the sheet
                    minChildSize: 0.1, // Minimum size before closing
                    maxChildSize: 0.55, // Maximum size of the sheet
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      bool isActive = true;
                      if (controller.deviceDetail.value?.status
                              ?.toLowerCase() !=
                          "active") {
                        isActive = false;
                      }
                      return NotificationListener<
                          DraggableScrollableNotification>(
                        onNotification: (notification) {
                          // When dragged down enough, close the bottom sheet
                          if (notification.extent <= 0.1) {
                            controller.showAllVehicles();
                          }
                          if (notification.extent >= 0.55) {
                            // maxChildSize
                            if (!controller.isSheetExpanded.value) {
                              controller.isSheetExpanded.value = true;
                            }
                          } else {
                            if (controller.isSheetExpanded.value) {
                              controller.isSheetExpanded.value = false;
                            }
                          }
                          return true;
                        },
                        child: DeferredPointerHandler(
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadiusDirectional.vertical(
                                            top: Radius.circular(
                                                AppSizes.radius_20))),
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  child: Obx(() {
                                    if (controller.deviceDetail.value != null) {
                                      var trackingData = controller
                                          .deviceDetail.value?.trackingData;
                                      String address = "Fetching Address...";
                                      if (trackingData?.location?.latitude !=
                                              null &&
                                          trackingData?.location?.longitude !=
                                              null) {
                                        // Call the address fetching method if lat/long are available
                                        Utils().getAddressFromLatLong(
                                          trackingData?.location?.latitude ??
                                              0.0,
                                          trackingData?.location?.longitude ??
                                              0.0,
                                        );
                                      } else {
                                        address = "Address Unavailable";
                                      }

                                      String date = 'Update unavailable';
                                      String time = "";
                                      if (trackingData
                                              ?.lastUpdateTime?.isNotEmpty ??
                                          false) {
                                        date =
                                            '${DateFormat("dd MMM y").format(DateTime.parse(trackingData?.lastUpdateTime ?? "").toLocal()) ?? ''}';
                                        time =
                                            '${DateFormat("HH:mm").format(DateTime.parse(trackingData?.lastUpdateTime ?? "").toLocal()) ?? ''}';
                                      }
                                      return FutureBuilder<String>(
                                        future: getAddress(),
                                        builder: (context, snapshot) {
                                          String address =
                                              "Fetching Address...";
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            if (snapshot.hasError) {
                                              address =
                                                  "Error Fetching Address";
                                            } else {
                                              address = snapshot.data ??
                                                  "Address Unavailable";
                                            }
                                          }
                                          return VehicalDetailBottomSheet(
                                            expiryDate: controller.deviceDetail
                                                .value?.subscriptionExp,
                                            isActive: isActive,
                                            displayParameters: controller
                                                .deviceDetail
                                                .value
                                                ?.displayParameters,
                                            imei: controller
                                                    .deviceDetail.value?.imei ??
                                                "",
                                            vehicalNo: controller.deviceDetail
                                                    .value?.vehicleNo ??
                                                '-',
                                            dateTime: "$date $time",
                                            address: address,
                                            totalkm:
                                                '${trackingData?.totalDistanceCovered ?? ''}',
                                            currentSpeed: controller
                                                    .deviceDetail
                                                    .value
                                                    ?.trackingData
                                                    ?.currentSpeed ??
                                                0,
                                            deviceID:
                                                '${controller.deviceDetail.value?.deviceId ?? ""}',
                                            icon: controller.deviceDetail.value
                                                    ?.vehicletype?.icons ??
                                                "",
                                            ignition:
                                                trackingData?.ignition?.status,
                                            network:
                                                trackingData?.network == null
                                                    ? null
                                                    : (trackingData?.network ==
                                                        "Connected"),
                                            gps: trackingData?.gps,
                                            ac: trackingData?.ac,
                                            charging: ((trackingData
                                                            ?.internalBattery ??
                                                        1) <=
                                                    0)
                                                ? true
                                                : false,
                                            door: trackingData?.door,
                                            geofence: controller.deviceDetail
                                                    .value?.locationStatus ??
                                                false,
                                            immob: controller.deviceDetail.value
                                                        ?.immobiliser !=
                                                    null
                                                ? (controller.deviceDetail.value
                                                        ?.immobiliser ==
                                                    "Stop")
                                                : null,
                                            parking: controller
                                                .deviceDetail.value?.parking,
                                            engine: controller
                                                    .deviceDetail
                                                    .value
                                                    ?.trackingData
                                                    ?.ignition
                                                    ?.status ??
                                                false,
                                            fuel: controller.deviceDetail.value
                                                        ?.fuelStatus !=
                                                    "Off"
                                                ? "${controller.deviceDetail.value?.fuelLevel ?? "N/A"}"
                                                : "N/A",
                                            vehicleName:
                                                "${controller.deviceDetail.value?.vehicletype?.vehicleTypeName ?? ""}",
                                            temp: (trackingData?.temperature ??
                                                    "N/A")
                                                .toString(),
                                            humid: (trackingData?.humidity0 ??
                                                    "N/A")
                                                .toString(),
                                            motion:
                                                (trackingData?.motion ?? "N/A")
                                                    .toString(),
                                            bluetooth:
                                                (trackingData?.rssi ?? "")
                                                    .toString(),
                                            extBattery: (trackingData
                                                        ?.externalBattery ??
                                                    "N/A")
                                                .toString(),
                                            intBattery: (trackingData
                                                        ?.internalBattery ??
                                                    "N/A")
                                                .toString(),
                                            summary: controller
                                                .deviceDetail.value?.summary,
                                          );
                                        },
                                      );
                                    }
                                    return SizedBox.shrink();
                                  }),
                                ),
                              ),
                              // Call driver button
                              Positioned(
                                top: -25,
                                left: 2.w,
                                child: InkWell(
                                  onTap: () {
                                    if (isActive &&
                                        (controller.deviceDetail.value?.mobileNo
                                                ?.isNotEmpty ??
                                            false)) {
                                      Utils.makePhoneCall(
                                          '${controller.deviceDetail.value?.mobileNo}');
                                    } else if (controller.deviceDetail.value
                                            ?.mobileNo?.isNotEmpty ??
                                        true) {
                                      Get.snackbar("", "",
                                          snackStyle: SnackStyle.FLOATING,
                                          padding: EdgeInsets.fromLTRB(
                                              10, 0, 10, 20),
                                          messageText: Text(
                                            "Please add a calling number in manage device",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: AppColors
                                                    .selextedindexcolor), // Ensure text is visible
                                          ),
                                          backgroundColor: AppColors.black,
                                          colorText:
                                              AppColors.selextedindexcolor,
                                          snackPosition: SnackPosition.BOTTOM);
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          AppSizes.radius_50),
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
                                                    ? AppColors
                                                        .selextedindexcolor
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
                                top: -25,
                                right: 2.w,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (isActive) {
                                      LatLng vehiclePosition = LatLng(
                                        controller
                                                .deviceDetail
                                                .value
                                                ?.trackingData
                                                ?.location
                                                ?.latitude ??
                                            0.0,
                                        controller
                                                .deviceDetail
                                                .value
                                                ?.trackingData
                                                ?.location
                                                ?.longitude ??
                                            0.0,
                                      );
                                      controller.openMaps(
                                          data: vehiclePosition);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isActive
                                        ? AppColors.blue
                                        : AppColors.grayLight,
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

                              Obx(
                                () => Positioned(
                                  top: -150,
                                  right: 4.w,
                                  child: DeferPointer(
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
                                          backgroundColor:
                                              AppColors.transparent,
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
                                          backgroundColor:
                                              AppColors.selextedindexcolor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                AppSizes.radius_50),
                                          ),
                                          onPressed: () async {
                                            // Fetch the current location
                                            Position? position =
                                                await controller
                                                    .getCurrentLocation();
                                            if (position != null) {
                                              controller.updateCameraPosition(
                                                  course: 0,
                                                  latitude:
                                                      position.latitude - 1,
                                                  longitude:
                                                      position.longitude);
                                            } else {
                                              Utils.getSnackbar("Error",
                                                  "Current location not available");
                                            }
                                          },
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ),

                              Obx(
                                () => Positioned(
                                  top: -24,
                                  right: 35.w,
                                  child: SvgPicture.asset(
                                    controller.isSheetExpanded.value
                                        ? "assets/images/svg/notched_down.svg"
                                        : "assets/images/svg/notched_up.svg",
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ],
              if (controller.showLoader.value)
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.grey.withOpacity(0.7),
                    child: LoadingAnimationWidget.threeArchedCircle(
                      color: AppColors.selextedindexcolor,
                      size: 50,
                    ),
                  ),
                )
            ],
          );
        }),
        floatingActionButton: Obx(
          () => controller.stackIndex.value == 0 &&
                  !controller.isShowvehicleDetail.value
              ? Padding(
                  padding: EdgeInsets.zero,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: FloatingActionButton(
                          heroTag: 'satellite1',
                          child: Image.asset(
                            !controller.isSatellite.value
                                ? "assets/images/png/satellite.png"
                                : "assets/images/png/default.png",
                            fit: BoxFit.fill,
                          ),
                          backgroundColor: AppColors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppSizes.radius_50),
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
                          heroTag: 'nav',
                          child: SvgPicture.asset(
                            Assets.images.svg.navigation1,
                            fit: BoxFit.fill,
                          ),
                          backgroundColor: AppColors.selextedindexcolor,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppSizes.radius_50),
                          ),
                          onPressed: () async {
                            // Fetch the current location
                            Position? position =
                                await controller.getCurrentLocation();
                            if (position != null) {
                              controller.updateCameraPosition(
                                  course: 0,
                                  latitude: position.latitude,
                                  longitude: position.longitude);
                            } else {
                              Utils.getSnackbar(
                                  "Error", "Current location not available");
                              return;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink(),
        ),
      ),
    );
  }

  Future<String> getAddress() async {
    var trackingData = controller.deviceDetail.value?.trackingData;
    if (controller.checkIfInactive(vehicle: controller.deviceDetail.value)) {
      if (controller.deviceDetail.value?.lastLocation?.latitude != null &&
          controller.deviceDetail.value?.lastLocation?.longitude != null) {
        return await Utils().getAddressFromLatLong(
          controller.deviceDetail.value?.lastLocation?.latitude ?? 0.0,
          controller.deviceDetail.value?.lastLocation?.longitude ?? 0.0,
        );
      } else {
        return Future.value("Address Unavailable");
      }
    } else {
      if (trackingData?.location?.latitude != null &&
          trackingData?.location?.longitude != null) {
        return await Utils().getAddressFromLatLong(
          trackingData?.location?.latitude ?? 0.0,
          trackingData?.location?.longitude ?? 0.0,
        );
      } else {
        return Future.value("Address Unavailable");
      }
    }
  }
}
