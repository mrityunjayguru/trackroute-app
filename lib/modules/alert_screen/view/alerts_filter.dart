import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/app_sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/utils/common_import.dart';
import '../../../utils/utils.dart';
import '../../track_route_screen/controller/track_route_controller.dart';
import '../controller/alert_controller.dart';

class AlertsFilterPage extends StatelessWidget {
  AlertsFilterPage({super.key});

  final controller = Get.isRegistered<AlertController>()
      ? Get.find<AlertController>() // Find if already registered
      : Get.put(AlertController());

  final trackController = Get.isRegistered<TrackRouteController>()
      ? Get.find<TrackRouteController>() // Find if already registered
      : Get.put(TrackRouteController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.white,
          body: Obx(()=>
             Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Utils().topBar(
                    context: context,
                    rightIcon: 'assets/images/svg/ic_arrow_left.svg',
                    onTap: () {
                      Get.back();
                    },
                    name: "Filter"),
                SizedBox(
                  height: 1.5.h,
                ),
                Text(
                  'Select Alerts',
                  style: AppTextStyles(context).display20W500,
                ),
                SizedBox(height: 2.h),
                StaggeredGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: controller.alertsList
                      .map((item) => StaggeredGridTile.fit(
                            crossAxisCellCount: 1,
                            child: alertItem(
                              controller.checkIfAlertSelected(item),
                              item,
                              context,
                              () => controller.addAlert(item),
                            ),
                          ))
                      .toList(),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Select Vehicle',
                  style: AppTextStyles(context).display20W500,
                ),
                SizedBox(height: 2.h),
                StaggeredGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: (trackController.vehicleList.value.data ?? [])
                      .map((item) => StaggeredGridTile.fit(
                            crossAxisCellCount: 1,
                            child: alertItem(
                                controller
                                    .checkIfVehicleSelected(item.imei ?? ""),
                                item.vehicleNo ?? "",
                                context,
                                () => controller.addVehicle(item.imei ?? ""),),
                          ))
                      .toList(),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                          if(controller.selectedAlertName.isNotEmpty || controller.selectedVehicleIMEI.isNotEmpty){
                            controller.selectedAlerts.value = true;
                          }
                          controller.getAlerts(isLoadMore: false, jump: true);
                        },
                        child: Container(
                          height: 6.h,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppSizes.radius_50),
                            color: AppColors.black,
                          ),
                          child: Center(
                            child: Text(
                              'Apply Filter',
                              style: AppTextStyles(context)
                                  .display18W400
                                  .copyWith(color: AppColors.selextedindexcolor),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ).paddingOnly(top: 12).paddingSymmetric(horizontal: 4.w * 0.9),
          ),
        ),
      ),
    );
  }

  Widget alertItem(
      bool isSelected, String label, BuildContext context, VoidCallback onTap,) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: AppColors.color_f6f8fc,
            borderRadius: BorderRadius.circular(AppSizes.radius_10),
            border: Border.all(color: AppColors.color_e5e7e9)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset((isSelected)
                    ? "assets/images/svg/blue_check_icon.svg"
                    : "assets/images/svg/grey_check_icon.svg")
                .paddingOnly(right: 5.w),
            Expanded(
              flex: 3,
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                // Display the vehicle number
                style: AppTextStyles(context).display14W600,
              ),
            ),
            SizedBox(
              width: 1.w,
            ),
          ],
        ),
      ),
    );
  }
}
