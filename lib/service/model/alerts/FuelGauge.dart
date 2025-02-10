/// quantity : 50
/// alarm : null

class FuelGauge {
  FuelGauge({
      this.quantity, 
      this.alarm,});

  FuelGauge.fromJson(dynamic json) {
    quantity = json['quantity'];
    alarm = json['alarm'];
  }
  int? quantity;
  dynamic alarm;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['quantity'] = quantity;
    map['alarm'] = alarm;
    return map;
  }

}