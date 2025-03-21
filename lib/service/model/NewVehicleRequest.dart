import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:track_route_pro/constants/project_urls.dart';
import 'package:track_route_pro/service/model/CommonResponseModel.dart';
import '../../utils/app_prefrance.dart';
import '../../utils/common_import.dart';
import 'listing_base_response.dart';

/// imei : "862410128001124"
/// vehicleNo : "HR36X1234"
/// dealerCode : "679a490dd811edfa8db17301"
/// deviceSimNumber : "DIC005"
/// operator : "Jio"
/// vehicleType : "67986af4f35d6047d4ed08a3"
/// deviceStatus : "Active"
/// Name : "Vikash Pandey"
/// emailAddress : "nd.vikash1997@gmail.com"
/// phone : "3333333333"
/// password : "123456"
/// confirmPassword : "123456"
/// status : true
/// gender : "Male"
/// dob : "1998-03-11"
/// address : "Seawoods Navi Mumbai"
/// country : "India"
/// state : "Madhya Pradesh"
/// city : "Mohan Garden"
/// pinCode : "123433"
/// idDocument : "Aadhar Card"
/// idno : "122233"
/// document : "/C:/Users/DELL/Downloads/vikash"
/// isView : false
/// subscribeType : "User"
/// role : "User"
/// Document : "aIT9Yvq-w/Screenshot (57).png"
/// isAppCreated : true

class NewVehicleRequest {
  NewVehicleRequest({
    this.imei,
    this.vehicleNo,
    this.dealerCode,
    this.deviceSimNumber,
    // this.operator,
    this.vehicleType,
    // this.deviceStatus,
    this.name,
    this.emailAddress,
    this.phone,
    this.password,
    this.confirmPassword,
    // this.status,
    this.gender,
    this.dob,
    this.address,
    this.country,
    this.state,
    this.city,
    this.pinCode,
    this.idDocument,
    this.idno,
    // this.document,
    // this.isView,
    this.subscribeType,
    this.role,
    this.isAppCreated,});

  NewVehicleRequest.fromJson(dynamic json) {
    imei = json['imei'];
    vehicleNo = json['vehicleNo'];
    dealerCode = json['dealerCode'];
    deviceSimNumber = json['deviceSimNumber'];
    // operator = json['operator'];
    vehicleType = json['vehicleType'];
    // deviceStatus = json['deviceStatus'];
    name = json['Name'];
    emailAddress = json['emailAddress'];
    phone = json['phone'];
    password = json['password'];
    confirmPassword = json['confirmPassword'];
    // status = json['status'];
    gender = json['gender'];
    dob = json['dob'];
    address = json['address'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    pinCode = json['pinCode'];
    idDocument = json['idDocument'];
    idno = json['idno'];
    // document = json['document'];
    // isView = json['isView'];
    subscribeType = json['subscribeType'];
    role = json['role'];
    // document = json['Document'];
    isAppCreated = json['isAppCreated'];
  }

  String? imei;
  String? vehicleNo;
  String? dealerCode;
  String? deviceSimNumber;
  // String? operator;
  String? vehicleType;
  // String? deviceStatus;
  String? name;
  String? emailAddress;
  String? phone;
  String? password;
  String? confirmPassword;
  // bool? status;
  String? gender;
  String? dob;
  String? address;
  String? country;
  String? state;
  String? city;
  String? pinCode;

  String? idDocument;
  String? idno;

  // String? document;
  // bool? isView;
  String? subscribeType;
  String? role;

  // String? document;
  bool? isAppCreated;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['imei'] = imei;
    map['vehicleNo'] = vehicleNo;
    map['dealerCode'] = dealerCode;
    map['deviceSimNumber'] = deviceSimNumber;
    // map['operator'] = operator;
    map['vehicleType'] = vehicleType;
    // map['deviceStatus'] = deviceStatus;
    map['Name'] = name;
    map['emailAddress'] = emailAddress;
    map['phone'] = phone;
    map['password'] = password;
    map['confirmPassword'] = confirmPassword;
    // map['status'] = status;
    map['gender'] = gender;
    map['dob'] = dob;
    map['address'] = address;
    map['country'] = country;
    map['state'] = state;
    map['city'] = city;
    map['pinCode'] = pinCode;
    map['idDocument'] = idDocument;
    map['idno'] = idno;
    // map['document'] = document;
    // map['isView'] = isView;
    map['subscribeType'] = subscribeType;
    map['role'] = role;
    // map['Document'] = document;
    map['isAppCreated'] = isAppCreated;
    return map;
  }


