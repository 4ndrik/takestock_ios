//
//  NSDate+Extended.m
//  takestok
//
//  Created by Artem on 4/14/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "NSDate+Extended.h"

@implementation NSDate (Extended)

+(NSString*)stringFromTimeInterval:(int)timeInterval{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    formatter.timeZone = [NSTimeZone systemTimeZone];
    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval]];
}

+(NSString*)stringFromDate:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    formatter.timeZone = [NSTimeZone systemTimeZone];
    return [formatter stringFromDate:date];
}

- (NSInteger)daysFromDate:(NSDate *)pDate {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger startDay=[calendar ordinalityOfUnit:NSCalendarUnitDay
                                           inUnit:NSCalendarUnitEra
                                          forDate:self];
    NSInteger endDay=[calendar ordinalityOfUnit:NSCalendarUnitDay
                                         inUnit:NSCalendarUnitEra
                                        forDate:pDate];
    return labs(endDay - startDay);
}

+(NSDate*)dateFromString:(NSString*)date format:(NSString*)format timeZone:(NSTimeZone*)timeZone{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    dateFormatter.timeZone = timeZone;
    return [dateFormatter dateFromString:date];
}

+(NSString*)stringFromDate:(NSDate*)date format:(NSString*)format timeZone:(NSTimeZone*)timeZone{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    dateFormatter.timeZone = timeZone;
    return [dateFormatter stringFromDate:date];
}

+(NSString*)stringFromTimeInterval:(NSTimeInterval)date format:(NSString*)format timeZone:(NSTimeZone*)timeZone{
    NSDate* d = [NSDate dateWithTimeIntervalSinceReferenceDate:date];
    return [self stringFromDate:d format:format timeZone:timeZone];
}

@end
