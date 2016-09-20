//
//  NSDictionary+HandleNil.m
//  Occupy
//
//  Created by N-iX Artem Serbin on 11/29/12.
//  Copyright (c) 2013 App Dev LLC. All rights reserved.
//

#import "NSDictionary+HandleNil.h"

@implementation NSDictionary (HandleNil)

- (id)objectForKeyNotNull:(id)key {
    id object = [self objectForKey:key];
    if (object == [NSNull null])
    {
//        NSLog(@"value for key %@ not found", key);
        return nil;
    }
    
    return object;
}

-(id)valueForKeyNotNull:(NSString *)key
{
    return [self objectForKeyNotNull:key];
}

-(void)setObjectNotNull:(id)object forKey:(id)key{
    if (object && object != [NSNull null]){
        [(NSMutableDictionary*)self setObject:object forKey:key];
    }
}

@end
