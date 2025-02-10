import 'Data.dart';

/// data : [{"_id":"67090d24501e002037ce2c87","vehicleTypeName":"car","icons":"11172864643649556_car.png","isDeleted":false,"status":true,"createdAt":"2024-10-11T11:33:56.661Z","updatedAt":"2024-10-11T11:33:56.662Z","__v":0},{"_id":"67090d2e501e002037ce2c89","vehicleTypeName":"Bus","icons":"1117286464464646_bus.png","isDeleted":false,"status":true,"createdAt":"2024-10-11T11:34:06.609Z","updatedAt":"2024-10-11T11:34:06.610Z","__v":0},{"_id":"67090d39501e002037ce2c8b","vehicleTypeName":"truck 102","icons":"11172864645754917_truck.gif","isDeleted":false,"status":true,"createdAt":"2024-10-11T11:34:17.760Z","updatedAt":"2024-10-11T11:34:17.760Z","__v":0},{"_id":"67090d45501e002037ce2c8d","vehicleTypeName":"auto 105","icons":"15172897637564355_auto.png","isDeleted":false,"status":true,"createdAt":"2024-10-11T11:34:29.237Z","updatedAt":"2024-10-15T07:05:11.944Z","__v":0},{"_id":"670e16f31aad27b6410c93cf","vehicleTypeName":"new car","icons":"1517289766272937_car.png","isDeleted":false,"status":true,"createdAt":"2024-10-15T07:17:07.465Z","updatedAt":"2024-10-15T07:17:07.469Z","__v":0}]
/// message : "success"
/// status : 200

class VehicleTypeList {
  VehicleTypeList({
      this.data, 
      this.message, 
      this.status,});

  VehicleTypeList.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(DataVehicleType.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }
  List<DataVehicleType>? data;
  String? message;
  int? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['message'] = message;
    map['status'] = status;
    return map;
  }

}