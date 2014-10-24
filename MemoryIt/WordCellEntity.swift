//
//  WordCellEntity.swift
//  MemoryIt
//
//  Created by SpoonRocket on 2014/10/16.
//  Copyright (c) 2014年 one. All rights reserved.
//

import UIKit

class WordCellEntity: NSObject {
    var paperFoldState: PaperFoldState = PaperFoldState.Default
    var bottomOpen: Bool = false
    var vocabulary: Vocabulary!
    
}
