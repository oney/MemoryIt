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
}