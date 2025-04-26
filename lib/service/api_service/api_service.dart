import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/retrofit.dart';
import 'package:track_route_pro/constants/project_urls.dart';
import 'package:track_route_pro/service/model/CommonResponseModel.dart';
import 'package:track_route_pro/service/model/ReportsRequest.dart';
import 'package:track_route_pro/service/model/alerts/config/get_config/GetAlertsConfig.dart';
import 'package:track_route_pro/service/model/auth/FirebaseUpdateRequest.dart';
import 'package:track_route_pro/service/model/auth/ManageSettingModel.dart';
import 'package:track_route_pro/service/model/auth/forgot_password/generate_otp.dart';
import 'package:track_route_pro/service/model/auth/forgot_password/verify_otp.dart';
import 'package:track_route_pro/service/model/auth/login/login_response.dart';
import 'package:track_route_pro/service/model/auth/reset_password/reset_password.dart';
import 'package:track_route_pro/service/model/faq/FaqListModel.dart';
import 'package:track_route_pro/service/model/listing_base_response.dart';
import 'package:track_route_pro/service/model/presentation/DownloadReportResponse.dart';
import 'package:track_route_pro/service/model/presentation/RenewResponse.dart';
import 'package:track_route_pro/service/model/presentation/fcm_token.dart';
import 'package:track_route_pro/service/model/presentation/setting_screen_model/about_us_model.dart';
import 'package:track_route_pro/service/model/presentation/setting_screen_model/setting_add_model.dart';
import 'package:track_route_pro/service/model/presentation/setting_screen_model/support_response.dart';
import 'package:track_route_pro/service/model/presentation/splsh_add/splash_add.dart';
import 'package:track_route_pro/service/model/presentation/track_route/track_route_vehicle_list.dart';
import 'package:track_route_pro/service/model/presentation/vehicle_type/VehicleTypeList.dart';
import 'package:track_route_pro/service/model/privacy_policy/PrivacyPolicyResponse.dart';
import 'package:track_route_pro/utils/app_prefrance.dart';
import '../../modules/login_screen/controller/login_controller.dart';
import '../../routes/app_pages.dart';
import '../model/NewVehicleByUserRequest.dart';
import '../model/NewVehicleRequest.dart';
import '../model/alerts/UpdateAlertsRequest.dart';
import '../model/alerts/alert/AlertsResponse.dart';
import '../model/alerts_listing.dart';
import '../model/faq/Topic.dart';
import '../model/notification/AnnouncementResponse.dart';
import '../model/presentation/DownloadReportRequest.dart';
import '../model/relay/RelayStatusResponse.dart';
import '../model/relay/relay/RelayResponse.dart';
import '../model/route/RouteHistoryList.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ProjectUrls.baseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  static ApiService create() {
    final dio = DioUtil().getDio(
      useAccessToken: true,
    );
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: kDebugMode ? true : false,
        requestBody: kDebugMode ? true : false,
        responseBody: kDebugMode ? true : false,
        responseHeader: kDebugMode ? true : false,
        compact: kDebugMode ? true : false,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) {
          // Pass the response if everything is fine
          handler.next(response);
        },
        onError: (DioError error, handler) async {
          if (error.response?.statusCode == 401) {
            Get.offAllNamed(Routes.LOGIN);
            await Get.put(LoginController()).sendTokenData(isLogout: true);
            await AppPreference.removeLoginData();
          }
          // Continue error handling
          handler.next(error);
        },
      ),
    );
    //kDebugMode ? "" : dio.interceptors.clear();
    return ApiService(dio);
  }

  @POST(ProjectUrls.login)
  Future<LoginResponse> login(
    @Body() Map<String, dynamic> body,
  );

  @POST(ProjectUrls.forgotPassword)
  Future<generateOtp> forgotPassword(
    @Body() Map<String, dynamic> body,
  );

  @POST(ProjectUrls.verifyOTP)
  Future<VeryfyOTP> verifyOTP(
    @Body() Map<String, dynamic> body,
  );

  @POST(ProjectUrls.resetPassword)
  Future<ResetPassword> resetPassword(
    @Body() Map<String, dynamic> body,
  );

  @POST(ProjectUrls.splashAdd)
  Future<SplashAddResponse> splashAdd();

  @POST(ProjectUrls.sendTokenData)
  Future<FCMDataResponse> sendTokenData(
      @Body(nullToAbsent: true) FirebaseUpdateRequest request
  );

  @POST(ProjectUrls.sendAlertsData)
  Future sendAlertsData(@Body() UpdateAlertsRequest request);

  @POST(ProjectUrls.sendAlertsData)
  Future sendNotif(
    @Body() Map<String, dynamic> body,
  );

  @POST(ProjectUrls.userDetails)
  Future<GetAlertsConfig> userDetails(
    @Body() Map<String, dynamic> body,
  );

  @POST(ProjectUrls.settingAdd)
  Future<SettingAddResponse> settingAdd();

  @POST(ProjectUrls.aboutUs)
  Future<AboutUSResponse> aboutUS();

  @POST(ProjectUrls.support)
  Future<SupportResponse> support(
    @Body() Map<String, dynamic> body,
  );

  @POST(ProjectUrls.devicesByOwnerID)
  Future<TrackRouteVehicleList> devicesByOwnerID(
    @Body() Map<String, dynamic> body,
  );

  @POST(ProjectUrls.editdevicesByOwnerID)
  Future editDevicesByOwnerID(
    @Body() Map<String, dynamic> body,
  );

  @POST(ProjectUrls.vehicleType)
  Future<VehicleTypeList> getVehicleType();

  @POST(ProjectUrls.renewSubscription)
  Future<RenewResponse> renewSubscription(
    @Body() Map<String, dynamic> body,
  );

  @POST(ProjectUrls.manageSettings)
  Future<ManageSettingModel> manageSettings();

  @POST(ProjectUrls.faqTopic)
  Future<ListingBaseResponse<Topic>> faqTopic();

  @POST(ProjectUrls.faqList)
  Future<ListingBaseResponse<FaqListModel>> faqList();

  @POST(ProjectUrls.announcements)
  Future<ListingBaseResponse<AnnouncementResponse>> announcements(
      @Body() Map<String, dynamic> body);

  @POST(ProjectUrls.alerts)
  Future<AlertsListing<AlertsResponse>> alerts(
      @Body() Map<String, dynamic> body);

  @POST(ProjectUrls.relayCheckStatus)
  Future<RelayStatusResponse> relayStatus(@Body() Map<String, dynamic> body);

  @POST(ProjectUrls.relayStartEngine)
  Future<RelayResponse> relayStartEngine(@Body() Map<String, dynamic> body);

  @POST(ProjectUrls.relayStopEngine)
  Future<RelayResponse> relayStopEngine(@Body() Map<String, dynamic> body);

  @POST(ProjectUrls.routeHistory)
  Future<RouteHistoryList> routeHistory(
      @Body() Map<String, dynamic> body);

  @POST(ProjectUrls.privacyPolicy)
  Future<ListingBaseResponse<PrivacyPolicyResponse>> privacyPolicy();

  @POST(ProjectUrls.termsCondition)
  Future<ListingBaseResponse<PrivacyPolicyResponse>> termsCondition();

  @POST(ProjectUrls.downloadReport)
  Future<DownloadReportResponse> downloadReport(
      @Body(nullToAbsent: true) DownloadReportRequest request);

  @POST(ProjectUrls.tripReport)
  Future<DownloadReportResponse> tripReport(
      @Body(nullToAbsent: true) ReportsRequest request);

  @POST(ProjectUrls.eventReport)
  Future<DownloadReportResponse> eventReport(
      @Body(nullToAbsent: true) ReportsRequest request);

  @POST(ProjectUrls.consolidateReport)
  Future<DownloadReportResponse> consolidateReport(
      @Body(nullToAbsent: true) ReportsRequest request);

  @POST(ProjectUrls.summaryReport)
  Future<DownloadReportResponse> summaryReport(
      @Body(nullToAbsent: true) ReportsRequest request);

  @POST(ProjectUrls.distanceReport)
  Future<DownloadReportResponse> distanceReport(
      @Body(nullToAbsent: true) ReportsRequest request);

  @POST(ProjectUrls.idleReport)
  Future<DownloadReportResponse> idleReport(
      @Body(nullToAbsent: true) ReportsRequest request);

  @POST(ProjectUrls.newVehicle)
  Future<CommonResponseModel> newVehicle(
      @Body(nullToAbsent: true) NewVehicleRequest request);

  @POST(ProjectUrls.newVehicleByUser)
  Future<CommonResponseModel> newVehicleByUser(
      @Body(nullToAbsent: true) NewVehicleByUserRequest request);

  @POST(ProjectUrls.tripSummary)
  Future<TrackRouteVehicleList> tripSummary(
      @Body() Map<String, dynamic> body);
}
