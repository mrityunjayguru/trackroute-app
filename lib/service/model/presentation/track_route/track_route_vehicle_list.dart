import 'dart:developer';

import 'package:track_route_pro/service/model/presentation/track_route/DisplayParameters.dart';

import '../../../../utils/common_import.dart';
import '../../../../utils/utils.dart';
import 'Summary.dart';

class TrackRouteVehicleList {
  List<Data>? data;
  String? message;
  int? status;


  TrackRouteVehicleList({this.data, this.message, this.status});

  TrackRouteVehicleList.fromJson(Map<String, dynamic> json) {

    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {

        data!.add(new Data.fromJson(v));

      });
    }

    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}
class Data {
  String? sId;
  String? vehicleRegistrationNo;
  String? fuel;
  String? fuelStatus;
  String? vehicleNo;
  String? deviceId;
  String? imei;
  String? vehicleType;
  String? ownerID;
  bool? isDeleted;
  String? status;
  String? createdAt;
  String? dateAdded;
  String? updatedAt;
  int? iV;
  TrackingData? trackingData;
  Location? lastLocation;
  Vehicletype? vehicletype;
  String? driverName; // Driver's name
  String? immobiliser;
  String? subscriptionExp; // Subscription expiration
  String? subscriptionStart; // Subscription start date
  String? fitnessExpiryDate; // Fitness expiry date
  String? insuranceExpiryDate; // Insurance expiry date
  String? mobileNo; // Driver's mobile number
  String? nationalPermitExpiryDate; // National permit expiry date
  String? pollutionExpiryDate; // Pollution expiry date
  String? vehicleBrand; // Vehicle brand
  String? vehicleModel; // Vehicle model
  double? maxSpeed; // Maximum speed
  double? fuelLevel; // Maximum speed
  String? area; // Area
  String? course; // Area
  bool? parking; // Parking status
  double? isApplied; // Parking status
  bool? locationStatus; // Parking status
  bool? speedStatus; // Parking status
  Location? location; // Location details
  DisplayParameters? displayParameters;
  Summary? summary;

  Data({
    this.speedStatus,
    this.summary,
    this.locationStatus,
    this.sId,
    this.vehicleRegistrationNo,
    this.fuel,
    this.vehicleNo,
    this.deviceId,
    this.imei,
    this.course,
    this.fuelStatus,
    // this.vehicleType,
    this.ownerID,
    this.isDeleted,
    this.status,
    this.createdAt,
    this.dateAdded,
    this.updatedAt,
    this.iV,
    this.trackingData,
    this.vehicletype,
    this.driverName,
    this.subscriptionExp,
    this.subscriptionStart,
    this.fitnessExpiryDate,
    this.insuranceExpiryDate,
    this.mobileNo,
    this.nationalPermitExpiryDate,
    this.pollutionExpiryDate,
    this.vehicleBrand,
    this.vehicleModel,
    this.maxSpeed,
    this.area,
    this.parking,
    this.location,
    this.immobiliser,
    this.displayParameters,
    this.isApplied,
    this.lastLocation,
    this.fuelLevel
  });

