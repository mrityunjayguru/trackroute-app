// ignore_for_file: depend_on_referenced_packages, constant_identifier_names

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Constants {
  //static const String userAccessTokenKey = 'USER_ACCESS_TOKEN';
  static const String userAccessTokenKey = 'access_token';
  static const String userId = 'userId';
  // static const String apiToken = '';
  static const String otp = 'otp';
  static const String verifyEmail = 'verifyEmail';
  static const String refreshTokenKey = 'refresh_token';
  static const int laborsPageSize = 10;
  static const String PROFILE = "Profile";
  static const String email = "email";
  static const String forgotemail = "forgotemail";
  static const String newPass = "newPass";
  static const String name = "name";
  static const String fcmToken = "Profile";
  static const String googleApiKey = "AIzaSyChD5d2MJHsO0tWn-7c8EixTETIqauqJrw";
  static const String phone = "phone";
  static const String password = "password";
  static const String notification = "notification";
  static const String isLogIn = "is_log_in";

  ///
  static const String selectedLanguage = "SELECTED_LANGUAGE";
  static const String lanAm = "am";
  static const String lanEn = "en";

  static const String REFRESHER_STATE = "REFRESHER_STATE";

  static String languageDataBox = "language_BaseData_Box";
}

DateTime stringToDate(String dateString) {
  try {
    var dt = DateTime.fromMillisecondsSinceEpoch(int.parse(dateString));
    var date = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z").format(dt);
    var convertedDate = DateTime.parse(date);
    return convertedDate;
  } catch (e) {
    throw Exception("Invalid Date Format");
  }
}

getDayName(DateTime date) {
  return DateFormat('EEE').format(date);
}

getDate(DateTime date) {
  return DateFormat('dd/MM/yyy a HH:mm').format(date);
}

getDateDDMMYYYY(DateTime date) {
  return DateFormat('dd/MM/yyy').format(date);
}

void appPrint(object) {
  if (kDebugMode) {
    log("$object");
  }
}
