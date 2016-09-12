//
//  TSBaseDictionaryEntity.h
//  takestok
//
//  Created by Artem on 9/9/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSBaseEntity.h"

@interface TSBaseDictionaryEntity : TSBaseEntity<NSCoding>{
    NSNumber* _ident;
    NSString* _title;
}

@property (nonatomic, readonly) NSNumber* ident;
@property (nonatomic, readonly) NSString *title;

-(void)updateWithDic:(NSDictionary*)jsonDic;
+(NSNumber*)identFromDic:(NSDictionary*)jsonDic;

@end
