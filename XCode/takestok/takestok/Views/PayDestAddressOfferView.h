//
//  SetCardInfoView.h
//  takestok
//
//  Created by Artem on 7/4/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPPaymentCardTextField.h"

@interface PayDestAddressOfferView : UIView

@property (weak, nonatomic) IBOutlet STPPaymentCardTextField *cardControl;
@property (weak, nonatomic) IBOutlet UITextView *destinationAddress;

@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@end
