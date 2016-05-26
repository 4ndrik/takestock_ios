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
#import "SubCategory.h"
#import "Shipping.h"
#import "Condition.h"
#import "SizeType.h"
#import "Certification.h"

#import "RadioButton.h"
#import "ServerConnectionHelper.h"
#import "AdvertDetailViewController.h"

#import "AppSettings.h"

@implementation CreateAdvertViewController

#define SIZE_REGEX @"^\\d+ ?x ?\\d+ ?x ?\\d+$"

-(void)setAdvert:(Advert*)advert{
    _advert = advert;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _images = [NSMutableArray array];
    _keyboardFrame = 303;

    
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
    
    if (_advert){
        
        _productTitleTextField.text = _advert.name;
        
        _categoryTextField.tag = _advert.category.ident;
        _categoryTextField.text = _advert.category.title;
        
        _subCategoryTextField.tag = _advert.subCategory.ident;
        _subCategoryTextField.text = _advert.subCategory.title;
        
        _unitTextField.tag = _advert.packaging.ident;
        _unitTextField.text = _advert.packaging.title;
        
        _countUnitTextField.text = [NSString stringWithFormat:@"%i", _advert.count];
        _minimumOrderTextField.text = [NSString stringWithFormat:@"%i", _advert.minOrderQuantity];
        _priceTextField.text = [NSString stringWithFormat:@"%f", _advert.guidePrice];
        
        _descriptionTextView.text = _advert.adDescription;
        _locationTextField.text = _advert.location;
        
        _shippingTextField.tag = _advert.shipping.ident;
        _shippingTextField.text = _advert.shipping.title;
        
        _conditionTextField.tag = _advert.condition.ident;
        _conditionTextField.text = _advert.condition.title;
        
        NSDate* date = [NSDate dateWithTimeIntervalSinceReferenceDate:_advert.expires];
        _expairyTextField.text = [formatter stringFromDate:date];
        _sizeTextField.text = _advert.size;
        
        _sizeTypeTextField.tag = _advert.sizeType.ident;
        _sizeTypeTextField.text = _advert.sizeType.title;
        
        _otherTextField.text = _advert.certificationOther;
        _keywordTextField.text = _advert.tags;
        
        self.title = @"EDIT ADVERT";
    }else{
        _advert = [Advert storedEntity];
        self.title = @"SELL SOMETHING";
    }
    
    //Add certifications
    
    float size = self.view.bounds.size.width - 40;
    NSArray* certifications = [Certification getAll];
    float y = -44;
    NSMutableArray* group = [NSMutableArray array];
    for (int i = 0; i < certifications.count; i++){
        Certification* cert = [certifications objectAtIndex:i];
        float x = 0;
        
        if (i % 2){
            x = size / 2.;
        }else
        {
            y += 20 + 24;
        }
        
        RadioButton* radioButton = [[RadioButton alloc] initWithFrame:CGRectMake(x, y, 135, 24)];
        radioButton.tag = cert.ident;
        [group addObject:radioButton];
        radioButton.autoresizingMask = UIViewAutoresizingNone;
        [radioButton setTitle:cert.title forState:UIControlStateNormal];
        [radioButton setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [radioButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
        radioButton.groupButtons = group;
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        radioButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        radioButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [radioButton.titleLabel setFont:HelveticaLight18];
        [radioButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [radioButton addTarget:self action:@selector(setCertification:) forControlEvents:UIControlEventTouchUpInside];
        if (_advert)
            [radioButton setSelected:cert.ident == _advert.certification.ident];
        
        [_certificationsContainerView addSubview:radioButton];
    }
    
    for (NSLayoutConstraint *constraint in _certificationsContainerView.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = y + 24;
            break;
        }
    }
    
//    //TODO: for debug
//     _additionalViewHeight.constant = _saveButton.frame.size.height + _saveButton.frame.origin.y + 20;
    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraints];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_advert.ident == 0){
        [_advert.managedObjectContext deleteObject:_advert];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"AdvertDetailSegue"]) {
        AdvertDetailViewController* advertVC = (AdvertDetailViewController*)segue.destinationViewController;
        [advertVC setAdvert:_advert];
    }
}

