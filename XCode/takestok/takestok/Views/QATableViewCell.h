//
//  QATableViewCell.h
//  takestok
//
//  Created by Artem on 5/6/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QATableViewCell;
@protocol ReplyProtocol <NSObject>

-(void)reply:(QATableViewCell*)sender;

@end

@interface QATableViewCell : UITableViewCell

@property (weak)id<ReplyProtocol>delegate;

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyHeightConstraint;
@property (weak, nonatomic) IBOutlet UITextView *replyTextEdit;

- (IBAction)reply:(id)sender;

@end
