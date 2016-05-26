//
//  RatingView.m
//  takestok
//
//  Created by Artem on 5/5/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "RatingView.h"

#define MaxCountOfStars 5
#define Step 2

@implementation RatingView
@synthesize rate = _rate;

- (void)drawRect:(CGRect)rect {
    UIImage *starImage = [UIImage imageNamed:@"star"];
    UIImage *starEmptyImage = [UIImage imageNamed:@"starEmpty"];
    
    float width = self.bounds.size.height - 10;
    float space = 10.;
    if (width > (self.bounds.size.width - space * MaxCountOfStars - 1 )/ MaxCountOfStars){
        width = (self.bounds.size.width - space * MaxCountOfStars - 1) / MaxCountOfStars;
    }else{
        space = self.bounds.size.width / 5 - width;
    }
    
    for(int i = 0; i < MaxCountOfStars * Step; i+=Step){
        if (i < _rate){
            [starImage drawInRect:CGRectMake(i / Step * space + i /Step * width, (self.bounds.size.height - width) / 2., width, width)];
        }else{
            [starEmptyImage drawInRect:CGRectMake(i / Step * space + i /Step * width, (self.bounds.size.height - width) / 2., width, width)];
        }
    }
}


@end
