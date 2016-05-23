//
//  OfferActionView.h
//  takestok
//
//  Created by Artem on 5/20/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PaddingTextField;
@interface OfferActionView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet PaddingTextField *priceTextEdit;
@property (weak, nonatomic) IBOutlet UILabel *priceTypeLabel;
@property (weak, nonatomic) IBOutlet PaddingTextField *qtyTextEdit;
@property (weak, nonatomic) IBOutlet UILabel *qtytypeLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *priceQtyHeightConstraints;

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end
