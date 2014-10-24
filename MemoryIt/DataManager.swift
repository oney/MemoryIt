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
    
    func runnn() {
        Article.showAll(self.managedObjectContext!)
    }
    
    func detectNewContent(string: NSString) {
        if string.isUrl() {
            detectUrl(string)
        }
        else if string.isArticle() {
            
        }
        else {
            detectVocabulary(string)
        }
    }
    
    func detectUrl(urlString: NSString) {
        
        var inexist: Bool = Article.checkInexist(urlString, managedObjectContext: self.managedObjectContext!)
        if inexist {
            var URL: NSURL = NSURL(string: urlString)!;
            var request: NSURLRequest = NSURLRequest(URL: URL, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 60)
            var response: NSURLResponse?
            var error: NSError?
            var data: NSData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)!
            
            parseHtml(urlString, data: data)
        }
        else {
            var array = Article.find(urlString, managedObjectContext: self.managedObjectContext!)
            var firstArticle: Article = array[0] as Article
            NotificationManager.sharedInstance.forArticle(firstArticle.title)
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
        var string: NSString = NSString(data: responseObject as NSData, encoding: NSUTF8StringEncoding)!
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

        NotificationManager.sharedInstance.forArticle(title)
    }
    
    
    func detectVocabulary(string: NSString) {
        NotificationManager.sharedInstance.forVocabulary(string)
        return
        var findVocabulary: [Vocabulary] = Vocabulary.find(string, managedObjectContext: self.managedObjectContext!)
        if findVocabulary.count == 0 {
            var vocabulary: Vocabulary = NSEntityDescription.insertNewObjectForEntityForName("Vocabulary", inManagedObjectContext: self.backgroundContext!) as Vocabulary
            vocabulary.word = string
            vocabulary.meaning = "heeee"
            saveContext()
            findVocabulary = Vocabulary.find(string, managedObjectContext: self.managedObjectContext!)
        }
        var vocabulary: Vocabulary = findVocabulary[0]
        
        var articles: [Article] = Article.search(string, managedObjectContext: self.managedObjectContext!)
        for article in articles {
            NSLog("ffffArticle: \(article.url) ")
            var sentences: [NSString] = article.findWord(string)
            for sentenceString in sentences {
                
                var sentence: Sentence = NSEntityDescription.insertNewObjectForEntityForName("Sentence", inManagedObjectContext: self.backgroundContext!) as Sentence
                
                var vocabularys: NSMutableSet = sentence.mutableSetValueForKey("vocabularys")
                vocabularys.addObject(vocabulary)
                sentence.content = sentenceString
                sentence.article = self.backgroundContext!.objectWithID(article.objectID) as Article
                
                saveContext()
            }
        }
        
        NotificationManager.sharedInstance.forFlash(string)
        
        Vocabulary.showAll(self.managedObjectContext!)
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
            return "No content"
        }
        else {
            var body: TFHppleElement = array[0] as TFHppleElement
            var bodyPlain = body.raw.stringByStrippingHTML()
            return bodyPlain
        }
    }
    
    func removeString(string: NSString, by pattern: NSString) -> NSString {
        var error: NSError?
        var regex: NSRegularExpression = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive, error: &error)!
        return regex.stringByReplacingMatchesInString(string, options: NSMatchingOptions.ReportProgress, range: NSMakeRange(0, string.length), withTemplate: "")
    }
    
    func findWord2(word: NSString, by article: NSString) {
        var find: NSString = "\\.\\s[^(\\.)]*communication[^(\\.)]*\\.\\s" // \.\s[^(\.)]*communication[^(\.)]*\.\s
        var error: NSError?
        var regex: NSRegularExpression = NSRegularExpression(pattern: "", options: NSRegularExpressionOptions.CaseInsensitive, error: &error)!
        var matches: NSArray = regex.matchesInString(article, options: NSMatchingOptions.ReportProgress, range: NSMakeRange(0, article.length))
        
        for match in matches {
            var result: NSTextCheckingResult = match as NSTextCheckingResult
            NSLog("range1:%@", result.rangeAtIndex(0))
            NSLog("range2:%@", result.range)
            var string = article.substringWithRange(result.range)
            NSLog("match:%@", string)
        }
    }
    
    func lockToFlash() {
        println("lockToFlash")
        NotificationManager.sharedInstance.forFlash("kk1")
        NotificationManager.sharedInstance.forFlash("kk2")
        NotificationManager.sharedInstance.forFlash("kk3")
    }
    
    func unlockToClear() {
        println("unlockToClear")
        NotificationManager.sharedInstance.clearAllFlash()
    }
    
}