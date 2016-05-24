//
//  QATableViewCell.m
//  takestok
//
//  Created by Artem on 5/6/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "QATableViewCell.h"

@implementation QATableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)reply:(id)sender {
    [self.delegate reply:self];
}
@end
