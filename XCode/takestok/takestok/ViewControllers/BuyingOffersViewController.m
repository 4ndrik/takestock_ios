//
//  BuyingOffersViewController.m
//  takestok
//
//  Created by Artem on 9/27/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BuyingOffersViewController.h"
#import "OfferTitleView.h"
#import "TSAdvert.h"
#import "TSOfferStatus.h"
#import "TSOffer.h"
#import "TSUserEntity.h"
#import "UIView+NibLoadView.h"
#import "BackgroundImageView.h"
#import "TopBottomStripesLabel.h"
#import "PaddingLabel.h"
#import "UserServiceManager.h"
#import "PayDestAddressOfferView.h"
#import <Stripe/Stripe.h>
#import "OfferServiceManager.h"
#import "OfferTableViewCell.h"
#import "OfferActionView.h"
#import "PaddingTextField.h"

@interface BuyingOffersViewController ()

@end

@implementation BuyingOffersViewController

-(void)setAdvert:(TSAdvert*)advert andOffer:(TSOffer*)_offer{
    _advert = advert;
    _offers = [NSMutableArray array];
    [_offers addObject:_offer];
    TSOffer* offer = _offer;
    while (offer.childOffers.count > 0) {
        offer = [offer.childOffers lastObject];
        [_offers addObject:offer];
    }
    [_offers  sortUsingComparator:^NSComparisonResult(TSOffer*  _Nonnull obj1, TSOffer*  _Nonnull obj2) {
        return [obj2.dateUpdated compare:obj1.dateUpdated];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_offersTableView registerNib:[UINib nibWithNibName:@"OfferTableViewCell" bundle:nil] forCellReuseIdentifier:@"OfferTableViewCell"];
    _offersTableView.rowHeight = UITableViewAutomaticDimension;
    _offersTableView.estimatedRowHeight = 150;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableAttributedString*)spaceForFont{
    NSMutableAttributedString* spaceString = [[NSMutableAttributedString alloc] initWithString:@"\n \n"];
    [spaceString addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:6]
                        range:NSMakeRange(0, spaceString.length)];
    return spaceString;
}

-(void)configureCell:(OfferTableViewCell*)cell withOffer:(TSOffer*)offer advert:(TSAdvert*)advert{
    NSMutableAttributedString* textString = [[NSMutableAttributedString alloc] init];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = kCFDateFormatterMediumStyle;
    cell.dateCreatedLabel.text = [NSString stringWithFormat:@"Updated: %@", [dateFormatter stringFromDate:offer.dateUpdated]];
    cell.offerTitleLabel.text = offer.isFromSeller ? @"Seller offer" : @"Your offer";
    
    cell.offerCountLabel.text = [NSString stringWithFormat:@"%i%@", offer.quantity, _advert.packaging ? _advert.packaging.title: @""];
    cell.offerPriceLabel.text = [NSString stringWithFormat:@"£%.02f", offer.price];
    
    cell.statusLabel.text = @"";
    cell.mainActionHeight.constant = 0;
    cell.offerActionHeight.constant = 0;
    
    if (offer.comment.length > 0){
        
        NSMutableAttributedString* commentString = [[NSMutableAttributedString alloc] initWithString:offer.comment];
        [commentString addAttribute:NSFontAttributeName
                              value:HelveticaNeue14
                              range:NSMakeRange(0, commentString.length)];
        [commentString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, commentString.length)];
        [textString appendAttributedString:commentString];
    }
    
    if ([offer.status.ident intValue] == tsAccept){
        if (textString.length > 0)
            [textString appendAttributedString:[self spaceForFont]];
        
        NSMutableAttributedString* statusString = [[NSMutableAttributedString alloc] initWithString:@"WAITING FOR PAYMENT"];
        [statusString addAttribute:NSFontAttributeName
                             value:BrandonGrotesqueBold14
                             range:NSMakeRange(0, statusString.length)];
        [statusString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, statusString.length)];
        [textString appendAttributedString:statusString];
        
        cell.mainActionHeight.constant = 35;
        [cell.mainActionButton setTitle:@"MAKE PAYMENT" forState:UIControlStateNormal];
    }
    else if ([offer.status.ident intValue] == tsDecline){
        
        if (textString.length > 0)
            [textString appendAttributedString:[self spaceForFont]];
        
        NSMutableAttributedString* statusString = [[NSMutableAttributedString alloc] initWithString:@"REJECTED"];
        [statusString addAttribute:NSFontAttributeName
                              value:BrandonGrotesqueBold14
                              range:NSMakeRange(0, statusString.length)];
        [statusString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, statusString.length)];
        [textString appendAttributedString:statusString];
    } else if ([offer.status.ident intValue] == tsPending){
        if (textString.length > 0)
            [textString appendAttributedString:[self spaceForFont]];

        if (offer.isFromSeller){
            cell.offerActionHeight.constant = 30.;
        }else {
            NSMutableAttributedString* statusString = [[NSMutableAttributedString alloc] initWithString:@"WAITING RESPONSE"];
            [statusString addAttribute:NSFontAttributeName
                                  value:BrandonGrotesqueBold14
                                  range:NSMakeRange(0, statusString.length)];
            [statusString addAttribute:NSForegroundColorAttributeName value:OliveMainColor range:NSMakeRange(0, statusString.length)];
            [textString appendAttributedString:statusString];
        }
    }else if ([offer.status.ident intValue] == tsCountered){
        if (textString.length > 0)
            [textString appendAttributedString:[self spaceForFont]];
        
        NSMutableAttributedString* statusString = [[NSMutableAttributedString alloc] initWithString:@"COUNTERED"];
        [statusString addAttribute:NSFontAttributeName
                             value:BrandonGrotesqueBold14
                             range:NSMakeRange(0, statusString.length)];
        [statusString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, statusString.length)];
        [textString appendAttributedString:statusString];
    }else if ([offer.status.ident intValue] == tsCounteredByByer){
        if (textString.length > 0)
            [textString appendAttributedString:[self spaceForFont]];
        
        NSMutableAttributedString* statusString = [[NSMutableAttributedString alloc] initWithString:@"COUNTERED BY BYER"];
        [statusString addAttribute:NSFontAttributeName
                             value:BrandonGrotesqueBold14
                             range:NSMakeRange(0, statusString.length)];
        [statusString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, statusString.length)];
        [textString appendAttributedString:statusString];
    }
    
