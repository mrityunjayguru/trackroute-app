import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:track_route_pro/modules/reports/view/reports_page.dart';
import 'package:track_route_pro/modules/route_history/controller/history_controller.dart';
import 'package:track_route_pro/modules/route_history/view/route_history_filter.dart';
import 'package:track_route_pro/service/model/presentation/track_route/DisplayParameters.dart';
import 'package:track_route_pro/utils/utils.dart';

import '../config/app_sizer.dart';
import '../config/theme/app_colors.dart';
import '../config/theme/app_textstyle.dart';
import '../gen/assets.gen.dart';
import '../modules/bottom_screen/controller/bottom_bar_controller.dart';
import '../modules/reports/controller/reports_controller.dart';
import '../modules/track_route_screen/controller/track_device_controller.dart';
import '../modules/track_route_screen/controller/track_route_controller.dart';
import '../service/model/presentation/track_route/Summary.dart';

class VehicleDataWidget extends StatelessWidget {
  final bool isBottomSheet, isActive;
  final String odo;
  final String fuel;
  final String speed;
  final String deviceId;
  final bool? doorIsActive;
  final bool showDeviceIdCopy;
  final String doorSubTitle;
  final bool? engineIsActive;
  final DisplayParameters? displayParameters;
  final String engineSubTitle;
  final bool? parkingIsActive;
  final String parkingSubTitle;
  final bool? immobilizerIsActive;
  final String immobilizerSubTitle;
  final bool? geofenceIsActive;
  final String geofenceSubTitle;
  final bool? gpsIsActive;
  final String gpsSubTitle;
  final bool? networkIsActive;
  final String networkSubTitle;
  final bool? acIsActive;
  final String acSubTitle;
  final bool? chargingIsActive;
  final String chargingSubTitle;
  final String address;
  final String lastUpdate;
  final String vehicleName;
  final String imei;
  final String extBattery;
  final String intBattery;
  final String humid;
  final String temp;
  final String motion;
  final String bluetooth;
  final String? expiryDate;
  final RxBool? isLoading;
  final Rx<Summary?>? summary;

  VehicleDataWidget({
    this.summary = null,
    required this.odo,
    required this.isActive,
    required this.fuel,
    required this.speed,
    required this.deviceId,
    required this.doorIsActive,
    this.showDeviceIdCopy = false,
    required this.doorSubTitle,
    required this.engineIsActive,
    required this.engineSubTitle,
    required this.parkingIsActive,
    required this.parkingSubTitle,
    required this.immobilizerIsActive,
    required this.immobilizerSubTitle,
    required this.geofenceIsActive,
    required this.geofenceSubTitle,
    required this.gpsIsActive,
    required this.gpsSubTitle,
    required this.networkIsActive,
    required this.networkSubTitle,
    required this.acIsActive,
    required this.acSubTitle,
    required this.chargingIsActive,
    required this.chargingSubTitle,
    required this.address,
    required this.lastUpdate,
    required this.vehicleName,
    required this.imei,
    this.displayParameters,
    required this.isBottomSheet,
    required this.extBattery,
    required this.intBattery,
    required this.humid,
    required this.temp,
    required this.motion,
    required this.bluetooth,
    this.expiryDate,
    this.isLoading
  });

  final controller = Get.isRegistered<TrackRouteController>()
      ? Get.find<TrackRouteController>() // Find if already registered
      : Get.put(TrackRouteController());

