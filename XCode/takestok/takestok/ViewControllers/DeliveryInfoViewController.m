//
//  DeliveryInfoViewController.m
//  takestok
//
//  Created by Artem on 10/5/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "DeliveryInfoViewController.h"
#import "PaddingTextField.h"
#import "TSOffer.h"
#import "TSShippingInfo.h"
#import "TSShippingInfo+Mutable.h"
#import "OfferServiceManager.h"

@interface DeliveryInfoViewController ()

@end

@implementation DeliveryInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    
    _arrivealDateTextField.placeholder = dateFormatter.dateFormat;
    _pickUpDateTextField.placeholder = dateFormatter.dateFormat;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    _keyboardFrame = 213;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)setOffer:(TSOffer*)offer{
    _offer = offer;
}

-(void)setDate:(UIDatePicker*)owner{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    NSString* dateString = [dateFormatter stringFromDate:owner.date];
    PaddingTextField* currentTextField = [_arrivealDateTextField isFirstResponder] ? _arrivealDateTextField : _pickUpDateTextField;
    currentTextField.text = dateString;
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == (UITextField*)_arrivealDateTextField || textField == (UITextField*)_pickUpDateTextField){
        UIDatePicker* datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, _keyboardFrame - textField.inputAccessoryView.frame.size.height)];
        datePicker.datePickerMode = UIDatePickerModeDate;
        textField.inputView = datePicker;
        [datePicker addTarget:self action:@selector(setDate:) forControlEvents:UIControlEventValueChanged];
    }
    return YES;
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
    _keyboardFrame = keyboardSize.height;
    _scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
}

-(BOOL)verifyFields{
    NSMutableArray* emptyFieldsArray = [NSMutableArray array];
    if (_arrivealDateTextField.text.length <= 0)
        [emptyFieldsArray addObject:@"Arrival date"];
    if (_pickUpDateTextField.text.length <= 0)
        [emptyFieldsArray addObject:@"Pickup date"];
    if (_trackingNumberTextField.text.length <= 0)
        [emptyFieldsArray addObject:@"Tracking number"];
    
    NSMutableString* message = [[NSMutableString alloc] init];
    if (emptyFieldsArray.count > 0){
        [message appendFormat:@"%@ %@ required", [emptyFieldsArray componentsJoinedByString:@"\n"], emptyFieldsArray.count > 0 ? @"are" : @"is"];
    }
    
    if (message.length > 0){
        [self showOkAlert:@"" text:message compleate:nil];
        return NO;
    }else{
        return YES;
    }
}

- (IBAction)submitAction:(id)sender {
    if ([self verifyFields]){
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        
        TSShippingInfo* shippingInfo = [[TSShippingInfo alloc] init];
        shippingInfo.offerId = _offer.ident;
        shippingInfo.arrivalDate = [dateFormatter dateFromString:_arrivealDateTextField.text];
        shippingInfo.pickUpDate = [dateFormatter dateFromString:_pickUpDateTextField.text];
        shippingInfo.trackingNumber = _trackingNumberTextField.text;
        shippingInfo.courierName = _courierNameTextField.text;
        
        [self showLoading];
        
        [[OfferServiceManager sharedManager] setDeliveryInfo:shippingInfo withOffer:_offer compleate:^(NSError *error) {
            [self hideLoading];
            NSString* title = @"";
            NSString* text = @"Delivery information is sent";
            if (error){
                title = @"Error";
                text = ERROR_MESSAGE(error);
            }
            
            [self showOkAlert:title text:text compleate:error ? nil : ^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }];
    }
}

-(void)closeOkAlert{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
