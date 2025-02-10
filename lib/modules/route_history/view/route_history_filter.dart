import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/app_sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/route_history/controller/history_controller.dart';
import 'package:track_route_pro/modules/route_history/view/widget/history_map.dart';
import 'package:track_route_pro/modules/route_history/view/widget/route_history_form.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_route_controller.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../../../constants/project_urls.dart';
import '../../../utils/utils.dart';
import '../../splash_screen/controller/data_controller.dart';

class RouteHistoryPage extends StatelessWidget {
  RouteHistoryPage({super.key});

  final trackController = Get.isRegistered<TrackRouteController>()
      ? Get.find<TrackRouteController>() // Find if already registered
      : Get.put(TrackRouteController());

  final controller = Get.isRegistered<HistoryController>()
      ? Get.find<HistoryController>() // Find if already registered
      : Get.put(HistoryController());
  var scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor:   AppColors.backgroundColor,
          body: Obx(
            () => Stack(children: [
              if (controller.showMap.value) RouteHistoryMap(),
              Column(
                children: [
                  Utils().topBar(
                      context: context,
                      rightIcon: 'assets/images/svg/ic_arrow_left.svg',
                      onTap: () {
                        if (!controller.showMap.value) {
                          controller.name.value = '';
                          controller.address.value = '';
                          controller.updateDate.value = '';
                          controller.dateController.clear();
                          controller.time1.value = null;
                          controller.endDateController.clear();
                          controller.time2.value = null;
                          controller.imei.value = '';
                          trackController.stackIndex.value = 0;
                        }
                        controller.showMap.value = false;
                        controller.data.value = [];

                      },
                      name: controller.showMap.value
                          ? controller.name.value
                          : "Route History"),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  controller.showMap.value
                      ? SizedBox()
                      : RouteHistoryFilter(
                          name: controller.name.value,
                          date: controller.updateDate.value,
                          address: controller.address.value,
                        )
                ],
              ).paddingOnly(top: 12).paddingSymmetric(horizontal: 4.w * 0.9),
              if(controller.showLoader.value)Positioned.fill(child: Container(
                alignment: Alignment.center,
                color: Colors.grey.withOpacity(0.7),
                child: LoadingAnimationWidget.threeArchedCircle(
                  color: AppColors.selextedindexcolor,
                  size: 50,
                ),
              ),)
            ]),
          ),
        ),
      ),
    );
  }
}
