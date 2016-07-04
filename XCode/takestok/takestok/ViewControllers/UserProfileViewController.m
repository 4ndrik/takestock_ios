//
//  UserDetailsViewController.m
//  takestok
//
//  Created by Artem on 5/4/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "UserProfileViewController.h"
#import "User.h"
#import "AppSettings.h"
#import "BackgroundImageView.h"
#import "PaddingTextField.h"
#import "UIImage+ExtendedImage.h"
#import "StoredImage.h"
#import "GUIDCreator.h"
#import "ImageCacheUrlResolver.h"
#import "ServerConnectionHelper.h"
#import "RadioButton.h"
#import "BusinessType.h"
#import "SubBusinessType.h"

@interface UserProfileViewController ()

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _user = [User getMe];
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
    if (_user){
        if (_user.image){
            [_userImageView loadImage:_user.image];
            _addImageTitle.text = @"EDIT";
        }
        _userNameTextField.text = _user.userName;
        _emailTextField.text = _user.email;
        [_emailSubscriberadioButton setSelected:_user.isSubscribed];
        _businessNameTextField.text = _user.businessName;
        _postCodeTextField.text = _user.postCode;
        
        _typeOfBusinessTextField.tag = _user.businessType.ident;
        _typeOfBusinessTextField.text = _user.businessType.title;
        
        _subTypeOfBusinessTextField.tag = _user.subBusinessType.ident;
        _subTypeOfBusinessTextField.text = _user.subBusinessType.title;
        
        if (_user.isVatRegistered){
            _vatNumber.text = _user.vatNumber;
        }
        [_amNotVatRegisteredButton setSelected:!_user.isVatRegistered];
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
    if ([item isKindOfClass:[Dictionary class]]){
        title = ((Dictionary*)item).title;
    }else if ([item isKindOfClass:[NSString class]]){
        title = item;
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if ([_currentInputControl respondsToSelector:@selector(setText:)]){
        id item = [_pickerData objectAtIndex:row];
        if ([item isKindOfClass:[Dictionary class]]){
            [_currentInputControl setText:((Dictionary*)item).title];
            [_currentInputControl setTag:((Dictionary*)item).ident];
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
    int index = [_textControlsArray indexOfObject:_currentInputControl];
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
    int index = [_textControlsArray indexOfObject:_currentInputControl];
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

-(void)configureDataPickerWithData:(NSArray<Dictionary*>*)data withTextField:(UITextField*)textField{
    _pickerData = data;
    [_textPiker reloadAllComponents];
    
    textField.inputView = _textPiker;
    NSUInteger index = [_pickerData indexOfObjectPassingTest:^BOOL(Dictionary* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return obj.ident == textField.tag;
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
        [self configureDataPickerWithData:[BusinessType getAll] withTextField:textField];
    }else if (textField == _subTypeOfBusinessTextField) {
        [self configureDataPickerWithData:[SubBusinessType getForParent:_typeOfBusinessTextField.tag] withTextField:textField];
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
    
    
    NSMutableString* message = [[NSMutableString alloc] init];
    if (errors.count > 0){
        [message appendFormat:@"%@ %@ required", [errors componentsJoinedByString:@"\n"], errors.count > 0 ? @"are" : @"is"];
    }
    
    if (message.length > 0){
        UIAlertController* emptyFieldsAlertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* closeAction = [UIAlertAction
                                      actionWithTitle:@"Ok"
                                      style:UIAlertActionStyleCancel
                                      handler:^(UIAlertAction * action)
                                      {
                                          [emptyFieldsAlertController dismissViewControllerAnimated:YES completion:nil];
                                          
                                      }];
        
        
        [emptyFieldsAlertController addAction:closeAction];
        
        [self presentViewController:emptyFieldsAlertController animated:YES completion:nil];
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
        NSUndoManager* undoManager = [[NSUndoManager alloc] init];
        _user.managedObjectContext.undoManager = undoManager;
        
        [undoManager beginUndoGrouping];
        _user.isSubscribed = _emailSubscriberadioButton.isSelected;
        _user.businessName = _businessNameTextField.text;
        _user.postCode = _postCodeTextField.text;
        _user.businessType = [BusinessType getEntityWithId:_typeOfBusinessTextField.tag];
        _user.subBusinessType = [SubBusinessType getEntityWithId:_subTypeOfBusinessTextField.tag];
        if (![_amNotVatRegisteredButton isSelected]){
            _user.vatNumber = _vatNumber.text;
        }
        _user.isVatRegistered = ![_amNotVatRegisteredButton isSelected];
        [undoManager endUndoGrouping];
        
        [self showLoading];
        [[ServerConnectionHelper sharedInstance] updateUser:_user image:_newImage compleate:^(NSError *error) {
            [self hideLoading];
            NSString* message = @"User updated successfully";
            NSString* title = @"";
            if (error){
                [undoManager undo];
                message = ERROR_MESSAGE(error);
                title = @"Error";
            }else{
                [_newImage saveToPath:[ImageCacheUrlResolver getPathForImage:_user.image]];
            }
            _user.managedObjectContext.undoManager = nil;
            
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