  var routeHistoryController = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    bool isNotExpired = (isActive &&
        (expiryDate == null
            ? isActive
            : (DateFormat('yyyy-MM-dd')
                        .parse(expiryDate!)
                        .difference(DateTime.now())
                        .inDays +
                    1 >
                0)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isNotExpired)
          Row(
            children: [
              if (expiryDate != null &&
                  isActive &&
                  (DateFormat('yyyy-MM-dd')
                          .parse(expiryDate!)
                          .difference(DateTime.now())
                          .inDays <=
                      15))
                Text(
                  "Expiring in ${(DateFormat('yyyy-MM-dd').parse(expiryDate!).difference(DateTime.now()).inDays + 1)} Days",
                  style: AppTextStyles(context)
                      .display12W400
                      .copyWith(color: AppColors.color_e23226),
                ),
              Spacer(),
              if(!isBottomSheet)GestureDetector(
                behavior: HitTestBehavior.deferToChild,
                onTap: () {
                  final bottomController = Get.isRegistered<
                          BottomBarController>()
                      ? Get.find<
                          BottomBarController>() // Find if already registered
                      : Get.put(BottomBarController());
                  bottomController.updateIndex(2);
                  controller.showEditView(imei);
                },
                child: Text(
                  'Manage Vehicle',
                  style: AppTextStyles(context)
                      .display14W600
                      .copyWith(color: AppColors.blue),
                ),
              ),
            ],
          ).paddingOnly(bottom: 8)
        else
          SizedBox(height: 1.5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vehicle Number',
                    style: AppTextStyles(context)
                        .display12W400
                        .copyWith(color: AppColors.grayLight),
                  ),
                  Text(
                    vehicleName,
                    style: AppTextStyles(context)
                        .display14W500
                        .copyWith(color: AppColors.black),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Last Update',
                    style: AppTextStyles(context)
                        .display12W400
                        .copyWith(color: AppColors.grayLight),
                  ),
                  Text(
                    lastUpdate,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles(context)
                        .display14W500
                        .copyWith(color: AppColors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 1.5.h),
        Container(
          decoration: BoxDecoration(
              color: isNotExpired
                  ? AppColors.selextedindexcolor
                  : AppColors.color_e5e7e9,
              borderRadius: BorderRadius.circular(AppSizes.radius_50)),
          child: Row(
            mainAxisAlignment: isNotExpired
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
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
          ).paddingOnly(left: 6, bottom: 7, top: 7),
        ),
        SizedBox(height: 1.5.h),
        Row(
          children: [
            Flexible(
              child: InkWell(
                onTap: () {
                  if (showDeviceIdCopy) {
                    Clipboard.setData(ClipboardData(text: imei));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Copied to clipboard!'),
                      duration: Duration(seconds: 2),
                      // Short duration
                      margin:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      behavior:
                          SnackBarBehavior.floating, // Makes it floating),
                    ));
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'IMEI',
                      style: AppTextStyles(context)
                          .display12W400
                          .copyWith(color: AppColors.grayLight),
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            imei,
                            maxLines: 3,
                            style: AppTextStyles(context).display12W500,
                          ),
                        ),
                        if (showDeviceIdCopy)
                          SvgPicture.asset('assets/images/svg/copy_icon.svg')
                              .paddingOnly(left: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                if (isNotExpired) {
                  if(isBottomSheet){
                    final deviceController = Get.isRegistered<DeviceController>()
                        ? Get.find<DeviceController>() // Find if already registered
                        : Get.put(DeviceController());
                    deviceController.closeSocket();
                  }
                  Get.to(() => RouteHistoryPage(),
                      transition: Transition.upToDown,
                      duration: const Duration(milliseconds: 300));
                  routeHistoryController.name.value = vehicleName;
                  routeHistoryController.address.value = address;
                  routeHistoryController.updateDate.value = lastUpdate;
                  routeHistoryController.imei.value = imei;
                  routeHistoryController.generateTimeList();
                  routeHistoryController.showMap.value = false;
                  String formattedDate =
                      DateFormat('dd-MM-yyyy').format(DateTime.now());
                  routeHistoryController.dateController.text = formattedDate;
                  routeHistoryController.endDateController.text =
                      DateFormat('yyyy-MM-dd').format(DateTime.now());
                  routeHistoryController.time1.value = null;
                  routeHistoryController.time2.value = null;
                  routeHistoryController.showMap.value = false;
                  routeHistoryController.data.value = [];
                }
              },
              child: Container(
                // height: 5.h,
                padding: EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                width: 30.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.radius_50),
                    color: AppColors.black),
                child: Center(
                  child: Text(
                    'Route History',
                    style: AppTextStyles(context).display13W500.copyWith(
                        color: isNotExpired
                            ? AppColors.selextedindexcolor
                            : AppColors.grayLight),
                  ),
                ),
              ),
            ).paddingOnly(left: 8),
          ],
        ),
        SizedBox(height: 1.5.h),
        if (isNotExpired) ...[
          if (isBottomSheet)
            Container(
              decoration: BoxDecoration(
                  color: AppColors.whiteOff,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      spreadRadius: 0,
                      offset: Offset(0, 1),
                      color: Color(0xff000000).withOpacity(0.2),
                    )
                  ],
                  borderRadius: BorderRadius.circular(AppSizes.radius_50)),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.grayBright,
                          child: SvgPicture.asset(
                            Assets.images.svg.icSpeedometer,
                            width: 24,
                            height: 24,
                          ),
                        ).paddingOnly(left: 3, right: 3),
                        Flexible(
                          child: AutoSizeText(
                            "${Utils.formatInt(data: speed)}",
                            style: AppTextStyles(context).display21W600,
                            maxLines: 4,
                            minFontSize: 9,
                          ).paddingOnly(left: 4, right: 6),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current',
                              style: AppTextStyles(context)
                                  .display9W400
                                  .copyWith(color: AppColors.grayLight),
                            ),
                            Column(
                              children: [
                                Text(
                                  'Speed (Kmph)',
                                  style: AppTextStyles(context)
                                      .display9W400
                                      .copyWith(color: AppColors.grayLight),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppSizes.radius_50),
                          border:
                              Border.all(color: AppColors.selextedindexcolor)),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.grayBright,
                            child: SvgPicture.asset(
                              'assets/images/svg/car_icon.svg',
                              width: 20,
                              height: 20,
                              colorFilter: ColorFilter.mode(
                                  AppColors.black, BlendMode.srcIn),
                            ),
                          ),
                          Obx(()=>
                             Flexible(
                              child: AutoSizeText(
                                '${summary?.value?.avgSpeed == null ? "NA " : Utils.parseDouble(data: summary?.value?.avgSpeed ?? "0").toInt()} ',
                                maxLines: 2,
                                minFontSize: 18,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles(context).display21W600,
                              ).paddingOnly(left: 4, right: 6),
                            ),
                          ),
                          Text(
                            'Average\nSpeed (KMPH)',
                            style: AppTextStyles(context)
                                .display9W400
                                .copyWith(color: AppColors.grayLight),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          if (isBottomSheet) SizedBox(height: 1.5.h),
          if (displayParameters != null)
            SizedBox(
              height: 9.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _buildVehicleItems(context),
              ),
            ),
          if (displayParameters != null) SizedBox(height: 0.4.h),
          if (isBottomSheet && summary != null)
            Obx(()=>
               Container(
                width: context.width,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.color_e5e7f3,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Today’s Trip Summary',
                          style: AppTextStyles(context).display14W700,
                        ),

                        InkWell(
                          onTap: () {
                            final deviceController = Get.isRegistered<DeviceController>()
                                ? Get.find<DeviceController>() // Find if already registered
                                : Get.put(DeviceController());
                            deviceController.closeSocket();
                            Get.put(ReportsController()).setData();

                            Get.to(
                                () => ReportsView(
                                      imei: imei,
                                    ),
                                transition: Transition.upToDown,
                                duration: const Duration(milliseconds: 300));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 9, horizontal: 8),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(AppSizes.radius_50),
                                color: AppColors.black),
                            child: Center(
                              child: Text(
                                'Download Reports',
                                style: AppTextStyles(context)
                                    .display13W500
                                    .copyWith(
                                        color: AppColors.selextedindexcolor),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: Skeletonizer(
                              enabled: isLoading?.value ?? false,
                              child: Container(
                                  // height: 6.h,
                                  // constraints: BoxConstraints(maxHeight: 9.h),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Text.rich(
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Total Travel ',
                                                style: AppTextStyles(context)
                                                    .display11W500,
                                              ),
                                              TextSpan(
                                                text:
                                                    '(${summary?.value?.totalTravelTime ?? "-"})\n',
                                                style: AppTextStyles(context)
                                                    .display11W500
                                                    .copyWith(
                                                        color: AppColors.grayLight),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${summary?.value?.total_travel_km == null ? "NA" : Utils.toStringAsFixed(data: summary?.value?.total_travel_km.toString())}',
                                                style: AppTextStyles(context)
                                                    .display21W600,
                                              ),
                                              TextSpan(
                                                text: ' KM ',
                                                style: AppTextStyles(context)
                                                    .display14W600
                                                    .copyWith(
                                                        color: AppColors.grayLight),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )).paddingSymmetric(horizontal: 3, vertical: 4),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          if(!(isLoading?.value ?? false))Expanded(
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text.rich(
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Latest Trip ',
                                        style:
                                            AppTextStyles(context).display11W500,
                                      ),
                                      if (summary?.value?.latestTripTime != null)
                                        TextSpan(
                                          text:
                                              '(${summary?.value?.latestTripTime ?? "NA"})\n',
                                          style: AppTextStyles(context)
                                              .display11W500
                                              .copyWith(
                                                  color: AppColors.grayLight),
                                        ) else TextSpan(
                                        text:
                                        '\n',
                                      ),
                                      TextSpan(
                                        text:
                                            '${summary?.value?.latestTripKm == null ? "NA" : Utils.toStringAsFixed(data: summary?.value?.latestTripKm.toString())}',
                                        style: AppTextStyles(context)
                                            .display21W600
                                            .copyWith(
                                                color:
                                                    summary?.value?.latestTripKm == null
                                                        ? AppColors.grayLight
                                                        : null),
                                      ),
                                      if (summary?.value?.latestTripKm != null &&
                                          (summary?.value?.latestTripKm != "NA"))
                                        TextSpan(
                                          text: ' KM ',
                                          style: AppTextStyles(context)
                                              .display14W600
                                              .copyWith(
                                                  color: AppColors.grayLight),
                                        ),
                                    ],
                                  ),
                                )).paddingSymmetric(horizontal: 3, vertical: 4),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Skeletonizer(
                            enabled: isLoading?.value ?? false,
                            child: Container(
                                width: 52.w,
                                padding: EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /*   CircleAvatar(
                                      maxRadius: 16,
                                      backgroundColor: AppColors.selextedindexcolor,
                                      child: SvgPicture.asset(
                                        "assets/images/svg/max_speed_icon.svg",
                                        width: 16,
                                        height: 16,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),*/
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text.rich(
                                            textAlign: TextAlign.start,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Max Speed ',
                                                  style: AppTextStyles(context)
                                                      .display11W500,
                                                ),
                                                TextSpan(
                                                  text:
                                                      '@ ${summary?.value?.maxSpeedTime != null ? formatMaxSpeedTime(summary?.value?.maxSpeedTime) : "NA"}  ',
                                                  style: AppTextStyles(context)
                                                      .display11W500,
                                                ),
                                              ],
                                            ),
                                          ),
                                          FutureBuilder(
                                            future: controller.getCurrAddress(
                                                latitude: summary?.value?.maxSpeedLocation?.latitude,
                                                longitude: summary?.value?.maxSpeedLocation?.longitude),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<dynamic> snapshot) {
                                              return Text.rich(
                                                textAlign: TextAlign.start,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: '${snapshot.data}\n',
                                                      style: AppTextStyles(context)
                                                          .display11W500
                                                          .copyWith(
                                                              color: AppColors
                                                                  .grayLight),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Text.rich(
                                            textAlign: TextAlign.start,
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      '${summary?.value?.maxSpeed == null ? "NA" : Utils.toStringAsFixed(data: summary?.value?.maxSpeed.toString()) ?? "NA"} ',
                                                  style: AppTextStyles(context)
                                                      .display21W600,
                                                ),
                                                TextSpan(
                                                  text: 'KMPH',
                                                  style: AppTextStyles(context)
                                                      .display14W600
                                                      .copyWith(
                                                          color:
                                                              AppColors.grayLight),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )).paddingSymmetric(horizontal: 3, vertical: 4),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                              child: Skeletonizer(
                                enabled: isLoading?.value ?? false,
                                child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: Text.rich(
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Fuel Approx \n(Litres)\n',
                                                  style: AppTextStyles(context)
                                                      .display11W500,
                                                ),
                                                fuel != "N/A"
                                                    ? TextSpan(
                                                        text: Utils.toStringAsFixed(
                                                            data: fuel),
                                                        style:
                                                            AppTextStyles(context)
                                                                .display21W600,
                                                      )
                                                    : TextSpan(
                                                        text: 'NA',
                                                        style:
                                                            AppTextStyles(context)
                                                                .display21W600
                                                                .copyWith(
                                                                    color: AppColors
                                                                        .grayLight),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    )).paddingSymmetric(horizontal: 3, vertical: 4),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          if (isBottomSheet)
            Container(
              width: context.width,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppColors.color_e5e7e9,
                borderRadius: BorderRadius.circular(10),
              ),
              child: StaggeredGrid.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 4,
                  children: [
                    if (displayParameters?.extBattery != null &&
                        (displayParameters?.extBattery ?? false))
                      detailItem(
                          "Vehicle Battery",
                          "${Utils.toStringAsFixed(data: extBattery)} V",
                          "assets/images/svg/batt_icon.svg",
                          16),
                    if (displayParameters?.internalBattery != null &&
                        (displayParameters?.internalBattery ?? false))
                      detailItem(
                          "Device Battery",
                          "${Utils.formatInt(data: intBattery)} %",
                          "assets/images/svg/charging_icon.svg",
                          12),
                    if (displayParameters?.vehicleMotion != null &&
                        (displayParameters?.vehicleMotion ?? false))
                      detailItem(
                          "Vehicle Motion",
                          motion.toLowerCase() == "true" ? "True" : "False",
                          "assets/images/svg/car_icon.svg",
                          16),
                    if (displayParameters?.temperature != null &&
                        (displayParameters?.temperature ?? false))
                      detailItem(
                          "Temp. \nin °C",
                          "${Utils.toStringAsFixed(data: temp)}",
                          "assets/images/svg/temp_icon.svg",
                          16),
                    if (displayParameters?.humidity != null &&
                        (displayParameters?.humidity ?? false))
                      detailItem(
                          "Humidity \nin %",
                          "${Utils.toStringAsFixed(data: humid)}",
                          "assets/images/svg/humid_icon.svg",
                          16),
                    if (displayParameters?.bluetooth != null &&
                        (displayParameters?.bluetooth ?? false))
                      detailItem(
                          "Bluetooth Strength",
                          double.tryParse(bluetooth) != null
                              ? ((double.tryParse(bluetooth) ?? 0) > 10
                                  ? "Strong"
                                  : "Weak")
                              : "N/A",
                          "assets/images/svg/bluetooth_icon.svg",
                          16),
                  ]),
              /*child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      detailItem(
                          "Vehicle Battery",
                          "${Utils.toStringAsFixed(data: extBattery)}",
                          "assets/images/svg/batt_icon.svg",
                          16),
                      detailItem(
                          "Device Battery",
                          "${Utils.toStringAsFixed(data: intBattery)}",
                          "assets/images/svg/charging_icon.svg",
                          12),
                      detailItem(
                          "Vehicle Motion",
                          motion.toLowerCase() == "true" ? "True" : "False",
                          "assets/images/svg/car_icon.svg",
                          16),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (displayParameters?.temperature != null &&
                          (displayParameters?.temperature ?? false))
                        detailItem(
                            "Temp. \nin °C",
                            "${Utils.toStringAsFixed(data: temp)}",
                            "assets/images/svg/temp_icon.svg",
                            16),
                      if (displayParameters?.humidity != null &&
                          (displayParameters?.humidity ?? false))
                        detailItem(
                            "Humidity \nin %",
                            "${Utils.toStringAsFixed(data: humid)}",
                            "assets/images/svg/humid_icon.svg",
                            16),
                      if (displayParameters?.bluetooth != null &&
                          (displayParameters?.bluetooth ?? false))
                        detailItem(
                            "Bluetooth Strength",
                            double.tryParse(bluetooth) != null
                                ? ((double.tryParse(bluetooth) ?? 0) > 10
                                    ? "Strong"
                                    : "Weak")
                                : "N/A",
                            "assets/images/svg/bluetooth_icon.svg",
                            16),
                    ],
                  )
                ],
              ),*/
            ).paddingOnly(bottom: 10),
        ] else
          InkWell(
            onTap: () {
              controller.isFilterSelected.value = false;
              controller.isFilterSelectedindex.value = -1;
              controller.showAllVehicles();
              Get.put(BottomBarController()).updateIndexForRenewal(imei);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              width: context.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.radius_10),
                  color: AppColors.black),
              child: Center(
                child: Text(
                  'Extend / Renew Subscription',
                  style: AppTextStyles(context)
                      .display18W500
                      .copyWith(color: AppColors.selextedindexcolor),
                ),
              ),
            ),
          ).paddingOnly(top: 16),
      ],
    );
  }

  Widget detailItem(String title, String text, String icon, double size) {
    return Builder(builder: (context) {
      return Container(
          constraints: BoxConstraints(maxHeight: 11.h, maxWidth: 29.w),
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child:
                        Text(title, style: AppTextStyles(context).display11W400)
                            .paddingOnly(right: 2),
                  ),
                  CircleAvatar(
                    maxRadius: 16,
                    child: SvgPicture.asset(
                      icon,
                      width: size,
                      height: size,
                    ),
                    backgroundColor: AppColors.selextedindexcolor,
                  )
                ],
              ),
              Flexible(
                child: Text(
                  text,
                  overflow: TextOverflow.fade,
                  style: AppTextStyles(context).display18W600,
                ),
              ),
            ],
          )).paddingSymmetric(horizontal: 3, vertical: 4);
    });
  }

  List<Widget> _buildVehicleItems(BuildContext context) {
    return [
      if (displayParameters?.network == true)
        _buildVehicleItem(context, 'Network', networkIsActive, networkSubTitle,
            'assets/images/svg/ic_signal.svg'),
      if (displayParameters?.gps == true)
        _buildVehicleItem(context, 'Internet', gpsIsActive, gpsSubTitle,
            'assets/images/svg/new_internet.svg'),
      if (displayParameters?.engine == true)
        _buildVehicleItem(context, 'Engine', engineIsActive, engineSubTitle,
            'assets/images/svg/new_engine_icon.svg'),

      if (displayParameters?.ac == true)
        _buildVehicleItem(context, 'AC', acIsActive, acSubTitle,
            'assets/images/svg/new_ac.svg'),
      if (displayParameters?.geoFencing == true)
        _buildVehicleItem(context, 'Geofence', geofenceIsActive,
            geofenceSubTitle, 'assets/images/svg/new_geofence.svg'),

      if (displayParameters?.parking == true)
        _buildVehicleItem(context, 'Parking', parkingIsActive, parkingSubTitle,
            'assets/images/svg/new_parking.svg'),
      if (displayParameters?.door == true)
        _buildVehicleItem(context, 'Door', doorIsActive, doorSubTitle,
            'assets/images/svg/new_door.svg'),
      if (displayParameters?.relay == true)
        _buildVehicleItem(context, 'Relay', immobilizerIsActive,
            immobilizerSubTitle, 'assets/images/svg/new_relay.svg'),
    ];
  }

  Widget _buildVehicleItem(BuildContext context, String title, bool? isActive,
      String subTitle, String iconPath) {
    return Row(
      children: [
        SizedBox(
          width: 55,
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
              SizedBox(height: 1.h),
              FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles(context)
                      .display11W500
                      .copyWith(color: AppColors.black),
                ),
              ),
              // SizedBox(height: 0.3.h),
              // FittedBox(
              //   fit: BoxFit.contain,
              //   child: Text(
              //     subTitle,
              //     style: AppTextStyles(context)
              //         .display11W800
              //         .copyWith(color: AppColors.black),
              //   ),
              // ),
            ],
          ),
        ),
        SizedBox(width: 4),
      ],
    );
  }


  String formatMaxSpeedTime(String? maxSpeedTime) {
    try {
      final dateTime = DateTime.tryParse(maxSpeedTime ?? "");
      if (dateTime == null) {
        return "NA";
      }
      return DateFormat("HH:mm").format(dateTime);
    } catch (e) {
      return "NA";
    }
  }

}
