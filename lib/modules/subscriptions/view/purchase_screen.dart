import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/app_sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/subscriptions/controller/subscription_controller.dart';
import 'package:track_route_pro/modules/subscriptions/view/widget/purchase_card.dart';
import 'package:track_route_pro/utils/common_import.dart';

class PurchaseView extends GetView<SubscriptionController> {
  const PurchaseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubscriptionController>();
    final subscriptionData = controller.subscriptions;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteOff,
        bottomNavigationBar: Obx(() {
          final totals = _calculateBillTotals(controller);
          return Container(
            decoration: BoxDecoration(color: AppColors.white),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: InkWell(
              onTap: () => Get.to(() => const PurchaseView()),
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
                    "Proceed to Payment",
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
              ...List.generate(
                subscriptionData.length,
                (index) => PurchaseCard(
                  features: subscriptionData[index].features,
                  name: subscriptionData[index].name,
                  price: subscriptionData[index].price,
                  type: subscriptionData[index].type,
                  wireType: subscriptionData[index].wireType,
                  image: subscriptionData[index].image,
                  index: subscriptionData[index].quantityIndex,
                ),
              ),
              Obx(() => _buildBill(context)),
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
        Container(height: 270),
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
            height: 160,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.color_f6f8fc,
              borderRadius: BorderRadius.circular(AppSizes.radius_20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.25),
                  blurRadius: 6,
                  spreadRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Select Your Plan',
                            style: AppTextStyles(context).display20W500),
                        Text('& Add-Ons',
                            style: AppTextStyles(context)
                                .display16W500
                                .copyWith(color: AppColors.black)),
                      ],
                    ),
                    SvgPicture.asset('assets/images/svg/touch.svg'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      final totals = _calculateBillTotals(controller);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Payable',
                              style: AppTextStyles(context)
                                  .display12W500
                                  .copyWith(color: AppColors.black)),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '₹',
                                  style: AppTextStyles(context)
                                      .display20W500
                                      .copyWith(color: AppColors.black),
                                ),
                                TextSpan(
                                  text: '${totals['total']}',
                                  style: AppTextStyles(context)
                                      .display28W600
                                      .copyWith(color: AppColors.black),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSizes.radius_16),
                        color: AppColors.white,
                      ),
                      child: Text('Inclusive of GST',
                          style: AppTextStyles(context)
                              .display14W500
                              .copyWith(color: AppColors.color_969696)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBill(BuildContext context) {
    final controller = Get.find<SubscriptionController>();
    final totals = _calculateBillTotals(controller);

    return Container(
      width: 100.w,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radius_24),
        color: AppColors.color_f6f8fc,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bill details',
              style: AppTextStyles(context)
                  .display16W600
                  .copyWith(color: AppColors.purpleColor)),
          SizedBox(height: 2.h),
          _buildBillDetails(context, 'Wired GPS Device', totals['wired']),
          SizedBox(height: 1.h),
          _buildBillDetails(
              context, 'Anti Theft (Relay) Amount', totals['antiTheft']),
          SizedBox(height: 1.h),
          if (totals['wiredPlan']! > 0) ...[
            _buildBillDetails(
                context,
                '${controller.subscriptions[0].plan?.year} Year Subscription (W)',
                totals['wiredPlan']),
            SizedBox(height: 1.h),
          ],
          _buildBillDetails(context, 'Wireless GPS Amount', totals['wireless']),
          SizedBox(height: 1.h),
          if (totals['wirelessPlan']! > 0)
            _buildBillDetails(
                context,
                '${controller.subscriptions[1].plan?.year} Year Subscription (WL)',
                totals['wirelessPlan']),
          const Divider(thickness: 1, height: 25),
          _buildBillDetails(context, 'GST (18%)', totals['gst']),
          const Divider(thickness: 1, height: 25),
          SizedBox(height: 1.h),
          Row(
            children: [
              Text('Total Payable',
                  style: AppTextStyles(context).display16W700),
              const Spacer(),
              Text('₹${totals['total']}',
                  style: AppTextStyles(context).display16W700),
            ],
          ),
          SizedBox(height: 1.5.h),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              suffixIcon: InkWell(
                onTap: () {
                  // TODO: Apply coupon
                },
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 10, top: 15, bottom: 15),
                  child: Text('APPLY',
                      style: AppTextStyles(context)
                          .display13W400
                          .copyWith(color: AppColors.purpleColor)),
                ),
              ),
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.white, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.purpleColor, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.white, width: 1),
              ),
              hintText: 'Enter Code',
              hintStyle: AppTextStyles(context)
                  .display14W300
                  .copyWith(color: AppColors.grayLight),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, int> _calculateBillTotals(SubscriptionController controller) {
    final wired = controller.subscriptions[0].price * controller.quantities[0];
    final antiTheft = controller.subscriptions[0].selectedAntiTheftQuantity > 0
        ? 249 * controller.subscriptions[0].selectedAntiTheftQuantity
        : 0;
    final wiredPlan = controller.subscriptions[0].plan?.price ?? 0;
    final wireless =
        controller.subscriptions[1].price * controller.quantities[1];
    final wirelessPlan = controller.subscriptions[1].plan?.price ?? 0;

    final subtotal = wired + antiTheft + wiredPlan + wireless + wirelessPlan;
    final gst = (subtotal * 0.18).round();
    final total = subtotal + gst;

    return {
      'wired': wired,
      'antiTheft': antiTheft,
      'wiredPlan': wiredPlan,
      'wireless': wireless,
      'wirelessPlan': wirelessPlan,
      'gst': gst,
      'total': total,
    };
  }

  Widget _buildBillDetails(BuildContext context, String text, int? amount) {
    final isZero = amount == 0;
    return Row(
      children: [
        Text(
          text,
          style: AppTextStyles(context)
              .display16W400
              .copyWith(color: AppColors.color_363B39),
        ),
        const Spacer(),
        Text(
          '₹$amount',
          style: AppTextStyles(context).display16W500.copyWith(
                color: isZero ? AppColors.grayLight : AppColors.color_363B39,
              ),
        ),
      ],
    );
  }
}
