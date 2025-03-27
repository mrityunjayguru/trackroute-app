/*
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
} */import Flutter
    import UIKit
    import GoogleMaps  // Import Google Maps SDK
    import Firebase    // Import Firebase
    import FirebaseMessaging  // Import Firebase Messaging

    @main
    @objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {  // ✅ Add protocols here
      override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
      ) -> Bool {
        // Provide API key for Google Maps
        GMSServices.provideAPIKey("AIzaSyChD5d2MJHsO0tWn-7c8EixTETIqauqJrw")  // Replace with your actual API key

        // Configure Firebase
        FirebaseApp.configure()

        // Set up Firebase Messaging
        Messaging.messaging().delegate = self

        // Register for remote notifications
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()

        GeneratedPluginRegistrant.register(with: self)
        UIApplication.shared.isIdleTimerDisabled = true
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
      }

      // MARK: - Handle Push Notifications
     override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
      ) {
        completionHandler([.banner, .sound, .badge]) // Show notification when app is in foreground
      }

      // Handle FCM Token updates
      func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase FCM Token: \(fcmToken ?? "")")
      }
    }
/*
import UIKit
import Flutter
import Firebase
import FirebaseMessaging
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        // Configure Firebase
        FirebaseApp.configure()

        // Set up Firebase Messaging
        Messaging.messaging().delegate = self

        // Request notification permissions
        requestNotificationPermission(application: application)

        GeneratedPluginRegistrant.register(with: self)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func requestNotificationPermission(application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permissions: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
        application.registerForRemoteNotifications()
    }

    // Handle push notification when app is in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }

    // Handle FCM token updates
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase FCM Token: \(fcmToken ?? "")")
    }
} */