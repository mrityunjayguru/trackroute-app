import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/app_sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/constants/project_urls.dart';
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
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
          child: InkWell(
            onTap: () => Get.to(() => PurchaseView()),
            child: Container(
              height: 6.5.h,
              width: 90.w,
              padding: EdgeInsets.all(1.5.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.radius_8),
                color: AppColors.black,
              ),
              child: Center(
                child: Text(
                  "Continue Purchase",
                  style: AppTextStyles(context).display18W400.copyWith(
                        color: const Color(0xffD9E821),
                      ),
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
                  SizedBox(height: 33.h),
                  Container(
                    alignment: Alignment.topCenter,
                    height: 28.h,
                    decoration: BoxDecoration(color: AppColors.black),
                    padding: EdgeInsets.only(left: 5.w, right: 4.w, top: 2.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          Assets.images.svg.logo,
                          width: 40.w,
                        ),
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(Icons.arrow_back_ios,
                              color: AppColors.selextedindexcolor),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10.h,
                    left: 5.w,
                    right: 5.w,
                    child: Container(
                      height: 22.h,
                      decoration: BoxDecoration(
                        color: AppColors.color_f6f8fc,
                        borderRadius: BorderRadius.circular(AppSizes.radius_20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.25),
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
              Container(
                decoration: BoxDecoration(
                  color: AppColors.color_f6f8fc,
                  borderRadius: BorderRadius.circular(AppSizes.radius_20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.h),
                margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Offered Devices',
                        style: AppTextStyles(context).display18W600),
                    Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: AppColors.selextedindexcolor,
                      size: 30,
                      weight: 900,
                    )
                    // Obx(
                    //   () => GestureDetector(
                    //     onTap: () {
                    //       controller.setSelectedRadioValue(
                    //         controller.selectedRadioValue.value == 'government'
                    //             ? ''
                    //             : 'government',
                    //       );
                    //     },
                    //     child: Row(
                    //       children: [
                    //         Text(
                    //           'Government Related',
                    //           style: AppTextStyles(context)
                    //               .display14W400
                    //               .copyWith(
                    //                 color:
                    //                     controller.selectedRadioValue.value ==
                    //                             'government'
                    //                         ? AppColors.purpleColor
                    //                         : AppColors.grayLight,
                    //               ),
                    //         ),
                    //         SizedBox(width: 2.w),
                    //         Container(
                    //           width: 4.w,
                    //           height: 4.w,
                    //           padding: EdgeInsets.all(0.5.w),
                    //           decoration: BoxDecoration(
                    //             shape: BoxShape.circle,
                    //             border: Border.all(
                    //               color: controller.selectedRadioValue.value ==
                    //                       'government'
                    //                   ? AppColors.purpleColor
                    //                   : AppColors.grayLight,
                    //               width: 0.4.w,
                    //             ),
                    //           ),
                    //           child: controller.selectedRadioValue.value ==
                    //                   'government'
                    //               ? SvgPicture.asset(
                    //                   'assets/images/svg/check.svg',
                    //                   height: 3.w,
                    //                 )
                    //               : null,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
              ...List.generate(
                subscriptionData.length,
                (index) => SubscriptionCard(
                  name: subscriptionData[index].name,
                  price: subscriptionData[index].price,
                  features: subscriptionData[index].features,
                  wireType: subscriptionData[index].wireType,
                  wireQuantity: subscriptionData[index].wireQuantity,
                  image:
                      '${ProjectUrls.imgBaseUrl}${Uri.encodeFull('${subscriptionData[index].image}')}',
                  index: index,
                ),
              ),
              Container(
                width: 100.w,
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
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
                    SizedBox(height: 0.5.h),
                    Text(
                      'Distinctive Features',
                      style: AppTextStyles(context)
                          .display14W600
                          .copyWith(color: AppColors.grayLight),
                    ),
                    SizedBox(height: 1.5.h),
                    Obx(() => Column(
                          children: List.generate(
                            controller.featuresList.length,
                            (index) {
                              final item = controller.featuresList[index];
                              final isExpanded =
                                  controller.expandedStates[index];

                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.w, vertical: 1.h),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: isExpanded ? 3.h : 0),
                                      child: isExpanded
                                          ? Container(
                                              width: double.infinity,
                                              margin: EdgeInsets.only(top: 2.h),
                                              padding: EdgeInsets.all(5.w),
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
                                                style: AppTextStyles(context)
                                                    .display12W400,
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          controller.toggleExpanded(index),
                                      child: Container(
                                        padding: EdgeInsets.all(2.w),
                                        decoration: BoxDecoration(
                                          color: AppColors.selextedindexcolor,
                                          borderRadius: BorderRadius.circular(
                                              AppSizes.radius_8),
                                        ),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              item['asset']!,
                                              height: 4.h,
                                              width: 4.h,
                                            ),
                                            SizedBox(width: 3.w),
                                            Expanded(
                                                child: Text(item['title']!,
                                                    style:
                                                        AppTextStyles(context)
                                                            .display12W600)),
                                            Icon(
                                              isExpanded
                                                  ? Icons.remove_circle_outline
                                                  : Icons
                                                      .add_circle_outline_sharp,
                                              color: Colors.black,
                                              size: 2.5.h,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
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
