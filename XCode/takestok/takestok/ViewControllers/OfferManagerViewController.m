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
#import "OfferActionView.h"
#import "PaddingTextField.h"

@implementation OfferManagerViewController
@synthesize advert = _advert;

-(void)viewDidLoad{
    [super viewDidLoad];
    _offers = [_advert.offers allObjects];
    
    _offersTableView.estimatedRowHeight = 124.0;
    _offersTableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - helpers

-(NSMutableAttributedString*)spaceForFont{
    NSMutableAttributedString* spaceString = [[NSMutableAttributedString alloc] initWithString:@"\n \n"];
    [spaceString addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:6]
                        range:NSMakeRange(0, spaceString.length)];
    return spaceString;
}

-(NSMutableAttributedString*)fillOfferInformation:(Offer*)offer advert:(Advert*)advert cell:(OfferTableViewCell*)cell{
    
    NSMutableAttributedString* textString = [[NSMutableAttributedString alloc] init];
    if (offer.status.ident == stAccept){
        
        if (textString.length > 0)
            [textString appendAttributedString:[self spaceForFont]];
        
        NSMutableAttributedString* acceptString = [[NSMutableAttributedString alloc] initWithString:@"ACCEPTED WAITING SHIPPING INFO"];
        [acceptString addAttribute:NSFontAttributeName
                             value:BrandonGrotesqueBold14
                             range:NSMakeRange(0, acceptString.length)];
        [acceptString addAttribute:NSForegroundColorAttributeName value:OliveMainColor range:NSMakeRange(0, acceptString.length)];
        [textString appendAttributedString:acceptString];
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
            [commentString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, commentString.length)];
            [textString appendAttributedString:commentString];
        }
        
    }else if (offer.status.ident == stPending){
        
        if (!offer.parentOffer){
            cell.operationPanelHeight.constant = 30.;
        }else{
            NSMutableAttributedString* pendingString = [[NSMutableAttributedString alloc] initWithString:@"WAITING RESPONCE"];
            [pendingString addAttribute:NSFontAttributeName
                                  value:BrandonGrotesqueBold14
                                  range:NSMakeRange(0, pendingString.length)];
            [pendingString addAttribute:NSForegroundColorAttributeName value:OliveMainColor range:NSMakeRange(0, pendingString.length)];
            [textString appendAttributedString:pendingString];
        }
    }
    else if (offer.status.ident == stCountered ){
        
        cell.myRequestLabel.text = @"Your offer:";
        cell.myQuantityLabel.text = [NSString stringWithFormat:@"%i%@", offer.counterOffer.quantity, advert.packaging ? advert.packaging.title: @""];
        cell.myPricelabel.text = [NSString stringWithFormat:@"£%.02f", offer.counterOffer.price];
        
        if (offer.comment.length > 0){
            if (textString.length > 0)
                [textString appendAttributedString:[self spaceForFont]];
            
            NSMutableAttributedString* commentString = [[NSMutableAttributedString alloc] initWithString:offer.comment];
            [commentString addAttribute:NSFontAttributeName
                                  value:HelveticaNeue14
                                  range:NSMakeRange(0, commentString.length)];
            [commentString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, commentString.length)];
            [textString appendAttributedString:commentString];
        }
        
        NSMutableAttributedString* additionalTextString = [self fillOfferInformation:offer.counterOffer advert:advert cell:cell];
        if (additionalTextString.length > 0){
            if (textString.length > 0)
                [textString appendAttributedString:[self spaceForFont]];
            [textString appendAttributedString:additionalTextString];
        }
    }
    
    return textString;
}

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

-(void)rejectOffer:(id)owner{
    int index = [_offers indexOfObjectPassingTest:^BOOL(Offer*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return obj.ident == _offerAlertView.tag;
    }];
    if (index != NSNotFound){
        Offer* offer = [_offers objectAtIndex:index];
        offer.status = [OfferStatus getEntityWithId:stDecline];
        offer.comment = _offerAlertView.commentTextView.text;
        [_offerAlertView removeFromSuperview];
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
}

-(void)counterOffer:(id)owner{
    float oPrice = [_offerAlertView.priceTextEdit.text floatValue];
    int oQuantity = [_offerAlertView.qtyTextEdit.text intValue];
    
    int index = [_offers indexOfObjectPassingTest:^BOOL(Offer*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return obj.ident == _offerAlertView.tag;
    }];
    
    if (index != NSNotFound && oPrice > 0 && oQuantity > 0){
        Offer* offer = [_offers objectAtIndex:index];
        offer.status = [OfferStatus getEntityWithId:stCountered];
        offer.comment = _offerAlertView.commentTextView.text;
        
        Offer* counterOffer = [Offer storedEntity];
        counterOffer.parentOffer = offer;
        counterOffer.user = [User getMe];
        counterOffer.price = oPrice;
        counterOffer.quantity = oQuantity;
        counterOffer.status = [OfferStatus getEntityWithId:stPending];
        
        [_offerAlertView removeFromSuperview];
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
                    [_offersTableView reloadData];
                    [self showOkAlert:title text:text];
                }];
            }
        }];
    }
}

-(void)hideOfferView:(id)owner{
    [_offerAlertView removeFromSuperview];
    _offerAlertView = nil;
}

#pragma mark - UITableViewDelegates
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
    cell.operationPanelHeight.constant = 0.;
    
    NSMutableAttributedString* textString = [self fillOfferInformation:offer advert:offer.advert cell:cell];
    [cell.commentLabel setAttributedText:textString];
    return cell;
    
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
    _offerAlertView =  [OfferActionView loadFromXib];
    _offerAlertView.frame = self.view.bounds;
    
    _offerAlertView.titleLabel.text = @"Reject offer.";
    _offerAlertView.priceQtyHeightConstraints.constant = 0;
    int index = [_offersTableView indexPathForCell:owner].row;
    Offer* offer = [_offers objectAtIndex:index];
    _offerAlertView.tag = offer.ident;
    [_offerAlertView.cancelButton addTarget:self action:@selector(hideOfferView:) forControlEvents:UIControlEventTouchUpInside];
    [_offerAlertView.sendButton addTarget:self action:@selector(rejectOffer:) forControlEvents:UIControlEventTouchUpInside];
    
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:_offerAlertView];
    
    [_offerAlertView.commentTextView becomeFirstResponder];
}

-(void)counterOfferAction:(OfferTableViewCell*)owner{
    
    _offerAlertView =  [OfferActionView loadFromXib];
    _offerAlertView.frame = self.view.bounds;
    
    _offerAlertView.titleLabel.text = @"Counter offer.";
    int index = [_offersTableView indexPathForCell:owner].row;
    Offer* offer = [_offers objectAtIndex:index];
    _offerAlertView.tag = offer.ident;
    [_offerAlertView.cancelButton addTarget:self action:@selector(hideOfferView:) forControlEvents:UIControlEventTouchUpInside];
    [_offerAlertView.sendButton addTarget:self action:@selector(counterOffer:) forControlEvents:UIControlEventTouchUpInside];
    
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:_offerAlertView];
    
    _offerAlertView.priceTypeLabel.text = @"£";
    _offerAlertView.qtytypeLabel.text = offer.advert.packaging ? offer.advert.packaging.title: @"";
    
    [_offerAlertView.priceTextEdit becomeFirstResponder];
}

@end
