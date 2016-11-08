//
//  PayBacsViewController.m
//  takestok
//
//  Created by Artem on 11/8/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "PayBacsViewController.h"
#import "TSAdvert.h"
#import "TSOffer.h"
#import "PayDestAddressOfferView.h"
#import "UIView+NibLoadView.h"
#import "TSOffer.h"
#import <Stripe/Stripe.h>
#import "OfferServiceManager.h"

@interface PayBacsViewController ()

@end

@implementation PayBacsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableAttributedString*  attributedText = [[NSMutableAttributedString alloc] initWithString:@"If paying by BACS please send the full balance to the bank account below and use " attributes:@{NSFontAttributeName:_informationLabel.font}];
    [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:_advert.name attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:14]}]];
    [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@" as advertised as the reference." attributes:@{NSFontAttributeName:_informationLabel.font}]];
    
    _informationLabel.attributedText = attributedText;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_informationLabel sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setOffer:(TSOffer*)offer withAdvert:(TSAdvert*)advert{
    _offer = offer;
    _advert = advert;
}

-(BOOL)validatePayment{
    NSMutableString* message = [[NSMutableString alloc] init];
    if (![_payView.cardControl isValid]){
        [message appendString:@"Card data invalid."];
    }
    
    if (message.length > 0){
        [self showOkAlert:@"" text:message compleate:nil];
        return NO;
        
    }else{
        return YES;
    }
}

-(void)makePayment:(id)owner{
    if ([self validatePayment]){
        [self showLoading];
        [[STPAPIClient sharedClient]
         createTokenWithCard:_payView.cardControl.cardParams
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
                     }
                     else{
                         [self hidePaymentView:nil];
                     }
                     [self showOkAlert:title text:message compleate:^{
                         [self.navigationController popViewControllerAnimated:YES];
                     }];
                 }];
             }
         }];
    }
}

-(void)payByBacs{
    [self showLoading];
    [[OfferServiceManager sharedManager] payByBacsOffer:_offer compleate:^(NSError *error) {
        [self hideLoading];
        NSString* title = @"";
        NSString* message = @"Payment made successfully.";
        if (error){
            title = @"Error";
            message = ERROR_MESSAGE(error);
        }
        
        [self showOkAlert:title text:message compleate:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

-(void)hidePaymentView:(id)owner{
    [_payView removeFromSuperview];
    _payView = nil;
}

- (IBAction)payByCardAction:(id)sender {
    _payView = [PayDestAddressOfferView loadFromXib];
    _payView.frame = self.navigationController.view.bounds;
    _payView.tag = [_offer.ident intValue];
    [_payView.payButton setTitle:[NSString stringWithFormat:@"PAY £%.02f", _offer.price * _offer.quantity] forState:UIControlStateNormal];
    
    [_payView.payButton addTarget:self action:@selector(makePayment:) forControlEvents:UIControlEventTouchUpInside];
    [_payView.cancelButton addTarget:self action:@selector(hidePaymentView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationController.view addSubview:_payView];
    
    [_payView.cardControl becomeFirstResponder];
}

- (IBAction)payByBacsAction:(id)sender {
    [self payByBacs];
}

@end
