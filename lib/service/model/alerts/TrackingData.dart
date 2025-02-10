import 'Location.dart';
import 'FuelGauge.dart';
import 'Ignition.dart';

/// _id : "6718f991e0b3d074f9660c79"
/// location : {"longitude":72.8777,"latitude":19.076}
/// course : "North"
/// status : "Online"
/// currentSpeed : 80
/// fuelGauge : {"quantity":50,"alarm":null}
/// ignition : {"status":true,"alarm":null}
/// ac : true
/// door : false
/// gps : true
/// dailyDistance : 120
/// externalBattery : 80
/// internalBattery : 60
/// createdAt : "2024-10-23T13:26:41.874Z"

class TrackingData {
  TrackingData({
      this.id, 
      this.location, 
      this.course, 
      this.status, 
      this.currentSpeed, 
      this.fuelGauge, 
      this.ignition, 
      this.ac, 
      this.door, 
      this.gps, 
      this.dailyDistance, 
      this.externalBattery, 
      this.internalBattery, 
      this.createdAt,});

  TrackingData.fromJson(dynamic json) {
    id = json['_id'];
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
    course = json['course'];
    status = json['status'];
    currentSpeed = json['currentSpeed'];
    fuelGauge = json['fuelGauge'] != null ? FuelGauge.fromJson(json['fuelGauge']) : null;
    ignition = json['ignition'] != null ? Ignition.fromJson(json['ignition']) : null;
    ac = json['ac'];
    door = json['door'];
    gps = json['gps'];
    dailyDistance = json['dailyDistance'];
    externalBattery = json['externalBattery'];
    internalBattery = json['internalBattery'];
    createdAt = json['createdAt'];
  }
  String? id;
  Location? location;
  String? course;
  String? status;
  int? currentSpeed;
  FuelGauge? fuelGauge;
  Ignition? ignition;
  bool? ac;
  bool? door;
  bool? gps;
  int? dailyDistance;
  int? externalBattery;
  int? internalBattery;
  String? createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    if (location != null) {
      map['location'] = location?.toJson();
    }
    map['course'] = course;
    map['status'] = status;
    map['currentSpeed'] = currentSpeed;
    if (fuelGauge != null) {
      map['fuelGauge'] = fuelGauge?.toJson();
    }
    if (ignition != null) {
      map['ignition'] = ignition?.toJson();
    }
    map['ac'] = ac;
    map['door'] = door;
    map['gps'] = gps;
    map['dailyDistance'] = dailyDistance;
    map['externalBattery'] = externalBattery;
    map['internalBattery'] = internalBattery;
    map['createdAt'] = createdAt;
    return map;
  }

}