import 'dart:developer';

import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/app_sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/alert_screen/controller/alert_controller.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../../../utils/utils.dart';

class AlertsNotificationView extends StatelessWidget {
  AlertsNotificationView({super.key});

  final controller = Get.find<AlertController>();

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
                name: 'Notification And Alerts'),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    alertData(
                        isOn: controller.notification,
                        title: 'All Notifications',
                        color: AppColors.selextedindexcolor,
                        img: "assets/images/svg/notif_icon_setting.svg",
                        allNotif: true),
                    alertData(
                        isOn: controller.Ignition,
                        title: 'Ignition',
                        img: "assets/images/svg/ic_engine_icon.svg"),
                    alertData(
                        isOn: controller.Geofencing,
                        title: 'Geofencing',
                        img: 'assets/images/svg/ic_geofence_icon.svg'),
                    alertData(
                        isOn: controller.OverSpeed,
                        title: 'Over Speed',
                        img: 'assets/images/svg/ic_engine_icon.svg'),
                    alertData(
                        isOn: controller.Parking,
                        title: 'Parking Alert',
                        img: 'assets/images/svg/ic_parking_icon.svg'),
                    alertData(
                        isOn: controller.Door,
                        title: 'AC/Door Alert',
                        img: 'assets/images/svg/ic_door_ac.svg'),
                    alertData(
                        isOn: controller.Fuel,
                        title: 'Fuel Alert',
                        img: 'assets/images/svg/ic_fuel.svg'),
                    alertData(
                        isOn: controller.ExpiryReminder,
                        title: 'Expiry Reminders',
                        img: 'assets/images/svg/ic_expiry_icon.svg'),
                    alertData(
                        isOn: controller.Vibration,
                        title: 'Vibration',
                        img: 'assets/images/svg/ic_charging_icon.svg'),
                    alertData(
                        isOn: controller.DevicePowerCut,
                        title: 'Device Power Cut',
                        img: 'assets/images/svg/ic_power_cut.svg'),
                    alertData(
                        isOn: controller.DeviceLowBattery,
                        title: 'Device Low Battery',
                        img: 'assets/images/svg/ic_low_batt.svg'),
                    alertData(
                        isOn: controller.OtherAlerts,
                        title: 'Other Alerts',
                        img: 'assets/images/svg/ic_other_alerts.svg'),
                  ],
                ),
              ),
            ),
          ],
        ).paddingAll(16),
      ),
    );
  }

  final WidgetStateProperty<Icon?> thumbIcon =
      WidgetStateProperty.resolveWith<Icon?>(
    (Set<WidgetState> states) {
      return const Icon(Icons.close, color: Colors.transparent);
    },
  );

  Widget alertData({
    required String title,
    required String img,
    Color? color,
    required ValueNotifier<bool> isOn,
    bool allNotif = false,
  }) {

    log("CONTROLLER ALL NOTIF ${controller.notification.value} ${ allNotif ? true : controller.notification.value}");
    return Builder(
      builder: (context) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.radius_10),
              color: color ?? AppColors.color_f6f8fc),
          child: Row(
            children: [
              CircleAvatar(
                  backgroundColor:
                      color == null ? AppColors.color_e5e7e9 : AppColors.white,
                  child: SvgPicture.asset(
                    img,
                    colorFilter: ColorFilter.mode(AppColors.black, BlendMode.srcIn),
                  )),
              SizedBox(
                width: 2.w,
              ),
              Text(
                '${title}',
                style: AppTextStyles(context).display18W500,
              ),
              Spacer(),
              /*  Switch(
                thumbIcon: thumbIcon,
                trackOutlineWidth: WidgetStatePropertyAll(0),
                trackOutlineColor: WidgetStatePropertyAll(Colors.transparent),
                activeColor: AppColors.selextedindexcolor,
                value: isOn.value,
                inactiveThumbColor: AppColors.selextedindexcolor,
                inactiveTrackColor: AppColors.grayLight,
                activeTrackColor: AppColors.black,
                onChanged: (value) {
                  isOn.value = value;
                }
              ),*/
              ValueListenableBuilder(
                valueListenable: controller.notification,
                builder: (BuildContext context, bool value, Widget? child) {
                  return ValueListenableBuilder(
                    valueListenable: isOn,
                    builder: (BuildContext context, bool value, Widget? child) {

                      log("IS ENABLED ${allNotif ? true : controller.notification.value}");
                      return AdvancedSwitch(
                        controller: isOn,
                        initialValue: isOn.value,
                        activeColor: AppColors.black,
                        inactiveColor: AppColors.grayLight,
                        thumb: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.selextedindexcolor,
                          ),
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                        width: 45.0,
                        height: 25.0,
                        enabled: allNotif ? true : controller.notification.value,
                        disabledOpacity: 0.5,
                        onChanged: (val){
                          if(!allNotif){
                            controller.setAlertsConfig();
                          }
                        },
                      ).paddingOnly(right: 6.w);
                    },
                  );
                },
              ),
            ],
          ).paddingOnly(left: 6.w, top: 8, bottom: 8),
        );
      }
    );
  }
}
