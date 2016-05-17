//
//  SellingViewControllers.m
//  takestok
//
//  Created by Artem on 4/20/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "SellingViewController.h"
#import "SellingTableViewCell.h"
#import "Advert.h"
#import "BackgroundImageView.h"
#import "NSDate+Extended.h"
#import "PaddingLabel.h"
#import "AdvertDetailViewController.h"
#import "CreateAdvertViewController.h"
#import "OfferManagerViewController.h"

@implementation SellingViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    _adverts = [Advert getMyAdverts];
}
   
#pragma mark - UITableViewDelegate UITableViewDataSource
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _adverts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SellingTableViewCell* cell = (SellingTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"SellingTableViewCell"];
    Advert* advert = [_adverts objectAtIndex:indexPath.row];
    [cell.adImageView loadImage:advert.images.firstObject];
    cell.titleLabel.text = advert.name;
    
    cell.priceLabel.text = [NSString stringWithFormat:@"£%.02f", advert.guidePrice];
    cell.countLabel.text = [NSString stringWithFormat:@"%i%@", advert.count, advert.packaging ? advert.packaging.title: @""];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = kCFDateFormatterMediumStyle;
    NSDate* updatedDate = [NSDate dateWithTimeIntervalSinceReferenceDate:advert.updated];
    cell.createdLabel.text = [NSString stringWithFormat:@"Updated: %@", [dateFormatter stringFromDate:updatedDate]];
    
    cell.offersCountLabel.text = [NSString stringWithFormat:@"%i", advert.offers.count];
    cell.questionCountLabel.text = @"0";
    
    cell.expiresDayCountLabel.text = [NSString stringWithFormat:@"%i", [[NSDate dateWithTimeIntervalSinceReferenceDate:advert.expires] daysFromDate:[NSDate date]]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Advert* advert = [_adverts objectAtIndex:indexPath.row];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *manageOffersAction = [UIAlertAction actionWithTitle:@"Manage offers"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              [tableView deselectRowAtIndexPath:indexPath animated:NO];
                                                              
                                                              UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                              OfferManagerViewController *controller = (OfferManagerViewController *)[storyboard instantiateViewControllerWithIdentifier:@"OfferManagerViewController"];
                                                              [controller setAdvert:[_adverts objectAtIndex:indexPath.row]];
                                                              [self.navigationController pushViewController:controller animated:YES];
                                                              NSLog(@"You pressed button one");
                                                          }];
    UIAlertAction *viewAdvertAction = [UIAlertAction actionWithTitle:@"View advert"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                [tableView deselectRowAtIndexPath:indexPath animated:NO];
                                                               UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                               AdvertDetailViewController *controller = (AdvertDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AdvertDetailViewController"];
                                                               [controller setAdvert:[_adverts objectAtIndex:indexPath.row]];
                                                               [self.navigationController pushViewController:controller animated:YES];
                                                           }];
    
    UIAlertAction *editAdvertAction = [UIAlertAction actionWithTitle:@"Edit advert"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                [tableView deselectRowAtIndexPath:indexPath animated:NO];
                                                               UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                               CreateAdvertViewController *controller = (CreateAdvertViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CreateAdvertViewController"];
                                                               [controller setAdvert:[_adverts objectAtIndex:indexPath.row]];
                                                               [self.navigationController pushViewController:controller animated:YES];
                                                           }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                          style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
                                                               [tableView deselectRowAtIndexPath:indexPath animated:NO];
                                                              NSLog(@"You pressed button two");
                                                          }];
    if (advert.offers.count > 0)
        [alert addAction:manageOffersAction];
    [alert addAction:viewAdvertAction];
    [alert addAction:editAdvertAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
