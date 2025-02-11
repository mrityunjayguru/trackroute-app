import 'dart:developer';

import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/app_sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/profile/controller/profile_controller.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../../../constants/project_urls.dart';
import '../../../../service/model/presentation/track_route/track_route_vehicle_list.dart';
import '../../../../utils/utils.dart';
import '../../../splash_screen/controller/data_controller.dart';

class ReNewSubscription extends StatefulWidget {
  ReNewSubscription({super.key});

  @override
  State<ReNewSubscription> createState() => _ReNewSubscriptionState();
}

class _ReNewSubscriptionState extends State<ReNewSubscription> {
  final controller = Get.isRegistered<ProfileController>()
      ? Get.find<ProfileController>() // Find if already registered
      : Get.put(ProfileController());

  final dataController = Get.isRegistered<DataController>()
      ? Get.find<DataController>() // Find if already registered
      : Get.put(DataController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      child: SafeArea(
        child: Obx(
          () => Column(
            children: [
              Utils()
                  .topBar(
                      context: context,
                      rightIcon: 'assets/images/svg/ic_arrow_left.svg',
                      onTap: () {
                        controller.isReNewSub.value = false;
                        controller.selectedVehicleIndex.value = {};
                      },
                      name: 'Renew Subscription')
                  .paddingSymmetric(vertical: 16),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff00000026).withOpacity(0.15),
                      blurRadius: 2,
                      spreadRadius: 0,
                      offset: Offset(0, 2),
                    )
                  ],
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSizes.radius_15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Username',
                      style: AppTextStyles(context)
                          .display12W400
                          .copyWith(color: AppColors.grayLight),
                    ),
                    Text(
                      '${controller.name ?? ''}',
                      style: AppTextStyles(context).display14W600,
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    if (controller.expiringVehicles.isEmpty)
                      Container(
                        width: context.width,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppSizes.radius_50),
                          color: AppColors.selextedindexcolor,
                        ),
                        child: Center(
                          child: Text(
                            'There are no devices currently due for renewal.',
                            style: AppTextStyles(context)
                                .display14W400
                                .copyWith(color: AppColors.black),
                          ).paddingSymmetric(horizontal: 3.w, vertical: 1.h),
                        ),
                      )
                    else
                      Text('Device(s) Due for Renewal',
                          style: AppTextStyles(context).display20W500),
                    SizedBox(
                      height: 1.3.h,
                    ),
                    Container(
                      constraints: BoxConstraints(maxHeight: 40.h),
                      /* height: controller.expiringVehicles.length < 10
                          ? controller.expiringVehicles.length * (6.h)
                          : 50.h,*/
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.expiringVehicles.length,
                        itemBuilder: (context, index) {

                          Data vehicle = controller.expiringVehicles[index];
                          bool isSelected = controller
                              .selectedVehicleIndex.value
                              .contains(index);
                          bool isApplied = ((vehicle.isApplied ?? 50) < 48.01) ?? false;
                          return InkWell(
                            onTap: () {
                              setState(() {
                                controller.toggleVehicleSelection(index);
                              });

                            },
                            child: Container(
                              padding:isApplied ? EdgeInsets.fromLTRB(16,0,16,10) :  EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  color: AppColors.color_f6f8fc,
                                  borderRadius:
                                      BorderRadius.circular(AppSizes.radius_10),
                                  border: Border.all(
                                      color: AppColors.color_e5e7e9)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if(isApplied)Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(AppSizes.radius_4),
                                            bottomLeft: Radius.circular(AppSizes.radius_4)),
                                        color: AppColors.blue,
                                      ),
                                      child: Text("Applied", style : AppTextStyles(context)
                                          .display11W400
                                          .copyWith(color: AppColors.white),),
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset((isApplied && isSelected) ? "assets/images/svg/blue_check_icon.svg":(isSelected
                                              ? "assets/images/svg/green_check.svg"
                                              : "assets/images/svg/grey_check_icon.svg"))
                                          .paddingOnly(right: 5.w),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Vehicle No.",
                                              overflow: TextOverflow.ellipsis,
                                              // Display the vehicle number
                                              style: AppTextStyles(context)
                                                  .display10W500
                                                  .copyWith(
                                                      color:
                                                          AppColors.grayLight),
                                            ),
                                            Text(
                                              vehicle.vehicleNo ?? '-',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              // Display the vehicle number
                                              style: AppTextStyles(context)
                                                  .display14W600,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 1.w,
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "IMEI",
                                              overflow: TextOverflow.ellipsis,
                                              // Display the vehicle number
                                              style: AppTextStyles(context)
                                                  .display10W500
                                                  .copyWith(
                                                      color:
                                                          AppColors.grayLight),
                                            ),
                                            Text(
                                              vehicle.imei ?? '-',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              // Display the vehicle number
                                              style: AppTextStyles(context)
                                                  .display14W600,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Expiry Date ${DateFormat("dd MMM y").format(DateTime.parse(vehicle.subscriptionExp ?? DateFormat("dd-MM-yyyy").format(DateTime.now()))) ?? 'Unknown'}',
                                    // Display the expiration date
                                    style: AppTextStyles(context)
                                        .display11W400
                                        .copyWith(color: AppColors.grayLight),
                                  ).paddingOnly(
                                      top: isApplied ? 0 : 4, bottom: 4, left: 25 + 5.w),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    InkWell(
                      onTap: () {
                        if (controller.selectedVehicleIndex.value != -1) {
                          controller.renewService();
                        } else {
                          Utils.getSnackbar(
                              "Error", "Please select an item for renewal");
                        }
                      },
                      child: Container(
                        width: context.width,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppSizes.radius_50),
                          color: AppColors.black,
                        ),
                        child: Center(
                          child: Text(
                            'Request Renewal',
                            style: AppTextStyles(context)
                                .display18W400
                                .copyWith(color: AppColors.selextedindexcolor),
                          ).paddingSymmetric(horizontal: 3.w, vertical: 1.5.h),
                        ),
                      ),
                    ).paddingSymmetric(horizontal: 30),
                  ],
                ).paddingSymmetric(horizontal: 4.w, vertical: 3.h),
              ),
              SizedBox(height: 35),
            ],
          ).paddingSymmetric(horizontal: 4.w * 0.9),
        ),
      ),
    );
  }
}
