import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:track_route_pro/config/app_sizer.dart';
import 'package:track_route_pro/gen/fonts.gen.dart';
import 'package:track_route_pro/modules/splash_screen/controller/statusbar_controller.dart';
import 'package:track_route_pro/utils/base_font.dart';

import 'app_colors.dart';

class AppTextStyles {
  final BuildContext? context;

  late final TextStyle menuRegular;
  late final TextStyle menuBold;
  late final TextStyle captionRegular;
  late final TextStyle captionBold;
  late final TextStyle bodySmallUnderlineRegular;
  late final TextStyle bodySmallRegular;
  late final TextStyle bodySmallBold;
  late final TextStyle bodyLargeUnderlineRegular;
  late final TextStyle bodyLargeRegular;
  late final TextStyle bodyRegular;
  late final TextStyle bodyLargeBold;
  late final TextStyle bodyHeadTitle;
  late final TextStyle titleRegular;
  late final TextStyle titleBold;
  late final TextStyle headlineRegular;
  late final TextStyle headlineBold;
  late final TextStyle displayOneRegular;
  late final TextStyle displayOneBold;
  late final TextStyle displayTwoRegular;
  late final TextStyle displayTwoBold;
  late final TextStyle displayThreeRegular;
  late final TextStyle displayThreeBold;
  late final TextStyle displayForthRegular;
  late final TextStyle textFieldLabel;
  late final TextStyle textFieldHint;
  late final TextStyle textFieldError;
  late final TextStyle textLabel;
  late final TextStyle textHeader;
  late final TextStyle display6W400;
  late final TextStyle display7W600;
  late final TextStyle display8W600;
  late final TextStyle display14W400;
  late final TextStyle display10W400;
  late final TextStyle display9W400;
  late final TextStyle display10W500;
  late final TextStyle display11W500;
  late final TextStyle display11W600;
  late final TextStyle display11W400;
  late final TextStyle display11W300;
  late final TextStyle display11W800;
  late final TextStyle display12W400;
  late final TextStyle display12W500;
  late final TextStyle display12W600;
  late final TextStyle display12W700;
  late final TextStyle display12W800;
  late final TextStyle display13W400;
  late final TextStyle display13W500;
  late final TextStyle display13W600;
  late final TextStyle display13W700;
  late final TextStyle display14W500;
  late final TextStyle display14W300;
  late final TextStyle display14W600;
  late final TextStyle display14W700;
  late final TextStyle display14W800;
  late final TextStyle display15W400;
  late final TextStyle display15W500;
  late final TextStyle display15W600;
  late final TextStyle display15W700;
  late final TextStyle display16W300;
  late final TextStyle display16W400;
  late final TextStyle display16W500;
  late final TextStyle display16W600;
  late final TextStyle display16W700;
  late final TextStyle display17W400;
  late final TextStyle display17W500;
  late final TextStyle display17W600;
  late final TextStyle display17W700;
  late final TextStyle display18W600;
  late final TextStyle display18W500;
  late final TextStyle display18W400;
  late final TextStyle display18W700;
  late final TextStyle display20W400;
  late final TextStyle display20W500;
  late final TextStyle display20W600;
  late final TextStyle display21W600;
  late final TextStyle display20W700;
  late final TextStyle display22W400;
  late final TextStyle display22W600;
  late final TextStyle display22W700;
  late final TextStyle display24W400;
  late final TextStyle display24W500;
  late final TextStyle display24W600;
  late final TextStyle display24W700;
  late final TextStyle display30W400;
  late final TextStyle display30W700;
  late final TextStyle display32W600;
  late final TextStyle display32W700;
  late final TextStyle display36W700;

  AppTextStyles(this.context) {
    StatusBarColorController statusBarColorController =
        Get.put(StatusBarColorController());

    ///MENU
    menuRegular = Theme.of(context!).textTheme.bodySmall!;
    menuBold = Theme.of(context!).textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.w700,
          color: statusBarColorController.isThemeDark
              ? AppColors.grayLighter
              : AppColors.black,
        );

