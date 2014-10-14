//
//  NotificationManager.swift
//  MemoryIt
//
//  Created by SpoonRocket on 2014/10/14.
//  Copyright (c) 2014年 one. All rights reserved.
//

import Foundation

private let _NotificationManagerSharedInstance = NotificationManager()

class NotificationManager {
    
    enum Actions:String{
        case increment = "INCREMENT_ACTION"
        case decrement = "DECREMENT_ACTION"
        case reset = "RESET_ACTION"
    }
    
    var categoryID:String {
        get{
            return "COUNTER_CATEGORY"
        }
    }
    
    var lockCount = 0
    var locked = false
    
    class var sharedInstance : NotificationManager {
        
    return _NotificationManagerSharedInstance
    }
    
    func forVocabulary(string :NSString) {
        var notification: UILocalNotification = UILocalNotification()
        notification.fireDate = NSDate()
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = "You copy \(string)"
        notification.alertAction = "Open"
        notification.hasAction = true
        notification.applicationIconBadgeNumber = 0
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func forArticle(string :NSString) {
        var notification: UILocalNotification = UILocalNotification()
        notification.fireDate = NSDate()
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = "Article: \(string)"
        notification.alertAction = "Open"
        notification.hasAction = true
        notification.applicationIconBadgeNumber = 0
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func registerNotification() {
        
        // 1. Create the actions **************************************************
        
        // increment Action
        let incrementAction = UIMutableUserNotificationAction()
        incrementAction.identifier = Actions.increment.toRaw()
        incrementAction.title = "ADD +1!"
        incrementAction.activationMode = UIUserNotificationActivationMode.Background
        incrementAction.authenticationRequired = true
        incrementAction.destructive = false
        
        // decrement Action
        let decrementAction = UIMutableUserNotificationAction()
        decrementAction.identifier = Actions.decrement.toRaw()
        decrementAction.title = "SUB -1"
        decrementAction.activationMode = UIUserNotificationActivationMode.Background
        decrementAction.authenticationRequired = true
        decrementAction.destructive = false
        
        // reset Action
        let resetAction = UIMutableUserNotificationAction()
        resetAction.identifier = Actions.reset.toRaw()
        resetAction.title = "RESET"
        resetAction.activationMode = UIUserNotificationActivationMode.Foreground
        // NOT USED resetAction.authenticationRequired = true
        resetAction.destructive = true
        
        
        // 2. Create the category ***********************************************
        
        // Category
        let counterCategory = UIMutableUserNotificationCategory()
        counterCategory.identifier = categoryID
        
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
    
    func forFlash(string :NSString) {
        var notification: UILocalNotification = UILocalNotification()
        notification.fireDate = NSDate()
        //        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = "You copy \(string)"
        //        notification.alertAction = "Open"
        notification.category = categoryID
        //        notification.hasAction = true
        notification.soundName = UILocalNotificationDefaultSoundName
        //        notification.applicationIconBadgeNumber = 1
                notification.userInfo = ["uoo": "kkkk"]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func scheduleNotification() {
        //UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        // Schedule the notification ********************************************
        if UIApplication.sharedApplication().scheduledLocalNotifications.count == 0 {
            
            let notification = UILocalNotification()
            notification.alertBody = "Hey! Update your counter ;)"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.fireDate = NSDate()
            notification.category = categoryID
            notification.repeatInterval = NSCalendarUnit.CalendarUnitMinute
            
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }
    
    func handleActionWithIdentifier(identifier: String?, notification: UILocalNotification) {
        if notification.category == categoryID {
            let action:Actions = Actions.fromRaw(identifier!)!
            
            switch action{
            case Actions.increment:
                println("increment")
                
            case Actions.decrement:
                println("increment")
                
            case Actions.reset:
                println("reset")
            }
        }
    }
    
    func lockEvent(string: String) {
        lockCount++
        if lockCount > 2 {
            locked = false
            lockCount = 0
            DataManager.sharedInstance.unlockToClear()
//            NSNotificationCenter.defaultCenter().postNotificationName("LockEvent", object: ["event": "locked"])
        }
        else if lockCount > 1 {
            locked = true
            DataManager.sharedInstance.lockToFlash()
//            NSNotificationCenter.defaultCenter().postNotificationName("LockEvent", object: ["event": "unlock"])
        }
    }
    
    func clearAllFlash() {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
}