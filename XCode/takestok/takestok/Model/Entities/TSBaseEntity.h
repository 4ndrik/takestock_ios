//
//  TSBaseDictionaryEntity.h
//  takestok
//
//  Created by Artem on 9/9/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSBaseEntity : NSObject

+ (instancetype)objectWithDictionary:(NSDictionary *)dict;
-(NSDictionary*)dictionaryRepresentation;

@end
