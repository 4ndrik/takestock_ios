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
#import "TSAdvert.h"
#import "TSAdvert+Mutable.h"
#import "TSImageEntity+Mutable.h"
#import "ImageCacheUrlResolver.h"
#import "TSAdvertCertification.h"
#import "TSAdvertSubCategory.h"

#import "RadioButton.h"
#import "ServerConnectionHelper.h"
#import "AdvertDetailViewController.h"

#import "AppSettings.h"
#import "StoredImage.h"
#import "GUIDCreator.h"

#import "AdvertServiceManager.h"
#import "UserServiceManager.h"
#import "AdvertDetailViewController.h"

@implementation CreateAdvertViewController

#define SIZE_REGEX @"^\\d+ ?x ?\\d+ ?x ?\\d+$"

-(void)setAdvert:(TSAdvert*)advert{
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
        
        [_images addObjectsFromArray:_advert.photos];
        
        _productTitleTextField.text = _advert.name;
        
        _categoryTextField.tag = [_advert.category.ident intValue];
        _categoryTextField.text = _advert.category.title;
        
        _subCategoryTextField.tag = [_advert.subCategory.ident intValue];
        _subCategoryTextField.text = _advert.subCategory.title;
        
        _unitTextField.tag = [_advert.packaging.ident intValue];
        _unitTextField.text = _advert.packaging.title;
        
        _countUnitTextField.text = [NSString stringWithFormat:@"%i", _advert.count];
        _minimumOrderTextField.text = [NSString stringWithFormat:@"%i", _advert.minOrderQuantity];
        _priceTextField.text = [NSString stringWithFormat:@"%.02f", _advert.guidePrice];
        
        _descriptionTextView.text = _advert.adDescription;
        _locationTextField.text = _advert.location;
        
        _shippingTextField.tag = [_advert.shipping.ident intValue];
        _shippingTextField.text = _advert.shipping.title;
        
        _conditionTextField.tag = [_advert.condition.ident intValue];
        _conditionTextField.text = _advert.condition.title;
        
        _expiratonPanelHeight.constant = _advert.category.isFood ? 100 : 0;
        
        if (_advert.dateExpires){
            _expairyTextField.text = [NSDate stringFromDate:_advert.dateExpires];
        }
        _sizeTextField.text = _advert.size;
        
//        _sizeTypeTextField.tag = [_advert.siz.ident intValue];
//        _sizeTypeTextField.text = _advert.sizeType.title;
        
        _otherTextField.text = _advert.certificationOther;
        _keywordTextField.text = _advert.tags;
        
        self.title = @"EDIT ADVERT";
        
        [_saveButton setTitle:@"SAVE CHANGES" forState:UIControlStateNormal];
        if (_advert.isInDrafts){
            _stateViewHeight.constant = 0;
            _previewButton.hidden = NO;
            _saveButton.backgroundColor = GrayColor;
        }else{
            _previewButton.hidden = YES;
            _saveButton.backgroundColor = OliveMainColor;
            _stateViewHeight.constant = 0;
            
            float size = self.view.bounds.size.width - 40;
            NSArray* states = [[AdvertServiceManager sharedManager] getStates];
            float y = -4;
            NSMutableArray* group = [NSMutableArray array];
            for (int i = 0; i < states.count; i++){
                TSAdvertState* state = [states objectAtIndex:i];
                float x = 0;
                
                if (i % 3){
                    x = size / 3 * i;
                }else
                {
                    y += 20 + 24;
                }
                
                RadioButton* radioButton = [[RadioButton alloc] initWithFrame:CGRectMake(x, y, size / 3, 24)];
                radioButton.tag = [state.ident intValue];
                [group addObject:radioButton];
                radioButton.autoresizingMask = UIViewAutoresizingNone;
                [radioButton setTitle:[state.title lowercaseString] forState:UIControlStateNormal];
                [radioButton setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
                [radioButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
                radioButton.groupButtons = group;
                radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                radioButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
                radioButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                [radioButton.titleLabel setFont:HelveticaLight18];
                [radioButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [radioButton addTarget:self action:@selector(setState:) forControlEvents:UIControlEventTouchUpInside];
                [_stateViewHolder addSubview:radioButton];
            }
            
            RadioButton* rb = (RadioButton*)group.firstObject;
            if (_advert.state.ident > 0){
                [rb setSelectedWithTag:[_advert.state.ident intValue]];
                _stateViewHolder.tag = [_advert.state.ident intValue];
            }else{
                [rb deselectAllButtons];
            }
            
            _stateViewHeight.constant = y + 34;
        }
        
        [_imagesCollectionView reloadData];
        [self collectionView:_imagesCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedImage inSection:0]];
        
    }else{
        _stateViewHeight.constant = 0;
        self.title = @"SELL SOMETHING";
    }
    
    //Add certifications
    
    float size = self.view.bounds.size.width - 40;
    NSArray* certifications = [[AdvertServiceManager sharedManager] getCertifications];
    float y = -44;
    NSMutableArray* group = [NSMutableArray array];
    for (int i = 0; i < certifications.count; i++){
        TSAdvertCertification* cert = [certifications objectAtIndex:i];
        float x = 0;
        
        if (i % 2){
            x = size / 2.;
        }else
        {
            y += 20 + 24;
        }
        
        RadioButton* radioButton = [[RadioButton alloc] initWithFrame:CGRectMake(x, y, 135, 24)];
        radioButton.tag = [cert.ident intValue];
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
        [_certificationsContainerView addSubview:radioButton];
    }
    
    RadioButton* rb = (RadioButton*)group.firstObject;
    if (_advert.certification.ident > 0){
        [rb setSelectedWithTag:[_advert.certification.ident intValue]];
        _certificationsContainerView.tag = [_advert.certification.ident intValue];
    }else{
        [rb deselectAllButtons];
    }
    
    for (NSLayoutConstraint *constraint in _certificationsContainerView.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = y + 24;
            break;
        }
    }
    
    //for debug
//    _additionalViewHeight.constant = _saveButton.frame.size.height + _saveButton.frame.origin.y + 20;
    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraints];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _collectionViewHeight.constant =  _images.count > 0 ? ((_imagesCollectionView.frame.size.width - 20) / 3 + 20) * ceilf((_images.count + 1) / 3.) : 0;
    _additionalViewHeight.constant = _productTitleTextField.text.length > 0 && _images.count > 0 ? _previewButton.frame.size.height + _previewButton.frame.origin.y + 20 : 0;
}

