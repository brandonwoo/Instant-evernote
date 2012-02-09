//
//  LoginViewController.h
//
//  Created by Brandon Ng on 10/04/27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController {
	UITextField *_username;
	UITextField *_password;
}

@property(nonatomic,retain) IBOutlet UITextField *username;
@property(nonatomic,retain) IBOutlet UITextField *password;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (void)login:(id)sender;
- (void)login;


@end
