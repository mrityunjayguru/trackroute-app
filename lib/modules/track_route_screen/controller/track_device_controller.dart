import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as developer;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:track_route_pro/modules/track_route_screen/controller/track_route_controller.dart';
import '../../../config/theme/app_colors.dart';
import '../../../constants/constant.dart';
import '../../../constants/project_urls.dart';
import '../../../service/api_service/api_service.dart';
import '../../../service/model/presentation/vehicle_type/Data.dart';
import '../../../utils/app_prefrance.dart';
import '../../../utils/common_import.dart';
import '../../../utils/enums.dart';
import 'package:track_route_pro/service/model/presentation/track_route/track_route_vehicle_list.dart';

import '../../../utils/utils.dart';
import '../view/widgets/device/vehicle_dialog.dart';

class DeviceController extends GetxController {
  final trackController = Get.isRegistered<TrackRouteController>()
      ? Get.find<TrackRouteController>() // Find if already registered
      : Get.put(TrackRouteController());
  var markers = <Marker>[].obs;
  var circles = <Circle>[].obs;
  RxList<DataVehicleType> vehicleTypeList = <DataVehicleType>[].obs;
  RxString devicesOwnerID = RxString('');
  RxString selectedVehicleIMEI = RxString('');
  late GoogleMapController mapController;
  RxBool isedit = false.obs;
  RxBool isExpanded = false.obs;
  bool dialogOpen = false;
  var currentLocation = LatLng(20.5937, 78.9629).obs;
  var isLoading = false.obs;
  RxBool isSatellite = false.obs;

  final ApiService apiService = ApiService.create();
  Rx<NetworkStatus> networkStatus = Rx(NetworkStatus.IDLE);

