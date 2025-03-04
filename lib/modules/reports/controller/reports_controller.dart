
import 'package:track_route_pro/constants/project_urls.dart';
import 'package:track_route_pro/service/api_service/api_service.dart';
import 'package:track_route_pro/service/model/ReportsRequest.dart';
import 'package:track_route_pro/service/model/presentation/track_route/track_route_vehicle_list.dart';
import 'package:track_route_pro/service/model/privacy_policy/PrivacyPolicyResponse.dart';
import 'package:track_route_pro/utils/common_import.dart';
import 'package:track_route_pro/utils/enums.dart';

import '../../../service/model/presentation/DownloadReportResponse.dart';
import '../../../utils/utils.dart';
import '../../track_route_screen/controller/track_route_controller.dart';

enum DATE {
  today(name: "Today", key : "today"),
  yesterday(name: "Yesterday", key: "yesterday"),
  last7Days(name: "Last 7 Days", key: "sevendays");

  final String name;
  final String key;

  const DATE({required this.name, required this.key});
}

class ReportsController extends GetxController {
  ApiService apiservice = ApiService.create();
  String link = "";
  RxList<PrivacyPolicyResponse> termsCondition = <PrivacyPolicyResponse>[].obs;
  Rx<NetworkStatus> networkStatus = Rx(NetworkStatus.IDLE);
  Rx<DATE?> selectedDate = Rx<DATE?>(null);
  RxList<Data> selectedVehicles = <Data>[].obs;
  RxString selectedReport = "".obs;
  RxBool openDay = true.obs;
  RxBool openReport = false.obs;
  RxBool showDownloaded = false.obs;
  RxList<Data> vehicleData = <Data>[].obs;
  final trackController = Get.isRegistered<TrackRouteController>()
      ? Get.find<TrackRouteController>() // Find if already registered
      : Get.put(TrackRouteController());

  List<String> reports = [
    "Summary",
    "Travel Report",
    "Trip Report",
    "Event Report",
    "Stop Idle Report",
    "Distance Report"
  ];
/*
  void getData() {
    vehicleData.value.clear();
    vehicleData.value.add(Data(vehicleNo: "Select All Vehicles"));
    vehicleData.value.addAll(trackController.allVehicles.value);
    vehicleData.value = List.from(vehicleData.value);
  }*/

  void setData() {
    // getData();
    openDay.value = false;
    openReport.value = true;
    showDownloaded.value = false;
    selectedDate.value = null;
    // selectedVehicles.value = [];
    link = "";
    selectedReport.value = "";
  }

/*  void addData(int index) {
    if (index == 0) {
      selectedVehicles.value.clear();
      selectedVehicles.value.add(Data(vehicleNo: "Select All Vehicles"));
      selectedVehicles.value.addAll(trackController.allVehicles.value);
    } else {
      if (!selectedVehicles.value
          .map(
            (e) => e.imei,
          )
          .contains(vehicleData.value[index].imei)) {
        selectedVehicles.value.add(vehicleData.value[index]);
      }
    }
    selectedVehicles.value = List.from(selectedVehicles.value);
  }

  void removeData(int index) {
    if (index != 0) {
      selectedVehicles.removeWhere(
        (element) => element.imei == vehicleData.value[index].imei,
      );
    }
    selectedVehicles
        .removeWhere((element) => element.vehicleNo == "Select All Vehicles");

    selectedVehicles.value = List.from(selectedVehicles.value);
  }*/

  Future<void> fetchData(String imei) async {
    if (selectedDate.value == null) {
      openDay.value = true;
      openReport.value = false;
    } else if (selectedReport.value.isEmpty) {
      openReport.value = true;
      openDay.value = false;
    } else {
      openReport.value = false;
      openDay.value = false;
      showDownloaded.value = false;
      try {
        networkStatus.value = NetworkStatus.LOADING;
        var request = ReportsRequest();
        request.days = selectedDate.value!.key;
        request.deviceId = [imei];
        var response;
        switch (selectedReport.value) {
          case "Summary":
            response = await apiservice.consolidateReport(request);
          case "Travel Report":
           response = await apiservice.summaryReport(request);
          case "Trip Report":
           response = await apiservice.tripReport(request);
          case "Event Report":
           response = await apiservice.eventReport(request); // Assuming event uses consolidate API
          case "Stop Idle Report":
           response = await apiservice.idleReport(request);
          case "Distance Report":
           response = await apiservice.distanceReport(request);
          default:
            throw Exception("Invalid report type: ${selectedReport.value}");
        }
        link = response.data ?? "";
        if (link.isNotEmpty) {
          showDownloaded.value = true;
          Utils.launchLink('${ProjectUrls.imgBaseUrl}$link', showError: true);
        } else {
          Utils.getSnackbar(
              "Report Unavailable", "");
        }
        networkStatus.value = NetworkStatus.SUCCESS;
      } catch (e) {
        networkStatus.value = NetworkStatus.ERROR;
        Utils.getSnackbar("Error", "Unable to fetch report, Please try later");
      }
    }
  }



}
