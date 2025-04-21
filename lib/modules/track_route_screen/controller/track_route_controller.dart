import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:track_route_pro/constants/constant.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/bottom_screen/controller/bottom_bar_controller.dart';
import 'package:track_route_pro/modules/vehicales/model/filter_model.dart';
import 'package:track_route_pro/service/api_service/api_service.dart';
import 'package:track_route_pro/service/model/presentation/track_route/track_route_vehicle_list.dart';
import 'package:track_route_pro/utils/app_prefrance.dart';
import 'package:track_route_pro/utils/common_import.dart';
import 'package:track_route_pro/utils/enums.dart';
import 'package:track_route_pro/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/theme/app_colors.dart';
import '../../../constants/project_urls.dart';
import '../../../service/model/presentation/vehicle_type/Data.dart';
import '../../../utils/common_map_helper.dart';
import '../../route_history/controller/common.dart';
import '../view/widgets/vehicle_dialog.dart';

class TrackRouteController extends GetxController {
  Rx<TrackRouteVehicleList> vehicleList = Rx(TrackRouteVehicleList());
  RxList<Data> filteredVehicleList = <Data>[].obs;
  RxList<FilterData> filterData = RxList([]);
  var markers = <Marker>[].obs;
  var circles = <Circle>[].obs;
  RxBool isSheetExpanded = false.obs;
  RxList<Data> ignitionOnList = <Data>[].obs;
  RxList<Data> ignitionOffList = <Data>[].obs;
  RxList<Data> activeVehiclesList = <Data>[].obs;
  RxList<Data> inActiveVehiclesList = <Data>[].obs;
  RxList<Data> offlineVehiclesList = <Data>[].obs;
  RxList<Data> allVehicles = <Data>[].obs;
  RxList<DataVehicleType> vehicleTypeList = <DataVehicleType>[].obs;
  RxString devicesOwnerID = RxString('');
  RxList<String> devicesImei = <String>[].obs;
  RxString selectedVehicleIMEI = RxString('');
  late GoogleMapController mapController;
  bool gpsEnabled = false;
  bool permissionGranted = false;
  RxBool isExpanded = false.obs;
  RxBool isFilterSelected = false.obs;
  RxInt isFilterSelectedindex = RxInt(-1);
  RxBool isvehicleSelected = false.obs;
  RxBool showLoader = false.obs;
  RxBool isShowvehicleDetail = false.obs;
  RxInt stackIndex = RxInt(0);
  RxBool isedit = false.obs;
  RxBool isSatellite = false.obs;
  double height = 848;
  bool dialogOpen = false;
  var currentLocation = LatLng(20.5937, 78.9629).obs;
  var isLoading = false.obs; // Loading state

  final ApiService apiService = ApiService.create();
  Rx<NetworkStatus> networkStatus = Rx(NetworkStatus.IDLE);
  TextEditingController searchController = TextEditingController();

  Rx<Data?> deviceDetail = Rx(Data());
  IO.Socket? socket;
  Timer? _timer;
  @override
  void onInit() {
    super.onInit();
    checkStatus();
    showLoader.value = true;

    loadUser().then(
      (value) {
        getVehicleTypeList();
        _timer = Timer.periodic(Duration(minutes: 1), (timer) {
          getAllDevices();
        });
        // devicesByOwnerID(false);
      },
    );
  }

