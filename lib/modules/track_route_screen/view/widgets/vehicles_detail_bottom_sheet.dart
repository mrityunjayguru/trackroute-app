import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/app_sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_route_controller.dart';
import 'package:track_route_pro/modules/vehicales/controller/vehicales_controller.dart';
import 'package:track_route_pro/service/model/presentation/track_route/DisplayParameters.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../../../utils/custom_vehicle_data.dart';

class VehicalDetailBottomSheet extends StatelessWidget {
  final controller = Get.isRegistered<VehicalesController>()
      ? Get.find<VehicalesController>()
      : Get.put(VehicalesController());
  final trackController = Get.isRegistered<TrackRouteController>()
      ? Get.find<TrackRouteController>()
      : Get.put(TrackRouteController());

  VehicalDetailBottomSheet({
    required this.vehicalNo,
    required this.isActive,
    required this.temp,
    required this.humid,
    required this.motion,
    required this.bluetooth,
    required this.intBattery,
    required this.extBattery,
    required this.dateTime,
    required this.address,
    required this.totalkm,
    required this.imei,
    required this.currentSpeed,
    required this.deviceID,
    super.key,
    required this.icon,
    required this.fuel,
    this.ignition,
    this.gps,
    this.network,
    this.ac,
    required this.vehicleName,
    this.charging,
    this.immob,
    this.parking,
    this.door,
    this.geofence,
    this.engine, this.displayParameters, this.expiryDate,
  });

  final String vehicalNo, icon, fuel, vehicleName;
  final String dateTime;
  final String address;
  final String totalkm;
  final String deviceID;
  final String imei;
  final String extBattery;
  final String intBattery;
  final String humid;
  final String temp;
  final String motion;
  final String bluetooth;
  final String? expiryDate;
  final bool? ignition,
      gps,
      network,
      ac,
      charging,
      immob,
      parking,
      door,
      geofence,
      engine;

  final double currentSpeed;
  final bool isActive;
  final DisplayParameters? displayParameters;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 50.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            spreadRadius: 0,
            offset: Offset(0, 4),
            color: Color(0xff000000).withOpacity(0.2),
          )
        ],
        borderRadius: BorderRadius.only(topLeft: Radius.circular(AppSizes.radius_16), topRight: Radius.circular(AppSizes.radius_16)),
      ),
      child: Column(
        children: [
          VehicleDataWidget(
            expiryDate: expiryDate,
            isActive: isActive,
            temp: temp, humid: humid, motion: motion,bluetooth: bluetooth,extBattery: extBattery,intBattery: intBattery,
            displayParameters: displayParameters,
                  showDeviceIdCopy: true,
                  odo: totalkm,
                  fuel: fuel,
                  speed: currentSpeed.toString(),
                  deviceId: deviceID,
                  doorIsActive: door,
                  doorSubTitle: door == null ? "N/A" : (door! ? "OPEN" : "CLOSED"),
                  engineIsActive: engine,
                  engineSubTitle:
                      engine == null ? "N/A" : (engine! ? "OPEN" : "CLOSED"),
                  parkingIsActive: parking,
                  parkingSubTitle:
                      parking == null ? "N/A" : (parking! ? "ON" : "OFF"),
                  immobilizerIsActive: immob,
                  immobilizerSubTitle:
                      immob == null ? "N/A" : (immob! ? "ON" : "OFF"),
                  geofenceIsActive: geofence,
                  geofenceSubTitle:
                      geofence == null ? "N/A" : (geofence! ? "ON" : "OFF"),
                  gpsIsActive: gps,
                  gpsSubTitle: gps == null ? "N/A" : (gps! ? "ON" : "OFF"),
                  networkIsActive: network,
                  networkSubTitle:
                      network == null ? "N/A" : (network! ? "AVAILABLE" : "OFF"),
                  acIsActive: ac,
                  acSubTitle: ac == null ? "N/A" : (ac! ? "ON" : "OFF"),
                  chargingIsActive: charging,
                  chargingSubTitle:
                      charging == null ? "N/A" : (charging! ? "ON" : "OFF"),
                  address: address,
                  lastUpdate: dateTime,
                  vehicleName: vehicalNo,
                  imei: imei, isBottomSheet: true,)
              .paddingOnly(left: 4.w, right: 4.w, top: 3.6.h),
        ],
      ),
    );
  }

}
