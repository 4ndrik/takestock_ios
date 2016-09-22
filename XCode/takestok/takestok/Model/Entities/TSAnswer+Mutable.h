//
//  TSAnswer+Mutable.h
//  takestok
//
//  Created by Artem on 9/22/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSAnswer.h"

@interface TSAnswer (Mutable)

@property (nonatomic, readwrite, assign) NSNumber* questionId;
@property (nonatomic, readwrite, assign) NSNumber* userIdent;
@property (nonatomic, readwrite, retain) NSString* userName;
@property (nonatomic, readwrite, retain) NSString* message;
@property (nonatomic, readwrite, retain) NSDate* dateCreated;

@end
