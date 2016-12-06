//
//  NotificationServiceManager.m
//  takestok
//
//  Created by Artem on 10/31/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "NotificationServiceManager.h"
#import "AppSettings.h"
#import "TSNotification.h"
#import "UserServiceManager.h"
#import "TSUserEntity.h"

@implementation NotificationServiceManager

#define notificationStorgeFile [[AppSettings getStorageFolder] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-notification.data", [UserServiceManager sharedManager].getMe.ident]]

static NotificationServiceManager *_manager = nil;

+(instancetype)sharedManager
{
    @synchronized([NotificationServiceManager class])
    {
        return _manager?_manager:[[self alloc] init];
    }
    return nil;
}

+(id)alloc {
    
    @synchronized([NotificationServiceManager class])
    {
        NSAssert(_manager == nil, @"Attempted to allocate a second instance of a singleton.");
        _manager = [super alloc];
        [_manager reloadNotifications];
        return _manager;
    }
    return nil;
}

-(id)init{
    self = [super init];
    return self;
}

-(NSArray*)getNotifications{
    return _notifications;
}

-(TSNotification*)receivedNotification:(NSDictionary*)notificationDic{
    TSNotification* not = [TSNotification objectWithDictionary:notificationDic];
    NSInteger index = [_notifications indexOfObjectPassingTest:^BOOL(TSNotification*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj.notId isEqualToString:not.notId];
    }];
    if (index == NSNotFound){
        [_notifications addObject:not];
        [NSKeyedArchiver archiveRootObject:_notifications toFile:notificationStorgeFile];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATED_NOTIFICATION object:nil];
    }else{
        not = nil;
    }
    return not;
}

-(void)reloadNotifications{
    _notifications = nil;
    if ([UserServiceManager sharedManager].getMe){
        _notifications = [NSKeyedUnarchiver unarchiveObjectWithFile:notificationStorgeFile];
    }
    if (!_notifications){
        _notifications = [[NSMutableArray alloc] init];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATED_NOTIFICATION object:nil];
}

-(void)removeNotification:(TSNotification*)notification{
    [_notifications removeObject:notification];
    [NSKeyedArchiver archiveRootObject:_notifications toFile:notificationStorgeFile];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATED_NOTIFICATION object:nil];

}

@end
