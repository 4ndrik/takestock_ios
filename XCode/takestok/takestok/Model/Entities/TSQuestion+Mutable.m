//
//  TSQuestion+Mutable.m
//  takestok
//
//  Created by Artem on 9/20/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSQuestion+Mutable.h"

@implementation TSQuestion (Mutable)

-(void)setIsNew:(BOOL)isNew{
    _isNew = isNew;
}

-(void)setMessage:(NSString *)message{
    _message = message;
}

-(void)setAdvertId:(NSNumber *)advertId{
    _advertId = advertId;
}

-(void)setUserIdent:(NSNumber *)userIdent{
    _userIdent = userIdent;
}

-(void)setDateCreated:(NSDate *)dateCreated{
    _dateCreated = dateCreated;
}

-(void)setUserName:(NSString *)userName{
    _userName = userName;
}

@end
