//
//  NSDictionary+HandleNil.h
//  Occupy
//
//  Created by N-iX Artem Serbin on 11/29/12.
//  Copyright (c) 2013 App Dev LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (HandleNil)
- (id)objectForKeyNotNull:(id)key;
-(id)valueForKeyNotNull:(NSString *)key;
-(void)setObjectNotNull:(id)object forKey:(id)key;
@end