  Data.fromJson(Map<String, dynamic> json) {
    // debugPrint("SUMMARY ${json['summary']}");
    summary = json['summary'] != null
        ? Summary.fromJson(json['summary'])
        : null;
    sId = json['_id'];
    vehicleRegistrationNo = json['vehicleRegistrationNo'];
    fuel = json['fuel'];
    vehicleNo = json['vehicleNo'];
    deviceId = json['deviceId'];
    imei = json['imei'];
    vehicleType = json['vehicleType'];
    ownerID = json['ownerID'];
    isDeleted = json['isDeleted'];
    status = json['status'];

    createdAt = json['createdAt'];
    dateAdded = json['dateAdded'];
    updatedAt = json['updatedAt'];
    fuelStatus = json['fuelStatus'];
    course = json['course'];
    iV = json['__v'];
    trackingData = json['trackingData'] != null
        ? TrackingData.fromJson(json['trackingData'])
        : null;
    lastLocation = json['lastLocation'] != null
        ? Location.fromJson(json['lastLocation'])
        : null;
    vehicletype = json['vehicletype'] != null
        ? Vehicletype.fromJson(json['vehicletype'])
        : null;
    driverName = json['driverName'];
    subscriptionExp = json['subscriptionexp'];
    subscriptionStart = json['subscriptiostart'];
    fitnessExpiryDate = json['fitnessExpiryDate'];
    insuranceExpiryDate = json['insuranceExpiryDate'];
    mobileNo = json['mobileNo'];
    nationalPermitExpiryDate = json['nationalPermitExpiryDate'];
    pollutionExpiryDate = json['pollutionExpiryDate'];
    vehicleBrand = json['vehicleBrand'];
    vehicleModel = json['vehicleModel'];
    maxSpeed = Utils.parseDouble(data: json['maxSpeed'].toString());
    fuelLevel = Utils.parseDouble(data: json['fuelLevel'].toString());
    isApplied = Utils.parseDouble(data: json['hoursDifference'].toString());
    area = json['Area'];
    parking = json['parking'];
    immobiliser = json['immobiliser'];
    locationStatus = json['locationStatus'];
    speedStatus = json['speedStatus'];
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
    displayParameters = json['displayParameters'] != null ? DisplayParameters.fromJson(json['displayParameters']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = this.sId;
    data['vehicleRegistrationNo'] = this.vehicleRegistrationNo;
    data['fuel'] = this.fuel;
    data['vehicleNo'] = this.vehicleNo;
    data['deviceId'] = this.deviceId;
    data['imei'] = this.imei;
    data['vehicleType'] = this.vehicleType;
    data['ownerID'] = this.ownerID;
    data['isDeleted'] = this.isDeleted;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['dateAdded'] = this.dateAdded;
    data['updatedAt'] = this.updatedAt;
    data['immobiliser'] = this.immobiliser;
    data['__v'] = this.iV;
    if (this.trackingData != null) {
      data['trackingData'] = this.trackingData!.toJson();
    }
    // if (this.vehicletype != null) {
    //   data['vehicletype'] = this.vehicletype!.toJson();
    // }
    data['driverName'] = this.driverName;
    data['subscriptionexp'] = this.subscriptionExp;
    data['subscriptiostart'] = this.subscriptionStart;
    data['fitnessExpiryDate'] = this.fitnessExpiryDate;
    data['insuranceExpiryDate'] = this.insuranceExpiryDate;
    data['mobileNo'] = this.mobileNo;
    data['nationalPermitExpiryDate'] = this.nationalPermitExpiryDate;
    data['pollutionExpiryDate'] = this.pollutionExpiryDate;
    data['vehicleBrand'] = this.vehicleBrand;
    data['vehicleModel'] = this.vehicleModel;
    data['maxSpeed'] = this.maxSpeed;
    data['Area'] = this.area;
    data['parking'] = this.parking;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    if (this.lastLocation != null) {
      data['lastLocation'] = this.lastLocation!.toJson();
    }
    return data;
  }
}

class Location {
  double? longitude;
  double? latitude;

  Location({this.longitude, this.latitude});

