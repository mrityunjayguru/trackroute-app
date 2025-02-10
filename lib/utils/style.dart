import 'package:flutter/material.dart';

import '../config/theme/app_colors.dart';

const fontFamily = "SF-Pro";

final TextStyle text12SemiBold = TextStyle(
    overflow: TextOverflow.ellipsis,
    fontFamily: fontFamily,
    decoration: TextDecoration.none,
    fontWeight: FontWeight.w600,
    fontSize: 12,
    color: AppColors.textBlackColor,
    height: 0);
final TextStyle text10Medium = TextStyle(
    overflow: TextOverflow.ellipsis,
    fontFamily: fontFamily,
    decoration: TextDecoration.none,
    fontWeight: FontWeight.w500,
    fontSize: 10,
    color: AppColors.textBlackColor,
    height: 0);
final TextStyle text10Regular = TextStyle(
    overflow: TextOverflow.ellipsis,
    fontFamily: fontFamily,
    decoration: TextDecoration.none,
    fontWeight: FontWeight.w400,
    fontSize: 10,
    color: AppColors.textBlackColor,
    height: 0);
final TextStyle text20Medium = TextStyle(
    overflow: TextOverflow.ellipsis,
    fontFamily: fontFamily,
    decoration: TextDecoration.none,
    fontWeight: FontWeight.w500,
    fontSize: 20,
    color: AppColors.textBlackColor,
    height: 0);
final TextStyle text20Semi = TextStyle(
    overflow: TextOverflow.ellipsis,
    fontFamily: fontFamily,
    decoration: TextDecoration.none,
    fontWeight: FontWeight.w600,
    fontSize: 20,
    color: AppColors.textBlackColor,
    height: 0);
final TextStyle text16Medium = TextStyle(
    overflow: TextOverflow.ellipsis,
    fontFamily: fontFamily,
    decoration: TextDecoration.none,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: AppColors.textBlackColor,
    height: 0);

final TextStyle text10Bold = TextStyle(
    overflow: TextOverflow.ellipsis,
    fontFamily: fontFamily,
    decoration: TextDecoration.none,
    fontWeight: FontWeight.w700,
    fontSize: 10,
    color: AppColors.textBlackColor,
    height: 0);

final TextStyle text12ExtraBold = TextStyle(
    overflow: TextOverflow.ellipsis,
    fontFamily: fontFamily,
    decoration: TextDecoration.none,
    fontWeight: FontWeight.w800,
    fontSize: 12,
    color: AppColors.textBlackColor,
    height: 0);

final TextStyle text12Bold = TextStyle(
    overflow: TextOverflow.ellipsis,
    fontFamily: fontFamily,
    decoration: TextDecoration.none,
    fontWeight: FontWeight.w700,
    fontSize: 12,
    color: AppColors.textBlackColor,
    height: 0);

final TextStyle text16Bold = TextStyle(
    overflow: TextOverflow.ellipsis,
    fontFamily: fontFamily,
    decoration: TextDecoration.none,
    fontWeight: FontWeight.w700,
    fontSize: 16,
    color: AppColors.textBlackColor,
    height: 0);

final TextStyle text10SemiBold = TextStyle(
    overflow: TextOverflow.ellipsis,
    fontFamily: fontFamily,
    decoration: TextDecoration.none,
    fontWeight: FontWeight.w600,
    fontSize: 10,
    color: AppColors.textBlackColor,
    height: 0);
final TextStyle text14Regular = TextStyle(
    overflow: TextOverflow.ellipsis,
    fontFamily: fontFamily,
    decoration: TextDecoration.none,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColors.textBlackColor,
    height: 0);

///
/// App Bar style
///
final TextStyle appBarStyle = TextStyle(
  decoration: TextDecoration.none,
  fontWeight: FontWeight.w500,
  fontSize: 20,
  fontFamily: fontFamily,
  color: AppColors.textBlackColor,
  overflow: TextOverflow.ellipsis,
);

