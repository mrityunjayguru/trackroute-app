class generateOtp {
  String? otp;
  String? message;
  int? status;

  generateOtp({this.otp, this.message, this.status});

  generateOtp.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp'] = this.otp;
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}
