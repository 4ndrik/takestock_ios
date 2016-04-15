//
//  GUIDCreator.m
//  toogletoys
//
//  Created by Serbin Artem on 7/22/14.
//  Copyright (c) 2014 organization. All rights reserved.
//

#import "GUIDCreator.h"

@implementation GUIDCreator

+(NSString*)getGuid
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    NSString* result =  (__bridge NSString *)string;
    return [result lowercaseString];
}

@end
