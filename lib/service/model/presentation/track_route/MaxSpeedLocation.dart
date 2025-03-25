import '../../../../utils/utils.dart';

/// longitude : 76.619057
/// latitude : 28.183415

class MaxSpeedLocation {
  MaxSpeedLocation({
      this.longitude, 
      this.latitude,});

  MaxSpeedLocation.fromJson(dynamic json) {
    longitude = Utils.parseDouble(data:json['longitude'].toString());
    latitude = Utils.parseDouble(data: json['latitude'].toString());
  }
  double? longitude;
  double? latitude;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['longitude'] = longitude;
    map['latitude'] = latitude;
    return map;
  }

}