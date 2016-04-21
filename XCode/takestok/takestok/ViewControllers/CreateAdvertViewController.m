//
//  SellViewController.m
//  takestok
//
//  Created by Artem on 4/7/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "CreateAdvertViewController.h"
#import "UIImage+ExtendedImage.h"
#import "ImageCollectionViewCell.h"
#import "PaddingTextField.h"
#import "TextFieldBorderBottom.h"
#import "Advert.h"
#import "ImageCacheUrlResolver.h"

#import "Category.h"
#import "Shipping.h"
#import "Condition.h"
#import "SizeType.h"
#import "Certification.h"

@implementation CreateAdvertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _keyboardFrame = 303;
    _images = [NSMutableArray array];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    _expairyTextField.placeholder = formatter.dateFormat;
    
    
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
                            _productTitleTextField,
                            _categoryTextField,
                            _subCategoryTextField,
                            _unitTextField,
                            _countUnitTextField,
                            _minimumOrderTextField,
                            _priceTextField,
                            _descriptionTextView,
                            _locationTextField,
                            _shippingTextField,
                            _conditionTextField,
                            _expairyTextField,
                            _sizeTextField,
                            _sizeTypeTextField,
                            _otherTextField,
                            _keywordTextField, nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.backItem.title = @"Home";
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

#pragma mark  - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = (UIImage*)[info objectForKey:UIImagePickerControllerOriginalImage];
    image = [image fixOrientation];
//TODO: Change size if need
//    CGSize size = image.size;
//    image = [UIImage imageWithImage:image scaledToSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width * size.height / size.width)];
    
    if (_isAddNewImage){
       [_images addObject:image];
        _selectedImage = _images.count - 1;;
    }else{
        [_images replaceObjectAtIndex:_selectedImage withObject:image];
    }
    
    _addImageLabel.text = @"EDIT";
    
    _collectionViewHeight.constant = ((_imagesCollectionView.frame.size.width - 20) / 3 + 20) * ceilf((_images.count + 1) / 3.);
    [_imagesCollectionView reloadData];
    [self collectionView:_imagesCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedImage inSection:0]];
    _additionalViewHeight.constant = _productTitleTextField.text.length > 0 && _images.count > 0 ? _saveButton.frame.size.height + _saveButton.frame.origin.y + 20 : 0;
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _images.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCollectionViewCell* cell = (ImageCollectionViewCell*)[collectionView
                                                               dequeueReusableCellWithReuseIdentifier:@"ImageViewCell" forIndexPath:indexPath];
    
    if (indexPath.row == _selectedImage){
        cell.layer.borderColor = OliveMainColor.CGColor;
        cell.layer.borderWidth = 3.;
    }else{
        cell.layer.borderWidth = 0.;
    }
    
    if (indexPath.row < _images.count){
        cell.imageView.image = [_images objectAtIndex:indexPath.row];

    }else{
        cell.imageView.image = [UIImage imageNamed:@"addImageIco"];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float size = (collectionView.frame.size.width - 20) / 3;
    
    return CGSizeMake(size, size);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < _images.count){
        _mainImageView.image = [_images objectAtIndex:indexPath.row];
        _selectedImage = indexPath.row;
        [collectionView reloadData];
    }else{
        [self addImage:nil];
    }
}

-(void)showImagePickerController:(BOOL)showLibrary{
    UIImagePickerController* photoLibraryContoller = [[UIImagePickerController alloc] init];
    photoLibraryContoller.delegate = self;
    [photoLibraryContoller setSourceType: showLibrary? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:photoLibraryContoller animated:YES completion:nil];
}

