//
//  BaseViewController.m
//  takestok
//
//  Created by Artem on 4/8/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BaseViewController.h"
#import "HomeViewController.h"
#import "User.h"
#import "LoginViewController.h"
#import "REFrostedViewController.h"

@implementation BaseViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    _loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
    _loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _loadingView.backgroundColor = [UIColor clearColor];
    UIView* blackPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    blackPanel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    blackPanel.layer.cornerRadius = 3.;
    blackPanel.center = _loadingView.center;
    blackPanel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [_loadingView addSubview:blackPanel];
    UIActivityIndicatorView* activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activityIndicator startAnimating];
    activityIndicator.center = _loadingView.center;
    activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [_loadingView addSubview:activityIndicator];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.navigationController.viewControllers firstObject] == self){
        UIButton* menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        [menuButton setImage:[UIImage imageNamed:@"menuWhiteButtonIco"] forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem* menuBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
        self.navigationItem.leftBarButtonItem = menuBarButtonItem;
    }
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (IBAction)hideKeyboard:(id)sender {
    [self.view endEditing:YES];
}

-(void)showLoading{
    [self hideKeyboard:nil];
    if (!_loadingView.superview)
        [self.view addSubview:_loadingView];
}

-(void)hideLoading{
    [_loadingView removeFromSuperview];
}

- (void)showMenu
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}

@end
