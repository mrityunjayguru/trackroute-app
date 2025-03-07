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
import 'device_page.dart';

class RegisterDevicePage extends StatelessWidget {
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
                  personalInfo(context),
                  address(context),
                  documentation(context),
                  InkWell(
                    onTap: () {
                      Get.to(() => DevicePage(),
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

  Widget personalInfo(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Personal Info",
          style: AppTextStyles(context).display18W500,
        ),
        textfield(controller: TextEditingController(), hint: "Full Name"),
        textfield(controller: TextEditingController(), hint: "Email ID"),
        textfield(controller: TextEditingController(), hint: "Mobile Number"),
        textfield(
            controller: TextEditingController(),
            hint: "Gender",
            readOnly: true,
            suffixIcon: "assets/images/avg/ic_arrow_down.svg",
            onTap: () {}),
        textfield(controller: TextEditingController(), hint: "Date Of Birth"),
        SizedBox(height: 2.h),
      ],
    );
  }

  Widget address(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Address",
          style: AppTextStyles(context).display18W500,
        ),
        textfield(controller: TextEditingController(), hint: "Permanent Address"),
        textfield(controller: TextEditingController(), hint: "City"),
        textfield(controller: TextEditingController(), hint: "State"),
        SizedBox(height: 2.h),
      ],
    );
  }

  Widget documentation(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Upload Documentation",
          style: AppTextStyles(context).display18W500,
        ),
        textfield(
            controller: TextEditingController(),
            hint: "Select ID",
            readOnly: true,
            suffixIcon: "assets/images/avg/ic_arrow_down.svg",
            onTap: () {}),
        textfield(controller: TextEditingController(), hint: "ID Number"),
        SizedBox(height: 2.h),
        Text(
          "Ensure you enter the Uploaded ID number correctly to avoid delays in activation.",
          style: AppTextStyles(context)
              .display11W400
              .copyWith(color: AppColors.grayLight),
        ),
        SizedBox(height: 0.7.h),
        InkWell(
          onTap: () {
            Get.to(() => DevicePage(),
                transition: Transition.upToDown,
                duration: const Duration(milliseconds: 300));
          },
          child: Container(
            height: 6.h,
            child: Center(
              child: Text(
                "Upload Document",
                style: AppTextStyles(context)
                    .display16W400
                    .copyWith(color: AppColors.black),
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.radius_10),
              color: AppColors.selextedindexcolor,
            ),
          ),
        ),
        SizedBox(height: 0.7.h),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Upload the document as an image file. Make sure it is in ',
            style: AppTextStyles(context).display11W400.copyWith(
                  color: AppColors.grayLight,
                ),
            children: [
              TextSpan(
                text: 'JPG or PNG format ',
                style: AppTextStyles(context).display11W600.copyWith(
                      height: 1.2,
                      color: AppColors.grayLight,
                    ),
              ),
              TextSpan(
                text: 'and does ',
                style: AppTextStyles(context).display11W500.copyWith(
                      height: 1.2,
                      color: AppColors.grayLight,
                    ),
              ),
              TextSpan(
                text: 'not exceed 1MB ',
                style: AppTextStyles(context).display11W600.copyWith(
                      height: 1.2,
                      color: AppColors.grayLight,
                    ),
              ),
              TextSpan(
                text: 'in size.',
                style: AppTextStyles(context).display11W500.copyWith(
                      height: 2,
                      color: AppColors.grayLight,
                    ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
      ],
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