//
//    
//    
//    
//    
//    else if ([offer.status.ident intValue] == tsCounteredByByer){
//        if (textString.length > 0)
//            [textString appendAttributedString:[self spaceForFont]];
//        
//        if ([offer.statusForBuyer.ident intValue] == tsPending){
//            NSMutableAttributedString* statusString = [[NSMutableAttributedString alloc] initWithString:@"WAITING RESPONSE"];
//            [statusString addAttribute:NSFontAttributeName
//                                 value:BrandonGrotesqueBold14
//                                 range:NSMakeRange(0, statusString.length)];
//            [statusString addAttribute:NSForegroundColorAttributeName value:OliveMainColor range:NSMakeRange(0, statusString.length)];
//            [textString appendAttributedString:statusString];
//        }else{
//            
//        }
//    }
//    
//    
//    
    
    
    
//    else if ([offer.statusForBuyer.ident intValue] == tsPending || [offer.status.ident intValue] == tsCounteredByByer){
//        
//        if (textString.length > 0)
//            [textString appendAttributedString:[self spaceForFont]];
//        
//        NSMutableAttributedString* statusString = [[NSMutableAttributedString alloc] initWithString:@"WAITING RESPONSE"];
//        [statusString addAttribute:NSFontAttributeName
//                              value:BrandonGrotesqueBold14
//                              range:NSMakeRange(0, statusString.length)];
//        [statusString addAttribute:NSForegroundColorAttributeName value:OliveMainColor range:NSMakeRange(0, statusString.length)];
//        [textString appendAttributedString:statusString];
//        
//    } else if ([offer.statusForBuyer.ident intValue] == tsCountered && [offer.status.ident intValue] == tsPending){
//        cell.offerActionHeight.constant = 30.;
//    }else if ([offer.statusForBuyer.ident intValue] == tsCountered && [offer.status.ident intValue] == tsCountered){
//        
//        if (textString.length > 0)
//            [textString appendAttributedString:[self spaceForFont]];
//        
//        NSMutableAttributedString* statusString = [[NSMutableAttributedString alloc] initWithString:@"COUNTERED"];
//        [statusString addAttribute:NSFontAttributeName
//                              value:BrandonGrotesqueBold14
//                              range:NSMakeRange(0, statusString.length)];
//        [statusString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, statusString.length)];
//        [textString appendAttributedString:statusString];
//    }
    

    [cell.statusLabel setAttributedText:textString];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _offers.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TSOffer* offer = [_offers objectAtIndex:indexPath.row];
    
    OfferTableViewCell* cell = (OfferTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"OfferTableViewCell"];
    cell.delegate = self;

    [self configureCell:cell withOffer:offer advert:_advert];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [OfferTitleView defaultSize];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    OfferTitleView* offerTitleView =  [OfferTitleView loadFromXib];
    [offerTitleView.advertImageView loadImage:[_advert.photos firstObject]];
    offerTitleView.advertTitleLabel.text = _advert.name;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = kCFDateFormatterMediumStyle;
    offerTitleView.advertDataCreated.text = [NSString stringWithFormat:@"Updated: %@", [dateFormatter stringFromDate:_advert.dateUpdated]];
    
    offerTitleView.advertPriceLabel.text = [NSString stringWithFormat:@"£%.02f", _advert.guidePrice];
    offerTitleView.advertAvailableLabel.text = [NSString stringWithFormat:@"%i%@", _advert.count, _advert.packaging ? _advert.packaging.title: @""];
    
    return offerTitleView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



