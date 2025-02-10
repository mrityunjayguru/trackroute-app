class SettingAddResponse {
  List<Data>? data;
  String? message;
  int? status;

  SettingAddResponse({this.data, this.message, this.status});

  SettingAddResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  String? sId;
  String? image;
  String? hyperLink;
  bool? isDeleted;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.sId,
      this.image,
      this.hyperLink,
      this.isDeleted,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    image = json['image'];
    hyperLink = json['hyperLink'];
    isDeleted = json['isDeleted'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['image'] = this.image;
    data['hyperLink'] = this.hyperLink;
    data['isDeleted'] = this.isDeleted;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
