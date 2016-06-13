//
//  MenuViewController.h
//  takestok
//
//  Created by Artem on 6/13/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserMenuView;
@interface MenuViewController : UIViewController<UITabBarDelegate, UITableViewDataSource>{
    NSMutableArray* _menuItems;
    UserMenuView* _userView;
    __weak IBOutlet UITableView *_menuTableView;
    
}

@end
