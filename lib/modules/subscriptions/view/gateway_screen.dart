import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/common/textfield/apptextfield.dart';
import 'package:track_route_pro/config/app_sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/constants/project_urls.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/subscriptions/controller/subscription_controller.dart';
import 'package:track_route_pro/modules/subscriptions/view/widget/purchase_card.dart';
import 'package:track_route_pro/utils/common_import.dart';

class GatewayScreen extends GetView<SubscriptionController> {
  const GatewayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubscriptionController>();
    final subscriptionData = controller.subscriptions;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteOff,
        bottomNavigationBar: Obx(() {
          return Container(
            decoration: BoxDecoration(color: AppColors.white),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: InkWell(
              // onTap: () => Get.to(() => const PurchaseView()),
              child: Container(
                height: 6.h,
                width: context.width - 40,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.radius_8),
                  color: AppColors.black,
                ),
                child: Center(
                  child: Text(
                    "Pay Now",
                    style: AppTextStyles(context)
                        .display18W600
                        .copyWith(color: const Color(0xffD9E821)),
                  ),
                ),
              ),
            ),
          );
        }),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final controller = Get.find<SubscriptionController>();

    return Stack(
      children: [
        Container(height: 100.h),
        Container(
          alignment: Alignment.topCenter,
          height: 226,
          decoration: const BoxDecoration(color: AppColors.black),
          padding: const EdgeInsets.only(left: 20, right: 10, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(Assets.images.svg.logo, width: 200),
              IconButton(
                onPressed: () => Get.back(),
                icon: Icon(Icons.arrow_back_ios,
                    color: AppColors.selextedindexcolor),
              )
            ],
          ),
        ),
        Positioned(
          top: 90,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSizes.radius_20),
            ),
            child: Column(
              children: [
                AppTextFormField(
                  color: AppColors.color_f1f2f4,
                  controller: TextEditingController(),
                  hintText: 'Full Name',
                  context: context,
                ),
                AppTextFormField(
                  color: AppColors.color_f1f2f4,
                  controller: TextEditingController(),
                  hintText: 'Mobile',
                  context: context,
                ),
                AppTextFormField(
                  color: AppColors.color_f1f2f4,
                  controller: TextEditingController(),
                  hintText: 'Email ID',
                  context: context,
                ),
                AppTextFormField(
                  color: AppColors.color_f1f2f4,
                  controller: TextEditingController(),
                  hintText: 'Address',
                  context: context,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 40.w,
                      child: AppTextFormField(
                        color: AppColors.color_f1f2f4,
                        controller: TextEditingController(),
                        hintText: 'District',
                        context: context,
                      ),
                    ),
                    SizedBox(
                      width: 40.w,
                      child: AppTextFormField(
                        color: AppColors.color_f1f2f4,
                        controller: TextEditingController(),
                        hintText: 'Pincode',
                        context: context,
                      ),
                    ),
                  ],
                ),
                AppTextFormField(
                  color: AppColors.color_f1f2f4,
                  controller: TextEditingController(),
                  hintText: 'GST Number',
                  context: context,
                ),
                SizedBox(height: 1.h),
                Text('Select a UPI app',
                    style: AppTextStyles(context).display16W500),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget AppTextFormField(
      {required TextEditingController controller,
      required String hintText,
      String? title,
      String? errorText,
      BoxBorder? border,
      bool obscureText = false,
      String? clearIcon,
      double? hintTextSize,
      String? suffixIcon,
      String? prefixIcon,
      GestureTapCallback? onSuffixTap,
      GestureTapCallback? onClearTap,
      ValueChanged<String>? onChanged,
      bool readOnly = false,
      GestureTapCallback? onTap,
      String? Function(String?)? validator,
      double? height,
      List<BoxShadow>? boxShadow,
      Color? color,
      Decoration? decoration,
      int? maxLines,
      int? minLine,
      int? maxLength,
      TextInputAction? textInputAction,
      EdgeInsetsGeometry? contentPadding,
      double? suffixIconHeight,
      required BuildContext context}) {
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.color_f6f8fc,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.8.h),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        onChanged: onChanged,
        cursorColor: AppColors.black,
        style: AppTextStyles(context)
            .display16W500
            .copyWith(color: AppColors.black),
        validator: validator,
        maxLines: maxLines,
        minLines: minLine,
        maxLength: maxLength,
        textInputAction: textInputAction ?? TextInputAction.next,
        decoration: InputDecoration(
          fillColor: AppColors.color_f6f8fc,
          contentPadding: contentPadding ??
              const EdgeInsets.only(
                right: 16,
                bottom: 4,
                left: 16,
              ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.red)),
          disabledBorder: InputBorder.none,
          hintText: hintText.tr,
          hintStyle: AppTextStyles(context)
              .display16W400
              .copyWith(color: AppColors.grayLight),
        ),
      ),
    );
  }
}
