import 'Notificationalert.dart';
import 'Location.dart';
import 'DeviceDetails.dart';

/// _id : "67456c96448b1ccee40469bf"
/// notificationalert : {"notification":{"title":"Speed Alert: Door Open!","body":"Your vehicle is moving at 80 km/h while the door is open. Please slow down to avoid accidents or further damage."},"token":"eFMT1ZUfQsa6eKDRZ81rp3:APA91bGrrmtlGeAMqwLqw0syWPwuxj36xVpxWPl6Iy2fI8C2ZWx-f11R33koRoWK-5KHzRQsvs1tPgBDRtvWg-Vs_fO0vknHLQsqDkwvtgHPNf4JhCpMEhK2XUm6UHvc2HbIhOGeAVd4"}
/// deviceId : "123456"
/// alertfor : "door"
/// location : {"longitude":-73.935242,"latitude":40.73061}
/// createdAt : "2024-11-26T06:37:10.354Z"
/// deviceDetails : {"_id":"6718f864a0c62615207c0eca","vehicleRegistrationNo":"gmvv","fuel":"InActive","vehicleNo":"Vehicle2211OOi","deviceId":"IMEI598LP","imei":"IMEI598ZH","vehicleType":"67090d24501e002037ce2c87","vehicleBrand":"guv","vehicleModel":"v","maxSpeed":"70","Area":"78","parking":true,"location":{"longitude":23.0539966,"latitude":72.5195762}}

class AlertsResponse {
  AlertsResponse({
      this.id, 
      this.notificationalert, 
      this.deviceId, 
      this.alertfor, 
      this.location, 
      this.createdAt, 
      this.deviceDetails,});

  AlertsResponse.fromJson(dynamic json) {
    id = json['_id'];
    notificationalert = json['notificationalert'] != null ? Notificationalert.fromJson(json['notificationalert']) : null;
    deviceId = json['deviceId'];
    alertfor = json['alertfor'];
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
    createdAt = json['createdAt'];
    deviceDetails = json['deviceDetails'] != null ? DeviceDetails.fromJson(json['deviceDetails']) : null;
  }
  String? id;
  Notificationalert? notificationalert;
  String? deviceId;
  String? alertfor;
  Location? location;
  String? createdAt;
  DeviceDetails? deviceDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    if (notificationalert != null) {
      map['notificationalert'] = notificationalert?.toJson();
    }
    map['deviceId'] = deviceId;
    map['alertfor'] = alertfor;
    if (location != null) {
      map['location'] = location?.toJson();
    }
    map['createdAt'] = createdAt;
    if (deviceDetails != null) {
      map['deviceDetails'] = deviceDetails?.toJson();
    }
    return map;
  }

}