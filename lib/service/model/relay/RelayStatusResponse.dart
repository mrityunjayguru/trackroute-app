import 'Data.dart';

/// data : {"message":"Owl Mode set Successful","response":{"attributes":{},"description":"New…","deviceId":297211,"id":0,"textChannel":false,"type":"engineStop"},"status":"success"}
/// message : "success"

class RelayStatusResponse {
  RelayStatusResponse({
    this.data,
    this.message,
  });

  RelayStatusResponse.fromJson(dynamic json) {
    data = json['data'] != null ? DataStatus.fromJson(json['data']) : null;
    message = json['message'];
  }

  DataStatus? data;
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

class DataStatus {
  DataStatus({
    this.imei,
    this.immobiliser,
  });

  DataStatus.fromJson(dynamic json) {
    imei = json['imei'];
    immobiliser = json['immobiliser'];
  }

  String? imei;
  String? immobiliser;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['imei'] = imei;
    map['immobiliser'] = immobiliser;
    return map;
  }
}