///
///
final TextStyle textThin = TextStyle(
  decoration: TextDecoration.none,
  fontWeight: FontWeight.w100,
  fontSize: 16,
  color: AppColors.black,
);

final TextStyle textExtraLight = TextStyle(
  decoration: TextDecoration.none,
  fontWeight: FontWeight.w200,
  fontSize: 16,
  color: AppColors.black,
  overflow: TextOverflow.ellipsis,
);
final TextStyle textLight = TextStyle(
  decoration: TextDecoration.none,
  fontWeight: FontWeight.w300,
  fontSize: 16,
  color: AppColors.black,
  overflow: TextOverflow.ellipsis,
);
final TextStyle textRegular = TextStyle(
  decoration: TextDecoration.none,
  fontWeight: FontWeight.w400,
  fontSize: 16,
  color: AppColors.black,
  overflow: TextOverflow.ellipsis,
);
final TextStyle textMedium = TextStyle(
  decoration: TextDecoration.none,
  fontWeight: FontWeight.w500,
  fontSize: 16,
  overflow: TextOverflow.ellipsis,
);
final TextStyle textSemiBold = TextStyle(
  decoration: TextDecoration.none,
  fontWeight: FontWeight.w600,
  fontSize: 16,
  overflow: TextOverflow.ellipsis,
);
final TextStyle textBold = TextStyle(
  decoration: TextDecoration.none,
  fontWeight: FontWeight.w700,
  fontSize: 16,
  overflow: TextOverflow.ellipsis,
);
final TextStyle textExtraBold = TextStyle(
  decoration: TextDecoration.none,
  fontWeight: FontWeight.w800,
  fontSize: 16,
  overflow: TextOverflow.ellipsis,
);
final TextStyle textBlack = TextStyle(
  decoration: TextDecoration.none,
  fontWeight: FontWeight.w900,
  fontSize: 26,
  overflow: TextOverflow.ellipsis,
);

TextStyle text12Regular({
  Color color = AppColors.textBlackColor,
  double? height,
}) =>
    TextStyle(
      decoration: TextDecoration.none,
      fontWeight: FontWeight.w400,
      fontSize: 12,
      fontFamily: fontFamily,
      color: color,
      height: height,
      overflow: TextOverflow.ellipsis,
    );

TextStyle text12Semi({
  Color color = AppColors.textBlackColor,
  double? height,
}) =>
    TextStyle(
      decoration: TextDecoration.none,
      fontWeight: FontWeight.w600,
      fontSize: 12,
      fontFamily: fontFamily,
      color: color,
      height: height,
      overflow: TextOverflow.ellipsis,
    );

TextStyle text12Medium({
  Color color = AppColors.textBlackColor,
  double? height,
}) =>
    TextStyle(
      decoration: TextDecoration.none,
      fontWeight: FontWeight.w500,
      fontSize: 12,
      fontFamily: fontFamily,
      color: color,
      height: height,
      overflow: TextOverflow.ellipsis,
    );

TextStyle text16Semi({
  Color color = AppColors.textBlackColor,
  double? height,
}) =>
    TextStyle(
      decoration: TextDecoration.none,
      fontWeight: FontWeight.w600,
      fontSize: 16,
      fontFamily: fontFamily,
      color: color,
      height: height,
      overflow: TextOverflow.ellipsis,
    );

TextStyle text16Regular({
  Color color = AppColors.textBlackColor,
  double? height,
}) =>
    TextStyle(
      decoration: TextDecoration.none,
      fontWeight: FontWeight.w400,
      fontSize: 16,
      fontFamily: fontFamily,
      color: color,
      height: height,
      overflow: TextOverflow.ellipsis,
    );
TextStyle text14Semi({
  Color color = AppColors.textBlackColor,
  double? height,
}) =>
    TextStyle(
      decoration: TextDecoration.none,
      fontWeight: FontWeight.w600,
      fontSize: 14,
      fontFamily: fontFamily,
      color: color,
      height: height,
      overflow: TextOverflow.ellipsis,
    );