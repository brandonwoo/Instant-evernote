//
//  EvernoteRequest.m
//
//  Created by Brandon Ng on 10/04/27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EvernoteRequest.h"
#import "Project.h"

//evernote
#import "THTTPClient.h"
#import "TBinaryProtocol.h"
//evernote

#import "Errors.h"

#define EVERNOTE_USER_STORE @"/user"
#define EVERNOTE_NOTE_STORE @"/note"

@implementation EvernoteRequest

+ (void)storeCredentials:(EDAMAuthenticationResult *)authResult {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:authResult];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:EVERNOTE_AUTH_CREDENTIALS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)deleteStoredCredentials {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:EVERNOTE_AUTH_CREDENTIALS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (EDAMAuthenticationResult *)getStoredCredentials {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:EVERNOTE_AUTH_CREDENTIALS_KEY];
    EDAMAuthenticationResult* authResult = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return authResult;
}

- (void)authenticate:(NSString*)username password:(NSString*)password {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    @try {
        // Keep this key private
        NSString *consumerKey = [[Project sharedInstance] getConfigValueForKey:EVERNOTE_CONSUMER_KEY_CONFIG_KEY];
        NSString *consumerSecret = [[Project sharedInstance] getConfigValueForKey:EVERNOTE_CONSUMER_SECRET_CONFIG_KEY];
        // For testing we use the sandbox server.
        
        NSString *baseUri = [[Project sharedInstance] getConfigValueForKey:EVERNOTE_CONNECT_URI_CONFIG_KEY];
        NSString *uri = [baseUri stringByAppendingString:EVERNOTE_USER_STORE];
        NSURL *userStoreUri = [[[NSURL alloc]
                                initWithString: uri] autorelease];
        // These are for test purposes. At some point the user will provide his/her own.
        
        THTTPClient *userStoreHttpClient = [[[THTTPClient alloc]
                                             initWithURL:userStoreUri] autorelease];
        TBinaryProtocol *userStoreProtocol = [[[TBinaryProtocol alloc]
                                               initWithTransport:userStoreHttpClient] autorelease];
        EDAMUserStoreClient *userStore = [[[EDAMUserStoreClient alloc]
                                           initWithProtocol:userStoreProtocol] autorelease];
        
        BOOL versionOk = [userStore checkVersion:@"Cocoa EDAMTest" :
                          [EDAMUserStoreConstants EDAM_VERSION_MAJOR] :
                          [EDAMUserStoreConstants EDAM_VERSION_MINOR]];
        
        if (versionOk == YES)
        {
            EDAMAuthenticationResult* authResult =
            [userStore authenticate:username :password
                                   :consumerKey :consumerSecret];
            EDAMUser *user = [authResult user];
            NSLog(@"Authentication was successful for: %@", [user username]);
            
            [EvernoteRequest storeCredentials:authResult];
            
            [[Project sharedInstance] userLogined];
        }
	}
    @catch (EDAMUserException *exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login failed"
                                                            message:@"Please try again"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView autorelease];
    }
	@catch (NSException *exception) {
        NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
    @finally {
        [pool drain];
    }
}


