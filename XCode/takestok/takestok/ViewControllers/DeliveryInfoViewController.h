//
//  DeliveryInfoViewController.h
//  takestok
//
//  Created by Artem on 10/5/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BaseViewController.h"

@class TSOffer;
@class PaddingTextField;

@interface DeliveryInfoViewController : BaseViewController<UITextFieldDelegate>{
    TSOffer* _offer;
    float _keyboardFrame;
    
    __weak IBOutlet UIScrollView *_scrollView;
    __weak IBOutlet PaddingTextField *_arrivealDateTextField;
    __weak IBOutlet PaddingTextField *_pickUpDateTextField;
    __weak IBOutlet PaddingTextField *_trackingNumberTextField;
    __weak IBOutlet PaddingTextField *_courierNameTextField;
}

- (void)setOffer:(TSOffer*)offer;
- (IBAction)submitAction:(id)sender;

@end
