import 'package:get/get.dart';
import 'package:track_route_pro/constants/constant.dart';
import 'package:track_route_pro/modules/login_screen/controller/login_controller.dart';
import 'package:track_route_pro/routes/app_pages.dart';
import 'package:track_route_pro/service/model/auth/ManageSettingModel.dart';
import 'package:track_route_pro/utils/app_prefrance.dart';
import 'package:track_route_pro/utils/enums.dart';

import '../../../service/api_service/api_service.dart';
import '../../../service/model/auth/Data.dart';
import '../../../utils/common_import.dart';
import 'data_controller.dart'; // Make sure this imports your app routes

class SplashController extends GetxController {
  Rx<NetworkStatus> networkStatus = Rx(NetworkStatus.IDLE);
  Rx<DataSetting> settings = Rx(DataSetting());
  ApiService apiservice = ApiService.create();
  @override
  void onInit() {
    super.onInit();

    checkTokenAndNavigate();

  }

  void checkTokenAndNavigate() async {
    // Delay for 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    // Check if the API token exists in AppPreference
    String? apiToken = await AppPreference.getStringFromSF(AppPreference.accessTokenKey);
    debugPrint("API TOKEN ========> $apiToken");
    if (apiToken != null && apiToken.isNotEmpty) {
      // If token exists, navigate to BottomBar

      Get.offNamed(Routes.BOTTOMBAR);
    } else {
      // If token doesn't exist, navigate to LoginScreen
      Get.offNamed(Routes.LOGIN);
    }
    Get.put(LoginController()).fetchSplashData();
  }

}
// Get.offAllNamed(Routes.LOGIN)Get.offAllNamed(Routes.LOGIN)