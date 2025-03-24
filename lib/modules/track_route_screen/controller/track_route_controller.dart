import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:track_route_pro/constants/constant.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/bottom_screen/controller/bottom_bar_controller.dart';
import 'package:track_route_pro/modules/vehicales/model/filter_model.dart';
import 'package:track_route_pro/service/api_service/api_service.dart';
import 'package:track_route_pro/service/model/presentation/track_route/track_route_vehicle_list.dart';
import 'package:track_route_pro/utils/app_prefrance.dart';
import 'package:track_route_pro/utils/common_import.dart';
import 'package:track_route_pro/utils/enums.dart';
import 'package:track_route_pro/utils/map_item.dart';
import 'package:track_route_pro/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/project_urls.dart';
import '../../../service/model/presentation/vehicle_type/Data.dart';
import '../../../utils/info_window.dart';
import '../view/widgets/vehicle_dialog.dart';

class TrackRouteController extends GetxController {
  Rx<TrackRouteVehicleList> vehicleList = Rx(TrackRouteVehicleList());
  RxList<FilterData> filterData = RxList([]);
  var markers = <Marker>[].obs;

  // New Rx lists for filtered results
  RxList<Data> ignitionOnList = <Data>[].obs;
  RxList<Data> ignitionOffList = <Data>[].obs;
  RxList<Data> activeVehiclesList = <Data>[].obs;
  RxList<Data> inActiveVehiclesList = <Data>[].obs;
  RxList<Data> offlineVehiclesList = <Data>[].obs;
  final GlobalKey markerKey = GlobalKey();

  // RxList<Data> inActiveVehiclesList = <Data>[].obs;
  RxList<Data> allVehicles = <Data>[].obs;
  RxList<DataVehicleType> vehicleTypeList = <DataVehicleType>[].obs;
  RxString devicesOwnerID = RxString('');
  RxString devicesId = RxString('');
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
  RxInt selectedVehicleIndex = RxInt(0);
  RxBool isListShow = false.obs;
  RxBool isedit = false.obs;
  StreamSubscription<Position>? positionStream;
  var currentLocation =
      LatLng(20.5937, 78.9629).obs; // Current vehicle location
  // var polylines = <Polyline>[].obs; // List of polylines to display on the map
  var isLoading = false.obs; // Loading state

  final ApiService apiService = ApiService.create();
  Rx<NetworkStatus> networkStatus = Rx(NetworkStatus.IDLE);

  Timer? _refreshTimer;

