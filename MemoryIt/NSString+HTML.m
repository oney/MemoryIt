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
    NSString *string = @"Here is an example string HELLO ";
    
    NSRange rangeToSearch = NSMakeRange(0, [string length] - 1); // get a range without the space character
    NSRange rangeOfSecondToLastSpace = [string rangeOfString:@" " options:NSBackwardsSearch range:rangeToSearch];

    
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@". "];
    return s;
}

@end
