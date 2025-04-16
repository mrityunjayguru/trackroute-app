/// vehicleTypeName : "SUV"
/// icons : "29174327452754227_SUV.svg"

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