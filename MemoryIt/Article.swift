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
            NSLog("Article: \(article.url) ")
        }
    }
}
