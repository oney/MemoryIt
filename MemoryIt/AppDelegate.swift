//
//  AppDelegate.swift
//  MemoryIt
//
//  Created by SpoonRocket on 2014/10/10.
//  Copyright (c) 2014年 one. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        if UIApplication.instancesRespondToSelector(Selector("registerUserNotificationSettings:")) {
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil))
        }
        
//        DataManager.sharedInstance.runnn()
        Converter.sharedInstance().registerDeviceLock({
            (event: String!) in
            println("event:\(event)")
            NotificationManager.sharedInstance.lockEvent(event)
        })
        NotificationManager.sharedInstance.registerNotification()
        return true
    }
    
    func pasteboardChanged(application: UIApplication) {
        
        var task : UIBackgroundTaskIdentifier!
        task = application.beginBackgroundTaskWithExpirationHandler({
            application.endBackgroundTask(task)
        })
        
        if task == UIBackgroundTaskInvalid {
            return
        }
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var content :NSString = ""
            for var i = 0; i < 1000; i++ {
                var paste = Converter.sharedInstance().pasteboardString()
                if paste != "" {
                    if !content.isEqualToString(UIPasteboard.generalPasteboard().string!) {
                        content = UIPasteboard.generalPasteboard().string!
                        println("new content:\(content)")
//                        NotificationManager.sharedInstance.forFlash(content)
//                        DataManager.sharedInstance.detectNewContent(content)
                    }
                }
                NSThread.sleepForTimeInterval(1)
            }
            application.endBackgroundTask(task)
        })
    }
    
    func applicationWillResignActive(application: UIApplication) {
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
        pasteboardChanged(application)
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
        DataManager.sharedInstance.saveContext()
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        println("didRegisterUserNotificationSettings")
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        println("handleActionWithIdentifier")
        NSLog("notification:%@", notification)
        NotificationManager.sharedInstance.handleActionWithIdentifier(identifier, notification: notification)
        completionHandler()
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        println("didReceiveLocalNotification")
    }

    

}

