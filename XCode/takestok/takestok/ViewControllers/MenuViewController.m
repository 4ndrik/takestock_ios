//
//  MenuViewController.m
//  takestok
//
//  Created by Artem on 6/13/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "MenuViewController.h"
#import "ActionItem.h"
#import "BackgroundImageView.h"
#import "UserMenuView.h"
#import "UIView+NibLoadView.h"
#import "TSUserEntity.h"
#import "REFrostedViewController.h"
#import "LoginViewController.h"
#import "AppSettings.h"
#import "UserServiceManager.h"
#import "NotificationServiceManager.h"

@implementation MenuViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initializeMenu];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshUserData];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _userView.frame = CGRectMake(0, 0, _menuTableView.bounds.size.width, [UserMenuView defaulHeight]);
}

-(void)initializeMenu{
    _menuItems = [NSMutableArray array];
    
    ActionItem* actionItem = [[ActionItem alloc] init];
    actionItem.title = @"Home";
    actionItem.action = @selector(showHome:);
    [_menuItems addObject:actionItem];
    
    actionItem = [[ActionItem alloc] init];
    actionItem.title = @"Dashboard";
    [_menuItems addObject:actionItem];
    
    actionItem = [[ActionItem alloc] init];
    actionItem.title = @"Overview";
    actionItem.action = @selector(showOverview:);
    [_menuItems addObject:actionItem];
    
    actionItem = [[ActionItem alloc] init];
    actionItem.title = @"Notifications";
    actionItem.action = @selector(showNotifications:);
    [_menuItems addObject:actionItem];
    
    actionItem = [[ActionItem alloc] init];
    actionItem.title = @"Selling";
    actionItem.action = @selector(showSelling:);
    [_menuItems addObject:actionItem];
    
    actionItem = [[ActionItem alloc] init];
    actionItem.title = @"Buying";
    actionItem.action = @selector(showBuying:);
    [_menuItems addObject:actionItem];
    
    actionItem = [[ActionItem alloc] init];
    actionItem.title = @"Legal information";
    [_menuItems addObject:actionItem];
    
    actionItem = [[ActionItem alloc] init];
    actionItem.title = @"About us";
    actionItem.action = @selector(showAboutUs:);
    [_menuItems addObject:actionItem];
    
    actionItem = [[ActionItem alloc] init];
    actionItem.title = @"Contact us";
    actionItem.action = @selector(showContactUs:);
    [_menuItems addObject:actionItem];
    
    actionItem = [[ActionItem alloc] init];
    actionItem.title = @" Legal information";
    actionItem.action = @selector(showLegalInfo:);
    [_menuItems addObject:actionItem];
    
}

-(void)refreshUserData{
    if (!_userView){
        _userView = [UserMenuView loadFromXib];
        _userView.frame = CGRectMake(0, 0, 0, [UserMenuView defaulHeight]);
        
        UITapGestureRecognizer* showUserProfileGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserProfile:)];
        [_userView addGestureRecognizer:showUserProfileGesture];
    }
    
    TSUserEntity* me = [[UserServiceManager sharedManager] getMe];
    if (me){
        [_userView.userPhotoImageView loadImage:me.photo];
        _userView.userNameLabel.text = me.userName;
        _userView.logoutButton.hidden = NO;
        [_userView.logoutButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        [_userView.logoutButton addTarget:self action:@selector(logOut:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        _userView.userPhotoImageView.image = [UIImage imageNamed:@"addImageIco"];
        _userView.userNameLabel.text = @"Sign in";
        _userView.logoutButton.hidden = YES;
    }
    _menuTableView.tableHeaderView = _userView;
    
}

#pragma mark - UITableViewDelegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_menuItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActionItem* action = [_menuItems objectAtIndex:indexPath.row];
    return action.action ? 46. : 20.;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActionItem* action = [_menuItems objectAtIndex:indexPath.row];
    UITableViewCell* cell;
    if (action.action){
        cell = [tableView dequeueReusableCellWithIdentifier:@"MenuActionTableViewCell"];
        UILabel* label = (UILabel*)[cell viewWithTag:1980];
        label.text = action.title;
        [cell viewWithTag:1981].hidden = _menuItems.count != indexPath.row + 1 && ((ActionItem*)[_menuItems objectAtIndex:indexPath.row + 1]).action == nil;
        
    }else{
    
    
    cell = [tableView dequeueReusableCellWithIdentifier:action.action ? @"MenuActionTableViewCell" : @"MenuSectionTableViewCell"];
    cell.textLabel.text = action.title;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ActionItem* action = [_menuItems objectAtIndex:indexPath.row];
    if (action.action){
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:action.action withObject:nil];
        #pragma clang diagnostic pop
    }
    
}

-(BOOL)checkUserLogin{
    if ([[UserServiceManager sharedManager] getMe]){
        return YES;
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:MAIN_STORYBOARD bundle:nil];
        LoginViewController *controller = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:LOGIN_CONTROLLER];
        [self presentViewController:controller animated:YES completion:nil];
        return NO;
    }
}

