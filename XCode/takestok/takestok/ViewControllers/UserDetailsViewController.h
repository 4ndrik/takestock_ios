//
//  UserDetailsViewController.h
//  takestok
//
//  Created by Artem on 5/4/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class BackgroundImageView;
@class PaddingTextField;
@class RadioButton;

@interface UserDetailsViewController : BaseViewController{
    __weak IBOutlet BackgroundImageView *_userImageView;
    __weak IBOutlet PaddingTextField *_userNameTextField;
    __weak IBOutlet PaddingTextField *_emailTextField;
    
    __weak IBOutlet PaddingTextField *_businessNameTextField;
    __weak IBOutlet PaddingTextField *_postCodeTextField;
    __weak IBOutlet PaddingTextField *_typeOfBusinessTextField;
    __weak IBOutlet PaddingTextField *_subTypeOfBusinessTextField;
    __weak IBOutlet PaddingTextField *_vatNumber;
    __weak IBOutlet RadioButton *_amNotVatRegisteredButton;
    
}
- (IBAction)changePasswordAction:(id)sender;
- (IBAction)submit:(id)sender;


@end
