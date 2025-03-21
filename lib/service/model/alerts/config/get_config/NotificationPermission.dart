/// all : true
/// Ignition : true
/// Geofencing : true
/// Over_Speed : true
/// Parking_Alert : true
/// AC_Door_Alert : true
/// Fuel_Alert : false
/// Expiry_Reminders : true
/// Vibration : true
/// Device_Power_Cut : true
/// Device_Low_Battery : true
/// Other_Alerts : true

class NotificationPermission {
  NotificationPermission({
      this.all, 
      this.ignition, 
      this.geofencing, 
      this.overSpeed, 
      this.parkingAlert, 
      this.aCDoorAlert, 
      this.fuelAlert, 
      this.vehicleLowBattery,
      this.expiryReminders,
      this.vibration, 
      this.devicePowerCut, 
      this.deviceLowBattery, 
      this.otherAlerts,});

  NotificationPermission.fromJson(dynamic json) {
    all = json['all'];
    ignition = json['Ignition'];
    geofencing = json['Geofencing'];
    overSpeed = json['Over_Speed'];
    parkingAlert = json['Parking_Alert'];
    aCDoorAlert = json['AC_Door_Alert'];
    fuelAlert = json['Fuel_Alert'];
    expiryReminders = json['Expiry_Reminders'];
    vibration = json['Vibration'];
    devicePowerCut = json['Device_Power_Cut'];
    deviceLowBattery = json['Device_Low_Battery'];
    otherAlerts = json['Other_Alerts'];
    vehicleLowBattery = json['vehicleLowBattery'];
  }
  bool? all;
  bool? ignition;
  bool? geofencing;
  bool? overSpeed;
  bool? parkingAlert;
  bool? aCDoorAlert;
  bool? fuelAlert;
  bool? expiryReminders;
  bool? vibration;
  bool? devicePowerCut;
  bool? deviceLowBattery;
  bool? vehicleLowBattery;
  bool? otherAlerts;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['all'] = all;
    map['Ignition'] = ignition;
    map['Geofencing'] = geofencing;
    map['Over_Speed'] = overSpeed;
    map['Parking_Alert'] = parkingAlert;
    map['AC_Door_Alert'] = aCDoorAlert;
    map['Fuel_Alert'] = fuelAlert;
    map['Expiry_Reminders'] = expiryReminders;
    map['Vibration'] = vibration;
    map['Device_Power_Cut'] = devicePowerCut;
    map['Device_Low_Battery'] = deviceLowBattery;
    map['Other_Alerts'] = otherAlerts;
    map['vehicleLowBattery'] = vehicleLowBattery;
    return map;
  }

}