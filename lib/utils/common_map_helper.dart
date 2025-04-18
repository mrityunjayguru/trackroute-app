
import 'dart:ui';

import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_route_pro/utils/map_item.dart';

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
