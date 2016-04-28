//
//  Categoriy.m
//  takestok
//
//  Created by Artem on 4/21/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "Category.h"
#import "Advert.h"
#import "NSDictionary+HandleNil.h"

@implementation Category

+ (NSString *)entityName {
    return @"Category";
}

+(Category*)sync:(NSArray*)dbCategories withJson:(NSDictionary*)jsonCategory{
    int ident = [[jsonCategory objectForKeyNotNull:@"pk"] intValue];
    NSUInteger index = [dbCategories indexOfObjectPassingTest:^BOOL(Dictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return obj.ident = ident;
    }];
    
    Category* dbCategory;
    if (index != NSNotFound){
        dbCategory = [dbCategories objectAtIndex:index];
    }else{
        dbCategory = [self storedEntity];
    }
    
    dbCategory.ident = ident;
    dbCategory.title = [jsonCategory objectForKeyNotNull:@"name"];
    
    return dbCategory;

}

+(void)syncWithJsonArray:(NSArray*)array{
    NSArray* dbCategories = [self getAll];
    //    NSMutableArray* allIdents = [NSMutableArray array];
    for (NSDictionary* jsonCategory in array){
        Category* dbCategory = [self sync:dbCategories withJson:jsonCategory];
        for (NSDictionary* subCategory in [jsonCategory objectForKeyNotNull:@"subcategories"]){
            Category* dbSubCategory = [self sync:dbCategories withJson:subCategory];
            dbSubCategory.parentCategory = dbCategory;
        }
    }
    
    [[DB sharedInstance].storedManagedObjectContext save:nil];
    
    //TODO Remove old items
}

+(NSArray*)getAllCategories{
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ident" ascending:YES];
    NSFetchRequest* request = [self getFetchRequestForPredicate:[NSPredicate predicateWithFormat:@"parentCategory == nil"] withSortDescriptions:[NSArray arrayWithObjects:sortDescriptor, nil]];
    return [[DB sharedInstance].storedManagedObjectContext executeFetchRequest:request error:nil];
}

+(NSArray*)getAllSubCategories{
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ident" ascending:YES];
    NSFetchRequest* request = [self getFetchRequestForPredicate:[NSPredicate predicateWithFormat:@"parentCategory != nil"]  withSortDescriptions:[NSArray arrayWithObjects:sortDescriptor, nil]];
    return [[DB sharedInstance].storedManagedObjectContext executeFetchRequest:request error:nil];
}

@end
