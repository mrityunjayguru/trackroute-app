/*
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

import '../../../../common/textfield/apptextfield.dart';
import '../../../../config/app_sizer.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_textstyle.dart';
import '../../../../utils/common_import.dart';
import '../../../../utils/utils.dart';
import '../../controller/track_route_controller.dart';
import 'edit_text_field.dart';

class SpeedDialog extends StatelessWidget {
  SpeedDialog({super.key});

  final controller = Get.isRegistered<TrackRouteController>()
      ? Get.find<TrackRouteController>() // Find if already registered
      : Get.put(TrackRouteController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 5.h,
            decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      15,
                    ),
                    topRight: Radius.circular(
                      15,
                    ))
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Speed Alert',
                    style: AppTextStyles(context).display16W600.copyWith(color: Colors.white),
                  ),
                ),
                InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: SvgPicture.asset(
                      'assets/images/svg/ic_close.svg',
                      color: AppColors.whiteOff,
                    )),
              ],
            ).paddingSymmetric(horizontal: 12, vertical: 6),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  '',
                  style: AppTextStyles(context).display16W600,
                ),
              ),
              InkWell(
                onTap: () {
                  controller.maxSpeedUpdate.text =
                      (controller.deviceDetail.value.data?[0].maxSpeed ?? "").toString();
                },
                child: Container(

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.radius_50),
                    color: AppColors.black,
                  ),
                  child: Center(
                    child: Text(
                      'Reset',
                      style: AppTextStyles(context)
                          .display12W500
                          .copyWith(color: AppColors.selextedindexcolor),
                    ).paddingSymmetric(horizontal: 4.w, vertical: 1.1.h),
                  ),
                ).paddingSymmetric(vertical: 1.4.h),
              ),
            ],
          ).paddingSymmetric(horizontal: 12),
          Row(
            // mainAxisAlignment:
            // MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Max Speed',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles(context)
                      .display14W400
                      .copyWith(color: AppColors.color_444650),
                ),
              ),
              SizedBox(width: 4.w),
              Flexible(
                  child: EditTextField(
                controller: controller.maxSpeedUpdate,
                hintText: "Max Speed",
              )),
              SizedBox(width: 2.w),
              Flexible(
                child: Text(
                  "In Kmph",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles(context)
                      .display14W400
                      .copyWith(color: AppColors.color_444650),
                ),
              ),
            ],
          ).paddingAll( 12),
          InkWell(
            onTap: () {
              controller.editDevicesByDetails(editSpeed: true, context: context);
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.radius_50),
                color: AppColors.black,
              ),
              child: Center(
                child: Text(
                  'Set Speed Alert',
                  style: AppTextStyles(context)
                      .display12W500
                      .copyWith(color: AppColors.selextedindexcolor),
                ).paddingSymmetric(horizontal: 4.w, vertical: 1.1.h),
              ),
            ).paddingSymmetric(vertical: 1.4.h, horizontal: 25),
          ),
        ],
      ),
    );
  }
}
*/
