//
//  Packaging.m
//  takestok
//
//  Created by Artem on 5/11/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "Packaging.h"
#import "Advert.h"
#import "NSDictionary+HandleNil.h"

@implementation Packaging

+ (NSString *)entityName {
    return @"Packaging";
}

+(void)syncWithJsonArray:(NSArray*)array{
    NSArray* dbPackagings = [self getAll];
    for (NSDictionary* jsonDic in array){
        int ident = [[jsonDic objectForKeyNotNull:@"id"] intValue];
        NSUInteger index = [dbPackagings indexOfObjectPassingTest:^BOOL(Dictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return obj.ident == ident;
        }];
        
        Packaging* dbPackaging;
        if (index != NSNotFound){
            dbPackaging = [dbPackagings objectAtIndex:index];
        }else{
            dbPackaging = [self storedEntity];
        }
        
        dbPackaging.ident = ident;
        dbPackaging.title = [jsonDic objectForKeyNotNull:@"name"];
    }
    [[DB sharedInstance].storedManagedObjectContext save:nil];
    //TODO Remove old items
}

@end
