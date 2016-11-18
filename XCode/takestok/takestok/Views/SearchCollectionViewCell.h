//
//  SearchCollectionViewCell.h
//  takestok
//
//  Created by Artem on 4/8/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackgroundImageView.h"

#define BottomSpace 164

@protocol WatchListProtocol <NSObject>

-(void)addRemoveWatchList:(id)owner;

@end

@interface SearchCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet BackgroundImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *soldOutImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *watchListButton;

@property (weak, nonatomic) id<WatchListProtocol> delegate;

- (IBAction)addRemoveWatchList:(id)sender;

@end
