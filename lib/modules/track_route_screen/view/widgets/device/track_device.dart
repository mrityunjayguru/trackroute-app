import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_device_controller.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_route_controller.dart';
import 'package:track_route_pro/modules/track_route_screen/view/widgets/device/speedometer.dart';
import 'package:track_route_pro/service/model/presentation/track_route/DisplayParameters.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../../../../config/app_sizer.dart';
import '../../../../../config/theme/app_colors.dart';
import '../../../../../config/theme/app_textstyle.dart';
import '../../../../../constants/project_urls.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../utils/utils.dart';
import '../../../../splash_screen/controller/data_controller.dart';
import 'device_select_page.dart';

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
        if (controller.deviceDetail.value?.status?.toLowerCase() != "active") {
          isActive = false;
        }
        String date = 'Update unavailable';
        String time = "";
        if (controller.deviceDetail.value?.trackingData?.lastUpdateTime
            ?.isNotEmpty ?? false) {
          date =
          '${DateFormat("dd MMM y").format(DateTime.parse(
              controller.deviceDetail.value?.trackingData?.lastUpdateTime ?? "")
              .toLocal()) ?? ''}';
          time =
          '${DateFormat("HH:mm").format(DateTime.parse(
              controller.deviceDetail.value?.trackingData?.lastUpdateTime ?? "")
              .toLocal()) ?? ''}';
        }
        return PopScope(
          canPop: false,
          child: Stack(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SafeArea(
                    child: Column(
                      children: [
                        Obx(
                              () =>
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                          AppSizes.radius_50),
                                      topRight: Radius.circular(
                                          AppSizes.radius_50),
                                      bottomRight: controller.isExpanded.value
                                          ? Radius.circular(AppSizes.radius_16)
                                          : Radius.circular(AppSizes.radius_50),
                                      bottomLeft: controller.isExpanded.value
                                          ? Radius.circular(AppSizes.radius_16)
                                          : Radius.circular(
                                          AppSizes.radius_50)),
                                  color: AppColors.whiteOff,
                                ),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      behavior: HitTestBehavior.deferToChild,
                                      onTap: () {
                                        controller.closeSocket();
                                        Get.back();
                                        /* controller.isExpanded.value =
                                      !controller.isExpanded.value;*/
                                        // controller.searchController.clear(); //todo
                                      },
                                      child: Container(
                                        height:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .height < 670
                                            ? 7.h
                                            : 6.h,
                                        // Increase height for smaller screens
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              AppSizes.radius_50),
                                          color: AppColors.black,
                                        ),
                                        child: Row(
                                          children: [
                                            Obx(
                                                  () =>
                                                  Image.network(
                                                      width: 25,
                                                      height: 25,
                                                      "${ProjectUrls
                                                          .imgBaseUrl}${dataController
                                                          .settings.value
                                                          .logo}",
                                                      errorBuilder: (context,
                                                          error,
                                                          stackTrace) =>
                                                          SvgPicture.asset(
                                                            Assets.images.svg
                                                                .icIsolationMode,
                                                            color: AppColors
                                                                .black,
                                                          )).paddingSymmetric(
                                                      horizontal: 10),
                                            ),
                                            Expanded(
                                              child: Text(
                                                controller.deviceDetail.value
                                                    ?.vehicleNo ??
                                                    "Tracking",
                                                overflow: TextOverflow.ellipsis,
                                                style: AppTextStyles(context)
                                                    .display20W400
                                                    .copyWith(
                                                    color: AppColors.whiteOff),
                                              ),
                                            ),
                                            SvgPicture.asset(
                                              /* !controller.isExpanded.value
                                  ? Assets.images.svg.icArrowDown
                                  :*/ //todo
                                                'assets/images/svg/ic_arrow_left.svg')
                                                .paddingOnly(
                                                right: 12, left: 7.w)
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
                                  borderRadius: BorderRadius.circular(
                                      AppSizes.radius_50)),
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
                      ],
                    ).paddingSymmetric(horizontal: 4.w * 0.9),
                  ),
                  Spacer(),
                  // Directions button
                  SizedBox(
                    width: 45,
                    height: 45,
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
                        borderRadius: BorderRadius.circular(AppSizes.radius_50),
                      ),
                      onPressed: () {
                        controller.isSatellite.value =
                        !controller.isSatellite.value;
                      },
                    ),
                  ).paddingOnly(bottom: 16, right: 4.w * 0.9),
                  SizedBox(
                    width: 45,
                    height: 45,
                    child: FloatingActionButton(
                      heroTag: 'nav1',
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
                        await trackController.getCurrentLocation();
                        if (position != null) {
                          trackController.updateCameraPosition(
                              course: 0,
                              latitude: position.latitude - 1,
                              longitude: position.longitude);
                        } else {
                          Utils.getSnackbar(
                              "Error", "Current location not available");
                        }
                      },
                    ),
                  ).paddingOnly(bottom: 16, right: 4.w * 0.9),
                  Row(
                    children: [
                      InkWell(
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
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive
                                  ? AppColors.selextedindexcolor
                                  : AppColors.grayLight,
                              border:
                              Border.all(color: AppColors.black, width: 4)),
                          child: Icon(Icons.call),
                        ).paddingOnly(top: 0.8.h, bottom: 0.8.h, left: 0.5.h),
                      ),
                      Spacer(),
                      SizedBox(
                        width: 45,
                        height: 45,
                        child: FloatingActionButton(
                          heroTag: 'directions',
                          child: Icon(
                            Icons.directions,
                            size: 29,
                            color: AppColors.white,
                          ),
                          backgroundColor:
                          isActive ? AppColors.blue : AppColors.grayLight,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(AppSizes.radius_50),
                          ),
                          onPressed: () {
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
                        ),
                      )
                    ],
                  ).paddingSymmetric(horizontal: 4.w * 0.9),
                  Stack(
                    children: [
                      SvgPicture.asset(
                        "assets/images/svg/tracking_bg_widget.svg",
                        width: context.width,
                      ),

                    ],
                  )
                ],
              ),
              Positioned(
                bottom: 10,
                child: Column(
                  children: [
                    SizedBox(
                      height: 125,
                      child: Row(
                        children: [
                          ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: _buildVehicleItemsLeft(context),
                          ).paddingOnly(top: 10),
                          SpeedometerWidget(
                              color: (controller.deviceDetail.value
                                  ?.trackingData?.currentSpeed ?? 0) == 0
                                  ? AppColors.color_434345
                                  : (controller.deviceDetail.value?.maxSpeed !=
                                  null
                                  ? ((controller
                                  .deviceDetail
                                  .value
                                  ?.trackingData
                                  ?.currentSpeed ??
                                  0) >
                                  (controller.deviceDetail.value?.maxSpeed ??
                                      0)
                                  ? AppColors.color_ED1C24
                                  : AppColors.selextedindexcolor)
                                  : AppColors.selextedindexcolor),
                              speed: ((controller
                                  .deviceDetail
                                  .value
                                  ?.trackingData
                                  ?.currentSpeed ??
                                  0)
                                  .toStringAsFixed(0) ??
                                  "N/A"),
                              distance: controller.deviceDetail.value
                                  ?.trackingData?.dailyDistance ??
                                  0)
                              .paddingOnly(bottom: 6, left: 25, right: 25),
                          ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: _buildVehicleItemsRight(context),
                          ).paddingOnly(top: 10),
                        ],
                      ),
                    ),
                    StreamBuilder<String>(
                      stream: controller.addressStream(),
                      builder: (context, snapshot) {
                        String address = "Fetching Address...";
                        if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            address = "Error Fetching Address";
                          } else {
                            address = snapshot.data ?? "Address Unavailable";
                          }
                        }

                        return Text(
                          address,
                          style: AppTextStyles(context).display11W500.copyWith(color: AppColors.white),
                        );
                      },
                    ),

                  ],
                ),
              ),
              Positioned(
                bottom: 20,
                child: Container(
                  width: context.width,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Last Update",
                              style: AppTextStyles(context)
                                  .display11W500
                                  .copyWith(color: AppColors.grayLight),
                            ).paddingOnly(bottom: 5),
                            Text(
                              date + " | " + time,
                              style: AppTextStyles(context)
                                  .display11W500
                                  .copyWith(color: AppColors.white),
                            )
                          ],
                        ),
                      ).paddingOnly(bottom: 10),
                      InkWell(
                        onTap: () {
                          controller.getDeviceByIMEITripSummary();
                          Get.to(() => DeviceSelectPage(),
                              transition: Transition.upToDown,
                              duration: const Duration(milliseconds: 300));
                        },
                        child: Container(
                          height: 26,
                          width: 100,
                          decoration: BoxDecoration(
                              color: AppColors.selextedindexcolor,
                              borderRadius: BorderRadius.circular(4)
                          ),
                          child: Center(
                              child: Text(
                                "More Info",
                                style: AppTextStyles(context).display14W600,
                              )),
                        ),
                      ).paddingOnly(bottom: 10)
                    ],
                  ),
                ),
              ),
              if (controller.isLoading.value)
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
          ),
        );
      },
    );
  }

  List<Widget> _buildVehicleItemsLeft(BuildContext context) {
    DisplayParameters? displayParameters =
        controller.deviceDetail.value?.displayParameters;
    return [
      if (displayParameters?.engine == true)
        _buildVehicleItem(
            context,
            'Engine',
            controller.deviceDetail.value?.trackingData?.ignition?.status ??
                false,
            'assets/images/svg/ic_engine_icon.svg'),
      if (displayParameters?.gps == true)
        _buildVehicleItem(
            context,
            'GPS',
            controller.deviceDetail.value?.trackingData?.gps,
            'assets/images/svg/gps.svg'),
      if (displayParameters?.network == true)
        _buildVehicleItem(
            context,
            'Network',
            controller.deviceDetail.value?.trackingData?.network == null
                ? null
                : controller.deviceDetail.value?.trackingData?.network ==
                "Connected",
            'assets/images/svg/ic_signal_tower.svg'),
    ];
  }

  List<Widget> _buildVehicleItemsRight(BuildContext context) {
    DisplayParameters? displayParameters =
        controller.deviceDetail.value?.displayParameters;
    return [
      if (displayParameters?.ac == true)
        _buildVehicleItem(
            context,
            'AC',
            controller.deviceDetail.value?.trackingData?.ac,
            'assets/images/svg/ic_ac.svg'),
      if (displayParameters?.parking == true)
        _buildVehicleItem(
            context,
            'Parking',
            controller.deviceDetail.value?.parking,
            'assets/images/svg/ic_parking_icon.svg'),
      if (displayParameters?.geoFencing == true)
        _buildVehicleItem(
            context,
            'Geofence',
            controller.deviceDetail.value?.locationStatus ?? false,
            'assets/images/svg/ic_geofence_icon.svg'),
    ];
  }

  Widget _buildVehicleItem(BuildContext context, String title, bool? isActive,
      String iconPath) {
    return Row(
      children: [
        SvgPicture.asset(iconPath,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(
                isActive == null
                    ? AppColors.color_f4f4f4
                    : (isActive
                    ? AppColors.selextedindexcolor
                    : AppColors.color_f4f4f4),
                BlendMode.srcIn)),
        SizedBox(width: 10),
      ],
    );
  }
}
