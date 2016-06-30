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
#import "HomeViewController.h"
#import "AdvertDetailViewController.h"
#import "OfferManagerViewController.h"
#import "QAViewController.h"
#import "CreateAdvertViewController.h"
#import "SearchViewController.h"
#import "UserDetailsViewController.h"

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
    [self.navigationController setNavigationBarHidden:[self isKindOfClass:[HomeViewController class]] animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:ADVERT_OFFERS_SEGUE]) {
        OfferManagerViewController* vc = (OfferManagerViewController*)segue.destinationViewController;
        [vc setAdvert:sender];
    }else if ([segue.identifier isEqualToString:ADVERT_QUESTIONS_SEGUE]) {
        QAViewController* vc = (QAViewController*)segue.destinationViewController;
        [vc setAdvert:sender];
    }else if([segue.identifier isEqualToString:ADVERT_DETAIL_SEGUE]) {
        AdvertDetailViewController* vc = (AdvertDetailViewController*)segue.destinationViewController;
        [vc setAdvert:sender];
    }else if([segue.identifier isEqualToString:EDIT_ADVERT_SEGUE]) {
        CreateAdvertViewController* vc = (CreateAdvertViewController*)segue.destinationViewController;
        [vc setAdvert:sender];
    } else if ([segue.identifier isEqualToString:CATEGORIES_SEGUE]) {
        CategoryViewController* categoryhVC = (CategoryViewController*)segue.destinationViewController;
        if ([[self class]conformsToProtocol:@protocol(CategoryProtocol)])
            categoryhVC.delegate = (id<CategoryProtocol>)self;
    } else if ([segue.identifier isEqualToString:SEARCH_ADVERT_SEGUE]) {
        SearchViewController* searchVC = (SearchViewController*)segue.destinationViewController;
        if ([sender isKindOfClass:[Category class]]){
            [searchVC setCategory:sender];
        }else if ([sender isKindOfClass:[NSString class]]){
            [searchVC setSearchText:sender];
        }
    } else if ([segue.identifier isEqualToString:USER_DETAILS_SEGUE]){
        UserDetailsViewController* udVC = (UserDetailsViewController*)segue.destinationViewController;
        [udVC setUser:sender];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:CREATE_ADVERT_SEGUE]){
        return [self checkUserLogin];
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

- (void)showMenu
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}

-(BOOL)checkUserLogin{
    if ([User getMe]){
        return YES;
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *controller = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:LOGIN_CONTROLLER];
        [self presentViewController:controller animated:YES completion:nil];
        return NO;
    }
}

@end
