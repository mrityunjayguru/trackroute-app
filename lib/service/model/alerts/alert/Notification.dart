/// title : "Speed Alert: Door Open!"
/// body : "Your vehicle is moving at 80 km/h while the door is open. Please slow down to avoid accidents or further damage."

class Notification {
  Notification({
      this.title, 
      this.body,});

  Notification.fromJson(dynamic json) {
    title = json['title'];
    body = json['body'];
  }
  String? title;
  String? body;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['body'] = body;
    return map;
  }

}