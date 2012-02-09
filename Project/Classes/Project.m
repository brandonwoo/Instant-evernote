//
//  Project.m
//  Project
//
//  Created by Brandon Woo on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Project.h"
#import "ProjectAppDelegate.h"

@implementation Project

@synthesize loginViewController = _loginViewController;
@synthesize postViewController = postViewController;
@synthesize evernoteRequest = _evernoteRequest;

@synthesize appConfigData = _appConfigData;

static Project* _shared;
+ (Project*)sharedInstance {
	if( !_shared )
	{
		_shared = [[Project alloc] init];
	}
	
	return _shared;
}

- (id)init {
    self = [super init];
    if (self) {
        _evernoteRequest = [[EvernoteRequest alloc] init];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"];
        _appConfigData = [NSDictionary dictionaryWithContentsOfFile:filePath];
        [_appConfigData retain];
    }
    return self;
}

- (BOOL)initApp {
    BOOL exists = NO;
    
    if ([EvernoteRequest getStoredCredentials]) {
        exists = YES;
    }
    
    ProjectAppDelegate *appDelegate = (ProjectAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	self.loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
	self.postViewController = [[PostViewController alloc] initWithNibName:@"PostViewController" bundle:[NSBundle mainBundle]];
	
	if (exists) { //cached auth user exists
		[appDelegate.navigationController pushViewController:self.loginViewController animated:NO];
		
		[appDelegate.navigationController pushViewController:self.postViewController animated:YES];
        
        appDelegate.navigationController.topViewController.title = @"Post";
	}
	else {
		[appDelegate.navigationController pushViewController:self.loginViewController animated:YES];
		
        appDelegate.navigationController.topViewController.title = @"Login";
	}
	
	[appDelegate.window makeKeyAndVisible];
    
    return YES;
}

- (void)userLogined {
    self.loginViewController.password.text = @"";
    
    ProjectAppDelegate *appDelegate = (ProjectAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate switchView:[Project sharedInstance].postViewController];
}

- (void)submitPost:(NSString *)content {
    SEL mySelector;
    mySelector = @selector(submitPost:);
    NSMethodSignature * sig = nil;
    sig = [[[Project sharedInstance].evernoteRequest class] instanceMethodSignatureForSelector:mySelector];
    
    NSInvocation *myInvocation = nil;
    myInvocation = [NSInvocation invocationWithMethodSignature:sig];
    [myInvocation setTarget:[Project sharedInstance].evernoteRequest];
    [myInvocation setSelector:mySelector];
    [myInvocation setArgument:&content atIndex:2];
    [myInvocation retainArguments];	
    
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithInvocation:myInvocation];
    [queue addOperation:operation]; 
    [operation release];
}

- (void)deleteCurrentUser {
	[EvernoteRequest deleteStoredCredentials];
}

- (NSString *)getConfigValueForKey:(NSString *)key {
    return [self.appConfigData objectForKey:key];
}

- (void)dealloc {
    [_loginViewController release];
    [_postViewController release];
    [_evernoteRequest release];
    [_appConfigData release];
    [super dealloc];
}
@end
