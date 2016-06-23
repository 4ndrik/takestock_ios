//
//  UserDetailsViewController.h
//  takestok
//
//  Created by Artem on 5/4/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <Stripe/Stripe.h>

@class BackgroundImageView;
@class PaddingTextField;
@class RadioButton;
@class User;
@class StoredImage;

@interface UserProfileViewController : BaseViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
    User* _user;
    
    __weak IBOutlet UIScrollView *_scrollView;
    UIImage* _newImage;
    __weak IBOutlet UILabel *_addImageTitle;
    __weak IBOutlet BackgroundImageView *_userImageView;
    __weak IBOutlet PaddingTextField *_userNameTextField;
    __weak IBOutlet PaddingTextField *_emailTextField;
    
    __weak IBOutlet RadioButton *_emailSubscriberadioButton;
    __weak IBOutlet PaddingTextField *_businessNameTextField;
    __weak IBOutlet PaddingTextField *_postCodeTextField;
    __weak IBOutlet PaddingTextField *_typeOfBusinessTextField;
    __weak IBOutlet PaddingTextField *_subTypeOfBusinessTextField;
    __weak IBOutlet PaddingTextField *_vatNumber;
    __weak IBOutlet RadioButton *_amNotVatRegisteredButton;
    __weak IBOutlet STPPaymentCardTextField *_paymantInformation;

    float _keyboardFrame;
    UIPickerView* _textPiker;
    NSArray* _pickerData;
    NSArray* _textControlsArray;
    UITextField* _currentInputControl;
}

- (IBAction)changePasswordAction:(id)sender;
- (IBAction)submit:(id)sender;
- (IBAction)addEditImage:(id)sender;
- (IBAction)vatRegisteredChanged:(id)sender;


@end
