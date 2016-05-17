//
//  BuyingViewController.m
//  takestok
//
//  Created by Artem on 4/20/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BuyingViewController.h"
#import "Advert.h"
#import "Offer.h"
#import "OfferStatus.h"
#import "BackgroundImageView.h"
#import "BuyingTableViewCell.h"
#import "OfferManagerViewController.h"

@implementation BuyingViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    _offers = [Offer getMyOffers];
}

#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _offers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BuyingTableViewCell* cell = (BuyingTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"BuyingTableViewCell"];
    Offer* offer = [_offers objectAtIndex:indexPath.row];
    Advert* advert = offer.advert;
    [cell.adImageView loadImage:advert.images.firstObject];
    cell.titleLabel.text = advert.name;
    cell.priceLabel.text = [NSString stringWithFormat:@"£%.02f", advert.guidePrice];
    cell.quantityLabel.text = [NSString stringWithFormat:@"%i%@", advert.count, advert.packaging ? advert.packaging.title: @""];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = kCFDateFormatterMediumStyle;
    NSDate* updatedDate = [NSDate dateWithTimeIntervalSinceReferenceDate:offer.updated];
    cell.createdLabel.text = [NSString stringWithFormat:@"Updated: %@", [dateFormatter stringFromDate:updatedDate]];
    
    cell.offerPriceLabel.text = [NSString stringWithFormat:@"£%.02f", offer.price];
    cell.offerCountLabel.text = [NSString stringWithFormat:@"%i%@", offer.quantity, advert.packaging ? advert.packaging.title: @""];
    
    cell.offerStatusLabel.text = [offer.status.title uppercaseString];
    
    return cell;
}


@end
