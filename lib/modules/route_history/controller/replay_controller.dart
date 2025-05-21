import 'dart:async';
import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:track_route_pro/config/app_sizer.dart';
import 'package:track_route_pro/modules/route_history/controller/location_controller.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_route_controller.dart';

import '../../../config/theme/app_colors.dart';
import '../../../constants/project_urls.dart';
import '../../../service/model/route/Data.dart';
import '../../../service/model/route/StopCount.dart';
import '../../../service/model/route/TrackingData.dart';
import '../../../utils/common_import.dart';
import '../../../utils/utils.dart';
import '../../track_route_screen/controller/track_device_controller.dart';
import 'common.dart';

class ReplayController extends GetxController {
  List<RouteHistoryResponse> vehicleListReplay = [];
  List<StopCount> stops = [];
  var markers = <Marker>[].obs;
  var arrowMarker = <Marker>[].obs;
  late GoogleMapController mapController;
  var polylines = <Polyline>[].obs;
  RxBool showLoader = false.obs;
  late final LocationController locController;
  RxInt selectStopIndex = (-1).obs;
  var showArrow = true.obs;
  var showStops = true.obs;
  var showButtons = false.obs;
  @override
  void onInit() {
    locController = Get.isRegistered<LocationController>()
        ? Get.find<LocationController>() // Find if already registered
        : Get.put(LocationController());
    super.onInit();
  }

  void setInitData(
      List<RouteHistoryResponse> data, List<StopCount> stops) async {
    showLoader.value = true;
    List<RouteHistoryResponse> processedData = [];

    double? lastLat;
    double? lastLon;

    for (var vehicle in data) {
      final lat = vehicle.trackingData?.location?.latitude;
      final lon = vehicle.trackingData?.location?.longitude;

      if (lat != null && lon != null) {
        if (lat != lastLat || lon != lastLon) {
          processedData.add(vehicle);
          lastLat = lat;
          lastLon = lon;
        }
      }
    }

    vehicleListReplay = processedData;
    this.stops = stops;

    locController.loadData(vehicleListReplay);
    selectStopIndex.value = -1;
  }

  double getBearing(LatLng start, LatLng end) {
    final lat1 = radians(start.latitude);
    final lon1 = radians(start.longitude);
    final lat2 = radians(end.latitude);
    final lon2 = radians(end.longitude);

    final dLon = lon2 - lon1;
    final y = sin(dLon) * cos(lat2);
    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);

