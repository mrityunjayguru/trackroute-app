import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:track_route_pro/constants/constant.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/bottom_screen/controller/bottom_bar_controller.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_device_controller.dart';
import 'package:track_route_pro/modules/track_route_screen/view/widgets/device/vehicle_selected.dart';
import 'package:track_route_pro/modules/vehicales/model/filter_model.dart';
import 'package:track_route_pro/service/api_service/api_service.dart';
import 'package:track_route_pro/service/model/presentation/track_route/track_route_vehicle_list.dart';
import 'package:track_route_pro/utils/app_prefrance.dart';
import 'package:track_route_pro/utils/common_import.dart';
import 'package:track_route_pro/utils/enums.dart';
import 'package:track_route_pro/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/project_urls.dart';
import '../../../service/model/presentation/vehicle_type/Data.dart';
import '../../../utils/common_map_helper.dart';
import '../../route_history/controller/common.dart';
import '../view/widgets/device/track_device.dart';

class TrackRouteController extends GetxController {
  Rx<TrackRouteVehicleList> vehicleList = Rx(TrackRouteVehicleList());
  RxList<Data> filteredVehicleList = <Data>[].obs;
  RxList<FilterData> filterData = RxList([]);
  var markers = <Marker>[].obs;
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
  late GoogleMapController mapController;
  bool gpsEnabled = false;
  bool permissionGranted = false;
  RxBool isExpanded = false.obs;
  RxBool isFilterSelected = false.obs;
  RxInt isFilterSelectedindex = RxInt(-1);
  RxBool showLoader = false.obs;

  // RxInt stackIndex = RxInt(0);
  RxBool isSatellite = false.obs;
  double height = 848;
  bool dialogOpen = false;
  var currentLocation = LatLng(20.5937, 78.9629).obs;
  var isLoading = false.obs; // Loading state

  final ApiService apiService = ApiService.create();
  Rx<NetworkStatus> networkStatus = Rx(NetworkStatus.IDLE);
  TextEditingController searchController = TextEditingController();

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    checkStatus();
    showLoader.value = true;

