//
//  WatchTableViewCell.m
//  takestok
//
//  Created by Artem on 6/29/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "AdvertTableViewCell.h"
#import "BackgroundImageView.h"
#import "PaddingLabel.h"
#import "TopBottomStripesLabel.h"

@implementation AdvertTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)mainAction:(id)sender {
    [_delegate mainAction:self];
}
@end
