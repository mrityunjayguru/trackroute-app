import 'Notification.dart';

/// notification : {"title":"Speed Alert: Door Open!","body":"Your vehicle is moving at 80 km/h while the door is open. Please slow down to avoid accidents or further damage."}
/// token : "eFMT1ZUfQsa6eKDRZ81rp3:APA91bGrrmtlGeAMqwLqw0syWPwuxj36xVpxWPl6Iy2fI8C2ZWx-f11R33koRoWK-5KHzRQsvs1tPgBDRtvWg-Vs_fO0vknHLQsqDkwvtgHPNf4JhCpMEhK2XUm6UHvc2HbIhOGeAVd4"

class Notificationalert {
  Notificationalert({
      this.notification, 
      });

  Notificationalert.fromJson(dynamic json) {
    notification = json['notification'] != null ? Notification.fromJson(json['notification']) : null;
    // token = json['token'];
  }
  Notification? notification;
  // List<String>? token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (notification != null) {
      map['notification'] = notification?.toJson();
    }
    // map['token'] = token;
    return map;
  }

}