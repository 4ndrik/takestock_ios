//
//  WatchListViewController.h
//  takestok
//
//  Created by Artem on 6/24/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BaseViewController.h"
#import "WatchTableViewCell.h"

@interface WatchListViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, WatchListProtocol>{
    NSMutableArray* _watcArray;
    IBOutlet UITableView* _watchListTableView;
    
    UIRefreshControl *_refreshControl;
    int _page;
    UIActivityIndicatorView* _loadingIndicator;
}

@end
