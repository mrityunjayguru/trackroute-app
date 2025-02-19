/// _id : ""
/// firebaseToken : "${fcmToken}"
/// isLogout : true

class FirebaseUpdateRequest {
  FirebaseUpdateRequest({
      this.id, 
      this.firebaseToken, 
      this.isLogout,});

  FirebaseUpdateRequest.fromJson(dynamic json) {
    id = json['_id'];
    firebaseToken = json['firebaseToken'];
    isLogout = json['isLogout'];
  }
  String? id;
  String? firebaseToken;
  bool? isLogout;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['firebaseToken'] = firebaseToken;
    map['isLogout'] = isLogout;
    return map;
  }

}