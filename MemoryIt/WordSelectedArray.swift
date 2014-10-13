//
//  WordSelectedArray.swift
//  MemoryIt
//
//  Created by SpoonRocket on 2014/10/13.
//  Copyright (c) 2014年 one. All rights reserved.
//

import UIKit

class WordSelectedArray: NSObject {
    var selectedRows:[Int] = []
    override init() {
        super.init()
    }
    func toggleSelect(row: Int) {
        for (index, selectedRow) in enumerate(selectedRows) {
            if row == selectedRow {
                selectedRows.removeAtIndex(index)
                return
            }
        }
        selectedRows.append(row)
    }
    func isSelected(row: Int) -> Bool {
        for selectedRow in selectedRows {
            if row == selectedRow {
                return true
            }
        }
        return false
    }
}
