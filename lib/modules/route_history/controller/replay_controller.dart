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
import 'common.dart';

class ReplayController extends GetxController {
  List<RouteHistoryResponse> vehicleListReplay = [];
  List<StopCount> stops = [];
  var markers = <Marker>[].obs;
  var arrowMarker = <Marker>[].obs;
  late GoogleMapController mapController;
  var polylines = <Polyline>[].obs;
  RxBool showLoader = false.obs;
  final locController = Get.isRegistered<LocationController>()
      ? Get.find<LocationController>() // Find if already registered
      : Get.put(LocationController());
  RxInt selectStopIndex = (-1).obs;
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
    selectStopIndex.value=-1;
  }

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
    for (int i = 0; i < stops.length; i++) {
      if (stops[i].location?.latitude != null &&
          stops[i].location?.longitude != null ) {
        String time = "";
        if (stops[i].createdAt != null) {
          DateTime timestamp = DateTime.parse(stops[i].createdAt ??
              ""); // Assuming dateFiled is a valid timestamp string
          time = DateFormat('HH:mm:ss').format(timestamp);
        }


      if(i>0){
        if (stops[i].location?.latitude != null && stops[i].location?.longitude != null) {
          if (stops[i].location?.latitude != stops[i-1].location?.latitude || stops[i].location?.longitude != stops[i-1].location?.longitude) {
            Marker m = await createMarker(
                index: i + 1,
                imei: stops[i].imei ?? "",
                lat: stops[i].location?.latitude,
                long: stops[i].location?.longitude,
                speed: 0,
                dist: "0",
                //todo
                time: time);
            markers.add(m);
          }
        }
      }
      else{
        Marker m = await createMarker(
            index: i + 1,
            imei: stops[i].imei ?? "",
            lat: stops[i].location?.latitude,
            long: stops[i].location?.longitude,
            speed: 0,
            dist: "0",
            //todo
            time: time);
        markers.add(m);
      }

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
      final trackCon = Get.isRegistered<TrackRouteController>()
          ? Get.find<TrackRouteController>() // Find if already registered
          : Get.put(TrackRouteController());
      var markerIcon = await svgToBitmapDescriptor(
          '${ProjectUrls.imgBaseUrl}${trackCon.deviceDetail.value.data?[0].vehicletype?.icons ?? ""}');
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
      CameraUpdate.newLatLngBounds(bounds, 50), // 50 is padding
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
      required String time,
      required String dist,
      required String speed}) async {
    if (!locController.isPlaying.value) {
      selectStopIndex.value = index;
      locController.setStopData(
        pos: LatLng(lat ?? 0, long ?? 0),
          speedStop: speed, timeStop: time, currDistStop: dist);
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
    if(selectStopIndex.value!=-1){
      BitmapDescriptor markerIconFalse = await createCustomIconWithNumber(
          selectStopIndex.value,
          isselected: false,
          maxSpeed: false,
          unselectedColor: AppColors.blue,
          selectedIcon: "assets/images/png/blue_marker.png",
          unselectedIcon: "assets/images/png/white_marker.png",
          width: 100,
          height: 100);
      markers[selectStopIndex.value-1] = markers[selectStopIndex.value-1].copyWith(iconParam: markerIconFalse);
    }

  }
}
