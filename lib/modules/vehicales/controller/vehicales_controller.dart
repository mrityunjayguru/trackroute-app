import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:track_route_pro/constants/constant.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_route_controller.dart';
import 'package:track_route_pro/modules/vehicales/model/filter_model.dart';
import 'package:track_route_pro/service/api_service/api_service.dart';
import 'package:track_route_pro/service/model/presentation/track_route/track_route_vehicle_list.dart';
import 'package:track_route_pro/utils/app_prefrance.dart';
import 'package:track_route_pro/utils/common_import.dart';
import 'package:track_route_pro/utils/enums.dart';

class VehicalesController extends GetxController {
  final ApiService apiService = ApiService.create();
  Rx<NetworkStatus> networkStatus = Rx(NetworkStatus.IDLE);
  RxString devicesOwnerID = RxString('');
  final trackRouteController = Get.isRegistered<TrackRouteController>()
      ? Get.find<TrackRouteController>() // Find if already registered
      : Get.put(TrackRouteController());
  Rx<TrackRouteVehicleList> vehicleList = Rx(TrackRouteVehicleList());
  RxList<FilterData> filterData = RxList([]);
  RxList<Data> allVehicles = <Data>[].obs;
  RxList<Data> ignitionOnList = <Data>[].obs;
  RxList<Data> ignitionOffList = <Data>[].obs;
  RxList<Data> activeVehiclesList = <Data>[].obs;
  RxList<Data> inactiveVehiclesList = <Data>[].obs;
  RxList<Data> offlineVehiclesList = <Data>[].obs;
  RxInt SelectedFilterIndex = RxInt(0);
  RxBool isFilterSelected = RxBool(false);
  TextEditingController searchController = TextEditingController();
  RxList<Data> filteredVehicleList = <Data>[].obs; // List for search results


  @override
  void onInit() {
    super.onInit();
    loadUser().then((_) {
      devicesByOwnerID();
    });
    searchController.addListener(() {
      updateFilteredList(); // Listen for search changes
    });
  }

/*  // Function to filter vehicles based on search query and selected filter index
  void filterVehicles(String query) {
    List<Data> allVehicles = vehicleList.value.data ?? [];

    List<Data> filtered = allVehicles.where((vehicle) {
      // Filter by the search query
      var matchesQuery =
          vehicle.vehicleNo?.toLowerCase().contains(query.toLowerCase());
      if(vehicle.vehicleNo?.isEmpty ?? true){
        matchesQuery = true;
      }
      bool matchesFilter = false;

      switch (SelectedFilterIndex.value) {
        case 2: // Active
          matchesFilter = vehicle.status == 'Active';
          break;
        case 0: // Ignition On
          matchesFilter = vehicle.trackingData?.ignition?.status == true;
          break;
        case 1: // Ignition Off
          matchesFilter = vehicle.trackingData?.ignition?.status == false;
          break;
        case 3: // Ignition Off
          matchesFilter = vehicle.status != "Active";
          break;
        default:
          matchesFilter = true; // Show all if no filter is selected
          break;
      }

      return (matchesQuery ?? false) && matchesFilter;
    }).toList();

    // Update the filtered vehicle list
    filteredVehicleList.value = filtered;
  }*/

  void updateFilteredList() {
    List<Data> allVehicles = vehicleList.value.data ?? [];

    // Apply search filtering
    List<Data> filteredBySearch = allVehicles.where((vehicle) {
      return vehicle.vehicleNo
              ?.toLowerCase()
              .contains(searchController.text.toLowerCase()) ??
          true;
    }).toList();
    List<Data> finalFilteredList = filteredBySearch.where((vehicle) {
      switch (SelectedFilterIndex.value) {
        case 2: // Active
          return vehicle.status?.toLowerCase() == 'active' &&
              (vehicle.subscriptionExp == null
                  ? vehicle.status?.toLowerCase() == 'active'
                  : (DateFormat('yyyy-MM-dd')
                              .parse(vehicle.subscriptionExp!)
                              .difference(DateTime.now())
                              .inDays +
                          1 >
                      0));
        case 0: // Ignition On
          return vehicle.trackingData?.ignition?.status == true;
        case 1: // Ignition Off
          return vehicle.trackingData?.ignition?.status == false;
        case 3: // inactive
          return vehicle.status?.toLowerCase() != "active" ||
              (vehicle.subscriptionExp == null
                  ? vehicle.status?.toLowerCase() != 'active'
                  : (DateFormat('yyyy-MM-dd')
                              .parse(vehicle.subscriptionExp!)
                              .difference(DateTime.now())
                              .inDays +
                          1 <=
                      0));
        case 4: // offline
          return vehicle.trackingData?.status?.toLowerCase() != "online";
        default:
          return true; // No specific filter applied
      }
    }).toList();
    filteredVehicleList.value = finalFilteredList;
  }

