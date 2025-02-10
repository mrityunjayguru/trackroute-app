/// id : "6787dbdc7ccb4ee0862703f8"
/// _id : "6787df3c08f5a267333d03a3"
/// time : "2025-01-15T16:15:56.917Z"

class CreatedBy {
  CreatedBy({
      this.id, 
      this.id1,
      this.time,});

  CreatedBy.fromJson(dynamic json) {
    id1 = json['id'];
    id = json['_id'];
    time = json['time'];
  }
  String? id;
  String? id1;
  String? time;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id1;
    map['_id'] = id;
    map['time'] = time;
    return map;
  }

}