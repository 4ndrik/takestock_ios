//
//  TSQuestion+Mutable.h
//  takestok
//
//  Created by Artem on 9/20/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSQuestion.h"

@interface TSQuestion (Mutable)

@property (nonatomic, readwrite, retain) NSNumber* userIdent;
@property (nonatomic, readwrite, retain) NSString* userName;
@property (nonatomic, readwrite, retain) NSString* message;
@property (nonatomic, readwrite, retain) NSDate* dateCreated;
@property (nonatomic, readwrite, retain) NSNumber* advertId;
@property (nonatomic, readwrite, assign) BOOL isNew;
@property (nonatomic, readwrite, retain) TSAnswer* answer;

@end
