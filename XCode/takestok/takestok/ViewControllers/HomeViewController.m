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
#import "Category.h"

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
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"SearchSegue"]) {
        SearchViewController* searchVC = (SearchViewController*)segue.destinationViewController;
        if ([sender isKindOfClass:[Category class]]){
            [searchVC setCategory:sender];
        }else if ([sender isKindOfClass:[UITextField class]]){
            [searchVC setSearchText:_searchTextField.text];
        }
    }else if ([segue.identifier isEqualToString:@"CategoriesSegue"]) {
        CategoryViewController* categoryhVC = (CategoryViewController*)segue.destinationViewController;
        categoryhVC.delegate = self;
    }
}

#pragma mark - CategoryProtocol
-(void)categorySelected:(Category*)category{
   [self performSegueWithIdentifier:@"SearchSegue" sender:category];
}

#pragma mark - Handle keyboard

- (void)keyboardWillHide:(NSNotification *)n
{
    _scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)keyboardWillShow:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    _scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self performSegueWithIdentifier:@"SearchSegue" sender:textField];
    [_searchTextField resignFirstResponder];
    return YES;
}

- (IBAction)showMenuAction:(id)sender {
    UIAlertController* menuController = [UIAlertController alertControllerWithTitle:@"Menu" message:@"Choose action" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* sellingAction = [UIAlertAction
                                  actionWithTitle:@"Selling"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                      if ([self shouldPerformSegueWithIdentifier:@"SellingSegue" sender:self]){
                                          [self performSegueWithIdentifier:@"SellingSegue" sender:self];
                                          [menuController dismissViewControllerAnimated:YES completion:nil];
                                      }
                                      
                                  }];
    
    UIAlertAction* buyingAction = [UIAlertAction
                                   actionWithTitle:@"Buying"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       if ([self shouldPerformSegueWithIdentifier:@"BuyingSegue" sender:self]){
                                           [self performSegueWithIdentifier:@"BuyingSegue" sender:self];
                                           [menuController dismissViewControllerAnimated:YES completion:nil];
                                       }
                                       
                                   }];
    
    UIAlertAction* profileAction = [UIAlertAction
                                   actionWithTitle:@"Profile"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       if ([self shouldPerformSegueWithIdentifier:@"MyProfileSegue" sender:self]){
                                           [self performSegueWithIdentifier:@"MyProfileSegue" sender:self];
                                           [menuController dismissViewControllerAnimated:YES completion:nil];
                                       }
                                       
                                   }];
    
    UIAlertAction* closeAction = [UIAlertAction
                                  actionWithTitle:@"Cancel"
                                  style:UIAlertActionStyleCancel
                                  handler:^(UIAlertAction * action)
                                  {
                                      [menuController dismissViewControllerAnimated:YES completion:nil];
                                      
                                  }];
    
    [menuController addAction:sellingAction];
    [menuController addAction:buyingAction];
    [menuController addAction:profileAction];
    [menuController addAction:closeAction];
    
    [self presentViewController:menuController animated:YES completion:nil];

}

@end
