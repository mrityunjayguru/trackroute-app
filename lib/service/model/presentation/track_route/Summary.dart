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
      this.totalTravelTime,});

  Summary.fromJson(dynamic json) {
    latestTripKm = Utils.parseDouble(data: json['latest_trip_km'].toString());
    latestTripTime = json['latest_trip_time'];
    maxSpeed = Utils.parseDouble(data: json['max_speed'].toString());
    maxSpeedTime = json['max_speed_time'];
    maxSpeedLocation = json['max_speed_location'] != null ? MaxSpeedLocation.fromJson(json['max_speed_location']) : null;
    avgSpeed = json['avg_speed'];
    totalTravelTime = json['total_travel_time'];
  }
  double? latestTripKm;
  String? latestTripTime;
  double? maxSpeed;
  String? maxSpeedTime;
  MaxSpeedLocation? maxSpeedLocation;
  String? avgSpeed;
  String? totalTravelTime;

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
    return map;
  }
  bool get isNotEmpty {
    return latestTripKm != null ||
        (latestTripTime != null && latestTripTime!.isNotEmpty) ||
        maxSpeed != null ||
        (maxSpeedTime != null && maxSpeedTime!.isNotEmpty) ||
        maxSpeedLocation != null ||
        (avgSpeed != null && avgSpeed!.isNotEmpty) ||
        (totalTravelTime != null && totalTravelTime!.isNotEmpty);;
  }

  bool get isEmpty => !isNotEmpty;
}