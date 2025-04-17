import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:track_route_pro/constants/constant.dart';
import 'package:track_route_pro/constants/project_urls.dart';
import 'package:track_route_pro/firebase_controller.dart';
import 'package:track_route_pro/modules/login_screen/view/widget/banner.dart';
import 'package:track_route_pro/modules/profile/controller/profile_controller.dart';
import 'package:track_route_pro/routes/app_pages.dart';
import 'package:track_route_pro/service/api_service/api_service.dart';
import 'package:track_route_pro/service/model/auth/FirebaseUpdateRequest.dart';
import 'package:track_route_pro/service/model/presentation/splsh_add/splash_add.dart';
import 'package:track_route_pro/utils/app_prefrance.dart';
import 'package:track_route_pro/utils/common_import.dart';
import 'package:track_route_pro/utils/enums.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Rx<NetworkStatus> networkStatus = Rx(NetworkStatus.IDLE);
  final profileController = Get.put(ProfileController());
  ApiService apiService = ApiService.create();
  final dio = Dio();
  RxBool obscureText = RxBool(true); // Default to hide password
  RxBool showLoader = RxBool(false);
  bool isChangeRememberMe = false;
  RxString errorEmail = ''.obs;
  RxString errorPassword = ''.obs;
  RxBool isWrongUser = RxBool(false);
  RxString userId = RxString('');

  Rx<SplashAddResponse> splashAddResponse = Rx(SplashAddResponse());

  @override
  void onInit() {
    super.onInit();
  }

  void validateEmail(AppLocalizations localizations) {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      isWrongUser.value = true;
      errorEmail.value = localizations.pleaseEmail;
    } else if (!GetUtils.isEmail(email)) {
      isWrongUser.value = true;
      errorEmail.value = localizations.pleaseValidEmail;
    } else {
      errorEmail.value = '';
      if(errorPassword.value.isEmpty){
        isWrongUser.value = false;
      }
    }
  }

  void validatePassword(AppLocalizations localizations) {
    final password = passwordController.text;
    if (password.isEmpty) {
      isWrongUser.value = true;
      errorPassword.value = localizations.pleasePassword;
    } else if (password.length < 2) {
      isWrongUser.value = true;
      errorPassword.value = localizations.pleaseValidPassword;
    } else {
      errorPassword.value = '';
      if(errorEmail.value.isEmpty){
        isWrongUser.value = false;
      }
    }
  }

  // Updated function to check credentials and make an API call
  // Updated function to check credentials and make an API call
  Future<void> checkCredentials(AppLocalizations localizations) async {
    isWrongUser.value = false;
    validateEmail(localizations);
    validatePassword(localizations);

    if (errorEmail.value.isEmpty && errorPassword.value.isEmpty) {
      try {
        networkStatus.value = NetworkStatus.LOADING;

        final body = {
          'emailAddress': emailController.text.trim(),
          'password': passwordController.text,
        };
        showLoader.value=true;
        // Call the login API
        final response = await apiService.login(body);

        // Handle successful login response
        if (response.status == 200) {
          // Assuming token or other login details are needed, handle it here
          // print('Login successful: ${response.token}');
          userId.value = response.data?.sId ?? '';
          // profileController.userProfile.value = response;
          await AppPreference.addStringToSF(
              AppPreference.accessTokenKey, response.token ?? '');
          await AppPreference.addStringToSF(
              Constants.userId, response.data?.sId ?? '');
          await AppPreference.addBoolToSF(
              Constants.isLogIn, true);
          AppPreference.addStringToSF(
              Constants.email, response.data?.emailAddress ?? '');
          AppPreference.addStringToSF(
              Constants.name, response.data?.name ?? '');
          AppPreference.addStringToSF(
              Constants.phone, response.data?.phone ?? '');
          AppPreference.addIntToSF(
              Constants.password, (response.data?.len ?? 0));
          await AppPreference.addBoolToSF(
              Constants.notification, response.data?.notification ?? true);
          sendTokenData();

          // fetchSplashData();
          Get.offAllNamed(Routes.BOTTOMBAR); // Navigate to bottom bar page
        } else {
          // If login fails, show the error message
          // print('Login failed: ${response.message}   STATUS => ${response.status}');
          isWrongUser.value = true;
        }

        networkStatus.value = NetworkStatus.SUCCESS;
      } catch (e, s) {
        // Handle errors during API call
        networkStatus.value = NetworkStatus.ERROR;
        // print('Error during login: $e  $s');
        isWrongUser.value = true;
      }
    } else {
      // Show validation errors in case email/password are invalid
      // print('Email or password validation failed');
    }
    showLoader.value=false;
  }

  // Function to fetch splash data from the API
  Future<void> fetchSplashData() async {
    try {
      networkStatus.value =
          NetworkStatus.LOADING;
      final dio = Dio();

      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          // Log the request details
         /* print('Request URL: ${options.uri}');
          print('Request Headers: ${options.headers}');
          print('Request Method: ${options.method}');
          print('Request Data: ${options.data}');*/
          return handler.next(options); // Continue with the request
        },
        onResponse: (response, handler) {
          // Log the response details
         /* print('Response Status Code: ${response.statusCode}');
          print('Response Data: ${response.data}');*/
          return handler.next(response); // Continue with the response
        },
        onError: (DioError e, handler) {
          // Log any error that occurs
          // print('Error: ${e.message}');
          if (e.response != null) {
          /*  print('Error Response Status Code: ${e.response?.statusCode}');
            print('Error Response Data: ${e.response?.data}');*/
          }
          return handler.next(e); // Continue with error handling
        },
      ));
      try {

        // debugPrint("fetch splash data ");

        final accessToken =
        await AppPreference.getStringFromSF(AppPreference.accessTokenKey,);
        var res = await dio.request(
          '${ProjectUrls.baseUrl}${ProjectUrls.splashAdd}',
          options: Options(
            method: 'POST',
            headers: {
              // 'Authorization':
              // 'Bearer $accessToken',
              'content-Type': 'application/json'
            },
          ),
        );
        // debugPrint("fetch splash data ");


        if (res.statusCode == 200) {
          // Assuming the response is in JSON format
          final data = res.data;

          // Parse the data into ManageSettingModel
          SplashAddResponse response = SplashAddResponse.fromJson(data);
          // print('Settings parsed successfully: ${response.toString()}');
          // Now you can use 'settings' object as needed

          if (res.data.isNotEmpty) {
            networkStatus.value = NetworkStatus.SUCCESS;
            splashAddResponse.value = response;
            showActiveAds(response.data);
          }
        } else {
          // print('Failed with status code: ${res.statusCode}');
        }
      } on DioException catch (e) {
        // print("SPLASH ADD ERROR $e");
      }

      // var response = await apiService.splashAdd();

      // debugPrint("fetch splash data $response");

    } catch (e) {
      networkStatus.value = NetworkStatus.ERROR;

      // print('Error: $e');
    }
  }

  // Function to fetch splash data from the API
  Future<void> sendTokenData({isLogout=false}) async {
    final fcmController = Get.isRegistered<FirebaseNotificationService>()
        ? Get.find<FirebaseNotificationService>() // Find if already registered
        : Get.put(FirebaseNotificationService());
    final fcmToken = await fcmController.getFcmToken();
    // final fcmToken = await AppPreference.getStringFromSF(Constants.fcmToken);
    userId.value = await AppPreference.getStringFromSF(Constants.userId) ?? "";

    if(userId.value.isNotEmpty){
      try {
        networkStatus.value =
            NetworkStatus.LOADING;

        var request = FirebaseUpdateRequest(id: userId.value, firebaseToken: fcmToken);

        if(isLogout){
           request.isLogout = true;  }
        // debugPrint("FIREBASE REQUEST ===> $request");
        var response = await apiService
            .sendTokenData(request);
            // log("FCM TOKEN $response");
        // Assuming you handle the response in a similar way
        if (response.message?.isNotEmpty ?? false) {
          networkStatus.value = NetworkStatus.SUCCESS;
        }
      } catch (e) {
        networkStatus.value = NetworkStatus.ERROR;

        // print('Error: $e');
      }
    }
  }

  void showActiveAds(List<SplashAddData> data) {
    // Iterate through the data list
    for (var item in data) {
      if (item.status == 'Active') {
        Future.delayed(Duration.zero, () {
          Get.dialog(
            AdvertiseBanner(
              child: Expanded(
                child: InkWell(
                  onTap: () async {
                    final url = item.hyperLink ?? '';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Container(
                    child: CachedNetworkImage(
                      fit: BoxFit.contain,
                      progressIndicatorBuilder: (context, url, progress) =>
                          Center(
                            child: CircularProgressIndicator(
                              value: progress.progress,
                            ),
                          ),
                      imageUrl: '${ProjectUrls.imgBaseUrl}${item.image}',
                    ),
                  ),
                ),
              ),
            ),
            barrierDismissible: true,
            barrierColor: Colors.black.withOpacity(0.6)
          );
        });
        break; // Break after showing the first active ad
      }
    }
  }

}

