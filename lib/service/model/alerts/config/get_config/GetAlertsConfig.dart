import 'Data.dart';

/// data : {"notificationPermission":{"ignitionOn":false,"ignitionOff":true,"geoFenceIn":true,"geoFenceOut":true,"overSpeed":true,"powerCut":true,"vibration":true,"lowBattery":true},"_id":"6787df3c08f5a267333d03a2"}
/// message : "success"

class GetAlertsConfig {
  GetAlertsConfig({
      this.data, 
      this.message,});

  GetAlertsConfig.fromJson(dynamic json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }
  Data? data;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['message'] = message;
    return map;
  }

}