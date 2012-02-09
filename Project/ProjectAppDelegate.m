//
//  ProjectAppDelegate.m
//  Project
//
//  Created by Brandon Ng on 11/03/12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProjectAppDelegate.h"
#import "Project.h"

@implementation ProjectAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;

#pragma mark -
#pragma mark Application lifecycle

- (id)init {
    self = [super init];
	if (self) {
		//custom initialization
	}
	return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.rootViewController = self.navigationController;
	return [[Project sharedInstance] initApp];
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)switchView:(UIViewController *)view {
	[self.navigationController pushViewController:view animated: YES];
}

- (void)popView {
	[self.navigationController popViewControllerAnimated: YES];
}

- (void)dealloc
{
    [_navigationController release];
    [_window release];
    [super dealloc];
}

@end
