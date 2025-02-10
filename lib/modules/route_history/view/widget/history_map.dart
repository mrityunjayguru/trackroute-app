import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_route_pro/modules/route_history/controller/history_controller.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_route_controller.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../../../constants/project_urls.dart';

class  RouteHistoryMap extends StatefulWidget {
   RouteHistoryMap({super.key});

  @override
  State<RouteHistoryMap> createState() => _RouteHistoryMapState();
}

class _RouteHistoryMapState extends State<RouteHistoryMap> {
  final controller = Get.put(HistoryController());


  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {


    });

  }

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => GoogleMap(
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        onMapCreated: controller.onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(28.6139, 77.2090), // Latitude and Longitude of Delhi
              zoom: 5,
            ),
        markers:Set<Marker>.of(controller.markers),
        polylines: Set<Polyline>.of(controller.polylines),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        mapToolbarEnabled: false,
        minMaxZoomPreference: MinMaxZoomPreference(5, 20),
      ),
    );
  }
}
