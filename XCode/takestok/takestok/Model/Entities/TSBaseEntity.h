//
//  TSBaseDictionaryEntity.h
//  takestok
//
//  Created by Artem on 9/9/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULT_DATE_FORMAT @"yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
#define NO_MILI_DATE_FORMAT @"yyyy-MM-dd'T'HH:mm:ss'Z'"

@interface TSBaseEntity : NSObject{
    NSNumber* _ident;
}
@property (nonatomic, readonly) NSNumber* ident;

+ (instancetype)objectWithDictionary:(NSDictionary *)dict;
-(NSDictionary*)dictionaryRepresentation;
+(NSNumber*)identFromDic:(NSDictionary*)jsonDic;
-(void)updateWithDic:(NSDictionary*)jsonDic;

@end
