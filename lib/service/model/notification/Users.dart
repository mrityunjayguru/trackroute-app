/// user : "67148ccb5700bd41154a323d"
/// status : "Pending"
/// _id : "672a19b962178a4b73f02d2e"

class Users {
  Users({
      this.user, 
      this.status, 
      this.id,});

  Users.fromJson(dynamic json) {
    user = json['user'];
    status = json['status'];
    id = json['_id'];
  }
  String? user;
  String? status;
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user'] = user;
    map['status'] = status;
    map['_id'] = id;
    return map;
  }

}