  // Function to filter vehicles with Ignition On
  List<Data> filterIgnitionOn(List<Data> vehicleList) {
    return vehicleList.where((vehicle) {
      return vehicle.trackingData?.ignition?.status == true; // Ignition is on
    }).toList();
  }

  // Function to filter vehicles with Ignition Off
  List<Data> filterIgnitionOff(List<Data> vehicleList) {
    return vehicleList.where((vehicle) {
      return vehicle.trackingData?.ignition?.status == false; // Ignition is off
    }).toList();
  }

  List<Data> filterOffline(List<Data> vehicleList) {
    return vehicleList.where((vehicle) {
      return vehicle.trackingData?.status?.toLowerCase() !=
          "online"; // Ignition is off
    }).toList();
  }

  // Function to filter Active Vehicles
  List<Data> filterActiveVehicles(List<Data> vehicleList) {
    return vehicleList.where((vehicle) {
      return vehicle.status?.toLowerCase() == 'active' &&
          (vehicle.subscriptionExp == null
              ? vehicle.status?.toLowerCase() == 'active'
              : (DateFormat('yyyy-MM-dd')
                          .parse(vehicle.subscriptionExp!)
                          .difference(DateTime.now())
                          .inDays +
                      1 >
                  0)); // Status is Active
    }).toList();
  }

  List<Data> filterInactiveVehicle(List<Data> vehicleList) {
    return vehicleList.where((vehicle) {
      return vehicle.status?.toLowerCase() != "active" ||
          (vehicle.subscriptionExp == null
              ? vehicle.status?.toLowerCase() != 'active'
              : (DateFormat('yyyy-MM-dd')
                          .parse(vehicle.subscriptionExp!)
                          .difference(DateTime.now())
                          .inDays +
                      1 <=
                  0));
    }).toList();
  }

  Future<void> loadUser() async {
    String? userId = await AppPreference.getStringFromSF(Constants.userId);
    devicesOwnerID.value = userId ?? '';
  }

  // API service to get devices by owner ID
  Future<void> devicesByOwnerID() async {
    try {
      final body = {"ownerId": "${devicesOwnerID.value}"};
      networkStatus.value = NetworkStatus.LOADING;

      final response = await apiService.devicesByOwnerID(body);

      if (response.status == 200) {
        networkStatus.value = NetworkStatus.SUCCESS;
        vehicleList.value = response;

        // After successfully fetching data, apply the filters
        final allVehiclesRes = vehicleList.value.data ?? [];

        allVehicles.value = allVehiclesRes;
        ignitionOnList.value = filterIgnitionOn(allVehiclesRes).obs;
        ignitionOffList.value = filterIgnitionOff(allVehiclesRes).obs;

        activeVehiclesList.value = filterActiveVehicles(allVehiclesRes).obs;
        inactiveVehiclesList.value = filterInactiveVehicle(allVehiclesRes).obs;
        offlineVehiclesList.value = filterOffline(allVehiclesRes).obs;

        // Initialize filter data after API call and filtering
        filterData.value = [
          FilterData(
            image: Assets.images.svg.icFlashGreen,
            count: ignitionOnList.length,
            title: 'Ignition On',
          ),
          FilterData(
            image: Assets.images.svg.icFlashRed,
            count: ignitionOffList.length,
            title: 'Ignition Off',
          ),
          FilterData(
            image: Assets.images.svg.icCheck,
            count: activeVehiclesList.length,
            title: 'Active',
          ),
          FilterData(
              image: "assets/images/svg/inactive_icon.svg",
              count: inactiveVehiclesList.length,
              title: 'Inactive'),
          FilterData(
              image: "assets/images/svg/offline_icon.svg",
              count: offlineVehiclesList.length,
              title: 'Offline'),
          FilterData(
              image: "assets/images/svg/all_icon.svg",
              count: allVehicles.length,
              title: 'All'),
        ];
        searchController.clear();
        SelectedFilterIndex.value = -1;
        updateFilteredList();
      } else if (response.status == 400) {
        networkStatus.value = NetworkStatus.ERROR;
      }
    } catch (e) {
      networkStatus.value = NetworkStatus.ERROR;
      // print("Error during fetching vehicles: $e");
    }
  }
}
