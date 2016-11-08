//
//  PayBacsViewController.h
//  takestok
//
//  Created by Artem on 11/8/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BaseViewController.h"

@class TSAdvert;
@class TSOffer;
@class PayDestAddressOfferView;

@interface PayBacsViewController : BaseViewController{
    
    __weak IBOutlet UILabel *_informationLabel;
    TSAdvert* _advert;
    TSOffer* _offer;
    PayDestAddressOfferView* _payView;
}

- (void)setOffer:(TSOffer*)offer withAdvert:(TSAdvert*)advert;

- (IBAction)payByCardAction:(id)sender;
- (IBAction)payByBacsAction:(id)sender;

@end
