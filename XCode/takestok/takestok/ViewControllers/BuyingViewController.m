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
#import "ServerConnectionHelper.h"
#import "OfferActionView.h"
#import "UIView+NibLoadView.h"
#import "AdvertDetailViewController.h"
#import <Stripe/Stripe.h>
#import "PayDestAddressOfferView.h"

@implementation BuyingViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:OFFERS_UPDATED_NOTIFICATION object:nil];
    
    _buyingTableView.estimatedRowHeight = 116.0;
    _buyingTableView.rowHeight = UITableViewAutomaticDimension;
    
    self.title = @"BUYING";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshData:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:OFFERS_UPDATED_NOTIFICATION object:nil];
}

-(void)refreshData:(id)owner{
    _offers = [Offer getMyOffers];
    [_buyingTableView reloadData];
    if (_offers.count == 0){
        [self showNoItems];
    }else{
        [self hideNoItems];
    }
}

#pragma mark - Helpers

-(NSMutableAttributedString*)spaceForFont{
    NSMutableAttributedString* spaceString = [[NSMutableAttributedString alloc] initWithString:@"\n \n"];
    [spaceString addAttribute:NSFontAttributeName
                         value:[UIFont systemFontOfSize:6]
                         range:NSMakeRange(0, spaceString.length)];
    return spaceString;
}

-(NSMutableAttributedString*)fillOfferInformation:(Offer*)offer advert:(Advert*)advert cell:(BuyingTableViewCell*)cell{
    NSMutableAttributedString* textString = [[NSMutableAttributedString alloc] init];
    if (offer.status.ident == stAccept){
        
        if (textString.length > 0)
            [textString appendAttributedString:[self spaceForFont]];
        
        NSMutableAttributedString* acceptString = [[NSMutableAttributedString alloc] initWithString:@"ACCEPTED"];
        [acceptString addAttribute:NSFontAttributeName
                             value:BrandonGrotesqueBold14
                             range:NSMakeRange(0, acceptString.length)];
        [acceptString addAttribute:NSForegroundColorAttributeName value:OliveMainColor range:NSMakeRange(0, acceptString.length)];
        [textString appendAttributedString:acceptString];
        
        cell.acceptHeight.constant = 30.;
        [cell.acceptButton setTitle:@"ADD PAYMENT" forState:UIControlStateNormal];
    }else if (offer.status.ident == stDecline){
        
        if (textString.length > 0)
            [textString appendAttributedString:[self spaceForFont]];
        
        NSMutableAttributedString* declineString = [[NSMutableAttributedString alloc] initWithString:@"REJECTED"];
        [declineString addAttribute:NSFontAttributeName
                              value:BrandonGrotesqueBold14
                              range:NSMakeRange(0, declineString.length)];
        [declineString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, declineString.length)];
        [textString appendAttributedString:declineString];
        
        if (offer.comment.length > 0){
            [textString appendAttributedString:[self spaceForFont]];
            
            NSMutableAttributedString* commentString = [[NSMutableAttributedString alloc] initWithString:offer.comment];
            [commentString addAttribute:NSFontAttributeName
                                  value:HelveticaNeue14
                                  range:NSMakeRange(0, commentString.length)];
            [commentString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, commentString.length)];
            [textString appendAttributedString:commentString];
        }
        
    }else if (offer.status.ident == stPending){
        
        if (offer.parentOffer){
            cell.additionalActionHeight.constant = 30.;
        }else{
            NSMutableAttributedString* pendingString = [[NSMutableAttributedString alloc] initWithString:@"WAITING RESPONSE"];
            [pendingString addAttribute:NSFontAttributeName
                                  value:BrandonGrotesqueBold14
                                  range:NSMakeRange(0, pendingString.length)];
            [pendingString addAttribute:NSForegroundColorAttributeName value:OliveMainColor range:NSMakeRange(0, pendingString.length)];
            [textString appendAttributedString:pendingString];
        }
    }
    else if (offer.status.ident == stCountered ){
        
        cell.counterTextLabel.text = @"Counteroffer:";
        cell.counterCountLabel.text = [NSString stringWithFormat:@"%i%@", offer.counterOffer.quantity, advert.packaging ? advert.packaging.title: @""];
        cell.counterPriceLabel.text = [NSString stringWithFormat:@"£%.02f", offer.counterOffer.price];
        
        
        if (offer.comment.length > 0){
            if (textString.length > 0)
                [textString appendAttributedString:[self spaceForFont]];
            
            NSMutableAttributedString* commentString = [[NSMutableAttributedString alloc] initWithString:offer.comment];
            [commentString addAttribute:NSFontAttributeName
                                  value:HelveticaNeue14
                                  range:NSMakeRange(0, commentString.length)];
            [commentString addAttribute:NSForegroundColorAttributeName value:OberginMainColor range:NSMakeRange(0, commentString.length)];
            [textString appendAttributedString:commentString];
        }
        
        NSMutableAttributedString* additionalTextString = [self fillOfferInformation:offer.counterOffer advert:advert cell:cell];
        if (additionalTextString.length > 0){
            if (textString.length > 0)
                [textString appendAttributedString:[self spaceForFont]];
            [textString appendAttributedString:additionalTextString];
        }
    }else if (offer.status.ident == stPayment){
        
        NSMutableAttributedString* deliveryString = [[NSMutableAttributedString alloc] initWithString:@"DELIVERY ADDRESS:\n"];
        [deliveryString addAttribute:NSFontAttributeName
                               value:BrandonGrotesqueBold13
                               range:NSMakeRange(0, deliveryString.length)];
        [deliveryString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, deliveryString.length)];
        [textString appendAttributedString:deliveryString];
        
        NSMutableAttributedString* deliveryAddressString = [[NSMutableAttributedString alloc] initWithString:@"Delivery address\nSome address"];
        [deliveryAddressString addAttribute:NSFontAttributeName
                                      value:HelveticaNeue14
                                      range:NSMakeRange(0, deliveryAddressString.length)];
        [deliveryAddressString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, deliveryString.length)];
        [textString appendAttributedString:deliveryAddressString];
        [textString appendAttributedString:[self spaceForFont]];
        
        NSMutableAttributedString* pendingString = [[NSMutableAttributedString alloc] initWithString:@"AWAITING DELIVERY INFO"];
        [pendingString addAttribute:NSFontAttributeName
                              value:BrandonGrotesqueBold14
                              range:NSMakeRange(0, pendingString.length)];
        [pendingString addAttribute:NSForegroundColorAttributeName value:OliveMainColor range:NSMakeRange(0, pendingString.length)];
        [textString appendAttributedString:pendingString];
    }
    
    return textString;

}

