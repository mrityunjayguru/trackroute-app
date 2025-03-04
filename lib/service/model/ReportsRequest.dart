/// deviceId : ["862408128000886"]
/// days : "sevendays"

class ReportsRequest {
  ReportsRequest({
      this.deviceId, 
      this.days,});

  ReportsRequest.fromJson(dynamic json) {
    deviceId = json['deviceId'] != null ? json['deviceId'].cast<String>() : [];
    days = json['days'];
  }
  List<String>? deviceId;
  String? days;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['deviceId'] = deviceId;
    map['days'] = days;
    return map;
  }

}