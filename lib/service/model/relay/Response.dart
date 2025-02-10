/// attributes : {}
/// description : "New…"
/// deviceId : 297211
/// id : 0
/// textChannel : false
/// type : "engineStop"

class Response {
  Response({
      this.attributes, 
      this.description, 
      this.deviceId, 
      this.id, 
      this.textChannel, 
      this.type,});

  Response.fromJson(dynamic json) {
    attributes = json['attributes'];
    description = json['description'];
    deviceId = json['deviceId'];
    id = json['id'];
    textChannel = json['textChannel'];
    type = json['type'];
  }
  dynamic attributes;
  String? description;
  int? deviceId;
  int? id;
  bool? textChannel;
  String? type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['attributes'] = attributes;
    map['description'] = description;
    map['deviceId'] = deviceId;
    map['id'] = id;
    map['textChannel'] = textChannel;
    map['type'] = type;
    return map;
  }

}