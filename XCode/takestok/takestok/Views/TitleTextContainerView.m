//
//  TitleTextContainerView.m
//  takestok
//
//  Created by Artem on 4/13/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TitleTextContainerView.h"

@implementation TitleTextContainerView

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    UIFont* textFont = [UIFont fontWithName:_titleFont size:_titleFontSize];
    NSDictionary *attributes = @{ NSFontAttributeName: textFont, NSParagraphStyleAttributeName: paragraphStyle,  NSForegroundColorAttributeName: _titleColor};
    CGSize size = [_title sizeWithFont:textFont constrainedToSize:self.bounds.size lineBreakMode:NSLineBreakByTruncatingTail];
    [_title drawInRect:CGRectMake(0, (self.bounds.size.height - size.height)/2, self.bounds.size.width/2 - 2.5, size.height) withAttributes:attributes];
    
    CGContextSetFillColorWithColor(context, _textColor.CGColor);
    textFont = [UIFont fontWithName:_textFont size:_textFontSize];
    size = [_text sizeWithFont:textFont constrainedToSize:self.bounds.size lineBreakMode:NSLineBreakByTruncatingTail];
    attributes = @{ NSFontAttributeName: textFont, NSParagraphStyleAttributeName: paragraphStyle,  NSForegroundColorAttributeName: _textColor};
    [_text drawInRect:CGRectMake(self.bounds.size.width/2 +2.5, (self.bounds.size.height - size.height)/2, self.bounds.size.width/2 - 5., size.height) withAttributes:attributes];
    

}

@end
