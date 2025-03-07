import 'package:intl/intl.dart';
import 'package:track_route_pro/constants/project_urls.dart';
import 'package:track_route_pro/service/api_service/api_service.dart';
import 'package:track_route_pro/service/model/ReportsRequest.dart';
import 'package:track_route_pro/service/model/presentation/track_route/track_route_vehicle_list.dart';
import 'package:track_route_pro/service/model/privacy_policy/PrivacyPolicyResponse.dart';
import 'package:track_route_pro/utils/common_import.dart';
import 'package:track_route_pro/utils/enums.dart';
import '../../../service/model/time_model.dart';
import '../../../utils/utils.dart';
import '../../track_route_screen/controller/track_route_controller.dart';

class RegisterController extends GetxController {
  ApiService apiservice = ApiService.create();
  String link = "";


}
