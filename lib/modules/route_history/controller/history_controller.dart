import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:developer' as dev;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:track_route_pro/service/api_service/api_service.dart';
import 'package:track_route_pro/utils/common_import.dart';
import 'package:track_route_pro/utils/enums.dart';
import 'package:track_route_pro/utils/utils.dart';
import '../../../config/theme/app_colors.dart';
import '../../../constants/project_urls.dart';
import 'package:geocoding/geocoding.dart';

import '../../../service/model/route/Data.dart';
import '../../../service/model/route/StopCount.dart';
import '../../../service/model/time_model.dart';
import '../../track_route_screen/controller/track_route_controller.dart';
import 'common.dart';

class HistoryController extends GetxController {
  final GlobalKey markerKey = GlobalKey();
  RxString address = ''.obs;
  RxString name = ''.obs;
  RxString updateDate = ''.obs;
  RxString imei = ''.obs;
  RxString selectedTime = ''.obs;
  RxString selectedSpeed = ''.obs;
  RxString markerNumber = ''.obs;
  RxString markerAddress = ''.obs;
  RxBool isMaxSpeed = false.obs;
  RxBool showDetails = false.obs;
  RxBool showMap = false.obs;
  RxBool showLoader = false.obs;
  TextEditingController dateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  var time1 = Rx<TimeOption?>(null); // Observable
  var time2 = Rx<TimeOption?>(null); // Observable
  RxList<RouteHistoryResponse> data = <RouteHistoryResponse>[].obs;
  bool isMapControllerInitialized = false;
  var markers = <Marker>[].obs;
  RxList<TimeOption> timeList = <TimeOption>[].obs;
  Set<int> overSpeedIndex = {};
  late GoogleMapController mapController;
  var currentLocation = LatLng(0.0, 0.0).obs; // Current vehicle location
  var polylines = <Polyline>[].obs; // List of polylines to display on the map
  var isLoading = false.obs; // Loading state
  List<RouteHistoryResponse> vehicleListReplay = [];
  List<StopCount> stopCount = [];
  final ApiService apiService = ApiService.create();
  Rx<NetworkStatus> networkStatus = Rx(NetworkStatus.IDLE);
  BitmapDescriptor? selectedIcon;
  BitmapDescriptor? unSelectedIcon;

