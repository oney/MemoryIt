//
//  Vocabulary.swift
//  MemoryIt
//
//  Created by SpoonRocket on 2014/10/10.
//  Copyright (c) 2014年 one. All rights reserved.
//

import Foundation
import CoreData

class Vocabulary: NSManagedObject {

    @NSManaged var word: String
    @NSManaged var meaning: String
    @NSManaged var sentence: String
    @NSManaged var state: Int16

}
