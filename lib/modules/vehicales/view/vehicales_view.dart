import 'package:sizer/sizer.dart';
import 'package:track_route_pro/common/textfield/search_textfield.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/modules/bottom_screen/controller/bottom_bar_controller.dart';
import 'package:track_route_pro/modules/vehicales/controller/vehicales_controller.dart';
import 'package:track_route_pro/modules/vehicales/view/widget/vehical_detail_card.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../../utils/utils.dart';

class VehicalesView extends StatefulWidget {
  VehicalesView({super.key});

  @override
  State<VehicalesView> createState() => _VehicalesViewState();
}

class _VehicalesViewState extends State<VehicalesView> {
  final controller = Get.put(VehicalesController());

  void initState() {
    super.initState();
 /*   WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      controller.loadUser().then((_) {
        controller.devicesByOwnerID();
      });*/
   /*   controller.searchController.addListener(() {
        controller.filterVehicles(
            controller.searchController.text); // Listen for search changes
      });*/
    /*  setState(() {});
    });*/
  }

  @override
  Widget build(BuildContext context) {
    final localizations = getAppLocalizations(context)!;
    return Container(
      color: AppColors.backgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            Utils()
                .topBar(
                    context: context,
                    rightIcon: '',
                    onTap: () {},
                    name: "Vehicles",
                    rightWidget: Obx(() => Text(
                          'Total ${controller.vehicleList.value.data?.length ?? 0}',
                          style: AppTextStyles(context)
                              .display14W500
                              .copyWith(color: AppColors.selextedindexcolor),
                        )).paddingOnly(right: 10))
                .paddingOnly(top: 12),
            SizedBox(height: 1.h),

            Obx(
              () {
                return SizedBox(
                  height: 4.h,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.filterData.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        controller.SelectedFilterIndex.value = index;
                        controller
                            .isFilterSelected.value = index ==
                            controller
                                .SelectedFilterIndex.value
                            ? !controller.isFilterSelected.value
                            : true;
                        controller.SelectedFilterIndex.value =
                        controller.isFilterSelected.value
                            ? index
                            : -1; // Update the index here
                        controller.updateFilteredList();
                        setState(() {});
                      },
                      child: Utils().filterOption(
                        isSelected:
                            controller.SelectedFilterIndex.value == index,
                        context: context,
                        img: controller.filterData[index].image,
                        title: controller.filterData[index].title,
                        count: controller.filterData[index].count,
                      ),
                    ),
                  ),
                );
              },
            ),

            // Search text field
            searchApptextfield(
              color: AppColors.whiteOff,
              prefixIcon: 'assets/images/svg/search.svg',
              hintText: 'Search Vehicle',
              controller: controller.searchController,
              onChanged: (query) =>
                  controller.updateFilteredList(), // Enable search filtering
            ),

            SizedBox(height: 2.h),

            // Vehicle list with search functionality
            Expanded(
              child: Obx(() {
                final filteredVehicles = controller.filteredVehicleList;

                if (filteredVehicles.isEmpty) {
                  return Center(child: Text("No vehicles found"));
                }

                return ListView.builder(
                  itemCount: filteredVehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = filteredVehicles[index];
                    final bottomController = Get.isRegistered<
                            BottomBarController>()
                        ? Get.find<
                            BottomBarController>() // Find if already registered
                        : Get.put(BottomBarController());
                    return InkWell(
                      onTap: () {
                        bottomController.updateIndex(2);
                        controller.trackRouteController
                            .devicesByDetails(vehicle.imei ?? '',showDialog: true, zoom: true);
                        controller.trackRouteController
                            .isShowVehicleDetails(index, vehicle.imei ?? "");

                      },
                      child: VehicalDetailCard(
                        vehicleInfo: vehicle,
                      ).paddingOnly(bottom: 1.5.h),
                    );
                  },
                );
              }),
            ),
          ],
        ).paddingSymmetric(horizontal: 4.w * 0.9),
      ),
    );
  }
}
