import 'package:track_route_pro/utils/search_drop_down.dart';

/// _id : "67090d24501e002037ce2c87"
/// vehicleTypeName : "car"
/// icons : "11172864643649556_car.png"
/// isDeleted : false
/// status : true
/// createdAt : "2024-10-11T11:33:56.661Z"
/// updatedAt : "2024-10-11T11:33:56.662Z"
/// __v : 0

class DataVehicleType extends SearchDropDownModel{
  DataVehicleType({
      this.id, 
      this.name,
      this.icons, 
      this.isDeleted, 
      this.status, 
      this.createdAt, 
      this.updatedAt, 
      this.v,});

  DataVehicleType.fromJson(dynamic json) {
    id = json['_id'];
    name = json['vehicleTypeName'];
    icons = json['icons'];
    isDeleted = json['isDeleted'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }
  String? id;
  String? name;
  String? icons;
  bool? isDeleted;
  bool? status;
  String? createdAt;
  String? updatedAt;
  int? v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['vehicleTypeName'] = name;
    map['icons'] = icons;
    map['isDeleted'] = isDeleted;
    map['status'] = status;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }

}