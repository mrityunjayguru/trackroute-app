import 'Data.dart';

/// data : {"message":"success"}
/// message : "success"
/// status : 200

class RelayResponse {
  RelayResponse({
      this.data, 
      this.message, 
      this.status,});

  RelayResponse.fromJson(dynamic json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
  }
  Data? data;
  String? message;
  int? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['message'] = message;
    map['status'] = status;
    return map;
  }

}