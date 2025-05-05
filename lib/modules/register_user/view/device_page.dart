import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/service/model/presentation/vehicle_type/Data.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../../common/textfield/apptextfield.dart';
import '../../../config/app_sizer.dart';
import '../../../utils/search_drop_down.dart';
import '../../../utils/utils.dart';
import '../controller/register_controller.dart';

class DevicePage extends StatelessWidget {
  final controller = Get.isRegistered<RegisterController>()
      ? Get.find<RegisterController>() // Find if already registered
      : Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteOff,
      body: Stack(
        children: [
          Container(
            height: 35.h,
            width: context.width,
            color: AppColors.black,
            padding: EdgeInsets.symmetric(horizontal: 65, vertical: 60),
            child: Align(
                    alignment: Alignment.topCenter,
                    child: SvgPicture.asset(Assets.images.svg.logo))
                .paddingOnly(top: 20),
          ),
          Container(
            decoration: BoxDecoration(
                color: AppColors.color_f6f8fc,
                borderRadius: BorderRadius.circular(AppSizes.radius_24)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Add Vehicle",
                        style: AppTextStyles(context).display24W500,
                      ).paddingOnly(bottom: 10),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: SvgPicture.asset(
                          'assets/images/svg/ic_arrow_left.svg',
                          colorFilter: ColorFilter.mode(
                              AppColors.black, BlendMode.srcIn),
                        ).paddingOnly(right: 12, left: 7.w),
                      )
                    ],
                  ),
                  Text(
                    "Register your First Vehicle!",
                    style: AppTextStyles(context)
                        .display12W500
                        .copyWith(color: AppColors.color_4B4749, height: 1.5),
                  ),
                  textfield(
                      controller: controller.imeiController,
                      hint: "Device IMEI No.",
                      inputFormatter: [Utils.intFormatter()],
                      errorText: controller.imeiError),
                  textfield(
                      controller: controller.simController,
                      hint: "SIM No.(Provided with device)",
                      errorText: controller.simError,
                      inputFormatter: [Utils.intFormatter()],
                      maxLength: 13),
                  textfield(
                      controller: controller.vehicleNumberController,
                      hint: "Vehicle Number",
                      errorText: controller.vehicleNoError),
                  SizedBox(
                    height: 20,
                  ),
                  Obx(() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1,
                                  color: controller
                                          .vehicleTypeError.value.isNotEmpty
                                      ? Colors.red
                                      : Colors.transparent),
                              borderRadius: BorderRadius.circular(16)),
                          child: SearchDropDown<DataVehicleType>(
                            dropDownFillColor: AppColors.white,
                            containerColor: AppColors.white,
                            showBorder: false,
                            hintStyle: AppTextStyles(context)
                                .display16W400
                                .copyWith(color: AppColors.grayLight),
                            height: 50,
                            items: controller.vehicleTypeList.toList(),
                            selectedItem: controller.vehicleCategory.value,
                            onChanged: (value) {
                              controller.vehicleCategory.value = value;
                              controller.vehicleTypeError.value = "";
                            },
                            hint: "Vehicle Category",
                            showSearch: false,
                          ),
                        ),
                        if (controller.vehicleTypeError.value.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            controller.vehicleTypeError.value.tr,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles(context)
                                .display14W400
                                .copyWith(color: AppColors.dangerDark),
                          ).paddingOnly(left: 5),
                        ],
                      ],
                    );
                  }),
                  SizedBox(
                    height: 20,
                  ),
                  Obx(() {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: controller
                                            .deviceTypeError.value.isNotEmpty
                                        ? Colors.red
                                        : Colors.transparent),
                                borderRadius: BorderRadius.circular(16)),
                            child: SearchDropDown<SearchDropDownModel>(
                              dropDownFillColor: AppColors.white,
                              containerColor: AppColors.white,
                              showBorder: false,
                              hintStyle: AppTextStyles(context)
                                  .display16W400
                                  .copyWith(color: AppColors.grayLight),
                              height: 50,
                              items: controller.deviceTypeList.toList(),
                              selectedItem: controller.deviceType.value,
                              onChanged: (value) {
                                controller.deviceType.value = value;
                                controller.deviceTypeError.value = "";
                              },
                              hint: "Device Type",
                              showSearch: false,
                            ),
                          ),
                          if (controller.deviceTypeError.value.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              controller.deviceTypeError.value.tr,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles(context)
                                  .display14W400
                                  .copyWith(color: AppColors.dangerDark),
                            ).paddingOnly(left: 5),
                          ],
                        ]);
                  }),
                  textfield(
                      controller: controller.dealerCodeController,
                      hint: "Dealer Code(Optional)",
                      errorText: "".obs),
                  SizedBox(height: 2.h),
                  InkWell(
                    onTap: () {
                      controller.sendDataVehicle();
                    },
                    child: Container(
                      height: 6.h,
                      child: Center(
                        child: Text(
                          "Add Vehicle",
                          style: AppTextStyles(context)
                              .display16W400
                              .copyWith(color: AppColors.selextedindexcolor),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSizes.radius_10),
                        color: AppColors.black,
                      ),
                    ),
                  ).paddingOnly(bottom: 1.h),
                  SizedBox(height: 1.h),
                ],
              ),
            ),
          ).paddingOnly(bottom: 17, left: 17, right: 17, top: 150),
        ],
      ),
    );
  }

  Widget textfield(
      {bool readOnly = false,
      required TextEditingController controller,
      VoidCallback? onTap,
      VoidCallback? onSuffixTap,
      bool obscureText = false,
      List<TextInputFormatter>? inputFormatter,
      String? suffixIcon,
      int? maxLength,
      required RxString errorText,
      required String hint}) {
    return Obx(
      () => AppTextFormField(
        maxLength: maxLength,
        height: 50,
        readOnly: readOnly,
        onTap: onTap,
        onSuffixTap: onSuffixTap,
        suffixIcon: suffixIcon,
        color: AppColors.white,
        controller: controller,
        hintText: hint,
        inputFormatters: inputFormatter,
        obscureText: obscureText,
        errorText: errorText.value,
        onChanged: (val) {
          if (val.trim().isNotEmpty && errorText.value.isNotEmpty) {
            errorText.value = "";
          }
        },
        border: Border.all(
            width: 1,
            color: errorText.isNotEmpty ? Colors.red : Colors.transparent),
      ),
    );
  }
}
