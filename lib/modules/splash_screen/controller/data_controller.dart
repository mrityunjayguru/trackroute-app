import 'package:get/get.dart';
import 'package:track_route_pro/utils/enums.dart';

import '../../../service/api_service/api_service.dart';
import '../../../service/model/auth/Data.dart';
import '../../../utils/common_import.dart';

class DataController extends GetxController {
  Rx<NetworkStatus> networkStatus = Rx(NetworkStatus.IDLE);
  Rx<DataSetting> settings = Rx(DataSetting());
  ApiService apiservice = ApiService.create();

  void onInit() {
    super.onInit();

    getInitData();
  }

  Future<void> getInitData() async {
    var response;
    try {
      networkStatus.value =
          NetworkStatus.LOADING; // Set network status to loading

      response = await apiservice.manageSettings();
      // Assuming you handle the response in a similar way
      if (response.status == 200) {
        networkStatus.value = NetworkStatus.SUCCESS;
        settings.value = response.data[0];
        // AppPreference.addStringToSF(
        //     Constants.contactPasswd, settings.value.mobileSupport);
      }
    } catch (e) {
      debugPrint("EXCEPTION $e");
      networkStatus.value = NetworkStatus.ERROR;
    }
  }
}
// Get.offAllNamed(Routes.LOGIN)Get.offAllNamed(Routes.LOGIN)
