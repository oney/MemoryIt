//
//  DataManager.swift
//  MemoryIt
//
//  Created by SpoonRocket on 2014/10/10.
//  Copyright (c) 2014年 one. All rights reserved.
//

import Foundation
import CoreData

private let _DataManagerSharedInstance = DataManager()

class DataManager  {
    
    let store: CoreDataStore = CoreDataStore()
    
    class var sharedInstance : DataManager {
        
        return _DataManagerSharedInstance
    }
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        let coordinator = self.store.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    lazy var backgroundContext: NSManagedObjectContext? = {
        let coordinator = self.store.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var backgroundContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        backgroundContext.persistentStoreCoordinator = coordinator
        return backgroundContext
        }()
    
    func saveContext (context: NSManagedObjectContext) {
        var error: NSError? = nil
        if context.hasChanges && !context.save(&error) {
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
    }
    
    func saveContext () {
        self.saveContext( self.backgroundContext! )
    }
    
    func detectNewContent(string: NSString) {
        if isUrl(string) {
            detectUrl(string)
        }
        else if isArticle(string) {
            
        }
        else {
            detectVocabulary(string)
        }
    }
    
    func isUrl(string: NSString) -> Bool {
        var pattern = "(http|https):\\/\\/(www\\.)?"
        var error: NSError?
        var regex: NSRegularExpression = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive, error: &error)
        var result: Int = regex.numberOfMatchesInString(string, options: NSMatchingOptions.Anchored, range: NSMakeRange(0, string.length))
        return result > 0
    }
    
    func isArticle(string: NSString) -> Bool {
        return false
    }
    
