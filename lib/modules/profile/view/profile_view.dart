import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/app_sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/constants/project_urls.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/profile/controller/profile_controller.dart';
import 'package:track_route_pro/modules/profile/view/widget/re_new_subscription.dart';
import 'package:track_route_pro/utils/common_import.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/utils.dart';
import '../../forgot_password/view/forgot_view.dart';
import '../../splash_screen/controller/data_controller.dart';

class ProfileView extends StatefulWidget {
  ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final controller = Get.isRegistered<ProfileController>()
      ? Get.find<ProfileController>() // Find if already registered
      : Get.put(ProfileController());
  final dataController = Get.isRegistered<DataController>()
      ? Get.find<DataController>() // Find if already registered
      : Get.put(DataController());

  void initState() {
    super.initState();
  }

  // Put (register) if not already registered
  @override
  Widget build(BuildContext context) {
    final localizations = getAppLocalizations(context)!;
    return Obx(() {
      return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            // Slide transition from up to down
            return SlideTransition(
              position: Tween<Offset>(
                begin: controller.isReNewSub.value
                    ? Offset(-1, 0)
                    : Offset(1, 0), // Slide from top
                end: Offset.zero, // End position
              ).animate(animation),
              child: child,
            );
          },
          child: controller.isReNewSub.value
              ? ReNewSubscription()
              : Container(
                  color: AppColors.white,
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Row(
                            children: [
                              Image.network(
                                  width: 25,
                                  height: 25,
                                  "${ProjectUrls.imgBaseUrl}${dataController.settings.value.logo}",
                                  errorBuilder: (context, error, stackTrace) =>
                                      SvgPicture.asset(
                                        Assets.images.svg.icIsolationMode,
                                        color: AppColors.black,
                                      )).paddingOnly(right: 8),
                              Text(
                                localizations.myProfile,
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
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 7, vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppSizes.radius_10),
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
                                        "assets/images/svg/user_icon.svg")
                                    .paddingSymmetric(horizontal: 5),
                              ).paddingOnly(right: 5),
                              Text(
                                '${controller.name.value ?? ''}',
                                style: AppTextStyles(context).display18W500,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Registered Email ID',
                              style: AppTextStyles(context)
                                  .display14W400
                                  .copyWith(color: AppColors.grayLight),
                            ),
                            Text(
                              '${controller.email.value ?? ""}',
                              style: AppTextStyles(context).display18W600,
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            Text(
                              'Registered Phone',
                              style: AppTextStyles(context)
                                  .display14W400
                                  .copyWith(color: AppColors.grayLight),
                            ),
                            Text(
                              '${controller.phone.value}',
                              style: AppTextStyles(context).display18W600,
                            ),
                          ],
                        ).paddingSymmetric(vertical: 2.h, horizontal: 5),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppSizes.radius_10),
                            color: AppColors.color_f6f8fc,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 7),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            AppSizes.radius_10),
                                        color: AppColors.color_f6f8fc,
                                      ),
                                      child: Text.rich(
                                        textAlign: TextAlign.start,
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Password\n',
                                              style: TextStyle(
                                                  color: AppColors.grayLight,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            TextSpan(
                                              text: '*' *
                                                  controller.password.value,
                                              style: AppTextStyles(context)
                                                  .display14W600
                                                  .copyWith(
                                                      color:
                                                          AppColors.blueColor),
                                            ),
                                          ],
                                        ),
                                      )).paddingOnly(left: 7)),
                              SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () => Get.to(
                                      () => ForgotView(
                                            fromLogin: false,
                                          ),
                                      transition: Transition.upToDown,
                                      duration:
                                          const Duration(milliseconds: 300)),
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 7, vertical: 15),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            AppSizes.radius_10),
                                        color: AppColors.black,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Reset Password",
                                          style: AppTextStyles(context)
                                              .display16W500
                                              .copyWith(
                                                  color: AppColors
                                                      .selextedindexcolor),
                                        ),
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ).paddingOnly(top: 5, bottom: 15),
                        SizedBox(
                          height: 3.h,
                        ),
                        InkWell(
                          onTap: () {
                            controller.checkForRenewal();
                            controller.isReNewSub.value = true;
                            controller.selectedVehicleIndex.value = {};
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            width: context.width,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(AppSizes.radius_10),
                                color: AppColors.black),
                            child: Center(
                              child: Text(
                                'Extend / Renew Subscription',
                                style: AppTextStyles(context)
                                    .display18W500
                                    .copyWith(
                                        color: AppColors.selextedindexcolor),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          // height: 20.h,
                          width: 100.w - (4.w * 0.9),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xff00000026).withOpacity(0.15),
                                  blurRadius: 2,
                                  spreadRadius: 0,
                                  offset: Offset(0, 2))
                            ],
                            color: AppColors.black,
                            borderRadius:
                                BorderRadius.circular(AppSizes.radius_10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: CachedNetworkImage(
                                  height: 40,
                                  width: 150,
                                  progressIndicatorBuilder:
                                      (context, url, progress) => Center(
                                    child: CircularProgressIndicator(
                                      value: progress.progress,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      SvgPicture.asset(
                                    "assets/images/svg/tarck_route_pro.svg",
                                  ),
                                  imageUrl:
                                      "${ProjectUrls.imgBaseUrl}${dataController.settings.value.appLogo}",
                                ).paddingOnly(left: 6, right: 8),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Text(
                                'Explore our wide range of GPS trackers!',
                                style: AppTextStyles(context)
                                    .display15W400
                                    .copyWith(color: AppColors.whiteOff),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              InkWell(
                                onTap: () async {
                                  final url =
                                      '${dataController.settings.value.catalogueLink ?? ''}';
                                  Utils.launchLink(url);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        AppSizes.radius_50),
                                    color: AppColors.selextedindexcolor,
                                  ),
                                  child: Text(
                                    'Product Catalogue',
                                    style: AppTextStyles(context).display14W400,
                                  ).paddingSymmetric(
                                      horizontal: 7.w, vertical: 1.4.h),
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              InkWell(
                                onTap: () {
                                  final url =
                                      '${dataController.settings.value.websiteLink ?? ''}';
                                  log("$url");
                                  Utils.launchLink(url);
                                },
                                child: Text(
                                    '${dataController.settings.value.websiteLabel ?? ''}',
                                    style: AppTextStyles(context)
                                        .display15W400
                                        .copyWith(color: AppColors.whiteOff)),
                              ),
                            ],
                          ).paddingSymmetric(horizontal: 20, vertical: 13),
                        ),
                        SizedBox(
                          height: 3.h,
                        )
                      ],
                    ).paddingSymmetric(horizontal: 4.w * 0.9),
                  ),
                ));
    });
  }
}
