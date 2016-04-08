//
//  SellViewController.h
//  takestok
//
//  Created by Artem on 4/7/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextFieldBorderBottom;
@class PaddingTextField;

@interface SellViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
    
    NSMutableArray* _images;
    
    BOOL _isAddNewImage;
    int _selectedImage;
    
    float _keyboardFrame;
    NSArray* _pickerData;
    UIPickerView* _textPiker;
    
    __weak IBOutlet UIScrollView *_scrollView;
    __weak IBOutlet UIImageView *_mainImageView;
    __weak IBOutlet UILabel *_addImageLabel;
    
    __weak IBOutlet UICollectionView *_imagesCollectionView;
    __weak IBOutlet NSLayoutConstraint *_collectionViewHeight;
  
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
    __weak IBOutlet TextFieldBorderBottom *_otherTextField;
    __weak IBOutlet TextFieldBorderBottom *_keywordTextField;
    
}

- (IBAction)addImage:(id)sender;

@end
