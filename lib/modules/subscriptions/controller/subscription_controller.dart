import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:track_route_pro/modules/subscriptions/model/subscription.dart';

class SubscriptionController extends GetxController {
  RxList<int> quantities = <int>[].obs;
  RxList<int> antiTheftQuantities = <int>[].obs;
  List<TextEditingController> quantityControllers = [];
  List<TextEditingController> antiTheftQuantityControllers = [];
  RxList<bool> expandedStates = <bool>[].obs;
  RxList<SubscriptionModel> subscriptions = <SubscriptionModel>[].obs;

  RxMap<int, int> selectedPlanIndexes = <int, int>{}.obs;

  RxString selectedRadioValue = ''.obs;

  final List<SubscriptionPlan> availablePlans = [
    SubscriptionPlan(
        name: 'Add 2nd Year',
        price: 1499,
        discount: 0,
        bestValue: false,
        year: 1),
    SubscriptionPlan(
        name: '3 Year Plan',
        price: 3699,
        discount: 20,
        bestValue: true,
        year: 3),
    SubscriptionPlan(
        name: '5 Year Plan',
        price: 6999,
        discount: 40,
        bestValue: false,
        year: 5),
  ];

  @override
  void onInit() {
    super.onInit();
    initializeControllers(2);
    subscriptions.assignAll(_initialData());
    expandedStates.value = List.generate(4, (_) => false);
  }

  void initializeControllers(int count) {
    quantities.value = List.filled(count, 1);
    quantityControllers = List.generate(count, (index) {
      return TextEditingController(text: '1');
    });
    antiTheftQuantities.value = List.filled(count, 0);
    antiTheftQuantityControllers = List.generate(count, (index) {
      return TextEditingController(text: '0');
    });
  }

  void setSelectedRadioValue(String value) {
    selectedRadioValue.value = value;
  }

  //this is for accordians.
  void toggleExpanded(int index) {
    if (index >= 0 && index < expandedStates.length) {
      expandedStates[index] = !expandedStates[index];
    }
  }

  void expandAll() {
    expandedStates.value = List.generate(expandedStates.length, (_) => true);
  }

  void collapseAll() {
    expandedStates.value = List.generate(expandedStates.length, (_) => false);
  }


  //this is for internal plans selection.
  void selectPlan(int cardIndex, int planIndex) {
    selectedPlanIndexes[cardIndex] = planIndex;
    subscriptions[cardIndex].plan = availablePlans[planIndex];
    final updated = subscriptions[cardIndex].copyWith(
      plan: availablePlans[planIndex],
    );
    subscriptions[cardIndex] = updated;
  }

  int getSelectedPlanIndex(int cardIndex) =>
      selectedPlanIndexes[cardIndex] ?? -1;

  //this is for main plan quantities.
  void increment(int index) {
    quantities[index]++;
    quantityControllers[index].text = quantities[index].toString();
    subscriptions[index].selectedQuantity = quantities[index];
  }

  void decrement(int index) {
    if (quantities[index] > 0) {
      quantities[index]--;
      quantityControllers[index].text = quantities[index].toString();
      subscriptions[index].selectedQuantity = quantities[index];

      if (quantities[index] == 0) {
        antiTheftQuantities[index] = 0;
        antiTheftQuantityControllers[index].text = '0';

        selectedPlanIndexes[index] = -1; 
        subscriptions[index].plan = null;
        subscriptions[index] = subscriptions[index].copyWith(
          selectedAntiTheftQuantity: 0,
          plan: null,
        );
      }
    }
  }

  //this is for anti-theft quantities.
  void incrementAntiTheft(int index) {
    antiTheftQuantities[index]++;
    antiTheftQuantityControllers[index].text =
        antiTheftQuantities[index].toString();

    final updated = subscriptions[index].copyWith(
      selectedAntiTheftQuantity: antiTheftQuantities[index],
    );
    subscriptions[index] = updated;
  }

  void decrementAntiTheft(int index) {
    if (antiTheftQuantities[index] > 0) {
      antiTheftQuantities[index]--;
      antiTheftQuantityControllers[index].text =
          antiTheftQuantities[index].toString();

      final updated = subscriptions[index].copyWith(
        selectedAntiTheftQuantity: antiTheftQuantities[index],
      );
      subscriptions[index] = updated;
    }
  }

  //this is where u can add API call.
  List<SubscriptionModel> _initialData() {
    return [
      SubscriptionModel(
        name: "Sentinel",
        price: 3499,
        wireType: "Wired GPS Device",
        image: "assets/images/png/sentinel.png",
        features: [
          "Direct Power Fee",
          "Tamper Resistance",
          "Lower Maintenance"
        ],
        quantityIndex: 0,
        wireQuantity: "(4 Wires)",
        hasAntiTheft: true,
        selectedAntiTheftQuantity: 0,
        plan: availablePlans[0],
      ),
      SubscriptionModel(
          name: "MagTrack",
          price: 5499,
          wireType: "Wireless GPS Device",
          image: "assets/images/png/magtrack.png",
          features: [
            "Direct Power Fee",
            "Tamper Resistance",
            "Lower Maintenance"
          ],
          quantityIndex: 1,
          type: "Secure",
          hasAntiTheft: false,
          selectedAntiTheftQuantity: 0,
          plan: availablePlans[0])
    ];
  }

  final List<Map<String, String>> featuresList = [
    {
      'title': 'Live GPS Tracking & Route History',
      'description':
          'Track real-time movement with precision and review detailed route history for enhanced security and accountability.',
      'asset': 'assets/images/svg/sheild.svg',
    },
    {
      'title': 'Multi-Vehicle Monitoring & & Security',
      'description':
          'Easily monitor multiple users or devices and receive instant alerts when predefined boundaries are crossed.',
      'asset': 'assets/images/svg/vehicle.svg',
    },
    {
      'title': 'Driving Insights & Smart Alerts',
      'description':
          'Track speed, stops, and idle time while receiving real-time alerts for unusual driving behaviour.',
      'asset': 'assets/images/svg/wheel.svg',
    },
    {
      'title': 'Quick Support & Customer Care',
      'description':
          'Get prompt help through in-app messaging, email, or call—our team is here to resolve issues and answer queries quickly.',
      'asset': 'assets/images/svg/support.svg',
    }
  ];
}
