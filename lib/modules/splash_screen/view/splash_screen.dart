import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/Login_Screen/view/login_screen.dart';
import 'package:track_route_pro/modules/splash_screen/controller/splash_controller.dart';
import 'package:track_route_pro/routes/app_pages.dart';


class SplashView extends StatelessWidget {
  SplashView({super.key});
  final controller = Get.put(SplashController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: InkWell(
          onTap: () {
            Get.to(()=> LoginView(), transition: Transition.upToDown, duration: const Duration(milliseconds: 300));
            // Get.toNamed(Routes.LOGIN);
          },
          child: SvgPicture.asset(Assets.images.svg.logo),
        ),
      ),
    );
  }
}