-(void)setCertification:(RadioButton*)owner{
    _certificationsContainerView.tag = owner.tag;
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
    CGSize size = image.size;
    image = [UIImage imageWithImage:image scaledToSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width * size.height / size.width)];
    
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
    
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:NO completion:nil];
        [self showImagePickerController:NO];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Choose from library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:NO completion:nil];
        [self showImagePickerController:YES];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
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
    if (control == [_textControlsArray lastObject] || _productTitleTextField.text.length <= 0 || _images.count <= 0){
        [keyboardToolBar.items objectAtIndex:1].enabled = NO;
    }
    
    return keyboardToolBar;
}

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

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    textView.inputAccessoryView = [self toolBarForControl:textView];
    _currentInputControl = textView;
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self scrollToView:textField];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self scrollToView:textView];
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
    
    if (textField == _categoryTextField) {
        [self configureDataPickerWithData:[Category getAll] withTextField:textField];
    }else if (textField == _subCategoryTextField) {
        [self configureDataPickerWithData:[SubCategory getAll] withTextField:textField];
    }else if (textField == _unitTextField) {
        [self configureDataPickerWithData:[Packaging getAll] withTextField:textField];
    }else if (textField == _shippingTextField) {
        [self configureDataPickerWithData:[Shipping getAll] withTextField:textField];
    }else if (textField == _conditionTextField) {
        [self configureDataPickerWithData:[Condition getAll] withTextField:textField];
    }else if (textField == _sizeTypeTextField) {
        [self configureDataPickerWithData:[SizeType getAll] withTextField:textField];
    }else if (textField == _expairyTextField) {
        UIDatePicker* datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, _keyboardFrame - textField.inputAccessoryView.frame.size.height)];
        datePicker.datePickerMode = UIDatePickerModeDate;
        textField.inputView = datePicker;
        [datePicker addTarget:self action:@selector(setExpirationDate:) forControlEvents:UIControlEventValueChanged];
        [self setExpirationDate:datePicker];
    }
    
    return YES;
}

-(void)setExpirationDate:(UIDatePicker*)owner{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    _expairyTextField.text = [formatter stringFromDate:owner.date];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //Show / hide additional view if image and title are set.
    if (textField == _productTitleTextField){
        NSString* str = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (str.length > 0 && _images.count > 0){
            _additionalViewHeight.constant = _saveButton.frame.size.height + _saveButton.frame.origin.y + 20;
            [((UIToolbar*)textField.inputAccessoryView).items objectAtIndex:1].enabled = YES;
        }else{
            _additionalViewHeight.constant = 0;
            [((UIToolbar*)textField.inputAccessoryView).items objectAtIndex:1].enabled = NO;
        }
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    _additionalViewHeight.constant = _saveButton.frame.size.height + _saveButton.frame.origin.y + 20;
    [_scrollView setNeedsUpdateConstraints];
    [_scrollView updateConstraints];
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
            if (_currentInputControl == _unitTextField){
                for (UILabel* unitLabel in _packagingLabelCollection){
                    unitLabel.text = ((Dictionary*)item).title;
                }
            }
        }else if ([item isKindOfClass:[NSString class]]){
             [_currentInputControl setText:item];
        }else{
            [_currentInputControl setText:@""];
        }
    }
}

#pragma mark - Outlets

