//
//  Article.swift
//  MemoryIt
//
//  Created by SpoonRocket on 2014/10/13.
//  Copyright (c) 2014年 one. All rights reserved.
//

import Foundation
import CoreData

@objc(Article)
class Article: NSManagedObject {

    @NSManaged var content: String
    @NSManaged var url: String
    @NSManaged var title: String
    @NSManaged var sentences: NSSet

    class func checkInexist(url: NSString, managedObjectContext:NSManagedObjectContext) -> Bool {
        var fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Article")
        fetchRequest.predicate = NSPredicate(format:"url == '\(url)' ")
        fetchRequest.fetchLimit = 1
        
        var count = managedObjectContext.countForFetchRequest(fetchRequest, error: nil)
        return count == 0
    }
    
    class func find(url: NSString, managedObjectContext:NSManagedObjectContext) -> [AnyObject] {
        var fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Article")
        fetchRequest.predicate = NSPredicate(format:"url == '\(url)' ")
        fetchRequest.fetchLimit = 1
        
        return managedObjectContext.executeFetchRequest(fetchRequest, error: nil)!
    }
    
    class func search(word: NSString, managedObjectContext:NSManagedObjectContext) -> [Article] {
        var fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Article")
        fetchRequest.predicate = NSPredicate(format:"content CONTAINS '\(word)' ")
        
        return managedObjectContext.executeFetchRequest(fetchRequest, error: nil)! as [Article]
    }
    
    class func showAll(managedObjectContext:NSManagedObjectContext) {
        println("showAllArticle")
        var fReq: NSFetchRequest = NSFetchRequest(entityName: "Article")
        fReq.returnsObjectsAsFaults = false
        
        var result = managedObjectContext.executeFetchRequest(fReq, error:nil)
        for resultItem in result! {
            var article = resultItem as Article
            for sentenceObj in article.sentences.allObjects {
                var sentence: Sentence = sentenceObj as Sentence
                NSLog("sentenceObj:%@", sentence.content)
            }
            NSLog("Article:%@", article)
        }
    }
    
    func findWord(word: NSString) -> [NSString] {
        var article: NSString = content
        
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
}
