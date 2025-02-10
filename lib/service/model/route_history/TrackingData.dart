import 'Location.dart';
import 'Ignition.dart';

/// location : {"longitude":84.245125,"latitude":25.824387}
/// course : "online"
/// ignition : {"status":true,"alarm":"null"}
/// createdAt : "2024-12-26T10:29:20.819Z"

class TrackingData {
  TrackingData({
      this.location, 
      this.course, 
      this.currentSpeed,
      this.ignition,
      this.createdAt,});

  TrackingData.fromJson(dynamic json) {
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
    course = json['course'];
    currentSpeed = double.tryParse(json['currentSpeed'].toString());
    ignition = json['ignition'] != null ? Ignition.fromJson(json['ignition']) : null;
    createdAt = json['createdAt'];
  }
  Location? location;
  String? course;
  double? currentSpeed;
  Ignition? ignition;
  String? createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (location != null) {
      map['location'] = location?.toJson();
    }
    map['course'] = course;
    map['currentSpeed'] = currentSpeed;
    if (ignition != null) {
      map['ignition'] = ignition?.toJson();
    }
    map['createdAt'] = createdAt;
    return map;
  }

}