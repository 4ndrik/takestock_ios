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
    __weak IBOutlet UILabel *_lastLabel;
    __weak IBOutlet UIImageView *_infoButton;
    __weak IBOutlet UIButton *_payByCardButton;
    __weak IBOutlet UIButton *_payByBacsButton;
    TSAdvert* _advert;
    TSOffer* _offer;
}

- (void)setOffer:(TSOffer*)offer withAdvert:(TSAdvert*)advert alreadyPayed:(BOOL)isPayed;
- (IBAction)payByBacsAction:(id)sender;

@end
