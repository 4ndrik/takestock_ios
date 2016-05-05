//
//  RatingView.h
//  takestok
//
//  Created by Artem on 5/5/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface RatingView : UIView{
    float _rate;
}

@property (nonatomic) IBInspectable float rate;

@end
