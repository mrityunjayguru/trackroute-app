import 'package:flutter/gestures.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/constants/constant.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/otp_verification/controller/otp_controller.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../../config/app_sizer.dart';
import '../../../constants/project_urls.dart';
import '../../create_new_pass/view/create_new_password_view.dart';
import '../../forgot_password/controller/forgot_pass_controller.dart';
import '../../splash_screen/controller/data_controller.dart';

class OtpView extends StatelessWidget {
  final bool fromLogin;

  OtpView({super.key, this.fromLogin = false});

  final controller = Get.put(OtpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteOff,
      body: SingleChildScrollView(
        child: Form(
          key: controller.formKey.value,
          child: Column(
            children: [

                Container(
                  height: 35.h,
                  color: AppColors.black,
                  child:
                      Center(child: SvgPicture.asset(Assets.images.svg.logo)),
                ),
              Container(
                height: 6,
                color: AppColors.selextedindexcolor,
                child: Row(
                  children: [
                    Container(
                      width: context.width * 0.66,
                    ),
                    Expanded(
                        child: Container(
                      color: AppColors.color_f1f2f4,
                    ))
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Enter OTP',
                          style: AppTextStyles(context)
                              .display30W400
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                        InkWell(
                            onTap: () {

                              Get.back();
                              controller.otpErrorText.value="";
                              controller.otpController.value.text="";
                            },
                            child: SvgPicture.asset(
                              "assets/images/svg/close_icon.svg", colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                            )),
                      ],
                    ).paddingSymmetric(vertical: 8),
                    Text(
                      "Check Your Registered Email for OTP",
                      style: AppTextStyles(context).display18W700.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.grayLight,
                          ),
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    Obx(
                      () {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Pinput(
                                length: 6,
                                controller: controller.otpController.value,
                                focusNode: controller.otpFocusNode,
                                defaultPinTheme: PinTheme(
                                  width: 50,
                                  height: 50,
                                  textStyle:
                                      AppTextStyles(context).display22W700,
                                  decoration: BoxDecoration(
                                    color: AppColors.grayLight.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                    border: controller.isOtpError.value
                                        ? Border.all(
                                            color: AppColors.errorColor,
                                            width: 1.5)
                                        : null,
                                  ),
                                ),
                                focusedPinTheme: PinTheme(
                                  width: 50,
                                  height: 50,
                                  textStyle:
                                      AppTextStyles(context).display22W700,
                                  decoration: BoxDecoration(
                                    color: AppColors.selextedindexcolor
                                        .withOpacity(0.2),
                                    border: controller.isOtpError.value
                                        ? Border.all(
                                            color: AppColors.errorColor,
                                            width: 1.5)
                                        : Border.all(
                                            color: AppColors.grayLight,
                                            width: 1.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onChanged: (value) =>
                                    controller.validateOtp(otp: value),
                                validator: (value) =>
                                    controller.validateOtp(otp: value ?? ''),
                              ),
                            ),
                            if (controller.isOtpError.value)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  controller.otpErrorText.value ?? '',
                                  style: AppTextStyles(context)
                                      .display11W500
                                      .copyWith(color: AppColors.errorColor),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 3.h),
                    InkWell(
                      onTap: () {
                          if (controller.formKey.value.currentState!.validate()) {
                          // Handle OTP submission logic here
                          controller.verifyotp(fromLogin: fromLogin);
                        }
                      },
                      child: Container(
                        height: 6.h,
                        child: Center(
                          child: Text(
                            'Submit OTP',
                            style: AppTextStyles(context)
                                .display18W500
                                .copyWith(color: Color(0xffD9E821)),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSizes.radius_50),
                          color: AppColors.black,
                        ),
                      ).paddingOnly(bottom: 20),
                    ),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Didn't get OTP Code? ",
                          style: AppTextStyles(context).display14W400, // Non-clickable text style
                          children: [
                            TextSpan(
                              text: 'Resend OTP',

                              style: AppTextStyles(context).display14W400.copyWith(color: AppColors.purpleColor),
                              // Clickable text style
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  final controller =
                                      Get.put(ForgotPassController());
                                  if (controller.formKey.currentState!
                                      .validate()) {
                                    controller.forgotPassword(
                                        fromLogin: fromLogin);
                                  }
                                  // appPrint('Clicked on reset link');
                                },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
