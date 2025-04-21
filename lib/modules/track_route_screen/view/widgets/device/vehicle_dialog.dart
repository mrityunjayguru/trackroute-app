import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_device_controller.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_device_controller.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_device_controller.dart';

import '../../../../../config/app_sizer.dart';
import '../../../../../config/theme/app_colors.dart';
import '../../../../../config/theme/app_textstyle.dart';
import '../../../../../utils/common_import.dart';
import '../../../controller/track_route_controller.dart';
import 'edit_text_field.dart';

class VehicleDialog extends StatelessWidget {
  VehicleDialog({super.key});

  final controller = Get.isRegistered<DeviceController>()
      ? Get.find<DeviceController>() // Find if already registered
      : Get.put(DeviceController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (val, val1){
        controller.dialogOpen = false; // Change dialogOpen when closed
      },
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.color_f0f4fd,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(
                              10,
                            ),
                            bottomRight: Radius.circular(
                              10,
                            ))),
                    child: Column(
                      children: [
                        Text(
                          'Enter Vehicle Details',
                          style: AppTextStyles(context)
                              .display20W500
                              .copyWith(color: AppColors.white),
                        ).paddingSymmetric(horizontal: 12),
                        Text(
                          'for Accurate Notifications',
                          style: AppTextStyles(context)
                              .display16W500
                              .copyWith(color: AppColors.selextedindexcolor),
                        ).paddingSymmetric(horizontal: 12),
                      ],
                    ).paddingSymmetric(vertical: 10, horizontal: 6),
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
              ).paddingOnly(left: 15, right: 15, bottom: 15),
              if (controller.deviceDetail.value?.vehicleNo?.isEmpty ??
                  true)
                EditTextField(
                  controller: controller.vehicleName,
                  hintText: "Vehicle Number",
                  inputFormatters: [],
                  height: 42,
                  borderRadius: AppSizes.radius_10,
                  color: Colors.white,
                  hintStyle: AppTextStyles(context)
                      .display16W400
                      .copyWith(color: AppColors.color_969696),
                  textStyle: AppTextStyles(context).display16W500,
                ).paddingOnly(left: 15, right: 15, bottom: 15),
            /*  if (controller.deviceDetail.value?.vehicleRegistrationNo
                      ?.isEmpty ??
                  true)
                EditTextField(
                  controller: controller.vehicleRegistrationNumber,
                  hintText: "Vehicle Plate No",
                  inputFormatters: [],
                  height: 42,
                  borderRadius: AppSizes.radius_10,
                  color: Colors.white,
                  hintStyle: AppTextStyles(context)
                      .display16W400
                      .copyWith(color: AppColors.color_969696),
                  textStyle: AppTextStyles(context).display16W500,
                ).paddingOnly(left: 15, right: 15, bottom: 15),*/
              if (controller.deviceDetail.value?.driverName?.isEmpty ??
                  true)
                EditTextField(
                  controller: controller.driverName,
                  hintText: "Driving Person",
                  height: 42,
                  borderRadius: AppSizes.radius_10,
                  color: Colors.white,
                  hintStyle: AppTextStyles(context)
                      .display16W400
                      .copyWith(color: AppColors.color_969696),
                  textStyle: AppTextStyles(context).display16W500,
                  inputFormatters: [],
                ).paddingOnly(left: 15, right: 15, bottom: 15),
              InkWell(
                onTap: () {
                  controller.editDeviceData(context);
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.radius_50),
                    color: AppColors.black,
                  ),
                  child: Center(
                    child: Text(
                      'Save',
                      style: AppTextStyles(context)
                          .display18W500
                          .copyWith(color: AppColors.selextedindexcolor),
                    ).paddingSymmetric(horizontal: 1.w, vertical: 1.4.h),
                  ),
                ).paddingSymmetric(vertical: 1.4.h, horizontal: 60),
              ),
              Text(
                "Don’t worry, you can change the details later by",
                style: AppTextStyles(context).display12W400,
                textAlign: TextAlign.center,
              ).paddingSymmetric(horizontal: 15),
              Text(
                "selecting the vehicle and clicking on 'Manage Vehicle'",
                style: AppTextStyles(context)
                    .display12W400
                    .copyWith(decoration: TextDecoration.underline),
                textAlign: TextAlign.center,
              ).paddingOnly(left: 15, right: 15, bottom: 15)
            ],
          ),
        ),
      ),
    );
  }

  Widget textFieldRow(
      {required String title,
      required TextEditingController con,
      required String hintText,
      required BuildContext context,
      List<TextInputFormatter>? inputFormatters,
      bool readOnly = false,
      VoidCallback? onTap}) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 2,
          style: AppTextStyles(context).display13W400,
        ),
        SizedBox(
          height: 0.6.h,
        ),
        EditTextField(
          controller: con,
          hintText: hintText,
          onTap: onTap,
          readOnly: readOnly,
          inputFormatters: inputFormatters,
        )
      ],
    ).paddingSymmetric(vertical: 8, horizontal: 12);
  }
}
