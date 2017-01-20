//
//  BuyingViewController.h
//  takestok
//
//  Created by Artem on 4/20/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BaseViewController.h"
#import "OfferActionDelegate.h"

@interface BuyingViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray* _offers;
    NSMutableDictionary* _adverts;
    
    BOOL _loading;
    UIRefreshControl *_refreshControl;
    int _page;
    UIActivityIndicatorView* _loadingIndicator;
    
    __weak IBOutlet UITableView *_buyingTableView;
}

@end
