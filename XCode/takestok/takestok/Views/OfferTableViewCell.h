//
//  OfferTableViewCell.h
//  takestok
//
//  Created by Artem on 4/25/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OfferTableViewCell;
@protocol OfferActionDelegate <NSObject>

-(void)acceptOfferAction:(OfferTableViewCell*)owner;
-(void)rejectOfferAction:(OfferTableViewCell*)owner;
-(void)counterOfferAction:(OfferTableViewCell*)owner;

@end

@class BackgroundImageView;
@interface OfferTableViewCell : UITableViewCell

@property (weak)id<OfferActionDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *autorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *myRequestLabel;
@property (weak, nonatomic) IBOutlet UILabel *myQuantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *myPricelabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIView *operationsView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *counterStatus;
@property (weak, nonatomic) IBOutlet UILabel *counterComment;

- (IBAction)acceptAction:(id)sender;
- (IBAction)rejectAction:(id)sender;
- (IBAction)counterAction:(id)sender;


@end


