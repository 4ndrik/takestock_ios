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
    UIImage *startImage = [UIImage imageNamed:@"star"];
    int index = 0;
    float width = self.bounds.size.height - 10;
    float space = 10.;
    if (width > (self.bounds.size.width - space * MaxCountOfStars - 1 )/ MaxCountOfStars){
        width = (self.bounds.size.width - space * MaxCountOfStars - 1) / MaxCountOfStars;
    }else{
        space = self.bounds.size.width / 5 - width;
    }
    
    while (_rate > index) {
        [startImage drawInRect:CGRectMake(index / Step * space + index /Step * width, (self.bounds.size.height - width) / 2., width, width)];
        index += Step;
    }
}


@end
