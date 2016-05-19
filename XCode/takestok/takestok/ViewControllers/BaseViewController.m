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
    [_loadingView addSubview:blackPanel];
    UIActivityIndicatorView* activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activityIndicator startAnimating];
    activityIndicator.center = _loadingView.center;
    [_loadingView addSubview:activityIndicator];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:[self isKindOfClass:[HomeViewController class]] animated:YES];
        
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" "
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:nil
                                                                                action:nil];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (![User getMe])
    {
        if ([identifier isEqualToString:@"SellSegue"] ||
            [identifier isEqualToString:@"SellingSegue"] ||
            [identifier isEqualToString:@"BuyingSegue"] ||
            [identifier isEqualToString:@"MyProfileSegue"]
            )
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *controller = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            [self presentViewController:controller animated:YES completion:nil];
            return NO;
        }
    }
    return YES;
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

@end
