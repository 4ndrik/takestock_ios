//
//  BusinessType.m
//  takestok
//
//  Created by Artem on 6/22/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BusinessType.h"
#import "SubBusinessType.h"
#import "User.h"

@implementation BusinessType

+ (NSString *)entityName {
    return @"BusinessType";
}

+(Dictionary*)syncClass:(Class)class withDb:(NSArray*)dbBusinessTypes withJson:(NSDictionary*)jsonBusinessType{
    int ident = [[jsonBusinessType objectForKeyNotNull:BT_ID_PARAM] intValue];
    NSUInteger index = [dbBusinessTypes indexOfObjectPassingTest:^BOOL(Dictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return obj.ident == ident;
    }];
    
    Dictionary* dbBusinessType;
    if (index != NSNotFound){
        dbBusinessType = [dbBusinessTypes objectAtIndex:index];
    }else{
        dbBusinessType = [class storedEntity];
    }
    
    dbBusinessType.ident = ident;
    dbBusinessType.title = [jsonBusinessType objectForKeyNotNull:BT_NAME_PARAM];
    
    return dbBusinessType;
    
}

+(void)syncWithJsonArray:(NSArray*)array{
    NSArray* dbBusinessTypes = [self getAll];
    NSArray* dbSubBusinessTypes = [SubBusinessType getAll];

    for (NSDictionary* jsonBusinessType in array){
        BusinessType* dbBusinessType = (BusinessType*)[self syncClass:[BusinessType class] withDb:dbBusinessTypes withJson:jsonBusinessType];
        for (NSDictionary* subBusinessType in [jsonBusinessType objectForKeyNotNull:BT_SUBTYPE_PARAM]){
            SubBusinessType* dbSubBusinessType = (SubBusinessType*)[self syncClass:[SubBusinessType class] withDb:dbSubBusinessTypes withJson:subBusinessType];
            dbSubBusinessType.businessType = dbBusinessType;
        }
    }
}


@end