-(void)setCertification:(RadioButton*)owner{
    _certificationsContainerView.tag = owner.tag;
}

-(void)setState:(RadioButton*)owner{
    _stateViewHolder.tag = owner.tag;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:ADVERT_DETAIL_SEGUE]) {
        AdvertDetailViewController* vc = (AdvertDetailViewController*)segue.destinationViewController;
        [vc setAdvert:sender];
        [vc fromEdit:YES];
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

#pragma mark  - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = (UIImage*)[info objectForKey:UIImagePickerControllerOriginalImage];
    image = [image fixOrientation];
    CGSize size = image.size;
    image = [UIImage imageWithImage:image scaledToSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width * size.height / size.width)];
    
    StoredImage* stImage = [[StoredImage alloc] init];
    stImage.resId = [GUIDCreator getGuid];
    
    [image saveToPath:[ImageCacheUrlResolver getPathForImage:stImage]];
    
    if (_isAddNewImage){
       [_images addObject:stImage];
        _selectedImage = _images.count - 1;
    }else{
        [_images replaceObjectAtIndex:_selectedImage withObject:stImage];
    }
    
    _addImageLabel.text = @"EDIT";
    
    _collectionViewHeight.constant = ((_imagesCollectionView.frame.size.width - 20) / 3 + 20) * ceilf((_images.count + 1) / 3.);
    [_imagesCollectionView reloadData];
    [self collectionView:_imagesCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedImage inSection:0]];
    _additionalViewHeight.constant = _productTitleTextField.text.length > 0 && _images.count > 0 ? _previewButton.frame.size.height + _previewButton.frame.origin.y + 20 : 0;
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _images.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCollectionViewCell* cell = (ImageCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageViewCell" forIndexPath:indexPath];
    
    if (indexPath.row == _selectedImage){
        cell.layer.borderColor = OliveMainColor.CGColor;
        cell.layer.borderWidth = 3.;
    }else{
        cell.layer.borderWidth = 0.;
    }
    
    if (indexPath.row < _images.count){
        [cell.imageView loadImage:[_images objectAtIndex:indexPath.row]];

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
        [_mainImageView loadImage:[_images objectAtIndex:indexPath.row]];
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
    NSUInteger index = [_textControlsArray indexOfObject:_currentInputControl];
    index++;
    UIView* textControl = [_textControlsArray objectAtIndex:index];
    if (textControl == _expairyTextField && _expiratonPanelHeight.constant <= 0){
        index++;
        textControl = [_textControlsArray objectAtIndex:index];
    }
    [textControl becomeFirstResponder];
}

-(void)previousTextField
{
    NSUInteger index = [_textControlsArray indexOfObject:_currentInputControl];
    index--;
    UIView* textControl = [_textControlsArray objectAtIndex:index];
    if (textControl == _expairyTextField && _expiratonPanelHeight.constant <= 0){
        index--;
        textControl = [_textControlsArray objectAtIndex:index];
    }
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
    
    if (textField == _categoryTextField) {
        [self configureDataPickerWithData:[[AdvertServiceManager sharedManager] getCategories] withTextField:textField];
    }else if (textField == _subCategoryTextField) {
        TSAdvertCategory* category = [[AdvertServiceManager sharedManager] getCategoyWithId:[NSNumber numberWithInt:_categoryTextField.tag]];
        [self configureDataPickerWithData:category.subCategories withTextField:textField];
    }else if (textField == _unitTextField) {
        [self configureDataPickerWithData:[[AdvertServiceManager sharedManager] getPackageTypes] withTextField:textField];
    }else if (textField == _shippingTextField) {
        [self configureDataPickerWithData:[[AdvertServiceManager sharedManager] getShippings] withTextField:textField];
    }else if (textField == _conditionTextField) {
        [self configureDataPickerWithData:[[AdvertServiceManager sharedManager] getConditions] withTextField:textField];
    }else if (textField == _sizeTypeTextField) {
        [self configureDataPickerWithData:[[AdvertServiceManager sharedManager] getSizeType] withTextField:textField];
    }else if (textField == _expairyTextField) {
        UIDatePicker* datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, _keyboardFrame - textField.inputAccessoryView.frame.size.height)];
        datePicker.datePickerMode = UIDatePickerModeDate;
			datePicker.minimumDate = [NSDate date];
        textField.inputView = datePicker;
        [datePicker addTarget:self action:@selector(setExpirationDate:) forControlEvents:UIControlEventValueChanged];
			
			NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
			[formatter setDateStyle:NSDateFormatterLongStyle];
			_expairyTextField.text = [formatter stringFromDate:[NSDate date]];
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
            _additionalViewHeight.constant = _previewButton.frame.size.height + _previewButton.frame.origin.y + 20;
            [((UIToolbar*)textField.inputAccessoryView).items objectAtIndex:1].enabled = YES;
        }else{
            _additionalViewHeight.constant = 0;
            [((UIToolbar*)textField.inputAccessoryView).items objectAtIndex:1].enabled = NO;
        }
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    _additionalViewHeight.constant = _previewButton.frame.size.height + _previewButton.frame.origin.y + 20;
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
            if (_currentInputControl == _unitTextField){
                for (UILabel* unitLabel in _packagingLabelCollection){
                    unitLabel.text = ((TSBaseDictionaryEntity*)item).title;
                }
            }else if (_currentInputControl == _categoryTextField){
                _expiratonPanelHeight.constant = ((TSAdvertCategory*)item).isFood ? 100 : 0;
                if (!((TSAdvertCategory*)item).isFood){
                    _expairyTextField.text = @"";
                }
                _subCategoryTextField.tag = 0;
                _subCategoryTextField.text = @"";
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
    NSMutableArray* emptyFieldsArray = [NSMutableArray array];
    if (_images.count <= 0)
        [emptyFieldsArray addObject:@"Image"];
    if (_productTitleTextField.text.length <= 0)
        [emptyFieldsArray addObject:@"Title"];
    if (_categoryTextField.text.length <= 0)
        [emptyFieldsArray addObject:@"Category"];
    if (_subCategoryTextField.text.length <= 0)
        [emptyFieldsArray addObject:@"Subcategory"];
    if (_unitTextField.text.length <= 0)
        [emptyFieldsArray addObject:@"Unit / type of packaging"];
    if (_countUnitTextField.text.length <= 0)
        [emptyFieldsArray addObject:@"Count"];
    if (_minimumOrderTextField.text.length <= 0)
        [emptyFieldsArray addObject:@"Minimum order"];
    if (_priceTextField.text.length <= 0)
        [emptyFieldsArray addObject:@"Price"];
    if (_descriptionTextView.text.length <= 0)
        [emptyFieldsArray addObject:@"Product description"];
    if (_locationTextField.text.length <= 0)
        [emptyFieldsArray addObject:@"Location"];
    if (_conditionTextField.text.length <= 0)
        [emptyFieldsArray addObject:@"Condition"];
    if (_expiratonPanelHeight.constant > 0 && _expairyTextField.text.length <= 0)
        [emptyFieldsArray addObject:@"Expairy date"];
    
    if (_sizeTextField.text.length > 0 || _sizeTypeTextField.text.length > 0) {
        NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:SIZE_REGEX options:NSRegularExpressionCaseInsensitive error:nil];
        NSUInteger regExMatches = [regEx numberOfMatchesInString:_sizeTextField.text options:0 range:NSMakeRange(0, [_sizeTextField.text length])];
        if (regExMatches == 0){
            [emptyFieldsArray addObject:@"Size"];
        }
        if (_sizeTypeTextField.text.length <= 0){
            [emptyFieldsArray addObject:@"Size type"];
        }
    }
    
    if (_certificationsContainerView.tag <= 0)
        [emptyFieldsArray addObject:@"Certification"];
