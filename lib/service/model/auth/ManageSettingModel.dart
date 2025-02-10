import 'Data.dart';

/// data : [{"_id":"6711155dd2a575a9b446c100","mobileSupport":"8798659856","supportEmail":"1lksdflsflsdjf@gmail.com","emailTitle":"1sdsda@gmail.com","catalogueLink":"https://www.facebook.com/","websiteLink":"https://c1.png","websiteLabel":"https://c1.png","privacyLink":"https://c1.png","logo":"20172942475983259_splash-fashion-sales-33-to-60-off-ad-hyderabad-chronicle-16-06-2017.jpg","status":"Active","isDeleted":false,"createdAt":"2024-10-17T13:47:09.049Z","updatedAt":"2024-10-20T11:46:00.062Z","__v":0}]
/// message : "success"
/// status : 200

class ManageSettingModel {
  ManageSettingModel({
      this.data, 
      this.message, 
      this.status,});

  ManageSettingModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(DataSetting.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }
  List<DataSetting>? data;
  String? message;
  int? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['message'] = message;
    map['status'] = status;
    return map;
  }

}