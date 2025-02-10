import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/app_localization.dart';
import 'package:track_route_pro/config/app_sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/alert_screen/controller/alert_controller.dart';
import 'package:track_route_pro/modules/alert_screen/view/widget/announcement.dart';
import 'package:track_route_pro/modules/alert_screen/view/widget/filterview.dart';
import 'package:track_route_pro/modules/alert_screen/view/widget/notification.dart';

import '../../../constants/project_urls.dart';
import '../../splash_screen/controller/data_controller.dart';

class AlertView extends StatefulWidget {
  AlertView({super.key});

  @override
  _AlertViewState createState() => _AlertViewState();
}

class _AlertViewState extends State<AlertView> with SingleTickerProviderStateMixin {
  final controller = Get.put(AlertController());
  late TabController tabController;
  final dataController =  Get.isRegistered<DataController>()
      ? Get.find<DataController>() // Find if already registered
      : Get.put(DataController());
  @override
  void initState() {
    super.initState();
    controller.selectedIndex.value=0;
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      controller.selectedIndex.value = tabController.index;
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => controller.getData(),);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = getAppLocalizations(context)!;

    return SafeArea(
      child: Obx(()=>DefaultTabController(
          length: 2,
          child: Container(
            color: AppColors.backgroundColor,
            child:Column(
              children: [
                Row(
                  children: [
                    Image.network(
                        width: 25,
                        height: 25,
                        "${ProjectUrls.imgBaseUrl}${dataController.settings.value.logo}",
                        errorBuilder: (context, error, stackTrace) =>
                            SvgPicture.asset(
                              Assets.images.svg.icIsolationMode,
                              color: AppColors.black,
                            )).paddingOnly(right: 8),

                    Text(
                      localizations.alertsCenter,
                      style: AppTextStyles(context).display20W500,
                    ),
                    Spacer(),
                    if(controller.selectedIndex.value == 0)InkWell(
                      onTap: () {
                        controller.getAlertsDetails();
                        Get.to(() => AlertsNotificationView(),
                            transition: Transition.upToDown,
                            duration: const Duration(milliseconds: 300));
                      },
                      child: SvgPicture.asset('assets/images/svg/ic_filter.svg'),
                    ),
                  ],
                ).paddingOnly(top: 12, right: 8, left: 8),
                SizedBox(height: 15),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radius_50),
                  child: Container(
                    decoration: BoxDecoration(color: AppColors.whiteOff),
                    child: TabBar(
                      controller: tabController, // Bind the TabController here
                      dividerHeight: 0,
                      indicatorSize: TabBarIndicatorSize.tab,
                      enableFeedback: true,
                      indicatorPadding: EdgeInsets.zero,
                      labelPadding: EdgeInsets.zero,
                      indicator: BoxDecoration(
                        border: Border.all(color: AppColors.selextedindexcolor),
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(AppSizes.radius_50),
                      ),
                      tabs: [
                        Obx(() => Tab(
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                controller.selectedIndex.value == 0
                                    ? AppColors.selextedindexcolor
                                    : AppColors.grayLighter,
                                child: SvgPicture.asset(
                                    'assets/images/svg/ic_alert.svg'),
                              ),
                              SizedBox(width:2.w),
                              Text(
                                localizations.alertNotification,
                                style: AppTextStyles(context)
                                    .display14W500
                                    .copyWith(
                                  color: controller.selectedIndex.value == 0
                                      ? AppColors.whiteOff
                                      : AppColors.grayLight,
                                ),
                              ),
                            ],
                          ).paddingOnly(left: 4),
                        )),
                        Obx(() => Tab(
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                controller.selectedIndex.value == 1
                                    ? AppColors.selextedindexcolor
                                    : AppColors.grayLighter,
                                child: SvgPicture.asset(
                                    'assets/images/svg/ic_megaphone.svg'),
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                "Announcements",
                                style: AppTextStyles(context)
                                    .display14W500
                                    .copyWith(
                                  color: controller.selectedIndex.value == 1
                                      ? AppColors.whiteOff
                                      : AppColors.grayLight,
                                ),
                              ),
                            ],
                          ).paddingAll(4),
                        )),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController, // Bind the TabController here
                    children: [AlertNotificationTab(), AnnouncementTab()],
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: 4.w * 0.9)
            ),
          ),
      ),
    );
  }
}


