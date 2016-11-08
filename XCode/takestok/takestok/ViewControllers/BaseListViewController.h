//
//  BaseListViewController.h
//  takestok
//
//  Created by Artem on 10/6/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BaseViewController.h"
#import "AdvertTableViewCell.h"

@interface BaseListViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, AdvertListProtocol>{
    NSMutableArray* _advertsArray;
    IBOutlet UITableView* _advertListTableView;
    BOOL _needUpdate;
    BOOL _loading;
    
    UIRefreshControl *_refreshControl;
    int _page;
    UIActivityIndicatorView* _loadingIndicator;
}

-(void)loadData;
-(void)reloadData:(id)owner;

@end
