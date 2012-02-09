//
//  LoginViewController.m
//
//  Created by Brandon Ng on 10/04/27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EvernoteRequest.h"
#import "ProjectAppDelegate.h"
#import "Project.h"


@implementation LoginViewController

@synthesize username = _username;
@synthesize password = _password;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [self.username becomeFirstResponder];
    [super viewDidLoad];
}

//hide back button since this should be the first view
- (void)viewDidAppear:(BOOL)animated {
    self.navigationItem.hidesBackButton = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger nextTag = textField.tag + 1;
    if (nextTag == 2) {
        [self login];
        return NO;
    }
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    }
    else{
        [textField resignFirstResponder];
    }
    return YES;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    self.username = nil;
    self.password = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)login {
	NSLog(@"login process reached");
	
	[[Project sharedInstance].evernoteRequest authenticate:self.username.text password:self.password.text];
}

- (void)login:(id)sender {
    [self login];
}

- (void)dealloc {
	[_username dealloc];
	[_password dealloc];
	[super dealloc];
}

@end
