import 'Data.dart';

/// data : {"message":"Owl Mode set Successful","response":{"attributes":{},"description":"New…","deviceId":297211,"id":0,"textChannel":false,"type":"engineStop"},"status":"success"}
/// message : "success"

class RelayStatusResponse {
  RelayStatusResponse({
      this.data, 
      this.message,});

  RelayStatusResponse.fromJson(dynamic json) {
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