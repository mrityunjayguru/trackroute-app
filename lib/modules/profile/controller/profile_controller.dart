import 'dart:developer';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:track_route_pro/service/model/auth/login/login_response.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../../constants/constant.dart';
import '../../../service/api_service/api_service.dart';
import '../../../service/model/presentation/track_route/track_route_vehicle_list.dart';
import '../../../utils/app_prefrance.dart';
import '../../../utils/enums.dart';
import '../../../utils/utils.dart';
import '../../track_route_screen/controller/track_route_controller.dart';

class ProfileController extends GetxController {
  RxBool isReNewSub = RxBool(false);
  RxSet<int> selectedVehicleIndex = <int>{}.obs;
  RxString name = "-".obs;
  RxString email = "-".obs;
  RxString phone = "-".obs;
  RxInt password = 0.obs;
  RxList<Data> expiringVehicles = <Data>[].obs;
  ApiService apiservice = ApiService.create();

  RxString appVersion = "".obs;
  Rx<NetworkStatus> networkStatus = Rx(NetworkStatus.IDLE);

  void checkForRenewal({String? selectVehicle}) {
    final trackRouteController = Get.isRegistered<TrackRouteController>()
        ? Get.find<TrackRouteController>() // Find if already registered
        : Get.put(TrackRouteController());

    expiringVehicles.value =
        trackRouteController.getVehiclesWithExpiringSubscriptions();
    if (selectVehicle != null) {
      int? val = expiringVehicles.indexWhere(
        (element) => element.imei == selectVehicle,
      );
      if (val != null && val != -1) {
        selectedVehicleIndex.value.add(val);
      }
    }
  }

  @override
  void onInit() async {
    super.onInit();
    name.value = await AppPreference.getStringFromSF(Constants.name) ?? "-";
    email.value = await AppPreference.getStringFromSF(Constants.email) ?? "-";
    phone.value = await AppPreference.getStringFromSF(Constants.phone) ?? "-";
    password.value = await AppPreference.getIntFromSF(Constants.password) ?? 0;
  }

  void toggleVehicleSelection(int index) {
    if (selectedVehicleIndex.value.contains(index)) {
     selectedVehicleIndex.value.remove(index);

    } else {
      selectedVehicleIndex.value.add(index);
    }
    selectedVehicleIndex.value = selectedVehicleIndex.value;
  }

  Future<void> renewService({String? id}) async {
    var response;
    try {
      networkStatus.value =
          NetworkStatus.LOADING; // Set network status to loading
      Map<String, dynamic> body = {};

      selectedVehicleIndex.value.removeWhere((element) => (expiringVehicles.value[element].isApplied ?? 50) < 48.01);
      if (selectedVehicleIndex.value.isNotEmpty) {
        List<String> imeiNo = [];
        for (int index in selectedVehicleIndex.value) {
          if (index >= 0 && index < expiringVehicles.length) {
            imeiNo.add(expiringVehicles[index].imei ??
                ""); // Adjust to the correct field if needed
          }
        }
        body = {"imei": imeiNo};
        isReNewSub.value = false;

        response = await apiservice.renewSubscription(body);
        // Assuming you handle the response in a similar way
        if (response.status == 200) {
          selectedVehicleIndex.clear();
          networkStatus.value = NetworkStatus.SUCCESS;
          final controller = Get.isRegistered<TrackRouteController>()
              ? Get.find<TrackRouteController>() // Find if already registered
              : Get.put(TrackRouteController());
          controller.devicesByOwnerID(false);
          Utils.getSnackbar('Success', 'Generated request for renewal');
        } else {
          Utils.getSnackbar('Error', '${response.message}');
        }
      } else {
        Utils.getSnackbar("Error", "Please select an item for renewal");
      }


    } catch (e) {
      networkStatus.value = NetworkStatus.ERROR;
      Utils.getSnackbar("Error", "Please try after 24 hours");
      print('Error: $e');
    }
  }
}
