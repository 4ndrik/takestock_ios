//
//  Certification.m
//  takestok
//
//  Created by Artem on 4/21/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "Certification.h"
#import "Image.h"
#import "NSDictionary+HandleNil.h"

@implementation Certification

+ (NSString *)entityName {
    return @"Certification";
}

+(void)syncWithJsonArray:(NSArray*)array{
    NSArray* dbCertifications = [self getAll];
//    NSMutableArray* allIdents = [NSMutableArray array];
    for (NSDictionary* jsonCerts in array){
        int ident = [[jsonCerts objectForKeyNotNull:@"pk"] intValue];
        NSUInteger index = [dbCertifications indexOfObjectPassingTest:^BOOL(Dictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return obj.ident = ident;
        }];
        
        Certification* dbCert;
        if (index != NSNotFound){
            dbCert = [dbCertifications objectAtIndex:index];
        }else{
            dbCert = [self storedEntity];
        }
        
        dbCert.ident = ident;
        dbCert.title = [jsonCerts objectForKeyNotNull:@"name"];
        dbCert.certDescription = [jsonCerts objectForKeyNotNull:@"description"];
        
        Image* image = [Image storedEntity];
        NSString* url = [jsonCerts objectForKeyNotNull:@"logo"];
        image.url = url;
        image.resId = [url lastPathComponent];
        dbCert.image = image;
//        [allIdents addObject:[NSNumber numberWithInt:ident]];
    }
    
    [[DB sharedInstance].storedManagedObjectContext save:nil];
    
    //TODO Remove old items
    
}

@end