- (void)submitPost:(NSString*)content {
	@try {
        
        EDAMAuthenticationResult* authResult = [EvernoteRequest getStoredCredentials];
        if (!authResult) {
            [EDAMUserException raise:@"No user credentials found" format:@"Please logout and login again"];
        }
        
        NSString *baseUri = [[Project sharedInstance] getConfigValueForKey:EVERNOTE_CONNECT_URI_CONFIG_KEY];
        NSString *userStoreUriString = [baseUri stringByAppendingString:EVERNOTE_USER_STORE];
        
		NSURL *userStoreUri = [[[NSURL alloc]
								initWithString: userStoreUriString] autorelease];
        
		// These are for test purposes. At some point the user will provide his/her own.
		
		THTTPClient *userStoreHttpClient = [[[THTTPClient alloc]
											 initWithURL:userStoreUri] autorelease];
		TBinaryProtocol *userStoreProtocol = [[[TBinaryProtocol alloc]
											   initWithTransport:userStoreHttpClient] autorelease];
		EDAMUserStoreClient *userStore = [[[EDAMUserStoreClient alloc]
										   initWithProtocol:userStoreProtocol] autorelease];
		EDAMNotebook* defaultNotebook = NULL;
		
		BOOL versionOk = [userStore checkVersion:@"Cocoa EDAMTest" :
						  [EDAMUserStoreConstants EDAM_VERSION_MAJOR] :
						  [EDAMUserStoreConstants EDAM_VERSION_MINOR]];
		
		if (versionOk == YES)
		{
            EDAMUser *user = [authResult user];
            NSString *authToken = [authResult authenticationToken];
            
            NSString *baseNoteStoreUriString = [baseUri stringByAppendingString:EVERNOTE_NOTE_STORE];
			
			NSURL *noteStoreUri =  [[[NSURL alloc]
									 initWithString:[NSString stringWithFormat:@"%@/%@",
													 baseNoteStoreUriString,
                                                     [user shardId]]]
                                    autorelease];
            
			THTTPClient *noteStoreHttpClient = [[[THTTPClient alloc]
												 initWithURL:noteStoreUri] autorelease];
			TBinaryProtocol *noteStoreProtocol = [[[TBinaryProtocol alloc]
												   initWithTransport:noteStoreHttpClient] autorelease];
			EDAMNoteStoreClient *noteStore = [[[EDAMNoteStoreClient alloc]
											   initWithProtocol:noteStoreProtocol] autorelease];
			
			NSArray *notebooks = [noteStore listNotebooks:authToken];
			NSLog(@"Found %d notebooks", [notebooks count]);
			for (int i = 0; i < [notebooks count]; i++)
			{
				EDAMNotebook* notebook = (EDAMNotebook*)[notebooks objectAtIndex:i];
				if ([notebook defaultNotebook] == YES)
				{
					defaultNotebook = notebook;
				}
				NSLog(@" * %@", [notebook name]);
			}
			
			NSLog(@"Creating a new note in default notebook: %@", [defaultNotebook name]);
			
            NSLog(@"content before trimming %@", content);
            content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSLog(@"content after trimming %@", content);
			// Skipping the image resource section...
            
            NSMutableArray *lines = [[[NSMutableArray alloc]init ]autorelease];            
			lines = [[content componentsSeparatedByCharactersInSet:
									  [NSCharacterSet newlineCharacterSet]] 
									 mutableCopy];
			NSLog(@"components joined by br: %@", [lines componentsJoinedByString:@"<br/>"]);
			
			NSLog(@"%@", [defaultNotebook name]);
			
			EDAMNote *note = [[[EDAMNote alloc] init] autorelease];
			[note setNotebookGuid:[defaultNotebook guid]];
            
            NSString *tempTitle = [[[NSString alloc] init] autorelease];
            tempTitle = [[lines objectAtIndex: 0]
                         stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
            if ([tempTitle length] == 0) {
                tempTitle = @"Untitled Note";
            }
            
			[note setTitle: tempTitle];
			
            NSLog(@"contents: %@", [[lines objectAtIndex: 0]
                                    stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]);
            [lines removeObjectAtIndex:0];
			
			NSMutableString *contentString = [[[NSMutableString alloc] init] autorelease];
			[contentString setString:	 @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"];
			[contentString appendString: @"<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml.dtd\">"];
			[contentString appendString: [NSString stringWithFormat:@"<en-note>%@</en-note>", 
                                           [[lines componentsJoinedByString:@"<br/>"] 
                                            stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]];
			
            NSLog(@"contents: %@", [[lines componentsJoinedByString:@"<br/>"]
                                    stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]);
			
			[note setContent:contentString];
			[note setCreated:(long long)[[NSDate date] timeIntervalSince1970] * 1000];
			EDAMNote *createdNote = [noteStore createNote:authToken :note];
			if (createdNote != NULL)
			{
				NSLog(@"Created note: %@", [createdNote title]);
			}
		}
	}
    @catch (EDAMUserException *exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login failed"
                                                            message:@"Please try again"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView autorelease];
    }
	@catch (NSException *exception) {
		NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
	}
}



@end
