import 'package:track_route_pro/constants/constant.dart';
import 'package:track_route_pro/service/api_service/api_service.dart';
import 'package:track_route_pro/utils/app_prefrance.dart';
import 'package:track_route_pro/utils/common_import.dart';
import 'package:track_route_pro/utils/enums.dart';

import '../../../utils/utils.dart';

class SupportController extends GetxController {
  ApiService apiservice = ApiService.create();
  Rx<NetworkStatus> networkStatus = Rx(NetworkStatus.IDLE);
  TextEditingController deviceID = TextEditingController();
  TextEditingController subject = TextEditingController();
  TextEditingController description = TextEditingController();
  RxString userEmail = ''.obs;
  RxString userId = ''.obs;
  RxBool isSucessSubmit = RxBool(false);
  RxString selectedVehicleName = RxString('');
  RxBool vehicleSelected = RxBool(false);
  RxBool showLoader = RxBool(false);
  RxBool isExpanded = RxBool(false);
  RxInt selectedIndex = RxInt(0);
  RxInt selectedVehicleIndex = RxInt(-1);
  @override
  void onInit() {
    super.onInit();
    loadUserEmail();
  }

  Future<void> loadUserEmail() async {
    String? email = await AppPreference.getStringFromSF(Constants.email);
    String? sid = await AppPreference.getStringFromSF(Constants.userId);
    userEmail.value = email ?? '';
    userId.value = sid ?? "";
  }

  Future<void> submitSupportRequest() async {
    var supportRequest;
    if(selectedVehicleName.isEmpty && deviceID.text.isEmpty){
      Utils.getSnackbar("Error", "Please select vehicle or enter the imei");
      return;
    }
    if(description.text.trim().isEmpty){
      Utils.getSnackbar("Error", "Please enter description");
      return;
    }

    if(selectedVehicleName.isEmpty){
       supportRequest = {
        "imei": deviceID.text,
        "suport": subject.text.trim(),
        "description": description.text.trim(),
        "userID": userId.value
      };
    }
    else if(deviceID.text.isEmpty){
      supportRequest  = {
        "vehicleNo": selectedVehicleName.value,
        "suport": subject.text,
        "description": description.text,
        "userID": userId.value
      };
    }
    if(selectedVehicleName.isNotEmpty && deviceID.text.isNotEmpty){
       supportRequest = {
        "imei": deviceID.text,
        "vehicleNo": selectedVehicleName.value,
        "suport": subject.text,
        "description": description.text,
        "userID": userId.value
      };
    }

    networkStatus.value = NetworkStatus.LOADING;
    try {
      showLoader.value = true;
      final response = await apiservice.support(supportRequest);

      if (response.status == 200) {
        isSucessSubmit.value = true;
        deviceID.clear();
        subject.clear();
        description.clear();
        networkStatus.value = NetworkStatus.SUCCESS;
      } else {

        networkStatus.value = NetworkStatus.ERROR;
      }
    } catch (error,s) {
      debugPrint("ERROR SUPPORT $error $s");
      Utils.getSnackbar("Error", "Something went wrong");
      networkStatus.value = NetworkStatus.ERROR;
    }
    showLoader.value = false;
  }

  void filterAlerts(bool isSelected, String vehicleNo, int index) {
    isExpanded.value = false;
    vehicleSelected.value = isSelected;
    if (isSelected) {
      selectedVehicleName.value = vehicleNo;
      selectedVehicleIndex.value = index;

    } else {
      selectedVehicleName.value = "";
      selectedVehicleIndex.value = -1;

    }

  }
}
