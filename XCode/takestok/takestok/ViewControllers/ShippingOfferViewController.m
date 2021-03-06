//
//  ShippingOfferViewController.m
//  takestok
//
//  Created by Artem on 10/4/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "ShippingOfferViewController.h"
#import "PaddingTextField.h"
#import "OfferServiceManager.h"
#import "TSShippingInfo.h"
#import "TSShippingInfo+Mutable.h"
#import "TSOffer.h"

@interface ShippingOfferViewController ()

@end

@implementation ShippingOfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    _keyboardFrame = 303;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_houseNoTextField becomeFirstResponder];
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

- (void)setOffer:(TSOffer*)offer{
    _offer = offer;
}

-(BOOL)verifyFields{
    return YES;
//    NSMutableArray* emptyFieldsArray = [NSMutableArray array];
//    if (_houseNoTextField.text.length <= 0)
//        [emptyFieldsArray addObject:@"House number"];
//    if (_streetTextField.text.length <= 0)
//        [emptyFieldsArray addObject:@"Street"];
//    if (_cityTextField.text.length <= 0)
//        [emptyFieldsArray addObject:@"City or Town"];
//    if (_postCodeTextField.text.length <= 0)
//        [emptyFieldsArray addObject:@"Postcode"];
//    
//    NSMutableString* message = [[NSMutableString alloc] init];
//    if (emptyFieldsArray.count > 0){
//        [message appendFormat:@"%@ %@ required", [emptyFieldsArray componentsJoinedByString:@"\n"], emptyFieldsArray.count > 1 ? @"are" : @"is"];
//    }
//    
//    if (message.length > 0){
//        [self showOkAlert:@"" text:message compleate:nil];
//        return NO;
//    }else{
//        return YES;
//    }
}

- (IBAction)sendShippingInformation:(id)sender {
    if ([self verifyFields]){
        
        TSShippingInfo* shippingInfo = [[TSShippingInfo alloc] init];
        shippingInfo.offerId = _offer.ident;
        shippingInfo.house = _houseNoTextField.text;
        shippingInfo.street = _streetTextField.text;
        shippingInfo.city = _cityTextField.text;
        shippingInfo.postcode = _postCodeTextField.text;
        shippingInfo.phone = _phoneNumberTextField.text;
        
        [self showLoading];
        
        [[OfferServiceManager sharedManager] setShippingInfo:shippingInfo withOffer:_offer compleate:^(NSError *error) {
            [self hideLoading];
            NSString* title = @"";
            NSString* text = @"Thanks. Shipping details saved and shared.";
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

@end
