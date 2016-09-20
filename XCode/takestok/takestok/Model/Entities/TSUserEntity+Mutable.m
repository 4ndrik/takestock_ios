//
//  TSUserEntity+Mutable.m
//  takestok
//
//  Created by Artem on 9/20/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSUserEntity+Mutable.h"

@implementation TSUserEntity (Mutable)

@dynamic isSuscribed;
@dynamic isVerified;
@dynamic isVatExtempt;
@dynamic photo;
@dynamic postCode;
@dynamic vatNumber;
@dynamic stripeId;
@dynamic last4;
@dynamic businessName;
@dynamic businessType;
@dynamic subBusinessType;

-(void)setIsSuscribed:(BOOL)isSuscribed{
    _isSuscribed = isSuscribed;
}

-(void)setIsVerified:(BOOL)isVerified{
    _isVerified = isVerified;
}

-(void)setIsVatExtempt:(BOOL)isVatExtempt{
    _isVatExtempt = isVatExtempt;
}

-(void)setPhoto:(TSImageEntity *)photo{
    _photo = photo;
}

-(void)setPostCode:(NSString *)postCode{
    _postCode = postCode;
}

-(void)setVatNumber:(NSString *)vatNumber{
    _vatNumber = vatNumber;
}

-(void)setStripeId:(NSString *)stripeId{
    _stripeId = stripeId;
}

-(void)setLast4:(NSString *)last4{
    _last4 = last4;
}

-(void)setBusinessName:(NSString *)businessName{
    _businessName = businessName;
}

-(void)setBusinessType:(TSUserBusinessType *)businessType{
    _businessType = businessType;
}

-(void)setSubBusinessType:(TSUserSubBusinessType *)subBusinessType{
    _subBusinessType = subBusinessType;
}

@end
