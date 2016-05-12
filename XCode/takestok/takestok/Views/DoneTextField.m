//
//  DoneTextField.m
//  takestok
//
//  Created by Artem on 5/11/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "DoneTextField.h"

@implementation DoneTextField

-(void)awakeFromNib
{
    [super awakeFromNib];
    UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    keyboardToolBar.barStyle = UIBarStyleDefault;
    [keyboardToolBar setItems: [NSArray arrayWithObjects:
                                [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)],
                                nil]];
//    self.inputAccessoryView = keyboardToolBar;
}

-(void)resignKeyboard{
    [self resignFirstResponder];
}

@end
