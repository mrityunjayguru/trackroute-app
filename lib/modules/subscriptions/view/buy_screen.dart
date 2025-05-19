import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import 'package:track_route_pro/config/app_sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/subscriptions/controller/subscription_controller.dart';
import 'package:track_route_pro/modules/subscriptions/view/subscription_screen.dart';

class BuyView extends StatefulWidget {
  const BuyView({super.key});

  @override
  State<BuyView> createState() => _BuyViewState();
}

class _BuyViewState extends State<BuyView> {
  late final TextEditingController controller;
  final SubscriptionController _controller = Get.put(SubscriptionController());

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteOff,
        body: SingleChildScrollView(
          child: SizedBox(
            height: 100.h,
            child: Stack(
              children: [
                // Background container for height
                Container(height: 100.h),

                // Top black header
                Container(
                  height: 31.h,
                  padding: EdgeInsets.only(left: 5.w, right: 4.w, top: 3.5.h),
                  decoration: BoxDecoration(color: AppColors.black),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset(
                            Assets.images.svg.logo,
                            width: 40.w,
                          ),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Icon(Icons.arrow_back_ios,
                                color: AppColors.selextedindexcolor),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.2.h),
                      Text(
                        'Buy GPS Device',
                        style: AppTextStyles(context)
                            .display20W400
                            .copyWith(color: AppColors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Assistant Code Card
                Positioned(
                  top: 17.h,
                  left: 5.w,
                  right: 5.w,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 5.5.h),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppSizes.radius_20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Sales Assistant Code',
                          style: AppTextStyles(context)
                              .display16W500
                              .copyWith(color: AppColors.black),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.5.h),
                        TextFormField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: () {
                                Get.to(() => SubscriptionView());
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 4.w, vertical: 2.h),
                                child: Text(
                                  'Submit',
                                  style: AppTextStyles(context)
                                      .display14W500
                                      .copyWith(color: AppColors.purpleColor),
                                ),
                              ),
                            ),
                            filled: true,
                            fillColor: AppColors.textfield,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: AppColors.textfield,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: AppColors.textfield,
                                width: 2.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: AppColors.textfield,
                                width: 2.0,
                              ),
                            ),
                            hintText: 'Enter Code',
                            hintStyle: AppTextStyles(context)
                                .display14W300
                                .copyWith(color: AppColors.grayLight),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 1.8.h, horizontal: 4.w),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: AppColors.color_e5e7f3,
                                thickness: 1,
                                endIndent: 10,
                              ),
                            ),
                            Text(
                              'or',
                              style: AppTextStyles(context)
                                  .display16W400
                                  .copyWith(color: AppColors.black),
                            ),
                            Expanded(
                              child: Divider(
                                color: AppColors.color_e5e7f3,
                                thickness: 1,
                                indent: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Shop Button
                Positioned(
                  top: 45.h,
                  left: 11.w,
                  right: 11.w,
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      height: 6.2.h,
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(AppSizes.radius_8),
                      ),
                      child: Center(
                        child: Text(
                          'Shop on our website!',
                          style: AppTextStyles(context)
                              .display18W400
                              .copyWith(color: AppColors.selextedindexcolor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
