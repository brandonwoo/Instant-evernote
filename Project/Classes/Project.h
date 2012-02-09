//
//  Project.h
//  Project
//
//  Created by Brandon Woo on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewController.h"
#import "PostViewController.h"
#import "EvernoteRequest.h"

#define EVERNOTE_CONNECT_URI_CONFIG_KEY @"EVERNOTE_CONNECT_URI"
#define EVERNOTE_CONSUMER_KEY_CONFIG_KEY @"EVERNOTE_CONSUMER_KEY"
#define EVERNOTE_CONSUMER_SECRET_CONFIG_KEY @"EVERNOTE_CONSUMER_SECRET"

@interface Project : NSObject {
	LoginViewController *_loginViewController;
	PostViewController *_postViewController;
	EvernoteRequest *_evernoteRequest;
    
    NSDictionary *_appConfigData;
}

@property (nonatomic, retain) LoginViewController *loginViewController;
@property (nonatomic, retain) PostViewController *postViewController;
@property (nonatomic, retain) EvernoteRequest *evernoteRequest;
@property (nonatomic, retain) NSDictionary *appConfigData;

/**
 project class singleton
 */
+ (Project *)sharedInstance;

/**
 init app: 
 initialize windows/navigation controllers
 load saved user credentials or show login screen
 */
- (BOOL)initApp;

/**
 call after user logins
 */
- (void)userLogined;

/**
 delete saved user
 */
- (void) deleteCurrentUser;

/**
 submit and save a note
 */
- (void)submitPost:(NSString *)content;

/**
 get config value for key specified. returns nil if not found.
 */
- (NSString *) getConfigValueForKey:(NSString *)key;

@end
