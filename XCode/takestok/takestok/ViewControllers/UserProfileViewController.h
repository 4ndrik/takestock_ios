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
@class User;
@class StoredImage;

@interface UserProfileViewController : BaseViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    User* _user;
    
    StoredImage* _selectedImage;
    __weak IBOutlet UILabel *_addImageTitle;
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
- (IBAction)addEditImage:(id)sender;


@end
