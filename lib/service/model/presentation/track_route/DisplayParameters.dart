/// AC : true
/// Door : true
/// Engine : true
/// Relay : true
/// GeoFencing : true
/// Parking : true
/// Network : true
/// Charging : true
/// GPS : true

class DisplayParameters {
  DisplayParameters({
      this.ac, 
      this.door, 
      this.engine, 
      this.relay, 
      this.geoFencing, 
      this.parking, 
      this.network, 
      this.charging, 
      this.humidity,
      this.temperature,
      this.bluetooth,
      this.overspeed,
      this.extBattery,
      this.internalBattery,
      this.vehicleMotion,
      this.gps,});

  DisplayParameters.fromJson(dynamic json) {
    ac = json['AC'];
    door = json['Door'];
    engine = json['Engine'];
    relay = json['Relay'];
    geoFencing = json['GeoFencing'];
    parking = json['Parking'];
    network = json['Network'];
    charging = json['Charging'];
    gps = json['GPS'];
    humidity = json['humidity'];
    temperature = json['temperature'];
    bluetooth = json['bluetooth'];
    overspeed = json['overspeed'];
    extBattery = json['externalBattery'];
    internalBattery = json['internalBattery'];
    extBattery = json['extBattery'];
    vehicleMotion = json['vehicleMotion'];
  }
  bool? ac;
  bool? door;
  bool? engine;
  bool? relay;
  bool? geoFencing;
  bool? parking;
  bool? network;
  bool? charging;
  bool? gps;
  bool? humidity;
  bool? temperature;
  bool? bluetooth;
  bool? overspeed;
  bool? extBattery;
  bool? internalBattery;
  bool? vehicleMotion;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['AC'] = ac;
    map['Door'] = door;
    map['Engine'] = engine;
    map['Relay'] = relay;
    map['GeoFencing'] = geoFencing;
    map['Parking'] = parking;
    map['Network'] = network;
    map['Charging'] = charging;
    map['GPS'] = gps;
    map['extBattery'] = extBattery;
    map['internalBattery'] = internalBattery;
    map['vehicleMotion'] = vehicleMotion;
    return map;
  }

}