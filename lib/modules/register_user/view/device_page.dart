import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/register_user/view/submission_page.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../../common/textfield/apptextfield.dart';
import '../../../config/app_sizer.dart';
import '../../../utils/search_drop_down.dart';
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
                  Text(
                    "Add Vehicle",
                    style: AppTextStyles(context).display24W500,
                  ),
                  Text(
                    "Register your First Vehicle!",
                    style: AppTextStyles(context)
                        .display12W500
                        .copyWith(color: AppColors.color_4B4749,height: 1.5),
                  ),
                  textfield(controller: controller.imeiController, hint: "Device IMEI No."),
                  textfield(controller: controller.simController, hint: "Device SIM No."),
                  textfield(controller: controller.vehicleNumberController, hint: "Vehicle Number"),
                  SizedBox(height: 20,),
                  SearchDropDown<SearchDropDownModel>(
                    dropDownFillColor: AppColors.white,
                    containerColor: AppColors.white,
                    showBorder: false,
                    hintStyle: AppTextStyles(context)
                        .display16W400
                        .copyWith(color: AppColors.grayLight),
                    height: 50,
                    items:
                    controller.genderList.toList(),
                    selectedItem:
                    controller.vehicleCategory.value,
                    onChanged: (value) {
                      controller.vehicleCategory.value= value;
                    },
                    hint: "Vehicle Category",
                    showSearch: false,
                  ),
                  textfield(controller: controller.dealerCodeController, hint: "Dealer Code(Optional)"),
                  SizedBox(height: 5.h),
                  InkWell(
                    onTap: () {
                      Get.back();
                      Get.back();
                      Get.to(() => SubmissionPage(),
                          transition: Transition.upToDown,
                          duration: const Duration(milliseconds: 300));
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
        String? suffixIcon,
        required String hint}) {
    return AppTextFormField(
      height: 50,
      readOnly: readOnly,
      onTap: () => onTap,
      onSuffixTap: () => onTap,
      suffixIcon: suffixIcon,
      color: AppColors.white,
      controller: controller,
      hintText: hint,
    );
  }
}
