import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../../../constants/project_urls.dart';
import '../../../service/model/route/Data.dart';
import '../../../utils/common_import.dart';
import '../../../utils/utils.dart';
import '../../track_route_screen/controller/track_device_controller.dart';
import '../../track_route_screen/controller/track_route_controller.dart';
import 'common.dart';
import 'package:track_route_pro/modules/route_history/controller/replay_controller.dart';

class LocationController extends GetxController {
  final RxList<RouteHistoryResponse> locations = <RouteHistoryResponse>[].obs;

  final RxInt currentIndex = 0.obs;
  final RxBool isPlaying = false.obs;
  final RxBool timerOn = false.obs;
  final RxString speed = "".obs;
  final RxString time = "".obs;
  final RxString currDist = "".obs;
  final RxString address = "".obs;
  final RxString stopDuration = "".obs;
  final RxString fromStop = "".obs;
  final RxString toStop = "".obs;
  final RxSet<Marker> markers = <Marker>{}.obs;

  final RxInt playbackSpeed = 1.obs;

  Ticker? _ticker;

  LatLng? _interpolatedPosition;
  LatLng? _animationStartPosition;
  LatLng? _targetPosition;
  DateTime? _animationStart;

  BitmapDescriptor? markerIcon;
  final Duration _animationDuration = const Duration(milliseconds: 600);
  double bearing = 0.0;
  DateTime timeStamp = DateTime.now();

  void initTicker(Ticker ticker) {
    _ticker = ticker;
  }

  @override
  void onClose() {
    _ticker?.dispose();
    super.onClose();
  }

  Future<void> loadData(List<RouteHistoryResponse> data) async {
    locations.assignAll(data);
    final controller = Get.put(DeviceController());
    playbackSpeed.value = 1;
    timerOn.value = false;
    isPlaying.value = false;
    currentIndex.value = 0;
    _interpolatedPosition = _latLngFromIndex(0);

    markerIcon = await svgToBitmapDescriptor(
      '${ProjectUrls.imgBaseUrl}${controller.deviceDetail.value?.vehicletype?.icons ?? ""}',
      size: const Size(50, 50),
    );

    _updateMarker(_interpolatedPosition!, 0.0);
  }

  LatLng _latLngFromIndex(int index) {
    final data = locations[index];
    return LatLng(
      data.trackingData?.location?.latitude ?? 0,
      data.trackingData?.location?.longitude ?? 0,
    );
  }

  void togglePlay() {
    isPlaying.toggle();
    if (isPlaying.value) {
      timerOn.value = true;
      _startTicker();
    } else {
      timerOn.value = false;
      _ticker?.stop();
      _setAddress();
    }
  }

  void _startTicker() {
    if (_ticker == null) return;

    _animationStart = DateTime.now();
    _animationStartPosition = _latLngFromIndex(currentIndex.value);
    _targetPosition = _latLngFromIndex(currentIndex.value + 1);
    bearing = _calculateBearing(_animationStartPosition!, _targetPosition!);
    _ticker!.start();
  }

  void onTick(Duration elapsed) {
    if (_animationStart == null ||
        _animationStartPosition == null ||
        _targetPosition == null) return;

    final t = (DateTime.now().difference(_animationStart!).inMilliseconds /
            _animationDuration.inMilliseconds)
        .clamp(0.0, 1.0);

    final lat =
        _lerp(_animationStartPosition!.latitude, _targetPosition!.latitude, t);
    final lng = _lerp(
        _animationStartPosition!.longitude, _targetPosition!.longitude, t);
    _interpolatedPosition = LatLng(lat, lng);
    _updateMarker(_interpolatedPosition!, bearing);
    _animateCamera(_interpolatedPosition!);

    if (t >= 1.0) {
      if (currentIndex.value < locations.length - 2) {
        currentIndex.value++;
        _setData();
        _animationStart = DateTime.now();
        _animationStartPosition = _latLngFromIndex(currentIndex.value);
        _targetPosition = _latLngFromIndex(currentIndex.value + 1);
        bearing = _calculateBearing(_animationStartPosition!, _targetPosition!);
      } else {
        timerOn.value = false;
        isPlaying.value = false;
        _ticker?.stop();
        _setAddress();
      }
    }
  }

  void _updateMarker(LatLng position, double rotation) {
    markers.value = {
      Marker(
        markerId: const MarkerId("playback_marker"),
        position: position,
        icon: markerIcon ?? BitmapDescriptor.defaultMarker,
        flat: true,
        rotation: rotation,
      )
    };
  }

  void _animateCamera(LatLng position) {
    final replayCon = Get.find<ReplayController>();
    final diff = DateTime.now().difference(timeStamp).inMilliseconds;
    if (diff > 1000) {
      replayCon.mapController.getZoomLevel().then((zoom) {
        replayCon.mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: position, zoom: 18, tilt: 0, bearing: 0),
          ),
        );
        timeStamp = DateTime.now();
      });
    }
  }

  void _setData() {
    final data = locations[currentIndex.value];
    time.value = data.dateFiled?.split(" ")[1] ?? "N/A";
    speed.value = Utils.parseDouble(data: data.trackingData?.currentSpeed)
        .toInt()
        .toString();
    currDist.value = Utils.parseDouble(data: data.trackingData?.distanceFromA)
        .toStringAsFixed(2);
  }

  Future<void> _setAddress() async {
    final lat =
        locations[currentIndex.value].trackingData?.location?.latitude ?? 0;
    final lng =
        locations[currentIndex.value].trackingData?.location?.longitude ?? 0;
    address.value = await Utils().getAddressFromLatLong(lat, lng);
  }

  void updateSpeed() {
    final speeds = [1, 2, 3, 4];
    int currentIdx = speeds.indexOf(playbackSpeed.value);
    int nextIdx = (currentIdx + 1) % speeds.length;
    playbackSpeed.value = speeds[nextIdx];
  }

  void onSliderChanged(double value) {
    currentIndex.value = value.toInt();
    _setData();
    _updateMarker(_latLngFromIndex(currentIndex.value), 0);
    _setAddress();
  }

  void setStopData({
    required String speedStop,
    required String timeStop,
    required String currDistStop,
    required String stopDur,
    required String fromstop,
    required String tostop,
    required LatLng pos,
  }) async {
    final dateFormat = DateFormat.Hm();
    time.value = timeStop;
    fromStop.value = dateFormat.format(DateTime.parse(fromstop));
    toStop.value = dateFormat.format(DateTime.parse(tostop));
    speed.value = Utils.parseDouble(data: speedStop).toInt().toString();
    currDist.value = Utils.parseDouble(data: currDistStop).toStringAsFixed(2);
    stopDuration.value = stopDur;
    address.value =
        await Utils().getAddressFromLatLong(pos.latitude, pos.longitude);
  }

  double _lerp(double start, double end, double t) => start + (end - start) * t;

  double _calculateBearing(LatLng start, LatLng end) {
    final lat1 = start.latitude * pi / 180;
    final lon1 = start.longitude * pi / 180;
    final lat2 = end.latitude * pi / 180;
    final lon2 = end.longitude * pi / 180;

    final dLon = lon2 - lon1;
    final y = sin(dLon) * cos(lat2);
    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    return (atan2(y, x) * 180 / pi + 360) % 360;
  }
}