    loadUser().then(
      (value) {
        getAllDevices();
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
    _timer?.cancel();
    super.onClose();
  }

  Future<void> loadUser() async {
    String? userId = await AppPreference.getStringFromSF(Constants.userId);
    // print('userid:::::>${userId}');
    devicesOwnerID.value = userId ?? '';
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
    if (!isFilterSelected.value) {
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
          } else {
            Marker m = await createMarker(
                imei: vehicle.imei ?? "",
                lat: lat,
                long: long,
                img: vehicle.vehicletype?.icons,
                id: vehicle.deviceId.toString(),
                vehicleNo: vehicle.vehicleNo,
                course: Utils.parseDouble(data: vehicle.trackingData?.course),
                isOffline: isOffline,
                isInactive: isInactive);
            markers.add(m);
          }
        }
      }
    } else {
      checkFilterIndex(false);
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

  Future<void> isShowVehicleDetails(String imei) async {
    ///init socket & store data in deviceDetails for one device
    try {
      developer.log("EXCEPTION");
      final controller = Get.isRegistered<DeviceController>()
          ? Get.find<DeviceController>() // Find if already registered
          : Get.put(DeviceController());
      controller.deviceDetail.value = null;
      controller.selectedVehicleIMEI.value = imei;
      controller.markerIcon = null;
      controller.getDeviceByIMEI(zoom: true, showDialog: true);
      Get.to(() => TrackDeviceView(),
          transition: Transition.upToDown,
          duration: const Duration(milliseconds: 300));
    } catch (e, s) {
      developer.log(" EXCEPTION $e $s");
    }
  }

  void showEditView(String imei) {
    ///store data in deviceDetails for one device and edit data
    final controller = Get.isRegistered<DeviceController>()
        ? Get.find<DeviceController>() // Find if already registered
        : Get.put(DeviceController());
    controller.selectedVehicleIMEI.value = imei;
    controller.getDeviceByIMEI(zoom: true, showDialog: true, initialize: false);
    controller.manageScreen = true;
    Get.to(() => VehicleSelected(),
        transition: Transition.upToDown,
        duration: const Duration(milliseconds: 300));
    controller.isedit.value = false;
    controller.editGeofence.value = false;
    controller.editSpeed.value = false;
  }

  void removeFilter() {
    isExpanded.value = false;
    isFilterSelected.value = false;
    isFilterSelectedindex.value = -1;
  }

  void showAllVehicles() async {
    isSheetExpanded.value = false;
    markers.value = [];
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
      return vehicle.status?.toLowerCase() == 'active' &&
          (vehicle.subscriptionExp == null
              ? vehicle.status?.toLowerCase() == 'active'
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
      return vehicle.status?.toLowerCase() != "active" ||
          (vehicle.subscriptionExp == null
              ? vehicle.status?.toLowerCase() != 'active'
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
      return vehicle.status?.toLowerCase() != "active" ||
          (vehicle.subscriptionExp == null
              ? vehicle.status?.toLowerCase() != 'active'
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
        } else {
          Marker marker = await createMarker(
              id: vehicle.deviceId.toString(),
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
              target: LatLng(latitude, longitude),
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

  void onMarkerTapped(int index, String imei, String vehicleNo, double course,
      {double? lat, double? long}) async {
    isShowVehicleDetails(imei);
    if (lat != null && long != null) {
      updateCameraPositionWithZoom(
          latitude: lat, longitude: long, course: course);
    }
  }

  void openMaps({
    required LatLng data,
    String? placeType,
  }) async {
    try {
      final double lat = data.latitude;
      final double lng = data.longitude;

      String googleUrl;

      if (placeType == 'streetview') {
        final isAvailable = await checkStreetViewAvailability(lat, lng);

        if (!isAvailable) {
          Utils.getSnackbar("Street View", "Not available at this location.");
          return;
        }

        googleUrl =
            'https://www.google.com/maps/@?api=1&map_action=pano&viewpoint=$lat,$lng';
      } else if (placeType != null) {
        googleUrl =
            'https://www.google.com/maps/search/${Uri.encodeComponent(placeType)}/@$lat,$lng,14z';
      } else {
        googleUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
      }

      final Uri googleUri = Uri.parse(googleUrl);
      final launchMode = placeType != null
          ? LaunchMode.inAppBrowserView
          : LaunchMode.externalApplication;

      if (await canLaunchUrl(googleUri)) {
        await launchUrl(googleUri, mode: launchMode);
      } else {
        throw 'Could not open the map.';
      }
    } catch (e) {
      Utils.getSnackbar("Error", e.toString());
    }
  }

  Future<bool> checkStreetViewAvailability(double lat, double lng) async {
    final apiKey = 'AIzaSyAhT2p2a9U5s9I_Tzmi8ilRMF37CxXz7pU';
    final url =
        'https://maps.googleapis.com/maps/api/streetview/metadata?location=$lat,$lng&key=$apiKey';

    final dio = Dio();

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final data = response.data;
        return data['status'] == 'OK';
      }
    } catch (e) {
      debugPrint("StreetView check error: $e");
    }

    return false;
  }

  BitmapDescriptor? inactiveIcon;
  Future<Marker> createMarker(
      {double? lat,
      double? long,
      String? img,
      String? id,
      required double course,
      required String imei,
      required bool isInactive,
      bool change = true,
      required bool isOffline,
      String? vehicleNo}) async {
    BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
    if (isInactive) {
      if (inactiveIcon == null) {
        inactiveIcon = await svgToBitmapDescriptorInactiveIcon();
      }
      markerIcon = inactiveIcon ?? BitmapDescriptor.defaultMarker;
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
        onTap: () => onMarkerTapped(-1, imei, vehicleNo ?? "-", course,
            lat: lat, long: long));
    return marker;
  }
}
