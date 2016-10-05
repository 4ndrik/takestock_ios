//
//  Header.h
//  takestok
//
//  Created by Artem on 5/23/16.
//  Copyright © 2016 Artem. All rights reserved.
//

@protocol OfferActionDelegate <NSObject>

@required

-(void)acceptOfferAction:(UITableViewCell*)owner;
-(void)rejectOfferAction:(UITableViewCell*)owner;
-(void)counterOfferAction:(UITableViewCell*)owner;
-(void)mainAction:(UITableViewCell*)owner;

@optional
-(void)organizeDispatch:(UITableViewCell*)owner;
//-(void)organize:(UITableViewCell*)owner;

@end
