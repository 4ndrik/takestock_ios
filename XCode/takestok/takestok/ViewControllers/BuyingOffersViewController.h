//
//  BuyingOffersViewController.h
//  takestok
//
//  Created by Artem on 9/27/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BaseViewController.h"
#import "OfferActionDelegate.h"
#import <MessageUI/MessageUI.h>

@class TSAdvert;
@class TSOffer;
@class PayDestAddressOfferView;
@class OfferActionView;

@interface BuyingOffersViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, OfferActionDelegate, MFMailComposeViewControllerDelegate>{
    __weak IBOutlet UITableView *_offersTableView;
    TSAdvert* _advert;
    NSMutableArray* _offers;
    OfferActionView* _offerAlertView;
}

-(void)setAdvert:(TSAdvert*)advert andOffer:(TSOffer*)offer;

@end
