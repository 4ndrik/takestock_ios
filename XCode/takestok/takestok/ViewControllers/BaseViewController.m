//
//  BaseViewController.m
//  takestok
//
//  Created by Artem on 4/8/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BaseViewController.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import "REFrostedViewController.h"
#import "HomeViewController.h"
#import "AdvertDetailViewController.h"
#import "OfferManagerViewController.h"
#import "QAViewController.h"
#import "CreateAdvertViewController.h"
#import "SearchViewController.h"
#import "UserDetailsViewController.h"
#import "TSBaseDictionaryEntity.h"
#import "UserServiceManager.h"
#import "ShippingOfferViewController.h"
#import "DeliveryInfoViewController.h"
#import "RKNotificationHub.h"
#import "TSUserEntity.h"

@implementation BaseViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardApeared:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDisapeared:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    _loadingView = [[UIView alloc] init];
    _loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    UIView* blackPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    blackPanel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
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
    [self.navigationController setNavigationBarHidden:[self isKindOfClass:[HomeViewController class]] animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    if (!self.navigationController.navigationBarHidden && [self.navigationController.viewControllers firstObject] == self){
        UIButton* menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        [menuButton setImage:[UIImage imageNamed:@"menuWhiteButtonIco"] forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem* menuBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
        self.navigationItem.leftBarButtonItem = menuBarButtonItem;
        
        _notificationsBadge = [[RKNotificationHub alloc]initWithBarButtonItem:menuBarButtonItem]; // sets the count to 0
        [_notificationsBadge moveCircleByX:10 Y:0];
        [self refreshBadge];
    }
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
        UINavigationController* categoryNC = (UINavigationController*)segue.destinationViewController;
        CategoryViewController* categoryhVC = (CategoryViewController*)categoryNC.viewControllers.firstObject;
        if ([[self class]conformsToProtocol:@protocol(CategoryProtocol)])
            categoryhVC.delegate = (id<CategoryProtocol>)self;
    } else if ([segue.identifier isEqualToString:SEARCH_ADVERT_SEGUE]) {
        SearchViewController* searchVC = (SearchViewController*)segue.destinationViewController;
        if ([sender isKindOfClass:[TSBaseDictionaryEntity class]]){
            [searchVC setCategory:sender];
        }else if ([sender isKindOfClass:[NSString class]]){
            [searchVC setSearchText:sender];
        }
    } else if ([segue.identifier isEqualToString:USER_DETAILS_SEGUE]){
        UserDetailsViewController* udVC = (UserDetailsViewController*)segue.destinationViewController;
        [udVC setUser:sender];
    } else if ([segue.identifier isEqualToString:OFFERS_SHIPPING_SEQUE]){
        ShippingOfferViewController* udVC = (ShippingOfferViewController*)segue.destinationViewController;
        [udVC setOffer:sender];
    }else if ([segue.identifier isEqualToString:OFFERS_DISPATCH_INFO_SEQUE]){
        DeliveryInfoViewController* udVC = (DeliveryInfoViewController*)segue.destinationViewController;
        [udVC setOffer:sender];
    }
}

-(void)keyboardApeared:(id)owner{
    _keyboardShown = YES;
}

-(void)keyboardDisapeared:(id)owner{
    _keyboardShown = NO;
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
    [self.navigationController.view endEditing:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return _keyboardShown;
}

-(void)showLoading{
    [self hideKeyboard:nil];
    if (!_loadingView.superview){
        UIView* superView = self.navigationController.view;
        if (!superView)
            superView = self.view;
        _loadingView.frame = superView.bounds;
        [superView addSubview:_loadingView];
    }
}

-(void)hideLoading{
    [_loadingView removeFromSuperview];
}

-(void)showNoItems{
    if (!_noItemsLabel){
        _noItemsLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
        _noItemsLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _noItemsLabel.backgroundColor = [UIColor clearColor];
        _noItemsLabel.textColor = GrayColor;
        _noItemsLabel.font = HelveticaNeue14;
        _noItemsLabel.text = @"No items";
        _noItemsLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_noItemsLabel];
    }else{
        [self.view bringSubviewToFront:_noItemsLabel];
    }
}

-(void)hideNoItems{
    [_noItemsLabel removeFromSuperview];
    _noItemsLabel = nil;
}

- (void)showMenu
{
    [self hideKeyboard:nil];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
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

-(void)showOkAlert:(NSString*)title text:(NSString*)text compleate:(void(^)())compleate{
    UIAlertController * alertController =   [UIAlertController
                                             alertControllerWithTitle:title
                                             message:text
                                             preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
        if (compleate)
            compleate();
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)refreshBadge{
//    [_notificationsBadge setCount:[UserServiceManager sharedManager].getMe.no]
}

@end
