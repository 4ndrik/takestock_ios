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

@interface AppDelegate ()

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
    
//    [[UISegmentedControl appearance] setTitleTextAttributes:titleBarAttributes forState:UIControlStateNormal];
//    
//    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:OliveMainColor]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Stripe setDefaultPublishableKey:@"pk_test_NCwfKANZ66zUvSwPTY3THQ0m"];
    // Override point for customization after application launch.
    
//    NSArray *fontFamilies = [UIFont familyNames];
//    
//    for (int i = 0; i < [fontFamilies count]; i++)
//    {
//        NSString *fontFamily = [fontFamilies objectAtIndex:i];
//        NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
//        NSLog (@"%@: %@", fontFamily, fontNames);
//    }
    
    [self customizeNavigationBar];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[DB sharedInstance].storedManagedObjectContext save:nil];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
//    [[ServerConnectionHelper sharedInstance] loadRequiredData];
    [[AdvertServiceManager sharedManager] fetchRequiredData];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