    func detectUrl(urlString: NSString) {
        
        var inexist: Bool = Article.checkInexist(urlString, managedObjectContext: self.managedObjectContext!)
        if inexist {
            var URL: NSURL = NSURL(string: urlString);
            var request: NSURLRequest = NSURLRequest(URL: URL, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 60)
            var response: NSURLResponse?
            var error: NSError?
            var data: NSData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)!
            
            parseHtml(urlString, data: data)
        }
        else {
            var array = Article.find(urlString, managedObjectContext: self.managedObjectContext!)
            var firstArticle: Article = array[0] as Article
            self.generateUrlNotification(firstArticle.title)
        }
        
        
//        var request: NSURLRequest = NSURLRequest(URL: URL)
//        var operation: AFHTTPRequestOperation = AFHTTPRequestOperation(request: request)
//        operation.setCompletionBlockWithSuccess({
//            (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
//            self.parseHtml(urlString, data: responseObject)
//            
//            }, failure: {
//                (operation: AFHTTPRequestOperation!, error: NSError!) in
//                println("error")
//        })
//        operation.start()
        
    }
    
    func parseHtml(urlString: NSString, data responseObject: AnyObject!) {
        println("parseHtml:\(urlString)")
        var string: NSString = NSString(data: responseObject as NSData, encoding: NSUTF8StringEncoding)
        string = removeString(string, by: "<script\\b[^<]*(?:(?!<\\/script>)<[^<]*)*<\\/script>")
        
        var data: NSData = string.dataUsingEncoding(NSUTF8StringEncoding)!
        
        var doc: TFHpple = TFHpple(HTMLData: data)
        var titles = doc.searchWithXPathQuery("//title")
        var title: NSString = self.fetchTitle(titles)
//        println("titles:\(title)")
        
        var bodys: NSArray = doc.searchWithXPathQuery("//body")
        var body: NSString = self.fetchBody(bodys)
        println("plain:\(body)")
        
        var article: Article = NSEntityDescription.insertNewObjectForEntityForName("Article", inManagedObjectContext: self.backgroundContext!) as Article
        article.url = urlString
        article.title = title
        article.content = body
        saveContext()
        
        Article.showAll(self.managedObjectContext!)

        self.generateUrlNotification(title)
    }
    
    
    func detectVocabulary(string: NSString) {
        
        var inexist: Bool = Vocabulary.checkInexist(string, managedObjectContext: self.managedObjectContext!)
        if inexist {
            var vocabulary: Vocabulary = NSEntityDescription.insertNewObjectForEntityForName("Vocabulary", inManagedObjectContext: self.backgroundContext!) as Vocabulary
            vocabulary.word = string
            vocabulary.meaning = "heeee"
            self.saveContext()
        }
        
        var articles: [Article] = Article.search(string, managedObjectContext: self.managedObjectContext!)
        for article in articles {
            NSLog("ffffArticle: \(article.url) ")
        }
        
        generateNotification(string)
        
        Vocabulary.showAll(self.managedObjectContext!)
    }
    
    func generateNotification(string :NSString) {
        var notification :UILocalNotification = UILocalNotification()
        notification.fireDate = NSDate()
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = "You copy \(string)"
        notification.alertAction = "Open"
        notification.hasAction = true
        notification.applicationIconBadgeNumber = 0
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func generateUrlNotification(string :NSString) {
        var notification :UILocalNotification = UILocalNotification()
        notification.fireDate = NSDate()
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = "Article: \(string)"
        notification.alertAction = "Open"
        notification.hasAction = true
        notification.applicationIconBadgeNumber = 0
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    
    
    func fetchTitle(array: NSArray) -> NSString {
        if array.count == 0 {
            return "No title"
        }
        else {
            var first: TFHppleElement = array[0] as TFHppleElement
            var string = first.text()
            string = (string.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) as NSArray).componentsJoinedByString("")
            string = string.stringByReplacingOccurrencesOfString("\t", withString: "")
            return string
        }
    }
    
    func fetchBody(array: NSArray) -> NSString {
        if array.count == 0 {
            return "No Content"
        }
        else {
            var body: TFHppleElement = array[0] as TFHppleElement
            var bodyPlain = body.raw.stringByStrippingHTML()
            return bodyPlain
        }
    }
    
    func removeString(string: NSString, by pattern: NSString) -> NSString {
        var error: NSError?
        var regex: NSRegularExpression = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive, error: &error)
        return regex.stringByReplacingMatchesInString(string, options: NSMatchingOptions.ReportProgress, range: NSMakeRange(0, string.length), withTemplate: "")
    }
    
    func findWord(word: NSString, by article: NSString) -> [NSString] {
        var error: NSError?
        var regex: NSRegularExpression = NSRegularExpression(pattern: word, options: NSRegularExpressionOptions.CaseInsensitive, error: &error)
        var matches: NSArray = regex.matchesInString(article, options: NSMatchingOptions.ReportProgress, range: NSMakeRange(0, article.length))
        
        
        var collect: [NSString] = []
        for match in matches {
            var result: NSTextCheckingResult = match as NSTextCheckingResult
            var forward: NSString = article.substringWithRange(NSMakeRange(0, result.range.location))
//            NSLog("forward:%@", forward)
            var forwardRange: NSRange = forward.rangeOfString(". ", options: NSStringCompareOptions.BackwardsSearch)
            forward = forward.substringWithRange(NSMakeRange(forwardRange.location+forwardRange.length, forward.length-(forwardRange.location+forwardRange.length)))
            
            
            var backwardStart = result.range.location + result.range.length
            var backward: NSString = article.substringWithRange(NSMakeRange(backwardStart, article.length-backwardStart))
            var backwardRange: NSRange = backward.rangeOfString(". ")
            backward = backward.substringWithRange(NSMakeRange(0, backwardRange.location+1))
            
            var sentence = "\(forward)\(word)\(backward)"
            collect.append(sentence)
        }
        return collect
    }
    
    func findWord2(word: NSString, by article: NSString) {
        var find: NSString = "\\.\\s[^(\\.)]*communication[^(\\.)]*\\.\\s" // \.\s[^(\.)]*communication[^(\.)]*\.\s
        var error: NSError?
        var regex: NSRegularExpression = NSRegularExpression(pattern: "", options: NSRegularExpressionOptions.CaseInsensitive, error: &error)
        var matches: NSArray = regex.matchesInString(article, options: NSMatchingOptions.ReportProgress, range: NSMakeRange(0, article.length))
        
        for match in matches {
            var result: NSTextCheckingResult = match as NSTextCheckingResult
            NSLog("range1:%@", result.rangeAtIndex(0))
            NSLog("range2:%@", result.range)
            var string = article.substringWithRange(result.range)
            NSLog("match:%@", string)
        }
    }
}