/// vehicleTypeName : "car 4001"
/// icons : "29173285728654546_bus.png"

class Vehicletype {
  Vehicletype({
      this.vehicleTypeName, 
      this.icons,});

  Vehicletype.fromJson(dynamic json) {
    vehicleTypeName = json['vehicleTypeName'];
    icons = json['icons'];
  }
  String? vehicleTypeName;
  String? icons;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['vehicleTypeName'] = vehicleTypeName;
    map['icons'] = icons;
    return map;
  }

}