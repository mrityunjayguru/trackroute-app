import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/app_sizer.dart';
import '../config/theme/app_colors.dart';
import '../config/theme/app_textstyle.dart';
import '../constants/project_urls.dart';
import '../gen/assets.gen.dart';
import '../modules/splash_screen/controller/data_controller.dart';
import 'common_import.dart';

class Utils{
  final dataController = Get.isRegistered<DataController>()
      ? Get.find<DataController>() // Find if already registered
      : Get.put(DataController());

  static Future openDialog({
    required BuildContext context,
    required Widget child,
  }) async {
    await showDialog(
      barrierDismissible: true,
      context: context,
      useRootNavigator: false,
      builder: (context) {
        return ScaffoldMessenger(
          child: Builder(builder: (context) {
            return Scaffold(
              backgroundColor: AppColors.transparent,
              body: Dialog(
                backgroundColor: AppColors.color_f6f8fc,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: child.paddingAll(0),
              ),
            );
          }),
        );
      },
    );
  }

  Widget filterOption(
      {required BuildContext context,
        required String img,
        required int count,
        required String title,
        required bool isSelected}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.selextedindexcolor : AppColors.whiteOff,
        borderRadius: BorderRadius.circular(AppSizes.radius_50),
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            spreadRadius: 0,
            color: const Color(0xff000000).withOpacity(0.25),
            offset: Offset(0, 0),
          ),

        ],
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            img,
          ),
          SizedBox(width: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles(context).display12W500,
              ),
              SizedBox(width: 1.w),
              Text(
                "(${count.toString()})",
                style: AppTextStyles(context).display12W500,
              ),
            ],
          ),
        ],
      ).paddingSymmetric(horizontal: 2.w, vertical: 1.h),
    );
  }
   Widget topBar({
    required VoidCallback onTap,
    required String name,
    required String rightIcon,
    required BuildContext context,  Widget? rightWidget,
  }) {
    return  GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height < 670 ? 7.h : 6.h, // Increase height for smaller screens
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radius_50),
          color: AppColors.black,
        ),
        child: Row(
          children: [
            Obx(()=>
               Image.network(
                  width: 25,
                  height: 25,
                  "${ProjectUrls.imgBaseUrl}${dataController.settings.value.logo}",
                  errorBuilder: (context, error, stackTrace) =>
                      SvgPicture.asset(
                        Assets.images.svg.icIsolationMode,
                        color: AppColors.black,
                      )).paddingSymmetric(horizontal: 10),
            ),
            Expanded(
              child: Text(
               name,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles(context)
                    .display20W400
                    .copyWith(color: AppColors.whiteOff),
              ),
            ),
            rightWidget!=null ? rightWidget :
            SvgPicture.asset(rightIcon)
                .paddingOnly(right: 12, left: 7.w)
          ],
        ).paddingOnly(left: 8, right: 8),
      ),
    );
  }
  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    try {
      if (!await launchUrl(launchUri)) {
        throw 'Could not launch $launchUri';
      }
    } on PlatformException catch (e) {
      // print('Error: $e'); // Log the error to the console for debugging
    }
  }

  static Future<void> launchLink(String url,{bool showError = false}) async {
    if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
    } else {
      if(showError){
        Utils.getSnackbar(
            "Error", "Unable to fetch report, Please try later");
      }
    throw 'Could not launch $url';
    }
  }

  static void getSnackbar(String title, String message){
    Get.snackbar(title, message, backgroundColor: AppColors.black, colorText: AppColors.selextedindexcolor,snackPosition: SnackPosition.BOTTOM);
  }

  static String toStringAsFixed({String? data}){
    return data==null? "N/A" : (double.tryParse(data) ?? 0).toStringAsFixed(1);
  }

  static  formatInt({String? data}){
    return data==null? "N/A" : (double.tryParse(data) ?? 0).toInt().toString();
  }

  static double parseDouble({String? data}){

    return data==null ? 0 : (double.tryParse(data) ?? 0);
  }

  static FilteringTextInputFormatter percentageFormatter() {
    return FilteringTextInputFormatter.allow(
      RegExp(r'^(100(\.0{0,2})?|([1-9]?[0-9])(\.\d{0,2})?)$'),
    );
  }

  static FilteringTextInputFormatter doubleFormatter() {
    return FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'));
  }

  static FilteringTextInputFormatter numLetterFormatter() {
    return FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'));
  }

  static TextInputFormatter intFormatter() {
    return FilteringTextInputFormatter.digitsOnly;
  }

  Future<String> getAddressFromLatLong(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];

      return "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
    } catch (e) {
      return "Address not available";
    }
    return "Address not available";
  }

  String formatDate(String? dateStr) {
    if (dateStr == null) return ''; // Handle null case
    try {
      // Parse the date string to a DateTime object
      DateTime dateTime = DateTime.parse(dateStr);
      // Format the date as dd-mm-yyyy
      return DateFormat('dd-MM-yyyy').format(dateTime);
    } catch (e) {
      return '-'; // Handle parsing error
    }
  }
}