- (IBAction)addImage:(id)sender {
    
    _isAddNewImage = !sender || _images.count == 0;
    
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

#pragma mark UITextFieldDelegate

-(void)scrollToView:(UIView*)view{
    CGRect rect = [view bounds];
    rect = [view convertRect:rect toView:_scrollView];
    rect.origin.x = 0 ;
    rect.origin.y -= 60 ;
    rect.size.height = 150;
    
    [_scrollView scrollRectToVisible:rect animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self scrollToView:textField];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self scrollToView:textView];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _productTitleTextField){
        NSString* str = [textField.text stringByReplacingCharactersInRange:range withString:string];
        _additionalViewHeight.constant = str.length > 0 && _images.count > 0 ? _saveButton.frame.size.height + _saveButton.frame.origin.y + 20 : 0;
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing: (UITextField *)textField

{
    UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    keyboardToolBar.barStyle = UIBarStyleDefault;
    [keyboardToolBar setItems: [NSArray arrayWithObjects:
                                [[UIBarButtonItem alloc]initWithTitle:@"Previous" style:UIBarButtonItemStylePlain target:self action:@selector(previousTextField)],
                                
                                [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextTextField)],
                                [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)],
                                nil]];
    textField.inputAccessoryView = keyboardToolBar;
    
    
    if (textField == [_textControlsArray firstObject]){
        [keyboardToolBar.items objectAtIndex:0].enabled = NO;
    }else if (textField == [_textControlsArray lastObject]){
        [keyboardToolBar.items objectAtIndex:1].enabled = NO;
    }
    
    if (!_textPiker){
        _textPiker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, _keyboardFrame - textField.inputAccessoryView.frame.size.height)];
        [_textPiker setDataSource: self];
        [_textPiker setDelegate: self];
        _textPiker.showsSelectionIndicator = YES;
    }
    
    if (textField == _categoryTextField) {
        _pickerData = [Category getAll];
        textField.inputView = _textPiker;
        [_textPiker reloadAllComponents];
    }else if (textField == _subCategoryTextField) {
        _pickerData = [Category getAll];;
        textField.inputView = _textPiker;
    }else if (textField == _unitTextField) {
        _pickerData = [NSArray arrayWithObjects:@"first", @"Second", @"Olala", @"Bebebe", nil];
        textField.inputView = _textPiker;
        [_textPiker reloadAllComponents];
    }else if (textField == _shippingTextField) {
        _pickerData = [Shipping getAll];
        textField.inputView = _textPiker;
        [_textPiker reloadAllComponents];
    }else if (textField == _conditionTextField) {
        _pickerData = [Condition getAll];
        textField.inputView = _textPiker;
        [_textPiker reloadAllComponents];
    }else if (textField == _sizeTypeTextField) {
        _pickerData = [SizeType getAll];
        textField.inputView = _textPiker;
        [_textPiker reloadAllComponents];
    }else if (textField == _expairyTextField) {
        UIDatePicker* datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, _keyboardFrame - textField.inputAccessoryView.frame.size.height)];
        datePicker.datePickerMode = UIDatePickerModeDate;
        textField.inputView = datePicker;
        
        [datePicker addTarget:self action:@selector(setExpirationDate:) forControlEvents:UIControlEventValueChanged];
    }
    _currentInputControl = textField;
    
    return YES;
}

-(void)setExpirationDate:(UIDatePicker*)owner{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    _expairyTextField.text = [formatter stringFromDate:owner.date];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView

{
    UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    keyboardToolBar.barStyle = UIBarStyleDefault;
    [keyboardToolBar setItems: [NSArray arrayWithObjects:
                                [[UIBarButtonItem alloc]initWithTitle:@"Previous" style:UIBarButtonItemStylePlain target:self action:@selector(previousTextField)],
                                [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextTextField)],
                                [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)],
                                nil]];
    textView.inputAccessoryView = keyboardToolBar;
    _currentInputControl = textView;
    return YES;
    
}

//- (id)findFirstResponder:(UIView*)view
//{
//    if (view.isFirstResponder) {
//        return view;
//    }
//    for (UIView *subView in view.subviews) {
//        id responder = [self findFirstResponder:subView];
//        if (responder) return responder;
//    }
//    return nil;
//}

- (void)nextTextField {
    int index = [_textControlsArray indexOfObject:_currentInputControl];
    index++;
    UIView* textControl = [_textControlsArray objectAtIndex:index];
    [textControl becomeFirstResponder];
}

-(void)previousTextField
{
    int index = [_textControlsArray indexOfObject:_currentInputControl];
    index--;
    UIView* textControl = [_textControlsArray objectAtIndex:index];
    [textControl becomeFirstResponder];
}

-(void)resignKeyboard {
    if (_currentInputControl){
        [_currentInputControl resignFirstResponder];
    }
    
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
        }else if ([item isKindOfClass:[NSString class]]){
             [_currentInputControl setText:item];
        }else{
            [_currentInputControl setText:@""];
        }
    }
}

#pragma mark - Outlets

- (IBAction)createAdverb:(id)sender{
    Advert* advert = [Advert storedEntity];
    NSMutableOrderedSet* imageSet = [[NSMutableOrderedSet alloc] init];
    for (UIImage* image in _images){
        Image* advImage = [Image storedEntity];
        advImage.height = (int)image.size.height;
        advImage.width = (int)image.size.width;
        
        [image saveToPath:[ImageCacheUrlResolver getPathForImage:advImage]];
        [imageSet addObject:advImage];
    }
    [advert setImages:imageSet];
    
    advert.name = _productTitleTextField.text;
    advert.guidePrice = [_priceTextField.text floatValue];
    advert.location = _locationTextField.text;
    advert.adDescription = _descriptionTextView.text;
    NSString* dateString = _expairyTextField.text;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    advert.expires = [[formatter dateFromString:dateString] timeIntervalSince1970];
    [[DB sharedInstance].storedManagedObjectContext save:nil];
}

@end
