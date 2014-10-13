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
        var URL: NSURL = NSURL(string: urlString);
        NSLog("URL:%@", URL)
        
        var request: NSURLRequest = NSURLRequest(URL: URL, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 60)
        var response: NSURLResponse?
        var error: NSError?
        var data: NSData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)!
        
//        NSLog("myData=%@", data)
        self.parseHtml(urlString, data: data)
        
        
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
        var string: NSString = NSString(data: responseObject as NSData, encoding: NSUTF8StringEncoding)
        string = removeString(string, by: "<script\\b[^<]*(?:(?!<\\/script>)<[^<]*)*<\\/script>")
        
        println("string:\(string)")
        
        var data: NSData = string.dataUsingEncoding(NSUTF8StringEncoding)!
        
        var doc: TFHpple = TFHpple(HTMLData: data)
        var titles = doc.searchWithXPathQuery("//title")
        var title: NSString = self.fetchTitle(titles)
        
        println("titles:\(title)")
        
        var bodys: NSArray = doc.searchWithXPathQuery("//body")
        var body: NSString = self.fetchBody(bodys)
        println("plain:\(body)")
        
        self.generateUrlNotification(title)
        
        var inexist: Bool = checkUrlInexist(urlString)
        if !inexist {
            return
        }
        
//        var article: Article = NSEntityDescription.insertNewObjectForEntityForName("Article", inManagedObjectContext: self.backgroundContext!) as Article
//        article.content = body
//        article.title = title
//        article.url = urlString
//        self.saveContext()
    }
    
    
    func detectVocabulary(string: NSString) {
        generateNotification(string)
        
        var inexist: Bool = checkVocabularyInexist(string)
        if !inexist {
            return
        }
        
        var vocabulary: Vocabulary = NSEntityDescription.insertNewObjectForEntityForName("Vocabulary", inManagedObjectContext: self.backgroundContext!) as Vocabulary
        vocabulary.word = string
        vocabulary.meaning = "heeee"
        self.saveContext()
        showAllVocabulary()
    }
    
    func showAllVocabulary() {
        var fReq: NSFetchRequest = NSFetchRequest(entityName: "Vocabulary")
        
        var sorter: NSSortDescriptor = NSSortDescriptor(key: "word" , ascending: false)
        fReq.sortDescriptors = [sorter]
        fReq.returnsObjectsAsFaults = false
        
        var result = self.managedObjectContext!.executeFetchRequest(fReq, error:nil)
        for resultItem in result! {
            var vocabulary = resultItem as Vocabulary
            NSLog("Vocabulary: \(vocabulary.word) ")
        }
    }
    
    func checkVocabularyInexist(vocabulary: NSString) -> Bool {
        var fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Vocabulary")
        fetchRequest.predicate = NSPredicate(format:"word CONTAINS '\(vocabulary)' ")
        fetchRequest.fetchLimit = 1
        
        var count = self.managedObjectContext!.countForFetchRequest(fetchRequest, error: nil)
        return count == 0
    }
    
    func checkUrlInexist(url: NSString) -> Bool {
        var fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Article")
        fetchRequest.predicate = NSPredicate(format:"url CONTAINS '\(url)' ")
        fetchRequest.fetchLimit = 1
        
        var count = self.managedObjectContext!.countForFetchRequest(fetchRequest, error: nil)
        return count == 0
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
}