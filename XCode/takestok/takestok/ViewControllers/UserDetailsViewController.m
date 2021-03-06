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
#import "TSUserEntity.h"
#import "TSUserBusinessType.h"
#import "TSUserSubBusinessType.h"
#import "TSAdvert.h"

@interface UserDetailsViewController ()

@end

@implementation UserDetailsViewController

-(void)setUser:(TSUserEntity *)user{
    _user = user;
    if (self.isViewLoaded){
        [self fillData];
    }
}

-(void)setAdvert:(TSAdvert*)advert{
    _parentAdvert = advert;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    _otherUserDetails.preferredMaxLayoutWidth = 100;
    if (_user){
        [self fillData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:SIMILAR_ADVERTS_SEQUE]) {
        _advertsViewController = (AdvertsCollectionViewController*)segue.destinationViewController;
        _advertsViewController.delegate = self;
        if (self.isViewLoaded && _parentAdvert){
            [self fillData];
        }
    }
}

-(NSMutableAttributedString*)nextLine{
    NSMutableAttributedString* spaceString = [[NSMutableAttributedString alloc] initWithString:@"\n \n"];
    [spaceString addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:6]
                        range:NSMakeRange(0, spaceString.length)];
    return spaceString;
}

-(void)dataLoaded:(BOOL)isEmpty{
    if (isEmpty){
        _similarAdvertsHeight.constant = 0;
        [self.view setNeedsUpdateConstraints];
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }
}

-(BOOL)isForUser{
    return YES;
}

-(void)fillData{
    if (_user.photo){
        [_userPicture loadImage:_user.photo];
    }else{
        [_userPicture setImage:[UIImage imageNamed:@"user_placeholder"]];
    }
    
    _userameLabel.text = _user.userName;
    _ratingView.rate = _user.rating;
    _ratingLabel.text = [NSString stringWithFormat:@"%.02f", _user.rating];
    
    NSMutableAttributedString* additionalString = [[NSMutableAttributedString alloc] init];
    if (_user.businessName.length > 0){
        NSMutableAttributedString* businessTitleString = [[NSMutableAttributedString alloc] initWithString:@"Business name:"];
        [businessTitleString addAttribute:NSFontAttributeName
                             value:HelveticaNeue18
                             range:NSMakeRange(0, businessTitleString.length)];
        [businessTitleString addAttribute:NSForegroundColorAttributeName value:GrayColor range:NSMakeRange(0, businessTitleString.length)];
        [additionalString appendAttributedString:businessTitleString];
         [additionalString appendAttributedString:[self nextLine]];
        
        NSMutableAttributedString* businessNameString = [[NSMutableAttributedString alloc] initWithString:_user.businessName];
        [businessNameString addAttribute:NSFontAttributeName
                                   value:HelveticaLight18
                                   range:NSMakeRange(0, businessNameString.length)];
        [businessNameString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, businessNameString.length)];
        [additionalString appendAttributedString:businessNameString];
    }
    
    if (_user.businessType){
        if (additionalString.length > 0){
            [additionalString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
        }
        NSMutableAttributedString* businessTitleString = [[NSMutableAttributedString alloc] initWithString:@"Type of businnes:"];
        [businessTitleString addAttribute:NSFontAttributeName
                                    value:HelveticaNeue18
                                    range:NSMakeRange(0, businessTitleString.length)];
        [businessTitleString addAttribute:NSForegroundColorAttributeName value:GrayColor range:NSMakeRange(0, businessTitleString.length)];
        [additionalString appendAttributedString:businessTitleString];
         [additionalString appendAttributedString:[self nextLine]];
        
        NSMutableAttributedString* businessNameString = [[NSMutableAttributedString alloc] initWithString:_user.businessType.title];
        [businessNameString addAttribute:NSFontAttributeName
                                   value:HelveticaLight18
                                   range:NSMakeRange(0, businessNameString.length)];
        [businessNameString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, businessNameString.length)];
        [additionalString appendAttributedString:businessNameString];
    }
    
    if (_user.subBusinessType){
        if (additionalString.length > 0){
            [additionalString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
        }
        NSMutableAttributedString* businessTitleString = [[NSMutableAttributedString alloc] initWithString:@"Subtype:"];
        [businessTitleString addAttribute:NSFontAttributeName
                                    value:HelveticaNeue18
                                    range:NSMakeRange(0, businessTitleString.length)];
        [businessTitleString addAttribute:NSForegroundColorAttributeName value:GrayColor range:NSMakeRange(0, businessTitleString.length)];
        [additionalString appendAttributedString:businessTitleString];
        [additionalString appendAttributedString:[self nextLine]];
        
        NSMutableAttributedString* businessNameString = [[NSMutableAttributedString alloc] initWithString:_user.subBusinessType.title];
        [businessNameString addAttribute:NSFontAttributeName
                                   value:HelveticaLight18
                                   range:NSMakeRange(0, businessNameString.length)];
        [businessNameString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, businessNameString.length)];
        [additionalString appendAttributedString:businessNameString];
    }
    
    [_otherUserDetails setAttributedText:additionalString];
    
    if (!_parentAdvert.ident){
        _similarAdvertsHeight.constant = 0;
    }else{
        [_advertsViewController setAdvert:_parentAdvert];
    }
    
    [self.view setNeedsUpdateConstraints];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

@end
