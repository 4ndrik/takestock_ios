//
//  PaddingTextField.m
//  takestok
//
//  Created by Artem on 4/7/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "PaddingTextField.h"

@implementation PaddingTextField

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 10);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 10);
}

@end