-(void)updateOffer:(Offer*)offer compleate:(void(^)(NSError* error))compleate{
//    [self showLoading];
//    [[ServerConnectionHelper sharedInstance] updateOffer:offer compleate:^(NSError *error) {
//        [self hideLoading];
//        compleate(error);
//    }];
}

-(void)acceptOffer:(Offer*)offer{
//    offer = offer.counterOffer;
//    offer.status = [OfferStatus getEntityWithId:stAccept];
//    [self updateOffer:offer compleate:^(NSError *error) {
//        NSString* title = @"";
//        NSString* text = @"Offer accepted";
//        if (error){
//            title = @"Error";
//            text = ERROR_MESSAGE(error);
//            offer.status = [OfferStatus getEntityWithId:stPending];
//        }
//        
//        [self showOkAlert:title text:text];
//        [_buyingTableView reloadData];
//    }];
}

-(void)rejectOffer:(id)owner{
//    NSInteger index = [_offers indexOfObjectPassingTest:^BOOL(Offer*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        return obj.ident == _offerAlertView.tag;
//    }];
//    if (index != NSNotFound){
//        Offer* offer = ((Offer*)[_offers objectAtIndex:index]).counterOffer;
//        offer.status = [OfferStatus getEntityWithId:stDecline];
//        offer.comment = _offerAlertView.commentTextView.text;
//        [_offerAlertView removeFromSuperview];
//        [self updateOffer:offer compleate:^(NSError *error) {
//            NSString* title = @"";
//            NSString* text = @"Offer rejected";
//            if (error){
//                title = @"Error";
//                text = ERROR_MESSAGE(error);
//                offer.status = [OfferStatus getEntityWithId:stPending];
//            }
//            
//            [self showOkAlert:title text:text];
//            [_buyingTableView reloadData];
//        }];
//    }
}

-(void)hideAlertView:(id)owner{
    [_offerAlertView removeFromSuperview];
    _offerAlertView = nil;
    
    [_payView removeFromSuperview];
    _payView = nil;
}

-(BOOL)validatePayment{
    NSMutableString* message = [[NSMutableString alloc] init];
    if (_payView.destinationAddress.text.length == 0)
        [message appendString:@"Fill destination address.\n"];
    
    if (![_payView.cardControl isValid]){
        [message appendString:@"Card data invalid."];
        
    }
    
    if (message.length > 0){
        [self showOkAlert:@"" text:message];
        return NO;
        
    }else{
        return YES;
    }
}

