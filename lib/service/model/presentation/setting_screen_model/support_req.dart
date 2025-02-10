class SupportReq {
  String? deviceID;
  String? suport;
  String? description;
  String? userID;

  SupportReq({this.deviceID, this.suport, this.description, this.userID});

  SupportReq.fromJson(Map<String, dynamic> json) {
    deviceID = json['deviceID'];
    suport = json['suport'];
    description = json['description'];
    userID = json['userID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceID'] = this.deviceID;
    data['suport'] = this.suport;
    data['description'] = this.description;
    data['userID'] = this.userID;
    return data;
  }
}
