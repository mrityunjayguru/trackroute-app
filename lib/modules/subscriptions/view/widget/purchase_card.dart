import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/app_sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/modules/subscriptions/controller/subscription_controller.dart';
import 'package:track_route_pro/routes/app_pages.dart';

class PurchaseCard extends StatelessWidget {
  final String name;
  final int price;
  final List<String> features;
  final String wireType;
  final String? wireQuantity;
  final String image;
  final int index;

  PurchaseCard({
    required this.name,
    required this.index,
    required this.price,
    required this.features,
    required this.wireType,
    required this.image,
    this.wireQuantity,
    super.key,
  });

  final controller = Get.find<SubscriptionController>();

  @override
  Widget build(BuildContext context) {
    final plans = controller.subscriptionPlans[index] ?? [];

    return Obx(() => Container(
          width: 100.w,
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radius_24),
            color: AppColors.color_f6f8fc,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopRow(context),
              SizedBox(height: 2.h),
              if (controller.subscriptions[index].hasAntiTheft) ...[
                _buildDeviceInfo(context),
                SizedBox(height: 1.5.h),
                _buildTheftNotice(context),
                SizedBox(height: 2.h),
              ],
              Text('Choose a Plan',
                  style: AppTextStyles(context).display16W600),
              SizedBox(height: 2.h),
              Obx(() => Row(
                    children: List.generate(
                      plans.length,
                      (planIndex) => Expanded(
                        child: GestureDetector(
                          onTap: () {
                            final selected =
                                controller.getSelectedPlanIndex(index);
                            if (selected == planIndex) {
                              controller.selectPlan(index, -1);
                              controller.subscriptions[index] = controller
                                  .subscriptions[index]
                                  .copyWith(plan: null);
                            } else {
                              controller.selectPlan(index, planIndex);
                              controller.subscriptions[index] =
                                  controller.subscriptions[index].copyWith(
                                plan: controller.subscriptionPlans[index]
                                    ?[planIndex],
                              );
                            }
                          },
                          child: Container(
                            height: 13.h,
                            margin: EdgeInsets.symmetric(horizontal: 1.w),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(AppSizes.radius_10),
                              border: Border.all(
                                color: controller.getSelectedPlanIndex(index) ==
                                        planIndex
                                    ? AppColors.purpleColor
                                    : Colors.transparent,
                                width: 2,
                              ),
                              color: controller.getSelectedPlanIndex(index) ==
                                      -1
                                  ? AppColors.color_e5e7f3
                                  : controller.getSelectedPlanIndex(index) ==
                                          planIndex
                                      ? AppColors.purpleColor
                                          .withValues(alpha: 0.2)
                                      : AppColors.white,
                            ),
                            child: Stack(
                              children: [
                                if (plans[planIndex].discount > 0)
                                  Positioned(
                                    bottom: 0.5.h,
                                    left: 1.w,
                                    right: 1.w,
                                    child: Container(
                                        padding: EdgeInsets.all(0.5.h),
                                        decoration: BoxDecoration(
                                            color: AppColors.selextedindexcolor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    AppSizes.radius_20))),
                                        child: Center(
                                          child: Text(
                                            '${plans[planIndex].discount}% Discount',
                                            style: AppTextStyles(context)
                                                .display10W600,
                                          ),
                                        )),
                                  ),
                                Positioned(
                                  top: 4.h,
                                  left: 3.w,
                                  right: 3.w,
                                  child: Column(
                                    children: [
                                      Text(
                                        plans[planIndex].name,
                                        style: AppTextStyles(context)
                                            .display12W500
                                            .copyWith(
                                                color: controller
                                                            .getSelectedPlanIndex(
                                                                index) ==
                                                        -1
                                                    ? AppColors.black
                                                    : controller.getSelectedPlanIndex(
                                                                index) ==
                                                            planIndex
                                                        ? AppColors.black
                                                        : AppColors
                                                            .color_BCBCBD),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '₹ ',
                                              style: AppTextStyles(context)
                                                  .display14W400
                                                  .copyWith(
                                                      color: AppColors
                                                          .grayDefault),
                                            ),
                                            TextSpan(
                                              text: '${plans[planIndex].price}',
                                              style: AppTextStyles(context)
                                                  .display22W600
                                                  .copyWith(
                                                      color: controller
                                                                  .getSelectedPlanIndex(
                                                                      index) ==
                                                              -1
                                                          ? AppColors.black
                                                          : controller.getSelectedPlanIndex(
                                                                      index) ==
                                                                  planIndex
                                                              ? AppColors.black
                                                              : AppColors
                                                                  .color_BCBCBD,
                                                      height: 1.3),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                if (plans[planIndex].bestValue)
                                  Positioned(
                                    top: 0,
                                    left: 4.w,
                                    right: 4.w,
                                    child: Container(
                                      height: 3.h,
                                      decoration: BoxDecoration(
                                        color: AppColors.black,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(
                                              AppSizes.radius_10),
                                          bottomRight: Radius.circular(
                                              AppSizes.radius_10),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Best Value',
                                          style: AppTextStyles(context)
                                              .display11W500
                                              .copyWith(
                                                  color: AppColors
                                                      .selextedindexcolor),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
              SizedBox(height: 1.h),
              Center(
                child: Text('All plans are exclusive of GST',
                    style: AppTextStyles(context)
                        .display11W300
                        .copyWith(color: AppColors.grayLight)),
              ),
            ],
          ),
        ));
  }

  Widget _buildTopRow(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 55.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(wireType, style: AppTextStyles(context).display12W500),
              Row(
                children: [
                  Text(name,
                      style: AppTextStyles(context)
                          .display24W600
                          .copyWith(color: AppColors.black)),
                  SizedBox(width: 3.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Amount",
                          style: AppTextStyles(context)
                              .display9W500
                              .copyWith(color: AppColors.grayLight)),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: '₹',
                            style: AppTextStyles(context)
                                .display12W400
                                .copyWith(color: AppColors.color_434345)),
                        TextSpan(
                            text: price.toString(),
                            style: AppTextStyles(context)
                                .display16W600
                                .copyWith(color: AppColors.color_434345)),
                      ])),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const Spacer(),
        _buildQuantityController(context),
      ],
    );
  }

  Widget _buildDeviceInfo(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 46.w,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Anti Theft',
                      style: AppTextStyles(context).display16W600),
                  Text('Relay Device',
                      style: AppTextStyles(context).display16W600),
                ],
              ),
              SizedBox(width: 3.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Amount",
                      style: AppTextStyles(context)
                          .display9W500
                          .copyWith(color: AppColors.grayLight)),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: '₹',
                        style: AppTextStyles(context)
                            .display12W400
                            .copyWith(color: AppColors.color_434345)),
                    TextSpan(
                        text: "259",
                        style: AppTextStyles(context)
                            .display16W600
                            .copyWith(color: AppColors.color_434345)),
                  ])),
                ],
              ),
            ],
          ),
        ),
        Obx(
          () => GestureDetector(
            onTap: () {
              final current = controller.subscriptions[index];
              controller.subscriptions[index] = current.copyWith(
                selectedAntiTheft: !(current.selectedAntiTheft ?? false),
              );
            },
            child: Container(
              width: 4.5.h,
              height: 4.5.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      controller.subscriptions[index].selectedAntiTheft == true
                          ? AppColors.purpleColor
                          : AppColors.grayLighter,
                  width: 3,
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/svg/check.svg',
                  color:
                      controller.subscriptions[index].selectedAntiTheft == true
                          ? AppColors.purpleColor
                          : AppColors.grayLighter,
                  height: 20,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 4.w),
        _buildAntiTheftController(context),
      ],
    );
  }

  Widget _buildTheftNotice(BuildContext context) {
    return Container(
      height: 4.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radius_20),
      ),
      child: Center(
        child: Text(
          'Turn vehicle ignition ON/OFF from your phone in case of theft',
          style: AppTextStyles(context)
              .display10W500
              .copyWith(color: AppColors.grayLight),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildAntiTheftController(BuildContext context) {
    return Container(
        width: 28.w,
        padding: EdgeInsets.symmetric(horizontal: 0.5.w, vertical: 0.5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radius_30),
          color: AppColors.white,
          border: Border.all(color: AppColors.grayLighter, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                print(controller.subscriptions[index].selectedAntiTheft);
                if (controller.subscriptions[index].selectedAntiTheft == true) {
                  controller.decrementAntiTheft(index);
                }
              },
              child: Icon(Icons.remove_circle_outline,
                  color: AppColors.color_BCBCBD, size: 3.5.h),
            ),
            SizedBox(
              width: 10.w,
              child: TextFormField(
                controller: controller.antiTheftQuantityControllers[index],
                onChanged: (value) {
                  controller.antiTheftQuantityControllers[index].text = value;
                  final parsedValue = int.tryParse(value) ?? 0;
                  controller.antiTheftQuantities[index] = parsedValue;
                  controller.subscriptions[index].selectedAntiTheftQuantity =
                      parsedValue;
                },
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                style: AppTextStyles(context).display22W600,
                keyboardType: TextInputType.number,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (controller.subscriptions[index].selectedAntiTheft == true) {
                  controller.incrementAntiTheft(index);
                }
              },
              child: Icon(Icons.add_circle_outline_outlined,
                  color: AppColors.color_BCBCBD, size: 3.5.h),
            ),
          ],
        ));
  }

  Widget _buildQuantityController(BuildContext context) {
    return Container(
        width: 28.w,
        padding: EdgeInsets.symmetric(horizontal: 0.5.w, vertical: 0.5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radius_30),
          color: AppColors.white,
          border: Border.all(color: AppColors.grayLighter, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => controller.decrement(index),
              child: Icon(Icons.remove_circle_outline,
                  color: AppColors.color_BCBCBD, size: 3.5.h),
            ),
            SizedBox(
              width: 10.w,
              child: TextFormField(
                controller: controller.quantityControllers[index],
                onChanged: (value) {
                  final parsedValue = int.tryParse(value) ?? 0;
                  controller.quantities[index] = parsedValue;
                  controller.subscriptions[index].selectedQuantity =
                      parsedValue;

                  if (parsedValue == 0) {
                    controller.antiTheftQuantities[index] = 0;
                    controller.antiTheftQuantityControllers[index].text = '0';

                    controller.selectedPlanIndexes[index] = -1;
                    controller.subscriptions[index] =
                        controller.subscriptions[index].copyWith(
                      selectedAntiTheftQuantity: 0,
                      plan: null,
                    );
                  }
                },
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                style: AppTextStyles(context).display22W600,
                keyboardType: TextInputType.number,
              ),
            ),
            GestureDetector(
              onTap: () => controller.increment(index),
              child: Icon(Icons.add_circle_outline_outlined,
                  color: AppColors.color_BCBCBD, size: 3.5.h),
            ),
          ],
        ));
  }
}
