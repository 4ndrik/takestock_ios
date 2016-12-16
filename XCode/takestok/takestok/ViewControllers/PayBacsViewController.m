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
#import "UIView+NibLoadView.h"
#import "TSOffer.h"

#import "OfferServiceManager.h"
#import "PayCardViewController.h"

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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:PAY_BY_CARD_SEGUE]) {
        PayCardViewController* vc = (PayCardViewController*)segue.destinationViewController;
        [vc setOffer:_offer withAdvert:_advert];
    }else{
        [super prepareForSegue:segue sender:sender];
    }
}

- (void)setOffer:(TSOffer*)offer withAdvert:(TSAdvert*)advert alreadyPayed:(BOOL)isPayed{
    _offer = offer;
    _advert = advert;
    id m = self.view;
    self.title = isPayed ? @"BACS DETAILS" : @"PAY BY BACS";
    _lastLabel.hidden = isPayed;
    _payByBacsButton.hidden = isPayed;
    _payByCardButton.hidden = isPayed;
    _infoButton.hidden = isPayed;
    
}

-(void)payByBacs{
    [self showLoading];
    [[OfferServiceManager sharedManager] payByBacsOffer:_offer compleate:^(NSError *error) {
        [self hideLoading];
        NSString* title = @"";
        NSString* message = @"Thanks. Please let us know if you have any problems paying by bacs.";
        if (error){
            title = @"Error";
            message = ERROR_MESSAGE(error);
        }
        
        [self showOkAlert:title text:message compleate:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

- (IBAction)payByBacsAction:(id)sender {
    [self payByBacs];
}

@end
