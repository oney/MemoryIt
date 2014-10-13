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

}
