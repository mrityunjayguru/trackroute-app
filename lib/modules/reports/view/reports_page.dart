import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/gen/assets.gen.dart';
import 'package:track_route_pro/modules/reports/controller/reports_controller.dart';
import 'package:track_route_pro/modules/reports/controller/reports_controller.dart';
import 'package:track_route_pro/modules/reports/controller/reports_controller.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../../constants/project_urls.dart';
import '../../../utils/utils.dart';
import '../../splash_screen/controller/data_controller.dart';

class ReportsView extends StatelessWidget {
  ReportsView({super.key});

  final controller = Get.isRegistered<ReportsController>()
      ? Get.find<ReportsController>() // Find if already registered
      : Get.put(ReportsController());
  final dataController = Get.isRegistered<DataController>()
      ? Get.find<DataController>() // Find if already registered
      : Get.put(DataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Obx(
                () => Image.network(
                    width: 25,
                    height: 25,
                    "${ProjectUrls.imgBaseUrl}${dataController.settings.value.logo}",
                    errorBuilder: (context, error, stackTrace) =>
                        SvgPicture.asset(
                          Assets.images.svg.icIsolationMode,
                          color: AppColors.black,
                        )).paddingOnly(left: 6, right: 8),
              ),
              Text(
                "Reports",
                style: AppTextStyles(context).display20W500,
              ).paddingOnly(right: 5),
              Text(
                "Download Consolidated Events Report",
                style: AppTextStyles(context)
                    .display10W400
                    .copyWith(color: AppColors.grayLight),
              ),
              Spacer(),
              InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: SvgPicture.asset(
                    "assets/images/svg/ic_arrow_left.svg",
                  ))
            ],
          ).paddingOnly(top: 12),
          SizedBox(
            height: 20,
          ),
          Container(
            width: context.width,
            padding: EdgeInsets.all(6),
            margin: EdgeInsets.only(bottom: 1.h),
            decoration: BoxDecoration(
              color: AppColors.color_f6f8fc,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      maxRadius: 30,
                      backgroundColor: AppColors.grayLight,
                      child: Icon(Icons.file_download_outlined, color: Colors.black,).paddingAll(5),
                    ),
                    Text(
                      'Trip / Event Summary',
                      style: AppTextStyles(context).display20W500,
                    ),
                  ],
                ),

                CircleAvatar(
                  maxRadius: 100,
                  backgroundColor: AppColors.grayLight,
                  child: SvgPicture.asset("assets/images/svg/reports_icon.svg").paddingAll(15),
                ),
                Text.rich(
                  textAlign: TextAlign.end,
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'The',
                        style: AppTextStyles(context)
                            .display13W500
                            .copyWith(color: AppColors.grayLight),
                      ),
                      TextSpan(
                        text: ' Consolidated Trip/Events Report',
                        style: AppTextStyles(context)
                            .display13W600
                            .copyWith(color: AppColors.grayLight),
                      ),
                      TextSpan(
                        text:
                        ' provides a detailed daily summary of vehicle activity. It includes key parameters such as geofence(entry/exit), ignition status (on/off), maximum and average speed, total distance traveled, duration of trips, motion time, and idle time.',
                        style: AppTextStyles(context)
                            .display13W500
                            .copyWith(color: AppColors.grayLight),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
