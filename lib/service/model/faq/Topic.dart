/// _id : "67134569568fb1703e8c4bd2"
/// title : "Topic !"
/// priority : "1"
/// status : "Active"
/// isDeleted : false
/// createdAt : "2024-10-19T05:36:41.440Z"
/// updatedAt : "2024-10-19T05:36:41.445Z"
/// __v : 0

class Topic {
  Topic({
      this.id, 
      this.title, 
      this.priority, 
      this.status, 
      this.isDeleted, 
      this.createdAt, 
      this.updatedAt, 
      this.v,});

  Topic.fromJson(dynamic json) {
    id = json['_id'];
    title = json['title'];
    priority = json['priority'];
    status = json['status'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }
  String? id;
  String? title;
  String? priority;
  String? status;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['title'] = title;
    map['priority'] = priority;
    map['status'] = status;
    map['isDeleted'] = isDeleted;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }

}