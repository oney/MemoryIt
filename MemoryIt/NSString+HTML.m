//
//  NSString+HTML.m
//  MemoryIt
//
//  Created by SpoonRocket on 2014/10/13.
//  Copyright (c) 2014年 one. All rights reserved.
//

#import "NSString+HTML.h"

@implementation NSString (HTML)

- (NSString *)stringByStrippingHTML
{
    NSString *newString = [[@"" componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    
    
    
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

@end
