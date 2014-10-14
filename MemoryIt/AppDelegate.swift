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
    
    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        if UIApplication.instancesRespondToSelector(Selector("registerUserNotificationSettings:")) {
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil))
        }
        
//        var body: NSString = ". Apple is a multinational corporation that designs, develops, and sells consumer electronics, computer software, and personal computers. Its product portfolio includes mobile communication and media devices, personal computers. Portable digital music communication, software, services, peripherals, networking solutions, third-party digital content, and applications related to its products. "
//
//        var array = DataManager.sharedInstance.findWord("communication", by: body)
//        NSLog("array:%@", array)
        
//        var string: NSString = "yoo ewerjil yoo ejiwrj"
//        var error: NSError?
//        var removeScriptRegex: NSRegularExpression = NSRegularExpression(pattern: "yoo", options: NSRegularExpressionOptions.CaseInsensitive, error: &error)
//        var removeScriptString = removeScriptRegex.stringByReplacingMatchesInString(string, options: NSMatchingOptions.ReportProgress, range: NSMakeRange(0, string.length), withTemplate: "")
//        println("string:\(removeScriptString)")
        
        
//        DataManager.sharedInstance.runnn()
        
        registerNotification()
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
        
        dispatch_async(dispatch_get_main_queue(), {
            var content :NSString = ""
            for var i = 0; i < 1000; i++ {
                if !content.isEqualToString(UIPasteboard.generalPasteboard().string!) {
                    content = UIPasteboard.generalPasteboard().string!
                    println("new content:\(content)")
                    self.forFlash(content)
//                    DataManager.sharedInstance.detectNewContent(content)
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
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
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
        //        notification.userInfo = ["uoo": "kkkk"]
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
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        println("didRegisterUserNotificationSettings")
//        scheduleNotification()
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
            println("handleActionWithIdentifier")
//            NSLog("notification:%@", notification)
        
            // Handle notification action *****************************************
//            if notification.category == "NormalFlashIdentifier" {
//                
//                let action:Actions = Actions.fromRaw(identifier!)!
//                let counter = Counter();
//                
//                switch action{
//                    
//                case Actions.increment:
//                    counter++
//                    
//                case Actions.decrement:
//                    counter--
//                    
//                case Actions.reset:
//                    counter.currentTotal = 0
//                    
//                }
//            }
        
            completionHandler()
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        println("didReceiveLocalNotification")
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.one.MemoryIt" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("MemoryIt", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("MemoryIt.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError.errorWithDomain("YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

}

