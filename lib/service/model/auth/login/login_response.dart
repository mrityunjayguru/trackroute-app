class LoginResponse {
  DataLogin? data;
  String? token;
  String? message;
  int? status;

  LoginResponse({this.data, this.token, this.message, this.status});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new DataLogin.fromJson(json['data']) : null;
    token = json['token'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['token'] = this.token;
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class DataLogin {
  String? sId;
  String? name;
  String? uniqueID;
  String? emailAddress;
  String? phone;
  int? len;
  String? dob;
  String? gender;
  String? address;
  String? country;
  String? state;
  String? city;
  String? pinCode;
  String? companyId;
  String? profile;
  String? profileId;
  int? otp;
  String? role;
  String? subscripeType;
  String? token;
  bool? status;
  bool? notification;
  String? createdAt;
  String? updatedAt;
  int? iV;

  DataLogin(
      {this.sId,
      this.name,
      this.uniqueID,
      this.emailAddress,
      this.phone,
      this.len,
      this.dob,
      this.gender,
      this.address,
      this.country,
      this.state,
      this.city,
      this.pinCode,
      this.companyId,
      this.profile,
      this.profileId,
      this.otp,
      this.role,
      this.subscripeType,
      this.token,
      this.status,
      this.createdAt,
      this.notification,
      this.updatedAt,
      this.iV});

  DataLogin.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['Name'];
    uniqueID = json['uniqueID'];
    emailAddress = json['emailAddress'];
    phone = json['phone'];
    len = json['len'];
    dob = json['dob'];
    gender = json['gender'];
    address = json['address'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    pinCode = json['pinCode'];
    companyId = json['companyId'];
    profile = json['profile'];
    profileId = json['profileId'];
    otp = json['otp'];
    role = json['role'];
    subscripeType = json['subscripeType'];
    token = json['token'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    notification = json['notification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['Name'] = this.name;
    data['uniqueID'] = this.uniqueID;
    data['emailAddress'] = this.emailAddress;
    data['phone'] = this.phone;
    data['len'] = this.len;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['address'] = this.address;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['pinCode'] = this.pinCode;
    data['companyId'] = this.companyId;
    data['profile'] = this.profile;
    data['profileId'] = this.profileId;
    data['otp'] = this.otp;
    data['role'] = this.role;
    data['subscripeType'] = this.subscripeType;
    data['token'] = this.token;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
