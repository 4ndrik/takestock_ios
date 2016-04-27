//
//  OfferTableViewCell.h
//  takestok
//
//  Created by Artem on 4/25/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>


@class BackgroundImageView;
@interface OfferTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet BackgroundImageView *autorPicImageView;
@property (weak, nonatomic) IBOutlet UILabel *autorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

//TODO: need change. Hardcoded for Mike
@property (weak, nonatomic) IBOutlet UIView *myRequestView;
@property (weak, nonatomic) IBOutlet UILabel *myQuantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *myPricelabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIView *operationsView;

@end
