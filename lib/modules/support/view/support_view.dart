import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/common/textfield/apptextfield.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/support/controller/support_controller.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_route_controller.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_route_controller.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_route_controller.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../../config/app_sizer.dart';
import '../../../constants/project_urls.dart';
import '../../splash_screen/controller/data_controller.dart';

class SupportView extends StatelessWidget {
  SupportView({super.key});

  final controller = Get.put(SupportController());
  final dataController = Get.isRegistered<DataController>()
      ? Get.find<DataController>() // Find if already registered
      : Get.put(DataController());
  var scrollController = ScrollController();
  final trackController = Get.isRegistered<TrackRouteController>()
      ? Get.find<TrackRouteController>() // Find if already registered
      : Get.put(TrackRouteController());

  @override
  Widget build(BuildContext context) {
    final localizations = getAppLocalizations(context)!;
    return Scaffold(
      backgroundColor: AppColors.whiteOff,
      body: Obx(()=>
         Stack(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 100.w,
              decoration: BoxDecoration(color: AppColors.black),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 8.h,
                  ),
                 Image.network(
                        width: 120,
                        height: 50,
                        "${ProjectUrls.imgBaseUrl}${dataController.settings.value.appLogo}",
                        errorBuilder: (context, error, stackTrace) =>
                            SvgPicture.asset(
                              Assets.images.svg.icIsolationMode,
                              color: AppColors.black,
                            )
                  ),
                  Row(
                    children: [
                      Text(
                        'Support',
                        style: AppTextStyles(context).display32W700.copyWith(
                              color: AppColors.whiteOff,
                            ),
                      ),
                      Spacer(),
                      InkWell(
                          onTap: () {
                            Get.back();
                            controller.isSucessSubmit.value = false;
                          },
                          child: SvgPicture.asset(
                            "assets/images/svg/close_icon.svg",
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                ],
              ).paddingSymmetric(horizontal: 6.w),
            ),
            controller.isSucessSubmit.value
                  ? Container(
                      child: Column(
                        children: [
                          Text(
                            'Thank you for your submission!',
                            style: AppTextStyles(context)
                                .display32W700
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Text('We will contact you within 24 hours',
                              style: AppTextStyles(context).display24W400),
                        ],
                      ),
                    ).paddingSymmetric(horizontal: 6.w, vertical: 4.h)
                  : Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Registered Email ID',
                              style: AppTextStyles(context)
                                  .display12W400
                                  .copyWith(color: AppColors.grayLight),
                            ),
                            Obx(
                              () => Text(
                                '${controller.userEmail.value}',
                                style: AppTextStyles(context)
                                    .display14W600
                                    .copyWith(color: AppColors.grayLight),
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            vehicalSelection(localizations, context),
                            AppTextFormField(
                                color: AppColors.textfield,
                                controller: controller.deviceID,
                                suffixIcon: "assets/images/svg/paste_icon.svg",
                                onSuffixTap: () async {
                                  ClipboardData data =
                                      await Clipboard.getData('text/plain') ??
                                          ClipboardData(text: "");
                                  controller.deviceID.text = data.text ?? "";
                                },
                                hintText: 'IMEI'),
                            SizedBox(
                              height: 0.4.h,
                            ),
                            AppTextFormField(
                                color: AppColors.textfield,
                                controller: controller.subject,
                                hintText: 'Subject'),
                            SizedBox(
                              height: 0.4.h,
                            ),
                            AppTextFormField(
                                maxLines: 10,
                                height: 23.h,
                                contentPadding: EdgeInsets.all(16),
                                color: AppColors.textfield,
                                controller: controller.description,
                                hintText: 'How can we assist you today?'),
                            SizedBox(
                              height: 3.5.h,
                            ),
                            InkWell(
                              onTap: () {
                                controller.submitSupportRequest();
                              },
                              child: Container(
                                height: 6.h,
                                child: Center(
                                  child: Text(
                                    'Submit',
                                    style: AppTextStyles(context)
                                        .display18W500
                                        .copyWith(color: Color(0xffD9E821)),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppSizes.radius_50),
                                  color: AppColors.black,
                                ),
                              ).paddingOnly(bottom: 20),
                            ),
                          ],
                        ).paddingSymmetric(horizontal: 6.w, vertical: 2.h),
                      ),
                    ),

          ]),
          if (controller.showLoader.value)
            Positioned.fill(
                child: Container(
              alignment: Alignment.center,
              color: Colors.grey.withOpacity(0.7),
              child: LoadingAnimationWidget.threeArchedCircle(
                color: AppColors.selextedindexcolor,
                size: 50,
              ),
            ))
        ]),
      ),
    );
  }

  Widget vehicalSelection(
      AppLocalizations localizations, BuildContext context) {
    return Obx(() {
      int itemCount = (trackController.vehicleList.value.data?.length ?? 0);
      double height = 0;
      height = itemCount * 40;
      if (height > 500) {
        height = 500;
      }
      return Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onTap: () {
              controller.isExpanded.value = !controller.isExpanded.value;
            },
            child: Container(
              height: 4.8.h,
              decoration: BoxDecoration(
                  color: AppColors.textfield,
                  borderRadius: BorderRadius.circular(AppSizes.radius_50)),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/svg/ic_racing.svg',
                    colorFilter:
                        ColorFilter.mode(AppColors.black, BlendMode.srcIn),
                  ).paddingOnly(right: 10, left: 10),
                  Text(
                    controller.vehicleSelected.value
                        ? controller.selectedVehicleName.value
                        : localizations.selectVehicle,
                    style: AppTextStyles(context)
                        .display16W400
                        .copyWith(color: AppColors.black),
                  ),
                  Spacer(),
                  SvgPicture.asset(
                    controller.isExpanded.value
                        ? "assets/images/svg/ic_arrow_up.svg"
                        : Assets.images.svg.icArrowDown,
                    color: AppColors.black,
                  ).paddingOnly(right: 14, left: 10),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: controller.isExpanded.value
                ? SizedBox(
                    height: height,
                    child: Scrollbar(
                      thumbVisibility: true,
                      controller: scrollController,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                            children: List.generate(
                          itemCount,
                          (index) => GestureDetector(
                            behavior: HitTestBehavior.deferToChild,
                            onTap: () {
                              controller.filterAlerts(
                                  !(index ==
                                      controller.selectedVehicleIndex.value),
                                  trackController.vehicleList.value.data?[index]
                                          .vehicleNo ??
                                      "",
                                  index);
                            },
                            child: Container(
                              width: double.maxFinite,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: controller.selectedVehicleIndex == index
                                    ? AppColors.selextedindexcolor
                                    : AppColors.textfield,
                              ),
                              child: Text(
                                '${trackController.vehicleList.value.data?[index].vehicleNo}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles(context)
                                    .display16W700
                                    .copyWith(
                                      color: controller.selectedVehicleIndex ==
                                              index
                                          ? AppColors.whiteOff
                                          : null,
                                    ),
                              ),
                            ),
                          ),
                        )),
                      ),
                    )).paddingSymmetric(horizontal: 10)
                : SizedBox.shrink(),
          ),
        ],
      );
    });
  }
}