  @override
  void onClose() {
    socket?.dispose();
    _timer?.cancel();
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

  void closeSocket(){
    socket?.dispose();
  }

  ///API SERVICE FOR ALL DEVICE
  Future<void> getAllDevices() async {
    bool isLogIn =
        await AppPreference.getBoolFromSF(Constants.isLogIn) ?? false;
    if (isLogIn) {
      try {
        final body = {"ownerId": "${devicesOwnerID.value}"};
        networkStatus.value = NetworkStatus.LOADING;

        final response = await apiService.devicesByOwnerID(body);
        if (response.status == 200) {
          networkStatus.value = NetworkStatus.SUCCESS;
          devicesImei.value = response.data
                  ?.map(
                    (e) => e.imei ?? "",
                  )
                  .toList() ??
              [];
          vehicleList.value = response;
          initSocket();
          storeVehicleData();
        } else if (response.status == 400) {
          networkStatus.value = NetworkStatus.ERROR;
        }
      } catch (e, s) {
        developer.log("exception ==> $e $s");
        networkStatus.value = NetworkStatus.ERROR;
      }
    }
  }

  Future<void> getDeviceByIMEI() async {
    try {
      final body = {"deviceId": "${selectedVehicleIMEI.value}"};
      networkStatus.value = NetworkStatus.LOADING;

      final response = await apiService.devicesByOwnerID(body);
      if (response.status == 200) {
        networkStatus.value = NetworkStatus.SUCCESS;
        if(response.data?.isNotEmpty ?? false){
          deviceDetail.value =  response.data?.first;
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

  void storeVehicleData() async {
    final allVehiclesRes = vehicleList.value.data ?? [];
    allVehicles.value = allVehiclesRes;
    ignitionOnList.value = filterIgnitionOn(allVehiclesRes).obs;
    ignitionOffList.value = filterIgnitionOff(allVehiclesRes).obs;
    activeVehiclesList.value = filterActiveVehicles(allVehiclesRes).obs;
    inActiveVehiclesList.value = filterInactive(allVehiclesRes).obs;
    offlineVehiclesList.value = filterOffline(allVehiclesRes).obs;
    filterData.value = [
      FilterData(
          image: Assets.images.svg.icFlashGreen,
          count: ignitionOnList.length,
          title: 'Ignition On'),
      FilterData(
          image: Assets.images.svg.icFlashRed,
          count: ignitionOffList.length,
          title: 'Ignition Off'),
      FilterData(
          image: Assets.images.svg.icCheck,
          count: activeVehiclesList.length,
          title: 'Active'),
      FilterData(
          image: "assets/images/svg/inactive_icon.svg",
          count: inActiveVehiclesList.length,
          title: 'Inactive'),
      FilterData(
          image: "assets/images/svg/offline_icon.svg",
          count: offlineVehiclesList.length,
          title: 'Offline'),
      FilterData(
          image: "assets/images/svg/all_icon.svg",
          count: allVehicles.length,
          title: 'All'),
    ];
    if (!isFilterSelected.value && !isShowvehicleDetail.value) {
      markers.value = [];
      for (var vehicle in allVehiclesRes) {
        if (vehicle.trackingData?.location?.latitude != null &&
            vehicle.trackingData?.location?.longitude != null) {
          bool isInactive = checkIfInactive(vehicle: vehicle);
          bool isOffline = checkIfOffline(vehicle: vehicle);
          double? lat = vehicle.trackingData?.location?.latitude;
          double? long = vehicle.trackingData?.location?.longitude;
          if (isInactive) {
            lat = vehicle.lastLocation?.latitude;
            long = vehicle.lastLocation?.longitude;
          }

          Marker m = await createMarker(
              imei: vehicle.imei ?? "",
              lat: lat,
              long: long,
              img: vehicle.vehicletype?.icons,
              id: vehicle.deviceId,
              vehicleNo: vehicle.vehicleNo,
              course: Utils.parseDouble(data: vehicle.trackingData?.course),
              isOffline: isOffline,
              isInactive: isInactive);
          markers.add(m);
        }
      }
    } else if (isFilterSelected.value) {
      checkFilterIndex(false);
    } else if (isShowvehicleDetail.value &&
        selectedVehicleIMEI.value.isNotEmpty &&
        !dialogOpen) {
   /*   devicesByDetails(
        selectedVehicleIMEI.value,
      );*/
    }
  }

  Future<void> getVehicleTypeList() async {
    try {
      networkStatus.value = NetworkStatus.LOADING;
      final response = await apiService.getVehicleType();

      if (response.status == 200) {
        networkStatus.value = NetworkStatus.SUCCESS;
        vehicleTypeList.value = response.data ?? [];

        // log("vehicle type list ===>${jsonEncode(vehicleTypeList)}");
      } else if (response.status == 400) {
        networkStatus.value = NetworkStatus.ERROR;
      }
    } catch (e) {
      networkStatus.value = NetworkStatus.ERROR;

      // print("Error during OTP verification: $e");
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
            updateCameraPositionWithZoom(
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
          bool isInactive = checkIfInactive(vehicle: data);
          bool isOffline = checkIfOffline(vehicle: data);
          double? lat = data?.trackingData?.location?.latitude;
          double? long = data?.trackingData?.location?.longitude;
          if (isInactive) {
            lat = data?.lastLocation?.latitude;
            long = data?.lastLocation?.longitude;
          }
          Marker m = await createMarker(
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
        isShowvehicleDetail.value = false;
        selectedVehicleIMEI.value = "";
        // selectedVehicleIndex.value = -1;
      }
    } catch (e, s) {}
  }

  Future<void> isShowVehicleDetails(int index, String imei) async {
    isShowvehicleDetail.value = true;
    selectedVehicleIMEI.value = imei;
  }

  void showAllVehicles() async {
    circles.value = [];
    isShowvehicleDetail.value = false;
    isSheetExpanded.value = false;
    markers.value = [];
    // selectedVehicleIndex.value = -1;
    selectedVehicleIMEI.value = "";
    isvehicleSelected.value = false;
    checkFilterIndex(false);
    if ((vehicleList.value.data?.isNotEmpty ?? false)) {
      int? validIndex = vehicleList.value.data?.indexWhere((vehicle) =>
          vehicle.trackingData?.location?.latitude != null &&
          vehicle.trackingData?.location?.longitude != null);

      if (validIndex != null && validIndex != -1) {
        var vehicle = vehicleList.value.data?[validIndex];
        updateCameraPosition(
            course: Utils.parseDouble(data: vehicle?.trackingData?.course),
            latitude: vehicle?.trackingData?.location?.latitude ?? 0,
            longitude: vehicle?.trackingData?.location?.longitude ?? 0);
      } else {
        updateCameraPositionToCurrentLocation();
      }
    } else {
      updateCameraPositionToCurrentLocation();
    }
  }

  Future<String> getCurrAddress({double? latitude, double? longitude}) async {
    try {
      // log("$latitude  $longitude  ====> LAT LONG");
      if (latitude == null || longitude == null) return "Address not available";
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      return "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
    } catch (e) {
      // debugPrint("Error LAT LONG ADDRESS" + e.toString());
      return "Address not available";
    }
  }

  /// FILTERING
  List<Data> getVehiclesWithExpiringSubscriptions() {
    List<Data> expiringVehicles = [];

    DateTime currentDate = DateTime.now();

    vehicleList.value.data?.forEach((vehicle) {
      if (vehicle.subscriptionExp != null) {
        DateTime subscriptionExpDate =
            DateFormat('yyyy-MM-dd').parse(vehicle.subscriptionExp!);

        int daysDifference = subscriptionExpDate.difference(currentDate).inDays;

        if (daysDifference <= 30) {
          expiringVehicles.add(vehicle);
        }
      }
    });

    return expiringVehicles;
  }

  List<Data> filterIgnitionOn(List<Data> vehicleList) {
    return vehicleList.where((vehicle) {
      return vehicle.trackingData?.ignition?.status == true; // Ignition is on
    }).toList();
  }

  List<Data> filterIgnitionOff(List<Data> vehicleList) {
    return vehicleList.where((vehicle) {
      return vehicle.trackingData?.ignition?.status == false; // Ignition is off
    }).toList();
  }

  List<Data> filterActiveVehicles(List<Data> vehicleList) {
    return vehicleList.where((vehicle) {
      return vehicle.status == 'Active' &&
          (vehicle.subscriptionExp == null
              ? vehicle.status == 'Active'
              : (DateFormat('yyyy-MM-dd')
                          .parse(vehicle.subscriptionExp!)
                          .difference(DateTime.now())
                          .inDays +
                      1 >
                  0)); // Status is Active
    }).toList();
  }

  List<Data> filterInactive(List<Data> vehicleList) {
    return vehicleList.where((vehicle) {
      return vehicle.status != "Active" ||
          (vehicle.subscriptionExp == null
              ? vehicle.status != 'Active'
              : (DateFormat('yyyy-MM-dd')
                          .parse(vehicle.subscriptionExp!)
                          .difference(DateTime.now())
                          .inDays +
                      1 <=
                  0)); // Status is Active
    }).toList();
  }

  List<Data> filterOffline(List<Data> vehicleList) {
    return vehicleList.where((vehicle) {
      return vehicle.trackingData?.status?.toLowerCase() !=
          "online"; // Status is Active
    }).toList();
  }

  bool checkIfInactive({Data? vehicle}) {
    if (vehicle != null) {
      return vehicle.status != "Active" ||
          (vehicle.subscriptionExp == null
              ? vehicle.status != 'Active'
              : (DateFormat('yyyy-MM-dd')
                          .parse(vehicle.subscriptionExp!)
                          .difference(DateTime.now())
                          .inDays +
                      1 <=
                  0));
    }
    return true;
  }

  bool checkIfOffline({Data? vehicle}) {
    if (vehicle != null) {
      return vehicle.trackingData?.status?.toLowerCase() != "online";
    }
    return true;
  }

  void updateFilteredList() {
    List<Data> allVehicles = vehicleList.value.data ?? [];

    // Apply search filtering
    List<Data> filteredBySearch = allVehicles.where((vehicle) {
      return vehicle.vehicleNo
              ?.toLowerCase()
              .contains(searchController.text.toLowerCase()) ??
          true;
    }).toList();
    filteredVehicleList.value = filteredBySearch;
    filteredVehicleList.refresh();
    developer.log("filtered list ${filteredVehicleList.value.length}");
  }

  void checkFilterIndex(bool updateCamera) async {
    List<Data> vehiclesToDisplay = [];
    if (isFilterSelectedindex.value == 2) {
      vehiclesToDisplay = activeVehiclesList;
    } else if (isFilterSelectedindex.value == 0) {
      vehiclesToDisplay = ignitionOnList;
    } else if (isFilterSelectedindex.value == 1) {
      vehiclesToDisplay = ignitionOffList;
    } else if (isFilterSelectedindex.value == 3) {
      vehiclesToDisplay = inActiveVehiclesList;
    } else if (isFilterSelectedindex.value == 4) {
      vehiclesToDisplay = offlineVehiclesList;
    } else {
      vehiclesToDisplay = allVehicles;
    }

    if (vehiclesToDisplay.isNotEmpty &&
        updateCamera &&
        vehiclesToDisplay[0].trackingData?.location?.latitude != null &&
        vehiclesToDisplay[0].trackingData?.location?.longitude != null) {
      updateCameraPosition(
          course: Utils.parseDouble(
              data: vehiclesToDisplay[0]?.trackingData?.course),
          latitude: vehiclesToDisplay[0].trackingData?.location?.latitude ?? 0,
          longitude:
              vehiclesToDisplay[0].trackingData?.location?.longitude ?? 0);
    }
    //else {
    //   updateCameraPositionToCurrentLocation();
    // }
 if (!isShowvehicleDetail.value &&
        selectedVehicleIMEI.value.isEmpty) {
      for (var vehicle in vehiclesToDisplay) {
        if (vehicle.trackingData?.location?.latitude != null &&
            vehicle.trackingData?.location?.longitude != null) {
          bool isInactive = checkIfInactive(vehicle: vehicle);
          bool isOffline = checkIfOffline(vehicle: vehicle);
          double? lat = vehicle.trackingData?.location?.latitude;
          double? long = vehicle.trackingData?.location?.longitude;
          if (isInactive) {
            lat = vehicle.lastLocation?.latitude;
            long = vehicle.lastLocation?.longitude;
          }
          Marker marker = await createMarker(
              id: vehicle.deviceId,
              img: vehicle.vehicletype?.icons,
              long: long,
              lat: lat,
              vehicleNo: vehicle.vehicleNo,
              imei: vehicle.imei ?? "",
              course: Utils.parseDouble(data: vehicle.trackingData?.course),
              isOffline: isOffline,
              isInactive: isInactive);
          markers.add(marker);
        }
      }
    }
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
        devicesByDetails( updateCamera: false);
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
    Position? data = await getCurrentLocation();
    latitudeUpdate.text = (data?.latitude ?? "").toString();
    longitudeUpdate.text = (data?.longitude ?? "").toString();
  }

  /// Location tracking methods

  Future<Position?> getCurrentLocation() async {
    try {
      await _requestLocationPermission(updateCamera: false);
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      // print('Error fetching location: $e');
      return null;
    }
  }

  // Method to check location permissions and GPS status
  Future<void> checkStatus() async {
    bool _permissionGranted = await _isPermissionGranted();
    bool _gpsEnabled = await _isGpsEnabled();

    if (_gpsEnabled && _permissionGranted) {
      _startLocationTracking();
    } else {
      if (!_gpsEnabled) await _requestEnableGps();
      if (!_permissionGranted) await _requestLocationPermission();
    }
  }

  // Method to request location permission
  Future<bool> _isPermissionGranted() async {
    return await Permission.locationWhenInUse.isGranted;
  }

  // Method to check if GPS is enabled
  Future<bool> _isGpsEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Request to enable GPS
  Future<void> _requestEnableGps() async {
    bool isGpsActive = await Geolocator.openLocationSettings();
    gpsEnabled = isGpsActive;
  }

  // Request location permission
  Future<void> _requestLocationPermission({bool updateCamera = true}) async {
    PermissionStatus permissionStatus =
        await Permission.locationWhenInUse.request();
    permissionGranted = permissionStatus == PermissionStatus.granted;
    if (permissionGranted) {
      _startLocationTracking(updateCamera: updateCamera);
    } else {
      Utils.getSnackbar("Please turn on device location", "");
    }
  }

  void _startLocationTracking({bool updateCamera = true}) async {
    // getCurrentLocation();
    Position pos = await Geolocator.getCurrentPosition();

    currentLocation.value = LatLng(pos.latitude, pos.longitude);
    if (updateCamera) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: currentLocation.value, zoom: 7),
        ),
      );
    }

    // positionStream = Geolocator.getPositionStream(
    //         locationSettings: LocationSettings(accuracy: LocationAccuracy.high))
    //     .listen((Position position) {
    //   updateCurrentPosition(position.latitude, position.longitude);
    // });
  }

  ///MAP methods

  void updateCameraPosition(
      {required double latitude,
      required double longitude,
      required double course}) {
    if (Get.put(BottomBarController()).selectedIndex == 2) {
      if (mapController != null) {
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                // bearing: course,
                target: LatLng(latitude, longitude),
                zoom: 7),
          ),
        );
      }
    }
  }

  void updateCameraPositionToCurrentLocation() async {
    if (Get.put(BottomBarController()).selectedIndex == 2) {
      Position? data = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (data != null && mapController != null) {
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(data.latitude, data.longitude), zoom: 7),
          ),
        );
      }
    }
  }

  void updateCameraPositionWithZoom(
      {required double latitude,
      required double longitude,
      required double course}) async {
    if (Get.put(BottomBarController()).selectedIndex == 2) {
      if (mapController != null) {
        // double offset = 0.0009;
        /*LatLng newLatLng =
            await calcLatLong(offset, course, latitude, longitude);*/
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              bearing: course,
              target: LatLng(latitude, longitude), //todo
              zoom: 17,
            ),
          ),
        );
      }
    }
  }

  // On Map Created
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onMarkerTapped(int index, String imei, String vehicleNo, double course,
      {double? lat, double? long}) async {
    isShowVehicleDetails(index, imei);
    isExpanded.value = false;
    await devicesByDetails(updateCamera: false, showDialog: true);
    if (lat != null && long != null) {
      updateCameraPositionWithZoom(
          latitude: lat, longitude: long, course: course);
    }
  }

  void openMaps({LatLng? data}) async {
    try {
      if (data != null) {
        // Utils.getSnackbar("Redirecting to maps...", "Please wait for the process");
        String appleUrl =
            'https://maps.apple.com/?saddr=&daddr=${data.latitude},${data.longitude}&directionsmode=driving';
        String googleUrl =
            'https://www.google.com/maps/search/?api=1&query=${data.latitude},${data.longitude}';
        Uri appleUri = Uri.parse(appleUrl);
        Uri googleUri = Uri.parse(googleUrl);
        if (Platform.isIOS) {
          if (await canLaunchUrl(appleUri)) {
            await launchUrl(appleUri);
          } else {
            if (await canLaunchUrl(googleUri)) {
              await launchUrl(googleUri);
            } else {
              throw 'Could not open the map.';
            }
          }
        } else {
          if (await canLaunchUrl(googleUri)) {
            await launchUrl(googleUri);
          } else {
            throw 'Could not open the map.';
          }
        }
      } else {
        throw 'Could not fetch location';
      }
    } catch (e) {
      Utils.getSnackbar("Error", e.toString());
    }
  }

  Future<Marker> createMarker(
      {double? lat,
      double? long,
      String? img,
      String? id,
      required double course,
      required String imei,
      required bool isInactive,
      required bool isOffline,
      String? vehicleNo}) async {
    BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
    developer.log("IMEI MARkER $imei");
    if (isInactive) {
      markerIcon = await svgToBitmapDescriptorInactiveIcon();
    } else {
      markerIcon = await svgToBitmapDescriptor('${ProjectUrls.imgBaseUrl}$img');
    }
    final markerId = "${ProjectUrls.imgBaseUrl}$img$imei";
    final marker = Marker(
        rotation: course,
        markerId: MarkerId(markerId),
        position: LatLng(
          lat ?? 0,
          long ?? 0,
        ),
        /* infoWindow: Platform.isAndroid
            ? InfoWindow(
                title: 'Vehicle No: ${vehicleNo}',
                snippet: 'IMEI: ${imei}',
              )
            : InfoWindow.noText,*/
        icon: markerIcon,
        flat: true,
        anchor: Offset(0.5, 0.5),
        onTap: () => _onMarkerTapped(-1, imei, vehicleNo ?? "-", course,
            lat: lat, long: long));
    return marker;
  }
}
