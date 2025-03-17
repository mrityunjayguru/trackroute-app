import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants/project_urls.dart';
import '../../utils/app_prefrance.dart';
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
      this.ownerID,});

  NewVehicleByUserRequest.fromJson(dynamic json) {
    imei = json['imei'];
    vehicleNo = json['vehicleNo'];
    dealerCode = json['dealerCode'];
    vehicleType = json['vehicleType'];
    isAppCreated = json['isAppCreated'];
    ownerID = json['ownerID'];
  }
  String? imei;
  String? vehicleNo;
  String? dealerCode;
  String? vehicleType;
  bool? isAppCreated;
  String? ownerID;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['imei'] = imei;
    map['vehicleNo'] = vehicleNo;
    map['dealerCode'] = dealerCode;
    map['vehicleType'] = vehicleType;
    map['isAppCreated'] = isAppCreated;
    map['ownerID'] = ownerID;
    return map;
  }

}

extension FormRequestValidator on NewVehicleByUserRequest {
  void validateRequest() {

    if (vehicleNo == null || vehicleNo!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter vehicle number");
    }
    if (imei == null || imei!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter IMEI number");
    }
    if (vehicleType == null || vehicleType!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter vehicle type");
    }
  }


  Future<CommonResponseModel> submitForm(NewVehicleByUserRequest requestForm) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse("${ProjectUrls.baseUrl}${ProjectUrls.newVehicle}"));

      // Add fields from requestForm to the request
      requestForm.toJson().forEach((key, value) {
        request.fields[key] = value.toString();
        // debugPrint("Field: $key = $value");
      });

      final accessToken =
      await AppPreference.getStringFromSF(AppPreference.accessTokenKey);
      // await AppPreference.getStringFromSF(AppPreference.accessTokenKey);

      if (accessToken != null) {
        request.headers['Authorization'] = 'Bearer $accessToken';
      }

      // Send the request and get the response
      http.StreamedResponse streamedResponse = await request.send();

      // Check if the response status is successful
      if (streamedResponse.statusCode == 200) {
        // Decode the response body
        final responseBody = await streamedResponse.stream.bytesToString();
        final jsonResponse = jsonDecode(responseBody);

        // Parse the response into BaseDataResponse
        return CommonResponseModel.fromJson(jsonResponse);
      } else {
        if (streamedResponse.statusCode == 400 || streamedResponse.statusCode == 409) {
          // Decode the response body
          final responseBody = await streamedResponse.stream.bytesToString();
          final jsonResponse = jsonDecode(responseBody);

          // Parse the response into BaseDataResponse
          return CommonResponseModel.fromJson(jsonResponse);
        }
        else{
          throw Exception(
              'Failed to submit form : ${streamedResponse
                  .statusCode} ${streamedResponse.reasonPhrase}');
        }

      }
    } catch (e, s) {
      // debugPrint("$e");
      throw Exception('Failed to submit form');
    }
  }
}