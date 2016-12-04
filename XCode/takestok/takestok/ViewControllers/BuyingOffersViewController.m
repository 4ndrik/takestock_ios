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
#import "TSShippingInfo.h"
#import "TSUserEntity.h"
#import "UIView+NibLoadView.h"
#import "BackgroundImageView.h"
#import "TopBottomStripesLabel.h"
#import "PaddingLabel.h"
#import "UserServiceManager.h"
#import <Stripe/Stripe.h>
#import "OfferServiceManager.h"
#import "OfferTableViewCell.h"
#import "OfferActionView.h"
#import "PaddingTextField.h"
#import "PayBacsViewController.h"
#import "PayCardViewController.h"

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_offersTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:PAY_BY_BACS_SEGUE]) {
        PayBacsViewController* vc = (PayBacsViewController*)segue.destinationViewController;
        [vc setOffer:sender withAdvert:_advert alreadyPayed:[((TSOffer*)sender).status.ident intValue] != tsAccept];
    }if ([segue.identifier isEqualToString:PAY_BY_CARD_SEGUE]) {
        PayCardViewController* vc = (PayCardViewController*)segue.destinationViewController;
        [vc setOffer:sender withAdvert:_advert];
    }else{
        [super prepareForSegue:segue sender:sender];
    }
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
    cell.transportActionHeight.constant = 0;
    cell.contactUsActionHeight.constant = 0;
    cell.contactUserActionHeight.constant = 0;
    cell.payActionHeight.constant = 0;
    cell.bottomTextHeight.constant = 0;
    [cell.contactUserButton setTitle:@"CONTACT SELLER" forState:UIControlStateNormal];
    
    cell.stateLabel.text = [offer.status.title uppercaseString];
    cell.stateLabel.textColor = [UIColor redColor];
    
    if (offer.comment.length > 0){
        
        NSMutableAttributedString* commentString = [[NSMutableAttributedString alloc] initWithString:offer.comment];
        [commentString addAttribute:NSFontAttributeName
                              value:HelveticaNeue14
                              range:NSMakeRange(0, commentString.length)];
        [commentString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, commentString.length)];
        [textString appendAttributedString:commentString];
    }
    
    if ([offer.status.ident intValue] == tsAccept){
        cell.payActionHeight.constant = 40;
    } else if ([offer.status.ident intValue] == tsPending){
        if (offer.isFromSeller){
            cell.offerActionHeight.constant = 40;
        }
    }else if ([offer.status.ident intValue] == tsPayment){
        cell.bottomTextHeight.constant = 30;
        cell.mainActionHeight.constant = 40;
        [cell.mainActionButton setTitle:@"ADD SHIPPING ADDRESS" forState:UIControlStateNormal];
        
        cell.bottomLabel.text = @"Please advice where the goods are to be send to.";
    }else if ([offer.status.ident intValue] == tsAddressReceived){
        cell.contactUserActionHeight.constant = 40;
        
        NSString* streetString = [NSString stringWithFormat:@"House: %@\nStreet: %@\nCity: %@\nPostcode: %@\nPhone: %@", offer.shippingInfo.house, offer.shippingInfo.street, offer.shippingInfo.city,offer.shippingInfo.postcode, offer.shippingInfo.phone];
        NSMutableAttributedString* shippingInfo = [[NSMutableAttributedString alloc] initWithString:streetString];
        [shippingInfo addAttribute:NSFontAttributeName
                             value:HelveticaNeue14
                             range:NSMakeRange(0, shippingInfo.length)];
        [shippingInfo addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, shippingInfo.length)];
        
        [textString appendAttributedString:shippingInfo];
        
    }else if ([offer.status.ident intValue] == tsConfirmStock){
        cell.contactUserActionHeight.constant = 40;
    }else if ([offer.status.ident intValue] == tsStockInTransit){
        cell.contactUserActionHeight.constant = 40;
        cell.mainActionHeight.constant = 40;
        [cell.mainActionButton setTitle:@"CONFIRM GOODS RECEIVED" forState:UIControlStateNormal];
        
        NSString* streetString = [NSString stringWithFormat:@"Arrival date: %@\nPick up date: %@\nTracking number: %@\nCourier name: %@", [dateFormatter stringFromDate:offer.shippingInfo.arrivalDate], [dateFormatter stringFromDate:offer.shippingInfo.pickUpDate], offer.shippingInfo.trackingNumber, offer.shippingInfo.courierName];
        NSMutableAttributedString* shippingInfo = [[NSMutableAttributedString alloc] initWithString:streetString];
        [shippingInfo addAttribute:NSFontAttributeName
                             value:HelveticaNeue14
                             range:NSMakeRange(0, shippingInfo.length)];
        [shippingInfo addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, shippingInfo.length)];
        
        [textString appendAttributedString:shippingInfo];
        
    }else if ([offer.status.ident intValue] == tsGoodsReceived){
        cell.contactUserActionHeight.constant = 40;
        cell.contactUsActionHeight.constant = 40;
        cell.mainActionHeight.constant  = 40;
        [cell.mainActionButton setTitle:@"RAICE DIPUITE" forState:UIControlStateNormal];
    }else if ([offer.status.ident intValue] == tsInDispute){
        cell.contactUserActionHeight.constant = 40;
        cell.contactUsActionHeight.constant = 40;
        
        NSMutableAttributedString* commentString = [[NSMutableAttributedString alloc] initWithString:@"Dispute raised on the sale of 'product name'. Our team will contact you shortly about this. "];
        [commentString addAttribute:NSFontAttributeName
                              value:HelveticaNeue14
                              range:NSMakeRange(0, commentString.length)];
        [commentString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, commentString.length)];
        [textString appendAttributedString:commentString];
    }else if ([offer.status.ident intValue] == tsPayByBacs){
        cell.mainActionHeight.constant  = 40;
        [cell.mainActionButton setTitle:@"SHOW BACS INFORMATION" forState:UIControlStateNormal];
    }
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
    offerTitleView.soldOutImage.hidden = ![_advert.state.ident isEqualToNumber:SOLD_OUT_IDENT];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = kCFDateFormatterMediumStyle;
    offerTitleView.advertDataCreated.text = [NSString stringWithFormat:@"Updated: %@", [dateFormatter stringFromDate:_advert.dateUpdated]];
    
    offerTitleView.advertPriceLabel.text = [NSString stringWithFormat:@"£%.02f", _advert.guidePrice];
    offerTitleView.advertAvailableLabel.text = [NSString stringWithFormat:@"%i%@", _advert.count, _advert.packaging ? _advert.packaging.title: @""];
    
    return offerTitleView;
}

