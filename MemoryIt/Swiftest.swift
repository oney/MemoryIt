//
//  Swiftest.swift
//  MemoryIt
//
//  Created by SpoonRocket on 2014/10/29.
//  Copyright (c) 2014年 one. All rights reserved.
//

import Foundation
import UIKit

infix operator <- { associativity left precedence 120 }
func <- (inout left: UILabel, right: UIFont) {
    left.font = right
}