//
//#pragma mark - Helpers
//
//-(NSMutableAttributedString*)spaceForFont{
//    NSMutableAttributedString* spaceString = [[NSMutableAttributedString alloc] initWithString:@"\n \n"];
//    [spaceString addAttribute:NSFontAttributeName
//                        value:[UIFont systemFontOfSize:6]
//                        range:NSMakeRange(0, spaceString.length)];
//    return spaceString;
//}
//
//-(NSMutableAttributedString*)fillOfferInformation:(TSOffer*)offer advert:(TSAdvert*)advert cell:(BuyingTableViewCell*)cell{
//    NSMutableAttributedString* textString = [[NSMutableAttributedString alloc] init];
//    if ([offer.status.ident intValue] == tsAccept){
//        
//        if (textString.length > 0)
//            [textString appendAttributedString:[self spaceForFont]];
//        
//        NSMutableAttributedString* acceptString = [[NSMutableAttributedString alloc] initWithString:@"WAITING FOR PAYMENT"];
//        [acceptString addAttribute:NSFontAttributeName
//                             value:BrandonGrotesqueBold14
//                             range:NSMakeRange(0, acceptString.length)];
//        [acceptString addAttribute:NSForegroundColorAttributeName value:OliveMainColor range:NSMakeRange(0, acceptString.length)];
//        [textString appendAttributedString:acceptString];
//    }else if ([offer.status.ident intValue] == tsDecline){
//        
//        if (textString.length > 0)
//            [textString appendAttributedString:[self spaceForFont]];
//        
//        NSMutableAttributedString* declineString = [[NSMutableAttributedString alloc] initWithString:@"REJECTED"];
//        [declineString addAttribute:NSFontAttributeName
//                              value:BrandonGrotesqueBold14
//                              range:NSMakeRange(0, declineString.length)];
//        [declineString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, declineString.length)];
//        [textString appendAttributedString:declineString];
//        
//        if (offer.comment.length > 0){
//            [textString appendAttributedString:[self spaceForFont]];
//            
//            NSMutableAttributedString* commentString = [[NSMutableAttributedString alloc] initWithString:offer.comment];
//            [commentString addAttribute:NSFontAttributeName
//                                  value:HelveticaNeue14
//                                  range:NSMakeRange(0, commentString.length)];
//            [commentString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, commentString.length)];
//            [textString appendAttributedString:commentString];
//        }
//        
//    }
//    //    else if ([offer.status.ident intValue] == tsPending){
//    //
//    //        if (offer.parentOffer){
//    //            cell.additionalActionHeight.constant = 30.;
//    //        }else{
//    //            NSMutableAttributedString* pendingString = [[NSMutableAttributedString alloc] initWithString:@"WAITING RESPONSE"];
//    //            [pendingString addAttribute:NSFontAttributeName
//    //                                  value:BrandonGrotesqueBold14
//    //                                  range:NSMakeRange(0, pendingString.length)];
//    //            [pendingString addAttribute:NSForegroundColorAttributeName value:OliveMainColor range:NSMakeRange(0, pendingString.length)];
//    //            [textString appendAttributedString:pendingString];
//    //        }
//    //    }
//    //    else if (offer.status.ident == stCountered ){
//    //
//    //        cell.counterTextLabel.text = @"Counteroffer:";
//    //        cell.counterCountLabel.text = [NSString stringWithFormat:@"%i%@", offer.counterOffer.quantity, advert.packaging ? advert.packaging.title: @""];
//    //        cell.counterPriceLabel.text = [NSString stringWithFormat:@"£%.02f", offer.counterOffer.price];
//    //
//    //
//    //        if (offer.comment.length > 0){
//    //            if (textString.length > 0)
//    //                [textString appendAttributedString:[self spaceForFont]];
//    //
//    //            NSMutableAttributedString* commentString = [[NSMutableAttributedString alloc] initWithString:offer.comment];
//    //            [commentString addAttribute:NSFontAttributeName
//    //                                  value:HelveticaNeue14
//    //                                  range:NSMakeRange(0, commentString.length)];
//    //            [commentString addAttribute:NSForegroundColorAttributeName value:OberginMainColor range:NSMakeRange(0, commentString.length)];
//    //            [textString appendAttributedString:commentString];
//    //        }
//    //
//    //        NSMutableAttributedString* additionalTextString = [self fillOfferInformation:offer.counterOffer advert:advert cell:cell];
//    //        if (additionalTextString.length > 0){
//    //            if (textString.length > 0)
//    //                [textString appendAttributedString:[self spaceForFont]];
//    //            [textString appendAttributedString:additionalTextString];
//    //        }
//    //    }else if (offer.status.ident == stPayment){
//    //
//    //        NSMutableAttributedString* deliveryString = [[NSMutableAttributedString alloc] initWithString:@"DELIVERY ADDRESS:\n"];
//    //        [deliveryString addAttribute:NSFontAttributeName
//    //                               value:BrandonGrotesqueBold13
//    //                               range:NSMakeRange(0, deliveryString.length)];
//    //        [deliveryString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, deliveryString.length)];
//    //        [textString appendAttributedString:deliveryString];
//    //
//    //        NSMutableAttributedString* deliveryAddressString = [[NSMutableAttributedString alloc] initWithString:@"Delivery address\nSome address"];
//    //        [deliveryAddressString addAttribute:NSFontAttributeName
//    //                                      value:HelveticaNeue14
//    //                                      range:NSMakeRange(0, deliveryAddressString.length)];
//    //        [deliveryAddressString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, deliveryString.length)];
//    //        [textString appendAttributedString:deliveryAddressString];
//    //        [textString appendAttributedString:[self spaceForFont]];
//    //
//    //        NSMutableAttributedString* pendingString = [[NSMutableAttributedString alloc] initWithString:@"AWAITING DELIVERY INFO"];
//    //        [pendingString addAttribute:NSFontAttributeName
//    //                              value:BrandonGrotesqueBold14
//    //                              range:NSMakeRange(0, pendingString.length)];
//    //        [pendingString addAttribute:NSForegroundColorAttributeName value:OliveMainColor range:NSMakeRange(0, pendingString.length)];
//    //        [textString appendAttributedString:pendingString];
//    //    }
//    
//    return textString;
//    
//}


