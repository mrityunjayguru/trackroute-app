import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_route_pro/modules/route_history/controller/replay_controller.dart';

import '../../../constants/project_urls.dart';
import '../../../service/model/route/Data.dart';
import '../../../utils/common_import.dart';
import '../../../utils/utils.dart';
import '../../track_route_screen/controller/track_route_controller.dart';
import 'common.dart';

class LocationController extends GetxController {

  late AnimationController animationController;
  Animation<LatLng>? animation;
  LatLng? oldLatLng;
  DateTime timeStamp = DateTime.now();
  final RxList<RouteHistoryResponse> locations = <RouteHistoryResponse>[].obs;
  final RxString speed = "".obs;
  final RxString time = "".obs;
  final RxString currDist = "".obs;
  final RxString address = "".obs;
  final RxString stopDuration = "".obs;
  final RxInt currentIndex = 0.obs;
  final RxBool isPlaying = false.obs;
  final RxBool timerOn = false.obs;
  var markers = <Marker>[].obs;

  final RxDouble playbackSpeed = 1.0.obs; // 1x, 2x, etc.
  // final Rx<Marker?> currentMarker = Rx<Marker?>(null);

  Timer? _playbackTimer;
  BitmapDescriptor? markerIcon;

  void initAnimation(TickerProvider vsync) {
    animationController = AnimationController(
      duration: Duration(milliseconds: getDurationFromSpeed(1)),
      vsync: vsync,
    );
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
    stopDuration.value = "";
    markerIcon = await svgToBitmapDescriptor(
        '${ProjectUrls.imgBaseUrl}${trackCon.deviceDetail.value?.vehicletype?.icons ?? ""}',
        size: Size(30, 30));
    _updateMap();
  }

  void _startPlayback()  {
    _playbackTimer?.cancel();
    int baseInterval = 2000;
    int interval = (baseInterval / playbackSpeed.value).round();
    _playbackTimer = Timer.periodic(Duration(milliseconds: interval), (timer) async {
      if (currentIndex.value < locations.length - 1) {
        if (!timerOn.value) timerOn.value = true;
        currentIndex.value++;
        _setData();

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

  void _updateMapNoAni() {
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

  }

  void _updateMap({bool zoom = true}) {
    final data = locations[currentIndex.value];
    final lat = data.trackingData?.location?.latitude ?? 0;
    final lng = data.trackingData?.location?.longitude ?? 0;
    final newLatLng = LatLng(lat, lng);
    double rotation = currentIndex.value==0? Utils.parseDouble(data: data.trackingData?.course) :Utils.parseDouble(data: locations[currentIndex.value-1].trackingData?.course) ;
    if (oldLatLng == null) {
      oldLatLng = newLatLng;
    }
    var replayCon = Get.isRegistered<ReplayController>()
        ? Get.find<
        ReplayController>() // Find if already registered
        : Get.put(ReplayController());
    super.onInit();
    animation = LatLngTween(begin: oldLatLng ?? newLatLng, end: newLatLng).animate(animationController)
      ..addListener(() {
        final position = animation!.value;
        final newMarker = Marker(
          markerId: const MarkerId("playback_marker"),
          position: position,
          icon: markerIcon ?? BitmapDescriptor.defaultMarker,
          flat: true,
          rotation: rotation,
        );

        markers.value = [newMarker];

        final timeDiff = DateTime.now().difference(timeStamp).inMilliseconds;
        if(timeDiff > 1000){
          replayCon.mapController.getZoomLevel().then((currentZoom) async {
            replayCon.mapController?.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: position,
                  zoom: currentZoom,
                ),
              ),
            );
            timeStamp = DateTime.now();
          });

        }

      });

    animationController.forward(from: 0.0);
    oldLatLng = newLatLng;
  }

  Future<void> updateMarkers() async {
    // Get the map controller

  }
  void updateSpeed() {
    final List<double> speeds = [1, 2, 3, 4];
    int currentIndex = speeds.indexOf(playbackSpeed.value);

    // Move to next speed in the list (loop back to start)
    int nextIndex = (currentIndex + 1) % speeds.length;
    playbackSpeed.value = speeds[nextIndex];
    animationController.duration = Duration(
      milliseconds: getDurationFromSpeed(playbackSpeed.value),
    );
    animationController.reset();
    if (_playbackTimer != null && _playbackTimer!.isActive) {
      _startPlayback();
    }
  }

  int getDurationFromSpeed(double speedMultiplier) {
    const baseDurationMs = 2000;
    return (baseDurationMs / speedMultiplier).round();
  }

  void togglePlay() async {
    var replayCon = Get.isRegistered<ReplayController>()
        ? Get.find<
        ReplayController>() // Find if already registered
        : Get.put(ReplayController());
    isPlaying.toggle();
    if (isPlaying.value) {
      _startPlayback();
      replayCon.unselectStops();

    } else {
      _playbackTimer?.cancel();
    _setAddress();
    }
  }

  void onSliderChanged(double value) {
    var replayCon = Get.isRegistered<ReplayController>()
        ? Get.find<
        ReplayController>() // Find if already registered
        : Get.put(ReplayController());
    super.onInit();
    if(!timerOn.value)timerOn.value = true;
    currentIndex.value = value.toInt();
    _setData();
    _updateMap();
    _setAddress();
    replayCon.unselectStops();
  }

  _setData(){
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
            .value[currentIndex.value].trackingData?.distanceFromA).toStringAsFixed(2);
  }


  _setAddress() async{
    address.value = await Utils().getAddressFromLatLong(locations
        .value[currentIndex.value].trackingData?.location?.latitude ?? 0, locations
        .value[currentIndex.value].trackingData?.location?.longitude ?? 0);
  }


  void setStopData({required String speedStop, required String timeStop, required String currDistStop, required String stopDur, required LatLng pos}) async{
    time.value =timeStop;
    speed.value = Utils.parseDouble(
        data: speedStop)
        .toInt()
        .toString();
    currDist.value = Utils.parseDouble(
        data: currDistStop).toStringAsFixed(2);
    stopDuration.value = stopDur;
    address.value = await Utils().getAddressFromLatLong(pos.latitude, pos.longitude);

  }
}

class LatLngTween extends Tween<LatLng> {
  LatLngTween({required LatLng begin, required LatLng end})
      : super(begin: begin, end: end);

  @override
  LatLng lerp(double t) => LatLng(
    begin!.latitude + (end!.latitude - begin!.latitude) * t,
    begin!.longitude + (end!.longitude - begin!.longitude) * t,
  );
}

