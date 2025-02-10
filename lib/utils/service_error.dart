
// import 'package:get/get_connect/sockets/src/sockets_html.dart';
// import 'package:track_route_pro/utils/app_prefrance.dart';
// import 'package:track_route_pro/utils/common_import.dart';

// class ServiceError {
//   String getError(String res)  {
//     if(ConnectionStatus.value == ConnectivityResult.none) {
//       showToastRed('No internet connection. Please check your network settings.');
//     }
//     var error = '';
//     try {
//       appPrint('res $res');
//       final jsonResponse = jsonDecode(res);
//       if (jsonResponse != null) {
//         final apiError =
//             ApiErrorModel.fromJson(jsonResponse as Map<String, dynamic>);
//         error = apiError.message ?? '';
//         if (apiError.status == 401) {
//           //AppToasts.showError(apiError.message ?? '');
//           //postRefreshToken();
//         } else if (apiError.status == 400) {
//           AppToasts.showError(apiError.message ?? '');
//         } else if (apiError.status == 408) {
//           AppToasts.showError(apiError.message ?? '');
//         } else {
//           AppToasts.showError(apiError.message ?? '');
//         }
//       } else {
//         AppToasts.showError('Something is wrong try again...');
//         appPrint('-*-*-**-*-*-*-*--* result Null ------*-*-**-*--');
//       }
//     } on DioError catch (onError) {
//       error = 'Something is wrong.';
//       appPrint(':::::: $res');
//     }
//     return error;
//   }
// }

// final _apiService = ApiService.create();

// Future<bool> postRefreshToken() async {
//   progressIndicator(Get.context!);
//   try {
//     final refreshToken = await AppPreference().getStringFromSF('refresh_token');
//     final response = await _apiService.refreshToken(refreshToken: refreshToken.toString());
//     if(response.status == 200 && response.data != null) {
//       await AppPreference().addStringToSF('access_token', (response.data as Map<String, dynamic>)['access_token']!.toString(),);
//       await AppPreference().addStringToSF('refresh_token', (response.data as Map<String, dynamic>)['refresh_token']!.toString(),);
//       return true;
//     }
//   } finally {
//     SizedBox();
//   }
//   return false;
// }


// class ApiErrorModel {
//   ApiErrorModel({this.success, this.error, this.message, this.status});

//   ApiErrorModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'] as bool;
//     error = json['error']?.toString();
//     message = json['message']?.toString();
//     status = json['status'] as int;
//   }

//   bool? success;
//   String? error;
//   String? message;
//   int? status;

//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['success'] = success;
//     data['error'] = error;
//     data['message'] = message;
//     data['status'] = status;
//     return data;
//   }
// }

// Map<String, dynamic> toJson() {
//   final data = <String, dynamic>{};
//   return data;
// }

// class ApiError {

//   ApiError({required this.status, required this.message});
//   ApiError.fromJson(Map<String, dynamic> json) {
//     status = (json['status'] ?? 0) as int;
//     final messageData = json['message'];

//     if (messageData != null) {
//       if (messageData is String) {
//         message = messageData;
//       } else if (messageData is List<dynamic>) {
//         // Joining the list elements to form a single string message
//         message =
//             messageData.join(', '); // Customize join based on your preference
//       } else {
//         message = messageData.toString();
//       }
//     } else {
//       message =
//           'Unknown error occurred'; // Default message if 'message' is absent
//     }
//   }

//   int status = 0;
//   dynamic message;

//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['status'] = status;
//     data['message'] = message;
//     return data;
//   }
// }
