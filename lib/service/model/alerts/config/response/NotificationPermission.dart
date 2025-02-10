/// ignitionOn : false
/// ignitionOff : true
/// geoFenceIn : true
/// geoFenceOut : true
/// overSpeed : true
/// powerCut : true
/// vibration : true
/// lowBattery : true

class NotificationPermission {
  NotificationPermission({
      this.ignitionOn, 
      this.ignitionOff, 
      this.geoFenceIn, 
      this.geoFenceOut, 
      this.overSpeed, 
      this.powerCut, 
      this.vibration, 
      this.lowBattery,});

  NotificationPermission.fromJson(dynamic json) {
    ignitionOn = json['ignitionOn'];
    ignitionOff = json['ignitionOff'];
    geoFenceIn = json['geoFenceIn'];
    geoFenceOut = json['geoFenceOut'];
    overSpeed = json['overSpeed'];
    powerCut = json['powerCut'];
    vibration = json['vibration'];
    lowBattery = json['lowBattery'];
  }
  bool? ignitionOn;
  bool? ignitionOff;
  bool? geoFenceIn;
  bool? geoFenceOut;
  bool? overSpeed;
  bool? powerCut;
  bool? vibration;
  bool? lowBattery;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ignitionOn'] = ignitionOn;
    map['ignitionOff'] = ignitionOff;
    map['geoFenceIn'] = geoFenceIn;
    map['geoFenceOut'] = geoFenceOut;
    map['overSpeed'] = overSpeed;
    map['powerCut'] = powerCut;
    map['vibration'] = vibration;
    map['lowBattery'] = lowBattery;
    return map;
  }

}