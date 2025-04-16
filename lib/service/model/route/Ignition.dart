/// status : true
/// alarm : "null"

class Ignition {
  Ignition({
      this.status, 
      this.alarm,});

  Ignition.fromJson(dynamic json) {
    status = json['status'];
    alarm = json['alarm'];
  }
  bool? status;
  String? alarm;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['alarm'] = alarm;
    return map;
  }

}