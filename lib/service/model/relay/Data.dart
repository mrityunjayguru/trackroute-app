import 'Response.dart';

/// message : "Owl Mode set Successful"
/// response : {"attributes":{},"description":"New…","deviceId":297211,"id":0,"textChannel":false,"type":"engineStop"}
/// status : "success"

class Data {
  Data({
      this.message, 
      this.response, 
      this.status,});

  Data.fromJson(dynamic json) {
    message = json['message'];
    response = json['response'] != null ? Response.fromJson(json['response']) : null;
    status = json['status'];
  }
  String? message;
  Response? response;
  String? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (response != null) {
      map['response'] = response?.toJson();
    }
    map['status'] = status;
    return map;
  }

}