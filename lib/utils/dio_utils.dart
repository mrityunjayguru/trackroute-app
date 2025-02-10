// // import 'package:alice/alice.dart';
// import 'dart:async';


// import 'package:dio/dio.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';
// import 'package:track_route_pro/utils/app_prefrance.dart';

// /*Alice alice = Alice(
//   /// keep showNotification false
//   /// if showNotification true, it will show lots of notifications while running ios App
//   showNotification: false,
//   showInspectorOnShake: true,
//   navigatorKey: AppRoutesConfig.rootNavigatorKey,
// );*/

// void showAliceInspector() {
//   //if(!kReleaseMode){
//   //  alice.showInspector();
//   //}
// }

// class DioUtil {
//  // Dio? dio;
//   final Dio _dioInstance = Dio(BaseOptions(
//     connectTimeout: 50000,
//     receiveTimeout: 50000,
//   ),);

//   Dio getDio({bool? useAccessToken, String? token}) {
//     _dioInstance.interceptors.clear(); // Clear existing interceptors

//     // Add PrettyDioLogger for logging
//     _dioInstance.interceptors.add(PrettyDioLogger(

//       requestHeader: true,
//       requestBody: true,
//       responseHeader: true,
//       compact: false,
//     ),);


//     // Add authorization header if useAccessToken is true
//     if (useAccessToken ?? false) {
//       _dioInstance.interceptors.add(InterceptorsWrapper(

//         onRequest: (options, handler) async {
//           /// todo remove the static
//           final accessToken =
//               await AppPreference().getStringFromSF('access_token');
//           options.headers['Authorization'] = 'Bearer $accessToken';
//           return handler.next(options);
//         },
//         onResponse: (response, handler) {
//           return handler.next(response);
//         },

//         onError: (error, handler) async {
//           if(error.requestOptions.path == 'auth/refresh-token' && error.response?.statusCode == 401){
//             await AppPreference.clearSharedPreferences();
//             userImageModel = Rx<UserImageModel>(UserImageModel());
//             unawaited(Get.offAllNamed(Routes.LOGIN));
//           } else if (error.response?.statusCode == 401) {
//             final requestOptions = error.response!.requestOptions;
//             final success = await postRefreshToken();
//             if (success == true) {
//               final accessToken = await AppPreference().getStringFromSF('access_token');
//               requestOptions.headers['Authorization'] = 'Bearer $accessToken';
//               final cloneReq = await _dioInstance.request<dynamic>(
//                 '${Constants.baseUrl}${requestOptions.path}',
//                 options: Options(
//                   method: requestOptions.method,
//                   headers: requestOptions.headers,
//                   responseType: ResponseType.json,
//                 ),
//                 data: requestOptions.data,
//                 queryParameters: requestOptions.queryParameters,
//               );
//               return handler.resolve(cloneReq);
//             }
//           }
//           return handler.next(error);
//         },

//       ),);
//     }

//     // Set default content-type header
//     _dioInstance.options.headers['Content-Type'] = 'application/json';

//     return _dioInstance;
//   }
// }
