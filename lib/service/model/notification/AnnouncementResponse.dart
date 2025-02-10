import 'Users.dart';
import 'UserDetails.dart';

/// _id : "672a19b962178a4b73f02d2d"
/// title : "test"
/// message : "jhjh"
/// urgency : "#000000"
/// sendTo : "Selected"
/// users : [{"user":"67148ccb5700bd41154a323d","status":"Pending","_id":"672a19b962178a4b73f02d2e"}]
/// isDeleted : false
/// createdAt : "2024-11-05T13:12:25.929Z"
/// updatedAt : "2024-11-05T13:12:25.933Z"
/// __v : 0
/// userDetails : {"_id":"67148ccb5700bd41154a323d","Name":"Urvashi patel ","uniqueID":"Test1111","emailAddress":"urvashi@gmail.com","phone":"8888888888","password":"U2FsdGVkX1/FqUKBOODOfSl49M/LKbXlG/Eh1WseAQw=","dob":"2016-10-05T18:30:00.000Z","gender":"female","address":"dsadas","country":"United States","state":"dsad","city":"dsad","pinCode":"sda","companyId":"CompanyPan00aaa","firebaseToken":"null","permissions":{"addSubscribers":false,"editSubscribers":false,"viewSubscribers":false},"profile":"20172940001145131_splash-fashion-sales-33-to-60-off-ad-hyderabad-chronicle-16-06-2017.jpg","profileId":"20172940001145131_splash-fashion-sales-33-to-60-off-ad-hyderabad-chronicle-16-06-2017.jpg","otp":null,"role":"User","subscribeType":"Individual","token":"U2FsdGVkX19gDxXhHr4qe6NOsbw2KMTuhMQ9J+kCbla0RbWlxTvlqcBiTBKENBOjVYbIct7gQ5HUEjemh6i+ssjnDk59S+YP3uxk06zJ+EuW7kZu/FZ7sofjpnI7NVuMwdZ7NbW623X/dxMy5y3obc6TFQxLvWcz1ai9w3Oe1zdFxvW7dbov9uDyd3CwUbDvdQvt7recRrvXzZergTIdUwCcQAl/b9My3mP+UXcEgpY=","status":true,"createdAt":"2024-10-20T04:53:31.615Z","updatedAt":"2024-10-20T04:53:31.615Z","__v":0}

class AnnouncementResponse {
  AnnouncementResponse({
      this.id, 
      this.title, 
      this.message, 
      this.urgency, 
      this.sendTo, 
      this.users, 
      this.isDeleted, 
      this.createdAt, 
      this.updatedAt, 
      this.v, 
      this.userDetails,});

  AnnouncementResponse.fromJson(dynamic json) {
    id = json['_id'];
    title = json['title'];
    message = json['message'];
    urgency = json['urgency'];
    sendTo = json['sendTo'];
    if (json['users'] != null) {
      users = [];
      json['users'].forEach((v) {
        users?.add(Users.fromJson(v));
      });
    }
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
    userDetails = json['userDetails'] != null ? UserDetails.fromJson(json['userDetails']) : null;
  }
  String? id;
  String? title;
  String? message;
  String? urgency;
  String? sendTo;
  List<Users>? users;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? v;
  UserDetails? userDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['title'] = title;
    map['message'] = message;
    map['urgency'] = urgency;
    map['sendTo'] = sendTo;
    if (users != null) {
      map['users'] = users?.map((v) => v.toJson()).toList();
    }
    map['isDeleted'] = isDeleted;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    if (userDetails != null) {
      map['userDetails'] = userDetails?.toJson();
    }
    return map;
  }

}