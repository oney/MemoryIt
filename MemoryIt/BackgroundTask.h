//
//  BackgroundTask.h
//  MemoryIt
//
//  Created by SpoonRocket on 2014/10/15.
//  Copyright (c) 2014年 one. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface BackgroundTask : NSObject
{
    __block UIBackgroundTaskIdentifier bgTask;
    __block dispatch_block_t expirationHandler;
    __block NSTimer * timer;
    __block AVAudioPlayer *player;
    
    NSInteger timerInterval;
    id target;
    SEL selector;
}

- (void) startBackgroundTasks:(NSInteger)time_  target:(id)target_ selector:(SEL)selector_;
- (void) stopBackgroundTask;

@end
