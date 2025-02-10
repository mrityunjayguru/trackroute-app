import '../../../utils/utils.dart';

/// _id : "67890965687db16383d73698"
/// vehicleRegistrationNo : "HR36X3033"
/// deviceId : "DIC0031"
/// imei : "862408128000886"
/// vehicleType : "6787de8908f5a267333d0382"
/// dealerCode : "6787de7308f5a267333d0376"
/// deviceType : "6787dde808f5a267333d0351"
/// deviceSimNumber : "DIC005"
/// fuleOutput : "Anolage/Device"
/// ownerID : "6787df3c08f5a267333d03a2"
/// maxSpeed : "40"
/// parking : false
/// parkingSpeed : 3
/// Area : ""
/// immobiliser : "Pending"
/// isDeleted : false
/// status : "Active"
/// createdAt : "2025-01-16T13:28:05.721Z"
/// updatedAt : "2025-01-20T05:02:01.056Z"
/// dateAdded : "2025-01-16T13:28:05.726Z"
/// __v : 0
/// fuelStatus : "Off"
/// operator : "Jio"
/// driverName : "CPSC"
/// mobileNo : "9876543210"
/// vehicleModel : "Corolla"
/// fitnessExpiryDate : "2025-12-31T00:00:00.000Z"
/// insuranceExpiryDate : "2025-10-08T00:00:00.000Z"
/// nationalPermitExpiryDate : "2026-01-15T00:00:00.000Z"
/// pollutionExpiryDate : "2025-09-30T00:00:00.000Z"
/// vehicleBrand : "Toyota"
/// vehicleNo : "TN01AB1234"

class Data {
  Data({
      this.id, 
      this.vehicleRegistrationNo, 
      this.deviceId, 
      this.imei, 
      this.vehicleType, 
      this.dealerCode, 
      this.deviceType, 
      this.deviceSimNumber, 
      this.fuleOutput, 
      this.ownerID, 
      this.maxSpeed, 
      this.parking, 
      this.parkingSpeed, 
      this.area, 
      this.immobiliser, 
      this.isDeleted, 
      this.status, 
      this.createdAt, 
      this.updatedAt, 
      this.dateAdded, 
      this.v, 
      this.fuelStatus, 
      this.operator, 
      this.driverName, 
      this.mobileNo, 
      this.vehicleModel, 
      this.fitnessExpiryDate, 
      this.insuranceExpiryDate, 
      this.nationalPermitExpiryDate, 
      this.pollutionExpiryDate, 
      this.vehicleBrand, 
      this.vehicleNo,});

  Data.fromJson(dynamic json) {
    id = json['_id'];
    vehicleRegistrationNo = json['vehicleRegistrationNo'];
    deviceId = json['deviceId'];
    imei = json['imei'];
    vehicleType = json['vehicleType'];
    dealerCode = json['dealerCode'];
    deviceType = json['deviceType'];
    deviceSimNumber = json['deviceSimNumber'];
    fuleOutput = json['fuleOutput'];
    ownerID = json['ownerID'];
    maxSpeed = Utils.parseDouble(data: json['maxSpeed'].toString());
    parking = json['parking'];
    parkingSpeed = json['parkingSpeed'];
    area = json['Area'];
    immobiliser = json['immobiliser'];
    isDeleted = json['isDeleted'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    dateAdded = json['dateAdded'];
    v = json['__v'];
    fuelStatus = json['fuelStatus'];
    operator = json['operator'];
    driverName = json['driverName'];
    mobileNo = json['mobileNo'];
    vehicleModel = json['vehicleModel'];
    fitnessExpiryDate = json['fitnessExpiryDate'];
    insuranceExpiryDate = json['insuranceExpiryDate'];
    nationalPermitExpiryDate = json['nationalPermitExpiryDate'];
    pollutionExpiryDate = json['pollutionExpiryDate'];
    vehicleBrand = json['vehicleBrand'];
    vehicleNo = json['vehicleNo'];
  }
  String? id;
  String? vehicleRegistrationNo;
  String? deviceId;
  String? imei;
  String? vehicleType;
  String? dealerCode;
  String? deviceType;
  String? deviceSimNumber;
  String? fuleOutput;
  String? ownerID;
  double? maxSpeed;
  bool? parking;
  int? parkingSpeed;
  String? area;
  String? immobiliser;
  bool? isDeleted;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? dateAdded;
  int? v;
  String? fuelStatus;
  String? operator;
  String? driverName;
  String? mobileNo;
  String? vehicleModel;
  String? fitnessExpiryDate;
  String? insuranceExpiryDate;
  String? nationalPermitExpiryDate;
  String? pollutionExpiryDate;
  String? vehicleBrand;
  String? vehicleNo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['vehicleRegistrationNo'] = vehicleRegistrationNo;
    map['deviceId'] = deviceId;
    map['imei'] = imei;
    map['vehicleType'] = vehicleType;
    map['dealerCode'] = dealerCode;
    map['deviceType'] = deviceType;
    map['deviceSimNumber'] = deviceSimNumber;
    map['fuleOutput'] = fuleOutput;
    map['ownerID'] = ownerID;
    map['maxSpeed'] = maxSpeed;
    map['parking'] = parking;
    map['parkingSpeed'] = parkingSpeed;
    map['Area'] = area;
    map['immobiliser'] = immobiliser;
    map['isDeleted'] = isDeleted;
    map['status'] = status;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['dateAdded'] = dateAdded;
    map['__v'] = v;
    map['fuelStatus'] = fuelStatus;
    map['operator'] = operator;
    map['driverName'] = driverName;
    map['mobileNo'] = mobileNo;
    map['vehicleModel'] = vehicleModel;
    map['fitnessExpiryDate'] = fitnessExpiryDate;
    map['insuranceExpiryDate'] = insuranceExpiryDate;
    map['nationalPermitExpiryDate'] = nationalPermitExpiryDate;
    map['pollutionExpiryDate'] = pollutionExpiryDate;
    map['vehicleBrand'] = vehicleBrand;
    map['vehicleNo'] = vehicleNo;
    return map;
  }

}