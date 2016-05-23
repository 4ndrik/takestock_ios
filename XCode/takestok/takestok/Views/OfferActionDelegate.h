//
//  Header.h
//  takestok
//
//  Created by Artem on 5/23/16.
//  Copyright © 2016 Artem. All rights reserved.
//

@protocol OfferActionDelegate <NSObject>

@optional
-(void)mainAction:(UITableViewCell*)owner;
-(void)counterOfferAction:(UITableViewCell*)owner;

@required
-(void)acceptOfferAction:(UITableViewCell*)owner;
-(void)rejectOfferAction:(UITableViewCell*)owner;

@end
