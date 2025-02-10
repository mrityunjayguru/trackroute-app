/// id : "6787df3c08f5a267333d03a2"
/// time : "2025-01-15T16:26:59.325Z"
/// _id : "6787e1d32b1958c8a466751a"

class UpdatedBy {
  UpdatedBy({
      this.id, 
      this.time, 
      this.id1,});

  UpdatedBy.fromJson(dynamic json) {
    id1 = json['id'];
    time = json['time'];
    id = json['_id'];
  }
  String? id;
  String? time;
  String? id1;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id1;
    map['time'] = time;
    map['_id'] = id;
    return map;
  }

}