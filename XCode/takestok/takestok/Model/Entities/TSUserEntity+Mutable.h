//
//  TSUserEntity+Mutable.h
//  takestok
//
//  Created by Artem on 9/20/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSUserEntity.h"

@interface TSUserEntity (Mutable)

@property (readwrite, nonatomic, assign) BOOL isSuscribed;
@property (readwrite, nonatomic, assign) BOOL isVerified;
@property (readwrite, nonatomic, assign) BOOL isVatExtempt;
@property (readwrite, nonatomic, retain) TSImageEntity *photo;
@property (readwrite, nonatomic, retain) NSString *postCode;
@property (readwrite, nonatomic, retain) NSString *vatNumber;
@property (readwrite, nonatomic, retain) NSString *stripeId;
@property (readwrite, nonatomic, retain) NSString *last4;
@property (readwrite, nonatomic, retain) NSString *businessName;
@property (readwrite, nonatomic, retain) TSUserBusinessType *businessType;
@property (readwrite, nonatomic, retain) TSUserSubBusinessType *subBusinessType;

@end
