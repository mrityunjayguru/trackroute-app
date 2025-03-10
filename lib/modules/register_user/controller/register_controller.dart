import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:track_route_pro/service/api_service/api_service.dart';
import 'package:track_route_pro/utils/common_import.dart';
import 'package:track_route_pro/utils/search_drop_down.dart';

import '../../../utils/utils.dart';

class RegisterController extends GetxController {
  ApiService apiservice = ApiService.create();

  bool loginPage = true;
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final permanentAddressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final idNumberController = TextEditingController();
  var gender = Rx<SearchDropDownModel?>(null); // Observable
  var vehicleCategory = Rx<SearchDropDownModel?>(null); // Observable

  var selectedID = ''.obs;

  // TextEditingControllers for Vehicle Form
  final imeiController = TextEditingController();
  final simController = TextEditingController();
  final vehicleNumberController = TextEditingController();
  final dealerCodeController = TextEditingController();

  var selectedFile = Rxn<File>();

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


  List<SearchDropDownModel> genderList = [
    SearchDropDownModel(name: "Male"),
    SearchDropDownModel(name: "Female"),
  ];

  void selectDate(
      context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 100000)),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      // Formatting the picked date
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

      controller.text = formattedDate;
    }
  }

  void clearAllData() {
    // Clear TextEditingControllers
    fullNameController.clear();
    emailController.clear();
    mobileNumberController.clear();
    dateOfBirthController.clear();
    permanentAddressController.clear();
    cityController.clear();
    stateController.clear();
    idNumberController.clear();
    imeiController.clear();
    simController.clear();
    vehicleNumberController.clear();
    dealerCodeController.clear();

    // Reset Observables
    gender.value = null;
    vehicleCategory.value = null;
    selectedID.value = '';
    selectedFile.value = null;
  }


}
