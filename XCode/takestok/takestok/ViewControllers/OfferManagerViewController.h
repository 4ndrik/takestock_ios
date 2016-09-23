//
//  OfferManagerViewController.h
//  takestok
//
//  Created by Artem on 4/25/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BaseViewController.h"
#import "Advert.h"
#import "OfferTableViewCell.h"

@class TSAdvert;
@class OfferActionView;
@class ShippingInfoActionView;

@interface OfferManagerViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, OfferActionDelegate>{
    NSMutableArray* _offers;
    UIRefreshControl *_refreshControl;
    int _page;
    UIActivityIndicatorView* _loadingIndicator;
    OfferActionView* _offerAlertView;
    ShippingInfoActionView* _shippingInfoActionView;
    
    __weak IBOutlet UITableView *_offersTableView;
}

@property (nonatomic, retain)TSAdvert* advert;

@end
