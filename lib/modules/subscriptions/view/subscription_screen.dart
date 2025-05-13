import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/app_sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/subscriptions/controller/subscription_controller.dart';
import 'package:track_route_pro/modules/subscriptions/model/subscription.dart';
import 'package:track_route_pro/modules/subscriptions/view/purchase_screen.dart';
import 'package:track_route_pro/modules/subscriptions/view/widget/subscription_card.dart';
import 'package:track_route_pro/utils/common_import.dart';

class SubscriptionView extends GetView<SubscriptionController> {
  SubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<SubscriptionModel> subscriptionData = controller.subscriptions;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteOff,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: AppColors.white),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30.0),
          child: InkWell(
            onTap: () {
              Get.to(
                () => PurchaseView(),
              );
            },
            child: Container(
              height: 6.h,
              width: context.width - 40,
              margin: const EdgeInsets.only(top: 0),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.radius_8),
                color: AppColors.black,
              ),
              child: Center(
                child: Text(
                  "Continue Purchase",
                  style: AppTextStyles(context)
                      .display18W600
                      .copyWith(color: const Color(0xffD9E821)),
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(height: 300),
                  Container(
                    alignment: Alignment.topCenter,
                    height: 236,
                    decoration: BoxDecoration(
                      color: AppColors.black,
                    ),
                    padding:
                        const EdgeInsets.only(left: 20, right: 10, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Assets.images.svg.logo,
                          width: 200,
                        ),
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(Icons.arrow_back_ios,
                                color: AppColors.selextedindexcolor))
                      ],
                    ),
                  ),
                  Positioned(
                    top: 84,
                    left: 20,
                    right: 20,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppColors.color_f6f8fc,
                        borderRadius: BorderRadius.circular(AppSizes.radius_20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.25),
                            blurRadius: 6,
                            spreadRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 6.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Offered Devices',
                      style: AppTextStyles(context)
                          .display18W600
                          .copyWith(color: AppColors.black),
                    ),
                    const SizedBox(width: 10),
                    Obx(
                      () => GestureDetector(
                        onTap: () {
                          controller.setSelectedRadioValue(
                            controller.selectedRadioValue.value == 'government'
                                ? ''
                                : 'government',
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              'Government Related',
                              style: AppTextStyles(context)
                                  .display14W400
                                  .copyWith(
                                    color:
                                        controller.selectedRadioValue.value ==
                                                'government'
                                            ? AppColors.purpleColor
                                            : AppColors.grayLight,
                                  ),
                            ),
                            SizedBox(width: 6),
                            Container(
                              width: 18,
                              height: 18,
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: controller.selectedRadioValue.value ==
                                          'government'
                                      ? AppColors.purpleColor
                                      : AppColors.grayLight,
                                  width: 2,
                                ),
                              ),
                              child: controller.selectedRadioValue.value ==
                                      'government'
                                  ? SvgPicture.asset(
                                      'assets/images/svg/check.svg',
                                      height: 10,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ...List.generate(
                subscriptionData.length,
                (index) => SubscriptionCard(
                  name: subscriptionData[index].name,
                  price: subscriptionData[index].price,
                  type: subscriptionData[index].type,
                  features: subscriptionData[index].features,
                  wireType: subscriptionData[index].wireType,
                  wireQuantity: subscriptionData[index].wireQuantity,
                  image: subscriptionData[index].image,
                  index: subscriptionData[index].quantityIndex,
                ),
              ),
              Container(
                width: 100.w,
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.radius_24),
                  color: AppColors.color_f6f8fc,
                ),
                child: Column(
                  children: [
                    Text(
                      "Built with you in mind",
                      style: AppTextStyles(context)
                          .display18W600
                          .copyWith(color: AppColors.black),
                    ),
                    SizedBox(height: 0.2.h),
                    Text(
                      'Distinctive Features ',
                      style: AppTextStyles(context)
                          .display14W600
                          .copyWith(color: AppColors.grayLight),
                    ),
                    SizedBox(height: 1.h),
                    Obx(() => Column(
                          children: List.generate(
                              controller.featuresList.length, (index) {
                            final item = controller.featuresList[index];
                            final isExpanded = controller.expandedStates[index];

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  // White container (expandable)
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    padding: EdgeInsets.only(
                                        top: isExpanded ? 25 : 0),
                                    child: AnimatedSize(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                      child: isExpanded
                                          ? Container(
                                              width: double.infinity,
                                              margin: const EdgeInsets.only(
                                                  top: 20),
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(
                                                      AppSizes.radius_16),
                                                  bottomRight: Radius.circular(
                                                      AppSizes.radius_16),
                                                ),
                                              ),
                                              child: Text(
                                                item['description']!,
                                                style: TextStyle(
                                                    color: AppColors.black),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                                  ),

                                  // Yellow container (tap target, always on top)
                                  GestureDetector(
                                    onTap: () =>
                                        controller.toggleExpanded(index),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: AppColors.selextedindexcolor,
                                        borderRadius: BorderRadius.circular(
                                            AppSizes.radius_8),
                                      ),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            item['asset']!,
                                            height: 25,
                                            width: 25,
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Text(item['title']!,
                                                style: AppTextStyles(context)
                                                    .display12W600),
                                          ),
                                          Icon(
                                            isExpanded
                                                ? Icons.remove_circle_outline
                                                : Icons
                                                    .add_circle_outline_sharp,
                                            color: Colors.black,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
