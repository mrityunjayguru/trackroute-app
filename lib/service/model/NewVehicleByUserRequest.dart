import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../constants/project_urls.dart';
import '../../modules/login_screen/controller/login_controller.dart';
import '../../routes/app_pages.dart';
import '../../utils/app_prefrance.dart';
import '../../utils/common_import.dart';
import '../../utils/utils.dart';
import 'CommonResponseModel.dart';
import 'NewVehicleRequest.dart';

/// imei : ""
/// vehicleNo : ""
/// dealerCode : ""
/// vehicleType : ""
/// subscribeType : ""
/// role : ""
/// isAppCreated : true
/// ownerID : ""

class NewVehicleByUserRequest {
  NewVehicleByUserRequest({
    this.imei,
    this.vehicleNo,
    this.dealerCode,
    this.vehicleType,
    this.isAppCreated,
    this.ownerID,
    this.deviceSimNumber
  });

  NewVehicleByUserRequest.fromJson(dynamic json) {
    imei = json['imei'];
    vehicleNo = json['vehicleNo'];
    dealerCode = json['dealerCode'];
    vehicleType = json['vehicleType'];
    isAppCreated = json['isAppCreated'];
    ownerID = json['ownerID'];
    deviceSimNumber = json['deviceSimNumber'];
  }

  String? imei;
  String? vehicleNo;
  String? dealerCode;
  String? vehicleType;
  bool? isAppCreated;
  String? ownerID;
  String? deviceSimNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['imei'] = imei;
    map['deviceSimNumber'] = deviceSimNumber;
    map['vehicleNo'] = vehicleNo;
    map['dealerCode'] = dealerCode;
    map['vehicleType'] = vehicleType;
    map['isAppCreated'] = isAppCreated;
    map['ownerID'] = ownerID;
    return map;
  }

  Future<CommonResponseModel> submitForm(
      NewVehicleByUserRequest requestForm) async {
    try {
      final accessToken =
          await AppPreference.getStringFromSF(AppPreference.accessTokenKey);
      final response = await http.post(
        Uri.parse("${ProjectUrls.baseUrl}${ProjectUrls.newVehicleByUser}"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $accessToken'
        },
        body: jsonEncode(requestForm),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return CommonResponseModel.fromJson(jsonResponse);
      } else if (response.statusCode == 400 || response.statusCode == 409) {
        final jsonResponse = jsonDecode(response.body);
        return CommonResponseModel.fromJson(jsonResponse);
      } else if (response.statusCode == 401) {
        Utils.getSnackbar("Error", "Please login and retry");
        Get.offAllNamed(Routes.LOGIN);
        await Get.put(LoginController()).sendTokenData(isLogout: true);
        await AppPreference.removeLoginData();
        final jsonResponse = jsonDecode(response.body);
        return CommonResponseModel.fromJson(jsonResponse);
      } else {
        throw Exception(
            'Failed to submit form: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e, s) {
      // debugPrint("$e");
      throw Exception('Failed to submit form');
    }
  }
}

extension FormRequestValidator on NewVehicleByUserRequest {
  void validateRequest() {
    if (imei == null || imei!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter IMEI number");
    }
    if (vehicleNo == null || vehicleNo!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter vehicle number");
    }
    if (vehicleType == null || vehicleType!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter vehicle type");
    }
  }
}
