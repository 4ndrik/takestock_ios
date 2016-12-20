//
//  OfferManagerViewController.h
//  takestok
//
//  Created by Artem on 4/25/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BaseViewController.h"
#import "OfferTableViewCell.h"
#import <MessageUI/MessageUI.h>

@class TSAdvert;
@class OfferActionView;
@class ShippingInfoActionView;

@interface OfferManagerViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, OfferActionDelegate, MFMailComposeViewControllerDelegate>{
    NSMutableArray* _offers;
    UIRefreshControl *_refreshControl;
    int _page;
    UIActivityIndicatorView* _loadingIndicator;
    OfferActionView* _offerAlertView;
    ShippingInfoActionView* _shippingInfoActionView;
    BOOL _loading;
    
    __weak IBOutlet UITableView *_offersTableView;
}

@property (nonatomic, retain)TSAdvert* advert;
@property (nonatomic, retain)NSNumber* advertId;
@property (nonatomic, retain)NSNumber* offerId;

@end
