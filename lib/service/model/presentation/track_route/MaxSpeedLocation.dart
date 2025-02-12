/// longitude : 76.619057
/// latitude : 28.183415

class MaxSpeedLocation {
  MaxSpeedLocation({
      this.longitude, 
      this.latitude,});

  MaxSpeedLocation.fromJson(dynamic json) {
    longitude = json['longitude'];
    latitude = json['latitude'];
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