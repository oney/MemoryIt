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
        var notification :UILocalNotification = UILocalNotification()
        notification.fireDate = NSDate()
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = "You copy \(string)"
        notification.alertAction = "Open"
        notification.hasAction = true
        notification.applicationIconBadgeNumber = 0
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    class func forArticle(string :NSString) {
        var notification :UILocalNotification = UILocalNotification()
        notification.fireDate = NSDate()
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = "Article: \(string)"
        notification.alertAction = "Open"
        notification.hasAction = true
        notification.applicationIconBadgeNumber = 0
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
}