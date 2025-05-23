import 'dart:developer';

import '../../../../utils/utils.dart';
import 'MaxSpeedLocation.dart';

/// latest_trip_km : 0
/// latest_trip_time : "2H 23M"
/// max_speed : 200
/// max_speed_time : "2025-02-11T11:12:08.613Z"
/// max_speed_location : {"longitude":76.619057,"latitude":28.183415}
/// avg_speed : "48.55"
/// total_travel_time : "29H 55M"

class Summary {
  Summary({
    this.latestTripKm,
    this.latestTripTime,
    this.maxSpeed,
    this.maxSpeedTime,
    this.maxSpeedLocation,
    this.avgSpeed,
    this.idelTime,
    this.motionTime,
    this.total_travel_km,
    this.totalTravelTime,
    this.tripStartTime,
    this.preTrip,
  });

  Summary.fromJson(dynamic json) {
    latestTripKm = json['latest_trip_km'] != null
        ? json['latest_trip_km'].toString()
        : null;
    latestTripTime = json['latest_trip_time'] != null
        ? json['latest_trip_time'].toString()
        : null;
    maxSpeed = json['max_speed'] != null ? json['max_speed'].toString() : null;
    total_travel_km = json['total_travel_km'] != null
        ? json['total_travel_km'].toString()
        : null;
    maxSpeedTime = json['max_speed_time'] != null
        ? json['max_speed_time'].toString()
        : null;
    maxSpeedLocation = json['max_speed_location'] != null
        ? MaxSpeedLocation.fromJson(json['max_speed_location'])
        : null;
    avgSpeed = json['avg_speed'] != null ? json['avg_speed'].toString() : null;
    totalTravelTime = json['total_travel_time'] != null
        ? json['total_travel_time'].toString()
        : null;
    motionTime =
        json['MotionTime'] != null ? json['MotionTime'].toString() : null;
    idelTime = json['idelTime'] != null ? json['idelTime'].toString() : null;
    tripStartTime =
        json['lastesTripTime'] != null ? json['lastesTripTime'] : null;
    preTrip = json['pre_trip'] != null ? json['pre_trip'] : null;
  }
  String? latestTripKm;
  String? latestTripTime;
  String? maxSpeed;
  String? maxSpeedTime;
  MaxSpeedLocation? maxSpeedLocation;
  String? avgSpeed;
  String? motionTime;
  String? idelTime;

  String? totalTravelTime;
  String? tripStartTime;
  String? preTrip;
  String? total_travel_km;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['latest_trip_km'] = latestTripKm;
    map['latest_trip_time'] = latestTripTime;
    map['max_speed'] = maxSpeed;
    map['max_speed_time'] = maxSpeedTime;
    if (maxSpeedLocation != null) {
      map['max_speed_location'] = maxSpeedLocation?.toJson();
    }
    map['avg_speed'] = avgSpeed;
    map['total_travel_time'] = totalTravelTime;
    map['MotionTime'] = motionTime;
    map['idelTime'] = idelTime;
    map['lastesTripTime'] = tripStartTime;
    map['pre_trip'] = preTrip;
    return map;
  }
}
