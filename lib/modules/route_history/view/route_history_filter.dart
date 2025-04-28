import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/app_sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/modules/route_history/controller/history_controller.dart';
import 'package:track_route_pro/modules/route_history/controller/replay_controller.dart';
import 'package:track_route_pro/modules/route_history/view/route_replay.dart';
import 'package:track_route_pro/modules/route_history/view/widget/history_map.dart';
import 'package:track_route_pro/modules/route_history/view/widget/route_history_form.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_device_controller.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_device_controller.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_device_controller.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../../utils/utils.dart';

class RouteHistoryPage extends StatelessWidget {
  RouteHistoryPage({super.key});

  final controller = Get.isRegistered<HistoryController>()
      ? Get.find<HistoryController>() // Find if already registered
      : Get.put(HistoryController());

  final deviceController = Get.isRegistered<DeviceController>()
      ? Get.find<DeviceController>() // Find if already registered
      : Get.put(DeviceController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        color: AppColors.backgroundColor,
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: AppColors.backgroundColor,
            body: Obx(
              () => Stack(children: [
                if (controller.showMap.value) RouteHistoryMap(),
                Column(
                  children: [
                    Utils().topBar(
                        context: context,
                        rightIcon: 'assets/images/svg/ic_arrow_left.svg',
                        onTap: () {
                          if (!controller.showMap.value) {
                            controller.name.value = '';
                            controller.address.value = '';
                            controller.updateDate.value = '';
                            controller.dateController.clear();
                            controller.time1.value = null;
                            controller.endDateController.clear();
                            controller.time2.value = null;
                            controller.imei.value = '';
                            // trackController.stackIndex.value = 0;
                            Get.back();
                            deviceController.getDeviceByIMEI(zoom: true);
                          }
                          controller.showMap.value = false;
                          controller.data.value = [];
                        },
                        name: controller.showMap.value
                            ? controller.name.value
                            : "Route History"),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    controller.showMap.value
                        ? (controller.showDetails.value
                            ? Column(
                                children: [
                                  SizedBox(height: 1.h),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(
                                            AppSizes.radius_50)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              controller.isMaxSpeed.value
                                                  ? 'assets/images/svg/max_speed_marker.svg'
                                                  : 'assets/images/svg/red_marker.svg',
                                              width: 45,
                                              height: 45,
                                            ),
                                            Positioned(
                                              top: 11,
                                              child: Text(
                                                  controller.markerNumber.value,
                                                  style: AppTextStyles(context)
                                                      .display16W600
                                                      .copyWith(
                                                          fontSize: controller
                                                                      .markerNumber
                                                                      .value
                                                                      .length >
                                                                  2
                                                              ? ((controller
                                                                          .markerNumber
                                                                          .value
                                                                          .length >
                                                                      4)
                                                                  ? double.tryParse((16 - controller.markerNumber.value.length).toString()) ??
                                                                      13
                                                                  : 14)
                                                              : 16,
                                                          color: controller
                                                                  .isMaxSpeed
                                                                  .value
                                                              ? AppColors
                                                                  .selextedindexcolor
                                                              : AppColors.white)),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "${controller.isMaxSpeed.value ? "Max " : ""}Speed",
                                                  style: AppTextStyles(context)
                                                      .display11W500),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text.rich(
                                                textAlign: TextAlign.start,
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: controller
                                                          .selectedSpeed.value,
                                                      style: AppTextStyles(
                                                              context)
                                                          .display20W600
                                                          .copyWith(
                                                              fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height <
                                                                      670
                                                                  ? 18
                                                                  : 20),
                                                    ),
                                                    TextSpan(
                                                      text: ' KMPH',
                                                      style:
                                                          AppTextStyles(context)
                                                              .display14W600
                                                              .copyWith(
                                                                  color: AppColors
                                                                      .grayLight),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Time",
                                                  style: AppTextStyles(context)
                                                      .display11W500),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                controller.selectedTime.value,
                                                style: AppTextStyles(context)
                                                    .display20W600
                                                    .copyWith(
                                                        fontSize:
                                                            MediaQuery.of(context)
                                                                        .size
                                                                        .height <
                                                                    670
                                                                ? 18
                                                                : 20),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ).paddingOnly(
                                        left: 6, bottom: 7, top: 7, right: 6),
                                  ),
                                  SizedBox(height: 1.5.h),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: AppColors.selextedindexcolor,
                                        borderRadius: BorderRadius.circular(
                                            AppSizes.radius_50)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset(
                                            'assets/images/svg/ic_location.svg'),
                                        Flexible(
                                          child: Text(
                                            controller.markerAddress.value,
                                            style: AppTextStyles(context)
                                                .display13W500,
                                          ).paddingOnly(left: 5),
                                        )
                                      ],
                                    ).paddingOnly(left: 6, bottom: 7, top: 7),
                                  ),
                                ],
                              )
                            : SizedBox.shrink())
                        : RouteHistoryFilter(
                            name: controller.name.value,
                            date: controller.updateDate.value,
                            address: controller.address.value,
                          ),
                    Spacer(),
                    if (controller.showMap.value)
                      InkWell(
                        onTap: () {
                          final replayCon = Get.isRegistered<ReplayController>()
                              ? Get.find<
                                  ReplayController>() // Find if already registered
                              : Get.put(ReplayController());
                          replayCon.setInitData(controller.vehicleListReplay, controller.stopCount);
                          Get.to(() => RouteReplayView(),
                              transition: Transition.upToDown,
                              duration: const Duration(milliseconds: 300));
                        },
                        child: Container(
                          height: 6.h,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppSizes.radius_50),
                            color: AppColors.black,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                      "assets/images/svg/play_button.svg")
                                  .paddingOnly(right: 6),
                              Text(
                                'Replay Route',
                                style: AppTextStyles(context)
                                    .display18W400
                                    .copyWith(
                                        color: AppColors.selextedindexcolor),
                              )
                            ],
                          ),
                        ),
                      ).paddingOnly(bottom: 16)
                  ],
                ).paddingOnly(top: 12).paddingSymmetric(horizontal: 4.w * 0.9),
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
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
