//
//  ServerConnectionHalper.h
//  takestok
//
//  Created by Artem on 4/19/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Reachability;
@class User;

@interface ServerConnectionHelper : NSObject{
    Reachability* _reachability;
    NSURLSession *_session;
    
    NSURLSessionDataTask* _loadAdvertCancelTask;
}

+(ServerConnectionHelper*)sharedInstance;
-(BOOL)isInternetConnection;
-(void)loadAdverb:(void(^)(NSArray* adverbs, NSError* error))compleate;
-(void)loadDictionaries;
-(void)loadUser:(int)ident compleate:(void(^)(User* user, NSError* error))compleate;

@end
