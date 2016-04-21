//
//  Dictionary.m
//  takestok
//
//  Created by Artem on 4/21/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "Dictionary.h"

@implementation Dictionary

+ (instancetype)tempEntity {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

+ (NSString *)entityName {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

+(void)syncWithJsonArray:(NSArray*)array{
    NSArray* dbDictionaries = [self getAll];
//    NSMutableArray* allIdents = [NSMutableArray array];
    for (NSDictionary* jsonDic in array){
        int ident = [[jsonDic allKeys].firstObject intValue];
        NSUInteger index = [dbDictionaries indexOfObjectPassingTest:^BOOL(Dictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return obj.ident == ident;
        }];
        
        Dictionary* dbDic;
        if (index != NSNotFound){
            dbDic = [dbDictionaries objectAtIndex:index];
        }else{
            dbDic = [self storedEntity];
        }
        
        dbDic.ident = ident;
        dbDic.title = [jsonDic allValues].firstObject;
    }
    [[DB sharedInstance].storedManagedObjectContext save:nil];
    //TODO Remove old items
}


@end
