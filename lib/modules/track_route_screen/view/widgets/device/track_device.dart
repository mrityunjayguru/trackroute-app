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
import '../../../../../service/model/presentation/track_route/track_route_vehicle_list.dart';
import '../../../../../utils/custom_vehicle_data.dart';
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
        if (controller.deviceDetail.value?.status?.toLowerCase() != "active") {
          isActive = false;
        }

        bool isNotExpired = (isActive &&
            ((controller.deviceDetail.value?.subscriptionExp) == null
                ? isActive
                : (DateFormat('yyyy-MM-dd')
                            .parse((controller
                                .deviceDetail.value?.subscriptionExp)!)
                            .difference(DateTime.now())
                            .inDays +
                        1 >
                    0)));
        return PopScope(
          canPop: false,
          child: Stack(
            alignment: Alignment.center,
            children: [
              GoogleMap(
                buildingsEnabled: false,
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
                                    controller.selectedVehicleIMEI.value = "";
                                    controller.closeSocket();
                                    Get.back();
                                  },
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.height < 670
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
                                          () => Image.network(
                                              width: 25,
                                              height: 25,
                                              "${ProjectUrls.imgBaseUrl}${dataController.settings.value.logo}",
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  SvgPicture.asset(
                                                    Assets.images.svg
                                                        .icIsolationMode,
                                                    color: AppColors.black,
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
                                                'assets/images/svg/ic_arrow_left.svg')
                                            .paddingOnly(right: 12, left: 7.w)
                                      ],
                                    ).paddingOnly(left: 8, right: 8),
                                  ),
                                ),
                              ],
                            ),
                          ).paddingOnly(top: 12),
                        ),
                        StreamBuilder<bool>(
                          stream: controller.internetStatusStream(),
                          builder: (context, snapshot) {
                            String message = "";
                            Color color = Colors.grey;

                            if (snapshot.connectionState ==
                                    ConnectionState.active ||
                                snapshot.connectionState ==
                                    ConnectionState.done) {
                              if (snapshot.data == true) {
                                message = "";
                                color = Colors.green;
                              } else {
                                message =
                                    "No Internet Connection - you're offline";
                                color = Colors.red;
                              }
                            }
                            if (message.isEmpty) {
                              return SizedBox.shrink();
                            }
                            return IntrinsicWidth(
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
                                      message,
                                      style: AppTextStyles(context)
                                          .display13W500
                                          .copyWith(color: Colors.white),
                                    ).paddingOnly(left: 6, bottom: 7, top: 7),
                                  ],
                                ).paddingSymmetric(horizontal: 16),
                              ).paddingSymmetric(horizontal: 16, vertical: 10),
                            );
                          },
                        )
                      ],
                    ).paddingSymmetric(horizontal: 4.w * 0.9),
                  ),
                  Spacer(),
                  if (!controller.expandInfo.value)...[
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
                            controller.updateCameraPosition(
                                course: 0,
                                latitude: position.latitude - 1,
                                longitude: position.longitude);
                          } else {
                            Utils.getSnackbar(
                                "Error", "Current location not available");
                          }
                        },
                      ),
                    ).paddingOnly(bottom: 16+30, right: 4.w * 0.9),
                    _infoWidget(context, isNotExpired, isActive),
                  ] else _fullInfoWidget(context, isNotExpired, isActive)
                  // Directions button

                ],
              ),
              if (!controller.expandInfo.value)...[
                Positioned(
                    bottom:
                    MediaQuery.of(context).size.height * ((205 / 812) - 0.07),
                    child: SpeedometerWidget(
                        color: (controller.deviceDetail.value?.trackingData?.currentSpeed ?? 0) == 0
                            ? AppColors.color_434345
                            : (controller.deviceDetail.value?.maxSpeed != null
                            ? ((controller
                            .deviceDetail
                            .value
                            ?.trackingData
                            ?.currentSpeed ??
                            0) >
                            (controller.deviceDetail.value
                                ?.maxSpeed ??
                                0)
                            ? AppColors.color_ED1C24
                            : AppColors.selextedindexcolor)
                            : AppColors.selextedindexcolor),
                        speed: ((controller.deviceDetail.value
                            ?.trackingData?.currentSpeed ??
                            0)
                            .toStringAsFixed(0) ??
                            "N/A"),
                        distance: controller.deviceDetail.value?.trackingData?.dailyDistance ?? 0)),
                Positioned(
                  bottom: (MediaQuery.of(context).size.height * ((205 / 812)))-22,
                  child: Container(
                    width: context.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
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
                            height: 45,
                            padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 2,
                                  spreadRadius: 1,
                                  color: const Color(0xff000000).withOpacity(0.25),
                                  offset: Offset(0, 0),
                                ),
                              ],
                              borderRadius:
                              BorderRadius.circular(AppSizes.radius_50),
                              color: AppColors.black,
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 30,
                                  width: 30,
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
                                  'Call',
                                  style:
                                  AppTextStyles(context).display14W600.copyWith(
                                    color: isActive
                                        ? AppColors.selextedindexcolor
                                        : AppColors.grayLight,
                                  ),
                                ).paddingOnly(left: 6, right: 12),
                              ],
                            ),
                          ),
                        ).paddingOnly(left: 4.w * 0.9),
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
                        ).paddingOnly(right: 4.w * 0.9)
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildVehicleItems(BuildContext context) {
    DisplayParameters? displayParameters =
        controller.deviceDetail.value?.displayParameters;
    return  [

        if (displayParameters?.network == true)
          _buildVehicleItem(
              context,
              'Network',
              controller.deviceDetail.value?.trackingData?.network == null
                  ? null
                  : controller.deviceDetail.value?.trackingData?.network ==
                      "Connected",
              'assets/images/svg/ic_signal.svg'),
        if (displayParameters?.gps == true)
          _buildVehicleItem(
              context,
              'GPS',
              !trackController.checkIfOffline(
                  vehicle: controller.deviceDetail.value),
              'assets/images/svg/new_internet.svg'),
        if (displayParameters?.engine == true)
          _buildVehicleItem(
              context,
              'Engine',
              controller.deviceDetail.value?.trackingData?.ignition?.status ??
                  false,
              'assets/images/svg/new_engine_icon.svg'),
        if (displayParameters?.ac == true)
          _buildVehicleItem(
              context,
              'AC',
              controller.deviceDetail.value?.trackingData?.ac,
              'assets/images/svg/new_ac.svg'),
        if (displayParameters?.geoFencing == true)
          _buildVehicleItem(
              context,
              'Geofence',
              controller.deviceDetail.value?.locationStatus ?? false,
              'assets/images/svg/new_geofence.svg'),
        if (displayParameters?.parking == true)
          _buildVehicleItem(
              context,
              'Parking',
              controller.deviceDetail.value?.parking,
              'assets/images/svg/new_parking.svg'),
      if (displayParameters?.door == true)
        _buildVehicleItem(context, 'Door', controller.deviceDetail.value?.trackingData?.door,
            'assets/images/svg/ic_door.svg'),
      if (displayParameters?.relay == true)
        _buildVehicleItem(context, 'Relay', controller.deviceDetail.value?.immobiliser == null
            ? null
            : (controller.deviceDetail.value?.immobiliser! == "Stop"),
             'assets/images/svg/new_relay.svg'),
      ];
  }

  Widget _buildVehicleItem(
      BuildContext context, String title, bool? isActive, String iconPath) {
    return Row(
      children: [
        SizedBox(
          width: 55,
          height: 55,
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: isActive == null
                    ? AppColors.color_f4f4f4
                    : (isActive
                        ? AppColors.selextedindexcolor
                        : AppColors.color_f4f4f4),
                child: SvgPicture.asset(iconPath,
                    colorFilter:
                        ColorFilter.mode(AppColors.black, BlendMode.srcIn)),
              ),
            ],
          ),
        ),
        SizedBox(width: 4),
      ],
    );
  }

  Widget _infoWidget(BuildContext context, bool isNotExpired, bool isActive) {
    String date = 'Update unavailable';
    String time = "";
    if (controller
            .deviceDetail.value?.trackingData?.lastUpdateTime?.isNotEmpty ??
        false) {
      date =
          '${DateFormat("dd MMM y").format(DateTime.parse(controller.deviceDetail.value?.trackingData?.lastUpdateTime ?? "").toLocal()) ?? ''}';
      time =
          '${DateFormat("HH:mm").format(DateTime.parse(controller.deviceDetail.value?.trackingData?.lastUpdateTime ?? "").toLocal()) ?? ''}';
    }
    return Container(
      height: MediaQuery.of(context).size.height * (0.32 - 0.06),
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.038),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSizes.radius_10),
              topRight: Radius.circular(AppSizes.radius_10)),
          boxShadow: [
            BoxShadow(
              blurRadius: 1,
              spreadRadius: 0,
              color: const Color(0xff000000).withOpacity(0.25),
              offset: Offset(0, 0),
            ),
          ]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Last Update",
                      style: AppTextStyles(context)
                          .display11W500
                          .copyWith(color: AppColors.grayLight),
                    ).paddingOnly(bottom: 2),
                    Text(
                      date + " | " + time,
                      style: AppTextStyles(context).display11W500,
                    )
                  ],
                ),
              ).paddingOnly(bottom: 4),
              InkWell(
                onTap: () {
                  if (isActive) {
                    trackController.showEditView(
                        controller.deviceDetail.value?.imei ?? "");
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4)),
                  child: Text(
                    "Manage Vehicle",
                    style: AppTextStyles(context).display12W500.copyWith(
                          color: isActive
                              ? AppColors.selextedindexcolor
                              : AppColors.grayLight,
                        ),
                  ),
                ).paddingOnly(top: 0.8.h, bottom: 0.8.h, left: 0.5.h),
              )
            ],
          ).paddingOnly(bottom: 10),
          StreamBuilder<String>(
            stream: controller.addressStream(),
            builder: (context, snapshot) {
              String address = "Fetching Address...";
              if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  address = "Error Fetching Address";
                } else {
                  address = snapshot.data ?? "Address Unavailable";
                }
              }

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                width: context.width,
                decoration: BoxDecoration(
                    color: AppColors.color_e5e7e9,
                    borderRadius: BorderRadius.circular(AppSizes.radius_4),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 1,
                        spreadRadius: 0,
                        color: const Color(0xff000000).withOpacity(0.25),
                        offset: Offset(0, 0),
                      ),
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (isNotExpired)
                      SvgPicture.asset('assets/images/svg/ic_location.svg'),
                    Flexible(
                      child: Text(
                        isNotExpired ? address : "Device Inactive",
                        style: AppTextStyles(context).display13W500,
                      ).paddingOnly(left: 5),
                    )
                  ],
                ),
              );
            },
          ).paddingOnly(bottom: 10),
          SizedBox(
            height: 65,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: _buildVehicleItems(context),
            ),
          ),

          Spacer(),
          Container(
            // margin: EdgeInsets.only(top: 10),
            height: 30,
            child: InkWell(
              onTap: () {
                controller.getDeviceByIMEITripSummary();
                controller.expandInfo.value = true;
              },
              child: Container(
                height: 26,
                width: 26,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(4)),
                child: Center(
                    child: SvgPicture.asset(
                  "assets/images/svg/ic_arrow_up.svg",
                  width: 20,
                  height: 20,
                  colorFilter:
                      ColorFilter.mode(AppColors.blue, BlendMode.srcIn),
                )),
              ),
            ),
          ).paddingOnly(bottom: 4)
        ],
      ).paddingSymmetric(horizontal: 4.w * 0.9),
    );
  }

  Widget _fullInfoWidget(BuildContext context, bool isNotExpired, bool isActive) {
    String date = 'Update unavailable';
    String time = "";
    if (controller
        .deviceDetail.value?.trackingData?.lastUpdateTime?.isNotEmpty ??
        false) {
      date =
      '${DateFormat("dd MMM y").format(DateTime.parse(controller.deviceDetail.value?.trackingData?.lastUpdateTime ?? "").toLocal()) ?? ''}';
      time =
      '${DateFormat("HH:mm").format(DateTime.parse(controller.deviceDetail.value?.trackingData?.lastUpdateTime ?? "").toLocal()) ?? ''}';
    }
    return Column(
      children: [
        InkWell(
          onTap: (){
            controller.expandInfo.value = false;
          },
            child: SvgPicture.asset("assets/images/svg/ic_arrow_down_button.svg", width: 24, height: 24,)),
        Container(
          height: MediaQuery.of(context).size.height * (0.74 - 0.06),
          // padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
          decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.radius_10),
                  topRight: Radius.circular(AppSizes.radius_10)),
              ),
          child:SingleChildScrollView(
            child: Column(
              children: [
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

                            border: Border.all(
                                color: !isActive
                                    ? AppColors
                                    .grayLight
                                    : AppColors
                                    .blue),
                            borderRadius:
                            BorderRadius.circular(
                                AppSizes
                                    .radius_4),
                          ),
                          child: Text(
                            'Call Driver',
                            style:
                            AppTextStyles(context).display14W600.copyWith(
                              color: isActive
                                  ? AppColors.blue
                                  : AppColors.grayLight,
                            ),
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
                        border: Border.all(
                            color: !isActive
                                ? AppColors
                                .grayLight
                                : AppColors
                                .blue),
                        borderRadius:
                        BorderRadius.circular(
                            AppSizes
                                .radius_4),
                      ),
            
                      child: Text('Manage Vehicle',
                          style: AppTextStyles(context).display14W600.copyWith(
                            color: isActive
                                ? AppColors.blue
                                : AppColors.grayLight,
                          ),),
                        ),
                      );
                    })
                  ],
                ).paddingOnly(top: 16).paddingSymmetric(horizontal: 4.w * 0.9),
                Obx(
                      () => FutureBuilder<String>(
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
                            isLoading: controller.isLoading.value,
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
                            gpsIsActive: !trackController.checkIfOffline(vehicle: controller.deviceDetail.value),
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
              ],
            ),
          ),
          ),
      ],
    );
  }
}