  void generateTimeList() {
    timeList.value = [];
    for (int hour = 0; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        // Adjust interval as needed
        String formattedTime =
            '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
        timeList.add(TimeOption(formattedTime));
      }
    }
  }

  void selectDate(context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 90)),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      // Formatting the picked date
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

      controller.text = formattedDate;
      endDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  Future<void> getRouteHistory() async {
    selectedTime.value = "";
    selectedSpeed.value = "";
    markerNumber.value = "";
    markerAddress.value = "Fetching address...";
    isMaxSpeed.value = false;
    showDetails.value = false;
    pendingUpdateMap = null;
    pendingUpdate = null;
    if (dateController.text.isEmpty)
      Utils.getSnackbar("Error", "Please select valid date");
    else {
      showLoader.value = true;
      var response;
      try {
        networkStatus.value =
            NetworkStatus.LOADING; // Set network status to loading

        String startDate = endDateController.text;
        String endDate = endDateController.text;
        if (time1.value != null) {
          startDate += "T" + time1.value!.name+":00.000Z";
        } else {
          startDate += "T" + "00:01"+":00.000Z";
        }
        if (time2.value != null) {
          endDate += "T" + time2.value!.name+":00.000Z";
        } else {
          endDate += "T" + "24:00"+":00.000Z";
        }

        final body = {
          "imei": imei.value,
          "startdate": startDate,
          "enddate": endDate,
          "isPlay": true
        };
        response = await apiService.routeHistory(body);

        if (response.message == "success") {
          stopCount  = response.stopCount ?? [];
          overSpeedIndex = {};
          // data.value = [];
          List<RouteHistoryResponse> vehicleList = [];
          networkStatus.value = NetworkStatus.SUCCESS;
          vehicleList = response.data;
          vehicleList = vehicleList
              .where((item) =>
                  item.trackingData?.location?.latitude != null &&
                  item.trackingData?.location?.longitude != null)
              .toList();

          vehicleList.sort((a, b) {
            // Assuming trackingData has a timestamp field that you want to compare
            if (a.trackingData?.createdAt == null ||
                b.trackingData?.createdAt == null) {
              return 0;
            }
            return a.trackingData?.createdAt
                    ?.compareTo(b.trackingData?.createdAt ?? "") ??
                0;
          });

          if (vehicleList.isNotEmpty) {
            showMap.value = true;
            markers.value = [];
            // showLoader.value = false;

            Set<String> uniqueLatLonSet = Set<String>();
            vehicleListReplay = vehicleList;

            List<RouteHistoryResponse> processedData = [];
            for (var vehicle in vehicleList) {
              // log("VEHICLE LIST");
              if (vehicle.trackingData?.location?.latitude != null &&
                  vehicle.trackingData?.location?.longitude != null) {
                double currentLat =
                    vehicle.trackingData?.location?.latitude ?? 0.0;
                double currentLon =
                    vehicle.trackingData?.location?.longitude ?? 0.0;

                // Create a unique key for the combination of lat and lon
                String latLonKey = '$currentLat,$currentLon';
                // log("LAT lONG KEY ====> ${latLonKey}");

                // If this lat/lon combination hasn't been added yet, proceed
                if (!uniqueLatLonSet.contains(latLonKey)) {
                  processedData.add(vehicle);
                  uniqueLatLonSet.add(latLonKey);
                }
              }
            }

            processedData = processList(processedData);

            await showMapData(processedData);
            showLoader.value = false;

            /* if (vehicleList[0].trackingData?.location?.latitude != null &&
                vehicleList[0].trackingData?.location?.longitude != null) {
              updateCameraPosition(
                  vehicleList[0].trackingData?.location?.latitude ?? 0,
                  vehicleList[0].trackingData?.location?.longitude ?? 0, zoom: 11);
            }
*/
            _zoomToMarkers();
          } else {
            Get.snackbar("", "",
                snackStyle: SnackStyle.FLOATING,
                padding: EdgeInsets.fromLTRB(10,0,10,20),
                messageText: Text(
                  "No Route History Found",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                      color:
                          AppColors.selextedindexcolor), // Ensure text is visible
                ),
                backgroundColor: AppColors.black,
                colorText: AppColors.selextedindexcolor,
                snackPosition: SnackPosition.BOTTOM);
            // Utils.getSnackbar("Error", "No Route History Found");
          }
        } else {
          // log("EXCEPTION ${data}");
          // debugPrint("EXCEPTION ${data}");
        }
      } catch (e, s) {
        dev.log("EXCEPTION $e $s");
        debugPrint("EXCEPTION $e $s");
        networkStatus.value = NetworkStatus.ERROR;
        Utils.getSnackbar("Error", "Something went wrong");
      }
    }
    showLoader.value = false;
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

    for (var marker in markers) {
      minLat = min(minLat, marker.position.latitude);
      maxLat = max(maxLat, marker.position.latitude);
      minLng = min(minLng, marker.position.longitude);
      maxLng = max(maxLng, marker.position.longitude);
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  List<RouteHistoryResponse> processList(List<RouteHistoryResponse> data) {
    List<RouteHistoryResponse> processedData = [];

    if (data.length <= 25) {
      return data;
    } else if (data.length <= 100) {
      // If list length is between 26 and 125, show alternate items
      for (int i = 0; i < data.length; i++) {
        if (i < 25 || i % 2 == 0) {
          // Keep first 25 as they are, then alternate
          processedData.add(data[i]);
        }
      }
    } else if(data.length<=500){
      // If list length is greater than 125, show 1 in every 3 data

      for (int i = 0; i < data.length; i++) {
        print("DATA ${data[i].dateFiled.toString()}");
        if (i < 25 || i % 3 == 0 || i > (data.length - 11)) {
          // Keep first 25 as they are, then 1 in every 3
          processedData.add(data[i]);
        }
      }
    }else{
      for (int i = 0; i < data.length; i++) {
        print("DATA ${data[i].dateFiled.toString()}");
        if (i < 25 || i % 4 == 0 || i > (data.length - 11)) {
          // Keep first 25 as they are, then 1 in every 4
          processedData.add(data[i]);
        }
      }
    }
    return processedData;
  }

  Future<void> showMapData(List<RouteHistoryResponse> data) async {
    polylines.value = [];
    List<LatLng> polylineCoordinates = [];
    // int maxSpeedIndex = findIndexWithMaxSpeed(data) ?? -1;
    final controller = Get.isRegistered<TrackRouteController>()
        ? Get.find<TrackRouteController>() // Find if already registered
        : Get.put(TrackRouteController());
    // debugPrint("MAX SPEED INDEX $maxSpeedIndex");
    for (int i = 0; i < data.length; i++) {
      if (data[i].trackingData?.location?.latitude != null &&
          data[i].trackingData?.location?.longitude != null) {
        String time = "";
        if (data[i].dateFiled != null) {
          /*DateTime timestamp =
          DateTime.parse(data[i].trackingData?.createdAt ?? ""); // Assuming dateFiled is a valid timestamp string
          time = DateFormat('HH:mm:ss').format(timestamp);*/

          time = data[i].dateFiled?.split(" ")[1] ?? "N/A";
        }
        bool isOverSpeed = (data[i].trackingData?.currentSpeed != null ||
                (controller.deviceDetail.value.data?.isNotEmpty ?? false) ||
                controller.deviceDetail.value.data?[0].maxSpeed != null)
            ? ((Utils.parseDouble(data: data[i].trackingData?.currentSpeed) ?? 0) >
                (controller.deviceDetail.value.data?[0].maxSpeed ?? 0))
            : false;
        if (isOverSpeed) {
          overSpeedIndex.add(i);
        }
        Marker m = await createMarker(
            maxSpeed: isOverSpeed,
            index: i + 1,
            imei: data[i].imei ?? "",
            lat: data[i].trackingData?.location?.latitude,
            long: data[i].trackingData?.location?.longitude,
            speed: Utils.parseDouble(data: data[i].trackingData?.currentSpeed),
            time: time);

        markers.add(m);
        if (data[i].trackingData?.location != null) {
          double lat = data[i].trackingData?.location?.latitude ?? 0.0;
          double lon = data[i].trackingData?.location?.longitude ?? 0.0;

          // Add the coordinate to the polyline
          polylineCoordinates.add(LatLng(lat, lon));
        }
      }

      Polyline polyline = Polyline(
        polylineId: PolylineId('route'),
        points: polylineCoordinates,
        color: Colors.blue, // Customize polyline color
        width: 3, // Customize polyline width
      );

      polylines.add(polyline);
    }
  }

  Future<String> getAddressFromLatLong(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];

      return "${place.street}, ${place.locality}, ${place.subLocality}, ${place.country}";
    } catch (e) {
      // debugPrint("Error " + e.toString());
      return "Address not available";
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    isMapControllerInitialized = true;

    // If there's a pending update, execute it now
    if (pendingUpdate != null) {
      pendingUpdate!();
      pendingUpdate = null;
    }
  }

  Function? pendingUpdate;
  Function? pendingUpdateMap;

  void updateCameraPosition(double latitude, double longitude, {double? zoom}) {
    if (isMapControllerInitialized) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: zoom ?? 16,
          ),
        ),
      );
    } else {
      // Save the update to execute later
      pendingUpdate = () {
        updateCameraPosition(latitude, longitude, zoom: 13);
      };
    }
  }

  Future<Marker> createMarker(
      {double? lat,
      double? long,
      double? speed,
      String? time,
      required bool maxSpeed,
      required String imei,
      required int index}) async {
    // BitmapDescriptor markerIcon = await createMarkerIconFromAssets();
    BitmapDescriptor markerIcon = await createCustomIconWithNumber(index,
        width: 100, height: 100, isselected: false, maxSpeed: maxSpeed);

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
        onTap: () => _onMarkerTapped(index, maxSpeed,
            lat: lat,
            long: long,
            time: time ?? "",
            speed: '${speed?.toStringAsFixed(0) ?? "N/A"}'));
    return marker;
  }

  void _onMarkerTapped(int index, bool maxSpeed,
      {double? lat,
      double? long,
      required String time,
      required String speed}) async {
    showDetails.value = true;
    selectedTime.value = time;
    selectedSpeed.value = speed;
    isMaxSpeed.value = maxSpeed;
    markerNumber.value = index.toString();

    /*if(Platform.isIOS){

      markers.removeWhere(
            (element) => element.markerId.value.contains("INFOWINDOWMARKER"),
      );
      addCustomMarker(LatLng(lat ?? 0, long ?? 0), time, speed);
    }*/
    BitmapDescriptor markerIcon = await createCustomIconWithNumber(index,
        isselected: true, width: 100, height: 100, maxSpeed: maxSpeed);
    markers[index - 1] = markers[index - 1].copyWith(iconParam: markerIcon);
    markerAddress.value = await getAddressFromLatLong(lat ?? 0, long ?? 0);
    for (int i = 0; i < markers.length; i++) {
      if (i != index - 1) {
        BitmapDescriptor markerIconFalse = await createCustomIconWithNumber(
            i + 1,
            isselected: false,
            maxSpeed: overSpeedIndex.contains(i),
            width: 100,
            height: 100);
        markers[i] = markers[i].copyWith(iconParam: markerIconFalse);
      }
    }
  }

  Future<BitmapDescriptor> createMarkerIcon(String indexedImage,
      {int width = 100, int height = 100}) async {
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
  }


  void removeRoute() {
    polylines.clear(); // Clear the polylines
    update(); // Trigger UI update if necessary
  }
}
/*
Future<ui.Image> _loadSvgImage(String assetPath) async {
  final String rawSvg = await rootBundle.loadString(assetPath);

  // Create a RepaintBoundary to render the SVG
  final boundaryKey = GlobalKey();
  final svgPicture = SvgPicture.string(rawSvg, key: boundaryKey);

  // Rebuild the widget to render the SVG
  await Future.delayed(Duration(milliseconds: 100)); // Allow widget to build

  final RenderRepaintBoundary boundary = boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  final ui.Image image = await boundary.toImage(pixelRatio: 3.0); // You can adjust the pixelRatio to improve quality

  return image;
}

Future<BitmapDescriptor> _createCustomMarker(String index) async {
  // Load the SVG image
  final image = await _loadSvgImage('assets/images/svg/selected_marker.svg'); // Path to your SVG file

  // Create a PictureRecorder to draw the image and text
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder, Rect.fromPoints(Offset(0, 0), Offset(150, 150)));

  // Draw the SVG image onto the canvas
  canvas.drawImage(image, Offset(0, 0), Paint());

  // Draw the index number over the image
  final textPainter = TextPainter(
    text: TextSpan(
      text: index,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    textDirection: ui.TextDirection.ltr,
  );
  textPainter.layout(minWidth: 0, maxWidth: 150);

  // Positioning the text at (50, 50) - adjust as needed
  textPainter.paint(canvas, Offset(50, 50));

  // Convert the canvas to an image and then to BitmapDescriptor
  final picture = recorder.endRecording();
  final img = await picture.toImage(150, 150);
  final bytes = await img.toByteData(format: ui.ImageByteFormat.png);
  final buffer = bytes!.buffer.asUint8List();

  return BitmapDescriptor.fromBytes(buffer);
}


XmlDocument modifySvg(XmlDocument svgDocument, String text, double x, double y) {
  // Create a new <text> node
  final newTextElement = XmlElement(
    XmlName('text'),
    [
      XmlAttribute(XmlName('x'), x.toString()),
      XmlAttribute(XmlName('y'), y.toString()),
      XmlAttribute(XmlName('fill'), 'white'),
    ],
    [XmlText(text)],
  );

  // Find the <svg> root element and add the new <text> element
  final svgRoot = svgDocument.rootElement;
  svgRoot.children.add(newTextElement);

  return svgDocument;
}

Future<String> loadAndEditSvg() async {
  // Load and parse the SVG
  final svgDocument = await loadAndParseSvg('assets/images/svg/selected_marker.svg');

  // Modify the SVG document
  final updatedDocument = modifySvg(svgDocument, 'Hello XML!', 50, 50);

  // Convert back to a string
  return updatedDocument.toXmlString(pretty: true);

}


Future<XmlDocument> loadAndParseSvg(String path) async {
  final svgString = await rootBundle.loadString(path);
  return XmlDocument.parse(svgString);
}*/

