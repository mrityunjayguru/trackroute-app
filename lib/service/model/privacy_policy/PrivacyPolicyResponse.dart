/// _id : "676aa1b6ef5031094f1bbfcf"
/// description : "This Privacy Policy explains how we collect, use, disclose, and protect your personal information when you use our services. By using TrackRoute Pro, you agree to the terms outlined in this policy."
/// isDeleted : false
/// createdAt : "2024-12-24T11:57:42.329Z"
/// updatedAt : "2024-12-24T11:57:42.329Z"
/// __v : 0

class PrivacyPolicyResponse {
  PrivacyPolicyResponse({
      this.id, 
      this.description, 
      this.isDeleted, 
      this.createdAt, 
      this.updatedAt, 
      this.v,});

  PrivacyPolicyResponse.fromJson(dynamic json) {
    id = json['_id'];
    description = json['description'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }
  String? id;
  String? description;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['description'] = description;
    map['isDeleted'] = isDeleted;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }

}