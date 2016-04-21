//
//  SellingViewControllers.h
//  takestok
//
//  Created by Artem on 4/20/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BaseViewController.h"

@interface SellingViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>{
    NSArray* _adverts;
    __weak IBOutlet UITableView *_sellingTableView;
}

@end
