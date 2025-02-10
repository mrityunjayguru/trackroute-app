import 'Topic.dart';

/// _id : "67134584568fb1703e8c4bd8"
/// title : "tittle 10"
/// description : "description 10"
/// topicId : "67134569568fb1703e8c4bd2"
/// priority : "05"
/// status : "Active"
/// isDeleted : false
/// createdAt : "2024-10-19T05:37:08.289Z"
/// updatedAt : "2024-10-19T05:37:08.290Z"
/// __v : 0
/// topic : {"_id":"67134569568fb1703e8c4bd2","title":"Topic !","priority":"1","status":"Active","isDeleted":false,"createdAt":"2024-10-19T05:36:41.440Z","updatedAt":"2024-10-19T05:36:41.445Z","__v":0}

class FaqListModel {
  FaqListModel({
      this.id, 
      this.title, 
      this.description, 
      this.topicId, 
      this.priority, 
      this.status, 
      this.isDeleted, 
      this.createdAt, 
      this.updatedAt, 
      this.v, 
      this.topic,});

  FaqListModel.fromJson(dynamic json) {
    id = json['_id'];
    title = json['title'];
    description = json['description'];
    topicId = json['topicId'];
    priority = json['priority'];
    status = json['status'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
    topic = json['topic'] != null ? Topic.fromJson(json['topic']) : null;
  }
  String? id;
  String? title;
  String? description;
  String? topicId;
  String? priority;
  String? status;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? v;
  Topic? topic;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['topicId'] = topicId;
    map['priority'] = priority;
    map['status'] = status;
    map['isDeleted'] = isDeleted;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    if (topic != null) {
      map['topic'] = topic?.toJson();
    }
    return map;
  }

}