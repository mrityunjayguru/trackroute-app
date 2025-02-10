import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/about_us/controller/about_us_controller.dart';
import 'package:track_route_pro/modules/privacy_policy/controller/privacy_policy_controller.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../../constants/project_urls.dart';
import '../../splash_screen/controller/data_controller.dart';

class PrivacyPolicyView extends StatelessWidget {
  PrivacyPolicyView({super.key});

  final controller = Get.isRegistered<PrivacyPolicyController>()
      ? Get.find<PrivacyPolicyController>() // Find if already registered
      : Get.put(PrivacyPolicyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              SvgPicture.asset(Assets.images.svg.logo, height: 25),
              SizedBox(
                height: 2.h,
              ),
              Row(
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Privacy Policy',
                      style: AppTextStyles(context).display32W700.copyWith(
                            color: AppColors.whiteOff,
                          ),
                    ),
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
                height: 3.h,
              ),
            ],
          ).paddingSymmetric(horizontal: 6.w),
        ),
        SizedBox(
          height: 3.h,
        ),
        Obx(() => Expanded(
          child: SingleChildScrollView(
            child: ListView.separated(
              physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) =>
                      Text(controller.data[0].description ?? '')
                          .paddingSymmetric(horizontal: 6.w),
                  separatorBuilder: (BuildContext context, int index) => SizedBox(
                    height: 8,
                  ),
                  itemCount: controller.data.length,
                ),
          ),
        ))
      ]),
    );
  }
}
