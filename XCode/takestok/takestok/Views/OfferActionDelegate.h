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
-(void)contactUsAction:(UITableViewCell*)owner;
-(void)contactUserAction:(UITableViewCell*)owner;

@optional
-(void)sellerArrangedTransport:(UITableViewCell*)owner;
-(void)buyerArrangedTransport:(UITableViewCell*)owner;

@end
