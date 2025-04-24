import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/service/model/presentation/track_route/track_route_vehicle_list.dart';

import '../../../../../config/app_sizer.dart';
import '../../../../../config/theme/app_colors.dart';
import '../../../../../config/theme/app_textstyle.dart';
import '../../../../../utils/common_import.dart';
import '../../../../../utils/custom_vehicle_data.dart';
import '../../../../../utils/utils.dart';
import '../../../controller/track_device_controller.dart';
import '../../../controller/track_route_controller.dart';

class DeviceSelectPage extends StatelessWidget {
  final controller = Get.isRegistered<DeviceController>()
      ? Get.find<DeviceController>() // Find if already registered
      : Get.put(DeviceController());
  final trackController = Get.isRegistered<TrackRouteController>()
      ? Get.find<TrackRouteController>() // Find if already registered
      : Get.put(TrackRouteController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Utils().topBar(
                context: context,
                rightIcon: 'assets/images/svg/ic_arrow_left.svg',
                onTap: () {
                  Get.back();
                },
                name: controller.deviceDetail.value?.vehicleNo ?? "-"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() {
                  bool isActive = true;
                  if (controller.deviceDetail.value?.status?.toLowerCase() !=
                      "active") {
                    isActive = false;
                  }
                  return InkWell(
                    onTap: () {
                      if (isActive &&
                          (controller
                                  .deviceDetail.value?.mobileNo?.isNotEmpty ??
                              false)) {
                        Utils.makePhoneCall(
                            '${controller.deviceDetail.value?.mobileNo}');
                      } else if (!(controller
                              .deviceDetail.value?.mobileNo?.isNotEmpty ??
                          false)) {
                        Get.snackbar(
                          "",
                          "",
                          snackStyle: SnackStyle.FLOATING,
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                          messageText: Text(
                            "Please add a calling number in manage device",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.selextedindexcolor,
                            ),
                          ),
                          backgroundColor: AppColors.black,
                          colorText: AppColors.selextedindexcolor,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSizes.radius_50),
                        color: AppColors.black,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 35,
                            width: 35,
                            child: SvgPicture.asset(
                              "assets/images/svg/new_call_icon.svg",
                              colorFilter: ColorFilter.mode(
                                  isActive
                                      ? AppColors.selextedindexcolor
                                      : AppColors.grayLight,
                                  BlendMode.srcIn),
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Call Now',
                            style:
                                AppTextStyles(context).display16W600.copyWith(
                                      color: isActive
                                          ? AppColors.selextedindexcolor
                                          : AppColors.grayLight,
                                    ),
                          ).paddingOnly(left: 6, right: 12),
                        ],
                      ),
                    ),
                  );
                }),
                Obx(() {
                  bool isActive = true;
                  if (controller.deviceDetail.value?.status?.toLowerCase() !=
                      "active") {
                    isActive = false;
                  }
                  return InkWell(
                    onTap: () {
                      if (isActive) {
                          trackController.showEditView(controller.deviceDetail.value?.imei ?? "");
                      }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSizes.radius_50),
                        color: isActive
                            ? AppColors.selextedindexcolor
                            : AppColors.grayLight,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 35,
                            width: 35,
                            child: SvgPicture.asset(
                              "assets/images/svg/new_manage_icon.svg",
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('Manage Vehicle',
                                  style: AppTextStyles(context).display16W600)
                              .paddingOnly(left: 6, right: 12),
                        ],
                      ),
                    ),
                  );
                })
              ],
            ).paddingOnly(top: 16),
            Obx(
              () => Flexible(
                child: SingleChildScrollView(
                  child: FutureBuilder<String>(
                    future: (controller.deviceDetail.value?.trackingData
                                    ?.location?.latitude !=
                                null &&
                            controller.deviceDetail.value?.trackingData
                                    ?.location?.longitude !=
                                null)
                        ? Utils().getAddressFromLatLong(
                            controller.deviceDetail.value?.trackingData
                                    ?.location?.latitude ??
                                0.0,
                            controller.deviceDetail.value?.trackingData
                                    ?.location?.longitude ??
                                0.0,
                          )
                        : Future.value("Address Unavailable"),
                    builder: (context, snapshot) {
                      String address = "Fetching Address...";
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          address = "Error Fetching Address";
                        } else {
                          address = snapshot.data ?? "Address Unavailable";
                        }
                      }
                      Data vehicleInfo =
                          controller.deviceDetail.value ?? Data();
                      TrackingData? trackingData = vehicleInfo.trackingData;
                      String date = 'Update unavailable';
                      String time = "";
                      if (vehicleInfo
                              .trackingData?.lastUpdateTime?.isNotEmpty ??
                          false) {
                        date = date =
                            '${DateFormat("dd MMM y").format(DateTime.parse(vehicleInfo.trackingData?.lastUpdateTime ?? "").toLocal()) ?? ''}';
                        time =
                            '${DateFormat("HH:mm").format(DateTime.parse(vehicleInfo.trackingData?.lastUpdateTime ?? "").toLocal()) ?? ''}';
                      }
                      return VehicleDataWidget(
                        summary: controller.summaryTrip,
                        expiryDate: vehicleInfo.subscriptionExp,
                        isActive: vehicleInfo.status?.toLowerCase() == "active",
                        temp: (trackingData?.temperature ?? "N/A").toString(),
                        humid: (trackingData?.humidity0 ?? "N/A").toString(),
                        motion: (trackingData?.motion ?? "N/A").toString(),
                        bluetooth: (trackingData?.rssi ?? "").toString(),
                        extBattery:
                            (trackingData?.externalBattery ?? "N/A").toString(),
                        intBattery:
                            (trackingData?.internalBattery ?? "N/A").toString(),
                        displayParameters: vehicleInfo.displayParameters,
                        vehicleName: vehicleInfo.vehicleNo ?? '-',
                        address: address,
                        lastUpdate: date + " " + time,
                        odo: (vehicleInfo.trackingData?.totalDistanceCovered ??
                                "")
                            .toString(),
                        fuel: controller.fuelValue.value,
                        speed: (vehicleInfo.trackingData?.currentSpeed ?? "")
                            .toString(),
                        deviceId: vehicleInfo.deviceId.toString() ?? '',
                        doorIsActive: vehicleInfo.trackingData?.door,
                        doorSubTitle: vehicleInfo.trackingData?.door == null
                            ? "N/A"
                            : ((vehicleInfo.trackingData!.door!)
                                ? "OPEN"
                                : "CLOSED"),
                        engineIsActive:
                            vehicleInfo.trackingData?.ignition?.status ?? false,
                        engineSubTitle: "N/A",
                        parkingIsActive: vehicleInfo.parking,
                        parkingSubTitle: vehicleInfo.parking == null
                            ? "N/A"
                            : ((vehicleInfo.parking!) ? "ON" : "OFF"),
                        immobilizerIsActive: vehicleInfo.immobiliser == null
                            ? null
                            : (vehicleInfo.immobiliser! == "Stop"),
                        immobilizerSubTitle: vehicleInfo.immobiliser == null
                            ? "N/A"
                            : ((vehicleInfo.immobiliser! == "Stop")
                                ? "ON"
                                : "OFF"),
                        geofenceIsActive: vehicleInfo.locationStatus ?? false,
                        geofenceSubTitle:
                            vehicleInfo.area != null ? "ON" : "OFF",
                        gpsIsActive: trackController.checkIfOffline(vehicle: controller.deviceDetail.value),
                        gpsSubTitle: vehicleInfo.trackingData?.gps == null
                            ? "N/A"
                            : ((vehicleInfo.trackingData!.gps!) ? "ON" : "OFF"),
                        networkIsActive: vehicleInfo.trackingData?.network ==
                                null
                            ? null
                            : vehicleInfo.trackingData?.network == "Connected",
                        networkSubTitle: vehicleInfo.trackingData?.network ==
                                null
                            ? "N/A"
                            : (vehicleInfo.trackingData?.network == "Connected")
                                ? "AVAILABLE"
                                : "OFF",
                        acIsActive: vehicleInfo.trackingData?.ac,
                        acSubTitle: vehicleInfo.trackingData?.ac == null
                            ? "N/A"
                            : ((vehicleInfo.trackingData!.ac!) ? "ON" : "OFF"),
                        chargingIsActive:
                            (vehicleInfo.trackingData?.internalBattery ?? 1) <=
                                    0
                                ? true
                                : false,
                        chargingSubTitle: "N/A",
                        imei: vehicleInfo.imei ?? "",
                        isBottomSheet: true,
                        showDeviceIdCopy: true,
                      ).paddingSymmetric(horizontal: 4.w, vertical: 1.5.h);
                    },
                  ),
                ),
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: 4.w * 0.9, vertical: 10),
      ),
    );
  }
}
