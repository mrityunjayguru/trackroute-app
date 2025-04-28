import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/reports/controller/reports_controller.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_device_controller.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_route_controller.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../../config/app_sizer.dart';
import '../../../constants/project_urls.dart';
import '../../splash_screen/controller/data_controller.dart';

class ReportsView extends StatelessWidget {
  final String imei;

  ReportsView({super.key, required this.imei});

  final controller = Get.isRegistered<ReportsController>()
      ? Get.find<ReportsController>() // Find if already registered
      : Get.put(ReportsController());
  final dataController = Get.isRegistered<DataController>()
      ? Get.find<DataController>() // Find if already registered
      : Get.put(DataController());

  final trackController = Get.isRegistered<TrackRouteController>()
      ? Get.find<TrackRouteController>() // Find if already registered
      : Get.put(TrackRouteController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Obx(
            () => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                )).paddingOnly(left: 6, right: 8),
                        Text(
                          "Reports",
                          style: AppTextStyles(context).display20W500,
                        ).paddingOnly(right: 5),
                        Spacer(),
                        InkWell(
                            onTap: () {
                              Get.back();
                              final deviceController = Get.isRegistered<DeviceController>()
                                  ? Get.find<DeviceController>() // Find if already registered
                                  : Get.put(DeviceController());
                              deviceController.getDeviceByIMEI(zoom: true);
                            },
                            child: SvgPicture.asset(
                              "assets/images/svg/ic_arrow_left.svg",
                              width: 20,
                              height: 20,
                            )).paddingOnly(right: 6)
                      ],
                    ).paddingOnly(top: 12),
                    SizedBox(
                      height: 20,
                    ),
                    header(context),
                    selectReport(context).paddingOnly(bottom: 16),
                    if ((controller.selectedDate.value != null &&
                            !controller.openDay.value) ||
                        controller.selectedReport.value.isNotEmpty)
                      selectDay(context).paddingOnly(bottom: 16),
                    if (controller.selectedReport.value.isNotEmpty &&
                        controller.selectedDate.value != null)
                      downloadReport(context),
                  ],
                ),
              ),
              Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'The',
                      style: AppTextStyles(context)
                          .display13W500
                          .copyWith(color: AppColors.grayLight),
                    ),
                    TextSpan(
                      text: ' Consolidated Trip/Events Report',
                      style: AppTextStyles(context)
                          .display13W600
                          .copyWith(color: AppColors.grayLight),
                    ),
                    TextSpan(
                      text:
                          ' provides a detailed daily summary of vehicle activity. It includes key parameters such as geofence(entry/exit), ignition status (on/off), maximum and average speed, total distance traveled, duration of trips, motion time, and idle time.',
                      style: AppTextStyles(context)
                          .display13W500
                          .copyWith(color: AppColors.grayLight),
                    ),
                  ],
                ),
              ).paddingAll(16)
            ]).paddingAll(16),
          ),
        ),
      ),
    );
  }

  Widget selectDay(BuildContext context) {
    if (!controller.openDay.value && controller.selectedDate.value != null) {
      return InkWell(
        onTap: () {
          controller.openDay.value = !controller.openDay.value;
          controller.openReport.value = false;
        },
        child: Container(
          height: 6.h,
          width: context.width,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.radius_10),
              color: AppColors.selextedindexcolor),
          child: Center(
            child: Text(controller.selectedDate.value?.name ?? 'Today',
                style: AppTextStyles(context).display18W600),
          ),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radius_10),
          color: AppColors.color_f6f8fc),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              controller.openDay.value = !controller.openDay.value;
              controller.openReport.value = false;
            },
            child: Container(
              height: 6.h,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.radius_10),
                  color: AppColors.black),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Day',
                    style: AppTextStyles(context)
                        .display18W600
                        .copyWith(color: AppColors.selextedindexcolor),
                  ),
                  controller.openDay.value
                      ? SvgPicture.asset("assets/images/svg/ic_arrow_up.svg",
                          colorFilter: ColorFilter.mode(
                              AppColors.selextedindexcolor, BlendMode.srcIn))
                      : SvgPicture.asset(
                          "assets/images/svg/ic_arrow_down.svg",
                          colorFilter: ColorFilter.mode(
                              AppColors.selextedindexcolor, BlendMode.srcIn),
                        )
                ],
              ),
            ),
          ),
          if (controller.openDay.value) ...[
            checkBox(
                title: "Today",
                value: controller.selectedDate.value == DATE.today,
                onChanged: (value) {
                  if (value ?? false) {
                    controller.selectedDate.value = DATE.today;
                    controller.openDay.value = false;
                  }
                }),
            checkBox(
                title: "Yesterday",
                value: controller.selectedDate.value == DATE.yesterday,
                onChanged: (value) {
                  if (value ?? false) {
                    controller.selectedDate.value = DATE.yesterday;
                    controller.openDay.value = false;
                  }
                }),
            checkBox(
                title: "Last 7 Days",
                value: controller.selectedDate.value == DATE.last7Days,
                onChanged: (value) {
                  if (value ?? false) {
                    controller.selectedDate.value = DATE.last7Days;
                    controller.openDay.value = false;
                  }
                })
          ]
        ],
      ),
    );
  }

  Widget selectReport(BuildContext context) {
    if (!controller.openReport.value &&
        controller.selectedReport.value.isNotEmpty) {
      return InkWell(
        onTap: () {
          controller.openReport.value = !controller.openReport.value;
          controller.openDay.value = false;
        },
        child: Container(
          height: 6.h,
          width: context.width,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.radius_10),
              color: AppColors.selextedindexcolor),
          child: Center(
            child: Text(controller.selectedReport.value,
                style: AppTextStyles(context).display18W600),
          ),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radius_10),
          color: AppColors.color_f6f8fc),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              controller.openReport.value = !controller.openReport.value;
              controller.openDay.value = false;
            },
            child: Container(
              height: 6.h,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.radius_10),
                  color: AppColors.black),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Report',
                    style: AppTextStyles(context)
                        .display18W600
                        .copyWith(color: AppColors.selextedindexcolor),
                  ),
                  controller.openReport.value
                      ? SvgPicture.asset("assets/images/svg/ic_arrow_up.svg",
                          colorFilter: ColorFilter.mode(
                              AppColors.selextedindexcolor, BlendMode.srcIn))
                      : SvgPicture.asset(
                          "assets/images/svg/ic_arrow_down.svg",
                          colorFilter: ColorFilter.mode(
                              AppColors.selextedindexcolor, BlendMode.srcIn),
                        )
                ],
              ),
            ),
          ),
          if (controller.openReport.value)
            ListView.builder(
              shrinkWrap: true,
              itemCount: controller.reports.length,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) =>
                  radioButton(title: controller.reports[index]),
            )
        ],
      ),
    );
  }

  /* Widget selectVehicle(BuildContext context) {
    if (!controller.openVehicle.value &&
        controller.selectedVehicles.value.isNotEmpty) {
      return InkWell(
        onTap: () {
          controller.openVehicle.value = !controller.openVehicle.value;
          controller.openDay.value = false;
        },
        child: Container(
          height: 6.h,
          width: context.width,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.radius_10),
              color: AppColors.selextedindexcolor),
          child: Center(
            child: Text('Selected Vehicle(s)',
                style: AppTextStyles(context).display18W600),
          ),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radius_10),
          color: AppColors.color_f6f8fc),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              controller.openVehicle.value = !controller.openVehicle.value;
              controller.openDay.value = false;
            },
            child: Container(
              height: 6.h,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.radius_10),
                  color: AppColors.black),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Vehicle(s)',
                    style: AppTextStyles(context)
                        .display18W600
                        .copyWith(color: AppColors.selextedindexcolor),
                  ),
                  controller.openVehicle.value
                      ? SvgPicture.asset("assets/images/svg/ic_arrow_up.svg",
                      colorFilter: ColorFilter.mode(
                          AppColors.selextedindexcolor, BlendMode.srcIn))
                      : SvgPicture.asset(
                    "assets/images/svg/ic_arrow_down.svg",
                    colorFilter: ColorFilter.mode(
                        AppColors.selextedindexcolor, BlendMode.srcIn),
                  )
                ],
              ),
            ),
          ),
          if (controller.openVehicle.value)
            ListView.builder(
              shrinkWrap: true,
              itemCount: controller.vehicleData.value.length,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) => checkBox(
                  title: controller.vehicleData.value[index].vehicleNo ?? "",
                  value: index == 0
                      ? controller.selectedVehicles.value
                      .map(
                        (e) => e.vehicleNo,
                  )
                      .toList()
                      .contains("Select All Vehicles")
                      : controller.selectedVehicles.value
                      .map(
                        (e) => e.imei,
                  )
                      .toList()
                      .contains(controller.vehicleData.value[index].imei),
                  imei: controller.vehicleData.value[index].imei,
                  onChanged: (value) {
                    if (value ?? false) {
                      controller.addData(index);
                    } else {
                      controller.removeData(index);
                    }
                  }),
            )
        ],
      ),
    );
  }*/

  Widget downloadReport(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => controller.fetchData(imei),
          child: Container(
            height: 6.h,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.radius_10),
                color: AppColors.black),
            child: Center(
              child: Text(
                'Download Report',
                style: AppTextStyles(context)
                    .display18W600
                    .copyWith(color: AppColors.selextedindexcolor),
              ),
            ),
          ),
        ).paddingOnly(bottom: 16),
        if (controller.showDownloaded.value)
          Center(
            child: Text(
              'Your Consolidated Events Report has been downloaded successfully. You can now access and review your data.',
              style: AppTextStyles(context)
                  .display14W500
                  .copyWith(color: AppColors.color_239B41),
            ),
          ).paddingOnly(left: 16, right: 16),
      ],
    );
  }

  Widget header(BuildContext context) {
    return Container(
      width: context.width,
      padding: EdgeInsets.symmetric(vertical: 11, horizontal: 15),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.color_f6f8fc,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                maxRadius: 18,
                backgroundColor: AppColors.color_e5e7e9,
                child: Icon(
                  Icons.file_download_outlined,
                  color: Colors.black,
                ).paddingAll(5),
              ).paddingOnly(right: 6),
              Text(
                'Trip / Event Summary',
                style: AppTextStyles(context).display20W500,
              ),
            ],
          ),
          /*CircleAvatar(
            maxRadius: 37,
            backgroundColor: AppColors.selextedindexcolor,
            child: SvgPicture.asset("assets/images/svg/report_icon.svg")
                .paddingAll(15),
          ).paddingOnly(bottom: 10),*/
        ],
      ),
    );
  }

  Widget checkBox(
      {required String title,
      required bool value,
      required Function(bool?) onChanged,
      String? imei}) {
    return Builder(builder: (context) {
      return CheckboxListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          visualDensity: VisualDensity.compact,
          dense: true,
          controlAffinity: ListTileControlAffinity.leading,
          title: imei != null
              ? Text.rich(
                  TextSpan(children: [
                    TextSpan(
                        text: title,
                        style: AppTextStyles(context).display16W600),
                    TextSpan(
                        text: " IMEI: ${imei}",
                        style: AppTextStyles(context)
                            .display14W500
                            .copyWith(color: AppColors.grayLight)),
                  ]),
                  style: AppTextStyles(context).display16W600,
                )
              : Text(
                  title,
                  style: AppTextStyles(context).display16W600,
                ),
          value: value,
          activeColor: AppColors.selextedindexcolor,

          // fillColor: WidgetStatePropertyAll(Colors.white),
          side: BorderSide(color: AppColors.color_e5e7e9),
          onChanged: onChanged);
    });
  }

  Widget radioButton({required String title}) {
    return Builder(builder: (context) {
      return RadioListTile<String>(
        title: Text(
          title,
          style: AppTextStyles(context).display16W600,
        ),
        value: title,
        activeColor: AppColors.selextedindexcolor,
        visualDensity: VisualDensity.compact,
        dense: true,
        shape: CircleBorder(side: BorderSide(width: 0.5)),
        controlAffinity: ListTileControlAffinity.leading,
        groupValue: controller.selectedReport.value,
        onChanged: (value) {
          controller.selectedReport.value = value ?? "";

          if (controller.selectedReport.value.isNotEmpty) {
            controller.openReport.value = false;
            if (controller.selectedDate.value == null) {
              controller.openDay.value = true;
            }
          }
        },
      );
    });
  }
}
