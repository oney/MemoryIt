//
//  Sentence.swift
//  MemoryIt
//
//  Created by SpoonRocket on 2014/10/14.
//  Copyright (c) 2014年 one. All rights reserved.
//

import Foundation
import CoreData

@objc(Sentence)
class Sentence: NSManagedObject {

    @NSManaged var content: String
    @NSManaged var vocabularys: NSSet
    @NSManaged var article: Article

}
