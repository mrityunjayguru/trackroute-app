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
            Column(
              children: [
                SizedBox(height: 9.h),
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppSizes.radius_50)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(controller.isMaxSpeed.value
                              ? 'assets/images/svg/max_speed_marker.svg'
                              : 'assets/images/svg/red_marker.svg', width: 45, height: 45,),
                          Positioned(
                            top: 11,
                            child: Text(controller.markerNumber.value,
                                style: AppTextStyles(context).display16W600.copyWith(
                                    fontSize: controller.markerNumber.value.length > 2
                                        ? ((controller.markerNumber.value.length > 4) ? double.tryParse((16 -controller.markerNumber.value.length).toString()) ?? 13 : 14)
                                        : 16,
                                    color: controller.isMaxSpeed.value
                                        ? AppColors.selextedindexcolor
                                        : AppColors.white)),
                          ),
                        ],
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${controller.isMaxSpeed.value ? "Max " : ""}Speed",
                                style: AppTextStyles(context).display11W500),
                            SizedBox(
                              height: 4,
                            ),
                            Text.rich(
                              textAlign: TextAlign.start,
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: controller.selectedSpeed.value,
                                    style: AppTextStyles(context).display20W600,
                                  ),
                                  TextSpan(
                                    text: ' KMPH',
                                    style: AppTextStyles(context)
                                        .display14W600
                                        .copyWith(color: AppColors.grayLight),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Time", style: AppTextStyles(context).display11W500),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              controller.selectedTime.value,
                              style: AppTextStyles(context).display20W600,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Vehicle",
                                style: AppTextStyles(context)
                                    .display10W500
                                    .copyWith(color: AppColors.grayLight)),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              controller.name.value,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles(context)
                                  .display12W500
                                  .copyWith(color: AppColors.grayLight),
                            ),
                          ],
                        ),
                      )
                    ],
                  ).paddingOnly(left: 6, bottom: 7, top: 7, right: 6),
                ),
                SizedBox(height: 1.5.h),
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.selextedindexcolor,
                      borderRadius: BorderRadius.circular(AppSizes.radius_50)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset('assets/images/svg/ic_location.svg'),
                      Flexible(
                        child: Text(
                          controller.markerAddress.value,
                          style: AppTextStyles(context).display13W500,
                        ).paddingOnly(left: 5),
                      )
                    ],
                  ).paddingOnly(left: 6, bottom: 7, top: 7),
                ),
              ],
            ).paddingSymmetric(horizontal: 16)

          ]
        ],
      ),
    );
  }
}
