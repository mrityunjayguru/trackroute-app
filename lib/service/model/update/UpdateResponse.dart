import 'Data.dart';

/// data : {"_id":"67890965687db16383d73698","vehicleRegistrationNo":"HR36X3033","deviceId":"DIC0031","imei":"862408128000886","vehicleType":"6787de8908f5a267333d0382","dealerCode":"6787de7308f5a267333d0376","deviceType":"6787dde808f5a267333d0351","deviceSimNumber":"DIC005","fuleOutput":"Anolage/Device","ownerID":"6787df3c08f5a267333d03a2","maxSpeed":"40","parking":false,"parkingSpeed":3,"Area":"","immobiliser":"Pending","isDeleted":false,"status":"Active","createdAt":"2025-01-16T13:28:05.721Z","updatedAt":"2025-01-20T05:02:01.056Z","dateAdded":"2025-01-16T13:28:05.726Z","__v":0,"fuelStatus":"Off","operator":"Jio","driverName":"CPSC","mobileNo":"9876543210","vehicleModel":"Corolla","fitnessExpiryDate":"2025-12-31T00:00:00.000Z","insuranceExpiryDate":"2025-10-08T00:00:00.000Z","nationalPermitExpiryDate":"2026-01-15T00:00:00.000Z","pollutionExpiryDate":"2025-09-30T00:00:00.000Z","vehicleBrand":"Toyota","vehicleNo":"TN01AB1234"}
/// message : "Update successful."

class UpdateResponse {
  UpdateResponse({
      this.data, 
      this.message,});

  UpdateResponse.fromJson(dynamic json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }
  Data? data;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['message'] = message;
    return map;
  }

}