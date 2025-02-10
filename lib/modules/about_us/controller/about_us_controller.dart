import 'package:track_route_pro/service/api_service/api_service.dart';
import 'package:track_route_pro/service/model/presentation/setting_screen_model/about_us_model.dart';
import 'package:track_route_pro/utils/common_import.dart';
import 'package:track_route_pro/utils/enums.dart';

class AboutUsController extends GetxController {
  ApiService apiservice = ApiService.create();
  Rx<AboutUSResponse> aboutUs = Rx(AboutUSResponse());
  Rx<NetworkStatus> networkStatus = Rx(NetworkStatus.IDLE);

  @override
  void onInit() {
    super.onInit();
    fetchAboutUsData();
  }

  // Method to fetch About Us data
  Future<void> fetchAboutUsData() async {
    try {
      networkStatus.value = NetworkStatus.LOADING;
      AboutUSResponse response = await apiservice.aboutUS();
      aboutUs.value = response;
      networkStatus.value = NetworkStatus.SUCCESS;
    } catch (e) {
      networkStatus.value = NetworkStatus.ERROR;
      print("Error fetching About Us data: $e");
    }
  }
}
