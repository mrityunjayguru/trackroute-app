import 'TrackingData.dart';
import 'Vehicletype.dart';

/// imei : "862408128000853"
/// trackingData : {"location":{"longitude":77.425343,"latitude":28.614082},"course":"320","currentSpeed":0,"ignition":{"status":true,"alarm":"null"},"createdAt":"2025-04-01T16:04:16.522Z","distanceFromA":0}
/// vehicletype : {"vehicleTypeName":"SUV","icons":"29174327452754227_SUV.svg"}
/// dateFiled : "2025-04-01 16:04:16"

class RouteHistoryResponse {
  RouteHistoryResponse({
      this.imei, 
      this.trackingData, 
      this.vehicletype, 
      this.dateFiled,});

  RouteHistoryResponse.fromJson(dynamic json) {
    imei = json['imei'];
    trackingData = json['trackingData'] != null ? TrackingData.fromJson(json['trackingData']) : null;
    vehicletype = json['vehicletype'] != null ? Vehicletype.fromJson(json['vehicletype']) : null;
    dateFiled = json['dateFiled'];
  }
  String? imei;
  TrackingData? trackingData;
  Vehicletype? vehicletype;
  String? dateFiled;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['imei'] = imei;
    if (trackingData != null) {
      map['trackingData'] = trackingData?.toJson();
    }
    if (vehicletype != null) {
      map['vehicletype'] = vehicletype?.toJson();
    }
    map['dateFiled'] = dateFiled;
    return map;
  }

}