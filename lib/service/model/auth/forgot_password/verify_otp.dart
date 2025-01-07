class VeryfyOTP {
  String? message;
  int? status;

  VeryfyOTP({this.message, this.status});

  VeryfyOTP.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}
