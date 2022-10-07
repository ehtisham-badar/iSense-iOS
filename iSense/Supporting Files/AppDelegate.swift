//
//  AppDelegate.swift
//  iSense
//
//  Created by  Abdullah Javed on 27/08/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UNUserNotificationCenter.current().delegate = self
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge,.alert, .sound,.criticalAlert]) { (granted, error) in
                if granted {
                    // do something
                }
            }
        
        if(!isAppAlreadyLaunchedOnce()){
            UserDefaults.standard.set("5", forKey: "seconds")
            UserDefaults.standard.set("2", forKey: "tilt_initial")
            UserDefaults.standard.set("500", forKey: "tilt_final")
            UserDefaults.standard.set("2", forKey: "magnet_initial")
            UserDefaults.standard.set("500", forKey: "magnet_final")
            UserDefaults.standard.set("1", forKey: "range_confirm")
            UserDefaults.standard.set("1", forKey: "wait")
            UserDefaults.standard.set("1", forKey: "after_notification")
            
            UserDefaults.standard.set("Started", forKey: "notification_message")
            UserDefaults.standard.set("Phone", forKey: "movement_message")
            UserDefaults.standard.set("Magnet", forKey: "magnet_message")
            UserDefaults.standard.set(true, forKey: "is_notification_on")
            UserDefaults.standard.set(true, forKey: "is_movement_on")
            UserDefaults.standard.set(true, forKey: "is_magnet_on")
        }
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Got the msg...")
        if #available(iOS 14.0, *) {
            completionHandler([.badge, .sound, .alert,.list])
        } else {
            completionHandler([.badge, .sound, .alert])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                          didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void){
        completionHandler()
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
            
        if defaults.bool(forKey: "isAppAlreadyLaunchedOnce"){
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            return false
        }
    }

}

