class ResetPassword {
  String? message;
  int? status;

  ResetPassword({this.message, this.status});

  ResetPassword.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] ?? 'No message'; // Provide a default value if null
    status = json['status'] ?? 0; // Provide a default value if null
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}
