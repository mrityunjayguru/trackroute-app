import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/app_sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/about_us/view/about_us.dart';
import 'package:track_route_pro/modules/faqs/view/faqs_view.dart';
import 'package:track_route_pro/modules/settig_screen/controller/setting_controller.dart';
import 'package:track_route_pro/modules/settig_screen/view/update_dialog.dart';
import 'package:track_route_pro/modules/support/view/support_view.dart';
import 'package:track_route_pro/routes/app_pages.dart';
import 'package:track_route_pro/utils/app_prefrance.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../../constants/project_urls.dart';
import '../../../utils/utils.dart';
import '../../alert_screen/controller/alert_controller.dart';
import '../../alert_screen/view/widget/filterview.dart';
import '../../faqs/controller/faqs_controller.dart';
import '../../login_screen/controller/login_controller.dart';
import '../../splash_screen/controller/data_controller.dart';

class SettingView extends StatelessWidget {
  SettingView({super.key});

  final controller = Get.put(SettingController());

  final dataController = Get.isRegistered<DataController>()
      ? Get.find<DataController>() // Find if already registered
      : Get.put(DataController());

  // void initState() {
  @override
  Widget build(BuildContext context) {
    final localizations = getAppLocalizations(context)!;
    return Container(
      color: AppColors.white,
      child: SafeArea(child: Obx(() {
        return Column(
          children: [
            Row(
              children: [
                Image.network(
                    width: 25,
                    height: 25,
                    "${ProjectUrls.imgBaseUrl}${dataController.settings.value.logo}",
                    errorBuilder: (context, error, stackTrace) =>
                        SvgPicture.asset(
                          Assets.images.svg.icIsolationMode,
                          color: AppColors.black,
                        )).paddingOnly(left: 6, right: 8),
                Text(
                  localizations.settings,
                  style: AppTextStyles(context).display20W500,
                ),
                Spacer(),
                Text(
                  "Crafted By DesignDemonz",
                  style: AppTextStyles(context)
                      .display10W400
                      .copyWith(color: AppColors.grayLight),
                ),
              ],
            ).paddingOnly(top: 12),

            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Get.to(() => AlertsNotificationView(),
                    transition: Transition.upToDown,
                    duration: const Duration(milliseconds: 300));
                Get.put(AlertController()).getAlertsDetails();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.radius_10),
                  color: AppColors.color_f6f8fc,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: AppColors.color_e5e7e9,
                          shape: BoxShape.circle),
                      child: SvgPicture.asset(
                              "assets/images/svg/notif_icon_setting.svg")
                          .paddingSymmetric(horizontal: 5),
                    ).paddingOnly(right: 5),
                    Text(
                      localizations.notifications,
                      style: AppTextStyles(context).display18W500,
                    ),
                    Spacer(),
                    SvgPicture.asset("assets/images/svg/arrow_icon.svg")
                        .paddingSymmetric(horizontal: 5),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),

            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.to(() => SupportView(),
                          transition: Transition.upToDown,
                          duration: const Duration(milliseconds: 300));
                    },
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 7, vertical: 15),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppSizes.radius_10),
                          color: AppColors.black,
                        ),
                        child: Center(
                          child: Text(
                            localizations.support,
                            style: AppTextStyles(context)
                                .display18W500
                                .copyWith(color: AppColors.selextedindexcolor),
                          ),
                        )),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if(dataController.settings.value.mobileSupport?.isNotEmpty ?? false){
                        Utils.makePhoneCall(
                            dataController.settings.value.mobileSupport ?? "");
                      }

                    },
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 7, vertical: 15),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppSizes.radius_10),
                          color: AppColors.selextedindexcolor,
                        ),
                        child: Center(
                          child: Text(
                            "Call Us",
                            style: AppTextStyles(context).display18W500,
                          ),
                        )),
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.radius_10),
                color: AppColors.color_f6f8fc,
              ),
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 7),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppSizes.radius_10),
                            color: AppColors.color_f6f8fc,
                          ),
                          child: Text.rich(
                            textAlign: TextAlign.start,
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'App Version\n',
                                  style: AppTextStyles(context)
                                      .display14W500
                                      .copyWith(color: AppColors.grayLight),
                                ),
                                TextSpan(
                                  text: "${controller.appVersion.value}",
                                  style: AppTextStyles(context).display16W500,
                                ),
                              ],
                            ),
                          )).paddingOnly(left: 7)),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        // Utils.openDialog(context: context, child: UpdateDialog());
                      },
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 7, vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppSizes.radius_10),
                            color: AppColors.black,
                          ),
                          child: Center(
                            child: Text(
                              "Update",
                              style: AppTextStyles(context)
                                  .display16W500
                                  .copyWith(
                                      color: AppColors.selextedindexcolor),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ).paddingOnly(top: 15, bottom: 15),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.addBanner.value.data?.length ?? 0,
                itemBuilder: (context, index) => InkWell(
                  onTap: () => Utils.launchLink(
                      controller.addBanner.value.data![index].hyperLink ?? ""),
                  child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSizes.radius_10),
                      child: Image.network(
                          height: 13.h,
                          width: context.width,
                          fit: BoxFit.cover,
                          '${ProjectUrls.imgBaseUrl}${controller.addBanner.value.data![index].image}',
                          errorBuilder: (context, error, stackTrace) =>
                              SvgPicture.asset(
                                Assets.images.svg.icIsolationMode,
                                color: AppColors.black,
                              )).paddingAll(0),
                    ),
                    width: context.width,
                    decoration: BoxDecoration(
                        color: AppColors.color_f6f8fc,
                        borderRadius:
                            BorderRadius.circular(AppSizes.radius_10)),
                  ).paddingOnly(bottom: 2.h),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 7, vertical: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.radius_10),
                color: AppColors.color_f6f8fc,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.to(() => AboutUsView(),
                            transition: Transition.upToDown,
                            duration: const Duration(milliseconds: 300));
                      },
                      child:  Container(
                          padding:
                          EdgeInsets.symmetric(horizontal: 7, vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(AppSizes.radius_10),
                            color: AppColors.grayLighter,
                          ),
                          child: Center(
                            child: Text(
                              "About Us",
                              style: AppTextStyles(context)
                                  .display16W500,
                            ),
                          )),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.put(FaqsController()).getTopics();
                        Get.put(FaqsController()).getFaq();
                        Get.to(() => FaqsView(),
                            transition: Transition.upToDown,
                            duration: const Duration(milliseconds: 300));
                        // Get.toNamed(Routes.FAQS);
                      },
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 7, vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppSizes.radius_10),
                            color: AppColors.grayLighter,
                          ),
                          child: Center(
                            child: Text(
                              "FAQs",
                              style: AppTextStyles(context)
                                  .display16W500
                                  .copyWith(color: AppColors.black),
                            ),
                          )),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                      child: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Language\n',
                          style: AppTextStyles(context).display14W400.copyWith(color: AppColors.grayLight),
                        ),
                        TextSpan(
                          text: 'English (UK)',
                          style: AppTextStyles(context).display16W500 )
                      ],
                    ),
                  ))
                ],
              ),
            ).paddingOnly(top: 15),
            InkWell(
              onTap: () async {
                Get.offAllNamed(Routes.LOGIN);
                await Get.put(LoginController()).sendTokenData(isLogout: true);
                await AppPreference.removeLoginData();
              },
              child: Container(
                height: 6.h,
                width: 45.w,
                decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(AppSizes.radius_50)),
                child: Center(
                    child: Text(
                  localizations.logOut,
                  style: AppTextStyles(context)
                      .display16W400
                      .copyWith(color: AppColors.selextedindexcolor),
                )),
              ),
            ).paddingOnly(top: 15),
            Container(
              height: 5.h,
              width: 100.w - (4.w * 0.9),
              decoration: BoxDecoration(
                  color: AppColors.grayLighter,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppSizes.radius_4),
                      topRight: Radius.circular(AppSizes.radius_4))),
              child: Center(
                  child: Text(
                localizations.newfeatures,
                style: AppTextStyles(context).display12W500,
              )),
            ).paddingOnly(top: 15),
            // Expanded(
            //   child: GridView.builder(
            //     itemCount: 2,
            //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //         crossAxisCount: 2,
            //         crossAxisSpacing: 12,
            //         mainAxisSpacing: 12,
            //         childAspectRatio: 3.7),
            //     itemBuilder: (context, index) => Container(
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(AppSizes.radius_16),
            //         color: AppColors.grayLighter,
            //       ),
            //     ),
            //   ),
            // )
          ],
        ).paddingSymmetric(horizontal: 4.w * 0.9);
      })),
    );
  }
}
