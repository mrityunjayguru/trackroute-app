import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:track_route_pro/service/api_service/api_service.dart';
import 'package:track_route_pro/service/model/NewVehicleByUserRequest.dart';
import 'package:track_route_pro/service/model/NewVehicleRequest.dart';
import 'package:track_route_pro/utils/common_import.dart';
import 'package:track_route_pro/utils/search_drop_down.dart';

import '../../../constants/constant.dart';
import '../../../service/model/presentation/vehicle_type/Data.dart';
import '../../../utils/app_prefrance.dart';
import '../../../utils/utils.dart';
import '../view/submission_page.dart';

class RegisterController extends GetxController {
  final ApiService apiService = ApiService.create();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final dateOfBirthController = RxString('');
  final permanentAddressController = TextEditingController();
  final cityController = TextEditingController();

  // final stateController = TextEditingController();
  final idNumberController = TextEditingController();
  final country = TextEditingController(text: "India");
  final pincode = TextEditingController();
  final passwd = TextEditingController();
  final cnfPasswd = TextEditingController();
  var gender = Rx<SearchDropDownModel?>(null); // Observable
  var state = Rx<SearchDropDownModel?>(null); // Observable
  var vehicleCategory = Rx<DataVehicleType?>(null); // Observable

  var idType = Rx<SearchDropDownModel?>(null);
  var deviceType = Rx<SearchDropDownModel?>(null);

  // TextEditingControllers for Vehicle Form
  final imeiController = TextEditingController();
  final simController = TextEditingController();
  final vehicleNumberController = TextEditingController();
  final dealerCodeController = TextEditingController();

  var selectedFile = Rxn<File>();
  String date = "";