    ///CAPTION
    captionRegular = Theme.of(context!).textTheme.bodyMedium!;
    captionBold = Theme.of(context!).textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.w700,
          color: statusBarColorController.isThemeDark
              ? AppColors.grayLighter
              : AppColors.black,
        );

    ///BODY
    bodySmallRegular = Theme.of(context!).textTheme.bodyLarge!;
    bodySmallBold = Theme.of(context!).textTheme.bodyLarge!.copyWith(
          fontWeight: FontWeight.w700,
          color: statusBarColorController.isThemeDark
              ? AppColors.grayLighter
              : AppColors.black,
        );

    bodySmallUnderlineRegular = Theme.of(context!)
        .textTheme
        .bodyLarge!
        .copyWith(
            fontWeight: FontWeight.w700,
            color: statusBarColorController.isThemeDark
                ? AppColors.grayLighter
                : AppColors.grayDark,
            decoration: TextDecoration.underline);

    bodyLargeUnderlineRegular = Theme.of(context!)
        .textTheme
        .bodyLarge!
        .copyWith(
            fontSize: AppSizes.font_16,
            fontWeight: FontWeight.w700,
            color: statusBarColorController.isThemeDark
                ? AppColors.grayLighter
                : AppColors.grayDark,
            decoration: TextDecoration.underline);

    bodyLargeRegular = Theme.of(context!).textTheme.bodyLarge!.copyWith(
          fontSize: AppSizes.font_16,
          fontFamily: BaseFonts.SFPro,
          fontWeight: FontWeight.w400,
        );

    bodyRegular = Theme.of(context!).textTheme.bodyLarge!.copyWith(
        fontSize: AppSizes.font_16,
        fontWeight: FontWeight.w600,
        color: AppColors.black);
    bodyHeadTitle = Theme.of(context!).textTheme.bodyLarge!.copyWith(
        fontSize: AppSizes.font_32,
        fontWeight: FontWeight.w600,
        fontFamily: BaseFonts.SFPro,
        color: AppColors.secondaryColor);

    bodyLargeBold = Theme.of(context!).textTheme.bodyLarge!.copyWith(
          fontSize: AppSizes.font_16,
          fontWeight: FontWeight.w700,
          color: statusBarColorController.isThemeDark
              ? AppColors.grayLighter
              : AppColors.black,
        );

    ///TITLE
    titleRegular = Theme.of(context!).textTheme.titleMedium!;
    titleBold = Theme.of(context!).textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.w700,
          color: statusBarColorController.isThemeDark
              ? AppColors.grayLighter
              : AppColors.black,
        );

    ///HEADLINE
    headlineRegular = Theme.of(context!).textTheme.headlineMedium!;
    headlineBold = Theme.of(context!).textTheme.headlineMedium!.copyWith(
          fontWeight: FontWeight.w700,
          color: statusBarColorController.isThemeDark
              ? AppColors.grayLighter
              : AppColors.black,
        );

    ///DISPLAY
    displayOneRegular = Theme.of(context!).textTheme.displaySmall!;
    displayOneBold = Theme.of(context!).textTheme.displaySmall!.copyWith(
          fontWeight: FontWeight.w700,
          color: statusBarColorController.isThemeDark
              ? AppColors.grayLighter
              : AppColors.black,
        );

    displayTwoRegular = Theme.of(context!).textTheme.displaySmall!.copyWith(
          fontSize: AppSizes.font_28,
        );
    displayTwoBold = Theme.of(context!).textTheme.displaySmall!.copyWith(
          fontWeight: FontWeight.w700,
          color: statusBarColorController.isThemeDark
              ? AppColors.grayLighter
              : AppColors.black,
          fontSize: AppSizes.font_28,
        );

    displayThreeRegular = Theme.of(context!).textTheme.displayMedium!.copyWith(
          fontSize: AppSizes.font_32,
        );
    displayThreeBold = Theme.of(context!).textTheme.displayMedium!.copyWith(
          fontWeight: FontWeight.w700,
          color: statusBarColorController.isThemeDark
              ? AppColors.grayLighter
              : AppColors.black,
          fontSize: AppSizes.font_32,
        );

    displayForthRegular = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontSize: AppSizes.font_46,
          fontWeight: FontWeight.w400,
        );
    textFieldLabel = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: AppSizes.font_14,
          fontWeight: FontWeight.w400,
        );

    textFieldHint = Theme.of(context!).textTheme.displayMedium!.copyWith(
          fontSize: AppSizes.font_12,
          fontWeight: FontWeight.w400,
          fontFamily: FontFamily.sFPro,
        );
    textFieldError = Theme.of(context!).textTheme.displayMedium!.copyWith(
          fontWeight: FontWeight.w400,
          fontFamily: FontFamily.sFPro,
          color: AppColors.danger,
          fontSize: AppSizes.font_10,
        );
    textLabel = Theme.of(context!).textTheme.displaySmall!.copyWith(
          fontWeight: FontWeight.w400,
          fontFamily: BaseFonts.SFPro,
          color: AppColors.secondaryColor,
          fontSize: AppSizes.font_12,
        );

    textHeader = Theme.of(context!).textTheme.displaySmall!.copyWith(
          fontWeight: FontWeight.w600,
          fontFamily: BaseFonts.SFPro,
          color: AppColors.secondaryColor,
          fontSize: AppSizes.font_16,
        );
    display6W400 = Theme.of(context!).textTheme.displaySmall!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 6,
          fontWeight: FontWeight.w400,
        );
    display7W600 = Theme.of(context!).textTheme.displaySmall!.copyWith(
      fontFamily: BaseFonts.SFPro,
      fontSize: 7,
      fontWeight: FontWeight.w600,
    );
    display8W600 = Theme.of(context!).textTheme.displaySmall!.copyWith(
      fontFamily: BaseFonts.SFPro,
      fontSize: 8,
      fontWeight: FontWeight.w600,
    );
    display10W400 = Theme.of(context!).textTheme.displaySmall!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 10,
          fontWeight: FontWeight.w400,
        );
    display9W400 = Theme.of(context!).textTheme.displaySmall!.copyWith(
      fontFamily: BaseFonts.SFPro,
      fontSize: 9,
      fontWeight: FontWeight.w400,
    );
    display10W500 = Theme.of(context!).textTheme.displaySmall!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        );
    display11W600 = Theme.of(context!).textTheme.displaySmall!.copyWith(
      fontFamily: BaseFonts.SFPro,
      fontSize: 11,
      fontWeight: FontWeight.w600,
    );
    display11W400 = Theme.of(context!).textTheme.displaySmall!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 11,
          fontWeight: FontWeight.w400,
        );
    display11W300 = Theme.of(context!).textTheme.displaySmall!.copyWith(
      fontFamily: BaseFonts.SFPro,
      fontSize: 11,
      fontWeight: FontWeight.w300,
    );
    display11W800 = Theme.of(context!).textTheme.displaySmall!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        );
    display11W500 = Theme.of(context!).textTheme.displaySmall!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        );

    display12W400 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        );
    display12W500 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        );
    display12W600 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        );
    display12W700 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        );
    display12W800 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        );
    display13W400 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        );
    display13W600 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        );
    display13W500 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        );
    display13W700 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        );
    display14W400 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        );
    display14W500 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: BaseFonts.SFPro,
        );
    display14W300 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w300,
          fontFamily: BaseFonts.SFPro,
        );
    display14W600 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        );
    display14W700 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        );
    display14W800 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        );
    display15W400 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        );
    display15W500 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        );
    display15W600 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        );
    display15W700 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        );
    display16W400 = Theme.of(context!).textTheme.displayLarge!.copyWith(
        fontFamily: BaseFonts.SFPro,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.secondaryColor);
    display16W300 = Theme.of(context!).textTheme.displayLarge!.copyWith(
        fontFamily: BaseFonts.SFPro,
        fontSize: 16,
        fontWeight: FontWeight.w300,
        color: AppColors.secondaryColor);

    display16W500 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        );
    display16W600 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        );
    display16W700 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        );
    display17W400 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 17,
          fontWeight: FontWeight.w400,
        );
    display17W500 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 17,
          fontWeight: FontWeight.w500,
        );
    display17W600 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        );
    display17W700 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        );
    display18W600 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        );
    display18W500 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        );
    display18W400 = Theme.of(context!).textTheme.displayLarge!.copyWith(
      fontFamily: BaseFonts.SFPro,
      fontSize: 18,
      fontWeight: FontWeight.w400,
    );
    display18W700 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        );
    display20W400 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 20,
          fontWeight: FontWeight.w400,
        );
    display20W500 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        );
    display20W600 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        );
    display20W700 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        );
    display21W600 = Theme.of(context!).textTheme.displayLarge!.copyWith(
      fontFamily: BaseFonts.SFPro,
      fontSize: 21,
      fontWeight: FontWeight.w600,
    );
    display22W400 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 22,
          fontWeight: FontWeight.w400,
        );
    display22W600 = Theme.of(context!).textTheme.displayLarge!.copyWith(
      fontFamily: BaseFonts.SFPro,
      fontSize: 22,
      fontWeight: FontWeight.w600,
    );
    display22W700 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        );

    display24W400 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 24,
          fontWeight: FontWeight.w400,
        );
    display24W500 = Theme.of(context!).textTheme.displayLarge!.copyWith(
      fontFamily: BaseFonts.SFPro,
      fontSize: 24,
      fontWeight: FontWeight.w500,
    );
    display24W600 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        );
    display24W700 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        );
    display36W700 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 30,
          fontWeight: FontWeight.w700,
        );
    display30W700 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 30,
          fontWeight: FontWeight.w700,
        );
    display32W600 = Theme.of(context!).textTheme.displayLarge!.copyWith(
      fontFamily: BaseFonts.SFPro,
      fontSize: 32,
      fontWeight: FontWeight.w600,
    );
    display32W700 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 32,
          fontWeight: FontWeight.w700,
        );
    display30W400 = Theme.of(context!).textTheme.displayLarge!.copyWith(
          fontFamily: BaseFonts.SFPro,
          fontSize: 30,
          fontWeight: FontWeight.w400,
        );
  }
}
