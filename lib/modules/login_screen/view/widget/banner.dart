import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/app_sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/modules/login_screen/controller/login_controller.dart';
import 'package:track_route_pro/utils/common_import.dart';

class AdvertiseBanner extends StatelessWidget {
  AdvertiseBanner({required this.child, super.key});
  final controller = Get.put(LoginController());
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.whiteOff,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radius_20),
      ),
      child: SizedBox(
          width: 90.w,
          height: 60.h,
          child: Column(
            children: [
              Align(
                child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: SvgPicture.asset('assets/images/svg/ic_close.svg')),
                alignment: Alignment.topRight,
              ).paddingAll(8),
              child
            ],
          )),
    );
  }
}
