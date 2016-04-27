//
//  OfferManagerViewController.m
//  takestok
//
//  Created by Artem on 4/25/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "OfferManagerViewController.h"
#import "OfferTableViewCell.h"
#import "OfferTitleView.h"
#import "UIView+NibLoadView.h"
#import "BackgroundImageView.h"
#import "TopBottomStripesLabel.h"

@implementation OfferManagerViewController
@synthesize advert = _advert;

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OfferTableViewCell* cell = (OfferTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"OfferTableViewCell"];
    //HArdcoded for Mike
    if (indexPath.row == 0){
        cell.myRequestView.hidden = YES;
        cell.statusLabel.hidden = YES;
        cell.operationsView.hidden = NO;
    }else{
        cell.myRequestView.hidden = NO;
        cell.statusLabel.hidden = NO;
        cell.operationsView.hidden = YES;
    }
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [OfferTitleView defaultSize];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    OfferTitleView* offerTitleView =  [OfferTitleView loadFromXib];
    [offerTitleView.advertImageView loadImage:[_advert.images firstObject]];
    offerTitleView.advertTitleLabel.text = _advert.name;
//    offerTitleView.advertAvailableLabel.text = [_adve
    return offerTitleView;
}

@end
