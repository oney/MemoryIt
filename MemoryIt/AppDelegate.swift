//
//  AppDelegate.swift
//  MemoryIt
//
//  Created by SpoonRocket on 2014/10/10.
//  Copyright (c) 2014年 one. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UINavigationControllerDelegate, HATransitionControllerDelegate {
    
    var window: UIWindow?
    var bgTask: BackgroundTask = BackgroundTask()
    var currentContent: NSString = ""
    var transitionController: HATransitionController?
    var navigationController: UINavigationController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        if UIApplication.instancesRespondToSelector(Selector("registerUserNotificationSettings:")) {
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil))
        }
        
        var sideMenu: RESideMenu =  window?.rootViewController as RESideMenu
        navigationController = sideMenu.contentViewController as? UINavigationController
        navigationController?.delegate = self
        var paperViewController: PaperViewController = navigationController?.topViewController as PaperViewController
        NSLog("navigationController:%@", paperViewController)
        transitionController = HATransitionController(collectionView: paperViewController.collectionView)
        transitionController?.delegate = self
        
        
        
//        NotificationManager.sharedInstance.registerNotification()
//        bgTask.startBackgroundTasks(2, target:self, selector: Selector("backgroundCallback:"))
//        NotificationManager.sharedInstance.registerDeviceLock()
        
        
        
        return true
    }
    
    func interactionBeganAtPoint(point: CGPoint) {
        
        var judgeVC: UIViewController? = navigationController?.topViewController
        if judgeVC!.isKindOfClass(PaperViewController) {
            var presentingVC: PaperViewController = navigationController?.topViewController as PaperViewController
            var presentedVC: PaperViewController = presentingVC.nextViewControllerAtPoint(point) as PaperViewController
            navigationController?.pushViewController(presentedVC, animated: true)
        }
        else {
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animationController === transitionController {
            return transitionController
        }
        return nil
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if !fromVC.isKindOfClass(UICollectionViewController) || !toVC.isKindOfClass(UICollectionViewController) {
            return nil
        }
        if transitionController?.hasActiveInteraction == false {
            return nil
        }
        
        transitionController?.navigationOperation = operation
        return transitionController
    }
    
    
    func backgroundCallback(info: AnyObject) {
        NSLog("App in BG, backgroundTimeRemaining %f sec", UIApplication.sharedApplication().backgroundTimeRemaining)
        var paste = Converter.sharedInstance().pasteboardString()
        NSLog("paste:%@", paste)
        if paste != "" {
            if !currentContent.isEqualToString(UIPasteboard.generalPasteboard().string!) {
                currentContent = UIPasteboard.generalPasteboard().string!
                println("new content:\(currentContent)")
                //                        NotificationManager.sharedInstance.forFlash(content)
                DataManager.sharedInstance.detectNewContent(currentContent)
            }
        }
    }
    
    func pasteboardChanged(application: UIApplication) {
        NSLog("pasteboardChanged")
        NotificationManager.sharedInstance.registerDeviceLock()
        
        var locationManager: CLLocationManager = CLLocationManager()
        
        var task : UIBackgroundTaskIdentifier!
        task = application.beginBackgroundTaskWithExpirationHandler({
//            self.pasteboardChanged(application)
            application.endBackgroundTask(task)
        })
        
        if task == UIBackgroundTaskInvalid {
            return
        }
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            locationManager.startUpdatingLocation()
            
            var content :NSString = ""
            var flag = true
            while flag {
                NSLog("App in BG, backgroundTimeRemaining %f sec", application.backgroundTimeRemaining)
                var paste = Converter.sharedInstance().pasteboardString()
                NSLog("paste:%@", paste)
                if paste != "" {
                    if !content.isEqualToString(UIPasteboard.generalPasteboard().string!) {
                        content = UIPasteboard.generalPasteboard().string!
                        println("new content:\(content)")
//                        NotificationManager.sharedInstance.forFlash(content)
                        DataManager.sharedInstance.detectNewContent(content)
                    }
                    flag = false
                    flag = true
                }
                NSThread.sleepForTimeInterval(1)
            }
            application.endBackgroundTask(task)
        })
    }
    
    func applicationWillResignActive(application: UIApplication) {
        println("applicationWillResignActive")
    }

    func applicationDidEnterBackground(application: UIApplication) {
//        pasteboardChanged(application)
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
        println("applicationDidBecomeActive")
    }

    func applicationWillTerminate(application: UIApplication) {
        println("applicationWillTerminate")
        DataManager.sharedInstance.saveContext()
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        println("didRegisterUserNotificationSettings")
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        println("handleActionWithIdentifier")
        NSLog("notification:%@", notification)
        NotificationManager.sharedInstance.handleActionWithIdentifier(identifier, notification: notification)
        NotificationManager.sharedInstance.registerDeviceLock()
        completionHandler()
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        println("didReceiveLocalNotification")
    }

    

}

