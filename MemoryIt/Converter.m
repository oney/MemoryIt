//
//  Converter.m
//  MemoryIt
//
//  Created by SpoonRocket on 2014/10/14.
//  Copyright (c) 2014年 one. All rights reserved.
//

#import "Converter.h"

@implementation Converter

+ (Converter *)sharedInstance {
    static Converter *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[Converter alloc] init];
    });
    return _sharedClient;
}

static void displayStatusChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    // the "com.apple.springboard.lockcomplete" notification will always come after the "com.apple.springboard.lockstate" notification
    CFStringRef nameCFString = (CFStringRef)name;
    NSString *lockState = (__bridge NSString*)nameCFString;
//    NSLog(@"Darwin notification NAME = %@",name);
    
    if([lockState isEqualToString:@"com.apple.springboard.lockcomplete"])
    {
//        NSLog(@"DEVICE LOCKED");
        [Converter sharedInstance].deviceLockBlock(@"DEVICE LOCKED");
        //Logic to disable the GPS
    }
    else
    {
//        NSLog(@"LOCK STATUS CHANGED");
        [Converter sharedInstance].deviceLockBlock(@"LOCK STATUS CHANGED");
        //Logic to enable the GPS
    }
}

- (void)registerDeviceLock:(DeviceLockBlock)handler
{
    self.deviceLockBlock = handler;
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    displayStatusChanged,
                                    CFSTR("com.apple.springboard.lockcomplete"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    displayStatusChanged,
                                    CFSTR("com.apple.springboard.lockstate"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
}

- (NSString*)pasteboardString
{
    NSString *string = [UIPasteboard generalPasteboard].string;
    if (!string) {
        return @"";
    }
    return string;
}

@end
