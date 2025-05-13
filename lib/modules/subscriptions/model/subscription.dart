class SubscriptionModel {
  final String id;
  final String name;
  final int price;
  final List<String> features;
  final String wireType;
  final String? wireQuantity;
  final String image;
  int selectedQuantity;
  SubscriptionPlan? plan;
  final bool hasAntiTheft;
  int selectedAntiTheftQuantity;
  final bool isGovtRelated;

  SubscriptionModel({
    required this.id,
    required this.name,
    required this.price,
    required this.wireType,
    required this.image,
    required this.features,
    this.wireQuantity,
    this.selectedQuantity = 1,
    this.plan,
    this.isGovtRelated = true,
    this.hasAntiTheft = false,
    this.selectedAntiTheftQuantity = 0,
  });

  SubscriptionModel copyWith(
      {SubscriptionPlan? plan, int? selectedAntiTheftQuantity}) {
    return SubscriptionModel(
        id: id,
        name: name,
        price: price,
        wireType: wireType,
        image: image,
        features: features,
        wireQuantity: wireQuantity,
        selectedQuantity: selectedQuantity,
        plan: plan,
        hasAntiTheft: hasAntiTheft,
        selectedAntiTheftQuantity: selectedAntiTheftQuantity ?? 0,
        isGovtRelated: isGovtRelated);
  }

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['_id'],
      name: json['deviceName'],
      price: json['price'],
      wireType: json['deviceType'] == true
          ? 'Wired GPS Device'
          : 'Wireless GPS Device',
      image: json['deviceImage'],
      features: [json['usp1'], json['usp2'], json['usp3']],
      wireQuantity: json['deviceType'] == true ? '(4 Wires)' : null,
      selectedQuantity: json['selectedQuantity'] ?? 1,
      plan: null,
      hasAntiTheft: json['deviceType'] == true ? true : false,
      selectedAntiTheftQuantity:  0,
      isGovtRelated: json['govtRelated'] ?? true,
    );
  }
}

class SubscriptionPlan {
  final String name;
  final int price;
  final int discount;
  final bool bestValue;
  final int year;

  SubscriptionPlan({
    required this.name,
    required this.price,
    required this.discount,
    required this.bestValue,
    required this.year,
  });
}
