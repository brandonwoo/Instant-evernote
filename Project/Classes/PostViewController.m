//
//  PostViewController.m
//
//  Created by Ng Brandon on 10/05/28.
//  Copyright 2010 Unoh. All rights reserved.
//

#import "PostViewController.h"
#import "Project.h"
#import "ProjectAppDelegate.h"

@implementation PostViewController

@synthesize body = _body;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"Logout"  style:UIBarButtonItemStyleBordered  target:self action:@selector(deleteUser:)];
		self.navigationItem.leftBarButtonItem = backBtn;
        
		UIBarButtonItem *submitBtn = [[UIBarButtonItem alloc] initWithTitle:@"Post"  style:UIBarButtonItemStyleBordered  target:self action:@selector(submit:)];
		self.navigationItem.rightBarButtonItem = submitBtn;
	}
	return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [self.body becomeFirstResponder];
    [super viewDidLoad];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    self.body = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)deleteUser:(id)sender {
	@try {
        [[Project sharedInstance] deleteCurrentUser];
        ProjectAppDelegate *appDelegate = (ProjectAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate popView];
	}
	@catch (NSException *exception) {
		NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
	}
}

- (void)submit:(id)sender {
    [[Project sharedInstance] submitPost:self.body.text];
    self.body.text=@"";
}

- (void)dealloc {
    [_body release];
    [super dealloc];
}


@end
