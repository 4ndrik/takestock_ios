//
//  ImageCollectionViewCell.h
//  takestok
//
//  Created by Artem on 4/7/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackgroundImageView.h"

@interface ImageCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet BackgroundImageView *imageView;

@end
