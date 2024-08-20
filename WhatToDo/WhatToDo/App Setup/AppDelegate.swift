//
//  AppDelegate.swift
//  WhatToDo
//
//  Created by Samet Baltacıoğlu on 31.07.2024.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Firebase
import FirebaseMessaging
import UserNotifications


class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Firebase'i başlatın
        FirebaseApp.configure()
        
        // Firebase Messaging delegesini ayarlayın
        Messaging.messaging().delegate = self
        
        // Bildirim merkezinin delegesini ayarlayın
        UNUserNotificationCenter.current().delegate = self
        
        // Bildirim izinlerini isteyin
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if let error = error {
                print("Bildirim izni hatası: \(error.localizedDescription)")
            } else {
                print("Bildirim izni verildi: \(granted)")
            }
        }
        
        // Uygulamayı uzaktan bildirimler için kaydedin
        application.registerForRemoteNotifications()
        
        return true
    }
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        print("APNs token alındı: \(deviceToken)")

        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error.localizedDescription)")
            } else if let token = token {
                print("FCM registration token: \(token)")
            }
        }
    }

    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}