-(void)showHome:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:ADVERT_STORYBOARD bundle:nil];
    self.frostedViewController.contentViewController = [storyboard instantiateViewControllerWithIdentifier:HOME_CONTROLLER];
    [self.frostedViewController hideMenuViewController];
}

-(void)showUserProfile:(id)owner{
    if([self checkUserLogin]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:USER_STORYBOARD bundle:nil];
        self.frostedViewController.contentViewController = [storyboard instantiateViewControllerWithIdentifier:USER_PROFILE_CONTROLLER];
        [self.frostedViewController hideMenuViewController];
    }
}

-(void)showSelling:(id)owner{
    if([self checkUserLogin]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:SELLING_STORYBOARD bundle:nil];
        self.frostedViewController.contentViewController = [storyboard instantiateViewControllerWithIdentifier:SELLING_CONTROLLER];
        [self.frostedViewController hideMenuViewController];
    }
}

-(void)showBuying:(id)owner{
    if([self checkUserLogin]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:BUYING_STORYBOARD bundle:nil];
        self.frostedViewController.contentViewController = [storyboard instantiateViewControllerWithIdentifier:BUYING_CONTROLLER];
        [self.frostedViewController hideMenuViewController];
    }
}

-(void)showOverview:(id)owner{
    if([self checkUserLogin]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:LISTS_STORYBOARD bundle:nil];
        self.frostedViewController.contentViewController = [storyboard instantiateViewControllerWithIdentifier:OVERVIEW_CONTROLLER];
        [self.frostedViewController hideMenuViewController];
    }
}

-(void)showAboutUs:(id)owner{
    self.frostedViewController.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:ABOUT_US_CONTROLLER];
    [self.frostedViewController hideMenuViewController];
}

-(void)showContactUs:(id)owner{
    self.frostedViewController.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:CONTACT_US_CONTROLLER];
    [self.frostedViewController hideMenuViewController];
}

-(void)showLegalInfo:(id)owner{
    self.frostedViewController.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:LEGAL_INFO_CONTROLLER];
    [self.frostedViewController hideMenuViewController];
}

-(void)showNotifications:(id)owner{
    if([self checkUserLogin]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:LISTS_STORYBOARD bundle:nil];
        self.frostedViewController.contentViewController = [storyboard instantiateViewControllerWithIdentifier:NOTIFICATION_CONTROLLER];
        [self.frostedViewController hideMenuViewController];
    }
}

-(void)logOut:(id)owner{
    UIAlertController* logoutController = [UIAlertController alertControllerWithTitle:@"" message:@"Are you sure you want to logout?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* closeAction = [UIAlertAction
                                  actionWithTitle:@"NO"
                                  style:UIAlertActionStyleCancel
                                  handler:^(UIAlertAction * action)
                                  {
                                      [logoutController dismissViewControllerAnimated:YES completion:nil];
                                      
                                  }];
    
    UIAlertAction* logOutAction = [UIAlertAction
                                  actionWithTitle:@"YES"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                      [AppSettings setUserId:0];
                                      [[UserServiceManager sharedManager] removeAPNSToken];
                                      [self refreshUserData];
                                      [self showHome:nil];
                                      [[NotificationServiceManager sharedManager] reloadNotifications];
                                      [logoutController dismissViewControllerAnimated:YES completion:nil];
                                      
                                  }];
    
    
    [logoutController addAction:closeAction];
    [logoutController addAction:logOutAction];
    
    [self presentViewController:logoutController animated:YES completion:nil];
}

@end
