//
//  Vocabulary.swift
//  MemoryIt
//
//  Created by SpoonRocket on 2014/10/10.
//  Copyright (c) 2014年 one. All rights reserved.
//

import Foundation
import CoreData

@objc(Vocabulary)
class Vocabulary: NSManagedObject {

    @NSManaged var word: String
    @NSManaged var meaning: String
    @NSManaged var sentences: NSSet
    @NSManaged var state: Int16

    class func checkInexist(word: NSString, managedObjectContext: NSManagedObjectContext) -> Bool {
        var fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Vocabulary")
        fetchRequest.predicate = NSPredicate(format:"word == '\(word)' ")
        fetchRequest.fetchLimit = 1
        var count = managedObjectContext.countForFetchRequest(fetchRequest, error: nil)
        return count == 0
    }
    
    class func find(url: NSString, managedObjectContext:NSManagedObjectContext) -> [Vocabulary] {
        var fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Vocabulary")
        fetchRequest.predicate = NSPredicate(format:"word == '\(url)' ")
        fetchRequest.fetchLimit = 1
        
        return managedObjectContext.executeFetchRequest(fetchRequest, error: nil)! as [Vocabulary]
    }
    
    class func showAll(managedObjectContext: NSManagedObjectContext) {
        var fReq: NSFetchRequest = NSFetchRequest(entityName: "Vocabulary")
        
        var sorter: NSSortDescriptor = NSSortDescriptor(key: "word" , ascending: false)
        fReq.sortDescriptors = [sorter]
        fReq.returnsObjectsAsFaults = false
        
        var result = managedObjectContext.executeFetchRequest(fReq, error:nil)
        for resultItem in result! {
            var vocabulary = resultItem as Vocabulary
            for sentenceObj in vocabulary.sentences.allObjects {
                var sentence = sentenceObj as Sentence
                NSLog("sentence:%@", sentence.article)
            }
            NSLog("Vocabulary:%@", vocabulary)
        }
    }
}
