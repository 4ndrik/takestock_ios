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
#import "ServerConnectionHelper.h"
#import "OfferStatus.h"

@implementation OfferManagerViewController
@synthesize advert = _advert;

-(void)viewDidLoad{
    [super viewDidLoad];
    _offers = [_advert.offers allObjects];
    
    _offersTableView.estimatedRowHeight = 124.0;
    _offersTableView.rowHeight = UITableViewAutomaticDimension;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _offers.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OfferTableViewCell* cell = (OfferTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"OfferTableViewCell"];
    
    cell.delegate = self;
    
    Offer* offer = [_offers objectAtIndex:indexPath.row];
    
    cell.autorNameLabel.text = offer.user.userName;
    cell.quantityLabel.text = [NSString stringWithFormat:@"%i%@", offer.quantity, _advert.packaging ? _advert.packaging.title: @""];
    cell.priceLabel.text = [NSString stringWithFormat:@"£%.02f", offer.price];
    
    cell.commentLabel.text = offer.comment;
    cell.myRequestLabel.text = @"";
    cell.myQuantityLabel.text = @"";
    cell.myPricelabel.text = @"";
    cell.counterStatus.text = @"";
    cell.counterComment.text = @"";
    
//    cell.myRequestLabel.text = @"test";
//    cell.myQuantityLabel.text = @"q";
//    cell.myPricelabel.text = @"p";
//    cell.commentLabel.text = @"Comment";
//    cell.counterStatus.text = @"Counter status";
//    cell.counterComment.text = @"counter comment";
    
    switch (offer.status.ident) {
        case stAccept:
            cell.statusLabel.text = @"ACCEPTED, WAITING FOR SHIPPING INFORMATION";
            cell.operationsView.hidden = YES;
            break;
        case stDecline:
            cell.statusLabel.text = [offer.status.title uppercaseString];
            cell.operationsView.hidden = YES;
            break;
        case stPending:
            cell.statusLabel.text = @"";
            cell.operationsView.hidden = NO;
            break;
        case stCountered:
            if (offer.counterOffer){
                cell.myRequestLabel.text = @"Your offer:";
                cell.myQuantityLabel.text = [NSString stringWithFormat:@"%i%@", offer.counterOffer.quantity, _advert.packaging ? _advert.packaging.title: @""];
                cell.myPricelabel.text = [NSString stringWithFormat:@"£%.02f", offer.counterOffer.price];
                switch (offer.counterOffer.status.ident) {
                    case stAccept:
                        cell.counterStatus.text = @"ACCEPTED, WAITING FOR SHIPPING INFORMATION";
                        break;
                    case stDecline:
                        cell.counterStatus.text = offer.counterOffer.status.title;
                        cell.counterComment.text = offer.counterOffer.comment;
                        break;
                    case stPending:
                        cell.counterStatus.text = @"WAITING FOR RESPONCE";
                        break;
                    default:
                        break;
                }

            }
            cell.statusLabel.text = @"";
            cell.operationsView.hidden = YES;
            break;
            
        default:
            break;
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

-(void)updateOffer:(Offer*)offer compleate:(void(^)(NSError* error))compleate{
    [self showLoading];
    [[ServerConnectionHelper sharedInstance] updateOffer:offer compleate:^(NSError *error) {
        [self hideLoading];
        compleate(error);
    }];
}

-(void)showOkAlert:(NSString*)title text:(NSString*)text{
    UIAlertController * alertController =   [UIAlertController
                                             alertControllerWithTitle:title
                                             message:text
                                             preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)acceptOffer:(Offer*)offer{
    offer.status = [OfferStatus getEntityWithId:stAccept];
    [self updateOffer:offer compleate:^(NSError *error) {
        NSString* title = @"";
        NSString* text = @"Offer accepted";
        if (error){
            title = @"Error";
            text = [error localizedDescription];
            offer.status = [OfferStatus getEntityWithId:stPending];
        }
        
        [self showOkAlert:title text:text];
        [_offersTableView reloadData];
    }];
}

-(void)rejectOffer:(Offer*)offer withComment:(NSString*)comment{
    offer.status = [OfferStatus getEntityWithId:stDecline];
    offer.comment = comment;
    [self updateOffer:offer compleate:^(NSError *error) {
        NSString* title = @"";
        NSString* text = @"Offer rejected";
        if (error){
            title = @"Error";
            text = [error localizedDescription];
            offer.status = [OfferStatus getEntityWithId:stPending];
        }
        
        [self showOkAlert:title text:text];
        [_offersTableView reloadData];
    }];
}

-(void)counterOffer:(Offer*)offer withPrice:(NSString*)price withQuantity:(NSString*)quantity withComment:(NSString*)comment{
    float oPrice = [price floatValue];
    int oQuantity = [quantity intValue];
    if (oPrice > 0 && oQuantity > 0){
        offer.status = [OfferStatus getEntityWithId:stCountered];
        offer.comment = comment;
        
        Offer* counterOffer = [Offer storedEntity];
        counterOffer.parentOffer = offer;
        counterOffer.user = [User getMe];
        counterOffer.price = oPrice;
        counterOffer.quantity = oQuantity;
        counterOffer.status = [OfferStatus getEntityWithId:stPending];
        
        [self showLoading];
        [[ServerConnectionHelper sharedInstance] createOffer:counterOffer compleate:^(NSError *error) {
            if (error){
                [self hideLoading];
                [counterOffer.managedObjectContext deleteObject:counterOffer];
                offer.status = [OfferStatus getEntityWithId:stPending];
                offer.comment = @"";
                NSString* title = @"Error";
                NSString* text = [error localizedDescription];
                [self showOkAlert:title text:text];
                [_offersTableView reloadData];
            }else{
                [self updateOffer:offer compleate:^(NSError *error) {
                    NSString* title = @"";
                    NSString* text = @"Offer Countered";
                    if (error){
                        title = @"Error";
                        text = [error localizedDescription];
                        offer.status = [OfferStatus getEntityWithId:stPending];
                    }
                    
                    [self showOkAlert:title text:text];
                    [_offersTableView reloadData];
                }];
            }
        }];
    }
}

-(void)acceptOfferAction:(OfferTableViewCell*)owner{
    
    UIAlertController * alertController =   [UIAlertController
                                        alertControllerWithTitle:@""
                                        message:@"Accept offer?"
                                        preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:NO completion:nil];
        int index = [_offersTableView indexPathForCell:owner].row;
        Offer* offer = [_offers objectAtIndex:index];
        [self acceptOffer:offer];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)rejectOfferAction:(OfferTableViewCell*)owner{
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
        
        int index = [_offersTableView indexPathForCell:owner].row;
        Offer* offer = [_offers objectAtIndex:index];
        [self rejectOffer:offer withComment:alertController.textFields.firstObject.text];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)counterOfferAction:(OfferTableViewCell*)owner{
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
        int index = [_offersTableView indexPathForCell:owner].row;
        Offer* offer = [_offers objectAtIndex:index];
        [self counterOffer:offer withPrice:[alertController.textFields objectAtIndex:0].text withQuantity:[alertController.textFields objectAtIndex:1].text withComment:[alertController.textFields objectAtIndex:2].text];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
