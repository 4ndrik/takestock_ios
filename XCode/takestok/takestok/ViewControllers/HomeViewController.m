//
//  ViewController.m
//  takestok
//
//  Created by Artem on 4/6/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "HomeViewController.h"
#import "TextFieldBorderBottom.h"
#import "SearchViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
//    SearchSegue
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [_scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, self.view.frame.size.height - 20)];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"SearchSegue"]) {
        SearchViewController* searchVC = (SearchViewController*)segue.destinationViewController;
        [searchVC setSearchText:_serachTextField.text];
    }
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self performSegueWithIdentifier:@"SearchSegue" sender:self];
    [_serachTextField resignFirstResponder];
    return YES;
}

- (IBAction)hideKeyboard:(id)sender {
    if ([_serachTextField isFirstResponder]){
        [_serachTextField resignFirstResponder];
    }
}

@end
