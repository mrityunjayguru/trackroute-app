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

  bool loginPage = true;
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

  // TextEditingControllers for Vehicle Form
  final imeiController = TextEditingController();
  final simController = TextEditingController();
  final vehicleNumberController = TextEditingController();
  final dealerCodeController = TextEditingController();

  var selectedFile = Rxn<File>();
  String date ="";

  RxBool  showLoader = false.obs;
  RxBool obscureText = true.obs;
  RxBool obscureTextCnf = true.obs;
  RxBool check = false.obs;

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);

      // Check file size (in bytes), 1MB = 1 * 1024 * 1024 bytes
      final int fileSize = await file.length();
      if (fileSize > 1 * 1024 * 1024) { // 1MB in bytes
        Utils.getSnackbar("File Error", "File size exceeds 1MB. Please select a smaller file.");
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

  void selectDate(BuildContext context) async {
    try{
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 100000)),
        lastDate: DateTime.now(),
      );

      if (pickedDate != null) {
        // Formatting the picked date
        String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

        dateOfBirthController.value = formattedDate;
        date=DateFormat('yyyy-MM-dd').format(pickedDate);
      }
    }
    catch(e){
      debugPrint("$e");
    }

  }

  void clearAllData() {
    // Clear TextEditingControllers
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
    date="";
    obscureText = true.obs;
    obscureTextCnf = true.obs;
    check = false.obs;
  }

  Future<void> sendData() async {

      showLoader.value = true;
      try {
        var request = NewVehicleRequest();
        request.role="User";
        request.subscribeType="Individual";
        request.isAppCreated=true;
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
        request.imei = imeiController.text.trim();
        request.country = country.text.trim();
        request.pinCode = pincode.text.trim();
        request.password = passwd.text.trim();
        request.confirmPassword = cnfPasswd.text.trim();
        // request.deviceSimNumber = simController.text.trim();
        request.vehicleNo = vehicleNumberController.text.trim();
        request.dealerCode = dealerCodeController.text.trim();
        // request.deviceStatus = "Active";
        request.validateRequest();
        if(selectedFile.value==null){
          throw ValidationException(errorMsg: "Please upload a file for ID document");
        }

        var response = await NewVehicleRequest().submitForm(request,img: selectedFile.value);

        if (response.message == "Success") {
          Get.back();
          if(loginPage){
            Get.back();
          }
          Get.to(() => SubmissionPage(),
              transition: Transition.upToDown,
              duration: const Duration(milliseconds: 300));
        } else {
          Utils.getSnackbar("Error", "Something went wrong ${response.message}");
        }
      } on ValidationException catch(e){
        Utils.getSnackbar("Error", "${e.errorMsg}");
      }
      catch (e, s) {
        Utils.getSnackbar("Error", "Something went wrong $e");
      }

    showLoader.value = false;
  }

  Future<void> sendDataVehicle() async {

    showLoader.value = true;
    try {
      var request = NewVehicleByUserRequest();
      String? userId = await AppPreference.getStringFromSF(Constants.userId);
      // request.role="User";
      // request.subscribeType="Individual";
      request.isAppCreated=true;
      request.ownerID = userId;
      request.vehicleType = vehicleCategory.value?.id;
      request.imei = imeiController.text.trim();
      // request.deviceSimNumber = simController.text.trim();
      request.vehicleNo = vehicleNumberController.text.trim();
      request.dealerCode = dealerCodeController.text.trim();
      // request.deviceStatus = "Active";
      request.validateRequest();


      var response = await NewVehicleByUserRequest().submitForm(request);

      if (response.message == "Success") {
        Get.back();
        Get.to(() => SubmissionPage(),
            transition: Transition.upToDown,
            duration: const Duration(milliseconds: 300));
      } else {
        Utils.getSnackbar("Error", "Something went wrong ${response.message}");
      }
    } on ValidationException catch(e){
      Utils.getSnackbar("Error", "${e.errorMsg}");
    }
    catch (e, s) {
      Utils.getSnackbar("Error", "Something went wrong, Please enter valid imei");
    }

    showLoader.value = false;
  }


  void validatePage1(){
    var request = NewVehicleRequest();
    request.name = fullNameController.text.trim();
    request.emailAddress = emailController.text.trim();
    request.phone = mobileNumberController.text.trim();
    request.dob = dateOfBirthController.value.trim();
    request.address = permanentAddressController.text.trim();
    request.city = cityController.text.trim();
    request.state = state.value?.name;
    request.idno = idNumberController.text.trim();
    request.country = country.text.trim();
    request.pinCode = pincode.text.trim();
    request.password = passwd.text.trim();
    request.confirmPassword = cnfPasswd.text.trim();
    request.gender = gender.value?.name;
    request.idDocument = idType.value?.name;
    request.validateRequestPage1();
    if(selectedFile.value==null){
      throw ValidationException(errorMsg: "Please upload a file for ID document");
    }
  }

  Future<void> getVehicleTypeList() async {
    try {
      final response = await apiService.getVehicleType();

      if (response.status == 200) {

        vehicleTypeList.value = response.data ?? [];

        // log("vehicle type list ===>${jsonEncode(vehicleTypeList)}");
      } else if (response.status == 400) {
      }
    } catch (e) {

      // print("Error during OTP verification: $e");
    }

  }

  RxList<DataVehicleType> vehicleTypeList = <DataVehicleType>[].obs;
}
