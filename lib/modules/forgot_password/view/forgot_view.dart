import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/common/textfield/apptextfield.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/forgot_password/controller/forgot_pass_controller.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../../config/app_sizer.dart';
import '../../../constants/project_urls.dart';
import '../../splash_screen/controller/data_controller.dart';

class ForgotView extends StatelessWidget {
  final bool fromLogin;

  ForgotView({super.key, this.fromLogin = false});

  final controller = Get.put(ForgotPassController());

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
                      width: context.width * 0.33,
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
                          'Forgot password?',
                          style: AppTextStyles(context)
                              .display30W400
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                        InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: SvgPicture.asset(
                              "assets/images/svg/close_icon.svg", colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                            )),
                      ],
                    ).paddingOnly(bottom: 8, top: 8),
                    Text(
                      "We'll send you reset instructions.",
                      style: AppTextStyles(context).display18W700.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.grayLight),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Obx(
                      () => AppTextFormField(
                        border: Border.all(
                            width: 1,
                            color: controller.errorEmail.isNotEmpty
                                ? Colors.red
                                : Colors.transparent),
                        color: AppColors.textfield,
                        controller: controller.emailController,
                        hintText: 'Email ID',
                        errorText: controller.errorEmail.isNotEmpty
                            ? controller.errorEmail.value
                            : '',
                        // Change to null if no error
                        onChanged: (_) {
                          controller.validateEmail(
                              localizations); // Validate on change
                        },
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    InkWell(
                      onTap: () {
                        if (controller.formKey.currentState!.validate()) {
                          controller.forgotPassword(fromLogin: fromLogin);
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
