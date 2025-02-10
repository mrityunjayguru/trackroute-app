class SupportResponse {
  Data? data;
  String? message;
  int? status;

  SupportResponse({this.data, this.message, this.status});

  SupportResponse.fromJson(Map<String, dynamic> json) {
    // data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  String? deviceID;
  String? suport;
  String? description;
  String? userID;
  bool? isDeleted;
  String? status;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.deviceID,
      this.suport,
      this.description,
      this.userID,
      this.isDeleted,
      this.status,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    deviceID = json['deviceID'];
    suport = json['suport'];
    description = json['description'];
    userID = json['userID'];
    isDeleted = json['isDeleted'];
    status = json['status'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceID'] = this.deviceID;
    data['suport'] = this.suport;
    data['description'] = this.description;
    data['userID'] = this.userID;
    data['isDeleted'] = this.isDeleted;
    data['status'] = this.status;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
