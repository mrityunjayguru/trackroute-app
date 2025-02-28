import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/app_sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/modules/track_route_screen/controller/track_route_controller.dart';
import 'package:track_route_pro/modules/track_route_screen/view/widgets/relay_dialog.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../../../utils/utils.dart';
import '../../../bottom_screen/controller/bottom_bar_controller.dart';
import '../../../profile/controller/profile_controller.dart';
import 'edit_text_field.dart';

class VehicleSelected extends StatelessWidget {
  VehicleSelected({super.key});

  final controller = Get.isRegistered<TrackRouteController>()
      ? Get.find<TrackRouteController>() // Find if already registered
      : Get.put(TrackRouteController());

  final WidgetStateProperty<Icon?> thumbIcon =
      WidgetStateProperty.resolveWith<Icon?>(
    (Set<WidgetState> states) {
      return const Icon(Icons.close, color: Colors.transparent);
    },
  );

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor:
            controller.isedit.value ? AppColors.color_f6f8fc : Colors.white,
        appBar: PreferredSize(
          preferredSize: controller.isedit.value
              ? Size.fromHeight(6.h + 6.h + 4.8.h)
              : Size.fromHeight(6.h + 4.8.h),
          child: Column(children: [
            SizedBox(
              height: 4.8.h,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppSizes.radius_50),
                    topRight: Radius.circular(AppSizes.radius_50),
                    bottomRight: Radius.circular(AppSizes.radius_10),
                    bottomLeft: Radius.circular(AppSizes.radius_10)),
                color: AppColors.whiteOff,
              ),
              child: Column(
                children: [
                  if (controller.isedit.value)
                    Utils().topBar(
                        context: context,
                        rightIcon: 'assets/images/svg/ic_arrow_left.svg',
                        onTap: () {
                          controller.stackIndex.value = 1;
                          controller.isedit.value = false;
                          controller.editGeofence.value = false;
                          controller.editSpeed.value = false;
                          controller.resetGeneralInfo();
                        },
                        name: 'Edit General Info')
                  else
                    Utils().topBar(
                        context: context,
                        rightIcon: 'assets/images/svg/ic_arrow_left.svg',
                        onTap: () {
                          controller.stackIndex.value = 0;
                        },
                        name:
                            'Manage ${controller.deviceDetail.value.data?[0].vehicleNo != null ? "-" : ""}${controller.deviceDetail.value.data?[0].vehicleNo ?? ''}'),
                  if (controller.isedit.value)
                    Container(
                      height: 7.h,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(AppSizes.radius_10),
                              bottomRight:
                                  Radius.circular(AppSizes.radius_10))),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Device IMEI No.",
                                  style: AppTextStyles(context)
                                      .display12W400
                                      .copyWith(color: AppColors.grayLight),
                                ),
                                Text(
                                    "${controller.deviceDetail.value.data?[0].imei ?? ""}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles(context).display14W400)
                              ],
                            ),
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Date Added",
                                style: AppTextStyles(context)
                                    .display12W400
                                    .copyWith(color: AppColors.grayLight),
                              ),
                              Text(
                                  "${formatDate(controller.deviceDetail.value.data?[0].dateAdded) ?? '-'}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles(context).display14W400)
                            ],
                          ))
                        ],
                      ).paddingOnly(top: 12, bottom: 12, left: 10, right: 10),
                    )
                ],
              ),
            )
          ]).paddingOnly(top: 12, bottom: 0, left: 10, right: 10),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: controller.isedit.value
                ? AppColors.color_f6f8fc
                : AppColors.white,
            child: controller.isedit.value
                ? editGeneralInfo(context)
                    .paddingSymmetric(horizontal: 4.w * 0.9)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      geofenceWidget(context).paddingOnly(bottom: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: parkingWidget(context)),
                          SizedBox(
                            width: 4.w,
                          ),
                          Expanded(child: speedWidget(context)),
                        ],
                      ),
                      generalInfoWidget(context),
                      immobilizerWidget(context),
                      subExpiry(context),
                    ],
                  ).paddingSymmetric(horizontal: 4.w * 0.9),
          ),
        ),
      ),
    );
  }

  String formatDate(String? dateStr) {
    if (dateStr == null) return '-'; // Handle null case
    try {
      // Parse the date string to a DateTime object
      DateTime dateTime = DateTime.parse(dateStr);
      // Format the date as dd-mm-yyyy
      return DateFormat('dd-MM-yyyy').format(dateTime);
    } catch (e) {
      return '-'; // Handle parsing error
    }
  }

  String formatDateString(String? dateStr) {
    if (dateStr == null) return '-'; // Handle null case
    try {
      // Parse the date string to a DateTime object
      DateTime dateTime = DateTime.parse(dateStr);
      // Format the date as dd-mm-yyyy
      return DateFormat('dd MMM yyyy').format(dateTime);
    } catch (e) {
      return '-'; // Handle parsing error
    }
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

  Widget buildRow(BuildContext context, String labelText, String valueText) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: SizedBox(
                height: 2.h,
                child: Text(
                  labelText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles(context)
                      .display14W400
                      .copyWith(color: AppColors.color_444650),
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Text(
                valueText,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: AppTextStyles(context)
                    .display16W500
                    .copyWith(color: AppColors.color_444650),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        if (labelText != "National Permit Expiry")
          Divider(
            color: AppColors.color_e5e7e9,
          )
      ],
    );
  }

  Widget editGeneralInfo(BuildContext context) {
    return Column(
      children: [
        textFieldRow(
            title: 'Vehicle Number',
            con: controller.vehicleName,
            hintText: "Enter Number",
            inputFormatters: [],
            context: context),
        /*  textFieldRow(
            title: 'Vehicle Plate No.',
            con: controller.vehicleRegistrationNumber,
            hintText: "Enter Plate No",
            inputFormatters: [],
            context: context),*/
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
        /* Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 2.h,
              child: Text(
                "Vehicle Make",
                style: AppTextStyles(context).display13W400,
              ),
            ),
            SizedBox(
              child: SearchDropDown<DataVehicleType>(
                height: 45,
                dropDownFillColor: AppColors.white,
                hintStyle: AppTextStyles(context)
                    .display18W400
                    .copyWith(color: AppColors.color_969696),
                itemTextStyle: AppTextStyles(context).display18W500,
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
          ],
        ).paddingSymmetric(vertical: 8, horizontal: 12),
        textFieldRow(
            title: 'Vehicle Model',
            inputFormatters: [],
            con: controller.vehicleModel,
            hintText: "Enter Vehicle Model",
            context: context),*/
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
            controller.editDevicesByDetails(
                editGeneral: true, context: context);
            controller.isedit.value = false;
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.radius_10),
              color: AppColors.black,
            ),
            child: Center(
              child: Text(
                'Save',
                style: AppTextStyles(context)
                    .display14W500
                    .copyWith(color: AppColors.selextedindexcolor),
              ).paddingSymmetric(horizontal: 4.w, vertical: 1.4.h),
            ),
          ).paddingSymmetric(vertical: 1.4.h, horizontal: 10),
        ),
      ],
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
          style: AppTextStyles(context).display14W400,
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
          color: AppColors.white,
        )
      ],
    ).paddingSymmetric(vertical: 8, horizontal: 12);
  }

  Widget generalInfoWidget(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "General Info ",
              style: AppTextStyles(context)
                  .display16W400
                  .copyWith(color: AppColors.color_444650),
            ),
            InkWell(
              onTap: () {
                controller.isedit.value = true;
                controller.stackIndex.value = 1;
                controller.editGeofence.value = false;
                controller.editSpeed.value = false;
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6),
                width: 34.w,
                child: Center(
                  child: Text(
                    'Edit',
                    style: AppTextStyles(context)
                        .display18W500
                        .copyWith(color: Color(0xffD9E821)),
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.radius_50),
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ).paddingOnly(bottom: 15, top: 15),
        Container(
          decoration: BoxDecoration(
              color: AppColors.color_f6f8fc,
              borderRadius: BorderRadius.circular(AppSizes.radius_10),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 2),
                    blurRadius: 2,
                    spreadRadius: 0,
                    color: Color(0xff000000).withOpacity(0.15))
              ]),
          child: Column(
            children: [
              SizedBox(height: 10),
              buildRow(
                context,
                'Date Added',
                '${formatDate(controller.deviceDetail.value.data?[0].dateAdded) ?? '-'}',
              ),
              SizedBox(height: 10),
              buildRow(
                context,
                'Vehicle No.',
                '${controller.deviceDetail.value.data?[0].vehicleNo ?? '-'}',
              ),
              SizedBox(height: 10),
              buildRow(
                context,
                'Driven By',
                '${controller.deviceDetail.value.data?[0].driverName ?? '-'}',
              ),
              SizedBox(height: 10),
              buildRow(
                context,
                'Calling Number',
                '${controller.deviceDetail.value.data?[0].mobileNo ?? '-'}',
              ),
              /* SizedBox(height: 10),
            */ /*  buildRow(
                context,
                'Vehicle Type',
                '${controller.deviceDetail.value.data?[0].vehicletype?.vehicleTypeName ?? '-'}',
              ),*/ /*
              SizedBox(height: 10),
              buildRow(
                context,
                'Vehicle Brand',
                '${controller.deviceDetail.value.data?[0].vehicleBrand ?? '-'}',
              ),
              SizedBox(height: 10),
             */ /* buildRow(
                context,
                'Vehicle Model',
                '${controller.deviceDetail.value.data?[0].vehicleModel ?? '-'}',
              ),*/
              SizedBox(height: 10),
              buildRow(
                context,
                'Insurance Expiry',
                formatDate(
                    '${controller.deviceDetail.value.data?[0].insuranceExpiryDate ?? '-'}'),
              ),
              SizedBox(height: 10),
              buildRow(
                context,
                'Pollution Expiry',
                formatDate(
                    '${controller.deviceDetail.value.data?[0].pollutionExpiryDate ?? '-'}'),
              ),
              SizedBox(height: 10),
              buildRow(
                context,
                'Fitness Expiry',
                formatDate(
                    '${controller.deviceDetail.value.data?[0].fitnessExpiryDate ?? '-'}'),
              ),
              SizedBox(height: 10),
              buildRow(
                context,
                'National Permit Expiry',
                formatDate(
                    '${controller.deviceDetail.value.data?[0].nationalPermitExpiryDate ?? '-'}'),
              ),
            ],
          ).paddingSymmetric(horizontal: 3.w, vertical: 1.h),
        ),
        SizedBox(
          height: 4.h,
        ),
      ],
    );
  }

  Widget immobilizerWidget(BuildContext context) {
    bool active = true;
    if(controller.deviceDetail.value.data?[0].displayParameters?.relay == null){
      active = false;
    }
    return Column(
      children: [
        Container(
          height: 6.h,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 2),
                    blurRadius: 2,
                    spreadRadius: 0,
                    color: Color(0xff000000).withOpacity(0.15))
              ],
              borderRadius: BorderRadius.circular(AppSizes.radius_10),
              color: AppColors.color_EBE7E4),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              CircleAvatar(
                backgroundColor: active?  AppColors.color_e92e19 : AppColors.color_e5e7e9,
                child: SvgPicture.asset(
                  'assets/images/svg/engine_icon.svg',
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ).paddingSymmetric(horizontal: 6),
              ).paddingSymmetric(horizontal: 3.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Engine Lock',
                    style: AppTextStyles(context).display20W500.copyWith(color: active? AppColors.black : AppColors.color_9F9EA2),
                  ).paddingOnly(bottom: 3),
                  Text(
                    "Relay On/Off",
                    style: AppTextStyles(context)
                        .display10W500.copyWith(color: active? AppColors.color_e92e19 : AppColors.color_9F9EA2),
                  ).paddingOnly(bottom: 3),
                ],
              ),
              Spacer(),
              SizedBox(
                height: 25,
                child: Switch(
                  thumbIcon: thumbIcon,
                  trackOutlineWidth: WidgetStatePropertyAll(0),
                  trackOutlineColor: WidgetStatePropertyAll(Colors.transparent),
                  activeColor: active ? AppColors.color_e92e19 : AppColors.color_EBE7E4,
                  value: controller.relayStatus == "Stop",
                  inactiveThumbColor: active ? AppColors.selextedindexcolor : AppColors.color_EBE7E4,
                  inactiveTrackColor: active? AppColors.grayLight : AppColors.white,
                  activeTrackColor: active? AppColors.black : AppColors.white,

                  onChanged: (value) {
                    if(active){
                      if (controller.relayStatus == "Stop") {
                        Get.showOverlay(
                            asyncFunction: () => controller.startEngine(
                                controller.deviceDetail.value.data?[0].imei ??
                                    ""),
                            loadingWidget: LoadingAnimationWidget.dotsTriangle(
                              color: AppColors.white,
                              size: 50,
                            ));
                      } else {
                        Utils.openDialog(context: context, child: RelayDialog());
                      }
                    }
                  },
                ).paddingOnly(right: 10),
              ),
            ],
          ),
        ).paddingOnly(bottom: 10),
        Center(
          child: Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              children: [
                TextSpan(
                  text: 'WARNING:',
                  style: AppTextStyles(context).display14W600.copyWith(color: active ? AppColors.color_e92e19 : AppColors.grayLight)
                ),
                TextSpan(
                  text: 'When the vehicle ',
                  style: AppTextStyles(context).display14W400.copyWith(color: active? AppColors.black : AppColors.grayLight),
                ),
                TextSpan(
                  text: 'Engine Lock',
                  style: AppTextStyles(context).display14W500.copyWith(decoration: TextDecoration.underline,  color:active ? AppColors.color_e92e19 : AppColors.grayLight,
                    decorationColor: active ? AppColors.color_e92e19 : AppColors.grayLight,)
                ),
                TextSpan(
                  text: ' is active,\n',
                  style: AppTextStyles(context).display14W400.copyWith(color: active? AppColors.black : AppColors.grayLight),
                ),
                TextSpan(
                  text: 'it will ',
                  style: AppTextStyles(context).display14W400.copyWith(color: active? AppColors.black : AppColors.grayLight),
                ),
                TextSpan(
                  text: 'instantly shut down the car.',
                  style:  AppTextStyles(context).display14W400.copyWith(decoration: TextDecoration.underline,color: active? AppColors.black : AppColors.grayLight)
                ),
              ],
            ),
          ),
        ).paddingOnly(bottom: 20),
      ],
    );
  }

  Widget subExpiry(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radius_10),
          color: AppColors.backgroundColor),
      child: Row(
        children: [
          Expanded(
              child: Container(
            height: 6.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.radius_10),
                color: AppColors.color_f6f8fc),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => Text(
                    formatDateString(
                        '${controller.deviceDetail.value.data?[0].subscriptionExp ?? '-'}'),
                    style: AppTextStyles(context).display16W500,
                  ),
                ),
                Text(
                  'Subscription Expiry Date',
                  style: AppTextStyles(context)
                      .display12W500
                      .copyWith(color: AppColors.grayLight),
                ).paddingOnly(bottom: 3),
              ],
            ).paddingOnly(left: 3.w),
          )),
          Expanded(
              child: InkWell(
            onTap: () {
              controller.isFilterSelected.value = false;
              controller.isFilterSelectedindex.value = -1;
              controller.showAllVehicles();
              Get.put(BottomBarController()).updateIndexForRenewal(
                  controller.deviceDetail.value.data?[0].imei ?? "");
              controller.stackIndex.value=0;

            },
            child: Container(
              height: 6.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.radius_10),
                  color: AppColors.black),
              child: Center(
                child: Text(
                  'Renew Subscription',
                  style: AppTextStyles(context)
                      .display16W500
                      .copyWith(color: AppColors.selextedindexcolor),
                ),
              ),
            ),
          )),
        ],
      ),
    ).paddingOnly(bottom: 20, top: 10);
  }

  Widget geofenceWidget(BuildContext context) {
    bool active = true;
    if(controller.deviceDetail.value.data?[0].displayParameters?.geoFencing == null){
      active = false;
    }
    return InkWell(
      onTap: () {
        if(active){
          controller.editGeofence.value = true;
          controller.editSpeed.value = false;
        }

      },
      child: Container(
          decoration: BoxDecoration(
              color: AppColors.color_f6f8fc,
              borderRadius: BorderRadius.circular(AppSizes.radius_10),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 2),
                    blurRadius: 2,
                    spreadRadius: 0,
                    color: Color(0xff000000).withOpacity(0.15))
              ]),
          child: Column(
            children: [
              InkWell(
                onTap: (){
                  if(active){
                    controller.editGeofence.value = !controller.editGeofence.value;
                    controller.editSpeed.value = false;
                  }

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.color_e5e7e9,
                            child: SvgPicture.asset(
                              'assets/images/svg/geo_icon.svg',
                            ).paddingSymmetric(horizontal: 6),
                          ).paddingSymmetric(horizontal: 1.w),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Geofencing',
                                  style: AppTextStyles(context).display24W400,
                                ),
                                if(active)FutureBuilder(
                                  future: controller.getCurrAddress(
                                      latitude: controller.deviceDetail.value
                                          .data?[0].location?.latitude,
                                      longitude: controller.deviceDetail.value
                                          .data?[0].location?.longitude),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<dynamic> snapshot) {
                                    return Text(
                                      'Location : ${snapshot.data}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: AppTextStyles(context).display14W400,
                                    );
                                  },
                                ),
                              ],
                            ).paddingOnly(left: 1.w),
                          ),
                          SizedBox(width: 4.w),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                      child: Switch(
                        thumbIcon: thumbIcon,
                        trackOutlineWidth: WidgetStatePropertyAll(0),
                        trackOutlineColor:
                            WidgetStatePropertyAll(Colors.transparent),
                        activeColor: active?  AppColors.selextedindexcolor : AppColors.color_f6f8fc,
                        value: controller.geofence.value,
                        inactiveThumbColor: active?  AppColors.selextedindexcolor : AppColors.color_f6f8fc,
                        inactiveTrackColor: active? AppColors.grayLight : AppColors.white,
                        activeTrackColor: active? AppColors.black : AppColors.white,
                        onChanged: (value) {
                          if(active){
                            controller.editSpeed.value = false;
                            controller.geofence.value =
                            !(controller.geofence.value);
                            if (value) {
                              controller.editGeofence.value = true;
                            }
                            controller.editGeofenceToggle(context);
                          }

                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.editGeofence.value && active) ...[
                Divider(color: AppColors.color_e5e7e9),
                Text(
                  "Set Geofencing",
                  style: AppTextStyles(context)
                      .display14W400
                      .copyWith(color: AppColors.grayLight),
                ).paddingSymmetric(horizontal: 2.w),
                Row(
                  children: [
                    Expanded(
                        child: EditTextField(
                      controller: controller.latitudeUpdate,
                      hintText: "Latitude",
                      borderColor: AppColors.selextedindexcolor,
                      height: 42,
                      borderRadius: AppSizes.radius_10,
                      color: Colors.white,
                      hintStyle: AppTextStyles(context)
                          .display16W400
                          .copyWith(color: AppColors.color_969696),
                      textStyle: AppTextStyles(context).display16W500,
                      inputFormatters: [Utils.doubleFormatter()],
                    )),
                    SizedBox(width: 4.w),
                    Expanded(
                        child: EditTextField(
                      height: 42,
                      borderRadius: AppSizes.radius_10,
                      color: Colors.white,
                      hintStyle: AppTextStyles(context)
                          .display16W400
                          .copyWith(color: AppColors.color_969696),
                      textStyle: AppTextStyles(context).display16W500,
                      borderColor: AppColors.selextedindexcolor,
                      controller: controller.longitudeUpdate,
                      hintText: "Longitude",
                      inputFormatters: [Utils.doubleFormatter()],
                    )),
                  ],
                ).paddingAll(12),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Divider(color: AppColors.color_e5e7e9),
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: Text("Or"),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          controller.getCurrLocationForGeofence();
                        },
                        child: Container(
                          padding: EdgeInsets.all(11),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(AppSizes.radius_10)),
                          child: Text(
                            'Select My Location',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles(context).display14W400,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                        child: EditTextField(
                      height: 42,
                      borderRadius: AppSizes.radius_10,
                      color: Colors.white,
                      hintStyle: AppTextStyles(context)
                          .display16W400
                          .copyWith(color: AppColors.color_969696),
                      textStyle: AppTextStyles(context).display16W500,
                      controller: controller.areaUpdate,
                      hintText: "Enter Radius In Feet",
                      inputFormatters: [Utils.doubleFormatter()],
                    )),
                  ],
                ).paddingAll(12),
                InkWell(
                  onTap: () {
                    controller.geofence.value = true;
                    controller.editDevicesByDetails(
                        editGeofence: true, context: context);
                    controller.editGeofence.value = false;
                  },
                  child: Container(
                    height: 5.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSizes.radius_10),
                      color: AppColors.black,
                    ),
                    child: Center(
                      child: Text(
                        'Set',
                        style: AppTextStyles(context)
                            .display16W500
                            .copyWith(color: AppColors.selextedindexcolor),
                      ).paddingSymmetric(horizontal: 4.w, vertical: 1.h),
                    ),
                  ).paddingSymmetric(vertical: 1.4.h, horizontal: 10),
                ),
              ]
            ],
          ).paddingSymmetric(horizontal: 2.w, vertical: 1.h)),
    );
  }

  Widget parkingWidget(BuildContext context) {
    bool active = true;
    if(controller.deviceDetail.value.data?[0].displayParameters?.parking == null){
      active = false;
    }
    return InkWell(
      onTap: (){
        if(active){
          controller.editGeofence.value=false;
          controller.editSpeed.value=false;
        }

      },
      child: Container(
          decoration: BoxDecoration(
              color: AppColors.color_f6f8fc,
              borderRadius: BorderRadius.circular(AppSizes.radius_10),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 2),
                    blurRadius: 2,
                    spreadRadius: 0,
                    color: Color(0xff000000).withOpacity(0.15))
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.color_e5e7e9,
                    child: SvgPicture.asset(
                      'assets/images/svg/parking_icon.svg',
                    ).paddingSymmetric(horizontal: 6),
                  ).paddingSymmetric(horizontal: 1.w),
                  SizedBox(width: 4.w),
                  SizedBox(
                    height: 25,
                    child: Switch(
                      thumbIcon: thumbIcon,
                      trackOutlineWidth: WidgetStatePropertyAll(0),
                      trackOutlineColor:
                          WidgetStatePropertyAll(Colors.transparent),
                      activeColor: active?  AppColors.selextedindexcolor : AppColors.color_f6f8fc,
                      value: controller.parkingUpdate.value,
                      inactiveThumbColor: active?  AppColors.selextedindexcolor : AppColors.color_f6f8fc,
                      inactiveTrackColor: active? AppColors.grayLight : AppColors.white,
                      activeTrackColor: active? AppColors.black : AppColors.white,
                      onChanged: (value) {
                        if(active){
                          controller.parkingUpdate.value =
                          !(controller.parkingUpdate.value);
                          controller.editDevicesByDetails(context: context);
                        }
                      },
                    ),
                  ),
                ],
              ).paddingSymmetric(horizontal: 2.w, vertical: 1.h),
              Text(
                'Parking',
                style: AppTextStyles(context).display24W400,
              ).paddingSymmetric(horizontal: 2.w),
              Text(
                'Movement Alert',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: AppTextStyles(context).display14W400,
              ).paddingSymmetric(horizontal: 2.w),
              SizedBox(
                height: 1.h,
              )
            ],
          )),
    );
  }

  Widget speedWidget(BuildContext context) {
    return InkWell(
        onTap: () {
          controller.editSpeed.value = ! controller.editSpeed.value ;
          controller.editGeofence.value = false;
        },
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                    color: AppColors.color_f6f8fc,
                    borderRadius: BorderRadius.circular(AppSizes.radius_10),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 2),
                          blurRadius: 2,
                          spreadRadius: 0,
                          color: Color(0xff000000).withOpacity(0.15))
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.color_e5e7e9,
                          child: SvgPicture.asset(
                            'assets/images/svg/speed_icon.svg',
                          ).paddingSymmetric(horizontal: 6),
                        ).paddingSymmetric(horizontal: 1.w),
                        SizedBox(width: 4.w),
                        SizedBox(
                          height: 25,
                          child: Switch(
                            thumbIcon: thumbIcon,
                            trackOutlineWidth: WidgetStatePropertyAll(0),
                            trackOutlineColor:
                                WidgetStatePropertyAll(Colors.transparent),
                            activeColor: AppColors.selextedindexcolor,
                            value: controller.speedUpdate.value,
                            inactiveThumbColor: AppColors.selextedindexcolor,
                            inactiveTrackColor: AppColors.grayLight,
                            activeTrackColor: AppColors.black,
                            onChanged: (value) {
                              controller.editGeofence.value = false;
                              controller.speedUpdate.value =
                                  !(controller.speedUpdate.value);

                              if(value){
                                controller.editSpeed.value = true;
                              }
                              controller.editSpeedToggle(context);
                            },
                          ),
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 2.w, vertical: 1.h),
                    Row(
                      children: [
                        Text(
                          '${(controller.deviceDetail.value.data?[0].maxSpeed ?? 0).toStringAsFixed(0) ?? '-'} ',
                          style: AppTextStyles(context).display24W600,
                        ),
                        Text(
                          'KMPH',
                          style: AppTextStyles(context).display24W400,
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 2.w),
                    Text(
                      'Speed Alert',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: AppTextStyles(context).display14W400,
                    ).paddingSymmetric(horizontal: 2.w),
                    SizedBox(
                      height: 1.h,
                    ),
                    if (controller.editSpeed.value) ...[
                      Row(
                        children: [
                          Expanded(
                            child: EditTextField(
                              height: 42,
                              borderRadius: AppSizes.radius_10,
                              color: Colors.white,
                              hintStyle: AppTextStyles(context)
                                  .display16W400
                                  .copyWith(color: AppColors.color_969696),
                              textStyle: AppTextStyles(context).display16W500,
                              controller: controller.maxSpeedUpdate,
                              hintText: "Max Speed",
                              inputFormatters: [Utils.intFormatter()],
                            ),
                          ),
                          SizedBox(
                            width: 1.w,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                controller.editDevicesByDetails(
                                    editSpeed: true, context: context);
                                controller.editSpeed.value = false;
                              },
                              child: Container(
                                height: 42,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(AppSizes.radius_10),
                                  color: AppColors.black,
                                ),
                                child: Center(
                                  child: Text(
                                    'Set',
                                    style: AppTextStyles(context)
                                        .display16W500
                                        .copyWith(
                                            color:
                                                AppColors.selextedindexcolor),
                                  ).paddingSymmetric(
                                      horizontal: 2.w, vertical: 1.h),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ).paddingSymmetric(vertical: 0.4.h, horizontal: 10),
                      SizedBox(
                        height: 1.h,
                      )
                    ]
                  ],
                ))
          ],
        ));
  }
}
