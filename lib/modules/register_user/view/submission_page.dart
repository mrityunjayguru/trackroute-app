import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../../config/app_sizer.dart';
import '../../Login_Screen/view/login_screen.dart';

class SubmissionPage extends StatelessWidget {
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
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: AppColors.color_f6f8fc,
                    borderRadius: BorderRadius.circular(AppSizes.radius_24)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: "Thank you for your submission!\n",
                            style: AppTextStyles(context)
                                .display32W700
                                .copyWith(fontWeight: FontWeight.w500,height: 1.3),
                            children: [
                              TextSpan(
                                text:
                                    "Your device will be activated within 24 hours. Once activated, you will receive a confirmation email.",
                                style: AppTextStyles(context)
                                    .display17W500.copyWith(height: 1.3),
                              )
                            ]),
                      ),
                      SvgPicture.asset("assets/images/svg/register_icon.svg"),
                    ],
                  ),
                ),
              ).paddingOnly(bottom: 17, left: 17, right: 17, top: 150),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'You can now return to the ',
                  style: AppTextStyles(context).display11W500.copyWith(
                    color: AppColors.grayLight,
                  ),
                  children: [
                    TextSpan(
                        text: 'login screen ',
                        style: AppTextStyles(context).display13W500.copyWith(
                          height: 2,
                          color: AppColors.purpleColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..  onTap= () {
                            Get.to(() => LoginView(),
                                transition: Transition.upToDown,
                                duration: const Duration(milliseconds: 300));
                          }
                    ),
                    TextSpan(
                      text: 'to\naccess your account.',
                      style: AppTextStyles(context).display13W500.copyWith(
                        color: AppColors.grayLight,
                      ),
                    ),
                  ],
                ),
              ).paddingOnly(bottom: 8)
            ],
          ),

        ],
      ),
    );
  }
}