  @override
  void onInit() {
    super.onInit();
    checkStatus();
    showLoader.value = true;

    loadUser().then(
      (value) {
        devicesByOwnerID(false);
      },
    );

    // Set up a timer to call `devicesByOwnerID` every 30 seconds if `isEdit` is false
    _refreshTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (!isedit.value) {
        devicesByOwnerID(false);
      }
    });
  }

  Future<String> getAddressFromLatLong(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];

      return "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
    } catch (e) {
      return "Address not available";
    }
    return "Address not available";
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

  Future<BitmapDescriptor> svgToBitmapDescriptor(String url,
      {Size size = const Size(120, 120)}) async {
    try {
      BitmapDescriptor selectedIcon = await SvgPicture.network(
        url,
        height: 50,
        width: 50,
        // fit: BoxFit.scaleDown,
      ).toBitmapDescriptor();
      return selectedIcon;
    } catch (e) {
      // debugPrint("Error loading SVG: $e");
      return BitmapDescriptor.defaultMarker;
    }
  }

  Future<BitmapDescriptor> svgToBitmapDescriptorInactiveIcon(
      {Size size = const Size(120, 120)}) async {
    try {
      BitmapDescriptor selectedIcon = await SvgPicture.asset(
        "assets/images/svg/deactivated-icon.svg",
        height: 40,
        width: 40,
        // fit: BoxFit.scaleDown,
      ).toBitmapDescriptor();
      return selectedIcon;
    } catch (e) {
      // debugPrint("Error loading SVG: $e");
      return BitmapDescriptor.defaultMarker;
    }
  }

  Future<BitmapDescriptor> svgToBitmapDescriptorOfflineIcon(
      {Size size = const Size(120, 120)}) async {
    try {
      BitmapDescriptor selectedIcon = await SvgPicture.asset(
        "assets/images/svg/offline.svg",
        height: 40,
        width: 40,
        // fit: BoxFit.scaleDown,
      ).toBitmapDescriptor();
      return selectedIcon;
    } catch (e) {
      // debugPrint("Error loading SVG: $e");
      return BitmapDescriptor.defaultMarker;
    }
  }

  /* Future<BitmapDescriptor> createMarkerIcon(String indexedImage,
      {int width = 120, int height = 120}) async {
    try {
      // Load image from network
      final ByteData data =
          await NetworkAssetBundle(Uri.parse(indexedImage)).load("");
      final Uint8List bytes = data.buffer.asUint8List();

      // Decode the image to get its original size
      final ui.Codec codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: width,
        targetHeight: height,
      );
      final ui.FrameInfo frameInfo = await codec.getNextFrame();

      // Convert the resized image to bytes
      final ByteData? resizedData =
          await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List resizedBytes = resizedData!.buffer.asUint8List();

      return BitmapDescriptor.fromBytes(resizedBytes);
    } catch (e) {
      return BitmapDescriptor.defaultMarker;
    }
  }

*/

  // Function to Filter for Vehicles with Ignition On
  List<Data> filterIgnitionOn(List<Data> vehicleList) {
    return vehicleList.where((vehicle) {
      return vehicle.trackingData?.ignition?.status == true; // Ignition is on
    }).toList();
  }

  // Function to Filter for Vehicles with Ignition Off
  List<Data> filterIgnitionOff(List<Data> vehicleList) {
    return vehicleList.where((vehicle) {
      return vehicle.trackingData?.ignition?.status == false; // Ignition is off
    }).toList();
  }

  // Function to Filter for Active Vehicles
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
      return vehicle.trackingData?.status?.toLowerCase() != "online"; // Status is Active
    }).toList();
  }

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

  void updateCameraPosition(
      {required double latitude, required double longitude}) {
    if (Get.put(BottomBarController()).selectedIndex == 2) {
      if (mapController != null) {
        log("UPDATE CAMERA =====> ");
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(latitude, longitude), zoom: 7),
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
      {required double latitude, required double longitude}) {
    if (Get.put(BottomBarController()).selectedIndex == 2) {
      if (mapController != null) {
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(latitude - 0.0020, longitude),
              zoom: 16,
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

  void _onMarkerTapped(int index, String imei, String vehicleNo,
      {double? lat, double? long}) async {
    isShowVehicleDetails(index, imei);
    isExpanded.value = false;
    await devicesByDetails(imei, updateCamera: false, showDialog: true);

    try {
      if (Platform.isIOS) {
        addCustomMarker(LatLng((lat ?? 0) + 0.0011, long ?? 0),
            "Vehicle No.: $vehicleNo", "IMEI: $imei");
      }
    } catch (e, s) {
      log("EXCEPTION $e ====> $s");
    }

    /* if(Platform.isIOS){
        customInfoWindowController.addInfoWindow!(
          _buildCustomInfoWindow(vehicleNo, imei),
          LatLng((lat ?? 0), long ?? 0),
        );
    }*/
    if (lat != null && long != null) {
      updateCameraPositionWithZoom(latitude: lat, longitude: long);
    }
  }

  Widget _buildCustomInfoWindow(String? vehicleNo, String imei) {
    return Container(
      width: 200,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Vehicle No: ${vehicleNo ?? "N/A"}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 3),
          Text('IMEI: $imei'),
        ],
      ),
    );
  }

  Future<void> addCustomMarker(
      LatLng position, String text1, String text2) async {
    Uint8List? markerIcon = await _captureMarkerWidget();

    if (markerIcon != null) {
      final marker = Marker(
        markerId: MarkerId("INFOWINDOWMARKER$text1$text2"),
        position: position,
        icon: BitmapDescriptor.fromBytes(markerIcon),
      );

      markers.add(marker);
    }
  }

  Future<Uint8List?> _captureMarkerWidget() async {
    RenderRepaintBoundary? boundary =
        markerKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary != null) {
      ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    }
    return null;
  }

  Future<Uint8List?> getWidgetMarker(String text1, String text2) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final painter = MarkerPainter(text1, text2);

    painter.paint(canvas, Size(500, 120));

    final img = await recorder.endRecording().toImage(500, 120);
    final byteData = await img.toByteData(format: ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  Future<void> loadUser() async {
    String? userId = await AppPreference.getStringFromSF(Constants.userId);
    // print('userid:::::>${userId}');
    devicesOwnerID.value = userId ?? '';
  }

  Future<void> isShowVehicleDetails(int index, String imei) async {
    isShowvehicleDetail.value = true;
    selectedVehicleIndex.value = index;
    selectedVehicleIMEI.value = imei;
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

  // Method to update current position on the map
  void updateCurrentPosition(double latitude, double longitude) {
    // currentLocation.value = LatLng(latitude, longitude);
    // mapController.animateCamera(CameraUpdate.newLatLng(currentLocation.value));
  }

  @override
  void onClose() {
    positionStream?.cancel();
    super.onClose();
  }

  ///API SERVICE FOR ALL DEVICE

  Future<void> devicesByOwnerID(bool updateCamera) async {
    bool isLogIn =
        await AppPreference.getBoolFromSF(Constants.isLogIn) ?? false;
    if (isLogIn) {
      try {
        final body = {"ownerId": "${devicesOwnerID.value}"};
        networkStatus.value = NetworkStatus.LOADING;

        final response = await apiService.devicesByOwnerID(body);
        if (response.status == 200) {
          networkStatus.value = NetworkStatus.SUCCESS;
          vehicleList.value = response;

          final allVehiclesRes =
              vehicleList.value.data ?? []; // Assuming data is a List<Data>

          // log("DATA ${allVehiclesRes.length}");
          allVehicles.value = allVehiclesRes;
          ignitionOnList.value = filterIgnitionOn(allVehiclesRes).obs;
          ignitionOffList.value = filterIgnitionOff(allVehiclesRes).obs;
          activeVehiclesList.value = filterActiveVehicles(allVehiclesRes).obs;
          // inActiveVehiclesList.value = filterInActiveVehicles(allVehiclesRes).obs;
          inActiveVehiclesList.value = filterInactive(allVehiclesRes).obs;
          offlineVehiclesList.value = filterOffline(allVehiclesRes).obs;
          // log("activeVehiclesList===>${jsonEncode(activeVehiclesList)}");
          // log("ignitionOnList===>${jsonEncode(ignitionOnList)}");
          // log("ignitionOffList===>$ignitionOffList");
          // log("idleList===>$idleList");
          // Initialize filter data after API call and filtering
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

          getVehicleTypeList();

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
                    course: Utils.parseDouble(data: vehicle.course),
                    isOffline:isOffline,
                    isInactive: isInactive);
                markers.add(m);
              }
            }
            /*  if (updateCamera &&
                allVehiclesRes.isNotEmpty &&
                allVehiclesRes[0].trackingData?.location?.latitude != null &&
                allVehiclesRes[0].trackingData?.location?.longitude != null) {
              updateCameraPosition(
                  latitude:
                      allVehiclesRes[0].trackingData?.location?.latitude ?? 0,
                  longitude:
                      allVehiclesRes[0].trackingData?.location?.longitude ?? 0);
            }*/
          } else if (isFilterSelected.value) {
            checkFilterIndex(false);
          } else if (isShowvehicleDetail.value &&
              selectedVehicleIMEI.value.isNotEmpty) {
            devicesByDetails(selectedVehicleIMEI.value ?? '',
                updateCamera: false);
          }
        } else if (response.status == 400) {
          networkStatus.value = NetworkStatus.ERROR;
        }
      } catch (e, s) {
        log("erroe in vehicle $e $s");
        networkStatus.value = NetworkStatus.ERROR;
      }
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

  Rx<TrackRouteVehicleList> deviceDetail = Rx(TrackRouteVehicleList());

  // ///API SEVICE FOR DEVICE DETAILS
  Future<void> devicesByDetails(String imei,
      {bool updateCamera = true,
      bool showDialog = false,
      bool zoom = false}) async {
    try {
      final body = {"deviceId": "${imei}"};
      networkStatus.value = NetworkStatus.LOADING;

      final response = await apiService.devicesByOwnerID(body);
      deviceDetail.value.data?.clear();

      if (response.status == 200) {
        networkStatus.value = NetworkStatus.SUCCESS;
        deviceDetail.value = response;
        deviceDetail.refresh();
        if (deviceDetail.value.data?.isNotEmpty ?? false) {
          final data = deviceDetail.value.data?[0];

          if (updateCamera &&
              data?.trackingData?.location?.latitude != null &&
              data?.trackingData?.location?.longitude != null) {
            if (zoom) {
              updateCameraPositionWithZoom(
                  latitude: data?.trackingData?.location?.latitude ?? 0,
                  longitude: data?.trackingData?.location?.longitude ?? 0);
            } else {
              updateCameraPosition(
                  latitude: data?.trackingData?.location?.latitude ?? 0,
                  longitude: data?.trackingData?.location?.longitude ?? 0);
            }
          }

          relayStatus.value = response.data?[0].immobiliser ?? "Stop";
          // vehicleRegistrationNumber.text = data?.vehicleRegistrationNo ?? '';
          vehicleName.text = data?.vehicleNo ?? '';
          dateAdded.text = formatDate(data?.dateAdded);
          driverName.text = data?.driverName ?? '';
          driverMobileNo.text = data?.mobileNo ?? '';
          // vehicleBrand.text = data?.vehicleBrand ?? '';
          // vehicleModel.text = data?.vehicleModel ?? '';
          maxSpeedUpdate.text =
              ((data?.maxSpeed ?? 0).toStringAsFixed(0) ?? '').toString();
          latitudeUpdate.text = (data?.location?.latitude ?? '').toString();
          longitudeUpdate.text = (data?.location?.longitude ?? '').toString();
          parkingUpdate.value = data?.parking ?? false;
          speedUpdate.value = data?.speedStatus ?? false;

          geofence.value = data?.locationStatus ?? false;
          areaUpdate.text = (data?.area ?? '').toString();

          insuranceExpiryDate.text = formatDate(data?.insuranceExpiryDate);
          pollutionExpiryDate.text = formatDate(data?.pollutionExpiryDate);
          fitnessExpiryDate.text = formatDate(data?.fitnessExpiryDate);
          nationalPermitExpiryDate.text =
              formatDate(data?.nationalPermitExpiryDate);
          if (showDialog && (deviceDetail.value.data?.isNotEmpty ?? false)) {
            if ((deviceDetail.value.data?[0].vehicleNo?.isEmpty ?? true) ||
                (deviceDetail.value.data?[0].driverName?.isEmpty ?? true)) {
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
                course: Utils.parseDouble(data: data?.course),
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
        } else {
          isShowvehicleDetail.value = false;
          selectedVehicleIMEI.value = "";
          selectedVehicleIndex.value = -1;
        }
      } else if (response.status == 400) {
        networkStatus.value = NetworkStatus.ERROR;
      }
    } catch (e, s) {
      networkStatus.value = NetworkStatus.ERROR;

      log("Error : $e   $s");
    }
  }

  String formatDate(String? dateStr) {
    if (dateStr == null) return ''; // Handle null case
    try {
      // Parse the date string to a DateTime object
      DateTime dateTime = DateTime.parse(dateStr);
      // Format the date as dd-mm-yyyy
      return DateFormat('dd-MM-yyyy').format(dateTime);
    } catch (e) {
      return '-'; // Handle parsing error
    }
  }

// ALL VAR FOR EDIT DETAILS

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
        lat = deviceDetail.value.data?[0].location?.latitude ?? 0.0;
        long = (deviceDetail.value.data?[0].location?.longitude ?? 0.0);
        areaUpdate.text = (deviceDetail.value.data?[0].area ?? '').toString();
      }

      if (!editSpeed) {
        maxSpeedUpdate.text =
            (deviceDetail.value.data?[0].maxSpeed ?? '').toString();
      } else {
        speedUpdate.value = true;
      }

      if (!editGeneral) {
        resetGeneralInfo();
      }

      final body = {
        // "vehicleRegistrationNo": vehicleRegistrationNumber.text,
        "vehicleNo": vehicleName.text,
        // "IMEINo" :deviceDetail.value.data?[0].imei,
        // "deviceID" :deviceDetail.value.data?[0].deviceId,
        // "dateAdded": dateAdded.text.isNotEmpty
        //     ? DateFormat('yyyy-MM-dd')
        //         .format(DateFormat('dd-MM-yyyy').parse(dateAdded.text))
        //     : "",
        "driverName": driverName.text,
        "mobileNo": driverMobileNo.text,
        // "vehicleType": vehicleType.value.id.toString(),
        // "vehicleBrand": vehicleBrand.text,
        // "vehicleModel": vehicleModel.text,
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
        "_id": deviceDetail.value.data?[0].sId ?? '',
        "maxSpeed": maxSpeedUpdate.text.trim(),
        "parking": parkingUpdate.value,
        "Area": areaUpdate.text.trim(),
        "speedStatus": speedUpdate.value,
        "locationStatus": geofence.value,
        "location": {"longitude": long, "latitude": lat}
      };
      networkStatus.value = NetworkStatus.LOADING;

      await apiService.editDevicesByOwnerID(body);
      devicesByDetails(deviceDetail.value.data?[0].imei ?? "",
          updateCamera: false);
      Utils.getSnackbar('Success', 'Your detail is updated');
      // deviceDetail.value.data?.clear();
      // deviceDetail.value.data?.clear();
      //  if (response.message == "success") {
      //   networkStatus.value = NetworkStatus.SUCCESS;
      //   stackIndex.value = 0;
      //
      // }
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
        "_id": deviceDetail.value.data?[0].sId ?? '',
      };
      networkStatus.value = NetworkStatus.LOADING;

      await apiService.editDevicesByOwnerID(body);
      devicesByDetails(deviceDetail.value.data?[0].imei ?? "",
          updateCamera: false);
      Utils.getSnackbar('Success', 'Your detail is updated');
    } catch (e) {
      networkStatus.value = NetworkStatus.ERROR;

      print("Error during data update: $e");
    }
  }

  Future<void> editGeofenceToggle(BuildContext context) async {
    try {
      final body = {
        "_id": deviceDetail.value.data?[0].sId ?? '',
        "locationStatus": geofence.value
      };
      networkStatus.value = NetworkStatus.LOADING;

      await apiService.editDevicesByOwnerID(body);
      /* devicesByDetails(deviceDetail.value.data?[0].imei ?? "",
          updateCamera: false);*/
      // Utils.getSnackbar('Success', 'Your detail is Updated');
    } catch (e) {
      networkStatus.value = NetworkStatus.ERROR;

      print("Error during data update: $e");
    }
  }

  Future<void> editSpeedToggle(BuildContext context) async {
    try {
      final body = {
        "speedStatus": speedUpdate.value,
        "_id": deviceDetail.value.data?[0].sId ?? '',
      };
      networkStatus.value = NetworkStatus.LOADING;

      await apiService.editDevicesByOwnerID(body);
      /*devicesByDetails(deviceDetail.value.data?[0].imei ?? "",
          updateCamera: false);
      Utils.getSnackbar('Success', 'Your detail is Updated');*/
    } catch (e) {
      networkStatus.value = NetworkStatus.ERROR;

      print("Error during data update: $e");
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
    if (isOffline) {
      markerIcon = await svgToBitmapDescriptorOfflineIcon();
    }
    else if (isInactive) {
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
        infoWindow: Platform.isAndroid
            ? InfoWindow(
                title: 'Vehicle No: ${vehicleNo}',
                snippet: 'IMEI: ${imei}',
              )
            : InfoWindow.noText,
        icon: markerIcon,
        onTap: () =>
            _onMarkerTapped(-1, imei, vehicleNo ?? "-", lat: lat, long: long));
    return marker;
  }

  void showAllVehicles() async {
    isShowvehicleDetail.value = false;
    markers.value = [];
    selectedVehicleIndex.value = -1;
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
            latitude: vehicle?.trackingData?.location?.latitude ?? 0,
            longitude: vehicle?.trackingData?.location?.longitude ?? 0);
      } else {
        updateCameraPositionToCurrentLocation();
      }
    } else {
      updateCameraPositionToCurrentLocation();
    }
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
    } else {
      vehiclesToDisplay = allVehicles;
    }
    if (vehiclesToDisplay.isNotEmpty &&
        updateCamera &&
        vehiclesToDisplay[0].trackingData?.location?.latitude != null &&
        vehiclesToDisplay[0].trackingData?.location?.longitude != null) {
      updateCameraPosition(
          latitude: vehiclesToDisplay[0].trackingData?.location?.latitude ?? 0,
          longitude:
              vehiclesToDisplay[0].trackingData?.location?.longitude ?? 0);
    }
    //else {
    //   updateCameraPositionToCurrentLocation();
    // }

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
            course: Utils.parseDouble(data: vehicle.course),
            isOffline: isOffline,
            isInactive: isInactive);
        markers.add(marker);
      }
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
        devicesByDetails(imei, updateCamera: false);
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
        devicesByDetails(imei, updateCamera: false);
        // checkRelayStatus(imei);
        networkStatus.value = NetworkStatus.SUCCESS;
      }
    } catch (e) {
      // debugPrint("EXCEPTION $e");
      networkStatus.value = NetworkStatus.ERROR;
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

  void resetGeneralInfo() {
    final data = deviceDetail.value.data?[0];
    // vehicleRegistrationNumber.text = data?.vehicleRegistrationNo ?? '';
    vehicleName.text = data?.vehicleNo ?? '';
    dateAdded.text = formatDate(data?.dateAdded);
    driverName.text = data?.driverName ?? '';
    driverMobileNo.text = data?.mobileNo ?? '';
    // vehicleBrand.text = data?.vehicleBrand ?? '';
    // vehicleModel.text = data?.vehicleModel ?? '';
    // vehicleType.value = DataVehicleType(
    //     id: data?.vehicletype?.sId ?? "",
    //     name: data?.vehicletype?.vehicleTypeName ?? "");
    insuranceExpiryDate.text = formatDate(data?.insuranceExpiryDate);
    pollutionExpiryDate.text = formatDate(data?.pollutionExpiryDate);
    fitnessExpiryDate.text = formatDate(data?.fitnessExpiryDate);
    nationalPermitExpiryDate.text = formatDate(data?.nationalPermitExpiryDate);
  }

  void getCurrLocationForGeofence() async {
    Position? data = await getCurrentLocation();
    latitudeUpdate.text = (data?.latitude ?? "").toString();
    longitudeUpdate.text = (data?.longitude ?? "").toString();
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
}
