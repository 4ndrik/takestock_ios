//
//  PaddingLabel.h
//  takestok
//
//  Created by Artem on 4/20/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaddingLabel : UILabel

@property (nonatomic) IBInspectable NSInteger leftInset;
@property (nonatomic) IBInspectable NSInteger rightInset;
@property (nonatomic) IBInspectable NSInteger topInset;
@property (nonatomic) IBInspectable NSInteger bottomInset;

@end