-(void)acceptOffer:(TSOffer*)offer{
    [self showLoading];
    [[OfferServiceManager sharedManager] acceptOffer:offer compleate:^(NSError *error) {
        [self hideLoading];
        NSString* title = @"";
        NSString* text = @"Offer is accepted";
        if (error){
            title = @"Error";
            text = ERROR_MESSAGE(error);
        }
        
        [self showOkAlert:title text:text];
        [_offersTableView reloadData];
        
    }];
}

-(void)rejectOffer:(id)owner{
    NSInteger index = [_offers indexOfObjectPassingTest:^BOOL(TSOffer*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj.ident intValue] == _offerAlertView.tag;
    }];
    if (index != NSNotFound){
        TSOffer* offer = [_offers objectAtIndex:index];
        NSString* comment = _offerAlertView.commentTextView.text;
        [_offerAlertView removeFromSuperview];
        [self showLoading];
        [[OfferServiceManager sharedManager] rejectOffer:offer withComment:comment compleate:^(NSError *error) {
            [self hideLoading];
            NSString* title = @"";
            NSString* text = @"Offer is rejected";
            if (error){
                title = @"Error";
                text = ERROR_MESSAGE(error);
            }
            
            [self showOkAlert:title text:text];
            [_offersTableView reloadData];
            
        }];
    }
}

