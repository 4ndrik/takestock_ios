//
//  TSAnswer+Mutable.m
//  takestok
//
//  Created by Artem on 9/22/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSAnswer+Mutable.h"

@implementation TSAnswer (Mutable)

-(void)setQuestionId:(NSNumber *)questionId{
    _questionId = questionId;
}

-(void)setUserIdent:(NSNumber *)userIdent{
    _userIdent = userIdent;
}

-(void)setUserName:(NSString *)userName{
    _userName = userName;
}

-(void)setMessage:(NSString *)message{
    _message = message;
}

-(void)setDateCreated:(NSDate *)dateCreated{
    _dateCreated = dateCreated;
}

@end
