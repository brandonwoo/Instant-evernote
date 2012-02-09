//
//  EvernoteRequest.h
//
//  Created by Brandon Ng on 10/04/27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserStore.h"
#import "NoteStore.h"
#define EVERNOTE_AUTH_CREDENTIALS_KEY @"APP_AUTH_CREDENTIALS_KEY"

@interface EvernoteRequest : NSObject {
}

+ (void)storeCredentials:(EDAMAuthenticationResult *)authResult;
+ (EDAMAuthenticationResult *)getStoredCredentials;
+ (void)deleteStoredCredentials;

- (void)authenticate:(NSString*)username password:(NSString*)password;
- (void)submitPost:(NSString*)content;

@end

