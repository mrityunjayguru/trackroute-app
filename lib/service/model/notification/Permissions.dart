/// addSubscribers : false
/// editSubscribers : false
/// viewSubscribers : false

class Permissions {
  Permissions({
      this.addSubscribers, 
      this.editSubscribers, 
      this.viewSubscribers,});

  Permissions.fromJson(dynamic json) {
    addSubscribers = json['addSubscribers'];
    editSubscribers = json['editSubscribers'];
    viewSubscribers = json['viewSubscribers'];
  }
  bool? addSubscribers;
  bool? editSubscribers;
  bool? viewSubscribers;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['addSubscribers'] = addSubscribers;
    map['editSubscribers'] = editSubscribers;
    map['viewSubscribers'] = viewSubscribers;
    return map;
  }

}