//
//  TSAuthorEntity.h
//  takestok
//
//  Created by Artem on 9/13/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSBaseEntity.h"
#import "TSImageEntity.h"

@class TSUserBusinessType;
@class TSUserSubBusinessType;
@class TSImageEntity;

@interface TSUserEntity : TSBaseEntity<NSCoding, NSCopying>{
    NSString* _userName;
    NSString*_firstName;
    NSString* _lastName;
    NSString*_email;
    BOOL _isSuscribed;
    BOOL _isVerified;
    BOOL _isVatExtempt;
    float _rating;
    TSImageEntity* _photo;
    NSString* _postCode;
    NSString* _vatNumber;
    NSString* _stripeId;
    NSString* _last4;
    NSString* _businessName;
    TSUserBusinessType* _businessType;
    TSUserSubBusinessType* _subBusinessType;
}

@property (readonly, nonatomic, retain) NSString *userName;
@property (readonly, nonatomic, retain) NSString *firstName;
@property (readonly, nonatomic, retain) NSString *lastName;
@property (readonly, nonatomic, retain) NSString *email;
@property (readonly, nonatomic, assign) BOOL isSuscribed;
@property (readonly, nonatomic, assign) BOOL isVerified;
@property (readonly, nonatomic, assign) BOOL isVatExtempt;
@property (readonly, nonatomic, assign) float rating;
@property (readonly, nonatomic, retain) TSImageEntity *photo;
@property (readonly, nonatomic, retain) NSString *postCode;
@property (readonly, nonatomic, retain) NSString *vatNumber;
@property (readonly, nonatomic, retain) NSString *stripeId;
@property (readonly, nonatomic, retain) NSString *last4;
@property (readonly, nonatomic, retain) NSString *businessName;
@property (readonly, nonatomic, retain) TSUserBusinessType *businessType;
@property (readonly, nonatomic, retain) TSUserSubBusinessType *subBusinessType;

@end