  Location.fromJson(Map<String, dynamic> json) {
    longitude = double.tryParse(json['longitude'].toString()) ?? 0;
    latitude = double.tryParse(json['latitude'].toString()) ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    return data;
  }
}

class TrackingData {
  String? sId;
  String? deviceID;
  String? deviceIMEI;
  String? vehicleNo;
  String? simIMEI;
  String? posID;
  String? simMobileNumber;
  Location? location;
  String? course;
  String? status;
  String? lastUpdateTime;
  String? vehicleType;
  String? deviceFixTime;
  double? currentSpeed;
  double? totalDistanceCovered;
  FuelGauge? fuelGauge;
  Ignition? ignition;
  bool? ac;
  bool? door;
  bool? gps;
  String? expiryDate;
  double? dailyDistance;
  double? tripDistance;
  String? lastIgnitionTime;
  double? externalBattery;
  double? internalBattery;
  double? fuel;
  String? network;
  double? temperature;
  String? createdAt;
  int? iV;
  String? rssi;
  String? adc1;
  String? humidity0;
  String? immobilizer;
  bool? motion;
  TrackingData(
      {this.sId,
        this.deviceID,
        this.deviceIMEI,
        this.vehicleNo,
        this.simIMEI,
        this.posID,
        this.simMobileNumber,
        this.location,
        this.course,
        this.status,
        this.lastUpdateTime,
        this.vehicleType,
        this.deviceFixTime,
        this.currentSpeed,
        this.totalDistanceCovered,
        this.fuelGauge,
        this.ignition,
        this.ac,
        this.door,
        this.gps,
        this.expiryDate,
        this.dailyDistance,
        this.tripDistance,
        this.lastIgnitionTime,
        this.externalBattery,
        this.internalBattery,
        this.fuel,
        this.network,
        this.temperature,
        this.createdAt,
        this.adc1,
        this.rssi,
        this.humidity0,
        this.immobilizer,
        this.motion,
        this.iV});

