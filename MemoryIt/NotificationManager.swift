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
    
    enum FlashActions:String{
        case memory = "MEMORY_ACTION"
        case forget = "FORGET_ACTION"
        case ok = "OK_ACTION"
        case mark = "MARK_ACTION"
    }
    
    var flashID:String {
        get{
            return "FLASH_ID"
        }
    }
    var flashMeaningID:String {
        get{
            return "FLASH_MEANING_ID"
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
        
        let types = UIUserNotificationType.Badge
        let settings = UIUserNotificationSettings(forTypes: types, categories: NSSet(objects: flashCategory(), flashMeaningCategory()))
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }
    
    func flashCategory() -> UIMutableUserNotificationCategory {
        let incrementAction = UIMutableUserNotificationAction()
        incrementAction.identifier = FlashActions.memory.rawValue
        incrementAction.title = "記得"
        incrementAction.activationMode = UIUserNotificationActivationMode.Background
        incrementAction.authenticationRequired = true
        incrementAction.destructive = false
        
        let decrementAction = UIMutableUserNotificationAction()
        decrementAction.identifier = FlashActions.forget.rawValue
        decrementAction.title = "忘了"
        decrementAction.activationMode = UIUserNotificationActivationMode.Background
        decrementAction.authenticationRequired = true
        decrementAction.destructive = false
        
        let counterCategory = UIMutableUserNotificationCategory()
        counterCategory.identifier = flashID
        
        counterCategory.setActions([incrementAction, decrementAction],
            forContext: UIUserNotificationActionContext.Minimal)
        
        return counterCategory
    }
    
    func flashMeaningCategory() -> UIMutableUserNotificationCategory {
        let incrementAction = UIMutableUserNotificationAction()
        incrementAction.identifier = FlashActions.ok.rawValue
        incrementAction.title = "了解"
        incrementAction.activationMode = UIUserNotificationActivationMode.Background
        incrementAction.authenticationRequired = true
        incrementAction.destructive = false
        
        let decrementAction = UIMutableUserNotificationAction()
        decrementAction.identifier = FlashActions.mark.rawValue
        decrementAction.title = "標記"
        decrementAction.activationMode = UIUserNotificationActivationMode.Background
        decrementAction.authenticationRequired = true
        decrementAction.destructive = false
        
        let counterCategory = UIMutableUserNotificationCategory()
        counterCategory.identifier = flashMeaningID
        
        counterCategory.setActions([incrementAction, decrementAction],
            forContext: UIUserNotificationActionContext.Minimal)
        
        return counterCategory
    }
    
    func forFlash(string :NSString) {
        var notification: UILocalNotification = UILocalNotification()
        notification.fireDate = NSDate()
        notification.alertBody = "You copy \(string)"
        notification.category = flashID
        notification.soundName = UILocalNotificationDefaultSoundName
                notification.userInfo = ["word": string]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func createFlashMeaning(string :NSString) {
        var notification: UILocalNotification = UILocalNotification()
        notification.fireDate = NSDate()
        notification.alertBody = "\(string) meaning is kkkk"
        notification.category = flashMeaningID
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["uoo": "kkkk"]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func handleActionWithIdentifier(identifier: String?, notification: UILocalNotification) {
        if notification.category == flashID {
            let action: FlashActions = FlashActions(rawValue: identifier!)!
            var userInfo: [NSObject : AnyObject] = notification.userInfo!
            var word: NSString = userInfo["word"] as NSString
            
            switch action{
            case FlashActions.memory:
                println("memory good")
            case FlashActions.forget:
                createFlashMeaning(word)
            default:
                println("hi good")
            }
        }
        else if notification.category == flashMeaningID {
        }
    }
    
    func lockEvent(string: String) {
        if string == "DEVICE LOCKED" {
            lockCount = 0
        }
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
    
    func registerDeviceLock() {
        Converter.sharedInstance().registerDeviceLock({
            (event: String!) in
            println("event:\(event)")
            NotificationManager.sharedInstance.lockEvent(event)
        })
    }
}