-(void)makePayment:(id)owner{
    if ([self validatePayment]){
        [self showLoading];
        [[STPAPIClient sharedClient]
         createTokenWithCard:_payView.cardControl.cardParams
         completion:^(STPToken *token, NSError *error) {
             if (error) {
                 [self hideLoading];
                 [self showOkAlert:@"" text:[error localizedDescription]];
             } else {
                 Offer* offer = [Offer getEntityWithId:(int)_payView.tag];
                 [[ServerConnectionHelper sharedInstance] payOffer:offer withToken:token completion:^(NSError *error) {
                     [self hideLoading];
                     NSString* title = @"";
                     NSString* message = @"Payment made successfully.";
                     if (error){
                         title = @"Error";
                         message = ERROR_MESSAGE(error);
                     }
                     else{
                         [self hideAlertView:nil];
                     }
                     [self showOkAlert:title text:message];
                 }];
             }
         }];
    }
}

-(void)showPaymentAlert:(Offer*)offer{
    _payView = [PayDestAddressOfferView loadFromXib];
    _payView.frame = self.navigationController.view.bounds;
    _payView.tag = offer.ident;
    [_payView.payButton setTitle:[NSString stringWithFormat:@"PAY £%.02f", offer.price * offer.quantity] forState:UIControlStateNormal];
    
    [_payView.payButton addTarget:self action:@selector(makePayment:) forControlEvents:UIControlEventTouchUpInside];
    [_payView.cancelButton addTarget:self action:@selector(hideAlertView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationController.view addSubview:_payView];
    
    [_payView.cardControl becomeFirstResponder];
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
    cell.locationLabel.text = advert.location;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = kCFDateFormatterMediumStyle;
    NSDate* updatedDate = [NSDate dateWithTimeIntervalSinceReferenceDate:offer.date_updated];
    cell.createdLabel.text = [NSString stringWithFormat:@"Updated: %@", [dateFormatter stringFromDate:updatedDate]];
    
    cell.offerPriceLabel.text = [NSString stringWithFormat:@"£%.02f", offer.price];
    cell.offerCountLabel.text = [NSString stringWithFormat:@"%i%@", offer.quantity, advert.packaging ? advert.packaging.title: @""];
    
    cell.counterTextLabel.text = @"";
    cell.counterCountLabel.text = @"";
    cell.counterPriceLabel.text = @"";
    
    cell.additionalActionHeight.constant = 0;
    cell.acceptHeight.constant = 0;
    
    NSMutableAttributedString* textString = [self fillOfferInformation:offer advert:advert cell:cell];
    
    [cell.offerTextLabel setAttributedText:textString];
    
    cell.delegate = self;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Offer* offer = [_offers objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self performSegueWithIdentifier:ADVERT_DETAIL_SEGUE sender:offer.advert];
}

#pragma mark - OfferActionDelegate

-(void)mainAction:(UITableViewCell*)owner{
    NSUInteger index = [_buyingTableView indexPathForCell:owner].row;
    Offer* offer = [_offers objectAtIndex:index];
    if (offer.counterOffer)
        offer = offer.counterOffer;
    if (offer.status.ident == stAccept ){
        [self showPaymentAlert:offer];
    }
}

-(void)acceptOfferAction:(UITableViewCell*)owner{
    UIAlertController * alertController =   [UIAlertController
                                             alertControllerWithTitle:@""
                                             message:@"Accept offer?"
                                             preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:NO completion:nil];
        NSUInteger index = [_buyingTableView indexPathForCell:owner].row;
        Offer* offer = [_offers objectAtIndex:index];
        [self acceptOffer:offer];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

-(void)rejectOfferAction:(UITableViewCell*)owner{
    _offerAlertView =  [OfferActionView loadFromXib];
    _offerAlertView.frame = self.navigationController.view.bounds;
    
    _offerAlertView.titleLabel.text = @"Reject offer.";
    _offerAlertView.priceQtyHeightConstraints.constant = 0;
    NSUInteger index = [_buyingTableView indexPathForCell:owner].row;
    Offer* offer = [_offers objectAtIndex:index];
    _offerAlertView.tag = offer.ident;
    [_offerAlertView.cancelButton addTarget:self action:@selector(hideAlertView:) forControlEvents:UIControlEventTouchUpInside];
    [_offerAlertView.sendButton addTarget:self action:@selector(rejectOffer:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationController.view addSubview:_offerAlertView];
    
    [_offerAlertView.commentTextView becomeFirstResponder];
}

@end
