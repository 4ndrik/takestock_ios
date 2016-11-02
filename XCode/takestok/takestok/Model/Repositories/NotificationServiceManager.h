//
//  NotificationServiceManager.h
//  takestok
//
//  Created by Artem on 10/31/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TSNotification;

@interface NotificationServiceManager : NSObject{
    NSMutableArray* _notifications;
}

+(instancetype)sharedManager;
-(NSArray*)getNotifications;

-(void)receivedNotification:(NSDictionary*)notificationDic;
-(void)reloadNotifications;

@end
