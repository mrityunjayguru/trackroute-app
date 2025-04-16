import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../constants/project_urls.dart';
import '../../../service/model/route/Data.dart';
import '../../../utils/common_import.dart';
import '../../../utils/utils.dart';
import '../../track_route_screen/controller/track_route_controller.dart';
import 'common.dart';

class LocationController extends GetxController {
  final RxList<RouteHistoryResponse> locations = <RouteHistoryResponse>[].obs;
  final RxString speed = "".obs;
  final RxString time = "".obs;
  final RxString currDist = "".obs;
  final RxString address = "".obs;
  final RxInt currentIndex = 0.obs;
  final RxBool isPlaying = false.obs;
  final RxBool timerOn = false.obs;
  var markers = <Marker>[].obs;

  final RxDouble playbackSpeed = 1.0.obs; // 1x, 2x, etc.
  // final Rx<Marker?> currentMarker = Rx<Marker?>(null);

  Timer? _playbackTimer;
  GoogleMapController? _mapController;
  BitmapDescriptor? markerIcon;

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  void loadData(List<RouteHistoryResponse> data) async {
    final trackCon = Get.isRegistered<TrackRouteController>()
        ? Get.find<TrackRouteController>() // Find if already registered
        : Get.put(TrackRouteController());
    locations.assignAll(data);
    playbackSpeed.value = 1.0;
    timerOn.value = false;
    isPlaying.value = false;
    currentIndex.value = 0;
    speed.value = "";
    time.value = "";
    currDist.value = "";
    address.value = "";
    markerIcon = await svgToBitmapDescriptor(
        '${ProjectUrls.imgBaseUrl}${trackCon.deviceDetail.value.data?[0].vehicletype?.icons ?? ""}',
        size: Size(30, 30));
    _updateMap();
  }

  void _startPlayback()  {
    _playbackTimer?.cancel();
    int baseInterval = 500; // 1x = 1000ms
    int interval = (baseInterval / playbackSpeed.value).round();
    _playbackTimer = Timer.periodic(Duration(milliseconds: interval), (timer) async {
      if (currentIndex.value < locations.length - 1) {
        if (!timerOn.value) timerOn.value = true;
        currentIndex.value++;
        time.value =
            locations.value[currentIndex.value].dateFiled?.split(" ")[1] ??
                "N/A";
        speed.value = Utils.parseDouble(
                data: locations
                    .value[currentIndex.value].trackingData?.currentSpeed)
            .toInt()
            .toString();
        currDist.value = Utils.parseDouble(
                data: locations
                    .value[currentIndex.value].trackingData?.distanceFromA)
            .round()
            .toInt()
            .toString();

        // _updateMap();
      } else {
        timerOn.value = false;
        isPlaying.value = false;
        currentIndex.value = 0;
        timer.cancel();
      }
      _updateMap();


    });
  }

  void stopPlayback() {
    _playbackTimer?.cancel();
  }

  @override
  void onClose() {
    stopPlayback();
    super.onClose();
  }

  void _updateMap() {
    debugPrint("CURR INDEX ==> ${currentIndex.value}  ");
    final data = locations[currentIndex.value];
    final lat = data.trackingData?.location?.latitude ?? 0;
    final lng = data.trackingData?.location?.longitude ?? 0;

    final position = LatLng(lat, lng);
    final newMarker = Marker(
        markerId: MarkerId("playback_marker"),
        position: position,
        icon: markerIcon ?? BitmapDescriptor.defaultMarker,
        flat: true,
        rotation: Utils.parseDouble(data: data.trackingData?.course) ?? 0);

    markers.value = [newMarker];
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(position),
    );
  }

  void updateSpeed() {
    final List<double> speeds = [1, 2, 3, 4];
    int currentIndex = speeds.indexOf(playbackSpeed.value);

    // Move to next speed in the list (loop back to start)
    int nextIndex = (currentIndex + 1) % speeds.length;
    playbackSpeed.value = speeds[nextIndex];
    if (_playbackTimer != null && _playbackTimer!.isActive) {
      _startPlayback();
    }
  }

  void togglePlay() async {
    isPlaying.toggle();
    if (isPlaying.value) {
      _startPlayback();
    } else {
      _playbackTimer?.cancel();
      address.value = await getAddressFromLatLong(locations
          .value[currentIndex.value].trackingData?.location?.latitude ?? 0, locations
          .value[currentIndex.value].trackingData?.location?.longitude ?? 0);
    }
  }

  void onSliderChanged(double value) {
    currentIndex.value = value.toInt();
    _updateMap();
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
}
