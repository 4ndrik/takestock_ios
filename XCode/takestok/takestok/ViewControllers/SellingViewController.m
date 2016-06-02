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
#import "QAViewController.h"

@implementation SellingViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:OFFERS_UPDATED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:QUESTIONS_UPDATED_NOTIFICATION object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshData:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:OFFERS_UPDATED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QUESTIONS_UPDATED_NOTIFICATION object:nil];
}

-(void)refreshData:(id)owner{
    _adverts = [Advert getMyAdverts];
    [_sellingTableView reloadData];
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
    NSDate* updatedDate = [NSDate dateWithTimeIntervalSinceReferenceDate:advert.date_updated];
    cell.createdLabel.text = [NSString stringWithFormat:@"Updated: %@", [dateFormatter stringFromDate:updatedDate]];
    
    cell.offersCountLabel.text = [NSString stringWithFormat:@"%i", advert.offers.count];
    cell.questionCountLabel.text = [NSString stringWithFormat:@"%i", advert.questions.count];
    
    cell.expiresDayCountLabel.text = advert.expires > 0 ? [NSString stringWithFormat:@"%i", [[NSDate dateWithTimeIntervalSinceReferenceDate:advert.expires] daysFromDate:[NSDate date]]] : @"N/A";
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"OffersSegue"]) {
        OfferManagerViewController* vc = (OfferManagerViewController*)segue.destinationViewController;
        [vc setAdvert:sender];
    }else if ([segue.identifier isEqualToString:@"QuestionSegue"]) {
        QAViewController* vc = (QAViewController*)segue.destinationViewController;
        [vc setAdvert:sender];
    }else if([segue.identifier isEqualToString:@"AdvertDetailSegue"]) {
        AdvertDetailViewController* vc = (AdvertDetailViewController*)segue.destinationViewController;
        [vc setAdvert:sender];
    }else if([segue.identifier isEqualToString:@"EditAdvertSegue"]) {
        CreateAdvertViewController* vc = (CreateAdvertViewController*)segue.destinationViewController;
        [vc setAdvert:sender];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Advert* advert = [_adverts objectAtIndex:indexPath.row];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *manageOffersAction = [UIAlertAction actionWithTitle:@"Manage offers"
                                                             style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                 [tableView deselectRowAtIndexPath:indexPath animated:NO];
                                                                 [self performSegueWithIdentifier:@"OffersSegue" sender:advert];
                                                             }];
    UIAlertAction *viewMessagesAction = [UIAlertAction actionWithTitle:@"View messages"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              [tableView deselectRowAtIndexPath:indexPath animated:NO];
                                                              [self performSegueWithIdentifier:@"QuestionSegue" sender:advert];
                                                          }];
    UIAlertAction *viewAdvertAction = [UIAlertAction actionWithTitle:@"View advert"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                [tableView deselectRowAtIndexPath:indexPath animated:NO];
                                                                [self performSegueWithIdentifier:@"AdvertDetailSegue" sender:advert];
                                                           }];
    
    UIAlertAction *editAdvertAction = [UIAlertAction actionWithTitle:@"Edit advert"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                [tableView deselectRowAtIndexPath:indexPath animated:NO];
                                                                [self performSegueWithIdentifier:@"EditAdvertSegue" sender:advert];
                                                           }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                          style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
                                                               [tableView deselectRowAtIndexPath:indexPath animated:NO];
                                                          }];
    if (advert.offers.count > 0)
        [alert addAction:manageOffersAction];
    if (advert.questions.count > 0)
        [alert addAction:viewMessagesAction];
    [alert addAction:viewAdvertAction];
    [alert addAction:editAdvertAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