-(void)acceptOffer:(TSOffer*)offer{
    [self showLoading];
    [[OfferServiceManager sharedManager] acceptOffer:offer compleate:^(NSError *error) {
        [self hideLoading];
        NSString* title = @"";
        NSString* text = @"Offer accepted";
        if (error){
            title = @"Error";
            text = ERROR_MESSAGE(error);
        }
        
        [self showOkAlert:title text:text compleate:nil];
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
            NSString* text = @"Offer rejected";
            if (error){
                title = @"Error";
                text = ERROR_MESSAGE(error);
            }
            
            [self showOkAlert:title text:text compleate:nil];
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
            NSString* text = @"Thanks. Counter offer sent. fingers crossed!";
            if (error){
                title = @"Error";
                text = ERROR_MESSAGE(error);
            }else{
                [_offers insertObject:offer.childOffers.lastObject atIndex:0];
            }
            
            [self showOkAlert:title text:text compleate:nil];
            [_offersTableView reloadData];
        }];
    }
}

-(void)confirmOffer:(TSOffer*)offer{
    [self showLoading];
    [[OfferServiceManager sharedManager] confirmOffer:offer compleate:^(NSError *error) {
        [self hideLoading];
        NSString* title = @"";
        NSString* text = @"Sale complete. Please advise us of any issue with the purchase within 24 hours. Thanks for using Takestock.";
        if (error){
            title = @"Error";
            text = ERROR_MESSAGE(error);
        }
        
        [self showOkAlert:title text:text compleate:nil];
        [_offersTableView reloadData];
    }];
}

