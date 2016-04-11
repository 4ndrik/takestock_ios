//
//  UIView+NibLoadView.m
//  takestok
//
//  Created by Artem on 4/8/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "UIView+NibLoadView.h"

@implementation UIView (NibLoadView)

-(instancetype)loadFromXib{
    return [self loadFromXibName:NSStringFromClass([self class])];
}

-(instancetype)loadFromXibName:(NSString*)xibName{
    return [[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil].lastObject;
}

@end
