import 'NotificationPermission.dart';

/// notificationPermission : {"ignitionOn":false,"ignitionOff":true,"geoFenceIn":true,"geoFenceOut":true,"overSpeed":true,"powerCut":true,"vibration":true,"lowBattery":true}
/// _id : "6787df3c08f5a267333d03a2"

class Data {
  Data({
      this.notificationPermission, 
      this.id,});

  Data.fromJson(dynamic json) {
    notificationPermission = json['notificationPermission'] != null ? NotificationPermission.fromJson(json['notificationPermission']) : null;
    id = json['_id'];
  }
  NotificationPermission? notificationPermission;
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (notificationPermission != null) {
      map['notificationPermission'] = notificationPermission?.toJson();
    }
    map['_id'] = id;
    return map;
  }

}