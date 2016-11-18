//
//  PayCardViewController.h
//  takestok
//
//  Created by Artem on 11/18/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BaseViewController.h"

@class TSAdvert;
@class TSOffer;
@class STPPaymentCardTextField;

@interface PayCardViewController : BaseViewController{
    TSAdvert* _advert;
    TSOffer* _offer;
    
    
    
    __weak IBOutlet STPPaymentCardTextField *_cardControl;
    __weak IBOutlet UILabel *_userEmailLabel;
    __weak IBOutlet UILabel *_stripeLabel;
    __weak IBOutlet UIButton *_payButton;
    
}

- (void)setOffer:(TSOffer*)offer withAdvert:(TSAdvert*)advert;
- (IBAction)payByCardAction:(id)sender;

@end
