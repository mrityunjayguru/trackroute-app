import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/app_sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/utils/common_import.dart';
import '../../../common/textfield/apptextfield.dart';
import '../../../service/model/time_model.dart';
import '../../../utils/search_drop_down.dart';
import '../../../utils/utils.dart';
import '../controller/alert_controller.dart';

class DateFilterPage extends StatelessWidget {
  DateFilterPage({super.key});
  final controller = Get.isRegistered<AlertController>()
      ? Get.find<AlertController>() // Find if already registered
      : Get.put(AlertController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.white,
          body:  Column(
            children: [
              Utils().topBar(
                  context: context,
                  rightIcon: 'assets/images/svg/ic_arrow_left.svg',
                  onTap: () {
                    Get.back();
                  },
                  name:"Choose Date Time"),
              Column(
                children: [
                  SizedBox(
                    height: 1.5.h,
                  ),
                  AppTextFormField(
                    height: 50,
                    readOnly: true,
                    border: Border.all(
                      color:  AppColors.textBlackColor.withOpacity(0.3),
                    ),
                    onTap: () => controller.selectDate(
                        context,controller.dateController, true
                    ),
                    onSuffixTap:() => controller.selectDate(
                        context,controller.dateController, true
                    ),
                    suffixIcon: 'assets/images/svg/date_icon.svg',

                    color: AppColors.color_f6f8fc,
                    controller: controller.dateController,
                    hintText: 'Start Date',
                  ),
                  AppTextFormField(
                    height: 50,
                    readOnly: true,
                    border: Border.all(
                      color:  AppColors.textBlackColor.withOpacity(0.3),
                    ),
                    onTap: () => controller.selectDate(
                        context,controller.endDateController, false
                    ),
                    onSuffixTap:() => controller.selectDate(
                        context,controller.endDateController,false
                    ),
                    suffixIcon: 'assets/images/svg/date_icon.svg',

                    color: AppColors.color_f6f8fc,
                    controller: controller.endDateController,
                    hintText: 'End Date',
                  ),
                  SizedBox(height: 2.5.h),
                  Obx(()=> Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SearchDropDown<TimeOption>(
                          dropDownFillColor: AppColors.color_f6f8fc,
                          showBorder: true,
                          hintStyle: AppTextStyles(context)
                              .display16W400
                              .copyWith(color: AppColors.grayLight),
                          height: 50,
                          containerColor: AppColors.color_f6f8fc,
                            borderOpacity: 0,
                          width: context.width,
                          items:
                          controller.timeList.toList(),
                          selectedItem:
                          controller.time1.value,
                          onChanged: (value) {
                            controller.time1.value= value;
                          },
                          hint: "00:00",
                          showSearch: false,
                        ),
                      ),

                      SizedBox(width: 2.w),
                      Column(
                        children: [
                          SizedBox(height: 0.2.h),
                          Text("to", style: AppTextStyles(context).display18W400,),
                        ],
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: SearchDropDown<TimeOption>(
                          dropDownFillColor: AppColors.color_f6f8fc,
                          showBorder: true,
                          containerColor: AppColors.color_f6f8fc,
                          hintStyle: AppTextStyles(context)
                              .display16W400
                              .copyWith(color: AppColors.grayLight),
                          height: 50,
                          width: context.width,
                          items:
                          controller.timeList.toList(),
                          selectedItem:
                          controller.time2.value,
                          onChanged: (value) {
                            controller.time2.value= value;
                          },
                          hint: "24:00",
                          showSearch: false,
                        ),
                      ),
                    ],
                  ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: (){

                          },
                          child: Container(
                            height: 6.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppSizes.radius_50),
                              color: AppColors.black,
                            ),
                            child: Center(
                              child: Text(
                                'Apply Filter',
                                style: AppTextStyles(context)
                                    .display18W400
                                    .copyWith(color: AppColors.selextedindexcolor),
                              ),
                            ),
                          ),
                        ),
                      )

                    ],
                  ),
                  SizedBox(height: 2.h),
                  InkWell(
                      onTap: (){
                        controller.time2.value=null;
                        controller.time1.value=null;
                        controller.dateController.clear();
                        controller.endDateController.clear();
                        controller.startDate ="";
                        controller.endDate ="";
                      },
                      child: Container(
                        width: 33.w,
                        decoration: BoxDecoration(
                          color: AppColors.grayLighter,
                          borderRadius: BorderRadius.circular(AppSizes.radius_50),
                        ),
                        child: Center(
                          child: Text(
                            "Reset",
                            style: AppTextStyles(context).display13W500.copyWith(color: AppColors.purpleColor),
                          ).paddingSymmetric(horizontal: 20,vertical: 10),
                        ),
                      )
                  ),
                ],
              ).paddingSymmetric(horizontal: 20),
              // SizedBox(height: 1.h),
            ],
          ).paddingOnly(top: 12).paddingSymmetric(horizontal: 4.w * 0.9),
        ),
      ),
    );
  }
}
