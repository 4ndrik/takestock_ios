//
//  NSLayoutConstraint+Description.m
//  takestok
//
//  Created by Artem on 6/9/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "NSLayoutConstraint+Description.h"

@implementation NSLayoutConstraint (Description)

-(NSString *)description {
    return [NSString stringWithFormat:@"id: %@, constant: %f", self.identifier, self.constant];
}

@end
