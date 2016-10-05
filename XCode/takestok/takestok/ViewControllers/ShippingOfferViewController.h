//
//  ShippingOfferViewController.h
//  takestok
//
//  Created by Artem on 10/4/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BaseViewController.h"

@class TSOffer;
@class PaddingTextField;

@interface ShippingOfferViewController : BaseViewController<UITextFieldDelegate>{
    TSOffer* _offer;
    float _keyboardFrame;
    
    __weak IBOutlet UIScrollView *_scrollView;
    __weak IBOutlet PaddingTextField *_houseNoTextField;
    __weak IBOutlet PaddingTextField *_streetTextField;
    __weak IBOutlet PaddingTextField *_cityTextField;
    __weak IBOutlet PaddingTextField *_postCodeTextField;
    __weak IBOutlet PaddingTextField *_phoneNumberTextField;
}

- (void)setOffer:(TSOffer*)offer;
- (IBAction)sendShippingInformation:(id)sender;

@end