-(BOOL)verifyFields{
    NSMutableArray* messagesArray = [NSMutableArray array];
    if (_images.count <= 0)
        [messagesArray addObject:@"Image"];
    if (_productTitleTextField.text.length <= 0)
        [messagesArray addObject:@"Title"];
    if (_categoryTextField.text.length <= 0)
        [messagesArray addObject:@"Category"];
    if (_subCategoryTextField.text.length <= 0)
        [messagesArray addObject:@"Subcategory"];
    if (_unitTextField.text.length <= 0)
        [messagesArray addObject:@"Unit / type of packaging"];
    if (_countUnitTextField.text.length <= 0)
        [messagesArray addObject:@"Count"];
    if (_minimumOrderTextField.text.length <= 0)
        [messagesArray addObject:@"Minimum order"];
    if (_priceTextField.text.length <= 0)
        [messagesArray addObject:@"Price"];
    if (_descriptionTextView.text.length <= 0)
        [messagesArray addObject:@"Product description"];
    if (_locationTextField.text.length <= 0)
        [messagesArray addObject:@"Location"];
    if (_conditionTextField.text.length <= 0)
        [messagesArray addObject:@"Condition"];
    if (_expairyTextField.text.length <= 0)
        [messagesArray addObject:@"Expairy date"];
    if (_sizeTypeTextField.text.length <= 0)
        [messagesArray addObject:@"Size type"];
    
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:SIZE_REGEX options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:_sizeTextField.text options:0 range:NSMakeRange(0, [_sizeTextField.text length])];
    
    if (regExMatches == 0) {
        [messagesArray addObject:@"Size"];
    }
    
    if (_certificationsContainerView.tag <= 0)
        [messagesArray addObject:@"Certification"];
    if (_keywordTextField.text.length <= 0)
        [messagesArray addObject:@"Keywords"];
    
    if (messagesArray.count > 0){
        NSString* message = [NSString stringWithFormat:@"%@ %@ empty", [messagesArray componentsJoinedByString:@"\n"], messagesArray.count > 0 ? @"are" : @"is"];
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

-(void)createAdvert{
    if (!_advert){
        _advert = [Advert storedEntity];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    
    NSMutableOrderedSet* imageSet = [[NSMutableOrderedSet alloc] init];
    for (UIImage* image in _images){
        Image* advImage = [Image storedEntity];
        advImage.height = (int)image.size.height;
        advImage.width = (int)image.size.width;
        
        [image saveToPath:[ImageCacheUrlResolver getPathForImage:advImage]];
        [imageSet addObject:advImage];
    }
    [_advert setImages:imageSet];
    
    _advert.name = _productTitleTextField.text;
    _advert.guidePrice = [_priceTextField.text floatValue];
    _advert.location = _locationTextField.text;
    _advert.adDescription = _descriptionTextView.text;
    _advert.expires = [[formatter dateFromString:_expairyTextField.text] timeIntervalSinceReferenceDate];
    _advert.created = [[NSDate date] timeIntervalSinceReferenceDate];
    _advert.date_updated = [[NSDate date] timeIntervalSinceReferenceDate];
    _advert.minOrderQuantity = [_minimumOrderTextField.text intValue];
    _advert.certificationOther = _otherTextField.text;
    _advert.count = [_countUnitTextField.text intValue];
    _advert.category = [Category getEntityWithId:_categoryTextField.tag];
    _advert.subCategory = [SubCategory getEntityWithId:_subCategoryTextField.tag];
    _advert.certification = [Certification getEntityWithId:_certificationsContainerView.tag];
    _advert.condition = [Condition getEntityWithId:_conditionTextField.tag];
    _advert.shipping = [Shipping getEntityWithId:_shippingTextField.tag];
    _advert.sizeType = [SizeType getEntityWithId:_sizeTextField.tag];
    _advert.tags = _keywordTextField.text;
    _advert.packaging = [Packaging getEntityWithId:_unitTextField.tag];
    _advert.author = [User getMe];
    
    [[DB sharedInstance].storedManagedObjectContext save:nil];

}

- (IBAction)saveAdvert:(id)sender{
    if ([self verifyFields]){
        [self createAdvert];
    }
}

- (IBAction)previewAdvert:(id)sender {
    if ([self verifyFields]){
        [self createAdvert];
        [self performSegueWithIdentifier:@"AdvertDetailSegue" sender:nil];
    }
}

@end
