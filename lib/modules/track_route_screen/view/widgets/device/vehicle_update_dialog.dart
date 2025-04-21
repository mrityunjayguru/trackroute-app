/*
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../common/textfield/apptextfield.dart';
import '../../../../config/app_sizer.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_textstyle.dart';
import '../../../../service/model/presentation/vehicle_type/Data.dart';
import '../../../../utils/common_import.dart';
import '../../../../utils/search_drop_down.dart';
import '../../../../utils/style.dart';
import '../../../../utils/utils.dart';
import '../../controller/track_route_controller.dart';
import 'edit_text_field.dart';

class VehicleUpdateDialog extends StatelessWidget {
  VehicleUpdateDialog({super.key});

  final controller = Get.isRegistered<TrackRouteController>()
      ? Get.find<TrackRouteController>() // Find if already registered
      : Get.put(TrackRouteController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 5.h,
              decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        15,
                      ),
                      topRight: Radius.circular(
                        15,
                      ))
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'General Updates',
                      style: AppTextStyles(context).display16W600.copyWith(color: Colors.white),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: SvgPicture.asset(
                        'assets/images/svg/ic_close.svg',
                        color: AppColors.whiteOff,
                      )),
                ],
              ).paddingSymmetric(horizontal: 12, vertical: 6),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '',
                    style: AppTextStyles(context).display16W600,
                  ),
                ),
                InkWell(
                  onTap: () {
                    controller.vehicleRegistrationNumber.text = controller
                            .deviceDetail.value.data?[0].vehicleRegistrationNo ??
                        '';
                    controller.vehicleRegistrationNumber.text = controller
                        .deviceDetail.value.data?[0].vehicleNo ??
                        '';
                    controller.dateAdded.text = controller.formatDate(
                        controller.deviceDetail.value.data?[0].dateAdded);
                    controller.driverName.text =
                        controller.deviceDetail.value.data?[0].driverName ?? '';
                    controller.driverMobileNo.text =
                        controller.deviceDetail.value.data?[0].mobileNo ?? '';
                    controller.vehicleBrand.text =
                        controller.deviceDetail.value.data?[0].vehicleBrand ?? '';
                    controller.vehicleModel.text =
                        controller.deviceDetail.value.data?[0].vehicleModel ?? '';
                    controller.maxSpeedUpdate.text =
                        (controller.deviceDetail.value.data?[0].maxSpeed ?? '').toString();
                    controller.vehicleModel.text =
                        controller.deviceDetail.value.data?[0].vehicleModel ?? '';
                    controller.vehicleModel.text =
                        controller.deviceDetail.value.data?[0].vehicleModel ?? '';
                    controller.vehicleType.value = DataVehicleType(
                        id: controller
                                .deviceDetail.value.data?[0].vehicletype?.sId ??
                            "",
                        name: controller.deviceDetail.value.data?[0].vehicletype
                                ?.vehicleTypeName ??
                            "");
                    controller.insuranceExpiryDate.text = controller.formatDate(
                        controller.deviceDetail.value.data?[0].insuranceExpiryDate);
                    controller.pollutionExpiryDate.text = controller.formatDate(
                        controller.deviceDetail.value.data?[0].pollutionExpiryDate);
                    controller.fitnessExpiryDate.text = controller.formatDate(
                        controller.deviceDetail.value.data?[0].fitnessExpiryDate);
                    controller.nationalPermitExpiryDate.text =
                        controller.formatDate(controller
                            .deviceDetail.value.data?[0].nationalPermitExpiryDate);
                  },
                  child: Container(

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSizes.radius_50),
                      color: AppColors.black,
                    ),
                    child: Center(
                      child: Text(
                        'Reset',
                        style: AppTextStyles(context)
                            .display12W500
                            .copyWith(color: AppColors.selextedindexcolor),
                      ).paddingSymmetric(horizontal: 4.w, vertical: 1.1.h),
                    ),
                  ).paddingSymmetric(vertical: 1.4.h),
                ),
              ],
            ).paddingSymmetric(horizontal: 12),
            textFieldRow(
                title: 'Date Vehicle Added',
                con: controller.dateAdded,
                hintText: "Date Added",
                readOnly: true,
                onTap: () => _selectDate(context, controller.dateAdded),
                inputFormatters: [],
                context: context),
            textFieldRow(
                title: 'Vehicle Number',
                con: controller.vehicleName,
                hintText: "Enter Number",
                inputFormatters: [],
                context: context),
            textFieldRow(
                title: 'Vehicle Plate No.',
                con: controller.vehicleRegistrationNumber,
                hintText: "Enter Plate No",
                inputFormatters: [],
                context: context),
            textFieldRow(
                title: 'Driven By',
                con: controller.driverName,
                hintText: "Enter Driver Name",
                inputFormatters: [],
                context: context),
            textFieldRow(
                title: 'Calling Number',
                inputFormatters: [Utils.intFormatter()],
                con: controller.driverMobileNo,
                hintText: "Enter Calling Number",
                context: context),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 3,
                  child: SizedBox(
                    height: 2.h,
                    child: Text(
                      "Vehicle Make",
                      style: AppTextStyles(context).display13W400,
                    ),
                  ),
                ),
                SizedBox(
                  width: 4.w,
                ),
                Expanded(
                  flex: 4,
                  child: SizedBox(
                    width: 35.w,
                    child: SearchDropDown<DataVehicleType>(
                      dropDownFillColor: AppColors.backgroundColor,
                      hintStyle: text10Medium.copyWith(color: AppColors.grayLight),
                      width: context.width,
                      items: controller.vehicleTypeList.toList(),
                      selectedItem: controller.vehicleType.value,
                      borderOpacity: 0,
                      showBorder: false,
                      onChanged: (value) {
                        controller.vehicleType.value = value ?? DataVehicleType();
                      },
                      hint: "Vehicle Type",
                      showSearch: false,
                    ),
                  ),
                ),
              ],
            ).paddingSymmetric(vertical: 8, horizontal: 12),
            textFieldRow(
                title: 'Vehicle Model',
                inputFormatters: [],
                con: controller.vehicleModel,
                hintText: "Enter Vehicle Model",
                context: context),
            textFieldRow(
                title: 'Insurance Expiry',
                inputFormatters: [],
                con: controller.insuranceExpiryDate,
                hintText: "Insurance Expiry Date",
                readOnly: true,
                onTap: () => _selectDate(context, controller.insuranceExpiryDate),
                context: context),
            textFieldRow(
                title: 'Pollution Expiry',
                inputFormatters: [],
                con: controller.pollutionExpiryDate,
                hintText: "Pollution Expiry Date",
                readOnly: true,
                onTap: () => _selectDate(context, controller.pollutionExpiryDate),
                context: context),
            textFieldRow(
                title: 'Fitness Expiry',
                inputFormatters: [],
                con: controller.fitnessExpiryDate,
                hintText: "Fitness Expiry Date",
                readOnly: true,
                onTap: () => _selectDate(context, controller.fitnessExpiryDate),
                context: context),
            textFieldRow(
                title: 'National Permit Expiry',
                inputFormatters: [],
                con: controller.nationalPermitExpiryDate,
                hintText: "National Permit Expiry",
                readOnly: true,
                onTap: () =>
                    _selectDate(context, controller.nationalPermitExpiryDate),
                context: context),
            InkWell(
              onTap: () {
                // controller.geofence.value = !(controller.geofence.value);
                controller.editDevicesByDetails(editGeneral: true,context: context);
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.radius_50),
                  color: AppColors.black,
                ),
                child: Center(
                  child: Text(
                    'Submit',
                    style: AppTextStyles(context)
                        .display12W500
                        .copyWith(color: AppColors.selextedindexcolor),
                  ).paddingSymmetric(horizontal: 4.w, vertical: 1.1.h),
                ),
              ).paddingSymmetric(vertical: 1.4.h, horizontal: 25),
            ),
          ],
        ),
      ),
    );
  }

  Widget textFieldRow(
      {required String title,
      required TextEditingController con,
      required String hintText,
      required BuildContext context,
      List<TextInputFormatter>? inputFormatters,
      bool readOnly = false,
      VoidCallback? onTap}) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 2,
          style: AppTextStyles(context).display13W400,
        ),
        SizedBox(
          height: 0.6.h,
        ),
        EditTextField(
          controller: con,
          hintText: hintText,
          onTap: onTap,
          readOnly: readOnly,
          inputFormatters: inputFormatters,
        )
      ],
    ).paddingSymmetric(vertical: 8, horizontal: 12);
  }

  void _selectDate(context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      // Formatting the picked date
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

      controller.text = formattedDate; // Update the textfield
    }
  }
}
*/
