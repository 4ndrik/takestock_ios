//
//  BaseViewController.h
//  takestok
//
//  Created by Artem on 4/8/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RKNotificationHub;
@interface BaseViewController : UIViewController<UIGestureRecognizerDelegate>{
    UIView* _loadingView;
    UILabel* _noItemsLabel;
    
    RKNotificationHub* _notificationsBadge;
    BOOL _keyboardShown;
}

- (IBAction)hideKeyboard:(id)sender;
- (IBAction)showMenu;

-(void)showLoading;
-(void)hideLoading;

-(void)showNoItems;
-(void)hideNoItems;

-(BOOL)checkUserLogin;

-(void)showOkAlert:(NSString*)title text:(NSString*)text compleate:(void(^)())compleate;

-(void)refreshBadge;

@end
