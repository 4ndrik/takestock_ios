//
//  WatchTableViewCell.h
//  takestok
//
//  Created by Artem on 6/29/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchCollectionViewCell.h"

@class BackgroundImageView, PaddingLabel, TopBottomStripesLabel;

@interface WatchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet BackgroundImageView *adImageView;
@property (weak, nonatomic) IBOutlet PaddingLabel *priceLabel;
@property (weak, nonatomic) IBOutlet TopBottomStripesLabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *expiresLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *offersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLeftLabel;

- (IBAction)removeFromWatchListAction:(id)sender;

@property (weak, nonatomic) id<WatchListProtocol> delegate;

@end
