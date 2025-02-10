/// longitude : 23.0539966
/// latitude : 72.5195762

class Location {
  Location({
      this.longitude, 
      this.latitude,});

  Location.fromJson(dynamic json) {
    longitude = double.tryParse(json['longitude'].toString());
    latitude =  double.tryParse(json['latitude'].toString());
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