//
//  ProjectAppDelegate.h
//  Project
//
//  Created by Brandon Ng on 10/04/22.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface ProjectAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *_window;
    UINavigationController *_navigationController;
}

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain) IBOutlet UIWindow *window;

- (void)switchView:(UIViewController*)view;
- (void)popView;

@end

