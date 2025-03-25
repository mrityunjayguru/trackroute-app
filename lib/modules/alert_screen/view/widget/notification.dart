import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/app_sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/alert_screen/controller/alert_controller.dart';
import 'package:track_route_pro/modules/alert_screen/view/alerts_filter.dart';
import 'package:track_route_pro/modules/alert_screen/view/date_filter.dart';
import 'package:track_route_pro/utils/common_import.dart';
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
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: onRefresh,
          color: AppColors.selextedindexcolor,
          child: Column(
            children: [
              filter(localizations, context),
              /*vehicalSelection(localizations, context),
              SizedBox(
                height: 1.5.h,
              ),
              alertsSelection(localizations, context),*/
              SizedBox(
                height: 1.5.h,
              ),
              Expanded(
                child: Obx(
                  () => alertController.alerts.length > 0
                      ? ListView.builder(
                          controller: alertController.scrollController,
                          itemCount: alertController.alerts.length,
                          itemBuilder: (context, index) => notificationAlert(
                              context: context,
                              data: alertController.alerts[index]),
                        )
                      : Center(
                          child: Text(
                          "No Alerts Found!",
                          style: AppTextStyles(context).display18W500,
                        )),
                ),
              )
            ],
          ),
        ),
        Obx(() {
          if (alertController.showLoader.value)
            return Positioned.fill(
                child: Container(
              alignment: Alignment.center,
              color: Colors.grey.withOpacity(0.3),
              child: LoadingAnimationWidget.threeArchedCircle(
                color: AppColors.selextedindexcolor,
                size: 50,
              ),
            ));
          return SizedBox.shrink();
        })
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
          .format(DateTime.parse(data.createdAt ?? ""));
      time = DateFormat("HH:mm")
          .format(DateTime.parse(data.createdAt ?? ""));
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
        String address =
            "Fetching Address...";
        if (snapshot.connectionState ==
            ConnectionState.done) {
          if (snapshot.hasError) {
            address =
            "Error Fetching Address";
          } else {
            address = snapshot.data ??
                "Address Unavailable";
          }
        }
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

  Widget filter(localizations, BuildContext context) {
    return Container(
      width: context.width,
      constraints: BoxConstraints(maxHeight: 100),
      child: Obx(()=>
         Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      alertController.checkFilter();
                      Get.to(() => AlertsFilterPage(),
                          transition: Transition.upToDown,
                          duration: const Duration(milliseconds: 300));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(AppSizes.radius_50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/images/svg/filter_icon.svg'),
                          Text(
                            "Filter",
                            style: AppTextStyles(context)
                                .display13W500
                                .copyWith(color: AppColors.selextedindexcolor),
                          ).paddingOnly(left: 5)
                        ],
                      ).paddingSymmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      alertController.checkFilter();
                      Get.to(() => DateFilterPage(),
                          transition: Transition.upToDown,
                          duration: const Duration(milliseconds: 300));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.selextedindexcolor,
                        borderRadius: BorderRadius.circular(AppSizes.radius_50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                              'assets/images/svg/date_time_icon.svg'),
                          Text(
                            "Date & Time",
                            style: AppTextStyles(context)
                                .display13W500
                                .copyWith(color: AppColors.black),
                          ).paddingOnly(left: 5)
                        ],
                      ).paddingSymmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
            if (alertController.selectedDate.value ||
                alertController.selectedAlerts.value)
              SizedBox(
                height: 10,
              ),
            if (alertController.selectedDate.value ||
                alertController.selectedAlerts.value)Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppSizes.radius_50),
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            "Alert Count : ",
                            style: AppTextStyles(context)
                                .display13W500
                                .copyWith(color: AppColors.grayLight),
                          ).paddingOnly(left: 5),
                        ),
                        Flexible(
                            child: Text(
                          alertController.totalCount.value,
                          style: AppTextStyles(context)
                              .display13W500
                              .copyWith(color: AppColors.grayLight),
                        ))
                      ],
                    ).paddingSymmetric(horizontal: 20, vertical: 10),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    alertController.clearAlertsFilter();
                    alertController.getAlerts(isLoadMore: false, jump: true);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.grayLighter,
                      borderRadius: BorderRadius.circular(AppSizes.radius_50),
                    ),
                    child: Text(
                      "Reset",
                      style: AppTextStyles(context)
                          .display13W500
                          .copyWith(color: AppColors.purpleColor),
                    ).paddingSymmetric(horizontal: 20, vertical: 10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

/*
  Widget vehicalSelection(
      AppLocalizations localizations, BuildContext context) {
    return Obx(() {
      int itemCount = (controller.vehicleList.value.data?.length ?? 0);
      return Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onTap: () {
              alertController.isExpanded.value =
                  !alertController.isExpanded.value;
              alertController.closeExpandedAlerts();
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
                ? Container(
                    constraints: BoxConstraints(maxHeight: 400.h),
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
                                  "",
                                  -1,
                                );
                              },
                              child: Container(
                                width: double.maxFinite,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: alertController
                                              .selectedVehicleIndex.value ==
                                          -1
                                      ? AppColors.selextedindexcolor
                                      : AppColors.whiteOff,
                                ),
                                child: Text(
                                  'All',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles(context)
                                      .display16W700
                                      .copyWith(
                                        color: alertController
                                                    .selectedVehicleIndex
                                                    .value ==
                                                -1
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
                                              .selectedVehicleIndex.value),controller.vehicleList.value.data?[index]
                                      .vehicleNo ??
                                      "",
                                      controller.vehicleList.value.data?[index]
                                              .imei ??
                                          "",
                                      index);
                                },
                                child: Container(
                                  width: double.maxFinite,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color:
                                        alertController.selectedVehicleIndex ==
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
  }*/
/*
  Widget alertsSelection(AppLocalizations localizations, BuildContext context) {
    return Obx(() {
      int itemCount = (alertController.alertsList.length);
      */ /*
      double height = 0;
      height = itemCount * 60;
      if (height > 500) {
        height = 500;
      }*/ /*
      return Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onTap: () {
              alertController.isExpandedAlerts.value =
                  !alertController.isExpandedAlerts.value;
              alertController.closeExpanded();
            },
            child: Container(
              height: 4.8.h,
              decoration: BoxDecoration(
                  color: AppColors.whiteOff,
                  borderRadius: BorderRadius.circular(AppSizes.radius_50)),
              child: Row(
                children: [
                  SvgPicture.asset('assets/images/svg/alerts_filter.svg')
                      .paddingOnly(right: 10, left: 10),
                  Text(
                    alertController.alertSelected.value
                        ? alertController.selectedAlertName.value
                        : "Select Alert Type",
                    style: AppTextStyles(context)
                        .display16W400
                        .copyWith(color: AppColors.grayLight),
                  ),
                  Spacer(),
                  SvgPicture.asset(
                    alertController.isExpandedAlerts.value
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
            child: alertController.isExpandedAlerts.value
                ? Container(
                    constraints: BoxConstraints(maxHeight: 400.h),
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
                                alertController.filterByAlertType(
                                  false,
                                  "",
                                  -1,
                                );
                              },
                              child: Container(
                                width: double.maxFinite,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: alertController
                                              .selectedAlertIndex.value ==
                                          -1
                                      ? AppColors.selextedindexcolor
                                      : AppColors.whiteOff,
                                ),
                                child: Text(
                                  'All',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles(context)
                                      .display16W700
                                      .copyWith(
                                        color: alertController
                                                    .selectedAlertIndex.value ==
                                                -1
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
                                  alertController.filterByAlertType(
                                      !(index ==
                                          alertController
                                              .selectedAlertIndex.value),
                                      alertController.alertsList[index],
                                      index);
                                },
                                child: Container(
                                  width: double.maxFinite,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: alertController.selectedAlertIndex ==
                                            index
                                        ? AppColors.selextedindexcolor
                                        : AppColors.whiteOff,
                                  ),
                                  child: Text(
                                    '${alertController.alertsList[index]}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles(context)
                                        .display16W700
                                        .copyWith(
                                          color: alertController
                                                      .selectedAlertIndex ==
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
  }*/

  Future<void> onRefresh() async {
    await alertController.getAlerts(isLoadMore: false);
  }
}
