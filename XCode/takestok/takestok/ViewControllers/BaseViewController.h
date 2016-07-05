//
//  BaseViewController.h
//  takestok
//
//  Created by Artem on 4/8/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController{
    UIView* _loadingView;
    UILabel* _noItemsLabel;
}

- (IBAction)hideKeyboard:(id)sender;
- (IBAction)showMenu;

-(void)showLoading;
-(void)hideLoading;

-(void)showNoItems;
-(void)hideNoItems;

-(BOOL)checkUserLogin;

-(void)showOkAlert:(NSString*)title text:(NSString*)text;

@end
