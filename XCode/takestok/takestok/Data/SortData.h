//
//  SortData.h
//  takestok
//
//  Created by Artem on 5/10/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SortData : NSObject{
    int _ident;
    NSString* _title;
    NSString* _value;
}

@property (readonly) int ident;
@property (readonly) NSString* title;
@property (readonly) NSString* value;

-(instancetype)initWith:(int)ident withTitle:(NSString*)title withValue:(NSString*)value;
+(NSArray*)getAll;

@end
