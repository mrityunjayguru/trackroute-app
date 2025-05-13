import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/app_sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/routes/app_pages.dart';
import 'package:track_route_pro/utils/common_import.dart';

class BuyView extends StatefulWidget {
  const BuyView({super.key});

  @override
  State<BuyView> createState() => _BuyViewState();
}

class _BuyViewState extends State<BuyView> {
  late final TextEditingController controller;

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
    final TextEditingController controller = TextEditingController();
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteOff,
        body: Stack(
          children: [
            Container(height: 100.h),
            Container(
              alignment: Alignment.topCenter,
              height: 236,
              decoration: BoxDecoration(
                color: AppColors.black,
              ),
              padding: const EdgeInsets.only(left: 20, right: 10, top: 20),
              child: Column(
                children: [
                  Row(
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
                  SizedBox(height: 2.h),
                  Text('Buy GPS Device',
                      style: AppTextStyles(context)
                          .display22W400
                          .copyWith(color: AppColors.white)),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
            Positioned(
              top: 150,
              left: 20,
              right: 20,
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSizes.radius_20),
                ),
                child: Column(children: [
                  SizedBox(height: 3.h),
                  Text(
                    'Sales Assistant Code',
                    style: AppTextStyles(context)
                        .display18W400
                        .copyWith(color: AppColors.black),
                  ),
                  SizedBox(height: 4.h),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                      ),
                      child: TextFormField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          suffixIcon: InkWell(
                            onTap: () {
                              Get.toNamed(Routes.SUBSCRIPTIONS);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 20, top: 15, bottom: 15),
                              child: Text(
                                'Submit',
                                style: AppTextStyles(context)
                                    .display16W600
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
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 12.0),
                        ),
                      )),
                  SizedBox(height: 4.h),
                  Text('or',
                      style: AppTextStyles(context)
                          .display18W500
                          .copyWith(color: AppColors.black)),
                ]),
              ),
            ),
            Positioned(
              top: 380,
              left: 40,
              right: 40,
              child: InkWell(
                onTap: () {
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(AppSizes.radius_8),
                  ),
                  child: Center(
                    child: Text(
                      'Shop on our website',
                      style: AppTextStyles(context)
                          .display18W600
                          .copyWith(color: AppColors.selextedindexcolor),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
