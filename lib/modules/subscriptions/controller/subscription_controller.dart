import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:track_route_pro/modules/subscriptions/model/subscription.dart';
import 'package:track_route_pro/service/api_service/api_service.dart';

class SubscriptionController extends GetxController {
  RxList<int> quantities = <int>[].obs;
  RxList<int> antiTheftQuantities = <int>[].obs;
  List<TextEditingController> quantityControllers = [];
  List<TextEditingController> antiTheftQuantityControllers = [];
  RxList<bool> expandedStates = <bool>[].obs;
  RxList<SubscriptionModel> subscriptions = <SubscriptionModel>[].obs;

  RxMap<int, int> selectedPlanIndexes = <int, int>{}.obs;

  RxString selectedRadioValue = ''.obs;
  RxMap<int, List<SubscriptionPlan>> subscriptionPlans =
      <int, List<SubscriptionPlan>>{}.obs;
  final RxString appliedCoupon = ''.obs;
  final TextEditingController couponController = TextEditingController();

  @override
  void onInit() async {
    super.onInit();

    final data = await _initialData();
    subscriptions.assignAll(data);
    for (int i = 0; i < data.length; i++) {
      subscriptionPlans[i] = data[i].plans ?? [];
    }

    initializeControllers(
        data.length); // Initialize based on actual data length
    expandedStates.value = List.generate(featuresList.length, (_) => false);
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

  void selectPlan(int cardIndex, int planIndex) {
    final plans = subscriptionPlans[cardIndex] ?? [];
    final selectedPlan =
        (planIndex >= 0 && planIndex < plans.length) ? plans[planIndex] : null;

    selectedPlanIndexes[cardIndex] = planIndex;

    final updated = subscriptions[cardIndex].copyWith(
      plan: selectedPlan,
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
  Future<List<SubscriptionModel>> _initialData() async {
    final apiService = ApiService.create();
    final response = await apiService.getDevices({});
    return response.data!;
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