    final bearing = atan2(y, x);
    return (degrees(bearing) + 360) % 360;
  }

  double radians(double degree) => degree * pi / 180;
  double degrees(double radian) => radian * 180 / pi;
  Future<void> showMapData() async {
    polylines.value = [];
    List<TrackingData> polylineCoordinates = [];
    List<LatLng> polylineLocation = [];

    for (int i = 0; i < vehicleListReplay.length; i++) {
      if (vehicleListReplay[i].trackingData?.location?.latitude != null &&
          vehicleListReplay[i].trackingData?.location?.longitude != null) {
        String time = "";
        if (vehicleListReplay[i].dateFiled != null) {
          time = vehicleListReplay[i].dateFiled?.split(" ")[1] ?? "N?A";
        }
        if (vehicleListReplay[i].trackingData?.location != null) {
          double lat =
              vehicleListReplay[i].trackingData?.location?.latitude ?? 0.0;
          double lon =
              vehicleListReplay[i].trackingData?.location?.longitude ?? 0.0;

          // Add the coordinate to the polyline
          polylineCoordinates.add(vehicleListReplay[i].trackingData!);
          polylineLocation.add(LatLng(lat, lon));
        }
      }

      Polyline polyline = Polyline(
        polylineId: PolylineId('route'),
        points: polylineLocation,
        color: AppColors.blue, // Customize polyline color
        width: 3, // Customize polyline width
      );

      polylines.add(polyline);
    }
    arrowMarker.value = [];
    markers.value = [];
    List<Marker> arrowMarkers = [];
    int step = 10;
    try {
      BitmapDescriptor arrowIcon = await svgAssetToBitmapDescriptor(
          "assets/images/svg/arrow-up.svg",
          size: Size(15, 15));
      for (int i = 0; i < vehicleListReplay.length - 1; i += step) {
        final p1 = vehicleListReplay[i];
        /*  final p2 = polylineCoordinates[i + 1];

        // Get the bearing between the two points
        final bearing = getBearing(p1, p2);
*/
        // Create the arrow marker
        final arrowMarker = Marker(
          markerId: MarkerId('arrow_$i'),
          position: LatLng(p1.trackingData?.location?.latitude ?? 0,
              p1.trackingData?.location?.longitude ?? 0),
          rotation: Utils.parseDouble(data: p1.trackingData?.course),
          flat: true,
          icon: arrowIcon,
          // Use the adjusted bearing for rotation
          anchor: const Offset(0.5, 0.5),
        );

        arrowMarkers.add(arrowMarker);
      }

// Update all at once (triggers a single .obs update)
      arrowMarker.addAll(arrowMarkers);
    } catch (e) {
      debugPrint("ARROW MARKER $e");
    }

    // await _addMarkerAtStart();
    _addNumberStops();
    _zoomToMarkers();
  }

  Future<void> _addNumberStops() async {
    List<StopCount> stopList = [];
    for (int i = 0; i < stops.length; i++) {
      if (stops[i].location?.latitude != null &&
          stops[i].location?.longitude != null) {
        if (i > 0) {
          if (stops[i].location?.latitude != null &&
              stops[i].location?.longitude != null) {
            if (stops[i].location?.latitude !=
                    stops[i - 1].location?.latitude ||
                stops[i].location?.longitude !=
                    stops[i - 1].location?.longitude) {
              stopList.add(stops[i]);
            }
          }
        } else {
          stopList.add(stops[i]);
        }
      }
    }

    stops = stopList;
    for (int i = 0; i < stops.length; i++) {
      if (stops[i].location?.latitude != null &&
          stops[i].location?.longitude != null) {
        String time = "";
        if (stops[i].createdAt != null) {
          DateTime timestamp = DateTime.parse(stops[i].createdAt ??
              ""); // Assuming dateFiled is a valid timestamp string
          time = DateFormat('HH:mm:ss').format(timestamp);
        }

        Marker m = await createMarker(
            stopDur: stops[i].stopDuration ?? "",
            index: i + 1,
            imei: stops[i].imei ?? "",
            lat: stops[i].location?.latitude,
            long: stops[i].location?.longitude,
            speed: 0,
            dist: stops[i].distanceFromA,
            time: time);
        markers.add(m);
      }
    }
  }

  Future<void> _addMarkerAtStart() async {
    if (vehicleListReplay.isNotEmpty &&
        vehicleListReplay.first.trackingData?.location != null) {
      final startLat =
          vehicleListReplay.first.trackingData!.location!.latitude!;
      final startLng =
          vehicleListReplay.first.trackingData!.location!.longitude!;
      final controller = Get.isRegistered<DeviceController>()
          ? Get.find<DeviceController>() // Find if already registered
          : Get.put(DeviceController());
      var markerIcon = await svgToBitmapDescriptor(
          '${ProjectUrls.imgBaseUrl}${controller.deviceDetail.value?.vehicletype?.icons ?? ""}');
      final startMarker = Marker(
        markerId: const MarkerId('start_marker'),
        position: LatLng(startLat, startLng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        // infoWindow: const InfoWindow(title: 'Start Point'),
      );

      markers.add(startMarker);
    }
  }

  void _zoomToMarkers() {
    final bounds = _getBounds();

    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 30), // 50 is padding
    );
  }

  LatLngBounds _getBounds() {
    double minLat = double.infinity;
    double maxLat = double.negativeInfinity;
    double minLng = double.infinity;
    double maxLng = double.negativeInfinity;

    for (var marker in vehicleListReplay) {
      minLat = min(minLat, marker.trackingData?.location?.latitude ?? 0);
      maxLat = max(maxLat, marker.trackingData?.location?.latitude ?? 0);
      minLng = min(minLng, marker.trackingData?.location?.longitude ?? 0);
      maxLng = max(maxLng, marker.trackingData?.location?.longitude ?? 0);
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  Future<Marker> createMarker(
      {double? lat,
      double? long,
      double? speed,
      String? time,
      String? stopDur,
      String? dist,
      required String imei,
      required int index}) async {
    BitmapDescriptor markerIcon = await createCustomIconWithNumber(index,
        width: 100,
        height: 100,
        isselected: false,
        maxSpeed: false,
        unselectedColor: AppColors.blue,
        selectedIcon: "assets/images/png/blue_marker.png",
        unselectedIcon: "assets/images/png/white_marker.png");

    final markerId = "$imei$lat$long$time";
    final marker = Marker(
        // rotation: 90,
        markerId: MarkerId(markerId),
        position: LatLng(
          lat ?? 0,
          long ?? 0,
        ),
        icon: markerIcon,

        // icon: await createCustomMarker('$index'),
        onTap: () => _onMarkerTapped(index,
            stopDur: stopDur ?? "",
            time: time ?? "",
            speed: speed.toString() ?? "0",
            dist: dist ?? "",
            long: long,
            lat: lat));
    return marker;
  }

  void _onMarkerTapped(int index,
      {double? lat,
      double? long,
      required String stopDur,
      required String time,
      required String dist,
      required String speed}) async {
    if (!locController.isPlaying.value) {
      selectStopIndex.value = index;
      locController.setStopData(
          stopDur: stopDur,
          pos: LatLng(lat ?? 0, long ?? 0),
          speedStop: speed,
          timeStop: time,
          currDistStop: dist);
      BitmapDescriptor markerIcon = await createCustomIconWithNumber(index,
          isselected: true,
          width: 100,
          height: 100,
          maxSpeed: false,
          unselectedColor: AppColors.blue,
          selectedIcon: "assets/images/png/blue_marker.png",
          unselectedIcon: "assets/images/png/white_marker.png");
      markers[index - 1] = markers[index - 1].copyWith(iconParam: markerIcon);
      // markerAddress.value = await getAddressFromLatLong(lat ?? 0, long ?? 0);
      for (int i = 0; i < markers.length; i++) {
        if (i != index - 1) {
          BitmapDescriptor markerIconFalse = await createCustomIconWithNumber(
              i + 1,
              isselected: false,
              maxSpeed: false,
              unselectedColor: AppColors.blue,
              selectedIcon: "assets/images/png/blue_marker.png",
              unselectedIcon: "assets/images/png/white_marker.png",
              width: 100,
              height: 100);
          markers[i] = markers[i].copyWith(iconParam: markerIconFalse);
        }
      }
    }
  }

  void unselectStops() async {
    if (selectStopIndex.value != -1) {
      BitmapDescriptor markerIconFalse = await createCustomIconWithNumber(
          selectStopIndex.value,
          isselected: false,
          maxSpeed: false,
          unselectedColor: AppColors.blue,
          selectedIcon: "assets/images/png/blue_marker.png",
          unselectedIcon: "assets/images/png/white_marker.png",
          width: 100,
          height: 100);
      markers[selectStopIndex.value - 1] = markers[selectStopIndex.value - 1]
          .copyWith(iconParam: markerIconFalse);
    }
    selectStopIndex.value = -1;
  }
}
