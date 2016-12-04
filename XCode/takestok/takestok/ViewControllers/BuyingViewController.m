//
//  BuyingViewController.m
//  takestok
//
//  Created by Artem on 4/20/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BuyingViewController.h"
#import "TSAdvert.h"
#import "TSOffer.h"
#import "TSOfferStatus.h"
#import "BackgroundImageView.h"
#import "BuyingTableViewCell.h"
#import "OfferServiceManager.h"
#import "UserServiceManager.h"
#import "BuyingOffersViewController.h"
#import "AdvertServiceManager.h"

@implementation BuyingViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    _offers = [NSMutableArray array];
    _adverts = [NSMutableDictionary dictionary];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = OliveMainColor;
    [_refreshControl addTarget:self action:@selector(reloadData:) forControlEvents:UIControlEventValueChanged];
    [_buyingTableView addSubview:_refreshControl];
    
    _loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _loadingIndicator.color = OliveMainColor;
    _loadingIndicator.hidesWhenStopped = YES;
    [_loadingIndicator stopAnimating];
    [_buyingTableView addSubview:_loadingIndicator];
    
    _buyingTableView.estimatedRowHeight = 116.0;
    _buyingTableView.rowHeight = 120;
    
    self.title = @"BUYING";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_buyingTableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_offers.count == 0 || _adverts.count == 0){
        [self reloadData:nil];
    }
}

-(void)reloadData:(id)owner{
    _page = 1;
    [_offers removeAllObjects];
    [_adverts removeAllObjects];
    [_buyingTableView reloadData];
    [_refreshControl beginRefreshing];
    
    if (_buyingTableView.contentOffset.y == 0) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
            _buyingTableView.contentOffset = CGPointMake(0, -_refreshControl.frame.size.height);
        } completion:nil];
    }
    [self loadData];
}

-(void)loadData{
    [[OfferServiceManager sharedManager] loadMyOffersWithPage:_page compleate:^(NSArray *result, NSDictionary* adverts, NSDictionary *additionalData, NSError *error) {
        if (error){
            [self showOkAlert:@"Error" text:ERROR_MESSAGE(error) compleate:nil];
        }
        else
        {
            if ([additionalData objectForKeyNotNull:@"next"]){
                _page ++;
            }else{
                _page = 0;
            };
            [_offers addObjectsFromArray:result];
            [_adverts addEntriesFromDictionary:adverts];
            [_buyingTableView reloadData];
            
            if (_offers.count == 0){
                [self showNoItems];
            }else{
                [self hideNoItems];
            }
        }
        [_loadingIndicator stopAnimating];
        if (_refreshControl.isRefreshing)
            [_refreshControl endRefreshing];
        _buyingTableView.contentInset = UIEdgeInsetsZero;
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:BUYER_OFFERS_SEQUE]) {
        BuyingOffersViewController* vc = (BuyingOffersViewController*)segue.destinationViewController;
        [vc setAdvert:[sender objectForKey:@"advert"] andOffer:[sender objectForKey:@"offer"]];
    }
}

#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _offers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BuyingTableViewCell* cell = (BuyingTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"BuyingTableViewCell"];
    TSOffer* offer = [_offers objectAtIndex:indexPath.row];
    while (offer.childOffers.count > 0) {
        offer = offer.childOffers.lastObject;
    }
    TSAdvert* advert = [_adverts objectForKey:offer.advertId];
    [cell.adImageView loadImage:advert.photos.firstObject];
    cell.soldOutImageView.hidden = ![advert.state.ident isEqualToNumber:SOLD_OUT_IDENT];
    cell.titleLabel.text = advert.name;
    cell.priceLabel.text = [NSString stringWithFormat:@"£%.02f", advert.guidePrice];
    cell.locationLabel.text = advert.location;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = kCFDateFormatterMediumStyle;
    cell.createdLabel.text = [NSString stringWithFormat:@"Updated: %@", [dateFormatter stringFromDate:offer.dateUpdated]];
    
    cell.offerPriceLabel.text = [NSString stringWithFormat:@"£%.02f", offer.price];
    cell.offerCountLabel.text = [NSString stringWithFormat:@"%i%@", offer.quantity, advert.packaging ? advert.packaging.title: @""];
    
    cell.offerTextLabel.text = [offer.status.title uppercaseString];
    cell.offerTextLabel.textColor = [UIColor redColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TSOffer* offer = [_offers objectAtIndex:indexPath.row];
    TSAdvert* advert = [_adverts objectForKey:offer.advertId];
    [[AdvertServiceManager sharedManager] sendReadNotificationsWithAdvert:advert];
    [self performSegueWithIdentifier:BUYER_OFFERS_SEQUE sender:[NSDictionary dictionaryWithObjectsAndKeys:offer, @"offer", advert, @"advert", nil]];
}


@end
