import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/about_us/controller/about_us_controller.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../../constants/project_urls.dart';
import '../../splash_screen/controller/data_controller.dart';

class AboutUsView extends StatelessWidget {
  AboutUsView({super.key});

  final controller = Get.put(AboutUsController());
  final dataController = Get.isRegistered<DataController>()
      ? Get.find<DataController>() // Find if already registered
      : Get.put(DataController());

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
              Row(
                children: [
                  Text(
                    'About Us',
                    style: AppTextStyles(context).display32W700.copyWith(
                          color: AppColors.whiteOff,
                        ),
                  ),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: SvgPicture.asset("assets/images/svg/close_icon.svg", ))
                ],
              ),
              SizedBox(
                height: 4.h,
              ),
            ],
          ).paddingSymmetric(horizontal: 6.w),
        ),
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 3.h,
                ),
                Obx(() => Text(controller.aboutUs.value.data?[0].description ?? ''))
                    .paddingSymmetric(horizontal: 6.w),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
