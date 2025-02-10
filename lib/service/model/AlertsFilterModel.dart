/// Ignition On : true
/// Ignition Off : true
/// Geo-fence In : true
/// Geo-fence Out : true
/// Over-speed : true
/// Power-Cut : true
/// Vibration : true
/// Low battery : true
/// Others : false

class AlertsFilterModel {
  AlertsFilterModel({
      this.ignitionOn, 
      this.ignitionOff, 
      this.geofenceIn, 
      this.geofenceOut, 
      this.overspeed, 
      this.powerCut, 
      this.vibration, 
      this.lowbattery, 
      this.others,});

  AlertsFilterModel.fromJson(dynamic json) {
    ignitionOn = json['Ignition On'];
    ignitionOff = json['Ignition Off'];
    geofenceIn = json['Geo-fence In'];
    geofenceOut = json['Geo-fence Out'];
    overspeed = json['Over-speed'];
    powerCut = json['Power-Cut'];
    vibration = json['Vibration'];
    lowbattery = json['Low battery'];
    others = json['Others'];
  }
  bool? ignitionOn;
  bool? ignitionOff;
  bool? geofenceIn;
  bool? geofenceOut;
  bool? overspeed;
  bool? powerCut;
  bool? vibration;
  bool? lowbattery;
  bool? others;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Ignition On'] = ignitionOn;
    map['Ignition Off'] = ignitionOff;
    map['Geo-fence In'] = geofenceIn;
    map['Geo-fence Out'] = geofenceOut;
    map['Over-speed'] = overspeed;
    map['Power-Cut'] = powerCut;
    map['Vibration'] = vibration;
    map['Low battery'] = lowbattery;
    map['Others'] = others;
    return map;
  }

}