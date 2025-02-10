import 'package:get/get.dart';
import 'package:track_route_pro/modules/about_us/controller/about_us_controller.dart';
import 'package:track_route_pro/modules/alert_screen/controller/alert_controller.dart';
import 'package:track_route_pro/modules/bottom_screen/controller/bottom_bar_controller.dart';
import 'package:track_route_pro/modules/faqs/controller/faqs_controller.dart';
import 'package:track_route_pro/modules/login_screen/controller/login_controller.dart';
import 'package:track_route_pro/modules/privacy_policy/controller/privacy_policy_controller.dart';
import 'package:track_route_pro/modules/privacy_policy/controller/privacy_policy_controller.dart';
import 'package:track_route_pro/modules/profile/controller/profile_controller.dart';
import 'package:track_route_pro/modules/settig_screen/controller/setting_controller.dart';
import 'package:track_route_pro/modules/splash_screen/controller/splash_controller.dart';
import 'package:track_route_pro/modules/support/controller/support_controller.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_route_controller.dart';
import 'package:track_route_pro/modules/vehicales/controller/vehicales_controller.dart';

import '../modules/route_history/controller/history_controller.dart';
import '../modules/splash_screen/controller/data_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(),
    );
  }
}

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
  }
}

class BottomNavigationBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomBarController>(
      () => BottomBarController(),
    );
  }
}

class ProfileBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}

class AlertBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlertController>(
      () => AlertController(),
    );
  }
}

class SettingBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingController>(
      () => SettingController(),
    );
  }
}

class TrackRouteBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrackRouteController>(
      () => TrackRouteController(),
    );
  }
}

class VehicalesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VehicalesController>(
      () => VehicalesController(),
    );
  }
}

class AboutUSBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AboutUsController>(
      () => AboutUsController(),
    );
  }
}

class FaqsBinDings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FaqsController>(
      () => FaqsController(),
    );
  }
}

class SupportBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupportController>(
      () => SupportController(),
    );
  }
}

class DataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DataController>(
          () => DataController(),
    );
  }
}

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryController>(
          () => HistoryController(),
    );
  }
}

class PrivacyPolicyBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivacyPolicyController>(
          () => PrivacyPolicyController(),
    );
  }
}