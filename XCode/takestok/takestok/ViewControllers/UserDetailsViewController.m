//
//  UserDetailsViewController.m
//  takestok
//
//  Created by Artem on 5/4/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "UserDetailsViewController.h"
#import "User.h"
#import "Settings.h"
#import "BackgroundImageView.h"
#import "PaddingTextField.h"

@interface UserDetailsViewController ()

@end

@implementation UserDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _user = [User getEntityWithId:[Settings getUserId]];
    [self refreshUserData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshUserData{

    if (_user){
        _userNameTextField.text = _user.userName;
        _emailTextField.text = _user.email;
    }
    
    [self.view setNeedsUpdateConstraints];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (IBAction)changePasswordAction:(id)sender {
}

- (IBAction)submit:(id)sender {
}
@end
