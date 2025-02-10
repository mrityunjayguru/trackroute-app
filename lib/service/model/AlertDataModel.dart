import 'dart:ui';

import 'alerts/AlertResponse.dart';

/// name : ""
/// latitude : 0.0
/// longitude : 0.0
/// date : ""
/// title : ""

class AlertDataModel {
  AlertDataModel({
      this.name, 
      this.latitude, 
      this.longitude, 
      this.color,
      this.date,
      this.title,});

  AlertDataModel.fromJson(dynamic json) {
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    date = json['date'];
    title = json['title'];
  }
  String? name;
  double? latitude;
  double? longitude;
  String? date;
  String? title;
  Color? color;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['date'] = date;
    map['title'] = title;
    return map;
  }

  static AlertDataModel convertData(AlertResponse alertResponse, String title, Color color) {
    return AlertDataModel(
      name: alertResponse.vehicleNo ?? "",
      latitude: alertResponse.trackingData?.location?.latitude ?? 0.0,
      longitude: alertResponse.trackingData?.location?.longitude ?? 0.0,
      date: alertResponse.trackingData?.createdAt,
      title:title,
      color:color,
    );
  }

}