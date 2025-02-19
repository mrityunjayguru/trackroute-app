import 'package:track_route_pro/service/api_service/api_service.dart';
import 'package:track_route_pro/service/model/privacy_policy/PrivacyPolicyResponse.dart';
import 'package:track_route_pro/utils/common_import.dart';
import 'package:track_route_pro/utils/enums.dart';

class PrivacyPolicyController extends GetxController {
  ApiService apiservice = ApiService.create();
  RxList<PrivacyPolicyResponse> data = <PrivacyPolicyResponse>[].obs;
  RxList<PrivacyPolicyResponse> termsCondition = <PrivacyPolicyResponse>[].obs;
  Rx<NetworkStatus> networkStatus = Rx(NetworkStatus.IDLE);

  @override
  void onInit() {
    super.onInit();
    fetchData();
    fetchDataTerms();
  }

  // Method to fetch About Us data
  Future<void> fetchData() async {
    try {
      networkStatus.value = NetworkStatus.LOADING;
      var response = await apiservice.privacyPolicy();
      data.value = response.data ?? [];
      networkStatus.value = NetworkStatus.SUCCESS;
    } catch (e) {
      networkStatus.value = NetworkStatus.ERROR;
      // print("Error fetching privacy policy data: $e");
    }
  }

  Future<void> fetchDataTerms() async {
    try {
      networkStatus.value = NetworkStatus.LOADING;
      var response = await apiservice.termsCondition();
      termsCondition.value = response.data ?? [];
      networkStatus.value = NetworkStatus.SUCCESS;
    } catch (e) {
      networkStatus.value = NetworkStatus.ERROR;
      // print("Error fetching terms conditions data: $e");
    }
  }
}
