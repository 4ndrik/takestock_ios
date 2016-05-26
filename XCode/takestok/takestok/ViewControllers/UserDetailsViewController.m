//
//  UserDetailsViewController.m
//  takestok
//
//  Created by Artem on 5/26/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "UserDetailsViewController.h"
#import "BackgroundImageView.h"
#import "RatingView.h"
#import "User.h"

@interface UserDetailsViewController ()

@end

@implementation UserDetailsViewController

-(void)setUser:(User *)user{
    _user = user;
    if (self.isViewLoaded){
        [self fillData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_user){
        [self fillData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)fillData{
    
    if (_user.image){
        [_userPicture loadImage:_user.image];
        _noImageLabel.hidden = YES;
    }else{
        _noImageLabel.hidden = NO;
    }
    
    _userameLabel.text = _user.userName;
    _ratingView.rate = _user.rating;
    _ratingLabel.text = [NSString stringWithFormat:@"%.02f", _user.rating];
}

@end
