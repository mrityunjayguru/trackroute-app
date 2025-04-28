import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/config/app_sizer.dart';
import 'package:track_route_pro/config/theme/app_colors.dart';
import 'package:track_route_pro/config/theme/app_textstyle.dart';
import 'package:track_route_pro/service/model/notification/AnnouncementResponse.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../controller/alert_controller.dart';

class AnnouncementTab extends StatelessWidget {
  AnnouncementTab({super.key});

  final controller = Get.find<AlertController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => RefreshIndicator(
        onRefresh: onRefresh,
        color: AppColors.selextedindexcolor,
        child: ListView.builder(
          itemCount: controller.announcements.length,
          itemBuilder: (context, index) => notificationAlert(
            context: context,
            data: controller.announcements[index],
          ),
        ),
      ),
    );
  }

  Widget notificationAlert({
    required BuildContext context,
    required AnnouncementResponse data,
  }) {
    String date = 'Update unavailable';
    String time = "";
    if (data.createdAt?.isNotEmpty ?? false) {
      try {
        final createdAt = DateTime.parse(data.createdAt ?? "").toLocal();
        date = DateFormat("dd MMM yyyy").format(createdAt);
        time = DateFormat("HH:mm").format(createdAt);
      } catch (e) {
        date = "NA";
        time = "NA";
      }

    }

    Color color;
    if (data.urgency != null && data.urgency!.isNotEmpty) {
      color = Color(int.parse(data.urgency!.replaceFirst('#', '0xFF')));
    } else {
      color = Colors.grey; // Default color if `urgency` is not provided
    }

    return Container(
      decoration: BoxDecoration(
          color: AppColors.whiteOff,
          borderRadius: BorderRadius.circular(AppSizes.radius_15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ).paddingOnly(right: 2.w),
              Flexible(
                child: Text(
                  data.title ?? "",
                   style: AppTextStyles(context).display14W700,
                ),
              ),
            ],
          ).paddingOnly(left: 1.4.w, top: 1.w, bottom: 1.5.w),
          Text(data.message ?? "").paddingOnly(
            left: 2.w,
            top: 1.w,
          ),
          Text(date + " at " + time).paddingOnly(
            left: 2.w,
            top: 1.w,
          )
        ],
      ).paddingAll(0.8.h),
    ).paddingOnly(bottom: 12);
  }

  Future<void> onRefresh() async {
    await controller.getAnnouncements();
  }
}
