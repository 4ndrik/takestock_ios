//
//  BuyingViewController.m
//  takestok
//
//  Created by Artem on 4/20/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BuyingViewController.h"
#import "Advert.h"
#import "BackgroundImageView.h"
#import "BuyingTableViewCell.h"
#import "OfferManagerViewController.h"

@implementation BuyingViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    _adverts = [Advert getAll];
}

#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _adverts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BuyingTableViewCell* cell = (BuyingTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"BuyingTableViewCell"];
    Advert* advert = [_adverts objectAtIndex:indexPath.row];
    [cell.adImageView loadImage:advert.images.firstObject];
    cell.titleLabel.text = advert.name;
    cell.createdLabel.text = @"Offer made";
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"OfferManagerSegue"] && [sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [_buyingTableView indexPathForCell:sender];
        OfferManagerViewController* oVC = (OfferManagerViewController*)segue.destinationViewController;
        [oVC setAdvert:([_adverts objectAtIndex:indexPath.row])];
    }
}


@end
