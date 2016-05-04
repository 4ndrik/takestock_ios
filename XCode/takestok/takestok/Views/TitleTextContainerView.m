//
//  TitleTextContainerView.m
//  takestok
//
//  Created by Artem on 4/13/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TitleTextContainerView.h"

#define CenterPadding 20

@implementation TitleTextContainerView

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    UIFont* textFont = [UIFont fontWithName:_titleFont size:_titleFontSize];
    NSDictionary *attributes = @{ NSFontAttributeName: textFont, NSParagraphStyleAttributeName: paragraphStyle,  NSForegroundColorAttributeName: _titleColor};
    
    float height = [_title boundingRectWithSize:CGSizeMake(self.bounds.size.width/2 - 2.5, self.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:textFont} context:nil].size.height;
    [self.title drawInRect:CGRectMake(0, (self.bounds.size.height - height)/2, self.bounds.size.width/2 - 2.5 - CenterPadding, height) withAttributes:attributes];
    
    CGContextSetFillColorWithColor(context, _textColor.CGColor);
    textFont = [UIFont fontWithName:_textFont size:_textFontSize];
    height = [_text boundingRectWithSize:CGSizeMake(self.bounds.size.width/2 - 2.5, self.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:textFont} context:nil].size.height;
    attributes = @{ NSFontAttributeName: textFont, NSParagraphStyleAttributeName: paragraphStyle,  NSForegroundColorAttributeName: _textColor};
    [self.text drawInRect:CGRectMake(self.bounds.size.width/2 +2.5  - CenterPadding, (self.bounds.size.height - height)/2, self.bounds.size.width/2 - 5. + CenterPadding, height) withAttributes:attributes];
    

}

@end
