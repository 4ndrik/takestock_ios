//
//  BuyingViewController.h
//  takestok
//
//  Created by Artem on 4/20/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BaseViewController.h"
#import "OfferActionDelegate.h"

@class OfferActionView;
@interface BuyingViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, OfferActionDelegate>{
    NSArray* _offers;
    OfferActionView* _offerAlertView;
    
    __weak IBOutlet UITableView *_buyingTableView;
}

@end
