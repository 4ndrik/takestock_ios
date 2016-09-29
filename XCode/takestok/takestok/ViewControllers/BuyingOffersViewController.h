//
//  BuyingOffersViewController.h
//  takestok
//
//  Created by Artem on 9/27/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BaseViewController.h"
#import "OfferActionDelegate.h"

@class TSAdvert;
@class TSOffer;
@class PayDestAddressOfferView;

@interface BuyingOffersViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, OfferActionDelegate>{
    __weak IBOutlet UITableView *_offersTableView;
    TSAdvert* _advert;
    NSArray* _offers;
    
    PayDestAddressOfferView* _payView;
}

-(void)setAdvert:(TSAdvert*)advert andOffer:(TSOffer*)offer;

@end