  TrackingData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    deviceID = json['deviceID'];
    deviceIMEI = json['deviceIMEI'];
    vehicleNo = json['vehicleNo'];
    simIMEI = json['simIMEI'];
    // posID = json['posID'];
    simMobileNumber = json['simMobileNumber'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    course = json['course'];
    status = json['status'];
    log("TRACKING STATUS ===== >   ${status}");
    lastUpdateTime = json['lastUpdateTime'];
    vehicleType = json['vehicleType'];
    deviceFixTime = json['deviceFixTime'];
    currentSpeed = double.tryParse(json['currentSpeed'].toString()) ?? 0.0;
    totalDistanceCovered = double.tryParse(json['totalDistanceCovered'].toString()) ?? 0.0;
    fuelGauge = json['fuelGauge'] != null
        ? new FuelGauge.fromJson(json['fuelGauge'])
        : null;
    ignition = json['ignition'] != null
        ? new Ignition.fromJson(json['ignition'])
        : null;
    ac = json['ac'];
    door = json['door'];
    gps = json['gps'];
    expiryDate = json['expiryDate'];
    dailyDistance = double.tryParse(json['dailyDistance'].toString()) ?? 0.0;
    tripDistance = double.tryParse(json['tripDistance'].toString()) ?? 0.0;
    lastIgnitionTime = json['lastIgnitionTime'];
    externalBattery = double.tryParse(json['externalBattery'].toString()) ?? 0.0;
    internalBattery = double.tryParse(json['internalBattery'].toString()) ?? 0.0;
    fuel = double.tryParse(json['fuel'].toString()) ?? 0.0;
    network = json['network'];
    temperature = double.tryParse(json['temperature'].toString()) ?? 0.0;
    createdAt = json['createdAt'];
    iV = json['__v'];
    // adc1 = json['adc1'];
    humidity0 = json['humidity0'];
    immobilizer = json['Immobilizer'];
    motion = json['Motion'];
    rssi = json['rssi'];
    // log("TRACKING DATA ======> {"
    //     "\n  sId: $sId,"
    //     "\n  deviceID: $deviceID,"
    //     "\n  deviceIMEI: $deviceIMEI,"
    //     "\n  vehicleNo: $vehicleNo,"
    //     "\n  simIMEI: $simIMEI,"
    //     "\n  simMobileNumber: $simMobileNumber,"
    //     "\n  location: ${location?.toJson()},"
    //     "\n  course: $course,"
    //     "\n  status: $status,"
    //     "\n  lastUpdateTime: $lastUpdateTime,"
    //     "\n  vehicleType: $vehicleType,"
    //     "\n  deviceFixTime: $deviceFixTime,"
    //     "\n  currentSpeed: $currentSpeed,"
    //     "\n  totalDistanceCovered: $totalDistanceCovered,"
    //     "\n  fuelGauge: ${fuelGauge?.toJson()},"
    //     "\n  ignition: ${ignition?.toJson()},"
    //     "\n  ac: $ac,"
    //     "\n  door: $door,"
    //     "\n  gps: $gps,"
    //     "\n  expiryDate: $expiryDate,"
    //     "\n  dailyDistance: $dailyDistance,"
    //     "\n  tripDistance: $tripDistance,"
    //     "\n  lastIgnitionTime: $lastIgnitionTime,"
    //     "\n  externalBattery: $externalBattery,"
    //     "\n  internalBattery: $internalBattery,"
    //     "\n  fuel: $fuel,"
    //     "\n  network: $network,"
    //     "\n  temperature: $temperature,"
    //     "\n  createdAt: $createdAt,"
    //     "\n  iV: $iV,"
    //     "\n  humidity0: $humidity0,"
    //     "\n  immobilizer: $immobilizer,"
    //     "\n  motion: $motion,"
    //     "\n  rssi: $rssi"
    //     "\n}");

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['deviceID'] = this.deviceID;
    data['deviceIMEI'] = this.deviceIMEI;
    data['vehicleNo'] = this.vehicleNo;
    data['simIMEI'] = this.simIMEI;
    data['posID'] = this.posID;
    data['simMobileNumber'] = this.simMobileNumber;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['course'] = this.course;
    data['status'] = this.status;
    data['lastUpdateTime'] = this.lastUpdateTime;
    data['vehicleType'] = this.vehicleType;
    data['deviceFixTime'] = this.deviceFixTime;
    data['currentSpeed'] = this.currentSpeed;
    data['totalDistanceCovered'] = this.totalDistanceCovered;
    if (this.fuelGauge != null) {
      data['fuelGauge'] = this.fuelGauge!.toJson();
    }
    if (this.ignition != null) {
      data['ignition'] = this.ignition!.toJson();
    }
    data['ac'] = this.ac;
    data['door'] = this.door;
    data['gps'] = this.gps;
    data['expiryDate'] = this.expiryDate;
    data['dailyDistance'] = this.dailyDistance;
    data['tripDistance'] = this.tripDistance;
    data['lastIgnitionTime'] = this.lastIgnitionTime;
    data['externalBattery'] = this.externalBattery;
    data['internalBattery'] = this.internalBattery;
    data['fuel'] = this.fuel;
    data['network'] = this.network;
    data['temperature'] = this.temperature;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    data['adc1'] = this.adc1;
    data['humidity0'] = this.humidity0;
    data['Immobilizer'] = this.immobilizer;
    data['Motion'] = this.motion;
    return data;
  }
}


// class Location {
//   double? longitude;
//   double? latitude;
//
//   Location({this.longitude, this.latitude});
//
//   Location.fromJson(Map<String, dynamic> json) {
//     longitude = json['longitude'];
//     latitude = json['latitude'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['longitude'] = this.longitude;
//     data['latitude'] = this.latitude;
//     return data;
//   }
// }

class FuelGauge {
  double? quantity;
  String? alarm;

  FuelGauge({this.quantity, this.alarm});

  FuelGauge.fromJson(Map<String, dynamic> json) {
    quantity = double.tryParse(json['quantity'].toString());
    alarm = json['alarm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quantity'] = this.quantity;
    data['alarm'] = this.alarm;
    return data;
  }
}

class Ignition {
  bool? status;
  String? alarm;

  Ignition({this.status, this.alarm});

  Ignition.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    alarm = json['alarm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['alarm'] = this.alarm;
    return data;
  }
}

class Vehicletype {
  String? sId;
  String? vehicleTypeName;
  String? icons;
  bool? isDeleted;
  bool? status;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Vehicletype(
      {this.sId,
      this.vehicleTypeName,
      this.icons,
      this.isDeleted,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Vehicletype.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    vehicleTypeName = json['vehicleTypeName'];
    icons = json['icons'];
    isDeleted = json['isDeleted'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['vehicleTypeName'] = this.vehicleTypeName;
    data['icons'] = this.icons;
    data['isDeleted'] = this.isDeleted;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
