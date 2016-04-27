//
//  TopBottomStripesLabel.m
//  takestok
//
//  Created by Artem on 4/25/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TopBottomStripesLabel.h"

@implementation TopBottomStripesLabel

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, _borderColor.CGColor);
    
    CGContextSetLineWidth(context, _borderWidth);
    
    CGContextMoveToPoint(context, 0.0f, _borderWidth);
    CGContextAddLineToPoint(context, self.frame.size.width, _borderWidth);
    
    CGContextMoveToPoint(context, 0.0f, self.frame.size.height - _borderWidth);
    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height - 1);
    
    // and now draw the Path!
    CGContextStrokePath(context);
}

@end
