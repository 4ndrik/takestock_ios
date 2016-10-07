//
//  SellViewController.h
//  takestok
//
//  Created by Artem on 4/7/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class TextFieldBorderBottom;
@class PaddingTextField;
@class TSAdvert;
@class BackgroundImageView;

@interface CreateAdvertViewController : BaseViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
    
    NSMutableArray* _images;
    
    TSAdvert* _advert;
    
    BOOL _isAddNewImage;
    NSInteger _selectedImage;
    
    float _keyboardFrame;
    NSArray* _pickerData;
    UIPickerView* _textPiker;
    id _currentInputControl;
    
    __weak IBOutlet UIScrollView *_scrollView;
    __weak IBOutlet BackgroundImageView *_mainImageView;
    __weak IBOutlet UILabel *_addImageLabel;
    
    __weak IBOutlet UICollectionView *_imagesCollectionView;
    __weak IBOutlet NSLayoutConstraint *_collectionViewHeight;
    __weak IBOutlet NSLayoutConstraint *_additionalViewHeight;
    __weak IBOutlet NSLayoutConstraint *_stateViewHeight;
  
    __weak IBOutlet UIButton *_saveButton;
    __weak IBOutlet UIButton *_previewButton;
    
    NSArray* _textControlsArray;
    __weak IBOutlet TextFieldBorderBottom *_productTitleTextField;
    __weak IBOutlet PaddingTextField *_categoryTextField;
    __weak IBOutlet PaddingTextField *_subCategoryTextField;
    __weak IBOutlet PaddingTextField *_unitTextField;
    __weak IBOutlet PaddingTextField *_countUnitTextField;
    __weak IBOutlet PaddingTextField *_minimumOrderTextField;
    __weak IBOutlet PaddingTextField *_priceTextField;
    __weak IBOutlet UITextView *_descriptionTextView;
    __weak IBOutlet TextFieldBorderBottom *_locationTextField;
    __weak IBOutlet PaddingTextField *_shippingTextField;
    __weak IBOutlet PaddingTextField *_conditionTextField;
    __weak IBOutlet PaddingTextField *_expairyTextField;
    __weak IBOutlet TextFieldBorderBottom *_sizeTextField;
    __weak IBOutlet PaddingTextField *_sizeTypeTextField;
    __weak IBOutlet UIView *_certificationsContainerView;
    __weak IBOutlet TextFieldBorderBottom *_otherTextField;
    __weak IBOutlet TextFieldBorderBottom *_keywordTextField;
    __weak IBOutlet UIView *_stateViewHolder;
    
    IBOutletCollection(UILabel) NSArray *_packagingLabelCollection;
}

-(void)setAdvert:(TSAdvert*)advert;

- (IBAction)addImage:(id)sender;
- (IBAction)saveAdvert:(id)sender;
- (IBAction)previewAdvert:(id)sender;

@end
