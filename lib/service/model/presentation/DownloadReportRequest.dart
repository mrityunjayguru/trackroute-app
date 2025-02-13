/// sevendays : true
/// today : true
/// yesterday : true
/// deviceId : ["862408128000853","862408128000886"]

class DownloadReportRequest {
  DownloadReportRequest({
      this.sevendays, 
      this.today, 
      this.yesterday, 
      this.deviceId,});

  DownloadReportRequest.fromJson(dynamic json) {
    sevendays = json['sevendays'];
    today = json['today'];
    yesterday = json['yesterday'];
    deviceId = json['deviceId'] != null ? json['deviceId'].cast<String>() : [];
  }
  bool? sevendays;
  bool? today;
  bool? yesterday;
  List<String>? deviceId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sevendays'] = sevendays;
    map['today'] = today;
    map['yesterday'] = yesterday;
    map['deviceId'] = deviceId;
    return map;
  }

}