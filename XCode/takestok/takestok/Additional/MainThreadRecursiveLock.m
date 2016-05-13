//
//  MainThreadRecursiveLock.m
//  takestok
//
//  Created by Artem on 5/13/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "MainThreadRecursiveLock.h"

@implementation MainThreadRecursiveLock

-(void)lock{
    if ([NSThread isMainThread]){
        [super lock];
    }else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [super lock];
        });
    }
}

-(void)unlock{
    if ([NSThread isMainThread]){
        [super unlock];
    }else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [super unlock];
        });
    }
}

-(void)waitUntilDone{
    NSAssert(![NSThread isMainThread], @"Wait dictionaries can not work in the main thred");
    while (![super tryLock]) {
        sleep(0.1);
    }
    [super unlock];
}

@end
