import 'package:track_route_pro/constants/constant.dart';
import 'package:track_route_pro/modules/otp_verification/view/otp_view.dart';
import 'package:track_route_pro/service/api_service/api_service.dart';
import 'package:track_route_pro/utils/app_prefrance.dart';
import 'package:track_route_pro/utils/common_import.dart';
import 'package:track_route_pro/utils/enums.dart';

import '../../../utils/utils.dart';

class ForgotPassController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ApiService apiservice = ApiService.create();

  TextEditingController emailController = TextEditingController();

  Rx<NetworkStatus> networkStatus = Rx(NetworkStatus.IDLE);
  RxBool obscureText = RxBool(true);
  bool isChangeRememberMe = false;
  RxString otp = RxString('');
  RxString errorEmail = ''.obs;

  void validateEmail(AppLocalizations localizations) {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      errorEmail.value = localizations.pleaseEmail;
    } else if (!GetUtils.isEmail(email)) {
      errorEmail.value = localizations.pleaseValidEmail;
    } else {
      errorEmail.value = '';
    }
  }

  Future<void> forgotPassword({required bool fromLogin}) async {

    if(emailController.text.isEmpty){
      return;
    }
    Utils.getSnackbar("Requesting Otp...", "");
    var body = {'emailAddress': emailController.text, "role" : "User"};
    networkStatus.value = NetworkStatus.LOADING;

    try {
      // Log the request body for debugging
      print('Sending forgotPassword request with body: $body');

      final response = await apiservice.forgotPassword(body);

      // Log the response to see the full data returned by the API
      print('Forgot password response: $response');

      // Check if the response status is 200 (success) and otp is not null
      if (response.status == 200 && response.otp != null) {
        otp.value = response.otp ?? '';
        // print('OTP is: ${response.otp}');
        AppPreference.addStringToSF(
            Constants.forgotemail, emailController.text);
        AppPreference.addStringToSF(Constants.otp, response.otp ?? '');

        Get.to(
          OtpView(fromLogin: fromLogin,),
        );

        networkStatus.value = NetworkStatus.SUCCESS;
        Utils.getSnackbar("Success", "OTP sent successfully");
      } else {
        // Handle cases where the response status is not 200
        print('Error: Unexpected response status ${response.status}');
        networkStatus.value = NetworkStatus.ERROR;
      }
    } catch (error) {
      Utils.getSnackbar("Error", "Something went wrong");
      print('Error during forgotPassword request: $error');
      networkStatus.value = NetworkStatus.ERROR;
    }
  }

  // Future<void> forgotPassword() async {
  //   var body = {'emailAddress': emailController.text};
  //   networkStatus.value = NetworkStatus.LOADING;
  //   try {
  //     final response = await apiservice.forgotPassword(body);
  //     if (response.status == 200) {
  //       otp.value = response.otp ?? '';
  //       print('otp is::::${response.otp ?? ''}');
  //       Get.to(OtpView(), arguments: {
  //         // Constants.otp: response.otp ?? '',
  //         Constants.email: emailController.text
  //       });
  //       networkStatus.value = NetworkStatus.SUCCESS;
  //     }
  //   } catch (error) {
  //     print('object catch $error');

  //     networkStatus.value = NetworkStatus.ERROR;
  //   }
  // }
}
