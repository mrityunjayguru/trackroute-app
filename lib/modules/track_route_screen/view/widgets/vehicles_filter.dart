import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/app_sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_route_controller.dart';
import 'package:track_route_pro/modules/track_route_screen/view/widgets/vehicle_dialog.dart';
import 'package:track_route_pro/service/model/presentation/track_route/track_route_vehicle_list.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../../../constants/project_urls.dart';
import '../../../../utils/utils.dart';
import '../../../splash_screen/controller/data_controller.dart';

class VehiclesList extends StatelessWidget {
  VehiclesList({super.key});

  final controller = Get.isRegistered<TrackRouteController>()
      ? Get.find<TrackRouteController>() // Find if already registered
      : Get.put(TrackRouteController());

  var scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final localizations = getAppLocalizations(context)!;

    return SafeArea(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.radius_50),
                  topRight: Radius.circular(AppSizes.radius_50),
                  bottomRight: Radius.circular(AppSizes.radius_16),
                  bottomLeft: Radius.circular(AppSizes.radius_16)),
              color: AppColors.whiteOff,
            ),
            child: Column(
              children: [
                Obx(
                  () => Utils().topBar(
                      context: context,
                      rightIcon: !controller.isExpanded.value
                          ? Assets.images.svg.icArrowDown
                          : 'assets/images/svg/ic_arrow_up.svg',
                      onTap: () {
                        controller.isExpanded.value =
                            !controller.isExpanded.value;
                        controller.isShowvehicleDetail.value = false;
                        controller.selectedVehicleIMEI.value = "";
                      },
                      name: localizations.selectVehicle),
                ),
                Obx(
                  () {
                    int itemCount =
                        controller.vehicleList.value.data?.length ?? 0;
                    double? height = null;
                    if (itemCount > 8) {
                      height = 500;
                    }
                    return AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: controller.isExpanded.value
                          ? Container(
                              height: height,
                              child: Scrollbar(
                                thumbVisibility: true,
                                controller: scrollController,
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListView.separated(
                                      physics: const ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: itemCount,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        bool isInactive =
                                            controller.checkIfInactive(
                                                vehicle: controller.vehicleList
                                                    .value.data?[index]);
                                        return GestureDetector(
                                          behavior:
                                              HitTestBehavior.deferToChild,
                                          onTap: () {
                                            controller.isShowVehicleDetails(
                                                index,
                                                controller.vehicleList.value
                                                        .data?[index].imei ??
                                                    '');
                                            controller.devicesByDetails(
                                                controller.vehicleList.value
                                                        .data?[index].imei ??
                                                    '',
                                                showDialog: true,
                                                zoom: true);
                                            controller.isExpanded.value = false;
                                            controller.isFilterSelected.value =
                                                false;
                                            controller.isFilterSelectedindex
                                                .value = -1;
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Vehicle',
                                                  style: AppTextStyles(context)
                                                      .display12W400
                                                      .copyWith(
                                                          color: AppColors
                                                              .grayLight),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        '${controller.vehicleList.value.data?[index].vehicleNo ?? "-"}',
                                                        style: AppTextStyles(
                                                                context)
                                                            .display16W700
                                                            .copyWith(
                                                                color: isInactive
                                                                    ? AppColors
                                                                        .grayLight
                                                                    : AppColors
                                                                        .black),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    GestureDetector(
                                                      behavior: HitTestBehavior
                                                          .deferToChild,
                                                      onTap: () {
                                                        if (isInactive) {
                                                          controller.isShowVehicleDetails(
                                                              index,
                                                              controller
                                                                      .vehicleList
                                                                      .value
                                                                      .data?[
                                                                          index]
                                                                      .imei ??
                                                                  '');
                                                          controller.devicesByDetails(
                                                              controller
                                                                      .vehicleList
                                                                      .value
                                                                      .data?[
                                                                          index]
                                                                      .imei ??
                                                                  '',
                                                              showDialog: true,
                                                              zoom: true);
                                                          controller.isExpanded
                                                              .value = false;
                                                          controller
                                                              .isFilterSelected
                                                              .value = false;
                                                          controller
                                                              .isFilterSelectedindex
                                                              .value = -1;
                                                        } else {
                                                          controller
                                                              .isvehicleSelected
                                                              .value = true;
                                                          controller.isedit
                                                              .value = false;
                                                          controller.stackIndex
                                                              .value = 1;
                                                          controller
                                                              .editGeofence
                                                              .value = false;
                                                          controller.editSpeed
                                                              .value = false;
                                                          controller.isExpanded
                                                              .value = false;
                                                          controller.devicesByDetails(
                                                              controller
                                                                      .vehicleList
                                                                      .value
                                                                      .data?[
                                                                          index]
                                                                      .imei ??
                                                                  '');
                                                        }
                                                      },
                                                      child: Text(
                                                        'Manage',
                                                        style: AppTextStyles(
                                                                context)
                                                            .display12W500
                                                            .copyWith(
                                                                color: isInactive
                                                                    ? AppColors
                                                                        .grayLight
                                                                    : AppColors
                                                                        .blue),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      separatorBuilder: (BuildContext context,
                                              int index) =>
                                          Divider(color: AppColors.grayLighter),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    );
                  },
                ),
              ],
            ),
          ).paddingOnly(top: 12),
          Obx(
            () => controller.isExpanded.value
                ? SizedBox.shrink()
                : Column(
                    children: [
                      SizedBox(height: 1.h),
                      Obx(
                        () => SizedBox(
                          height: 4.h,
                          child: Row(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.filterData.length,
                                  itemBuilder: (context, index) => InkWell(
                                    onTap: () async {
                                      controller
                                          .isFilterSelected.value = index ==
                                              controller
                                                  .isFilterSelectedindex.value
                                          ? !controller.isFilterSelected.value
                                          : true;
                                      controller.isFilterSelectedindex.value =
                                          controller.isFilterSelected.value
                                              ? index
                                              : -1; // Update the index here
                                      controller.update();
                                      controller.markers.value = [];
                                      controller.isShowvehicleDetail.value =
                                          false;
                                      controller.selectedVehicleIndex.value =
                                          -1;
                                      controller.selectedVehicleIMEI.value = "";
                                      controller.checkFilterIndex(true);
                                    },
                                    child: Obx(
                                      () => Utils().filterOption(
                                        isSelected: controller
                                                .isFilterSelectedindex.value ==
                                            index,
                                        // Check index here
                                        context: context,
                                        img: controller.filterData[index].image,
                                        title:
                                            controller.filterData[index].title,
                                        count:
                                            controller.filterData[index].count,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          )
        ],
      ).paddingSymmetric(horizontal: 4.w * 0.9),
    );
  }
}
