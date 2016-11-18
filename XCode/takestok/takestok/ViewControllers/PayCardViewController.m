//
//  PayCardViewController.m
//  takestok
//
//  Created by Artem on 11/18/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "PayCardViewController.h"
#import "TSAdvert.h"
#import "TSOffer.h"
#import <Stripe/Stripe.h>
#import "OfferServiceManager.h"
#import "STPPaymentCardTextField.h"
#import "UserServiceManager.h"
#import "AppSettings.h"
#import "PayBacsViewController.h"

@interface PayCardViewController ()

@end

@implementation PayCardViewController

- (void)setOffer:(TSOffer*)offer withAdvert:(TSAdvert*)advert{
    _offer = offer;
    _advert = advert;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _userEmailLabel.text = [UserServiceManager sharedManager].getMe.email;
    _stripeLabel.text = [NSString stringWithFormat:@"There is a %i%% surcharge by Stripe", [AppSettings getStripeFee]];
    [_payButton setTitle:[NSString stringWithFormat:@"PAY £%.2f", _offer.price * _offer.quantity + (_offer.price * _offer.quantity * [AppSettings getStripeFee] / 100.0)] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)validatePayment{
    NSMutableString* message = [[NSMutableString alloc] init];
    if (![_cardControl isValid]){
        [message appendString:@"Card data invalid."];
    }
    if (message.length > 0){
        [self showOkAlert:@"" text:message compleate:nil];
        return NO;
    }else{
        return YES;
    }
}

- (IBAction)payByCardAction:(id)sender{
    if ([self validatePayment]){
        [self showLoading];
        [[STPAPIClient sharedClient]
         createTokenWithCard:_cardControl.cardParams
         completion:^(STPToken *token, NSError *error) {
             if (error) {
                 [self hideLoading];
                 [self showOkAlert:@"" text:[error localizedDescription] compleate:nil] ;
             } else {
                 [[OfferServiceManager sharedManager] makePayment:_offer token:token compleate:^(NSError *error) {
                     [self hideLoading];
                     NSString* title = @"";
                     NSString* message = @"Payment made successfully.";
                     if (error){
                         title = @"Error";
                         message = ERROR_MESSAGE(error);
                         [self showOkAlert:title text:message compleate:nil];
                     }else{
                        [self showOkAlert:title text:message compleate:^{
                            id vc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
                            if ([vc isKindOfClass:[PayBacsViewController class]]){
                                vc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3];
                            }
                            [self.navigationController popToViewController:vc animated:YES];
                        }];
                     }
                 }];
             }
         }];
    }
}

@end
