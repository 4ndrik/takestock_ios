//
//  MainThreadRecursiveLock.h
//  takestok
//
//  Created by Artem on 5/13/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainThreadRecursiveLock : NSRecursiveLock

-(void)waitUntilDone;

@end