  Future<CommonResponseModel> submitForm(NewVehicleRequest requestForm, {
    File? img,
  }) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse("${ProjectUrls.baseUrl}${ProjectUrls.newVehicle}"));

      // Add fields from requestForm to the request
      requestForm.toJson().forEach((key, value) {
        request.fields[key] = value.toString();
        debugPrint("Field: $key = $value");
      });

      if (img != null) {
        request.files.add(http.MultipartFile.fromBytes(
            'Document',
            await img.readAsBytes(),
            filename: img.path
                .split('/')
                .last));
      }

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
        debugPrint('Response Body (200): $responseBody');
        final jsonResponse = jsonDecode(responseBody);

        // Parse the response into BaseDataResponse
        return CommonResponseModel.fromJson(jsonResponse);
      } else {
        if (streamedResponse.statusCode == 400 || streamedResponse.statusCode == 409) {
          // Decode the response body
          final responseBody = await streamedResponse.stream.bytesToString();
          debugPrint('Response Body (Error ${streamedResponse.statusCode}): $responseBody');
          final jsonResponse = jsonDecode(responseBody);

          // Parse the response into BaseDataResponse
          return CommonResponseModel.fromJson(jsonResponse);
        } else {
          throw Exception(
              'Failed to submit form: ${streamedResponse.statusCode} ${streamedResponse.reasonPhrase}'
          );
        }
      }

    } catch (e, s) {
      debugPrint("$e");
      throw Exception('Failed to submit form');
    }
  }
}
extension FormRequestValidator on NewVehicleRequest {
  void validateRequest() {
    if (name == null || name!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter name");
    }
    if (emailAddress == null || emailAddress!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter email address");
    }
    if (!GetUtils.isEmail(emailAddress ?? "") ) {
      throw ValidationException(errorMsg: "Please enter a valid email address");
    }
    if (phone == null || phone!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter phone number");
    }
    if (phone?.length !=10) {
      throw ValidationException(errorMsg: "Please enter a 10 digit phone number");
    }
    if (gender == null || gender!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter gender");
    }
    if (dob == null || dob!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter date of birth");
    }
    if (dob == null || dob!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter date of birth");
    }
    if (password == null || password!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter password");
    }
    if (confirmPassword == null || confirmPassword!.isEmpty) {
      throw ValidationException(errorMsg: "Please confirm your password");
    }
    if (password != confirmPassword) {
      throw ValidationException(errorMsg: "Passwords do not match");
    }

    if (address == null || address!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter address");
    }
    if (city == null || city!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter city");
    }
    if (state == null || state!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter state");
    }
    if (country == null || country!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter country");
    }


    if (pinCode == null || pinCode!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter pin code");
    }
    if (pinCode?.length!=6) {
      throw ValidationException(errorMsg: "Please enter a 6 digit pin code");
    }
    if (idno == null || idno!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter ID number");
    }
    if (idDocument == null || idDocument!.isEmpty) {
      throw ValidationException(errorMsg: "Please select ID Type");
    }
    if (imei == null || imei!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter IMEI number");
    }
    if (vehicleNo == null || vehicleNo!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter vehicle number");
    }

  /*  if (deviceSimNumber == null || deviceSimNumber!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter device SIM number");
    }*/

    if (vehicleType == null || vehicleType!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter vehicle type");
    }
  }

  void validateRequestPage1() {
    if (name == null || name!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter name");
    }
    if (emailAddress == null || emailAddress!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter email address");
    }
    if (phone == null || phone!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter phone number");
    }
    if (password == null || password!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter password");
    }
    if (confirmPassword == null || confirmPassword!.isEmpty) {
      throw ValidationException(errorMsg: "Please confirm your password");
    }
    if (password != confirmPassword) {
      throw ValidationException(errorMsg: "Passwords do not match");
    }
    if (dob == null || dob!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter date of birth");
    }
    if (address == null || address!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter address");
    }
    if (country == null || country!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter country");
    }
    if (state == null || state!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter state");
    }
    if (city == null || city!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter city");
    }
    if (pinCode == null || pinCode!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter pin code");
    }
    if (idno == null || idno!.isEmpty) {
      throw ValidationException(errorMsg: "Please enter ID number");
    }
    if (idDocument == null || idDocument!.isEmpty) {
      throw ValidationException(errorMsg: "Please select ID Type");
    }
  }
}

class ValidationException implements Exception {
  ValidationException({required this.errorMsg});

  final String errorMsg;
}