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
#import "User.h"
#import "REFrostedViewController.h"
#import "LoginViewController.h"

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
    actionItem.title = @"Selling";
    actionItem.action = @selector(showSelling:);
    [_menuItems addObject:actionItem];
    
    actionItem = [[ActionItem alloc] init];
    actionItem.title = @"Buying";
    actionItem.action = @selector(showBuying:);
    [_menuItems addObject:actionItem];
    
    actionItem = [[ActionItem alloc] init];
    actionItem.title = @"About us";
    actionItem.action = @selector(showAboutUs:);
    [_menuItems addObject:actionItem];
    
}

-(void)refreshUserData{
    if (!_userView){
        _userView = [UserMenuView loadFromXib];
        _userView.frame = CGRectMake(0, 0, 0, [UserMenuView defaulHeight]);
        
        UITapGestureRecognizer* showUserProfileGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserProfile:)];
        [_userView addGestureRecognizer:showUserProfileGesture];
    }
    
    User* me = [User getMe];
    if (me){
        [_userView.userPhotoImageView loadImage:me.image];
        _userView.userNameLabel.text = me.userName;
    }else{
        _userView.userPhotoImageView.image = [UIImage imageNamed:@"addImageIco"];
        _userView.userNameLabel.text = @"Sign in";
    }
    _menuTableView.tableHeaderView = _userView;
    
}

#pragma mark - UITableViewDelegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_menuItems count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActionItem* action = [_menuItems objectAtIndex:indexPath.row];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MenuActionTableViewCell"];
    cell.textLabel.text = action.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ActionItem* action = [_menuItems objectAtIndex:indexPath.row];
    if (action.action)
        [self performSelector:action.action withObject:nil];
    
}

-(BOOL)checkUserLogin{
    if ([User getMe]){
        return YES;
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *controller = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentViewController:controller animated:YES completion:nil];
        return NO;
    }
}

-(void)showHome:(id)sender{
    self.frostedViewController.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [self.frostedViewController hideMenuViewController];
}

-(void)showUserProfile:(id)owner{
    if([self checkUserLogin]){
        self.frostedViewController.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileController"];
        [self.frostedViewController hideMenuViewController];
    }
}

-(void)showSelling:(id)owner{
    if([self checkUserLogin]){
        self.frostedViewController.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SellingController"];
        [self.frostedViewController hideMenuViewController];
    }
}

-(void)showBuying:(id)owner{
    if([self checkUserLogin]){
        self.frostedViewController.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BuyingController"];
        [self.frostedViewController hideMenuViewController];
    }
}

-(void)showAboutUs:(id)owner{
    self.frostedViewController.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUsController"];
    [self.frostedViewController hideMenuViewController];
}

@end
