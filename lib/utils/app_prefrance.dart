import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_route_controller.dart';
import 'package:track_route_pro/utils/utils.dart';

import '../constants/constant.dart';

// AppPreference class for managing SharedPreferences
class AppPreference {
  static Future<SharedPreferences> get _appPref async =>
      SharedPreferences.getInstance();

  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String attemptCountKey = 'attemptCount';
  static const String alertPreferences = 'alert_preferences';

  // Save the access token
  static Future<void> saveToken(String token) async {
    final prefs = await _appPref;
    await prefs.setString(accessTokenKey, token);
  }

  // Get the access token
  static Future<String?> getToken() async {
    final prefs = await _appPref;
    return prefs.getString(accessTokenKey);
  }

  static Future<int?> getAttemptCount() async {
    return getIntFromSF(attemptCountKey);
  }

  static Future<void> incrementAttemptCount() async {
    final currentCount = await getAttemptCount();
    final newCount = currentCount != null ? currentCount + 1 : 1;
    await addIntToSF(attemptCountKey, newCount);
  }

  // Save JSON data as Base64 string in SharedPreferences
  static Future<void> saveJsonToPrefs(String key, dynamic value) async {
    final prefs = await _appPref;
    final jsonString = jsonEncode(value);
    final base64String = base64Encode(utf8.encode(jsonString));
    await prefs.setString(key, base64String);
  }

  // Get JSON data from SharedPreferences
  static Future<dynamic> getJsonFromPrefs(String key) async {
    final prefs = await _appPref;
    final base64String = prefs.getString(key);
    if (base64String != null) {
      final jsonString = utf8.decode(base64Decode(base64String));
      return jsonDecode(jsonString);
    }
    return null;
  }

  // SharedPreference helpers for string, int, double, bool, and list
  static Future<void> addStringToSF(String key, String value) async {
    final prefs = await _appPref;
    final base64String = base64Encode(utf8.encode(value));
    await prefs.setString(key, base64String);
  }

  static Future<String?> getStringFromSF(String key) async {
    final prefs = await _appPref;
    final base64String = prefs.getString(key);
    if (base64String != null) {
      return utf8.decode(base64Decode(base64String));
    }
    return null;
  }

  static Future<void> addIntToSF(String key, int value) async {
    final prefs = await _appPref;
    await prefs.setInt(key, value);
  }

  static Future<int?> getIntFromSF(String key) async {
    final prefs = await _appPref;
    return prefs.getInt(key);
  }

  static Future<void> addDoubleToSF(String key, double value) async {
    final prefs = await _appPref;
    await prefs.setDouble(key, value);
  }

  static Future<double?> getDoubleFromSF(String key) async {
    final prefs = await _appPref;
    return prefs.getDouble(key);
  }

  static Future<void> addBoolToSF(String key, bool value) async {
    final prefs = await _appPref;
    await prefs.setBool(key, value);
  }

  static Future<bool?> getBoolFromSF(String key) async {
    final prefs = await _appPref;
    return prefs.getBool(key);
  }

  static Future<void> removeFromSF(String key) async {
    final prefs = await _appPref;
    await prefs.remove(key);
  }

  static Future<void> clearSharedPreferences() async {
    final prefs = await _appPref;
    await prefs.clear();
  }

  static Future<void> removeLoginData() async {
    final prefs = await _appPref;
    await prefs.remove(accessTokenKey);
    await prefs.remove(Constants.userId);
    await prefs.remove(Constants.password);
    await prefs.remove(Constants.notification);
    await prefs.remove(Constants.name);
    await prefs.remove(Constants.email);
    await prefs.remove(Constants.otp);
    await prefs.remove(Constants.verifyEmail);
    await prefs.remove(Constants.isLogIn);
    Get.delete<TrackRouteController>();
  }
}


// DioUtil class for managing network requests
class DioUtil {
  final Dio _dioInstance = Dio(BaseOptions(
    connectTimeout: Duration(seconds: 50),
    receiveTimeout: Duration(seconds: 50),
  ));

  Dio getDio({bool? useAccessToken}) {
    _dioInstance.interceptors.clear(); // Clear existing interceptors

    // Add PrettyDioLogger for logging
    _dioInstance.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      compact: false,
    ));

    // Add authorization header if useAccessToken is true
    if (useAccessToken ?? false) {
      _dioInstance.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken =
              await AppPreference.getStringFromSF(AppPreference.accessTokenKey);
              // await AppPreference.getStringFromSF(AppPreference.accessTokenKey);

          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options); // Continue request
        },
        onResponse: (response, handler) => handler.next(response),
        onError: (error, handler) async {
          // Handle 401 error for refreshing token
          if (error.response?.statusCode == 401 &&
              error.requestOptions.path != 'auth/refresh-token') {
            final success = await postRefreshToken();
            if (success) {
              final newToken = await AppPreference.getStringFromSF(
                AppPreference.accessTokenKey,);
              error.requestOptions.headers['Authorization'] =
                  'Bearer $newToken';
              final clonedRequest = await _dioInstance.request<dynamic>(
                error.requestOptions.path,
                options: Options(
                  method: error.requestOptions.method,
                  headers: error.requestOptions.headers,
                ),
              );
              return handler.resolve(clonedRequest);
            }
          }
          return handler.next(error);
        },
      ));
    }

    return _dioInstance;
  }
}

// Function to refresh token
Future<bool> postRefreshToken() async {
  try {
    final refreshToken =
        await AppPreference.getStringFromSF(AppPreference.refreshTokenKey);
    if (refreshToken != null) {
      // Call API to refresh the token
      final response = await DioUtil()
          .getDio()
          .post('/auth/refresh-token', data: {'refresh_token': refreshToken});
      if (response.statusCode == 200) {
        final newTokenData = response.data;
        await AppPreference.addStringToSF(
            AppPreference.accessTokenKey, newTokenData['access_token']);
        await AppPreference.addStringToSF(
            AppPreference.refreshTokenKey, newTokenData['refresh_token']);
        return true;
      }
    }
  } catch (e) {
    // Handle error
  }
  return false;
}

// ServiceError class for handling API errors
class ServiceError {
  String getError(String res) {
    if (Get.isSnackbarOpen) {
      Utils.getSnackbar('Error', 'No internet connection.');
    }
    try {
      final jsonResponse = jsonDecode(res);
      if (jsonResponse != null) {
        final apiError = ApiErrorModel.fromJson(jsonResponse);
        return apiError.message ?? 'Unknown error occurred';
      }
    } catch (e) {
      return 'Something went wrong.';
    }
    return 'Unknown error occurred';
  }
}

class ApiErrorModel {
  bool? success;
  String? error;
  String? message;
  int? status;

  ApiErrorModel({this.success, this.error, this.message, this.status});

  ApiErrorModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] as bool?;
    error = json['error']?.toString();
    message = json['message']?.toString();
    status = json['status'] as int?;
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'error': error,
      'message': message,
      'status': status,
    };
  }
}
