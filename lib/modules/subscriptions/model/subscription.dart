class SubscriptionModel {
  final String id;
  final String name;
  final int price;
  final List<String> features;
  final String wireType;
  final String? wireQuantity;
  final String image;
  int selectedQuantity;
  List<SubscriptionPlan>? plans;
  SubscriptionPlan? plan;
  final bool hasAntiTheft;
  int selectedAntiTheftQuantity;
  final bool isGovtRelated;
  final String? internalPlanId;
  bool? selectedAntiTheft;

  SubscriptionModel(
      {required this.id,
      required this.internalPlanId,
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
      this.selectedAntiTheft = false,
      this.plans});

  SubscriptionModel copyWith({
    String? id,
    String? name,
    int? price,
    List<String>? features,
    String? wireType,
    String? wireQuantity,
    String? image,
    int? selectedQuantity,
    List<SubscriptionPlan>? plans,
    SubscriptionPlan? plan,
    bool? hasAntiTheft,
    int? selectedAntiTheftQuantity,
    bool? isGovtRelated,
    String? internalPlanId,
    bool? selectedAntiTheft,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      features: features ?? this.features,
      wireType: wireType ?? this.wireType,
      wireQuantity: wireQuantity ?? this.wireQuantity,
      image: image ?? this.image,
      selectedQuantity: selectedQuantity ?? this.selectedQuantity,
      plans: plans ?? this.plans,
      plan: plan ?? this.plan,
      hasAntiTheft: hasAntiTheft ?? this.hasAntiTheft,
      selectedAntiTheftQuantity:
          selectedAntiTheftQuantity ?? this.selectedAntiTheftQuantity,
      isGovtRelated: isGovtRelated ?? this.isGovtRelated,
      internalPlanId: internalPlanId ?? this.internalPlanId,
      selectedAntiTheft: selectedAntiTheft ?? this.selectedAntiTheft,
    );
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
        selectedAntiTheftQuantity: 0,
        isGovtRelated: json['govtRelated'] ?? true,
        internalPlanId: json['Plan']['_id'],
        selectedAntiTheft: json['Plan']['antiTheft'] ?? false,
        plans: [
          SubscriptionPlan(
            name: 'Add 2nd Year',
            price: json['Plan']['secondYearCost'],
            discount: json['Plan']['secondYearDiscount'],
            bestValue:
                json['Plan']['bestValue'] == 'secondYearCost' ? true : false,
            year: 2,
          ),
          SubscriptionPlan(
            name: 'Add 3rd Year',
            price: json['Plan']['thirdYearCost'],
            discount: json['Plan']['thirdYearDiscount'],
            bestValue: json['Plan']['thirdYearBestValueBadge'],
            year: 3,
          ),
          SubscriptionPlan(
            name: '5th year',
            price: json['Plan']['fifthYearCost'],
            discount: json['Plan']['fifthYearDiscount'],
            bestValue: json['Plan']['fifthYearBestValueBadge'],
            year: 5,
          )
        ]);
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
