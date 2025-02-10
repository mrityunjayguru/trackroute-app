class FCMDataResponse {
  Data? data;
  String? message;

  FCMDataResponse({this.data, this.message});

  FCMDataResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  Permissions? permissions;
  String? sId;
  String? name;
  String? uniqueID;
  String? emailAddress;
  String? phone;
  String? password;
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
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? firebaseToken;

  Data(
      {this.permissions,
      this.sId,
      this.name,
      this.uniqueID,
      this.emailAddress,
      this.phone,
      this.password,
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
      this.updatedAt,
      this.iV,
      this.firebaseToken});

  Data.fromJson(Map<String, dynamic> json) {
    permissions = json['permissions'] != null
        ? new Permissions.fromJson(json['permissions'])
        : null;
    sId = json['_id'];
    name = json['Name'];
    uniqueID = json['uniqueID'];
    emailAddress = json['emailAddress'];
    phone = json['phone'];
    password = json['password'];
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
    firebaseToken = json['firebaseToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.permissions != null) {
      data['permissions'] = this.permissions!.toJson();
    }
    data['_id'] = this.sId;
    data['Name'] = this.name;
    data['uniqueID'] = this.uniqueID;
    data['emailAddress'] = this.emailAddress;
    data['phone'] = this.phone;
    data['password'] = this.password;
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
    data['firebaseToken'] = this.firebaseToken;
    return data;
  }
}

class Permissions {
  bool? addSubscribers;
  bool? editSubscribers;
  bool? viewSubscribers;

  Permissions(
      {this.addSubscribers, this.editSubscribers, this.viewSubscribers});

  Permissions.fromJson(Map<String, dynamic> json) {
    addSubscribers = json['addSubscribers'];
    editSubscribers = json['editSubscribers'];
    viewSubscribers = json['viewSubscribers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addSubscribers'] = this.addSubscribers;
    data['editSubscribers'] = this.editSubscribers;
    data['viewSubscribers'] = this.viewSubscribers;
    return data;
  }
}
