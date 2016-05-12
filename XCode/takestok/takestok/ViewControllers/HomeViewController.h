//
//  ViewController.h
//  takestok
//
//  Created by Artem on 4/6/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class TextFieldBorderBottom;

@interface HomeViewController : BaseViewController<UITextFieldDelegate>{
    
    __weak IBOutlet UIScrollView *_scrollView;
    __weak IBOutlet TextFieldBorderBottom *_serachTextField;
}

- (IBAction)showMenuAction:(id)sender;

@end

