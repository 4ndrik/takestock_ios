//
//  UserDetailsViewController.m
//  takestok
//
//  Created by Artem on 5/4/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "UserProfileViewController.h"
#import "TSUserEntity.h"
#import "UserServiceManager.h"
#import "AppSettings.h"
#import "BackgroundImageView.h"
#import "PaddingTextField.h"
#import "UIImage+ExtendedImage.h"
#import "StoredImage.h"
#import "GUIDCreator.h"
#import "ImageCacheUrlResolver.h"
#import "ServerConnectionHelper.h"
#import "RadioButton.h"
#import "TSUserBusinessType.h"
#import "TSUserSubBusinessType.h"
#import "TSUserEntity+Mutable.h"

@interface UserProfileViewController ()

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self refreshUserData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    
    _textControlsArray = [NSArray arrayWithObjects:
                          _businessNameTextField,
                          _postCodeTextField,
                          _typeOfBusinessTextField,
                          _subTypeOfBusinessTextField,
                          _vatNumber, nil];
    
    _keyboardFrame = 303;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshUserData{
    TSUserEntity* user = [[UserServiceManager sharedManager] getMe];
    if (user){
        if (user.photo){
            [_userImageView loadImage:user.photo];
            _addImageTitle.text = @"EDIT";
        }
        _userNameTextField.text = user.userName;
        _emailTextField.text = user.email;
        [_emailSubscriberadioButton setSelected:user.isSuscribed];
        _businessNameTextField.text = user.businessName;
        _postCodeTextField.text = user.postCode;
        
        TSUserBusinessType* bt = user.businessType;
        if (!bt){
            bt = [[[UserServiceManager sharedManager] getBusinessTypes] firstObject];
        }
        _typeOfBusinessTextField.tag = [bt.ident intValue];
        _typeOfBusinessTextField.text = bt.title;
        
        TSUserSubBusinessType* sb = user.subBusinessType;
        if (sb){
            sb = [bt.subTypes firstObject];
        }
        _subTypeOfBusinessTextField.tag = [sb.ident intValue];
        _subTypeOfBusinessTextField.text = sb.title;
        
        if (user.isVatExtempt){
            _vatNumber.text = user.vatNumber;
        }
        [_amNotVatRegisteredButton setSelected:!user.isVatExtempt];
        [self vatRegisteredChanged:_amNotVatRegisteredButton];
    }
    
    [self.view setNeedsUpdateConstraints];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

#pragma mark  - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = (UIImage*)[info objectForKey:UIImagePickerControllerOriginalImage];
    image = [image fixOrientation];
    CGSize size = image.size;
    image = [UIImage imageWithImage:image scaledToSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width * size.height / size.width)];
    
    _newImage = image;
    
    _userImageView.image = image;
    _addImageTitle.text = @"EDIT";
}

-(void)showImagePickerController:(BOOL)showLibrary{
    UIImagePickerController* photoLibraryContoller = [[UIImagePickerController alloc] init];
    photoLibraryContoller.delegate = self;
    [photoLibraryContoller setSourceType: showLibrary? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:photoLibraryContoller animated:YES completion:nil];
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _pickerData.count;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    id item = [_pickerData objectAtIndex:row];
    NSString* title = @"";
    if ([item isKindOfClass:[TSBaseDictionaryEntity class]]){
        title = ((TSBaseDictionaryEntity*)item).title;
    }else if ([item isKindOfClass:[NSString class]]){
        title = item;
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if ([_currentInputControl respondsToSelector:@selector(setText:)]){
        id item = [_pickerData objectAtIndex:row];
        if ([item isKindOfClass:[TSBaseDictionaryEntity class]]){
            [_currentInputControl setText:((TSBaseDictionaryEntity*)item).title];
            [_currentInputControl setTag:[((TSBaseDictionaryEntity*)item).ident intValue]];
            if (_currentInputControl == _typeOfBusinessTextField){
                _subTypeOfBusinessTextField.tag = 0;
                _subTypeOfBusinessTextField.text = @"";
            }
        }else if ([item isKindOfClass:[NSString class]]){
            [_currentInputControl setText:item];
        }else{
            [_currentInputControl setText:@""];
        }
    }
}

#pragma mark - UITextFieldDelegate

-(void)scrollToView:(UIView*)view{
    CGRect rect = [view bounds];
    rect = [view convertRect:rect toView:_scrollView];
    rect.origin.x = 0 ;
    rect.origin.y -= 60 ;
    rect.size.height = 150;
    
    [_scrollView scrollRectToVisible:rect animated:YES];
}

-(UIToolbar*)toolBarForControl:(UIView*)control{
    UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    keyboardToolBar.barStyle = UIBarStyleDefault;
    [keyboardToolBar setItems: [NSArray arrayWithObjects:
                                [[UIBarButtonItem alloc]initWithTitle:@"Previous" style:UIBarButtonItemStylePlain target:self action:@selector(previousTextField)],
                                
                                [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextTextField)],
                                [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(hideKeyboard:)],
                                nil]];
    
    if (control == [_textControlsArray firstObject]){
        [keyboardToolBar.items objectAtIndex:0].enabled = NO;
    }
    if (control == [_textControlsArray lastObject]){
        [keyboardToolBar.items objectAtIndex:1].enabled = NO;
    }
    
    return keyboardToolBar;
}

