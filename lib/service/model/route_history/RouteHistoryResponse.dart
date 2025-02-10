import 'TrackingData.dart';
import 'Vehicletype.dart';

/// imei : "868003032593027"
/// trackingData : {"location":{"longitude":84.245125,"latitude":25.824387},"course":"online","ignition":{"status":true,"alarm":"null"},"createdAt":"2024-12-26T10:29:20.819Z"}
/// vehicletype : {"vehicleTypeName":"car 4001","icons":"29173285728654546_bus.png"}
/// dateFiled : "2024-12-26 15:59:20"

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