/*
Future<void> updateRoutes() async {
  // Clear existing polylines
  polylines.clear();

  // Iterate through the data and generate markers and polylines
  LatLng? previousLocation; // To store the previous location for creating polylines

  for (var vehicle in data) {
    // Check if the location data is valid
    if (vehicle.trackingData?.location?.latitude != null &&
        vehicle.trackingData?.location?.longitude != null) {
      // Get the current location
      LatLng currentLocation = LatLng(
        vehicle.trackingData!.location!.latitude!,
        vehicle.trackingData!.location!.longitude!,
      );

      // Create a polyline if there is a previous location
      if (previousLocation != null) {
        polylines.add(Polyline(
          polylineId: PolylineId(
            'route ${previousLocation.longitude}${currentLocation.longitude}${previousLocation.latitude}${currentLocation.latitude}',
          ),
          color:AppColors.redColor,
          width: 2,
          points: [previousLocation, currentLocation],
        ));
      }

      // Update the previous location to the current location
      previousLocation = currentLocation;
    }
  }
}*/

/*Future<void> addCustomMarker(
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

  Future<Marker> createMarkerFromNet({
    double? lat,
    double? long,
    String? img,
    String? speed,
    String? time,
    required String imei,
  }) async {
    BitmapDescriptor markerIcon =
        await createMarkerIcon('${ProjectUrls.imgBaseUrl}$img');
    final markerId = "${ProjectUrls.imgBaseUrl}$img";
    // String address = await getAddressFromLatLong(lat ?? 0, long ?? 0);
    final marker = Marker(
      markerId: MarkerId(markerId),
      position: LatLng(
        lat ?? 0,
        long ?? 0,
      ),
      infoWindow: Platform.isAndroid ? InfoWindow(
        title: 'Time: $time',
        snippet: 'Speed: $speed',
      ) : InfoWindow.noText,
      icon: markerIcon,
    );
    return marker;
  }
   Future<BitmapDescriptor> createMarkerIconFromAssets(
      {int width = 35, int height = 35}) async {
    final ByteData data =
        await rootBundle.load("assets/images/png/selected_marker.png");
    final Uint8List bytes = data.buffer.asUint8List();

    // Decode the image to get its original size and resize it
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

    // Create and return BitmapDescriptor
    return BitmapDescriptor.fromBytes(resizedBytes);
  }*/
