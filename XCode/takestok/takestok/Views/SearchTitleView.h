//
//  SearchTitleView.h
//  takestok
//
//  Created by Artem on 4/11/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTitleView : UICollectionReusableView{
    
}
@property (weak, nonatomic) IBOutlet UILabel *countResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *searchWordLabel;
@property (weak, nonatomic) IBOutlet UIButton *browseCategoriesButton;

+(float)defaultHeight;

@end
