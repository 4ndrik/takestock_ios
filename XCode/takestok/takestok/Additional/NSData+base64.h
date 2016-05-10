//
//  NSData+base64.h
//  smartbuy4me
//
//  Created by N-iX Artem Serbin on 5/14/13.
//  Copyright (c) 2013 App Dev LLC. All rights reserved.
//


@interface NSData (MBBase64)

+ (id)dataWithBase64EncodedString:(NSString *)string;     //  Padding '=' characters are optional. Whitespace is ignored.
- (NSString *)base64Encoding;
@end

