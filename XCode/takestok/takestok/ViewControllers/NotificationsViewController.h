//
//  NotificationsViewController.h
//  takestok
//
//  Created by Artem on 11/1/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BaseViewController.h"

@interface NotificationsViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>{
    NSArray* _notifications;
    __weak IBOutlet UITableView *_tableView;
}

@end
