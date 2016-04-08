//
//  CALayer+BorderUIColor.m
//  toogletoys
//
//  Created by Serbin Artem on 7/25/14.
//  Copyright (c) 2014 organization. All rights reserved.
//

#import "CALayer+BorderUIColor.h"

@implementation CALayer (BorderUIColor)

-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
