//
//  NSDate+Extended.h
//  takestok
//
//  Created by Artem on 4/14/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extended)

+(NSString*)stringFromTimeInterval:(int)timeInterval;
-(NSInteger)daysFromDate:(NSDate *)pDate;

+(NSDate*)dateFromString:(NSString*)date format:(NSString*)format timeZone:(NSTimeZone*)timeZone;
+(NSString*)stringFromDate:(NSDate*)date format:(NSString*)format timeZone:(NSTimeZone*)timeZone;

+(NSString*)stringFromTimeInterval:(NSTimeInterval)date format:(NSString*)format timeZone:(NSTimeZone*)timeZone;

@end
