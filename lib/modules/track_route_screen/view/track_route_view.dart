import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:track_route_pro/config/app_sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_route_controller.dart';
import 'package:track_route_pro/modules/track_route_screen/view/widgets/map_view.dart';
import 'package:track_route_pro/modules/track_route_screen/view/widgets/vehicles_filter.dart';
import 'package:track_route_pro/utils/common_import.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../utils/utils.dart';

class TrackRouteView extends StatelessWidget {
  TrackRouteView({super.key});

  final controller = Get.isRegistered<TrackRouteController>()
      ? Get.find<TrackRouteController>() // Find if already registered
      : Get.put(TrackRouteController());

  @override
  Widget build(BuildContext context) {
    WakelockPlus.enable();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, val) {
        controller.isExpanded.value = false;
        controller.showAllVehicles();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Obx(() {
          return Stack(
            children: [
              MapViewTrackRoute(),
              AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(-1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                  child: VehiclesList()),
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
            ],
          );
        }),
        floatingActionButton: Obx(() => Padding(
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: FloatingActionButton(
                      heroTag: 'satellite1',
                      child: Image.asset(
                        !controller.isSatellite.value
                            ? "assets/images/png/satellite.png"
                            : "assets/images/png/default.png",
                        fit: BoxFit.cover,
                      ),
                      backgroundColor: AppColors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radius_50),
                      ),
                      onPressed: () {
                        controller.isSatellite.value =
                            !controller.isSatellite.value;
                      },
                    ),
                  ).paddingOnly(bottom: 16),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: FloatingActionButton(
                      heroTag: 'nav',
                      child: SvgPicture.asset(
                        Assets.images.svg.navigation1,
                        fit: BoxFit.fill,
                      ),
                      backgroundColor: AppColors.selextedindexcolor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radius_50),
                      ),
                      onPressed: () async {
                        // Fetch the current location
                        Position? position =
                            await controller.getCurrentLocation();
                        if (position != null) {
                          controller.updateCameraPosition(
                              course: 0,
                              latitude: position.latitude,
                              longitude: position.longitude);
                        } else {
                          Utils.getSnackbar(
                              "Error", "Current location not available");
                          return;
                        }
                      },
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
