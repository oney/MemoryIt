//
//  NSString.swift
//  MemoryIt
//
//  Created by SpoonRocket on 2014/10/14.
//  Copyright (c) 2014年 one. All rights reserved.
//

import Foundation

extension NSString {
    func isUrl() -> Bool {
        var pattern = "(http|https):\\/\\/(www\\.)?"
        var error: NSError?
        var regex: NSRegularExpression = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive, error: &error)
        var result: Int = regex.numberOfMatchesInString(self, options: NSMatchingOptions.Anchored, range: NSMakeRange(0, self.length))
        return result > 0
    }
    
    func isArticle() -> Bool {
        return false
    }
    
    func stringByStrippingHTML() -> NSString {
        var r: NSRange
        var s: NSString = self.copy() as NSString
        
        r = s.rangeOfString("<[^>]+>", options: NSStringCompareOptions.RegularExpressionSearch)
        while (r.location != NSNotFound) {
            s = s.stringByReplacingCharactersInRange(r, withString: ". ")
            r = s.rangeOfString("<[^>]+>", options: NSStringCompareOptions.RegularExpressionSearch)
        }
        return s
    }
}