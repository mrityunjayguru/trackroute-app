import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:track_route_pro/modules/faqs/controller/faqs_controller.dart';
import 'package:track_route_pro/service/model/faq/FaqListModel.dart';
import 'package:track_route_pro/utils/common_import.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_textstyle.dart';
import '../../../constants/project_urls.dart';
import '../../../gen/assets.gen.dart';
import '../../splash_screen/controller/data_controller.dart';

class FaqsView extends StatelessWidget {
  FaqsView({super.key});

  final controller = Get.put(FaqsController());

  final dataController = Get.isRegistered<DataController>()
      ? Get.find<DataController>() // Find if already registered
      : Get.put(DataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 100.w,
          decoration: BoxDecoration(color: AppColors.black),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 8.h,
              ),
              Obx(
                () => Image.network(
                    width: 120,
                    height: 50,
                    "${ProjectUrls.imgBaseUrl}${dataController.settings.value.appLogo}",
                    errorBuilder: (context, error, stackTrace) =>
                        SvgPicture.asset(
                          Assets.images.svg.icIsolationMode,
                          color: AppColors.black,
                        )),
              ),
              Row(
                children: [
                  Text(
                    'FAQ\'s',
                    style: AppTextStyles(context).display32W700.copyWith(
                          color: AppColors.whiteOff,
                        ),
                  ),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: SvgPicture.asset("assets/images/svg/close_icon.svg", ))
                ],
              ),
              SizedBox(
                height: 4.h,
              ),
            ],
          ).paddingSymmetric(horizontal: 6.w),
        ),
        SizedBox(
          height: 1.5.h,
        ),
        Obx(() {
          return Expanded(
          child: SingleChildScrollView(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    List<FaqListModel> faq = controller.faqs
                        .where(
                          (p0) {
                            return p0.topic?.id == controller.topicsList[index].id;
                          },
                        )
                        .toList();
                    faq.sort((a, b) => int.parse(a.priority ?? "0").compareTo(int.parse(b.priority ?? "0")));
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(controller.topicsList[index].title ?? "",
                                  style: AppTextStyles(context).display20W600)
                              .paddingSymmetric(horizontal: 6.w),
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                        Flexible(
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) =>
                                Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(faq[index].title ?? "",  style: AppTextStyles(context).display18W500)
                                      .paddingSymmetric(horizontal: 6.w),
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                Flexible(
                                  child: Text(faq[index].description ?? "", style: AppTextStyles(context).display14W400)
                                      .paddingSymmetric(horizontal: 6.w),
                                ),
                              ],
                            ),
                            separatorBuilder: (BuildContext context, int index) =>
                                SizedBox(
                              height: 16,
                            ),
                            itemCount: faq.length,
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => SizedBox(
                    height: 16,
                  ),
                  itemCount: controller.topicsList.length,
                ),
              ),
        );
        })
      ]),
    );
  }
}
