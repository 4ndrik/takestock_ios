//
//  PaddingLabel.m
//  takestok
//
//  Created by Artem on 4/20/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "PaddingLabel.h"

@implementation PaddingLabel

- (CGSize)intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    if (size.width > 0 && size.height > 0)
        size = CGSizeMake(size.width + _leftInset + _rightInset, size.height + _topInset + _bottomInset);
    return size;
}

@end
