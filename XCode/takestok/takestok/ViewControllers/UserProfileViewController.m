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

@interface UserProfileViewController ()

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _user = [User getMe];
    [self refreshUserData];
    
    _paymantInformation.cornerRadius = 3.;
    _paymantInformation.borderColor = [UIColor colorWithRed:235./255. green:235./255. blue:235./255. alpha:1.];
    _paymantInformation.font = HelveticaLight18;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    
    // Do any additional setup after loading the view.
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
    }
    
    [self.view setNeedsUpdateConstraints];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = (UIImage*)[info objectForKey:UIImagePickerControllerOriginalImage];
    image = [image fixOrientation];
    //TODO: Change size if need
    CGSize size = image.size;
    image = [UIImage imageWithImage:image scaledToSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width * size.height / size.width)];
    
    _selectedImage = [[StoredImage alloc] init];
    _selectedImage.resId = [GUIDCreator getGuid];
    
    [image saveToPath:[ImageCacheUrlResolver getPathForImage:_selectedImage]];
    
    
    _userImageView.image = image;
    _addImageTitle.text = @"EDIT";
}

-(void)showImagePickerController:(BOOL)showLibrary{
    UIImagePickerController* photoLibraryContoller = [[UIImagePickerController alloc] init];
    photoLibraryContoller.delegate = self;
    [photoLibraryContoller setSourceType: showLibrary? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:photoLibraryContoller animated:YES completion:nil];
}

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
    _scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
    
}

#pragma mark - Actions

- (IBAction)submit:(id)sender {
    if ([self validateUser]){
        NSUndoManager* undoManager = [[NSUndoManager alloc] init];
        _user.managedObjectContext.undoManager = undoManager;
        [undoManager beginUndoGrouping];
        
        Image* uImage = [Image storedEntity];
        uImage.resId = _selectedImage.resId;
        _user.image = uImage;
        
        [undoManager endUndoGrouping];
        
        [self showLoading];
        [[ServerConnectionHelper sharedInstance] updateUser:_user compleate:^(NSError *error) {
            NSString* message = @"User updated successfully";
            NSString* title = @"";
            if (error){
                [undoManager undo];
                message = ERROR_MESSAGE(error);
                title = @"Error";
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

@end