- (void)nextTextField {
    NSUInteger index = [_textControlsArray indexOfObject:_currentInputControl];
    index++;
    UITextField* textControl = [_textControlsArray objectAtIndex:index];
    if (![textControl isEnabled]){
        index++;
        textControl = [_textControlsArray objectAtIndex:index];
    }
    [textControl becomeFirstResponder];
}

-(void)previousTextField
{
    NSUInteger index = [_textControlsArray indexOfObject:_currentInputControl];
    index--;
    UITextField* textControl = [_textControlsArray objectAtIndex:index];
    if (![textControl isEnabled]){
        index--;
        textControl = [_textControlsArray objectAtIndex:index];
    }
    [textControl becomeFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self scrollToView:textField];
}

-(void)configureDataPickerWithData:(NSArray<TSBaseDictionaryEntity*>*)data withTextField:(UITextField*)textField{
    _pickerData = data;
    [_textPiker reloadAllComponents];
    
    textField.inputView = _textPiker;
    NSUInteger index = [_pickerData indexOfObjectPassingTest:^BOOL(TSBaseDictionaryEntity* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj.ident intValue] == textField.tag;
    }];
    [_textPiker selectRow:index == NSNotFound ? 0 : index inComponent:0 animated:NO];
    [self pickerView:_textPiker didSelectRow:index == NSNotFound ? 0 : index inComponent:0];
}

-(BOOL)textFieldShouldBeginEditing: (UITextField *)textField
{
    _currentInputControl = textField;
    
    textField.inputAccessoryView = [self toolBarForControl:textField];
    
    if (!_textPiker){
        _textPiker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, _keyboardFrame - textField.inputAccessoryView.frame.size.height)];
        [_textPiker setDataSource: self];
        [_textPiker setDelegate: self];
        _textPiker.showsSelectionIndicator = YES;
    }
    
    if (textField == _typeOfBusinessTextField) {
        [self configureDataPickerWithData:[[UserServiceManager sharedManager] getBusinessTypes] withTextField:textField];
    }else if (textField == _subTypeOfBusinessTextField) {
        TSUserBusinessType* type = [[UserServiceManager sharedManager] getBusinessTypeWithId:[NSNumber numberWithInt:_typeOfBusinessTextField.tag]];
        [self configureDataPickerWithData:[type subTypes] withTextField:textField];
    }
    return YES;
}


#pragma mark - Helpers

- (IBAction)changePasswordAction:(id)sender {
}

-(BOOL)validateUser{
    NSMutableArray* errors = [NSMutableArray array];
    if (_userNameTextField.text <= 0){
        [errors addObject:@"Username"];
    }
    
    if (_emailTextField.text.length <= 0){
        [errors addObject:@"Email"];
    }
    
    if (_businessNameTextField.text.length <= 0){
        [errors addObject:@"Business name"];
    }
    
    
    NSMutableString* message = [[NSMutableString alloc] init];
    if (errors.count > 0){
        [message appendFormat:@"%@ %@ required", [errors componentsJoinedByString:@"\n"], errors.count > 0 ? @"are" : @"is"];
    }
    
    if (message.length > 0){
        [self showOkAlert:@"" text:message compleate:nil];
        return NO;
    }else{
        return YES;
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
    _keyboardFrame = keyboardSize.height;
    _scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
    
}

#pragma mark - Actions

- (IBAction)submit:(id)sender {
    if ([self validateUser]){
        TSUserEntity* newUser = [[[UserServiceManager sharedManager] getMe] copy];
        newUser.isSuscribed = _emailSubscriberadioButton.isSelected;
        newUser.businessName = _businessNameTextField.text;
        newUser.postCode = _postCodeTextField.text;
        newUser.businessType = [[UserServiceManager sharedManager] getBusinessTypeWithId:[NSNumber numberWithInt:_typeOfBusinessTextField.tag]];
        for (TSUserSubBusinessType* subBt in newUser.businessType.subTypes) {
            if ([subBt.ident intValue] == _subTypeOfBusinessTextField.tag){
                newUser.subBusinessType = subBt;
                break;
            }
        }
        newUser.isVatExtempt = ![_amNotVatRegisteredButton isSelected];
        if (newUser.isVatExtempt){
            newUser.vatNumber = _vatNumber.text;
        }
        
        [self showLoading];
        
        [[UserServiceManager sharedManager] updateUser:newUser withImage:_newImage compleate:^(NSError *error) {
            [self hideLoading];
            NSString* message = @"User updated successfully";
            NSString* title = @"";
            if (error){
                message = ERROR_MESSAGE(error);
                title = @"Error";
            }else{
                [_newImage saveToPath:[ImageCacheUrlResolver getPathForImage:[[UserServiceManager sharedManager] getMe].photo]];
            }
            [self showOkAlert:title text:message compleate:nil];
        }];
    }
}

- (IBAction)addEditImage:(id)sender {
    UIAlertController * actionSheet=   [UIAlertController
                                        alertControllerWithTitle:@""
                                        message:@""
                                        preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:NO completion:nil];
        [self showImagePickerController:NO];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Choose from library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:NO completion:nil];
        [self showImagePickerController:YES];
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (IBAction)vatRegisteredChanged:(RadioButton*)sender {
    _vatNumber.enabled = !sender.isSelected;
    if (!_vatNumber.enabled){
        _vatNumber.text = @"";
        _vatNumber.placeholder = @"";
    }else{
        _vatNumber.placeholder = @"VAT number";
    }
}

- (IBAction)changeCardNumber:(id)sender {
}

@end
