//
//  AppDelegate.m
//  takestok
//
//  Created by Artem on 4/6/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "AppDelegate.h"
#import "UIImage+ExtendedImage.h"
#import "ServerConnectionHelper.h"
#import "DB.h"
#import <Stripe/Stripe.h>
#import "AdvertServiceManager.h"
#import "UserServiceManager.h"
#import "OfferServiceManager.h"
#import <UserNotifications/UserNotifications.h>
#import "AppSettings.h"
#import "NotificationServiceManager.h"

@import Firebase;
@import FirebaseMessaging;

@interface AppDelegate ()<FIRMessagingDelegate, UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


-(void)customizeNavigationBar{
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [titleBarAttributes setValue:BrandonGrotesqueBold16 forKey:NSFontAttributeName];
    
    [[UINavigationBar appearance] setTitleTextAttributes:titleBarAttributes];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:OliveMainColor];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:OliveMainColor]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Stripe setDefaultPublishableKey:@"pk_test_vqadhDOynhijTjKgj7sEnybl"];
    [FIRApp configure];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!granted)
                NSLog(@"Push notifications disabled by user.");
        }];
        [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
        [[FIRMessaging messaging] setRemoteMessageDelegate:self];
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [self customizeNavigationBar];
    
    return YES;
}

- (void)connectToFcm {
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM.");
        }
    }];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeSandbox];
    [[UserServiceManager sharedManager] sendAPNSToken];
}

- (void)tokenRefreshNotification:(NSNotification *)notification {
    [self connectToFcm];
    [[UserServiceManager sharedManager] sendAPNSToken];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[FIRMessaging messaging] disconnect];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [[NotificationServiceManager sharedManager] receivedNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [[NotificationServiceManager sharedManager] receivedNotification:userInfo];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [[AdvertServiceManager sharedManager] fetchRequiredData];
    [[UserServiceManager sharedManager] fetchRequiredData];
    [[OfferServiceManager sharedManager] fetchRequiredData];
    [[UserServiceManager sharedManager] sendAPNSToken];
}



@end
