import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/app_localization.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/bottom_screen/controller/bottom_bar_controller.dart';

import '../../../config/app_sizer.dart';
import '../../splash_screen/controller/data_controller.dart';
import '../../track_route_screen/controller/track_route_controller.dart';

class BottomBarView extends StatelessWidget {
  BottomBarView({super.key});
  final BottomBarController controller = Get.put(BottomBarController());

  @override
  Widget build(BuildContext context) {
    final localizations = getAppLocalizations(context)!;

    return Scaffold(
      body: Obx(
            () {
          final int currentIndex = controller.selectedIndex.value;

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              // Determine direction based on index comparison
              final Offset beginOffset =
              (controller.previousIndex.value > currentIndex)
                  ? const Offset(-1, 0) // Slide in from the left
                  : const Offset(1, 0); // Slide in from the right

              return SlideTransition(
                position: Tween<Offset>(
                  begin: beginOffset,
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
            child: KeyedSubtree(
              // Assign a unique key for each screen
              key: ValueKey<int>(currentIndex),
              child: controller.screens[currentIndex],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        color: AppColors.black,
        height: 12.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Obx(() => bottomTabs(
              context: context,
              img: Assets.images.svg.btMenu,
              title: localizations.settings,
              isSelected: controller.selectedIndex.value == 0,
              onTap: () => controller.updateIndex(0),
            )),
            Obx(() => bottomTabs(
              context: context,
              img: Assets.images.svg.btNotification,
              title: localizations.alerts,
              isSelected: controller.selectedIndex.value == 1,
              onTap: () => controller.updateIndex(1),
            )),
            Column(
              children: [
                Obx(
                      () => InkWell(
                    onTap: () {
                      controller.updateIndex(2);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 6.h,
                      width: 24.w,
                      decoration: BoxDecoration(
                        color: controller.selectedIndex.value == 2
                            ? AppColors.selextedindexcolor
                            : AppColors.whiteOff,
                        borderRadius: BorderRadius.circular(AppSizes.radius_50),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          Assets.images.svg.btTrackRoute,
                          width: 35,
                          height: 35,
                        ),
                      ),
                    ).paddingOnly(top: 6, bottom: 6),
                  ),
                ),
                Text(
                  localizations.trackRoute,
                  style: AppTextStyles(context)
                      .display11W400
                      .copyWith(color: AppColors.whiteOff),
                ),
              ],
            ),
            Obx(() => bottomTabs(
              context: context,
              img: Assets.images.svg.btSteeringWheel,
              title: localizations.vehicle,
              isSelected: controller.selectedIndex.value == 3,
              onTap: () => controller.updateIndex(3),
            )),
            Obx(() => bottomTabs(
              context: context,
              img: Assets.images.svg.btCar,
              title: localizations.profile,
              isSelected: controller.selectedIndex.value == 4,
              onTap: () => controller.updateIndex(4),
            )),
          ],
        ).paddingOnly(bottom: 20),
      ),
    );
  }



  Widget bottomTabs({
    required BuildContext context,
    required String img,
    required bool isSelected,
    required String title,
    required VoidCallback onTap, // Add onTap callback
  }) {
    return GestureDetector(
      // Wrap with GestureDetector for tap detection
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor:
                isSelected ? AppColors.selextedindexcolor : AppColors.whiteOff,
            radius: 3.h,
            child: SvgPicture.asset(img, width: img == Assets.images.svg.btMenu ? 25 : 31, height:  img == Assets.images.svg.btMenu ?  25 : 31,),
          ).paddingOnly(top: 6, bottom: 6),
          Text(
            title,
            style: AppTextStyles(context)
                .display11W300
                .copyWith(color: AppColors.whiteOff),
          ),
        ],
      ),
    );
  }
}
