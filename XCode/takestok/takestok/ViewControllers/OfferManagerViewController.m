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
#import "Offer.h"
#import "OfferStatus.h"

@implementation OfferManagerViewController
@synthesize advert = _advert;

-(void)viewDidLoad{
    [super viewDidLoad];
    _offers = [_advert.offers allObjects];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _offers.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OfferTableViewCell* cell = (OfferTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"OfferTableViewCell"];
    
    cell.delegate = self;
    
    Offer* offer = [_offers objectAtIndex:indexPath.row];
    
    cell.autorNameLabel.text = offer.user.userName;
    cell.quantityLabel.text = [NSString stringWithFormat:@"£%.02f", offer.price];
    cell.priceLabel.text = [NSString stringWithFormat:@"%i%@", offer.quantity, _advert.packaging ? _advert.packaging.title: @""];
    
//    
//    //TODO: need change. Hardcoded for Mike
//    @property (weak, nonatomic) IBOutlet UIView *myRequestView;
//    @property (weak, nonatomic) IBOutlet UILabel *myQuantityLabel;
//    @property (weak, nonatomic) IBOutlet UILabel *myPricelabel;
    
    if (offer.status.ident == 3){
        cell.statusLabel.hidden = YES;
        cell.operationsView.hidden = NO;
    }else{
        cell.statusLabel.hidden = NO;
        cell.operationsView.hidden = YES;
        
        cell.statusLabel.text = [offer.status.title uppercaseString];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [OfferTitleView defaultSize];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    OfferTitleView* offerTitleView =  [OfferTitleView loadFromXib];
    [offerTitleView.advertImageView loadImage:[_advert.images firstObject]];
    offerTitleView.advertTitleLabel.text = _advert.name;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = kCFDateFormatterMediumStyle;
    NSDate* updatedDate = [NSDate dateWithTimeIntervalSinceReferenceDate:_advert.updated];
    offerTitleView.advertDataCreated.text = [NSString stringWithFormat:@"Updated: %@", [dateFormatter stringFromDate:updatedDate]];
    
    offerTitleView.advertPriceLabel.text = [NSString stringWithFormat:@"£%.02f", _advert.guidePrice];
    offerTitleView.advertAvailableLabel.text = [NSString stringWithFormat:@"%i%@", _advert.count, _advert.packaging ? _advert.packaging.title: @""];
    
    return offerTitleView;
}

#pragma mark - OfferActionDelegate

-(void)acceptOffer:(OfferTableViewCell*)owner{
    
    UIAlertController * alertController =   [UIAlertController
                                        alertControllerWithTitle:@""
                                        message:@"Accept offer?"
                                        preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)rejectOffer:(OfferTableViewCell*)owner{
    UIAlertController * alertController=   [UIAlertController
                                        alertControllerWithTitle:@"Reject offer."
                                        message:@"Please add comment."
                                        preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Comment";
        textField.keyboardType = UIKeyboardTypeAlphabet;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Reject" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)counterOffer:(OfferTableViewCell*)owner{
    UIAlertController * alertController=   [UIAlertController
                                        alertControllerWithTitle:@"Counter offer."
                                        message:@"Enter new price and quantity"
                                        preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Price";
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Quantity";
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Comment";
        textField.keyboardType = UIKeyboardTypeAlphabet;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Send" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