  Rx<Data?> deviceDetail = Rx(Data());
  IO.Socket? socket;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    loadUser();
  }

  @override
  void onClose() {
    socket?.dispose();
    super.onClose();
  }

  Future<void> loadUser() async {
    String? userId = await AppPreference.getStringFromSF(Constants.userId);
    // print('userid:::::>${userId}');
    devicesOwnerID.value = userId ?? '';
  }

  ///SOCKET
  void initSocket() {
    socket = IO.io(
      '${ProjectUrls.baseUrl}',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket!.connect();
    developer.log('✅ Connected to socket server: ${socket!.id}');
    socket!.onConnect((_) {
      developer.log('✅ Connected to socket server: ${socket!.id}');

      socket!.emit('registerUser', {
        'userImei': [selectedVehicleIMEI.value],
        'socketId': socket!.id,
      });
    });

    socket!.on('vehicleData', (data) {
      developer.log('📡 vehicleData received: $data');
      try {
        final List<Data> vehicleListData = (data as List<dynamic>)
            .map((item) => Data.fromJson(item as Map<String, dynamic>))
            .toList();
        if (!isedit.value && vehicleListData.isNotEmpty) {
          /*   int index = vehicleList.value.data?.indexWhere(
                (element) => element.imei == vehicleListData.first.imei,
              ) ??
              -1;

      vehicleList.value.data?[index] = vehicleListData.first;*/
          // storeVehicleData();

          deviceDetail.value = vehicleListData.first;
        }
        for (var vehicle in vehicleListData ?? []) {
          developer.log(
              '🚗 Vehicle No: ${vehicle.vehicleNo}, Speed: ${vehicle.trackingData?.currentSpeed}');
        }
      } catch (e, stackTrace) {
        developer.log('❌ Error parsing vehicleData: $e\n$stackTrace');
      }
    });

    socket!.onConnectError((data) {
      developer.log('❌ Connect Error: $data');
    });

    socket!.onError((data) {
      developer.log('❌ Socket Error: $data');
    });

    socket!.onDisconnect((_) {
      developer.log('🔌 Socket Disconnected');
    });
  }

  void closeSocket() {
    socket?.dispose();
  }

  /// DEVICE API

  Future<void> getDeviceByIMEI() async {
    try {
      final body = {"deviceId": "${selectedVehicleIMEI.value}"};
      networkStatus.value = NetworkStatus.LOADING;

      final response = await apiService.devicesByOwnerID(body);
      if (response.status == 200) {
        networkStatus.value = NetworkStatus.SUCCESS;
        if (response.data?.isNotEmpty ?? false) {
          deviceDetail.value = response.data?.first;
          deviceDetail.refresh();
        }
      } else if (response.status == 400) {
        networkStatus.value = NetworkStatus.ERROR;
      }
    } catch (e, s) {
      developer.log("exception ==> $e $s");
      networkStatus.value = NetworkStatus.ERROR;
    }
  }
  Future<void> devicesByDetails(
      {bool updateCamera = true,
        bool showDialog = false,
        bool zoom = false}) async {
    try {
      /*   deviceDetail.value = vehicleList.value.data
          ?.where(
            (element) => element.imei == imei,
          )
          .firstOrNull;*/

      deviceDetail.refresh();
      if (deviceDetail.value != null) {
        final data = deviceDetail.value;

        if (updateCamera &&
            data?.trackingData?.location?.latitude != null &&
            data?.trackingData?.location?.longitude != null) {
          if (zoom) {
            trackController.updateCameraPositionWithZoom(
                course: Utils.parseDouble(data: data?.trackingData?.course),
                latitude: data?.trackingData?.location?.latitude ?? 0,
                longitude: data?.trackingData?.location?.longitude ?? 0);
          } else {
            mapController.getZoomLevel().then((currentZoom) async {
              /* double offset =
                    getOffset(currentZoom); // Get offset based on zoom
                double course =
                    Utils.parseDouble(data: data?.trackingData?.course);
                LatLng newLatLng = await calcLatLong(
                    offset,
                    course,
                    (data?.trackingData?.location?.latitude ?? 0),
                    (data?.trackingData?.location?.longitude ?? 0));*/
              mapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    bearing:
                    Utils.parseDouble(data: data?.trackingData?.course),
                    // Keep map aligned with vehicle movement
                    target: LatLng(
                        (data?.trackingData?.location?.latitude ?? 0),
                        (data?.trackingData?.location?.longitude ?? 0)),
                    zoom: currentZoom,
                  ),
                ),
              );
            });
          }
        }

        relayStatus.value = data?.immobiliser ?? "Stop";
        // vehicleRegistrationNumber.text = data?.vehicleRegistrationNo ?? '';
        vehicleName.text = data?.vehicleNo ?? '';
        dateAdded.text = Utils().formatDate(data?.dateAdded);
        driverName.text = data?.driverName ?? '';
        driverMobileNo.text = data?.mobileNo ?? '';
        maxSpeedUpdate.text =
            ((data?.maxSpeed ?? 0).toStringAsFixed(0)).toString();
        latitudeUpdate.text = (data?.location?.latitude ?? '').toString();
        longitudeUpdate.text = (data?.location?.longitude ?? '').toString();
        parkingUpdate.value = data?.parking ?? false;
        speedUpdate.value = data?.speedStatus ?? false;

        geofence.value = data?.locationStatus ?? false;
        areaUpdate.text = (data?.area ?? '').toString();

        insuranceExpiryDate.text =
            Utils().formatDate(data?.insuranceExpiryDate);
        pollutionExpiryDate.text =
            Utils().formatDate(data?.pollutionExpiryDate);
        fitnessExpiryDate.text = Utils().formatDate(data?.fitnessExpiryDate);
        nationalPermitExpiryDate.text =
            Utils().formatDate(data?.nationalPermitExpiryDate);
        if (showDialog && (deviceDetail.value != null)) {
          if ((deviceDetail.value?.vehicleNo?.isEmpty ?? true) ||
              (deviceDetail.value?.driverName?.isEmpty ?? true)) {
            dialogOpen = true;
            Utils.openDialog(
              context: Get.context!,
              child: VehicleDialog(),
            );
          }
        }
        if (data?.trackingData?.location?.latitude != null &&
            data?.trackingData?.location?.longitude != null) {
          bool isInactive = trackController.checkIfInactive(vehicle: data);
          bool isOffline = trackController.checkIfOffline(vehicle: data);
          double? lat = data?.trackingData?.location?.latitude;
          double? long = data?.trackingData?.location?.longitude;
          if (isInactive) {
            lat = data?.lastLocation?.latitude;
            long = data?.lastLocation?.longitude;
          }
          Marker m = await trackController.createMarker(
              course: Utils.parseDouble(data: data?.trackingData?.course),
              imei: data?.imei ?? "",
              lat: lat,
              long: long,
              img: data?.vehicletype?.icons,
              id: data?.deviceId,
              vehicleNo: data?.vehicleNo,
              isOffline: isOffline,
              isInactive: isInactive);
          markers.value = [];
          markers.add(m);
        }
        circles.value = [];
        if ((data?.locationStatus ?? false) &&
            (data?.location?.latitude != null &&
                data?.location?.longitude != null)) {
          circles.value.add(Circle(
            circleId: CircleId("GEOFENCE${data?.imei}"),
            fillColor: AppColors.selextedindexcolor.withOpacity(0.4),
            strokeWidth: 2,
            strokeColor: AppColors.selextedindexcolor.withOpacity(0.41),
            center: LatLng(
                data?.location?.latitude ?? 0, data?.location?.longitude ?? 0),
            radius: Utils.parseDouble(data: data?.area),
          ));
          circles.value = List.from(circles);
        }
      } else {
        selectedVehicleIMEI.value = "";
        // selectedVehicleIndex.value = -1;
      }
    } catch (e, s) {}
  }
  /// EDIT VEHICLE DETAILS

  TextEditingController vehicleRegistrationNumber = TextEditingController();
  TextEditingController vehicleName = TextEditingController();
  TextEditingController dateAdded = TextEditingController();
  TextEditingController driverName = TextEditingController();
  TextEditingController driverMobileNo = TextEditingController();
  TextEditingController vehicleBrand = TextEditingController();
  TextEditingController vehicleModel = TextEditingController();
  TextEditingController insuranceExpiryDate = TextEditingController();
  TextEditingController pollutionExpiryDate = TextEditingController();
  TextEditingController fitnessExpiryDate = TextEditingController();
  TextEditingController nationalPermitExpiryDate = TextEditingController();
  TextEditingController latitudeUpdate = TextEditingController();
  TextEditingController longitudeUpdate = TextEditingController();
  TextEditingController areaUpdate = TextEditingController();
  TextEditingController maxSpeedUpdate = TextEditingController();
  Rx<DataVehicleType> vehicleType = Rx(DataVehicleType());
  Rx<bool> parkingUpdate = Rx(false);
  Rx<bool> speedUpdate = Rx(false);
  Rx<bool> geofence = Rx(false);
  Rx<bool> selectCurrentLocationUpdate = Rx(false);
  Rx<bool> editGeofence = Rx(false);
  Rx<bool> editSpeed = Rx(false);

  //edit detail api

  Future<void> editDevicesByDetails(
      {bool editGeofence = false,
        bool editSpeed = false,
        bool editGeneral = false,
        required BuildContext context}) async {
    try {
      double? lat;
      double? long;
      if (editGeofence) {
        lat = double.tryParse(latitudeUpdate.text) ?? 0.0;
        long = double.tryParse(longitudeUpdate.text) ?? 0.0;
        geofence.value = true;
      } else {
        lat = deviceDetail.value?.location?.latitude ?? 0.0;
        long = (deviceDetail.value?.location?.longitude ?? 0.0);
        areaUpdate.text = (deviceDetail.value?.area ?? '').toString();
      }

      if (!editSpeed) {
        maxSpeedUpdate.text = (deviceDetail.value?.maxSpeed ?? '').toString();
      } else {
        speedUpdate.value = true;
      }

      if (!editGeneral) {
        resetGeneralInfo();
      }

      final body = {
        "vehicleNo": vehicleName.text,
        "driverName": driverName.text,
        "mobileNo": driverMobileNo.text,
        "insuranceExpiryDate": insuranceExpiryDate.text.isNotEmpty
            ? DateFormat('yyyy-MM-dd').format(
            DateFormat('dd-MM-yyyy').parse(insuranceExpiryDate.text))
            : "",
        "pollutionExpiryDate": pollutionExpiryDate.text.isNotEmpty
            ? DateFormat('yyyy-MM-dd').format(
            DateFormat('dd-MM-yyyy').parse(pollutionExpiryDate.text))
            : "",
        "fitnessExpiryDate": fitnessExpiryDate.text.isNotEmpty
            ? DateFormat('yyyy-MM-dd')
            .format(DateFormat('dd-MM-yyyy').parse(fitnessExpiryDate.text))
            : "",
        "nationalPermitExpiryDate": nationalPermitExpiryDate.text.isNotEmpty
            ? DateFormat('yyyy-MM-dd').format(
            DateFormat('dd-MM-yyyy').parse(nationalPermitExpiryDate.text))
            : "",
        "_id": deviceDetail.value?.sId ?? '',
        "maxSpeed": maxSpeedUpdate.text.trim(),
        "parking": parkingUpdate.value,
        "Area": areaUpdate.text.trim(),
        "speedStatus": speedUpdate.value,
        "locationStatus": geofence.value,
        "location": {"longitude": long, "latitude": lat}
      };
      networkStatus.value = NetworkStatus.LOADING;

      await apiService.editDevicesByOwnerID(body);
      devicesByDetails(updateCamera: false);
      Utils.getSnackbar('Success', 'Your detail is updated');
    } catch (e) {
      networkStatus.value = NetworkStatus.ERROR;

      // print("Error during data update: $e");
    }
  }

  Future<void> editDeviceData(BuildContext context) async {
    try {
      final body = {
        // "vehicleRegistrationNo": vehicleRegistrationNumber.text,
        "vehicleNo": vehicleName.text,
        "driverName": driverName.text,
        "_id": deviceDetail.value?.sId ?? '',
      };
      networkStatus.value = NetworkStatus.LOADING;

      await apiService.editDevicesByOwnerID(body);
      devicesByDetails(updateCamera: false);
      Utils.getSnackbar('Success', 'Your detail is updated');
    } catch (e) {
      networkStatus.value = NetworkStatus.ERROR;

      print("Error during data update: $e");
    }
  }

  Future<void> editGeofenceToggle(BuildContext context) async {
    try {
      final body = {
        "_id": deviceDetail.value?.sId ?? '',
        "locationStatus": geofence.value
      };
      networkStatus.value = NetworkStatus.LOADING;

      await apiService.editDevicesByOwnerID(body);
    } catch (e) {
      networkStatus.value = NetworkStatus.ERROR;

      print("Error during data update: $e");
    }
  }

  Future<void> editSpeedToggle(BuildContext context) async {
    try {
      final body = {
        "speedStatus": speedUpdate.value,
        "_id": deviceDetail.value?.sId ?? '',
      };
      networkStatus.value = NetworkStatus.LOADING;

      await apiService.editDevicesByOwnerID(body);
    } catch (e) {
      networkStatus.value = NetworkStatus.ERROR;

      print("Error during data update: $e");
    }
  }

  RxString relayStatus = "".obs;

  Future<void> checkRelayStatus(String imei) async {
    var response;
    try {
      networkStatus.value =
          NetworkStatus.LOADING; // Set network status to loading
      final body = {"imei": imei};
      // log("CHECK RELAY $body");
      response = await apiService.relayStatus(body);
      // debugPrint("RESPONSE $response");
      if (response.data.status != null && response.data.status == "success") {
        relayStatus.value = response.data.response.type;
        networkStatus.value = NetworkStatus.SUCCESS;
      } else {
        Utils.getSnackbar("Engine Status", response.data.message);
      }
    } catch (e) {
      // debugPrint("EXCEPTION $e");
      networkStatus.value = NetworkStatus.ERROR;
    }
  }

  Future<void> stopEngine(String imei) async {
    var response;
    try {
      networkStatus.value =
          NetworkStatus.LOADING; // Set network status to loading
      final body = {"imei": imei};
      response = await apiService.relayStopEngine(body);
      if (response.data.message != null) {
        Utils.getSnackbar("Engine", response.data.message);
      }

      if (response.message == "success") {
        devicesByDetails(updateCamera: false);
        // checkRelayStatus(imei);
        networkStatus.value = NetworkStatus.SUCCESS;
      }
      Utils.getSnackbar("Engine", response.data.message);
    } catch (e) {
      // debugPrint("EXCEPTION $e");
      networkStatus.value = NetworkStatus.ERROR;
    }
  }

  Future<void> startEngine(String imei) async {
    var response;
    try {
      networkStatus.value =
          NetworkStatus.LOADING; // Set network status to loading
      final body = {"imei": imei};
      response = await apiService.relayStartEngine(body);
      if (response.data.message != null) {
        Utils.getSnackbar("Engine", response.data.message);
      }
      if (response.message == "success") {
        devicesByDetails(updateCamera: false);
        // checkRelayStatus(imei);
        networkStatus.value = NetworkStatus.SUCCESS;
      }
    } catch (e) {
      // debugPrint("EXCEPTION $e");
      networkStatus.value = NetworkStatus.ERROR;
    }
  }

  void resetGeneralInfo() {
    final data = deviceDetail.value;
    // vehicleRegistrationNumber.text = data?.vehicleRegistrationNo ?? '';
    vehicleName.text = data?.vehicleNo ?? '';
    dateAdded.text = Utils().formatDate(data?.dateAdded);
    driverName.text = data?.driverName ?? '';
    driverMobileNo.text = data?.mobileNo ?? '';
    insuranceExpiryDate.text = Utils().formatDate(data?.insuranceExpiryDate);
    pollutionExpiryDate.text = Utils().formatDate(data?.pollutionExpiryDate);
    fitnessExpiryDate.text = Utils().formatDate(data?.fitnessExpiryDate);
    nationalPermitExpiryDate.text =
        Utils().formatDate(data?.nationalPermitExpiryDate);
  }

  void getCurrLocationForGeofence() async {
    Position? data = await trackController.getCurrentLocation();
    latitudeUpdate.text = (data?.latitude ?? "").toString();
    longitudeUpdate.text = (data?.longitude ?? "").toString();
  }

  /// Location tracking methods

}