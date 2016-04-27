//
//  OfferTitleView.h
//  takestok
//
//  Created by Artem on 4/25/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BackgroundImageView;
@class TopBottomStripesLabel;

@interface OfferTitleView : UIView

@property (weak, nonatomic) IBOutlet BackgroundImageView *advertImageView;
@property (weak, nonatomic) IBOutlet TopBottomStripesLabel *advertTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *advertAvailableLabel;
@property (weak, nonatomic) IBOutlet UILabel *advertDataCreated;

+(float)defaultSize;

@end
