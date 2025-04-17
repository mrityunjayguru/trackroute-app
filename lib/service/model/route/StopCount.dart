import 'Location.dart';

/// _id : "67eb878012e5f624387eb43c"
/// imei : "862408128000853"
/// igitionOF : false
/// location : {"longitude":77.426572,"latitude":28.612287}
/// createdAt : "2025-04-01T11:58:16.416Z"
/// updatedAt : "2025-04-01T11:58:16.416Z"
/// __v : 0

class StopCount {
  StopCount({

    this.stopDuration,
      this.id, 
      this.imei, 
      this.igitionOF, 
      this.distanceFromA,
      this.location,
      this.createdAt, 
      this.updatedAt,
      this.v,});

  StopCount.fromJson(dynamic json) {
    id = json['_id'];
    imei = json['imei'];
    igitionOF = json['igitionOF'];
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    distanceFromA = json['distanceFromA'].toString();
    stopDuration = json['stopDuration'].toString();
    v = json['__v'];
  }
  String? id;
  String? imei;
  bool? igitionOF;
  Location? location;
  String? createdAt;
  String? updatedAt;
  String? distanceFromA;
  String? stopDuration;
  int? v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['imei'] = imei;
    map['igitionOF'] = igitionOF;
    if (location != null) {
      map['location'] = location?.toJson();
    }
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }

}