import 'package:flutter/gestures.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/common/textfield/apptextfield.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/create_new_pass/controller/create_new_password_controller.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../../config/app_sizer.dart';
import '../../../constants/project_urls.dart';
import '../../splash_screen/controller/data_controller.dart';

class CreateNewPasswordView extends StatelessWidget {
  final bool fromLogin;
  CreateNewPasswordView({super.key, this.fromLogin=false});
  final controller = Get.put(CreateNewPasswordController());
  final dataController = Get.isRegistered<DataController>()
      ? Get.find<DataController>() // Find if already registered
      : Get.put(DataController());

  @override
  Widget build(BuildContext context) {
    final localizations = getAppLocalizations(context)!;
    return Scaffold(
      backgroundColor: AppColors.whiteOff,
      body: SingleChildScrollView(
        child: Form(
          key: controller.formKey, // Attach the GlobalKey to the Form
          child: Column(
            children: [
              if (fromLogin)
                Container(
                  height: 35.h,
                  color: AppColors.black,
                  child:
                  Center(child: SvgPicture.asset(Assets.images.svg.logo)),
                )
              else
                Container(
                  // height: 20.h,
                  width: 100.w,
                  decoration: BoxDecoration(color: AppColors.black),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8.h,
                      ),
                      Row(
                        children: [
                          Obx(
                                () => Image.network(
                                width: 120,
                                height: 50,
                                "${ProjectUrls.imgBaseUrl}${dataController.settings.value.appLogo}",
                                errorBuilder: (context, error, stackTrace) =>
                                    SvgPicture.asset(
                                      Assets.images.svg.icIsolationMode,
                                      color: AppColors.black,
                                    )),
                          ),
                          Spacer(),
                          InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: SvgPicture.asset(
                                "assets/images/svg/close_icon.svg",
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 6.w),
                ),
              Container(
                height: 6,
                color: AppColors.selextedindexcolor,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Obx(
                      () => AppTextFormField(
                        suffixIconHeight: 25,
                        obscureText: controller.obscureText.value,
                        onSuffixTap: () {
                          controller.obscureText.value =
                          !controller.obscureText.value;
                        },
                        suffixIcon: !controller.obscureText.value
                            ? 'assets/images/svg/eye_open_icon.svg'
                            : 'assets/images/svg/eye_close_icon.svg',
                        color: AppColors.textfield,
                        controller: controller.passwordController,
                        border: Border.all(
                            color: controller.errorPassword.isNotEmpty
                                ? Colors.red
                                : Colors.transparent),
                        hintText: 'Password',
                        errorText: controller.errorPassword.isNotEmpty
                            ? controller.errorPassword.value
                            : '',
                        onChanged: (_) {
                          controller.validatePassword(localizations);
                        },
                      ),
                    ),
                    Obx(
                      () => AppTextFormField(
                        suffixIconHeight: 25,
                        obscureText: controller.obscureText.value,
                        onSuffixTap: () {
                          controller.obscureText.value =
                          !controller.obscureText.value;
                        },
                        suffixIcon: !controller.obscureText.value
                            ? 'assets/images/svg/eye_open_icon.svg'
                            : 'assets/images/svg/eye_close_icon.svg',
                        border: Border.all(
                            color: controller.errorConfirmPassword.isNotEmpty
                                ? Colors.red
                                : Colors.transparent),
                        color: AppColors.textfield,
                        controller: controller.confirmpasswordController,
                        hintText: 'Confirm Password',
                        errorText: controller.errorConfirmPassword.isNotEmpty
                            ? controller.errorConfirmPassword.value
                            : '',
                        onChanged: (_) {
                          controller.validateConfirmPassword();
                        },
                      ),
                    ),
                    SizedBox(height: 24.h),
                    InkWell(
                      onTap: () {
                        if (controller.formKey.currentState!.validate()) {
                          // Proceed with the password reset logic
                          controller.resetPassword(fromLogin: fromLogin);
                        }
                      },
                      child: Container(
                        height: 6.h,
                        child: Center(
                          child: Text(
                            'Reset Password',
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
                    // forgotPasswordMethod(),
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
