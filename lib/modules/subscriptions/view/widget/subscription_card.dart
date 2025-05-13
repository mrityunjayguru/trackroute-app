import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/app_sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/modules/subscriptions/controller/subscription_controller.dart';
import 'package:track_route_pro/utils/common_import.dart';

class SubscriptionCard extends StatelessWidget {
  SubscriptionCard({
    required this.name,
    required this.index,
    required this.price,
    this.type,
    required this.features,
    required this.wireType,
    required this.image,
    this.wireQuantity,
    super.key,
  });

  final controller = Get.put(SubscriptionController());

  final String name;
  final int price;
  final String? type;
  final List<String> features;
  final String wireType;
  final String? wireQuantity;
  final String image;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radius_24),
        color: AppColors.color_f6f8fc,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.radius_50),
                    color: AppColors.selextedindexcolor,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/images/svg/wireless.svg',
                        height: 20,
                        width: 20,
                      ),
                      Text('$wireType       ',
                          style: AppTextStyles(context).display10W500),
                    ],
                  ),
                ),
                SizedBox(height: 1.h),
                Padding(
                  padding: EdgeInsets.only(left: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "$name ",
                          style: AppTextStyles(context)
                              .display28W600
                              .copyWith(color: AppColors.black),
                          children: [
                            wireQuantity != null
                                ? TextSpan(
                                    text: wireQuantity,
                                    style: AppTextStyles(context)
                                        .display12W600
                                        .copyWith(color: AppColors.grayLight),
                                  )
                                : TextSpan()
                          ],
                        ),
                      ),
                      SizedBox(height: 1.h),
                      ...features.map((point) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 0.5.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 2), // Adjust to align with text
                                child: SvgPicture.asset(
                                    'assets/images/svg/check.svg',
                                    height: 12),
                              ),
                              SizedBox(width: 6), // Space between icon and text
                              Expanded(
                                child: Text(
                                  point,
                                  style: AppTextStyles(context)
                                      .display12W400
                                      .copyWith(
                                        color: AppColors.black,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      SizedBox(height: 1.h),
                      RichText(
                        text: TextSpan(
                          text: "Price: ",
                          style: AppTextStyles(context)
                              .display12W500
                              .copyWith(color: AppColors.black, height: 3.4),
                          children: [
                            TextSpan(
                                text: '₹',
                                style: AppTextStyles(context).display20W600),
                            TextSpan(
                              text: "${price.toString()} ",
                              style: AppTextStyles(context)
                                  .display28W600
                                  .copyWith(color: AppColors.black),
                            ),
                            TextSpan(
                              text: '5000',
                              style: AppTextStyles(context)
                                  .display12W400
                                  .copyWith(
                                      color: AppColors.grayDefault,
                                      decoration: TextDecoration.lineThrough),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// RIGHT SECTION - Image + Quantity
          SizedBox(width: 3.w),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 15.h,
                      width: 30.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSizes.radius_24),
                        color: AppColors.selextedindexcolor,
                      ),
                    ),
                    Transform.rotate(
                      angle: 0.785398,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.asset(
                          image,
                          height: 15.h,
                          width: 35.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Obx(() => Container(
                      width: 28.w, // reduced total width
                      padding: EdgeInsets.symmetric(
                        horizontal: 0.5.w,
                        vertical: 0.5.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSizes.radius_30),
                        color: AppColors.white,
                        border: Border.all(
                          color: AppColors.grayLighter,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => controller.decrement(index),
                            child: Icon(
                              Icons.remove_circle_outline,
                              color: AppColors.grayLighter,
                              size: 30,
                            ),
                          ),
                          SizedBox(
                            width: 40,
                            child: TextFormField(
                              onTapOutside: (_) =>
                                  FocusScope.of(context).unfocus(),
                              onChanged: (value) {
                                controller.quantities[index] =
                                    int.tryParse(value) ?? 0;
                              },
                              controller: controller.quantityControllers[index],
                              style: controller.quantities[index] > 0
                                  ? AppTextStyles(context)
                                      .display22W400
                                      .copyWith(color: AppColors.black)
                                  : AppTextStyles(context)
                                      .display22W400
                                      .copyWith(color: AppColors.grayLight),
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => controller.increment(index),
                            child: Icon(
                              Icons.add_circle_outline_outlined,
                              color: AppColors.grayLighter,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
