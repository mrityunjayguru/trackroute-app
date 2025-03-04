import 'dart:convert';
import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:track_route_pro/service/model/notification/AnnouncementResponse.dart';
import 'package:track_route_pro/utils/common_import.dart';
import '../../../constants/constant.dart';
import '../../../service/api_service/api_service.dart';
import '../../../service/model/alerts/UpdateAlertsRequest.dart';
import '../../../service/model/alerts/alert/AlertsResponse.dart';
import '../../../service/model/alerts/config/get_config/NotificationPermission.dart';
import '../../../utils/app_prefrance.dart';
import '../../../utils/enums.dart';

class AlertController extends GetxController {
  RxInt selectedIndex = RxInt(0);
  RxInt selectedVehicleIndex = RxInt(-1);
  RxString devicesOwnerID = RxString('');
  RxString selectedVehicleName = RxString('');
  RxBool vehicleSelected = RxBool(false);
  RxBool isExpanded = RxBool(false);
  RxList<AnnouncementResponse> announcements = <AnnouncementResponse>[].obs;
  RxList<AlertsResponse> alerts = <AlertsResponse>[].obs;

  // RxList<AlertDataModel> alertsData = <AlertDataModel>[].obs;
  RxList<AlertsResponse> unfilteredAlerts = <AlertsResponse>[].obs;
  final ApiService apiService = ApiService.create();
  Rx<NetworkStatus> networkStatus = Rx(NetworkStatus.IDLE);
  final Ignition = ValueNotifier<bool>(true);
  final Parking = ValueNotifier<bool>(true);
  final Geofencing = ValueNotifier<bool>(true);
  final Door = ValueNotifier<bool>(true);
  final OverSpeed = ValueNotifier<bool>(true);
  final Vibration = ValueNotifier<bool>(true);
  final DevicePowerCut = ValueNotifier<bool>(true);
  final DeviceLowBattery = ValueNotifier<bool>(true);
  final notification = ValueNotifier<bool>(true);
  final Fuel = ValueNotifier<bool>(true);
  final ExpiryReminder = ValueNotifier<bool>(true);
  final OtherAlerts = ValueNotifier<bool>(true);
  NotificationPermission notificationDataApi = NotificationPermission();
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    // description
    importance: Importance.max,
  );

  @override
  void onInit() {
    super.onInit();
    // _loadPreferences();
    notification.addListener(
      () {
        setAlertsConfig();
        checkNotification();
      },
    );
  }

  void getData() {
    isExpanded.value = false;
    selectedVehicleIndex.value = -1;
    selectedVehicleName.value = "";
    vehicleSelected.value = false;
    loadUser().then(
      (value) {
        getAlerts();
        getAnnouncements();
      },
    );
  }

  Future<void> loadUser() async {
    String? userId = await AppPreference.getStringFromSF(Constants.userId);
    // print('userid:::::>${userId}');
    devicesOwnerID.value = userId ?? '';
  }

  Future<void> getAnnouncements() async {
    try {
      final body = {"_id": "${devicesOwnerID.value}"};
      networkStatus.value = NetworkStatus.LOADING;

      final response = await apiService.announcements(body);

      if (response.status == 200) {
        networkStatus.value = NetworkStatus.SUCCESS;
        announcements.value = response.data ?? [];
        announcements.sort((a, b) => DateTime.parse(b.createdAt!)
            .compareTo(DateTime.parse(a.createdAt!)));
      } else if (response.status == 400) {
        networkStatus.value = NetworkStatus.ERROR;
      }
    } catch (e,s) {
      log("EXCEPTION $e $s");
      networkStatus.value = NetworkStatus.ERROR;
    }
  }

  Future<void> getAlerts() async {
    try {
      final body = {"ownerID": "${devicesOwnerID.value}"};
      networkStatus.value = NetworkStatus.LOADING;

      final response = await apiService.alerts(body);

      if (response.message?.toLowerCase() == "success") {
        networkStatus.value = NetworkStatus.SUCCESS;
        unfilteredAlerts.value = response.data ?? [];
        alerts.value = unfilteredAlerts;
        // _filterData();
      } else {
        networkStatus.value = NetworkStatus.ERROR;
      }
    } catch (e, s) {
      log("ERROR ALERTS $e $s");
      networkStatus.value = NetworkStatus.ERROR;
    }
  }

  Future<String> getAddressFromLatLong(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      Placemark place = placemarks[0];

      String address =
          "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
      return address;
    } catch (e) {
      // debugPrint("Error " + e.toString());
      String address = "Address not available";
      return address;
    }
  }

  void filterAlerts(bool isSelected, String vehicleNo, int index) {
    isExpanded.value = false;
    vehicleSelected.value = isSelected;
    if (isSelected) {
      selectedVehicleName.value = vehicleNo;
      selectedVehicleIndex.value = index;
      alerts.value = unfilteredAlerts
          .where(
            (element) => element.deviceDetails?.vehicleNo == vehicleNo,
          )
          .toList();
    } else {
      selectedVehicleName.value = "";
      selectedVehicleIndex.value = -1;
      alerts.value = unfilteredAlerts;
    }
    alerts.sort((a, b) =>
        DateTime.parse(b.createdAt!).compareTo(DateTime.parse(a.createdAt!)));
  }

  Future<void> setAlertsConfig() async {
    try {
      log("SET NOTIFICATION =======>");
      if (devicesOwnerID.value.isEmpty) {
        String? userId = await AppPreference.getStringFromSF(Constants.userId);
        devicesOwnerID.value = userId ?? "";
      }
      UpdateAlertsRequest request = UpdateAlertsRequest();
      if (!notification.value) {
        request = UpdateAlertsRequest(
          id: devicesOwnerID.value,
          ignition: notificationDataApi.ignition ?? true,
          parkingAlert: notificationDataApi.parkingAlert ?? true,
          geofencing: notificationDataApi.geofencing ?? true,
          aCDoorAlert: notificationDataApi.aCDoorAlert ?? true,
          overSpeed: notificationDataApi.overSpeed ?? true,
          vibration: notificationDataApi.vibration ?? true,
          devicePowerCut: notificationDataApi.devicePowerCut ?? true,
          deviceLowBattery: notificationDataApi.deviceLowBattery ?? true,
          all: false,
          fuelAlert: notificationDataApi.fuelAlert ?? true,
          expiryReminders: notificationDataApi.expiryReminders ?? true,
          otherAlerts: notificationDataApi.otherAlerts ?? true,
        );
      } else {
        request = UpdateAlertsRequest(
          id: devicesOwnerID.value,
          all: notification.value,
          ignition: Ignition.value,
          geofencing: Geofencing.value,
          overSpeed: OverSpeed.value,
          parkingAlert: Parking.value,
          aCDoorAlert: Door.value,
          fuelAlert: Fuel.value,
          expiryReminders: ExpiryReminder.value,
          vibration: Vibration.value,
          devicePowerCut: DevicePowerCut.value,
          deviceLowBattery: DeviceLowBattery.value,
          otherAlerts: OtherAlerts.value,
        );
      }
      networkStatus.value = NetworkStatus.LOADING;

      await apiService.sendAlertsData(request);
      getAlertsDetails(check: false);
      // Utils.getSnackbar("Success", "Successfully updated data");
    } catch (e, s) {
      log("ERROR ALERTS CONFIG $e $s");
      networkStatus.value = NetworkStatus.ERROR;
    }
  }

  Future<void> getAlertsDetails({bool check = true}) async {
    String? userId = await AppPreference.getStringFromSF(Constants.userId);

    try {
      log("GET NOTIFICATION =======>");
      final body = {"_id": userId};
      networkStatus.value = NetworkStatus.LOADING;
      devicesOwnerID.value = userId ?? '';
      final response = await apiService.userDetails(body);

      if (response.message?.toLowerCase() == "success") {
        networkStatus.value = NetworkStatus.SUCCESS;
        notificationDataApi =
            response.data?.notificationPermission ?? NotificationPermission();
        notification.value = notificationDataApi.all ?? true;
        if (check) {
          checkNotification();
        }
      } else {
        networkStatus.value = NetworkStatus.ERROR;
      }
    } catch (e, s) {
      log("ERROR ALERTS Get details $e $s");
      networkStatus.value = NetworkStatus.ERROR;
    }
  }

  void checkNotification() {
    if (!notification.value) {
      log("FALSE NOTIFICATION =======>");
      Ignition.value = false;
      Parking.value = false;
      Geofencing.value = false;
      Door.value = false;
      OverSpeed.value = false;
      Vibration.value = false;
      DevicePowerCut.value = false;
      DeviceLowBattery.value = false;
      notification.value = false;
      Fuel.value = false;
      ExpiryReminder.value = false;
      OtherAlerts.value = false;
    } else {
      log("TRUE NOTIFICATION =======>${json.encode(notificationDataApi)}");
      Ignition.value = notificationDataApi.ignition ?? true;
      Parking.value = notificationDataApi.parkingAlert ?? true;
      Geofencing.value = notificationDataApi.geofencing ?? true;
      Door.value = notificationDataApi.aCDoorAlert ?? true;
      OverSpeed.value = notificationDataApi.overSpeed ?? true;
      Vibration.value = notificationDataApi.vibration ?? true;
      DevicePowerCut.value = notificationDataApi.devicePowerCut ?? true;
      DeviceLowBattery.value = notificationDataApi.deviceLowBattery ?? true;
      // notification.value = notificationDataApi.all ?? true;
      Fuel.value = notificationDataApi.fuelAlert ?? true;
      ExpiryReminder.value = notificationDataApi.expiryReminders ?? true;
      OtherAlerts.value = notificationDataApi.otherAlerts ?? true;
    }
  }

  // Function to fetch splash data from the API
  Future<void> sendTokenData() async {
    String userId = await AppPreference.getStringFromSF(Constants.userId) ?? "";

    if (userId.isNotEmpty) {
      try {
        networkStatus.value =
            NetworkStatus.LOADING; // Set network status to loading

        // Call the API method from ApiService

        var request = {"_id": userId, "notification": '${notification.value}'};
        var response = await apiService.sendNotif(request);
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
}