//    if (_keywordTextField.text.length <= 0)
//        [emptyFieldsArray addObject:@"Keywords"];
	
    NSMutableString* message = [[NSMutableString alloc] init];
    if (emptyFieldsArray.count > 0){
        [message appendFormat:@"%@ %@ required", [emptyFieldsArray componentsJoinedByString:@"\n"], emptyFieldsArray.count > 0 ? @"are" : @"is"];
    }
    
    int minimumOrder = [_minimumOrderTextField.text intValue];
    int count = [_countUnitTextField.text intValue];
    
    if (_countUnitTextField.text.length > 0 && _minimumOrderTextField.text.length > 0 &&  minimumOrder > count){
        [message appendFormat:@"%@Minimum order quantity is greater than units available.", message.length > 0 ? @"\n" : @""];
    }
    
    if (message.length > 0){
        [self showOkAlert:@"" text:message compleate:nil];
        return NO;
    }else{
        return YES;
    }
}

-(void)createAdvert{
    if (!_advert){
        _advert = [[TSAdvert alloc] init];
    }else{
        _advert = [_advert copy];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    
    NSMutableArray* images = [[NSMutableArray alloc] init];
    for (id<ImageProtocol> image in _images){
        TSImageEntity* advImage = image;
        if ([image isKindOfClass:[StoredImage class]]){
            UIImage* uiImage = [UIImage imageWithContentsOfFile:[ImageCacheUrlResolver getPathForImage:image]];
            
            advImage = [[TSImageEntity alloc] init];
            advImage.resId = image.resId;
            advImage.height = (int)uiImage.size.height;
            advImage.width = (int)uiImage.size.width;
        }
        [images addObject:advImage];
    }
    [_advert setPhotos:images];
    
    _advert.name = _productTitleTextField.text;
    _advert.guidePrice = [_priceTextField.text floatValue];
    _advert.location = _locationTextField.text;
    _advert.adDescription = _descriptionTextView.text;
    _advert.dateExpires = _expairyTextField.text.length > 0 ? [formatter dateFromString:_expairyTextField.text] : nil;
    
    _advert.minOrderQuantity = [_minimumOrderTextField.text intValue];
    _advert.certificationOther = _otherTextField.text;
    _advert.count = [_countUnitTextField.text intValue];
    _advert.category = [[AdvertServiceManager sharedManager] getCategoyWithId:[NSNumber numberWithInt:_categoryTextField.tag]];
    
    for (TSAdvertSubCategory* subCategory in _advert.category.subCategories) {
        if ([subCategory.ident intValue] == _subCategoryTextField.tag){
            _advert.subCategory = subCategory;
            break;
        }
    }
    
    _advert.certification = [[AdvertServiceManager sharedManager] getCertificationWithId:[NSNumber numberWithInt:_certificationsContainerView.tag]];
    if (_stateViewHolder.tag > 0)
        _advert.state = [[AdvertServiceManager sharedManager] getStateWithId:[NSNumber numberWithInt:_stateViewHolder.tag]];
    _advert.condition = [[AdvertServiceManager sharedManager] getConditionWithId:[NSNumber numberWithInt:_conditionTextField.tag]];
    _advert.shipping = [[AdvertServiceManager sharedManager] getShippingWithId:[NSNumber numberWithInt:_shippingTextField.tag]];
    
    if (_sizeTypeTextField.text.length > 0){
        _advert.size = _sizeTextField.text;
//        _advert.sizeType = [[AdvertServiceManager sharedManager] getSizeTypeWithId:[NSNumber numberWithInt:_sizeTypeTextField.tag]];
    }else{
        _advert.size = @"";
//        _advert.sizeType = nil;
    }
    _advert.tags = _keywordTextField.text;
    _advert.packaging = [[AdvertServiceManager sharedManager] getPackageTypeWithId:[NSNumber numberWithInt:_unitTextField.tag]];
    _advert.author = [[UserServiceManager sharedManager] getMe];
}

- (IBAction)saveAdvert:(id)sender{
    if ([self verifyFields]){
        [self createAdvert];
        __block NSString* message = @"Advert edited";
        if (!_advert.ident){
            _advert.isInDrafts = true;
            message = @"Advert created";
        }
        
        [self showLoading];
        [[AdvertServiceManager sharedManager] createAdvert:_advert compleate:^(NSError *error) {
            [self hideLoading];
            NSString* title = @"";
            
            if (error){
                title = @"Error";
                message = ERROR_MESSAGE(error);
            }
            UIAlertController * alertController =   [UIAlertController
                                                     alertControllerWithTitle:title
                                                     message:message
                                                     preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [self dismissViewControllerAnimated:YES completion:nil];
                if (!error){
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
    }
}

- (IBAction)previewAdvert:(id)sender {
    if ([self verifyFields]){
        [self createAdvert];
        [self performSegueWithIdentifier:ADVERT_DETAIL_SEGUE sender:_advert];
    }
}

@end
