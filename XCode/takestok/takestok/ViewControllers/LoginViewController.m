//
//  LoginViewController.m
//  takestok
//
//  Created by Artem on 4/11/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "LoginViewController.h"
#import "ServerConnectionHelper.h"
#import "TextFieldBorderBottom.h"

@implementation LoginViewController

#define SignInHeight 250
#define SignUpHeight 476


- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
}


#pragma mark - Handle keyboard

- (void)keyboardWillHide:(NSNotification *)n
{
    _scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)keyboardWillShow:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
//    _keyboardFrame = keyboardSize.height;
    _scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
    
}

-(void)nextTextField{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.returnKeyType == UIReturnKeyNext && _signUpView.hidden) {
        [_signInPasswordTextField becomeFirstResponder];
    } else if (textField.returnKeyType==UIReturnKeyDone) {
        [self hideKeyboard:nil];
    }
    return YES;
}

- (IBAction)showSignUpView:(id)sender {
    [self.view endEditing:YES];
    _signInView.hidden = YES;
    _signInHeightConstraint.constant = 0;
    
    _signUpView.hidden = NO;
    _signUpHeightConstraint.constant = SignUpHeight;
}

- (IBAction)showSignInView:(id)sender {
    [self.view endEditing:YES];
    _signInView.hidden = NO;
    _signInHeightConstraint.constant = SignInHeight;
    
    _signUpView.hidden = YES;
    _signUpHeightConstraint.constant = 0;
}

- (IBAction)forgotPasswordAction:(id)sender {
}

- (IBAction)signIn:(id)sender {
    [self showLoading];
    [[ServerConnectionHelper sharedInstance] signIn:_signInEmailTextField.text password:_signInPasswordTextField.text compleate:^(NSError *error) {
        [self hideLoading];
        if (error){
            NSString* title = @"Error";
            NSString* message = [error localizedDescription];
            UIAlertController* errorController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* closeAction = [UIAlertAction
                                          actionWithTitle:@"Ok"
                                          style:UIAlertActionStyleCancel
                                          handler:^(UIAlertAction * action)
                                          {
                                              [errorController dismissViewControllerAnimated:YES completion:nil];
                                              
                                          }];
            
            
            [errorController addAction:closeAction];
            
            [self presentViewController:errorController animated:YES completion:nil];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (IBAction)signUp:(id)sender {
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)hideKeyboard:(id)sender {
    [self.view endEditing:YES];
}

@end
