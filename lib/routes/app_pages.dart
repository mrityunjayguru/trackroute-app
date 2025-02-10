import 'package:get/get.dart';
import 'package:track_route_pro/bindings/bindings.dart';
import 'package:track_route_pro/modules/Login_Screen/view/login_screen.dart';
import 'package:track_route_pro/modules/about_us/view/about_us.dart';
import 'package:track_route_pro/modules/alert_screen/view/alert_view.dart';
import 'package:track_route_pro/modules/bottom_screen/view/bottom_bar_view.dart';
import 'package:track_route_pro/modules/faqs/view/faqs_view.dart';
import 'package:track_route_pro/modules/profile/view/profile_view.dart';
import 'package:track_route_pro/modules/settig_screen/view/setting_view.dart';
import 'package:track_route_pro/modules/splash_screen/view/splash_screen.dart';
import 'package:track_route_pro/modules/support/view/support_view.dart';
import 'package:track_route_pro/modules/track_route_screen/view/track_route_view.dart';
import 'package:track_route_pro/modules/vehicales/view/vehicales_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.BOTTOMBAR,
      page: () => BottomBarView(),
      binding: BottomNavigationBarBinding(),
    ),
    GetPage(
      name: _Paths.ALERT,
      page: () => AlertView(),
      binding: AlertBindings(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBindings(),
    ),
    GetPage(
      name: _Paths.SETTING,
      page: () => SettingView(),
      binding: SettingBindings(),
    ),
    GetPage(
      name: _Paths.TRACK_ROUTE,
      page: () => TrackRouteView(),
      binding: TrackRouteBindings(),
    ),
    GetPage(
      name: _Paths.VEHICALES,
      page: () => VehicalesView(),
      binding: VehicalesBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT_US,
      page: () => AboutUsView(),
      binding: AboutUSBindings(),
    ),
    GetPage(
      name: _Paths.FAQS,
      page: () => FaqsView(),
      binding: FaqsBinDings(),
    ),
    GetPage(
      name: _Paths.SUPPORT,
      page: () => SupportView(),
      binding: SupportBindings(),
    ),
  ];
}
