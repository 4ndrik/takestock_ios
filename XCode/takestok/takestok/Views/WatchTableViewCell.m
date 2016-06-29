//
//  WatchTableViewCell.m
//  takestok
//
//  Created by Artem on 6/29/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "WatchTableViewCell.h"
#import "BackgroundImageView.h"
#import "PaddingLabel.h"
#import "TopBottomStripesLabel.h"

@implementation WatchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)removeFromWatchListAction:(id)sender {
    [_delegate addRemoveWatchList:self];
}
@end
