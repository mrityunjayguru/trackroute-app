import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_device_controller.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_device_controller.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_device_controller.dart';
import '../../../../../config/app_sizer.dart';
import '../../../../../config/theme/app_colors.dart';
import '../../../../../config/theme/app_textstyle.dart';
import '../../../../../utils/common_import.dart';
import '../../../controller/track_route_controller.dart';


class RelayDialog extends StatelessWidget {
  RelayDialog({super.key});

  final controller = Get.isRegistered<TrackRouteController>()
      ? Get.find<TrackRouteController>() // Find if already registered
      : Get.put(TrackRouteController());

  final deviceController = Get.isRegistered<DeviceController>()
      ? Get.find<DeviceController>() // Find if already registered
      : Get.put(DeviceController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.color_f0f4fd,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(
                          AppSizes.radius_10,
                        ),
                        bottomRight: Radius.circular(
                          AppSizes.radius_10,
                        ))),
                child: Row(
                  children: [
                    SvgPicture.asset("assets/images/svg/warning_icon.svg"),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Warning!',
                          style: AppTextStyles(context)
                              .display20W500
                              .copyWith(color: AppColors.white),
                        ).paddingSymmetric(horizontal: 12),
                        Text(
                          'Proceed with Caution',
                          style: AppTextStyles(context)
                              .display16W500
                              .copyWith(color: AppColors.selextedindexcolor),
                        ).paddingSymmetric(horizontal: 12),
                      ],
                    ).paddingSymmetric(vertical: 10, horizontal: 6),
                  ],
                ).paddingSymmetric( horizontal: 6),
              ).paddingOnly(right: 15),
              Spacer(),
              InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: SvgPicture.asset(
                    'assets/images/svg/close_icon_dialog.svg',
                  )),
            ],
          ).paddingOnly(left: 12, right: 12, bottom: 15),
          Text(
            'Would you like to continue?',
            style: AppTextStyles(context).display20W500,
          ).paddingSymmetric(horizontal: 12, vertical: 6),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSizes.radius_50),
                      color: AppColors.black,
                    ),
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: AppTextStyles(context)
                            .display18W400
                            .copyWith(color: AppColors.selextedindexcolor),
                      ).paddingSymmetric(horizontal: 4.w, vertical: 1.5.h),
                    ),
                  ).paddingSymmetric(vertical: 1.4.h, horizontal: 0),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                      Get.showOverlay(
                          asyncFunction: () => deviceController.stopEngine(
                              deviceController.deviceDetail.value?.imei ??
                                  ""),
                          loadingWidget: LoadingAnimationWidget.dotsTriangle(
                            color: AppColors.white,
                            size: 50,
                          ));

                    Get.back();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSizes.radius_50),
                      color: AppColors.color_e23226,
                    ),
                    child: Center(
                      child: Text(
                        'Turn Off Engine',
                        style: AppTextStyles(context)
                            .display18W400
                            .copyWith(color: AppColors.white),
                      ).paddingSymmetric(horizontal: 0.5.w, vertical: 1.5.h),
                    ),
                  ).paddingSymmetric(vertical: 1.4.h, horizontal: 0),
                ),
              ),
            ],
          ).paddingOnly(left: 12, right: 12, bottom: 15),
          Container(
            decoration: BoxDecoration(
                color: AppColors.color_e5e7e9,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      AppSizes.radius_10,
                    ),
                    topRight: Radius.circular(
                      AppSizes.radius_10,
                    ))),
            child: Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset("assets/images/svg/red_check.svg").paddingOnly(right: 3),
                    Text(
                      'Use only when necessary.',
                      style: AppTextStyles(context).display16W500,
                    ).paddingSymmetric(horizontal: 5,vertical: 3),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset("assets/images/svg/red_check.svg").paddingOnly(right: 5),
                    Text(
                      'Double-check before confirming.',
                      style: AppTextStyles(context).display16W500,
                    ).paddingSymmetric(horizontal: 5, vertical: 3),
                  ],
                ),
              ],
            ).paddingSymmetric(vertical: 12, horizontal: 12),
          ).paddingOnly(left: 12, right: 12, bottom: 0),
        ],
      ),
    );
  }
}
