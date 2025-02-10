/// message : "you have allReady make request for this device try after 24 hours"
/// status : 400

class RenewResponse {
  RenewResponse({
      this.message, 
      this.status,});

  RenewResponse.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
  }
  String? message;
  int? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['status'] = status;
    return map;
  }

}