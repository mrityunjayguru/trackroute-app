import '../../../../utils/utils.dart';
import 'Location.dart';

/// _id : "6718f864a0c62615207c0eca"
/// vehicleRegistrationNo : "gmvv"
/// fuel : "InActive"
/// vehicleNo : "Vehicle2211OOi"
/// deviceId : "IMEI598LP"
/// imei : "IMEI598ZH"
/// vehicleType : "67090d24501e002037ce2c87"
/// vehicleBrand : "guv"
/// vehicleModel : "v"
/// maxSpeed : "70"
/// Area : "78"
/// parking : true
/// location : {"longitude":23.0539966,"latitude":72.5195762}

class DeviceDetails {
  DeviceDetails({
      this.id, 
      this.vehicleRegistrationNo, 
      this.fuel, 
      this.vehicleNo, 
      this.deviceId, 
      this.imei, 
      this.vehicleType, 
      this.vehicleBrand, 
      this.vehicleModel, 
      this.maxSpeed, 
      this.area, 
      this.parking, 
      this.location,});

  DeviceDetails.fromJson(dynamic json) {
    id = json['_id'];
    vehicleRegistrationNo = json['vehicleRegistrationNo'];
    fuel = json['fuel'];
    vehicleNo = json['vehicleNo'];
    deviceId = json['deviceId'];
    imei = json['imei'];
    vehicleType = json['vehicleType'];
    vehicleBrand = json['vehicleBrand'];
    vehicleModel = json['vehicleModel'];
    maxSpeed = Utils.parseDouble(data: json['maxSpeed'].toString());
    area = json['Area'];
    parking = json['parking'];
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
  }
  String? id;
  String? vehicleRegistrationNo;
  String? fuel;
  String? vehicleNo;
  String? deviceId;
  String? imei;
  String? vehicleType;
  String? vehicleBrand;
  String? vehicleModel;
  double? maxSpeed;
  String? area;
  bool? parking;
  Location? location;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['vehicleRegistrationNo'] = vehicleRegistrationNo;
    map['fuel'] = fuel;
    map['vehicleNo'] = vehicleNo;
    map['deviceId'] = deviceId;
    map['imei'] = imei;
    map['vehicleType'] = vehicleType;
    map['vehicleBrand'] = vehicleBrand;
    map['vehicleModel'] = vehicleModel;
    map['maxSpeed'] = maxSpeed;
    map['Area'] = area;
    map['parking'] = parking;
    if (location != null) {
      map['location'] = location?.toJson();
    }
    return map;
  }

}