-(void)counterOffer:(id)owner{
    float oPrice = [_offerAlertView.priceTextEdit.text floatValue];
    int oQuantity = [_offerAlertView.qtyTextEdit.text intValue];
    
    NSInteger index = [_offers indexOfObjectPassingTest:^BOOL(TSOffer*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj.ident intValue] == _offerAlertView.tag;
    }];
    
    if (index != NSNotFound && oPrice > 0 && oQuantity > 0){
        TSOffer* offer = [_offers objectAtIndex:index];
        
        [_offerAlertView removeFromSuperview];
        [self showLoading];
        
        
        [[OfferServiceManager sharedManager] createCounterOffer:offer withCount:oQuantity price:oPrice withComment:_offerAlertView.commentTextView.text byByer:YES compleate:^(NSError *error) {
            [self hideLoading];
            NSString* title = @"";
            NSString* text = @"Offer is countered.";
            if (error){
                title = @"Error";
                text = ERROR_MESSAGE(error);
            }else{
                [_offers insertObject:offer.childOffers.lastObject atIndex:0];
            }
            
            [self showOkAlert:title text:text];
            [_offersTableView reloadData];
        }];
    }
}

-(void)hideAlertView:(id)owner{
    [_offerAlertView removeFromSuperview];
    _offerAlertView = nil;
    
    [_payView removeFromSuperview];
    _payView = nil;
}

-(BOOL)validatePayment{
    NSMutableString* message = [[NSMutableString alloc] init];
//    if (_payView.destinationAddress.text.length == 0)
//        [message appendString:@"Fill destination address.\n"];
    
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
                 NSUInteger index = [_offers indexOfObjectPassingTest:^BOOL(TSOffer*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     return [obj.ident intValue] == (int)_payView.tag;
                 }];
                 TSOffer* offer = [_offers objectAtIndex:index];
                 [[OfferServiceManager sharedManager] makePayment:offer token:token compleate:^(NSError *error) {
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

-(void)showPaymentAlert:(TSOffer*)offer{
    _payView = [PayDestAddressOfferView loadFromXib];
    _payView.frame = self.navigationController.view.bounds;
    _payView.tag = [offer.ident intValue];
    [_payView.payButton setTitle:[NSString stringWithFormat:@"PAY £%.02f", offer.price * offer.quantity] forState:UIControlStateNormal];
    
    [_payView.payButton addTarget:self action:@selector(makePayment:) forControlEvents:UIControlEventTouchUpInside];
    [_payView.cancelButton addTarget:self action:@selector(hideAlertView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationController.view addSubview:_payView];
    
    [_payView.cardControl becomeFirstResponder];
}


#pragma mark - OfferActionDelegate

-(void)mainAction:(UITableViewCell*)owner{
    NSUInteger index = [_offersTableView indexPathForCell:owner].row;
    TSOffer* offer = [_offers objectAtIndex:index];
//    if (offer.counterOffer)
//        offer = offer.counterOffer;
    
    //Waiting for payment
    if ([offer.status.ident intValue] == tsAccept ){
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
        NSInteger index = [_offersTableView indexPathForCell:owner].row;
        TSOffer* offer = [_offers objectAtIndex:index];
        [self acceptOffer:offer];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)rejectOfferAction:(OfferTableViewCell*)owner{
    _offerAlertView =  [OfferActionView loadFromXib];
    _offerAlertView.frame = self.navigationController.view.bounds;
    
    _offerAlertView.titleLabel.text = @"Reject offer.";
    _offerAlertView.priceQtyHeightConstraints.constant = 0;
    NSInteger index = [_offersTableView indexPathForCell:owner].row;
    TSOffer* offer = [_offers objectAtIndex:index];
    _offerAlertView.tag = [offer.ident intValue];
    [_offerAlertView.cancelButton addTarget:self action:@selector(hideAlertView:) forControlEvents:UIControlEventTouchUpInside];
    [_offerAlertView.sendButton addTarget:self action:@selector(rejectOffer:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationController.view addSubview:_offerAlertView];
    
    [_offerAlertView.commentTextView becomeFirstResponder];
}

-(void)counterOfferAction:(OfferTableViewCell*)owner{
    _offerAlertView =  [OfferActionView loadFromXib];
    _offerAlertView.frame = self.navigationController.view.bounds;
    
    _offerAlertView.titleLabel.text = @"Counter offer.";
    NSUInteger index = [_offersTableView indexPathForCell:owner].row;
    TSOffer* offer = [_offers objectAtIndex:index];
    _offerAlertView.tag = [offer.ident intValue];
    [_offerAlertView.cancelButton addTarget:self action:@selector(hideAlertView:) forControlEvents:UIControlEventTouchUpInside];
    [_offerAlertView.sendButton addTarget:self action:@selector(counterOffer:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationController.view addSubview:_offerAlertView];
    
    _offerAlertView.priceTypeLabel.text = @"£";
    _offerAlertView.qtytypeLabel.text = _advert.packaging ? _advert.packaging.title: @"";
    
    [_offerAlertView.priceTextEdit becomeFirstResponder];
}


@end
