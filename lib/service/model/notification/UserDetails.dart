import 'Permissions.dart';

/// _id : "67148ccb5700bd41154a323d"
/// Name : "Urvashi patel "
/// uniqueID : "Test1111"
/// emailAddress : "urvashi@gmail.com"
/// phone : "8888888888"
/// password : "U2FsdGVkX1/FqUKBOODOfSl49M/LKbXlG/Eh1WseAQw="
/// dob : "2016-10-05T18:30:00.000Z"
/// gender : "female"
/// address : "dsadas"
/// country : "United States"
/// state : "dsad"
/// city : "dsad"
/// pinCode : "sda"
/// companyId : "CompanyPan00aaa"
/// firebaseToken : "null"
/// permissions : {"addSubscribers":false,"editSubscribers":false,"viewSubscribers":false}
/// profile : "20172940001145131_splash-fashion-sales-33-to-60-off-ad-hyderabad-chronicle-16-06-2017.jpg"
/// profileId : "20172940001145131_splash-fashion-sales-33-to-60-off-ad-hyderabad-chronicle-16-06-2017.jpg"
/// otp : null
/// role : "User"
/// subscribeType : "Individual"
/// token : "U2FsdGVkX19gDxXhHr4qe6NOsbw2KMTuhMQ9J+kCbla0RbWlxTvlqcBiTBKENBOjVYbIct7gQ5HUEjemh6i+ssjnDk59S+YP3uxk06zJ+EuW7kZu/FZ7sofjpnI7NVuMwdZ7NbW623X/dxMy5y3obc6TFQxLvWcz1ai9w3Oe1zdFxvW7dbov9uDyd3CwUbDvdQvt7recRrvXzZergTIdUwCcQAl/b9My3mP+UXcEgpY="
/// status : true
/// createdAt : "2024-10-20T04:53:31.615Z"
/// updatedAt : "2024-10-20T04:53:31.615Z"
/// __v : 0

class UserDetails {
  UserDetails({
      this.id, 
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
      this.firebaseToken, 
      this.permissions, 
      this.profile, 
      this.profileId, 
      this.otp, 
      this.role, 
      this.subscribeType, 
      this.token, 
      this.status, 
      this.createdAt, 
      this.updatedAt, 
      this.v,});

  UserDetails.fromJson(dynamic json) {
    id = json['_id'];
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
    firebaseToken = json['firebaseToken'];
    permissions = json['permissions'] != null ? Permissions.fromJson(json['permissions']) : null;
    profile = json['profile'];
    profileId = json['profileId'];
    otp = json['otp'];
    role = json['role'];
    subscribeType = json['subscribeType'];
    token = json['token'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }
  String? id;
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
  String? firebaseToken;
  Permissions? permissions;
  String? profile;
  String? profileId;
  dynamic otp;
  String? role;
  String? subscribeType;
  String? token;
  bool? status;
  String? createdAt;
  String? updatedAt;
  int? v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['Name'] = name;
    map['uniqueID'] = uniqueID;
    map['emailAddress'] = emailAddress;
    map['phone'] = phone;
    map['password'] = password;
    map['dob'] = dob;
    map['gender'] = gender;
    map['address'] = address;
    map['country'] = country;
    map['state'] = state;
    map['city'] = city;
    map['pinCode'] = pinCode;
    map['companyId'] = companyId;
    map['firebaseToken'] = firebaseToken;
    if (permissions != null) {
      map['permissions'] = permissions?.toJson();
    }
    map['profile'] = profile;
    map['profileId'] = profileId;
    map['otp'] = otp;
    map['role'] = role;
    map['subscribeType'] = subscribeType;
    map['token'] = token;
    map['status'] = status;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }

}