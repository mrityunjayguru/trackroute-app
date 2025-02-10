import 'package:defer_pointer/defer_pointer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/service/model/time_model.dart';
import '../../../../common/textfield/apptextfield.dart';
import '../../../../config/app_sizer.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_textstyle.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/search_drop_down.dart';
import '../../controller/history_controller.dart';

class RouteHistoryFilter extends StatelessWidget {
  final String name;
  final String date;
  final String address;

  RouteHistoryFilter({
    required this.name,
    required this.date,
    required this.address,
  });

  final controller = Get.isRegistered<HistoryController>()
      ? Get.find<HistoryController>() // Find if already registered
      : Get.put(HistoryController());
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteOff,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            spreadRadius: 0,
            offset: Offset(0, 4),
            color: Color(0xff000000).withOpacity(0.2),
          )
        ],
        borderRadius: BorderRadius.circular(AppSizes.radius_16),
      ),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vehicle',
                    style: AppTextStyles(context)
                        .display12W400
                        .copyWith(color: AppColors.grayLight),
                  ),
                  Text(
                    name,
                    style: AppTextStyles(context)
                        .display14W700
                        .copyWith(color: AppColors.grayLight),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Last Update',
                    style: AppTextStyles(context)
                        .display12W400
                        .copyWith(color: AppColors.grayLight),
                  ),
                  Text(
                    date,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles(context)
                        .display14W700
                        .copyWith(color: AppColors.grayLight),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 1.5.h),
        Container(
          decoration: BoxDecoration(
              color: AppColors.selextedindexcolor,
              borderRadius: BorderRadius.circular(AppSizes.radius_50)),
          child: Row(
            children: [
              SvgPicture.asset('assets/images/svg/ic_location.svg'),
              Flexible(
                child: Text(
                  address,
                  style: AppTextStyles(context).display13W500,
                ).paddingOnly(left: 5),
              )
            ],
          ).paddingOnly(left: 6, bottom: 7, top: 7),
        ),
        SizedBox(height: 0.7.h),
        AppTextFormField(
          height: 50,
          readOnly: true,
          onTap: () => controller.selectDate(
              context,controller.dateController
          ),
          onSuffixTap:() => controller.selectDate(
              context,controller.dateController
          ),
          suffixIcon: 'assets/images/svg/date_icon.svg',

          color: AppColors.textfield,
          controller: controller.dateController,
          hintText: 'Date',
        ),
        SizedBox(height: 2.h),
        Obx(()=> Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SearchDropDown<TimeOption>(
                  dropDownFillColor: AppColors.textfield,
                  showBorder: false,
                  hintStyle: AppTextStyles(context)
                      .display16W400
                      .copyWith(color: AppColors.grayLight),
                  height: 50,

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
                  Text("to", style: TextStyle(fontSize: 18),),
                ],
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: SearchDropDown<TimeOption>(
                  dropDownFillColor: AppColors.textfield,
                  showBorder: false,
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
                  controller.getRouteHistory();
                },
                child: Container(
                  height: 6.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.radius_50),
                    color: AppColors.black,
                  ),
                  child: Center(
                    child: Text(
                      'Check History',
                      style: AppTextStyles(context)
                          .display12W500
                          .copyWith(color: AppColors.selextedindexcolor),
                    ),
                  ),
                ),
              ),
            )

          ],
        ),
        SizedBox(height: 1.h),
        InkWell(
            onTap: (){
              controller.time2.value=null;
              controller.time1.value=null;
              controller.dateController.clear();
              controller.endDateController.clear();
            },
            child: Container(
              width: 33.w,
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(AppSizes.radius_50),
                color: AppColors.white,
              ),
              child: Center(
                child: Text(
                  'Reset',
                  style: AppTextStyles(context)
                      .display12W500
                      .copyWith(
                      color:
                      AppColors.blue),
                ).paddingSymmetric(
                    horizontal: 6.w, vertical: 1.4.h),
              ),
            )
        ),
        // SizedBox(height: 1.h),
      ],
                ),
    );
  }
}
