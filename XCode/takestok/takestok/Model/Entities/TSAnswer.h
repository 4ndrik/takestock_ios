//
//  TSAnswer.h
//  takestok
//
//  Created by Artem on 9/15/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSBaseEntity.h"

@interface TSAnswer : TSBaseEntity

@property (nonatomic, readonly, assign) NSNumber* questionId;
@property (nonatomic, readonly, assign) NSNumber* userIdent;
@property (nonatomic, readonly, retain) NSString* userName;
@property (nonatomic, readonly, retain) NSString* message;
@property (nonatomic, readonly, retain) NSDate* dateCreated;

-(instancetype)initWithQuestionIdent:(NSNumber*)questionId withDic:(NSDictionary*)dic;

@end
