//
//  TextFieldBorderBottom.m
//  takestok
//
//  Created by Artem on 4/7/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TextFieldBorderBottom.h"

@implementation TextFieldBorderBottom

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, LightGrayColor.CGColor);
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 1.f);
    
    CGContextMoveToPoint(context, 0.0f, self.frame.size.height - 1); //start at this point
    
    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height - 1); //draw to this point
    
    // and now draw the Path!
    CGContextStrokePath(context);
}

@end
