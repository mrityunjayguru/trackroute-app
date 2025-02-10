import Flutter
import UIKit
import GoogleMaps  // Import Google Maps SDK

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Provide your API key to the Google Maps SDK
    GMSServices.provideAPIKey("AIzaSyChD5d2MJHsO0tWn-7c8EixTETIqauqJrw")  // Replace with your actual API key

    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
//
// import UIKit
// import Flutter
// import GoogleMaps
// import Firebase
//
// @UIApplicationMain
// @objc class AppDelegate: FlutterAppDelegate {
//     override func application(
//         _ application: UIApplication,
//         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//     ) -> Bool {
//         // Initialize Firebase
//         FirebaseApp.configure()
//
//         // Provide your API key to the Google Maps SDK
//     GMSServices.provideAPIKey("AIzaSyChD5d2MJHsO0tWn-7c8EixTETIqauqJrw")   // Replace with your actual API key
//
//         // Set the notification delegate for iOS 10+
//         if #available(iOS 10.0, *) {
//             UNUserNotificationCenter.current().delegate = self
//         }
//
//         // Register Flutter plugins
//         GeneratedPluginRegistrant.register(with: self)
//
//         return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//     }
//
//     // Handle APNs token registration
//     override func application(
//         _ application: UIApplication,
//         didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
//     ) {
//         Messaging.messaging().apnsToken = deviceToken
//         super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
//     }
//
//     // Handle Firebase messaging when receiving notifications
//     func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//         print("Received remote message: \(remoteMessage.appData)")
//     }
//
//     // Handle notification response
//     override func userNotificationCenter(
//         _ center: UNUserNotificationCenter,
//         didReceive response: UNNotificationResponse,
//         withCompletionHandler completionHandler: @escaping () -> Void
//     ) {
//         print("User responded to notification: \(response.notification.request.content.userInfo)")
//         completionHandler()
//     }
// }
