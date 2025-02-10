import 'TrackingData.dart';
import 'VehicleDetails.dart';

/// _id : "6718e952414ebce84c970fd3"
/// fuel : "Active"
/// deviceId : "123456"
/// vehicleType : "67090d39501e002037ce2c8b"
/// ownerID : "67148ccb5700bd41154a323d"
/// trackingData : {"_id":"6718f991e0b3d074f9660c79","location":{"longitude":72.8777,"latitude":19.076},"course":"North","status":"Online","currentSpeed":80,"fuelGauge":{"quantity":50,"alarm":null},"ignition":{"status":true,"alarm":null},"ac":true,"door":false,"gps":true,"dailyDistance":120,"externalBattery":80,"internalBattery":60,"createdAt":"2024-10-23T13:26:41.874Z"}
/// vehicleDetails : {"_id":"67090d39501e002037ce2c8b","vehicleTypeName":"truck 102"}

class AlertResponse {
  AlertResponse({
      this.id, 
      this.fuel, 
      this.deviceId, 
      this.vehicleType, 
      this.ownerID, 
      this.vehicleNo,
      this.trackingData,
      this.vehicleDetails,});

  AlertResponse.fromJson(dynamic json) {
    id = json['_id'];
    fuel = json['fuel'];
    deviceId = json['deviceId'];
    vehicleType = json['vehicleType'];
    vehicleNo = json['vehicleNo'];
    ownerID = json['ownerID'];
    trackingData = json['trackingData'] != null ? TrackingData.fromJson(json['trackingData']) : null;
    vehicleDetails = json['vehicleDetails'] != null ? VehicleDetails.fromJson(json['vehicleDetails']) : null;
  }
  String? id;
  String? fuel;
  String? deviceId;
  String? vehicleType;
  String? vehicleNo;
  String? ownerID;
  TrackingData? trackingData;
  VehicleDetails? vehicleDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['fuel'] = fuel;
    map['deviceId'] = deviceId;
    map['vehicleType'] = vehicleType;
    map['ownerID'] = ownerID;
    if (trackingData != null) {
      map['trackingData'] = trackingData?.toJson();
    }
    if (vehicleDetails != null) {
      map['vehicleDetails'] = vehicleDetails?.toJson();
    }
    return map;
  }

}