  RxBool showLoader = false.obs;
  RxBool obscureText = true.obs;
  RxBool obscureTextCnf = true.obs;
  RxBool check = false.obs;
  bool loginPage = true;

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);

      // Check file size (in bytes), 1MB = 1 * 1024 * 1024 bytes
      final int fileSize = await file.length();
      if (fileSize > 1 * 1024 * 1024) {
        // 1MB in bytes
        Utils.getSnackbar("File Error",
            "File size exceeds 1MB. Please select a smaller file.");
        return;
      }

      // Save the selected file
      selectedFile.value = file;
    } else {
      Get.snackbar("File Selection", "No file selected.");
    }
  }

  List<SearchDropDownModel> indianStatesList = [
    SearchDropDownModel(name: "Andhra Pradesh"),
    SearchDropDownModel(name: "Arunachal Pradesh"),
    SearchDropDownModel(name: "Assam"),
    SearchDropDownModel(name: "Bihar"),
    SearchDropDownModel(name: "Chhattisgarh"),
    SearchDropDownModel(name: "Goa"),
    SearchDropDownModel(name: "Gujarat"),
    SearchDropDownModel(name: "Haryana"),
    SearchDropDownModel(name: "Himachal Pradesh"),
    SearchDropDownModel(name: "Jharkhand"),
    SearchDropDownModel(name: "Karnataka"),
    SearchDropDownModel(name: "Kerala"),
    SearchDropDownModel(name: "Madhya Pradesh"),
    SearchDropDownModel(name: "Maharashtra"),
    SearchDropDownModel(name: "Manipur"),
    SearchDropDownModel(name: "Meghalaya"),
    SearchDropDownModel(name: "Mizoram"),
    SearchDropDownModel(name: "Nagaland"),
    SearchDropDownModel(name: "Odisha"),
    SearchDropDownModel(name: "Punjab"),
    SearchDropDownModel(name: "Rajasthan"),
    SearchDropDownModel(name: "Sikkim"),
    SearchDropDownModel(name: "Tamil Nadu"),
    SearchDropDownModel(name: "Telangana"),
    SearchDropDownModel(name: "Tripura"),
    SearchDropDownModel(name: "Uttar Pradesh"),
    SearchDropDownModel(name: "Uttarakhand"),
    SearchDropDownModel(name: "West Bengal"),
    SearchDropDownModel(name: "Andaman and Nicobar Islands"),
    SearchDropDownModel(name: "Chandigarh"),
    SearchDropDownModel(name: "Lakshadweep"),
    SearchDropDownModel(name: "Delhi"),
    SearchDropDownModel(name: "Puducherry"),
    SearchDropDownModel(name: "Ladakh"),
    SearchDropDownModel(name: "Jammu and Kashmir"),
  ];

  List<SearchDropDownModel> genderList = [
    SearchDropDownModel(name: "Male"),
    SearchDropDownModel(name: "Female"),
    SearchDropDownModel(name: "Other"),
  ];

  List<SearchDropDownModel> idTypeList = [
    SearchDropDownModel(name: "Aadhar Card"),
    SearchDropDownModel(name: "PAN Card"),
    SearchDropDownModel(name: "Driving License"),
  ];

  List<SearchDropDownModel> deviceTypeList = [
    SearchDropDownModel(name: "Wired"),
    SearchDropDownModel(name: "Wireless"),
  ];

  @override
  void onInit() {
    vehicleTypeList.listen((value) {
      // This callback is triggered whenever vehicleTypeList changes
      // debugPrint("Vehicle Type List Updated: $value");
    });
  }

  void selectDate(BuildContext context) async {
    try {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 100000)),
        lastDate: DateTime.now(),
      );

      if (pickedDate != null) {

        DateTime eighteenYearsAgo =
            DateTime.now().subtract(Duration(days: 18 * 365));
        if (pickedDate.isBefore(eighteenYearsAgo) ||
            pickedDate.isAtSameMomentAs(eighteenYearsAgo)) {
          dateOfBirthError.value="";
          String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

          dateOfBirthController.value = formattedDate;
          date = DateFormat('yyyy-MM-dd').format(pickedDate);
        } else {
          dateOfBirthError.value="You need to be above 18 years of age to register";

        }
      }
      else{
        dateOfBirthError.value="";
      }
    } catch (e) {
      debugPrint("$e");
      dateOfBirthError.value="";
    }
  }

  void clearAllData() {
    clearValidationErrors();
    fullNameController.clear();
    emailController.clear();
    mobileNumberController.clear();
    dateOfBirthController.value = "";
    permanentAddressController.clear();
    cityController.clear();
    idNumberController.clear();
    imeiController.clear();
    simController.clear();
    vehicleNumberController.clear();
    dealerCodeController.clear();
    country.text = "India";
    pincode.clear();
    passwd.clear();
    cnfPasswd.clear();

    // Reset Observables
    gender.value = null;
    state.value = null;
    vehicleCategory.value = null;
    idType.value = null;
    selectedFile.value = null;
    deviceType.value = null;
    date = "";
    obscureText = true.obs;
    obscureTextCnf = true.obs;
    check = false.obs;
  }

  Future<void> sendData() async {
    showLoader.value = true;
    try {
      validateForm();
      var request = NewVehicleRequest();
      request.role = "User";
      request.subscribeType = "Individual";
      request.isAppCreated = true;
      request.name = fullNameController.text.trim();
      request.emailAddress = emailController.text.trim();
      request.phone = mobileNumberController.text.trim();
      request.dob = date;
      request.address = permanentAddressController.text.trim();
      request.city = cityController.text.trim();
      request.state = state.value?.name;
      request.idno = idNumberController.text.trim();
      request.gender = gender.value?.name;
      request.vehicleType = vehicleCategory.value?.id;
      request.idDocument = idType.value?.name;
      request.isWired = deviceType.value?.name == "Wired";
      request.imei = imeiController.text.trim();
      request.country = country.text.trim();
      request.pinCode = pincode.text.trim();
      request.password = passwd.text.trim();
      request.confirmPassword = cnfPasswd.text.trim();
      request.deviceSimNumber = simController.text.trim();
      request.vehicleNo = vehicleNumberController.text.trim();
      request.dealerCode = dealerCodeController.text.trim();
      // request.deviceStatus = "Active";
      request.validateRequest();
      if (selectedFile.value == null) {
        throw ValidationException(
            errorMsg: "Please upload a file for ID document");
      }

      var response = await NewVehicleRequest()
          .submitForm(request, img: selectedFile.value);

      if (response.message == "Success") {
        Get.back();
        Get.to(() => SubmissionPage(),
            transition: Transition.upToDown,
            duration: const Duration(milliseconds: 300));
      } else {
        if(response.message?.isNotEmpty ?? false){
          Utils.getSnackbar("${response.message}", "");
        }
        else{
          Utils.getSnackbar("Something went wrong", "Please contact the support");
        }

      }
    } on ValidationException catch (e) {
      Utils.getSnackbar("Error", "${e.errorMsg}");
    } catch (e, s) {
      Utils.getSnackbar("Something went wrong", "Please contact the support");
    }

    showLoader.value = false;
  }

  Future<void> sendDataVehicle() async {
    showLoader.value = true;
    try {
      validateVehicleForm();
      var request = NewVehicleByUserRequest();
      String? userId = await AppPreference.getStringFromSF(Constants.userId);
      // request.role="User";
      // request.subscribeType="Individual";
      request.isAppCreated = true;
      request.ownerID = userId;
      request.vehicleType = vehicleCategory.value?.id;
      request.imei = imeiController.text.trim();
      request.deviceSimNumber = simController.text.trim();
      request.vehicleNo = vehicleNumberController.text.trim();
      request.dealerCode = dealerCodeController.text.trim();
      // request.deviceStatus = "Active";
      request.validateRequest();

      var response = await NewVehicleByUserRequest().submitForm(request);
      // var response = await apiService.newVehicleByUser(request);

      if (response.message == "Success") {
        Get.back();
        Get.to(() => SubmissionPage(),
            transition: Transition.upToDown,
            duration: const Duration(milliseconds: 300));
      } else {
        if(response.message?.isNotEmpty ?? false){
          Utils.getSnackbar("${response.message}", "");
        }
        else{
          Utils.getSnackbar("Something went wrong", "Please contact the support");
        }
      }
    } on ValidationException catch (e) {
      Utils.getSnackbar("Error", "${e.errorMsg}");
    } catch (e, s) {
      Utils.getSnackbar("Something went wrong", "Please contact the support");
    }

    showLoader.value = false;
  }

  Future<void> getVehicleTypeList() async {
    try {
      final response = await apiService.getVehicleType();

      if (response.status == 200) {
        vehicleTypeList.value = response.data ?? [];

        log("vehicle type list ===>${jsonEncode(vehicleTypeList)}");
        debugPrint("vehicle list ${vehicleTypeList.value.length}");
      } else if (response.status == 400) {}
    } catch (e) {
      print("Error during vehicle list fetch: $e");
    }
  }

  RxList<DataVehicleType> vehicleTypeList = <DataVehicleType>[].obs;

  var fullNameError = ''.obs;
  var emailError = ''.obs;
  var mobileNumberError = ''.obs;
  var dateOfBirthError = ''.obs;
  var permanentAddressError = ''.obs;
  var stateError = ''.obs;
  var countryError = ''.obs;
  var cityError = ''.obs;
  var idNumberError = ''.obs;
  var pincodeError = ''.obs;
  var passwdError = ''.obs;
  var cnfPasswdError = ''.obs;
  var vehicleNoError = ''.obs;
  var imeiError = ''.obs;
  var genderError = ''.obs;
  var idTypeError = ''.obs;
  var deviceTypeError = ''.obs;
  var vehicleTypeError = ''.obs;
  var simError = ''.obs;

  void validateForm() {
    if (fullNameController.text.trim().isEmpty) {
      fullNameError.value = 'Full name is required';
    } else {
      fullNameError.value = '';
    }

    if (emailController.text.trim().isEmpty) {
      emailError.value = 'Email is required';
    } else {
      emailError.value = '';
    }
    if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = 'Enter a valid email id';
    } else {
      emailError.value = '';
    }

    if (mobileNumberController.text.trim().isEmpty) {
      mobileNumberError.value = 'Mobile number is required';
    } else {
      mobileNumberError.value = '';
    }
    if (mobileNumberController.text.trim().length != 10) {
      mobileNumberError.value = 'Mobile number should be 10 digits';
    } else {
      mobileNumberError.value = '';
    }
    if (gender.value == null) {
      genderError.value = 'Gender is required';
    } else {
      genderError.value = '';
    }
    if (dateOfBirthController.value.isEmpty) {
      dateOfBirthError.value = 'Date of birth is required';
    } else {
      dateOfBirthError.value = '';
    }
    if (passwd.text.trim().isEmpty) {
      passwdError.value = 'Password is required';
    } else {
      passwdError.value = '';
    }

    if (cnfPasswd.text.trim().isEmpty) {
      cnfPasswdError.value = 'Confirm Password is required';
    } else if (cnfPasswd.text.trim() != passwd.text.trim()) {
      cnfPasswdError.value = 'Passwords do not match';
    } else {
      cnfPasswdError.value = '';
    }

    if (permanentAddressController.text.trim().isEmpty) {
      permanentAddressError.value = 'Address is required';
    } else {
      permanentAddressError.value = '';
    }

    if (cityController.text.trim().isEmpty) {
      cityError.value = 'City is required';
    } else {
      cityError.value = '';
    }
    if (state.value == null) {
      stateError.value = 'State is required';
    } else {
      stateError.value = '';
    }
    if (country.text.trim().isEmpty) {
      countryError.value = 'City is required';
    } else {
      countryError.value = '';
    }
    if (pincode.text.trim().trim().isEmpty) {
      pincodeError.value = 'PinCode is required';
    } else {
      pincodeError.value = '';
    }
    if (pincode.text.trim().trim().isEmpty) {
      pincodeError.value = 'PinCode should be 6 digits';
    } else {
      pincodeError.value = '';
    }
    if (idType.value == null) {
      idTypeError.value = 'ID Type is required';
    } else {
      idTypeError.value = '';
    }

    if (idNumberController.text.trim().isEmpty) {
      idNumberError.value = 'ID Number is required';
    } else {
      idNumberError.value = '';
    }

    if (imeiController.text.trim().isEmpty) {
      imeiError.value = 'IMEI is required';
    } else {
      imeiError.value = '';
    }

    if (vehicleNumberController.text.trim().isEmpty) {
      vehicleNoError.value = 'Vehicle Number is required';
    } else {
      vehicleNoError.value = '';
    }
    if (vehicleCategory.value == null) {
      vehicleTypeError.value = 'Vehicle Category is required';
    } else {
      vehicleTypeError.value = '';
    }
    if (deviceType.value == null) {
      deviceTypeError.value = 'Device Type is required';
    } else {
      deviceTypeError.value = '';
    }

    if (simController.text.trim().isNotEmpty && simController.text.trim().length!=13) {
      simError.value = 'The sim number should be 13 digits';
    } else {
      simError.value = '';
    }
    if ([
      fullNameError.value,
      emailError.value,
      mobileNumberError.value,
      dateOfBirthError.value,
      passwdError.value,
      cnfPasswdError.value,
      permanentAddressError.value,
      cityError.value,
      countryError.value,
      pincodeError.value,
      idNumberError.value,
      imeiError.value,
      vehicleNoError.value,
      genderError.value,
      stateError.value,
      idTypeError.value,
      deviceTypeError.value,
      vehicleTypeError.value,
      simError.value
    ].any((error) => error.isNotEmpty)) {
      throw ValidationException(errorMsg: 'All fields in the form are required');
    }

  }

  void validateVehicleForm() {
    if (imeiController.text.trim().isEmpty) {
      imeiError.value = 'IMEI is required';
    } else {
      imeiError.value = '';
    }

    if (vehicleNumberController.text.trim().isEmpty) {
      vehicleNoError.value = 'Vehicle Number is required';
    } else {
      vehicleNoError.value = '';
    }
    if (vehicleCategory.value == null) {
      vehicleTypeError.value = 'Vehicle Category is required';
    } else {
      vehicleTypeError.value = '';
    }
    if (deviceType.value == null) {
      deviceTypeError.value = 'Device Type is required';
    } else {
      deviceTypeError.value = '';
    }
    if (simController.text.trim().isNotEmpty && simController.text.trim().length!=13) {
      simError.value = 'The sim number should be 13 digits';
    } else {
      simError.value = '';
    }
    if ([
      vehicleTypeError.value,
      imeiError.value,
      vehicleNoError.value,
      simError.value,
      deviceTypeError.value
    ].any((error) => error.isNotEmpty)) {
      throw ValidationException(errorMsg: 'All fields in the form are required');
    }

  }

  void clearValidationErrors() {
    fullNameError.value = '';
    emailError.value = '';
    mobileNumberError.value = '';
    dateOfBirthError.value = '';
    permanentAddressError.value = '';
    stateError.value = '';
    countryError.value = '';
    cityError.value = '';
    idNumberError.value = '';
    pincodeError.value = '';
    passwdError.value = '';
    cnfPasswdError.value = '';
    vehicleNoError.value = '';
    imeiError.value = '';
    genderError.value = '';
    idTypeError.value = '';
    deviceTypeError.value = '';
    vehicleTypeError.value = '';
    simError.value = '';
  }

}
