import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/modules/route_history/controller/history_controller.dart';
import 'package:track_route_pro/utils/common_import.dart';
import '../../../../config/app_sizer.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_textstyle.dart';

class RouteHistoryMap extends StatelessWidget {
  RouteHistoryMap({super.key});

  final controller = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            onMapCreated: controller.onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(28.6139, 77.2090),
              // Latitude and Longitude of Delhi
              zoom: 5,
            ),
            onTap: (val){
              controller.showDetails.value = false;
            },
            markers: Set<Marker>.of(controller.markers),
            polylines: Set<Polyline>.of(controller.polylines),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            minMaxZoomPreference: MinMaxZoomPreference(5, 20),
          ),
          /* Positioned(
            left: -9999,
            child: RepaintBoundary(
              key: controller.markerKey,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 1),
                  // Black Border
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon(Icons.directions_car, size: 40, color: Colors.blue),
                    Text(
                      "Time: ${controller.selectedTime.value}",
                      style: AppTextStyles(context).display18W500.copyWith(fontSize: MediaQuery.of(context).size.height < 670 ? 14 : null),
                    ),
                    Text(
                      controller.selectedSpeed.value,
                      style: AppTextStyles(context)
                          .display16W400
                          .copyWith(color: AppColors.grayLight, fontSize: MediaQuery.of(context).size.height < 670 ? 12 : null),
                    ),
                  ],
                ),
              ),
            ),
          ),*/
          if (controller.showDetails.value) ...[


          ]
        ],
      ),
    );
  }
}
