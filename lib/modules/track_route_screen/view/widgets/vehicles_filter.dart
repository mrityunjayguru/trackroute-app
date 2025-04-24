import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/app_sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_route_controller.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../../../common/textfield/search_textfield.dart';
import '../../../../utils/utils.dart';

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
          Obx(
            () => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppSizes.radius_50),
                    topRight: Radius.circular(AppSizes.radius_50),
                    bottomRight: controller.isExpanded.value
                        ? Radius.circular(AppSizes.radius_16)
                        : Radius.circular(AppSizes.radius_50),
                    bottomLeft: controller.isExpanded.value
                        ? Radius.circular(AppSizes.radius_16)
                        : Radius.circular(AppSizes.radius_50)),
                color: AppColors.whiteOff,
              ),
              child: Column(
                children: [
                  Utils().topBar(
                      context: context,
                      rightIcon: !controller.isExpanded.value
                          ? Assets.images.svg.icArrowDown
                          : 'assets/images/svg/ic_arrow_up.svg',
                      onTap: () {
                        controller.isExpanded.value =
                            !controller.isExpanded.value;
                        controller.filteredVehicleList.value =
                            controller.vehicleList.value.data ?? [];
                        controller.searchController.clear();
                      },
                      name: localizations.selectVehicle),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: controller.isExpanded.value
                        ? Container(
                            constraints: BoxConstraints(maxHeight: 500),
                            child: Scrollbar(
                              thumbVisibility: true,
                              controller: scrollController,
                              child: SingleChildScrollView(
                                controller: scrollController,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Column(
                                    children: [
                                      searchApptextfield(
                                        color: AppColors.selextedindexcolor,

                                        prefixIcon:
                                            'assets/images/svg/search.svg',
                                        hintText: 'Search Vehicle',
                                        controller: controller.searchController,
                                        onChanged: (query) => controller
                                            .updateFilteredList(), // Enable search filtering
                                      ).paddingOnly(bottom: 8),
                                      ListView.separated(
                                        physics: const ClampingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: controller
                                            .filteredVehicleList.value.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final vehicle = controller
                                              .filteredVehicleList.value[index];

                                          // Hide items not in filteredVehicleList
                                          bool isInactive =
                                              controller.checkIfInactive(
                                                  vehicle: vehicle);
                                          return InkWell(
                                            onTap: () {
                                              controller.removeFilter();
                                              controller.isShowVehicleDetails(vehicle.imei ?? "");

                                              controller.searchController
                                                  .clear();
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Vehicle',
                                                            style: AppTextStyles(
                                                                    context)
                                                                .display12W400
                                                                .copyWith(
                                                                    color: AppColors
                                                                        .grayLight),
                                                          ),
                                                          Text(
                                                            '${vehicle.vehicleNo ?? "-"}',
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
                                                        ],
                                                      ).paddingSymmetric(
                                                          vertical: 4),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  InkWell(
                                                    onTap: () {
                                                      /// if inactive then show the vehicle details or else go to manage screen
                                                      controller.removeFilter();
                                                      if (isInactive) {
                                                        controller
                                                            .isShowVehicleDetails(vehicle.imei ?? "");
                                                      } else {
                                                        controller.showEditView();
                                                      }
                                                      controller
                                                          .searchController
                                                          .clear();
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
                                                    ).paddingSymmetric(
                                                        vertical: 4),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        separatorBuilder: (BuildContext context,
                                                int index) =>
                                            Divider(
                                                color: AppColors.grayLighter),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ).paddingOnly(top: 12),
          ),
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
