//
//  LoginViewController.h
//  takestok
//
//  Created by Artem on 4/11/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextFieldBorderBottom;

@interface LoginViewController : UIViewController{
    
    __weak IBOutlet UIScrollView *_scrollView;
    
    
    __weak IBOutlet TextFieldBorderBottom *_signInEmailTextField;
    __weak IBOutlet TextFieldBorderBottom *_signInPasswordTextField;
    
    __weak IBOutlet TextFieldBorderBottom *_signUpUserNameTextField;
    __weak IBOutlet TextFieldBorderBottom *_signUpEmailTextField;
    __weak IBOutlet TextFieldBorderBottom *_signUpPasswordTextField;
    __weak IBOutlet TextFieldBorderBottom *_signUpConfirmtextField;
    
    __weak IBOutlet UIView *_signInView;
    __weak IBOutlet NSLayoutConstraint *_signInHeightConstraint;
    
    __weak IBOutlet UIView *_signUpView;
    __weak IBOutlet NSLayoutConstraint *_signUpHeightConstraint;
    
}

- (IBAction)showSignUpView:(id)sender;
- (IBAction)showSignInView:(id)sender;
- (IBAction)forgotPasswordAction:(id)sender;

- (IBAction)signIn:(id)sender;
- (IBAction)signUp:(id)sender;

- (IBAction)close:(id)sender;
@end
