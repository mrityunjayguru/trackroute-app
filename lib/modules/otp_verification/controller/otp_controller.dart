import 'dart:async';

import 'package:track_route_pro/constants/constant.dart';
import 'package:track_route_pro/modules/create_new_pass/view/create_new_password_view.dart';
import 'package:track_route_pro/service/api_service/api_service.dart';
import 'package:track_route_pro/utils/app_prefrance.dart';
import 'package:track_route_pro/utils/common_import.dart';
import 'package:track_route_pro/utils/enums.dart';

import '../../../utils/utils.dart';

class OtpController extends GetxController {
  ApiService apiservice = ApiService.create();

  Rx<NetworkStatus> networkStatus = Rx(NetworkStatus.IDLE);
  Rx<TextEditingController> otpController = TextEditingController().obs;
  final otpFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>().obs;
  RxBool isOtpError = false.obs;
  Rx<String?> otpErrorText = Rx<String?>(null);
  Timer? timer;
  RxInt start = 30.obs;
  RxBool isResendVisible = false.obs;
  RxString email = ''.obs;

  RxString otp = RxString('');

  @override
  void onInit() {
    super.onInit();
    loadUserEmail();
    // Start the timer for resending the OTP
    startTimer();
  }

  Future<void> loadUserEmail() async {
    String? forgotemail =
        await AppPreference.getStringFromSF(Constants.forgotemail);

    email.value = forgotemail ?? "";
  }

  Future<void> verifyotp({required bool fromLogin}) async {
    try {
      final body = {
        "role" : "User",
        "emailAddress": email.value,
        "otp": otpController.value.text,
      };
      networkStatus.value = NetworkStatus.LOADING;

      final response = await apiservice.verifyOTP(body);

      if (response.status == 200) {
        Get.back();
        Get.back();
        Get.to(()=> CreateNewPasswordView(fromLogin: fromLogin,), transition: Transition.upToDown, duration: const Duration(milliseconds: 300));
        networkStatus.value = NetworkStatus.SUCCESS;
      } else if (response.status == 400) {
        // Handle the case for invalid OTP
        isOtpError.value = true;
        otpErrorText.value = 'Enter a valid OTP';
        networkStatus.value = NetworkStatus.ERROR;

        // print('Invalid OTP: Status 400');
      }
    } catch (e) {
      Utils.getSnackbar("Error", "Something went wrong");
      networkStatus.value = NetworkStatus.ERROR;
      isOtpError.value = true;
      otpErrorText.value = 'Enter valid OTP';
      // print("Error during OTP verification: $e");
    }
  }

  void startTimer() {
    isResendVisible.value = false;
    start.value = 30;
    timer?.cancel();
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (start.value <= 1) {
          isResendVisible.value = true;
          timer.cancel();
        } else {
          start.value--;
        }
      },
    );
  }

  String? validateOtp({required String otp}) {
    final otpRegex = RegExp(r'^[0-9]{6}$');
    if (otp.isEmpty) {
      isOtpError.value = true;
      return otpErrorText.value = 'Please enter a 6 digit code';
    } else if (!otpRegex.hasMatch(otp)) {
      isOtpError.value = true;
      return otpErrorText.value = 'Please enter a valid 6 digit code';
    }
    isOtpError.value = false;
    return null;
  }

  @override
  void dispose() {
    otpController.value.dispose();
    otpFocusNode.dispose();
    timer?.cancel();
    super.dispose();
  }
}
