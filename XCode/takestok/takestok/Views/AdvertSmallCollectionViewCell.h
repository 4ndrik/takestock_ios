//
//  AdvertSmallCollectionViewCell.h
//  takestok
//
//  Created by Artem on 10/11/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BackgroundImageView;

@interface AdvertSmallCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet BackgroundImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
