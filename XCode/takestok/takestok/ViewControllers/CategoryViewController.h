//
//  CategoryViewController.h
//  takestok
//
//  Created by Artem on 6/1/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Category;

@protocol CategoryProtocol <NSObject>

-(void)categorySelected:(Category*)category;

@end

@interface CategoryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    NSArray* _categories;
}

@property (assign)id<CategoryProtocol>delegate;
- (IBAction)close:(id)sender;

@end
