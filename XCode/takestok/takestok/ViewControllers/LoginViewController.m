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
#import "RadioButton.h"
#import "UserServiceManager.h"

#define EMAIL_REGEX @"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+$"
//#define PHONE_REGEX @"^\\d+$"
//#define ZIP_REGEX @"^[a-zA-Z0-9]*$"

#define USER_NAME_REGEX @"^[a-zA-Z\\d]+$"

@implementation LoginViewController

#define SignInHeight 250
#define SignUpHeight 350


- (void)viewDidLoad {
    [super viewDidLoad];
    
#if DEBUG
    _signInEmailTextField.text = @"g2306804@mvrht.com";
    _signInPasswordTextField.text = @"test";
#endif

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

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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

-(void)nextTextField:(UITextField*)owner{
    NSInteger currentTag = owner.tag;
    currentTag++;
    UITextField* nextTextField = [owner.superview viewWithTag:currentTag];
    if (nextTextField){
        [nextTextField becomeFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.returnKeyType == UIReturnKeyNext) {
        [self nextTextField:textField];
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

-(BOOL)validateData:(BOOL)signIn{
    NSMutableArray* messagesArray = [NSMutableArray array];
    NSRegularExpression *emailRegEx = [[NSRegularExpression alloc] initWithPattern:EMAIL_REGEX options:NSRegularExpressionCaseInsensitive error:nil];
    NSRegularExpression *userNameRegEx = [[NSRegularExpression alloc] initWithPattern:USER_NAME_REGEX options:NSRegularExpressionCaseInsensitive error:nil];
    
    if (signIn){
        if (_signInEmailTextField.text.length <= 0){
            [messagesArray addObject:@"User name / Email is empty"];
        }
        
        if (_signInPasswordTextField.text.length <= 0)
            [messagesArray addObject:@"Password is empty"];
    }else{
        if (_signUpUserNameTextField.text.length <= 0){
            [messagesArray addObject:@"Username is empty"];
        }
        else if (_signUpUserNameTextField.text.length > 30){
            [messagesArray addObject:@"Username: Required 30 characters or fewer."];
        }
//        else if ([userNameRegEx numberOfMatchesInString:_signUpUserNameTextField.text options:0 range:NSMakeRange(0, [_signUpUserNameTextField.text length])] == 0){
//            [messagesArray addObject:@"Username: Required 30 characters or fewer. Letters, digits"];
//        }
        
        if ([emailRegEx numberOfMatchesInString:_signUpEmailTextField.text options:0 range:NSMakeRange(0, [_signUpEmailTextField.text length])] == 0){
            [messagesArray addObject:@"Wrong email address"];
        }
        
        if (_signUpPasswordTextField.text.length <= 0)
            [messagesArray addObject:@"Password is empty"];
        else if (![_signUpPasswordTextField.text isEqualToString:_signUpConfirmtextField.text]){
            [messagesArray addObject:@"Password and confirm password are different"];
        }
        
        if (!_acceptTermsAndConditionsButton.selected){
           [messagesArray addObject:@"You have to agree with terms and coditions"];
        }
    }
    if (messagesArray.count > 0){
        NSString* message = [messagesArray componentsJoinedByString:@"\n"];
        [self showOkAlert:@"" text:message compleate:nil];
    }
    return messagesArray.count == 0;
}

- (IBAction)forgotPasswordAction:(id)sender {

}

- (IBAction)showTermsAndConditionsAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://takestock.shalakh.in/legal/"]];
}

- (IBAction)signIn:(id)sender {
    if ([self validateData:YES]){
        [self showLoading];
        [[UserServiceManager sharedManager] signInWithUserName:_signInEmailTextField.text password:_signInPasswordTextField.text compleate:^(NSError *error) {
            [self hideLoading];
            if (error){
                NSString* title = @"Error";
                NSString* message = ERROR_MESSAGE(error);
                [self showOkAlert:title text:message compleate:nil];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
}

- (IBAction)signUp:(id)sender {
    if ([self validateData:NO]){
        [self showLoading];
        [[UserServiceManager sharedManager] signUpWithUserName:_signUpUserNameTextField.text email:_signUpEmailTextField.text password:_signUpPasswordTextField.text compleate:^(NSError *error) {
            [self hideLoading];
            if (error){
                [self showOkAlert:@"Error" text:ERROR_MESSAGE(error) compleate:nil];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)hideKeyboard:(id)sender {
    [self.view endEditing:YES];
}

@end
