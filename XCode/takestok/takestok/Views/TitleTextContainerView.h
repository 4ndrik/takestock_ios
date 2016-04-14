//
//  TitleTextContainerView.h
//  takestok
//
//  Created by Artem on 4/13/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface TitleTextContainerView : UIView{
    
}

@property (nonatomic) IBInspectable UIColor* titleColor;
@property (nonatomic) IBInspectable NSString* titleFont;
@property (nonatomic) IBInspectable NSInteger titleFontSize;
@property (nonatomic) IBInspectable NSString* title;

@property (nonatomic) IBInspectable UIColor* textColor;
@property (nonatomic) IBInspectable NSString* textFont;
@property (nonatomic) IBInspectable NSInteger textFontSize;
@property (nonatomic) IBInspectable NSString* text;

@end
