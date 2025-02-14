import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:upgrader/upgrader.dart';
import '../../../../config/app_sizer.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_textstyle.dart';
import '../../../../utils/common_import.dart';

class UpdateDialog extends StatelessWidget {
  UpdateDialog({super.key});


  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      child: SizedBox.shrink(),
    );
  }
}
