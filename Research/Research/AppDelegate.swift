//
//  AppDelegate.swift
//  Research
//
//  Created by Lance Blue on 2016/11/1.
//  Copyright © 2016年 Lance Blue. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    
    let locationManager = CLLocationManager()

    
    // MARK: - UIApplicationDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow()
        
        let rootViewController = UINavigationController(rootViewController: MainViewController())
        self.window?.rootViewController = rootViewController
        
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        
        
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            granted, error in
            if granted {
                // 用户允许进行通知
            }
        }
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        if CLLocationManager.significantLocationChangeMonitoringAvailable() {
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.startUpdatingLocation()
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        if CLLocationManager.significantLocationChangeMonitoringAvailable() {
            locationManager.stopMonitoringSignificantLocationChanges()
            locationManager.stopUpdatingLocation()
        }
        
        if FileManager.default.fileExists(atPath: filePath()) {
            if let array = NSArray(contentsOfFile: filePath()) as? [[String: Any]] {
                for item in array {
                    debugPrint("Latitude:\(item["latitude"]) Longitude:\(item["longitude"]) Time:\(item["time"])")
                }
                debugPrint("Count: \(array.count)")
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // 1. 创建通知内容
        let content = UNMutableNotificationContent()
        content.title = "Time Interval Notification"
        content.body = "My first notification"
        
        // 2. 创建发送触发
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        // 3. 发送请求标识符
        let requestIdentifier = "com.lance.usernotification.myFirstNotification"
        
        // 4. 创建一个发送请求
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        
        // 将请求添加到发送中心
        UNUserNotificationCenter.current().add(request) { error in
            if error == nil {
                debugPrint("Time Interval Notification scheduled: \(requestIdentifier)")
                let alertController = UIAlertController(title: "", message: "Time Interval Notification scheduled: \(requestIdentifier)", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
                application.keyWindow?.rootViewController?.present(alertController, animated: true)
                
//                self.locationManager.startUpdatingLocation()
            }
        }
        
        completionHandler(.newData)
    }
    
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!;
        var array = NSMutableArray(contentsOfFile: filePath())
        if array == nil {
            array = NSMutableArray()
        }
        let data = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
            "time": Date().timeIntervalSince1970
        ];
        array?.add(data)
//        array = NSMutableArray()
//        array?.write(toFile: filePath(), atomically: true)
//        
//        self.locationManager.stopUpdatingLocation()
    }
    
    
    // MARK: - Private
    
    private func filePath() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/locations.plist")
    }

}

