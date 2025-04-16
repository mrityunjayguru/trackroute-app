import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:track_route_pro/utils/common_import.dart';
import 'package:track_route_pro/utils/map_item.dart';



Future<BitmapDescriptor> createCustomIconWithNumber(int number,
    {required int width,
      required int height,
      required bool isselected,
      Color unselectedColor = Colors.red,
      String maxSpeedIcon = "assets/images/png/black_marker_icon.png",
      String selectedIcon = "assets/images/png/selected_marker.png",
      String unselectedIcon = "assets/images/png/unselected_marker.png",
      required bool maxSpeed}) async {
  ByteData data = await rootBundle.load(maxSpeed
      ? maxSpeedIcon
      : (isselected
      ? selectedIcon
      : unselectedIcon));

  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width, targetHeight: height);
  ui.FrameInfo fi = await codec.getNextFrame();
  final Uint8List imageData =
  (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();

  // Prepare the canvas for drawing
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final Size canvasSize = Size(width.toDouble(), height.toDouble());
  final ui.Image image = await decodeImageFromList(imageData);
  paintImage(
      canvas: canvas,
      image: image,
      rect: Rect.fromLTWH(0, 0, canvasSize.width, canvasSize.height));

  TextPainter textPainter = TextPainter(
      textAlign: TextAlign.center, textDirection: ui.TextDirection.ltr);
  textPainter.text = TextSpan(
    text: '$number',
    style: TextStyle(
        fontSize: number.toString().length > 2
            ? ((number.toString().length > 4) ? width * 0.2 : width * 0.3)
            : width * 0.4,
        color: isselected || maxSpeed ? Colors.white : unselectedColor,
        fontWeight: FontWeight.bold),
  );
  textPainter.layout();
  textPainter.paint(
      canvas,
      Offset(width / 2 - textPainter.width / 2,
          height / 2 - textPainter.height / 2 - 10));

  // Convert that masterpiece into an image
  final ui.Image markerAsImage =
  await pictureRecorder.endRecording().toImage(width, height);
  final ByteData? byteData =
  await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
}

Future<BitmapDescriptor> getArrowIcon(double rotation) async {
  final bytes = await getBytesFromAsset('assets/images/png/arrow-up.png', 40);
  final codec = await ui.instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  final img = frame.image;

  // final rotated = await rotateImage(img, rotation);
  final data = await img.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
}



double getBearing(LatLng start, LatLng end) {
  final lat1 = start.latitude * pi / 180;
  final lon1 = start.longitude * pi / 180;
  final lat2 = end.latitude * pi / 180;
  final lon2 = end.longitude * pi / 180;

  final dLon = lon2 - lon1;
  final y = sin(dLon) * cos(lat2);
  final x =
      cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
  final bearing = atan2(y, x);

  return (bearing * 180 / pi + 360) % 360;
}

Future<ui.Image> rotateImage(ui.Image src, double angleDegrees) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  final angle = angleDegrees * pi / 180;
  final center = Offset(src.width / 2, src.height / 2);

  canvas.translate(center.dx, center.dy);
  canvas.rotate(angle);
  canvas.translate(-center.dx, -center.dy);
  canvas.drawImage(src, Offset.zero, Paint());

  final picture = recorder.endRecording();
  return await picture.toImage(src.width, src.height);
}


Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  final byteData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}


Future<BitmapDescriptor> svgToBitmapDescriptor(String url,
    {Size size = const Size(50, 50)}) async {
  try {
    BitmapDescriptor selectedIcon = await SvgPicture.network(
      url,
      height: size.width,
      width: size.height,
      // fit: BoxFit.scaleDown,
    ).toBitmapDescriptor();
    return selectedIcon;
  } catch (e) {
    // debugPrint("Error loading SVG: $e");
    return BitmapDescriptor.defaultMarker;
  }
}

Future<BitmapDescriptor> svgAssetToBitmapDescriptor(String url,
    {Size size = const Size(50, 50)}) async {
  try {
    BitmapDescriptor selectedIcon = await SvgPicture.asset(
      url,
      height: size.width,
      width: size.height,
      // fit: BoxFit.scaleDown,
    ).toBitmapDescriptor();
    return selectedIcon;
  } catch (e) {
    // debugPrint("Error loading SVG: $e");
    return BitmapDescriptor.defaultMarker;
  }
}


