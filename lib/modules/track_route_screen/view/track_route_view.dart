import 'dart:developer';

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

import '../../../utils/utils.dart';
import '../../route_history/view/route_history_filter.dart';

class TrackRouteView extends StatelessWidget {
  TrackRouteView({super.key});

  final controller = Get.isRegistered<TrackRouteController>()
      ? Get.find<TrackRouteController>() // Find if already registered
      : Get.put(TrackRouteController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        controller.stackIndex.value = 0;
        controller.isShowvehicleDetail.value = false;
        controller.isExpanded.value = false;
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
                    (controller.deviceDetail.value.data?.isNotEmpty ??
                        false)) ...[
                  DraggableScrollableSheet(
                    initialChildSize: 0.55, // Initial size of the sheet
                    minChildSize: 0.1, // Minimum size before closing
                    maxChildSize: 0.55, // Maximum size of the sheet
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      bool isActive = true;
                      if (controller.deviceDetail.value.data?[0].status
                              ?.toLowerCase() !=
                          "active") {
                        isActive = false;
                      }
                      return NotificationListener<
                          DraggableScrollableNotification>(
                        onNotification: (notification) {
                          // When dragged down enough, close the bottom sheet
                          if (notification.extent <= 0.2) {
                            controller.showAllVehicles();
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
                                    if (controller.deviceDetail.value.data
                                            ?.isNotEmpty ??
                                        false) {
                                      var trackingData = controller.deviceDetail
                                          .value.data?[0].trackingData;
                                      if (trackingData?.location?.latitude !=
                                              null &&
                                          trackingData?.location?.longitude !=
                                              null) {
                                        // Call the address fetching method if lat/long are available
                                        controller.getAddressFromLatLong(
                                          trackingData?.location?.latitude ??
                                              0.0,
                                          trackingData?.location?.longitude ??
                                              0.0,
                                        );
                                      } else {
                                        controller.address.value =
                                            "Address Unavailable";
                                      }

                                      String date = 'Update unavailable';
                                      String time = "";
                                      if (trackingData
                                              ?.lastUpdateTime?.isNotEmpty ??
                                          false) {
                                        date =
                                            '${DateFormat("dd MMM y").format(DateTime.parse(trackingData?.lastUpdateTime ?? "").toLocal()) ?? ''}';
                                        time =
                                            '${DateFormat("hh:mm").format(DateTime.parse(trackingData?.lastUpdateTime ?? "").toLocal()) ?? ''}';
                                      }
                                      return VehicalDetailBottomSheet(
                                        expiryDate: controller.deviceDetail
                                            .value.data?[0].subscriptionExp,
                                        isActive: isActive,
                                        displayParameters: controller
                                            .deviceDetail
                                            .value
                                            .data?[0]
                                            .displayParameters,
                                        imei: controller.deviceDetail.value
                                                .data?[0].imei ??
                                            "",
                                        vehicalNo: controller.deviceDetail.value
                                                .data?[0].vehicleNo ??
                                            '-',
                                        dateTime: "$date $time",
                                        address: '${controller.address.value}',
                                        totalkm:
                                            '${trackingData?.totalDistanceCovered ?? ''}',
                                        currentSpeed: controller
                                                .deviceDetail
                                                .value
                                                .data?[0]
                                                .trackingData
                                                ?.currentSpeed ??
                                            0,
                                        deviceID:
                                            '${controller.deviceDetail.value.data?[0].deviceId ?? ""}',
                                        icon: controller.deviceDetail.value
                                                .data?[0].vehicletype?.icons ??
                                            "",
                                        ignition:
                                            trackingData?.ignition?.status,
                                        network: trackingData?.network == null
                                            ? null
                                            : (trackingData?.network ==
                                                "Connected"),
                                        gps: trackingData?.gps,
                                        ac: trackingData?.ac,
                                        charging: ((trackingData?.internalBattery ?? 1) <= 0) ? true : false ,
                                        door: trackingData?.door,
                                        geofence: controller.deviceDetail.value
                                                .data?[0].area != null,
                                        immob: controller.deviceDetail.value
                                                    .data?[0].immobiliser !=
                                                null
                                            ? (controller.deviceDetail.value
                                                    .data?[0].immobiliser ==
                                                "Stop")
                                            : null,
                                        parking: controller.deviceDetail.value
                                            .data?[0].parking,
                                        engine: controller.deviceDetail.value
                                            .data?[0].trackingData?.ignition?.status ?? false,
                                        fuel:
                                            "${controller.deviceDetail.value.data?[0]?.fuelLevel ?? "N/A"}",
                                        vehicleName:
                                            "${controller.deviceDetail.value.data?[0].vehicletype?.vehicleTypeName ?? ""}",
                                        temp:
                                            (trackingData?.temperature ?? "N/A")
                                                .toString(),
                                        humid:
                                            (trackingData?.humidity0 ?? "N/A")
                                                .toString(),
                                        motion: (trackingData?.motion ?? "N/A")
                                            .toString(),
                                        bluetooth: (trackingData?.rssi ?? "")
                                            .toString(),
                                        extBattery:
                                            (trackingData?.externalBattery ??
                                                    "N/A")
                                                .toString(),
                                        intBattery:
                                            (trackingData?.internalBattery ??
                                                    "N/A")
                                                .toString(), summary: controller.deviceDetail
                                          .value.data?[0].summary,
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
                                    if (isActive) {
                                      Utils.makePhoneCall(
                                          '${controller.deviceDetail.value.data?[0].mobileNo}');
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
                                          height: 34,
                                          width: 34,
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
                                        ).paddingOnly(left: 6, right: 6),
                                      ],
                                    ).paddingOnly(
                                        top: 0.5.h, bottom: 0.5.h, left: 0.5.h),
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
                                                .data?[0]
                                                .trackingData
                                                ?.location
                                                ?.latitude ??
                                            0.0,
                                        controller
                                                .deviceDetail
                                                .value
                                                .data?[0]
                                                .trackingData
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

                              Positioned(
                                top: -100,
                                right: 4.w,
                                child: DeferPointer(
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: FloatingActionButton(
                                      child: SvgPicture.asset(
                                        Assets.images.svg.navigation1,
                                        fit: BoxFit.fill,
                                      ),
                                      backgroundColor:
                                          AppColors.selextedindexcolor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(AppSizes.radius_50),
                                      ),
                                      onPressed: () async {
                                        // Fetch the current location
                                        Position? position = await controller
                                            .getCurrentLocation();
                                        if (position != null) {
                                          controller.updateCameraPosition(
                                              latitude: position.latitude - 1,
                                              longitude: position.longitude);
                                        } else {
                                          Utils.getSnackbar("Error",
                                              "Current location not available");
                                        }
                                      },
                                    ),
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
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: FloatingActionButton(
                      child: SvgPicture.asset(
                        Assets.images.svg.navigation1,
                        fit: BoxFit.fill,
                      ),
                      backgroundColor: AppColors.selextedindexcolor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radius_50),
                      ),
                      onPressed: () async {
                        // Fetch the current location
                        Position? position =
                            await controller.getCurrentLocation();
                        if (position != null) {
                          controller.updateCameraPosition(
                              latitude: position.latitude - 1,
                              longitude: position.longitude);
                        } else {
                          Utils.getSnackbar(
                              "Error", "Current location not available");
                          return;
                        }
                      },
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ),
      ),
    );
  }
}
