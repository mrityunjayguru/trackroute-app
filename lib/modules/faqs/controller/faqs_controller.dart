import 'package:track_route_pro/service/model/faq/FaqListModel.dart';
import 'package:track_route_pro/utils/common_import.dart';
import 'package:get/get.dart';
import 'package:track_route_pro/utils/enums.dart';

import '../../../service/api_service/api_service.dart';
import '../../../service/model/auth/Data.dart';
import '../../../service/model/faq/Topic.dart';
import '../../../utils/common_import.dart';

class FaqsController extends GetxController {
  Rx<NetworkStatus> networkStatus = Rx(NetworkStatus.IDLE);
  ApiService apiservice = ApiService.create();
  RxList<Topic> topicsList =  RxList([]);
  RxList<FaqListModel> faqs = RxList([]);

  void onInit() {
    super.onInit();

    // getTopics();
    // getFaq();
  }

  Future<void> getTopics() async {
    var response;
    try {
      networkStatus.value =
          NetworkStatus.LOADING; // Set network status to loading

      response = await apiservice.faqTopic();

      if (response.status == 200) {
        networkStatus.value = NetworkStatus.SUCCESS;
        topicsList.value = response.data;
        topicsList.value = topicsList.where((p0) => p0.status == "Active",).toList();
        topicsList.sort((a, b) => int.parse(a.priority ?? "0").compareTo(int.parse(b.priority ?? "0")));
      }
    } catch (e) {
      debugPrint("EXCEPTION $e");
      networkStatus.value = NetworkStatus.ERROR;
    }
  }

  Future<void> getFaq() async {
    var response;
    try {
      networkStatus.value =
          NetworkStatus.LOADING; // Set network status to loading

      response = await apiservice.faqList();

      if (response.status == 200) {
        networkStatus.value = NetworkStatus.SUCCESS;
        faqs.value = response.data;
        faqs.value = faqs.where((p0) => p0.status == "Active",).toList();
      }
    } catch (e) {
      debugPrint("EXCEPTION $e");
      networkStatus.value = NetworkStatus.ERROR;
    }
  }
}
