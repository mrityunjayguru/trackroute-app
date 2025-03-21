import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/register_user/controller/register_controller.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../../common/textfield/apptextfield.dart';
import '../../../config/app_sizer.dart';
import '../../../service/model/presentation/vehicle_type/Data.dart';
import '../../../utils/search_drop_down.dart';
import '../../../utils/utils.dart';
import '../../privacy_policy/view/privacy_policy_page.dart';
import '../../privacy_policy/view/terms_cond_page.dart';

class RegisterDevicePage extends StatelessWidget {
  final controller = Get.isRegistered<RegisterController>()
      ? Get.find<RegisterController>() // Find if already registered
      : Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteOff,
      body: Stack(
        children: [
          Container(
            height: 35.h,
            width: context.width,
            color: AppColors.black,
            padding: EdgeInsets.symmetric(horizontal: 65, vertical: 60),
            child: Align(
                    alignment: Alignment.topCenter,
                    child: SvgPicture.asset(Assets.images.svg.logo))
                .paddingOnly(top: 20),
          ),
          Container(
            decoration: BoxDecoration(
                color: AppColors.color_f6f8fc,
                borderRadius: BorderRadius.circular(AppSizes.radius_24)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: SingleChildScrollView(
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Register",
                          style: AppTextStyles(context).display24W500,
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: SvgPicture.asset(
                            'assets/images/svg/ic_arrow_left.svg',
                            colorFilter: ColorFilter.mode(
                                AppColors.black, BlendMode.srcIn),
                          ).paddingOnly(right: 12, left: 7.w),
                        )
                      ],
                    ).paddingOnly(bottom: 10),
                    Text(
                      "Create an account to continue!",
                      style: AppTextStyles(context)
                          .display12W500
                          .copyWith(color: AppColors.color_4B4749, height: 1.5),
                    ).paddingOnly(bottom: 10),
                    personalInfo(context),
                    address(context),
                    documentation(context),
                    addVehicle(context),
                    InkWell(
                      onTap: () async {
                        if (controller.check.value) {
                          controller.sendData();
                        }
                      },
                      child: Container(
                        height: 6.h,
                        child: Center(
                          child: Text(
                            "Add Vehicle",
                            style: AppTextStyles(context)
                                .display16W400
                                .copyWith(
                                    color: controller.check.value
                                        ? AppColors.selextedindexcolor
                                        : AppColors.grayLight),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppSizes.radius_10),
                          color: controller.check.value
                              ? AppColors.black
                              : AppColors.color_D9D9D9C6,
                        ),
                      ),
                    ).paddingOnly(bottom: 1.h)
                  ],
                ),
              ),
            ),
          ).paddingOnly(bottom: 17, left: 17, right: 17, top: 150),
          Obx(() {
            if (controller.showLoader.value)
              return Positioned.fill(
                  child: Container(
                alignment: Alignment.center,
                color: Colors.grey.withOpacity(0.3),
                child: LoadingAnimationWidget.threeArchedCircle(
                  color: AppColors.selextedindexcolor,
                  size: 50,
                ),
              ));
            return SizedBox.shrink();
          })
        ],
      ),
    );
  }

  Widget personalInfo(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Personal Info",
          style: AppTextStyles(context).display18W500,
        ),
        textfield(
            controller: controller.fullNameController,
            hint: "Full Name",
            errorText: controller.fullNameError),
        textfield(
            controller: controller.emailController,
            hint: "Email ID",
            errorText: controller.emailError),
        textfield(
            maxLength: 10,
            controller: controller.mobileNumberController,
            hint: "Mobile Number",
            errorText: controller.mobileNumberError,
            inputFormatter: [Utils.intFormatter()]),
        SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1,
                  color: controller.genderError.value.isNotEmpty
                      ? Colors.red
                      : Colors.transparent),
              borderRadius: BorderRadius.circular(16)),
          child: SearchDropDown<SearchDropDownModel>(
            dropDownFillColor: AppColors.white,
            containerColor: AppColors.white,
            showBorder: false,
            hintStyle: AppTextStyles(context)
                .display16W400
                .copyWith(color: AppColors.grayLight),
            height: 50,
            items: controller.genderList.toList(),
            selectedItem: controller.gender.value,
            onChanged: (value) {
              controller.gender.value = value;
              controller.genderError.value = "";
            },
            hint: "Gender",
            showSearch: false,
          ),
        ),
        if (controller.genderError.value.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            controller.genderError.value.tr,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles(context)
                .display14W400
                .copyWith(color: AppColors.dangerDark),
          ).paddingOnly(left: 5),
        ],
        SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            controller.selectDate(context);
          },
          child: Container(
            height: 50,
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(
                  width: 1,
                  color: controller.dateOfBirthError.value.isNotEmpty
                      ? Colors.red
                      : Colors.transparent),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: controller.dateOfBirthController.value.isEmpty
                  ? Text(
                      "Date Of Birth",
                      style: AppTextStyles(context)
                          .display16W400
                          .copyWith(color: AppColors.grayLight),
                    )
                  : Text(
                      controller.dateOfBirthController.value,
                      style: AppTextStyles(context).display16W400,
                    ),
            ),
          ),
        ),
        if (controller.dateOfBirthError.value.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            controller.dateOfBirthError.value.tr,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles(context)
                .display14W400
                .copyWith(color: AppColors.dangerDark),
          ).paddingOnly(left: 5),
        ],
        textfield(
          errorText: controller.passwdError,
          controller: controller.passwd,
          hint: "Password",
          obscureText: controller.obscureText.value,
          onSuffixTap: () {
            controller.obscureText.value = !controller.obscureText.value;
          },
          suffixIcon: !controller.obscureText.value
              ? 'assets/images/svg/eye_open_icon.svg'
              : 'assets/images/svg/eye_close_icon.svg',
        ),
        textfield(
          errorText: controller.cnfPasswdError,
          controller: controller.cnfPasswd,
          hint: "Confirm Password",
          obscureText: controller.obscureTextCnf.value,
          onSuffixTap: () {
            controller.obscureTextCnf.value = !controller.obscureTextCnf.value;
          },
          suffixIcon: !controller.obscureTextCnf.value
              ? 'assets/images/svg/eye_open_icon.svg'
              : 'assets/images/svg/eye_close_icon.svg',
        ),
        SizedBox(height: 2.h),
      ],
    );
  }

  Widget address(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Address",
          style: AppTextStyles(context).display18W500,
        ),
        textfield(
            errorText: controller.permanentAddressError,
            controller: controller.permanentAddressController,
            hint: "Permanent Address"),
        textfield(
            controller: controller.cityController,
            hint: "City",
            errorText: controller.cityError),
        SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1,
                  color: controller.stateError.value.isNotEmpty
                      ? Colors.red
                      : Colors.transparent),
              borderRadius: BorderRadius.circular(16)),
          child: SearchDropDown<SearchDropDownModel>(
            dropDownFillColor: AppColors.white,
            containerColor: AppColors.white,
            showBorder: false,
            hintStyle: AppTextStyles(context)
                .display16W400
                .copyWith(color: AppColors.grayLight),
            height: 50,
            items: controller.indianStatesList.toList(),
            selectedItem: controller.state.value,
            onChanged: (value) {
              controller.state.value = value;
              controller.stateError.value = "";
            },
            hint: "State",
            showSearch: false,
          ),
        ),
        if (controller.stateError.value.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            controller.stateError.value.tr,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles(context)
                .display14W400
                .copyWith(color: AppColors.dangerDark),
          ).paddingOnly(left: 5),
        ],
        textfield(
            errorText: controller.countryError,
            controller: controller.country,
            hint: "Country",
            readOnly: true),
        textfield(
            errorText: controller.pincodeError,
            controller: controller.pincode,
            hint: "Pincode",
            maxLength: 6,
            inputFormatter: [Utils.intFormatter()]),
        SizedBox(height: 2.h),
      ],
    );
  }

  Widget documentation(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Upload Documentation",
          style: AppTextStyles(context).display18W500,
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1,
                  color: controller.idTypeError.value.isNotEmpty
                      ? Colors.red
                      : Colors.transparent),
              borderRadius: BorderRadius.circular(16)),
          child: SearchDropDown<SearchDropDownModel>(
            dropDownFillColor: AppColors.white,
            containerColor: AppColors.white,
            showBorder: false,
            hintStyle: AppTextStyles(context)
                .display16W400
                .copyWith(color: AppColors.grayLight),
            height: 50,
            items: controller.idTypeList.toList(),
            selectedItem: controller.idType.value,
            onChanged: (value) {
              controller.idType.value = value;
              controller.idTypeError.value = "";
            },
            hint: "Select ID",
            showSearch: false,
          ),
        ),
        if (controller.idTypeError.value.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            controller.idTypeError.value.tr,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles(context)
                .display14W400
                .copyWith(color: AppColors.dangerDark),
          ).paddingOnly(left: 5),
        ],
        textfield(
            errorText: controller.idNumberError,
            controller: controller.idNumberController,
            hint: "ID Number"),
        SizedBox(height: 2.h),
        Text(
          "Ensure you enter the Uploaded ID number correctly to avoid delays in activation.",
          style: AppTextStyles(context)
              .display11W400
              .copyWith(color: AppColors.grayLight),
        ),
        SizedBox(height: 0.7.h),
        InkWell(
          onTap: () async {
            await controller.pickFile();
          },
          child: Container(
            height: 6.h,
            child: Center(
              child: Text(
                "Upload Document",
                style: AppTextStyles(context)
                    .display16W400
                    .copyWith(color: AppColors.black),
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.radius_10),
              color: AppColors.selextedindexcolor,
            ),
          ),
        ),
        SizedBox(height: 0.7.h),
        if (controller.selectedFile.value?.path != null)
          Center(
            child: Text(
              '"${controller.selectedFile.value?.path.split('/').last}" - File Selected',
              textAlign: TextAlign.center,
              style: AppTextStyles(context)
                  .display16W400
                  .copyWith(color: AppColors.black),
            ),
          ),
        SizedBox(height: 0.7.h),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Upload the document as an image file. Make sure it is in ',
            style: AppTextStyles(context).display11W400.copyWith(
                  color: AppColors.grayLight,
                ),
            children: [
              TextSpan(
                text: 'JPG or PNG format ',
                style: AppTextStyles(context).display11W600.copyWith(
                      height: 1.2,
                      color: AppColors.grayLight,
                    ),
              ),
              TextSpan(
                text: 'and does ',
                style: AppTextStyles(context).display11W500.copyWith(
                      height: 1.2,
                      color: AppColors.grayLight,
                    ),
              ),
              TextSpan(
                text: 'not exceed 1MB ',
                style: AppTextStyles(context).display11W600.copyWith(
                      height: 1.2,
                      color: AppColors.grayLight,
                    ),
              ),
              TextSpan(
                text: 'in size.',
                style: AppTextStyles(context).display11W500.copyWith(
                      height: 2,
                      color: AppColors.grayLight,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget textfield(
      {bool readOnly = false,
      required TextEditingController controller,
      VoidCallback? onTap,
      VoidCallback? onSuffixTap,
      bool obscureText = false,
      List<TextInputFormatter>? inputFormatter,
      String? suffixIcon,
      int? maxLength,
      required RxString errorText,
      required String hint}) {
    return AppTextFormField(
      maxLength: maxLength,
      height: 50,
      readOnly: readOnly,
      onTap: onTap,
      onSuffixTap: onSuffixTap,
      suffixIcon: suffixIcon,
      color: AppColors.white,
      controller: controller,
      hintText: hint,
      inputFormatters: inputFormatter,
      obscureText: obscureText,
      errorText: errorText.value,
      onChanged: (val) {
        if (val.trim().isNotEmpty && errorText.value.isNotEmpty) {
          errorText.value = "";
        }
      },
      border: Border.all(
          width: 1,
          color: errorText.isNotEmpty ? Colors.red : Colors.transparent),
    );
  }

  Widget addVehicle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Add Vehicle",
          style: AppTextStyles(context).display18W500,
        ).paddingOnly(bottom: 10, top: 16),
        Text(
          "Register your First Vehicle!",
          style: AppTextStyles(context)
              .display12W500
              .copyWith(color: AppColors.color_4B4749, height: 1.5),
        ),
        textfield(
            controller: controller.imeiController,
            hint: "Device IMEI No.",
            inputFormatter: [Utils.intFormatter()],
            errorText: controller.imeiError),
        textfield(
            controller: controller.simController,
            hint: "SIM No.(Provided with device)",
            errorText: controller.simError,
            inputFormatter: [Utils.intFormatter()],
            maxLength: 13),
        textfield(
            controller: controller.vehicleNumberController,
            hint: "Vehicle Number",
            errorText: controller.vehicleNoError),
        SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1,
                  color: controller.vehicleTypeError.value.isNotEmpty
                      ? Colors.red
                      : Colors.transparent),
              borderRadius: BorderRadius.circular(16)),
          child: SearchDropDown<DataVehicleType>(
            dropDownFillColor: AppColors.white,
            containerColor: AppColors.white,
            showBorder: false,
            hintStyle: AppTextStyles(context)
                .display16W400
                .copyWith(color: AppColors.grayLight),
            height: 50,
            items: controller.vehicleTypeList.toList(),
            selectedItem: controller.vehicleCategory.value,
            onChanged: (value) {
              controller.vehicleCategory.value = value;
              controller.vehicleTypeError.value = "";
            },
            hint: "Vehicle Category",
            showSearch: false,
          ),
        ),
        if (controller.vehicleTypeError.value.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            controller.vehicleTypeError.value.tr,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles(context)
                .display14W400
                .copyWith(color: AppColors.dangerDark),
          ).paddingOnly(left: 5),
        ],
        textfield(
            controller: controller.dealerCodeController,
            hint: "Dealer Code(Optional)",
            errorText: "".obs),
        SizedBox(height: 2.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
                visualDensity: VisualDensity.compact,
                value: controller.check.value,
                activeColor: AppColors.selextedindexcolor,

                // fillColor: WidgetStatePropertyAll(Colors.white),
                side: BorderSide(color: AppColors.black),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(5), // Adjust radius as needed
                ),
                onChanged: (value) {
                  controller.check.value = value ?? false;
                }).paddingOnly(bottom: 10),
            Expanded(
              child: RichText(
                textAlign: TextAlign.start,
                maxLines: 3,
                text: TextSpan(
                  text:
                      'By submitting, I confirm that I have read, understood, and agree to the ',
                  style: AppTextStyles(context).display11W500.copyWith(
                        color: AppColors.grayLight,
                      ),
                  children: [
                    TextSpan(
                        text: 'Terms of Use ',
                        style: AppTextStyles(context).display11W500.copyWith(
                              height: 2,
                              color: AppColors.purpleColor,
                            ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(() => TermsConditionView(),
                                transition: Transition.upToDown,
                                duration: const Duration(milliseconds: 300));
                          }),
                    TextSpan(
                      text: 'and ',
                      style: AppTextStyles(context).display11W500.copyWith(
                            height: 2,
                            color: AppColors.grayLight,
                          ),
                    ),
                    TextSpan(
                        text: 'Privacy Policy.',
                        style: AppTextStyles(context).display11W500.copyWith(
                              height: 2,
                              color: AppColors.purpleColor,
                            ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(() => PrivacyPolicyView(),
                                transition: Transition.upToDown,
                                duration: const Duration(milliseconds: 300));
                          }),
                  ],
                ),
              ),
            ),
          ],
        ).paddingOnly(bottom: 8),
      ],
    );
  }
}
