import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/modules/route_history/controller/location_controller.dart';
import 'package:track_route_pro/modules/route_history/controller/replay_controller.dart';

import '../../../config/app_sizer.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_textstyle.dart';
import '../../../utils/common_import.dart';
import '../../../utils/utils.dart';
import '../controller/history_controller.dart';

class RouteReplayView extends StatefulWidget {
  @override
  State<RouteReplayView> createState() => _RouteReplayViewState();
}

class _RouteReplayViewState extends State<RouteReplayView> with TickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
    locationController.initAnimation(this);
  }

  @override
  void dispose() {
    locationController.animationController.dispose();
    super.dispose();
  }
  final locationController = Get.isRegistered<LocationController>()
      ? Get.find<LocationController>() // Find if already registered
      : Get.put(LocationController());

  final controller = Get.isRegistered<ReplayController>()
      ? Get.find<ReplayController>() // Find if already registered
      : Get.put(ReplayController());

  final historyController = Get.isRegistered<HistoryController>()
      ? Get.find<HistoryController>() // Find if already registered
      : Get.put(HistoryController());

  var scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.backgroundColor,
          body: Obx(
            () => Stack(children: [
              Obx(
                () => GoogleMap(
                  zoomControlsEnabled: false,
                  mapType: MapType.normal,
                  onMapCreated: (con) async {
                    controller.mapController = con;
                    await controller.showMapData();

                    controller.showLoader.value = false;
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(28.6139, 77.2090),
                    // Latitude and Longitude of Delhi
                    zoom: 5,
                  ),
                  onTap: (val) {
                    // controller.showDetails.value = false;
                  },
                  markers:  {...controller.markers, ...locationController.markers, ...controller.arrowMarker},
                  polylines: Set<Polyline>.of(controller.polylines),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  mapToolbarEnabled: false,
                  minMaxZoomPreference: MinMaxZoomPreference(5, !locationController.isPlaying.value ? 19 : 16),
                ),
              ),
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Utils().topBar(
                        context: context,
                        rightIcon: 'assets/images/svg/ic_arrow_left.svg',
                        onTap: () {
                          Get.back();
                          locationController.stopPlayback();
                        },
                        name: historyController.name.value),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    Column(
                            children: [
                              SizedBox(height: 1.h),
                              Container(
                                decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(
                                        AppSizes.radius_50)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/svg/blue_marker.svg',
                                      width: 40,
                                      height: 40,
                                    ).paddingOnly(top: 4),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Total Stops",
                                              style: AppTextStyles(context)
                                                  .display11W500),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            "${controller.stops.length}",
                                            style: AppTextStyles(context)
                                                .display20W600
                                                .copyWith(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .height <
                                                                670
                                                            ? 18
                                                            : 20),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text("Total Trip",
                                              style: AppTextStyles(context)
                                                  .display11W500),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Text.rich(
                                            overflow: TextOverflow.ellipsis,
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: Utils.toStringAsFixed(data: locationController.locations[locationController.locations.length-1].trackingData?.distanceFromA),
                                                  style: AppTextStyles(context)
                                                      .display20W600
                                                      .copyWith(
                                                      fontSize: MediaQuery.of(
                                                          context)
                                                          .size
                                                          .height <
                                                          670
                                                          ? 18
                                                          : 20),
                                                ),
                                                if(locationController.locations[locationController.locations.length-1].trackingData?.distanceFromA!=null)TextSpan(
                                                    text: ' KM ',
                                                    style: AppTextStyles(
                                                        context)
                                                        .display14W600
                                                        .copyWith(
                                                        color: AppColors
                                                            .grayLight,
                                                        fontSize: MediaQuery.of(
                                                            context)
                                                            .size
                                                            .height <
                                                            670
                                                            ? 12
                                                            : 14)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Time",
                                              style: AppTextStyles(context)
                                                  .display11W500),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            locationController.timerOn.value ? locationController.time.value: (locationController.locations.value[0].dateFiled?.split(" ")[1] ??
                                                "N/A"),
                                            style: AppTextStyles(context)
                                                .display20W600
                                                .copyWith(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .height <
                                                                670
                                                            ? 18
                                                            : 20),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ).paddingOnly(
                                    left: 11, bottom: 11, top: 11, right: 11),
                              ),
                              SizedBox(height: 1.5.h),
                              if((!locationController.isPlaying.value && locationController.timerOn.value) || controller.selectStopIndex.value!=-1)Container(
                                decoration: BoxDecoration(
                                    color: AppColors.selextedindexcolor,
                                    borderRadius: BorderRadius.circular(
                                        AppSizes.radius_50)),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset(
                                            'assets/images/svg/ic_location.svg'),
                                        Flexible(
                                          child: Text(
                                            "${locationController.address.value}",
                                            style: AppTextStyles(context)
                                                .display13W500,
                                          ).paddingOnly(left: 5),
                                        )
                                      ],
                                    ).paddingOnly(left: 10, bottom: 7, top: 7),
                                    if(controller.selectStopIndex.value!=-1)Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [

                                        Flexible(
                                          child: Text(
                                            "Stop Duration: ${locationController.stopDuration.value}",
                                            style: AppTextStyles(context)
                                                .display13W500,
                                          ).paddingOnly(left: 8),
                                        )
                                      ],
                                    ).paddingOnly(left: 20, bottom: 7,),
                                  ],
                                ),
                              ),
                            ],
                          ),
                    Spacer(),
                    if(locationController.timerOn.value || controller.selectStopIndex.value!=-1)Container(
                      height: 60,
                      constraints: BoxConstraints(minWidth: 165, maxWidth: 200),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(500),
                        color: AppColors.white,

                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Transform.translate(
                            offset: Offset(-7, 0),
                            child: Container(
                              width: 60,
                              height: 60,
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.white,
                                  border: Border.all(
                                      color: AppColors.selextedindexcolor,
                                      width: 3)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                     '${locationController.speed.value}',
                                    style: AppTextStyles(context)
                                        .display20W600
                                        .copyWith(color: Colors.black),

                                  ),
                                  Text(
                                     'KM/H',
                                    style: AppTextStyles(context)
                                        .display7W600
                                        .copyWith(
                                      color: AppColors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text: 'Current\n',
                              style: AppTextStyles(context)
                                  .display11W500
                                  .copyWith(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: '${locationController.currDist.value}',
                                  style: AppTextStyles(context)
                                      .display21W600
                                      .copyWith(
                                        color: AppColors.black,
                                      ),
                                ),
                                TextSpan(
                                  text: ' KM',
                                  style: AppTextStyles(context)
                                      .display14W600
                                      .copyWith(
                                        color: AppColors.grayLight,
                                      ),
                                ),
                              ],
                            ),
                          ).paddingOnly(right: 20)
                        ],
                      ),
                    ).paddingOnly(bottom: 16),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(500),
                        color: AppColors.black,
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap:(){
                              locationController.togglePlay();
                            },
                            child: SvgPicture.asset(locationController.isPlaying.value ? "assets/images/svg/green_pause.svg":"assets/images/svg/green_play.svg" )
                                .paddingOnly(left: 7),
                          ),
                          Expanded(
                            child: Slider(
                              activeColor: AppColors.white,
                              thumbColor: AppColors.purpleColor,
                              value: locationController.currentIndex.value.toDouble(),
                              min: 0,
                              max: (locationController.locations.length - 1).toDouble(),
                              divisions: locationController.locations.length > 1
                                  ? locationController.locations.length - 1
                                  : null,
                              label: "Point ${locationController.currentIndex.value + 1}",
                              onChanged: (val) => locationController.onSliderChanged(val),
                            ),
                          ),
                          InkWell(
                            onTap: ()=> locationController.updateSpeed(),
                            child: SvgPicture.asset("assets/images/svg/fast_icon.svg")
                                .paddingOnly(right: 5),
                          ),
                          InkWell(
                            onTap: ()=> locationController.updateSpeed(),
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.white,
                                  border: Border.all(
                                      color: AppColors.selextedindexcolor,
                                      width: 1)),
                              child: Text(
                                '${locationController.playbackSpeed.value.toInt()}X',
                                style: AppTextStyles(context)
                                    .display20W600
                                    .copyWith(color: Colors.black),
                              ),
                            ).paddingOnly(right: 3),
                          ),
                        ],
                      ),
                    ).paddingOnly(bottom: 16)
                  ],
                ).paddingOnly(top: 12).paddingSymmetric(horizontal: 4.w * 0.9),
              ),
              if (controller.showLoader.value)
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.grey.withOpacity(0.7),
                    child: LoadingAnimationWidget.threeArchedCircle(
                      color: AppColors.selextedindexcolor,
                      size: 50,
                    ),
                  ),
                )
            ]),
          ),
        ),
      ),
    );
  }
}