-(void)raiceDispute:(TSOffer*)offer{
    [self showLoading];
    [[OfferServiceManager sharedManager] diputeOffer:offer compleate:^(NSError *error) {
        [self hideLoading];
        NSString* title = @"";
        NSString* text = @"Dispute raiced.";
        if (error){
            title = @"Error";
            text = ERROR_MESSAGE(error);
        }
        
        [self showOkAlert:title text:text compleate:nil];
        [_offersTableView reloadData];
    }];
}

-(void)hideAlertView:(id)owner{
    [_offerAlertView removeFromSuperview];
    _offerAlertView = nil;
}

#pragma mark - OfferActionDelegate

-(void)mainAction:(UITableViewCell*)owner{
    NSUInteger index = [_offersTableView indexPathForCell:owner].row;
    TSOffer* offer = [_offers objectAtIndex:index];
    
    if ([offer.status.ident intValue] == tsPayment ){
        [self performSegueWithIdentifier:OFFERS_SHIPPING_SEQUE sender:offer];
    }else if ([offer.status.ident intValue] == tsStockInTransit ){
        UIAlertController* confirmGoodsReceived = [UIAlertController alertControllerWithTitle:@"Confirm" message:@"Confirm goods received." preferredStyle:UIAlertControllerStyleAlert];
        [confirmGoodsReceived addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
            [self confirmOffer:offer];
        }]];
        [confirmGoodsReceived addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        
         [self presentViewController:confirmGoodsReceived animated:YES completion:nil];
    }else if ([offer.status.ident intValue] == tsGoodsReceived ){
        
        UIAlertController* confirmGoodsReceived = [UIAlertController alertControllerWithTitle:@"Confirm" message:@"Raice a dispute?" preferredStyle:UIAlertControllerStyleAlert];
        [confirmGoodsReceived addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
            [self raiceDispute:offer];
        }]];
        [confirmGoodsReceived addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        [self presentViewController:confirmGoodsReceived animated:YES completion:nil];
    }else if ([offer.status.ident intValue] == tsPayByBacs ){
        NSUInteger index = [_offersTableView indexPathForCell:owner].row;
        TSOffer* offer = [_offers objectAtIndex:index];
        [self performSegueWithIdentifier:PAY_BY_BACS_SEGUE sender:offer];
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

-(void)contactUsAction:(UITableViewCell *)owner{
    NSString *subject = [NSString stringWithFormat:@""];
    NSString *mail = [NSString stringWithFormat:CONTACT_US_EMAIL];
    NSCharacterSet *set = [NSCharacterSet URLHostAllowedCharacterSet];
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"mailto:?to=%@&subject=%@",
                                                [mail stringByAddingPercentEncodingWithAllowedCharacters:set],
                                                [subject stringByAddingPercentEncodingWithAllowedCharacters:set]]];
    if ([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
    }
}

-(void)contactUserAction:(UITableViewCell *)owner{
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        
        [mailCont setSubject:@"Takestock Trade Message"];
        [mailCont setToRecipients:[NSArray arrayWithObject:_advert.author.email]];
        [mailCont setCcRecipients:[NSArray arrayWithObject:CONTACT_US_EMAIL]];
        [mailCont setMessageBody:[NSString stringWithFormat:@"AdvertName: %@ (%@/selling/%@/)", _advert.name, TAKESTOK_IMAGE_URL, _advert.ident] isHTML:NO];
        
        [self presentViewController:mailCont animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)payByCardAction:(UITableViewCell*)owner{
    NSUInteger index = [_offersTableView indexPathForCell:owner].row;
    TSOffer* offer = [_offers objectAtIndex:index];
    [self performSegueWithIdentifier:PAY_BY_CARD_SEGUE sender:offer];
}

-(void)payByBacsAction:(UITableViewCell*)owner{
    NSUInteger index = [_offersTableView indexPathForCell:owner].row;
    TSOffer* offer = [_offers objectAtIndex:index];
    [self performSegueWithIdentifier:PAY_BY_BACS_SEGUE sender:offer];
}

@end
