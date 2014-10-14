//
//  UILocalNotification.swift
//  MemoryIt
//
//  Created by SpoonRocket on 2014/10/14.
//  Copyright (c) 2014年 one. All rights reserved.
//

import Foundation

extension UILocalNotification {
    
    class func forVocabulary(string :NSString) {
        var notification: UILocalNotification = UILocalNotification()
        notification.fireDate = NSDate()
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = "You copy \(string)"
        notification.alertAction = "Open"
        notification.hasAction = true
        notification.applicationIconBadgeNumber = 0
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    class func forArticle(string :NSString) {
        var notification: UILocalNotification = UILocalNotification()
        notification.fireDate = NSDate()
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = "Article: \(string)"
        notification.alertAction = "Open"
        notification.hasAction = true
        notification.applicationIconBadgeNumber = 0
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    class func forFlash(string :NSString) {
        var notification: UILocalNotification = UILocalNotification()
        notification.fireDate = NSDate()
//        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = "You copy \(string)"
//        notification.alertAction = "Open"
        notification.category = "NormalFlashIdentifier"
//        notification.hasAction = true
        notification.soundName = UILocalNotificationDefaultSoundName
//        notification.applicationIconBadgeNumber = 1
//        notification.userInfo = ["uoo": "kkkk"]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    class func registerNotification() {
        
        // 1. Create the actions **************************************************
        
        // increment Action
        let incrementAction = UIMutableUserNotificationAction()
        incrementAction.identifier = "identifier1"
        incrementAction.title = "ADD +1!"
        incrementAction.activationMode = UIUserNotificationActivationMode.Background
        incrementAction.authenticationRequired = true
        incrementAction.destructive = false
        
        // decrement Action
        let decrementAction = UIMutableUserNotificationAction()
        decrementAction.identifier = "identifier2"
        decrementAction.title = "SUB -1"
        decrementAction.activationMode = UIUserNotificationActivationMode.Background
        decrementAction.authenticationRequired = true
        decrementAction.destructive = false
        
        // reset Action
        let resetAction = UIMutableUserNotificationAction()
        resetAction.identifier = "identifier3"
        resetAction.title = "RESET"
        resetAction.activationMode = UIUserNotificationActivationMode.Foreground
        // NOT USED resetAction.authenticationRequired = true
        resetAction.destructive = true
        
        
        // 2. Create the category ***********************************************
        
        // Category
        let counterCategory = UIMutableUserNotificationCategory()
        counterCategory.identifier = "NormalFlashIdentifier"
        
        // A. Set actions for the default context
        counterCategory.setActions([incrementAction, decrementAction, resetAction],
            forContext: UIUserNotificationActionContext.Default)
        
        // B. Set actions for the minimal context
        counterCategory.setActions([incrementAction, decrementAction],
            forContext: UIUserNotificationActionContext.Minimal)
        
        
        // 3. Notification Registration *****************************************
        
        let types = UIUserNotificationType.Alert | UIUserNotificationType.Sound
        let settings = UIUserNotificationSettings(forTypes: types, categories: NSSet(object: counterCategory))
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }
}