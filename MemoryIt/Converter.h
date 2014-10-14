//
//  Converter.h
//  MemoryIt
//
//  Created by SpoonRocket on 2014/10/14.
//  Copyright (c) 2014年 one. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^DeviceLockBlock) (NSString *event);

@interface Converter : NSObject

@property (strong, nonatomic) DeviceLockBlock deviceLockBlock;

+ (Converter *)sharedInstance;
- (void)registerDeviceLock:(DeviceLockBlock)handler;
- (NSString*)pasteboardString;

@end
