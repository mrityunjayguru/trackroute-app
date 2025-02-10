/// _id : "67090d39501e002037ce2c8b"
/// vehicleTypeName : "truck 102"

class VehicleDetails {
  VehicleDetails({
      this.id, 
      this.vehicleTypeName,});

  VehicleDetails.fromJson(dynamic json) {
    id = json['_id'];
    vehicleTypeName = json['vehicleTypeName'];
  }
  String? id;
  String? vehicleTypeName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['vehicleTypeName'] = vehicleTypeName;
    return map;
  }

}