/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// Directory path: assets/images/png
  $AssetsImagesPngGen get png => const $AssetsImagesPngGen();

  /// Directory path: assets/images/svg
  $AssetsImagesSvgGen get svg => const $AssetsImagesSvgGen();
}

class $AssetsImagesPngGen {
  const $AssetsImagesPngGen();

  /// File path: assets/images/png/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/images/png/logo.png');

  /// List of all assets
  List<AssetGenImage> get values => [logo];
}

class $AssetsImagesSvgGen {
  const $AssetsImagesSvgGen();

  /// File path: assets/images/svg/bt_car.svg
  String get btCar => 'assets/images/svg/bt_car.svg';

  /// File path: assets/images/svg/bt_menu.svg
  String get btMenu => 'assets/images/svg/bt_menu.svg';

  /// File path: assets/images/svg/bt_notification.svg
  String get btNotification => 'assets/images/svg/bt_notification.svg';

  /// File path: assets/images/svg/bt_steering-wheel.svg
  String get btSteeringWheel => 'assets/images/svg/bt_steering-wheel.svg';

  /// File path: assets/images/svg/bt_track_route.svg
  String get btTrackRoute => 'assets/images/svg/bt_track_route.svg';

  /// File path: assets/images/svg/ic_Isolation_Mode.svg
  String get icIsolationMode => 'assets/images/svg/ic_Isolation_Mode.svg';

  /// File path: assets/images/svg/ic_arrow_down.svg
  String get icArrowDown => 'assets/images/svg/ic_arrow_down.svg';

  /// File path: assets/images/svg/ic_check.svg
  String get icCheck => 'assets/images/svg/ic_check.svg';

  /// File path: assets/images/svg/ic_close.svg
  String get icClose => 'assets/images/svg/ic_close.svg';

  /// File path: assets/images/svg/ic_flash_green.svg
  String get icFlashGreen => 'assets/images/svg/ic_flash_green.svg';

  /// File path: assets/images/svg/ic_flash_red.svg
  String get icFlashRed => 'assets/images/svg/ic_flash_red.svg';

  /// File path: assets/images/svg/ic_gps.svg
  String get icGps => 'assets/images/svg/ic_gps.svg';

  /// File path: assets/images/svg/ic_loading.svg
  String get icLoading => 'assets/images/svg/ic_loading.svg';

  /// File path: assets/images/svg/ic_navigation.svg
  String get icNavigation => 'assets/images/svg/ic_navigation.svg';

  /// File path: assets/images/svg/ic_speedometer.svg
  String get icSpeedometer => 'assets/images/svg/ic_speedometer.svg';

  /// File path: assets/images/svg/ic_view.svg
  String get icView => 'assets/images/svg/ic_view.svg';

  /// File path: assets/images/svg/logo.svg
  String get logo => 'assets/images/svg/logo.svg';

  /// File path: assets/images/svg/navigation1.svg
  String get navigation1 => 'assets/images/svg/navigation1.svg';

  /// List of all assets
  List<String> get values => [
        btCar,
        btMenu,
        btNotification,
        btSteeringWheel,
        btTrackRoute,
        icIsolationMode,
        icArrowDown,
        icCheck,
        icClose,
        icFlashGreen,
        icFlashRed,
        icGps,
        icLoading,
        icNavigation,
        icSpeedometer,
        icView,
        logo,
        navigation1
      ];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
