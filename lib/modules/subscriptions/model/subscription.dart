class SubscriptionModel {
  final String name;
  final int price;
  final String? type;
  final List<String> features;
  final String wireType;
  final String? wireQuantity;
  final String image;
  final int quantityIndex;
  int selectedQuantity;
  SubscriptionPlan? plan;
  final bool hasAntiTheft;
  int selectedAntiTheftQuantity;
  SubscriptionModel({
    required this.name,
    required this.price,
    required this.wireType,
    required this.image,
    required this.features,
    required this.quantityIndex,
    this.wireQuantity,
    this.type,
    this.selectedQuantity = 1,
    this.plan,
    this.hasAntiTheft = false,
    this.selectedAntiTheftQuantity = 0,
  });

  SubscriptionModel copyWith({
    String? name,
    int? price,
    String? wireType,
    String? image,
    List<String>? features,
    int? quantityIndex,
    String? wireQuantity,
    String? type,
    int? selectedQuantity,
    SubscriptionPlan? plan,
    bool? hasAntiTheft,
    int? selectedAntiTheftQuantity,
  }) {
    return SubscriptionModel(
      name: name ?? this.name,
      price: price ?? this.price,
      wireType: wireType ?? this.wireType,
      image: image ?? this.image,
      features: features ?? this.features,
      quantityIndex: quantityIndex ?? this.quantityIndex,
      wireQuantity: wireQuantity ?? this.wireQuantity,
      type: type ?? this.type,
      selectedQuantity: selectedQuantity ?? this.selectedQuantity,
      plan: plan ?? this.plan,
      selectedAntiTheftQuantity:
          selectedAntiTheftQuantity ?? this.selectedAntiTheftQuantity,
      hasAntiTheft: hasAntiTheft ?? this.hasAntiTheft,
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
