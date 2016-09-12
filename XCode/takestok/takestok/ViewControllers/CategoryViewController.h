//
//  CategoryViewController.h
//  takestok
//
//  Created by Artem on 6/1/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSAdvertCategory;
@class TSBaseDictionaryEntity;

@protocol CategoryProtocol <NSObject>

-(void)categorySelected:(TSBaseDictionaryEntity*)category;

@end

@interface CategoryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    NSArray* _items;
    BOOL _subCategories;
}

@property (assign)id<CategoryProtocol>delegate;
-(void)setCategory:(TSAdvertCategory*)category;
- (IBAction)close:(id)sender;

@end
