//
//  ShippingInfoActionView.h
//  takestok
//
//  Created by Artem on 7/1/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PaddingTextField;

@interface ShippingInfoActionView : UIView<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet PaddingTextField *dateShippedTextField;
@property (weak, nonatomic) IBOutlet PaddingTextField *curierNameTextField;
@property (weak, nonatomic) IBOutlet PaddingTextField *curierNumberTextField;
@property (weak, nonatomic) IBOutlet PaddingTextField *dateArrivedTextField;

@property (weak, nonatomic) IBOutlet UIButton *setButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end
