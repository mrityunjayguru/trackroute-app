/// longitude : 72.8777
/// latitude : 19.076

class Location {
  Location({
      this.longitude, 
      this.latitude,});

  Location.fromJson(dynamic json) {
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