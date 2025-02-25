import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:track_route_pro/modules/alert_screen/view/alert_view.dart';
import 'package:track_route_pro/modules/profile/controller/profile_controller.dart';
import 'package:track_route_pro/modules/profile/view/profile_view.dart';
import 'package:track_route_pro/modules/settig_screen/view/setting_view.dart';
import 'package:track_route_pro/modules/track_route_screen/view/track_route_view.dart';
import 'package:track_route_pro/modules/vehicales/view/vehicales_view.dart';

import '../../track_route_screen/controller/track_route_controller.dart';
import '../../vehicales/controller/vehicales_controller.dart';

class BottomBarController extends GetxController {

  var selectedIndex = 2.obs;
  var previousIndex = 2.obs;

  void updateIndex(int index) {
    if(index==2){
      final controller = Get.isRegistered<TrackRouteController>()
          ? Get.find<TrackRouteController>() // Find if already registered
          : Get.put(TrackRouteController());
      controller.isExpanded.value = false;
      controller.isedit.value = false;
      controller.stackIndex.value = 0;
      controller.isFilterSelected.value = false;
      controller.isFilterSelectedindex.value = -1;
      controller.showAllVehicles();
      if(controller.vehicleList.value.data?.isEmpty ?? false){
        controller.markers.value = [];
        controller.devicesByOwnerID(false);
      }

    }
    if(index==3){
      final controller = Get.isRegistered<VehicalesController>()
          ? Get.find<VehicalesController>() // Find if already registered
          : Get.put(VehicalesController());
      controller.onInit();
    }
    if(index==4) {
      var controller = Get.put(ProfileController());
      controller.selectedVehicleIndex.value = {};
      controller.isReNewSub.value = false;
    }
    previousIndex.value = selectedIndex.value;
    selectedIndex.value = index;
  }

  void updateIndexForRenewal(String imei) {

    try{
      var controller = Get.put(ProfileController());
      controller.checkForRenewal(selectVehicle : imei) ;
      controller.isReNewSub.value = true;
      previousIndex.value = selectedIndex.value;
      selectedIndex.value = 4;
    }
    catch(e,s){
      log("EXCEPTION BOTTOM BAR $e $s");
    }
    log("HELLO BOTTOM BAR $selectedIndex");
  }

  List<Widget> screens = [
    SettingView(),
    AlertView(),
    TrackRouteView(),
    VehicalesView(),
    ProfileView()
  ];
}
