import 'dart:developer';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/app_sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/alert_screen/controller/alert_controller.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../../../service/model/AlertDataModel.dart';
import '../../../../service/model/alerts/alert/AlertsResponse.dart';
import '../../../track_route_screen/controller/track_route_controller.dart';

class AlertNotificationTab extends StatelessWidget {
  AlertNotificationTab({super.key});

  final controller = Get.isRegistered<TrackRouteController>()
      ? Get.find<TrackRouteController>() // Find if already registered
      : Get.put(TrackRouteController());
  final alertController = Get.find<AlertController>();
  var scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final localizations = getAppLocalizations(context)!;

    return Column(
      children: [
        vehicalSelection(localizations, context),
        SizedBox(
          height: 1.5.h,
        ),
        Expanded(
          child: Obx(
            () => ListView.builder(
              itemCount: alertController.alerts.length,
              itemBuilder: (context, index) => notificationAlert(
                  context: context, data: alertController.alerts[index]),
            ),
          ),
        )
      ],
    );
  }

  Widget notificationAlert({
    required BuildContext context,
    required AlertsResponse data,
  }) {
    String date = 'Update unavailable';
    String time = '';
    // Color color = data.color ?? Colors.grey;

    if (data.createdAt?.isNotEmpty ?? false) {
      date = DateFormat("dd MMM yyyy")
          .format(DateTime.parse(data.createdAt ?? "").toLocal());
      time = DateFormat("hh:mm")
          .format(DateTime.parse(data.createdAt ?? "").toLocal());
    }

    Future<String> getAddress() async {
      if (data.location?.latitude != null && data.location?.longitude != null) {
        return await alertController.getAddressFromLatLong(
          data.location!.latitude!,
          data.location!.longitude!,
        );
      }
      return "Address unavailable";
    }

    return FutureBuilder<String>(
      future: getAddress(), // Fetch the address asynchronously
      builder: (context, snapshot) {
        String address = snapshot.data ?? 'Loading...';
        // Color color;
        // if (data.urgency != null && data.urgency!.isNotEmpty) {
        //   color = Color(int.parse(data.urgency!.replaceFirst('#', '0xFF')));
        // } else {
        //   color = Colors.grey; // Default color if `urgency` is not provided
        // }
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.radius_15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                  ).paddingOnly(right: 2.w),
                  Flexible(
                    child: Text(
                      "${data.notificationalert?.notification?.title ?? " "} :",
                      style: AppTextStyles(context).display14W700,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ).paddingOnly(right: 6),
                  ),
                  Text(
                    data.deviceDetails?.vehicleNo ?? "",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: AppTextStyles(context).display14W400,
                  ),
                ],
              ).paddingOnly(left: 1.4.w, top: 1.w, bottom: 1.5.w),
              Text(
                data.notificationalert?.notification?.body ?? "",
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: AppTextStyles(context).display14W400,
              ).paddingOnly(left: 1.4.w, top: 1.w, bottom: 1.5.w),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.grayBright,
                  borderRadius: BorderRadius.circular(AppSizes.radius_50),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/images/svg/ic_location.svg'),
                    Flexible(
                      child: Text(
                        address,
                        style: AppTextStyles(context).display13W500,
                      ).paddingOnly(left: 5),
                    )
                  ],
                ).paddingOnly(left: 6, bottom: 7, top: 7),
              ),
              Text(
                '$date at $time',
                style: AppTextStyles(context)
                    .display14W400
                    .copyWith(color: AppColors.grayLight),
              ).paddingOnly(
                left: 6.7.w,
                top: 1.w,
              ),
            ],
          ).paddingAll(0.8.h),
        ).paddingOnly(bottom: 12);
      },
    );
  }

  Widget vehicalSelection(
      AppLocalizations localizations, BuildContext context) {
    return Obx(() {
      int itemCount = (controller.vehicleList.value.data?.length ?? 0);
      double height = 0;
      height = itemCount * 60;
      if (height > 500) {
        height = 500;
      }
      return Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onTap: () {
              alertController.isExpanded.value =
                  !alertController.isExpanded.value;
            },
            child: Container(
              height: 4.8.h,
              decoration: BoxDecoration(
                  color: AppColors.whiteOff,
                  borderRadius: BorderRadius.circular(AppSizes.radius_50)),
              child: Row(
                children: [
                  SvgPicture.asset('assets/images/svg/ic_racing.svg')
                      .paddingOnly(right: 10, left: 10),
                  Text(
                    alertController.vehicleSelected.value
                        ? alertController.selectedVehicleName.value
                        : localizations.selectVehicle,
                    style: AppTextStyles(context)
                        .display16W400
                        .copyWith(color: AppColors.grayLight),
                  ),
                  Spacer(),
                  SvgPicture.asset(
                    alertController.isExpanded.value
                        ? "assets/images/svg/ic_arrow_up.svg"
                        : Assets.images.svg.icArrowDown,
                    color: AppColors.grayLight,
                  ).paddingOnly(right: 14, left: 10),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: alertController.isExpanded.value
                ? SizedBox(
                    height: height,
                    child: Scrollbar(
                      thumbVisibility: true,
                      controller: scrollController,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.deferToChild,
                              onTap: () {
                                alertController.filterAlerts(
                                  false,
                                  "",
                                  -1,
                                );
                              },
                              child: Container(
                                width: double.maxFinite,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: alertController.selectedVehicleIndex.value == -1
                                      ? AppColors.selextedindexcolor
                                      : AppColors.whiteOff,
                                ),
                                child: Text(
                                  'All',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles(context).display16W700.copyWith(
                                    color: alertController.selectedVehicleIndex.value == -1
                                        ? AppColors.whiteOff
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                            // Now add the rest of the vehicle list items
                            ...List.generate(
                              itemCount,
                                  (index) => GestureDetector(
                                behavior: HitTestBehavior.deferToChild,
                                onTap: () {
                                  alertController.filterAlerts(
                                      !(index ==
                                          alertController
                                              .selectedVehicleIndex.value),
                                      controller.vehicleList.value.data?[index]
                                          .vehicleNo ??
                                          "",
                                      index);
                                },
                                child: Container(
                                  width: double.maxFinite,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: alertController.selectedVehicleIndex ==
                                        index
                                        ? AppColors.selextedindexcolor
                                        : AppColors.whiteOff,
                                  ),
                                  child: Text(
                                    '${controller.vehicleList.value.data?[index].vehicleNo}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles(context)
                                        .display16W700
                                        .copyWith(
                                      color: alertController
                                          .selectedVehicleIndex ==
                                          index
                                          ? AppColors.whiteOff
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )).paddingSymmetric(horizontal: 10)
                : SizedBox.shrink(),
          ),
        ],
      );
    });
  }
}
