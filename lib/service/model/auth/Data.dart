/// _id : "6711155dd2a575a9b446c100"
/// mobileSupport : "8798659856"
/// supportEmail : "1lksdflsflsdjf@gmail.com"
/// emailTitle : "1sdsda@gmail.com"
/// catalogueLink : "https://www.facebook.com/"
/// websiteLink : "https://c1.png"
/// websiteLabel : "https://c1.png"
/// privacyLink : "https://c1.png"
/// logo : "20172942475983259_splash-fashion-sales-33-to-60-off-ad-hyderabad-chronicle-16-06-2017.jpg"
/// status : "Active"
/// isDeleted : false
/// createdAt : "2024-10-17T13:47:09.049Z"
/// updatedAt : "2024-10-20T11:46:00.062Z"
/// __v : 0

class DataSetting {
  DataSetting({
      this.id, 
      this.mobileSupport, 
      this.supportEmail, 
      this.emailTitle, 
      this.catalogueLink, 
      this.websiteLink, 
      this.websiteLabel, 
      this.privacyLink, 
      this.logo, 
      this.appLogo,
      this.status,
      this.isDeleted, 
      this.createdAt, 
      this.updatedAt, 
      this.v,});

  DataSetting.fromJson(dynamic json) {
    id = json['_id'];
    mobileSupport = json['mobileSupport'];
    supportEmail = json['supportEmail'];
    emailTitle = json['emailTitle'];
    catalogueLink = json['catalogueLink'];
    websiteLink = json['websiteLink'];
    websiteLabel = json['websiteLabel'];
    privacyLink = json['privacyLink'];
    logo = json['logo'];
    appLogo = json['applogo'];
    status = json['status'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }
  String? id;
  String? mobileSupport;
  String? supportEmail;
  String? emailTitle;
  String? catalogueLink;
  String? websiteLink;
  String? websiteLabel;
  String? privacyLink;
  String? logo;
  String? appLogo;
  String? status;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['mobileSupport'] = mobileSupport;
    map['supportEmail'] = supportEmail;
    map['emailTitle'] = emailTitle;
    map['catalogueLink'] = catalogueLink;
    map['websiteLink'] = websiteLink;
    map['websiteLabel'] = websiteLabel;
    map['privacyLink'] = privacyLink;
    map['logo'] = logo;
    map['status'] = status;
    map['isDeleted'] = isDeleted;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }

}